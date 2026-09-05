#!/usr/bin/env python3
"""Batch generate subtitles with faster-whisper, isolated timeout per file."""
import argparse
import os
import pathlib
import subprocess
import sys
import tempfile


def transcribe_with_timeout(mp4_path, srt_path, lang, model, fmt, timeout, venv_python):
    # inner code runs in isolated process to allow timeout to kill C++ hangs
    ext = srt_path.suffix.lower()
    is_vtt = ext == ".vtt"
    code = f"""
from faster_whisper import WhisperModel
from pathlib import Path
def fmt_srt(t):
    h=int(t//3600); m=int((t%3600)//60); s=int(t%60); ms=int((t-int(t))*1000)
    return f"{{h:02}}:{{m:02}}:{{s:02}},{{ms:03}}"
def fmt_vtt(t):
    h=int(t//3600); m=int((t%3600)//60); s=int(t%60); ms=int((t-int(t))*1000)
    return f"{{h:02}}:{{m:02}}:{{s:02}}.{{ms:03}}"
model = WhisperModel("{model}", device="cpu", compute_type="int8", cpu_threads=1)
segments, info = model.transcribe(r"{mp4_path}", language="{lang}" if "{lang}" != "auto" else None, beam_size=1)
tmp = Path(r"{srt_path}.tmp")
with open(tmp, "w", encoding="utf-8") as f:
    if {str(is_vtt)}:
        f.write("WEBVTT\\n\\n")
    for i, seg in enumerate(segments, 1):
        if {str(is_vtt)}:
            f.write(f"{{fmt_vtt(seg.start)}} --> {{fmt_vtt(seg.end)}}\\n")
        else:
            f.write(f"{{i}}\\n")
            f.write(f"{{fmt_srt(seg.start)}} --> {{fmt_srt(seg.end)}}\\n")
        f.write(f"{{seg.text.strip()}}\\n\\n")
tmp.rename(r"{srt_path}")
print(f"done {{info.language}} {{info.language_probability:.2f}}")
"""
    with tempfile.NamedTemporaryFile(mode="w", suffix=".py", delete=False) as tf:
        tf.write(code)
        tf_path = tf.name
    try:
        result = subprocess.run(
            ["timeout", str(timeout), venv_python, tf_path],
            capture_output=True, text=True, timeout=timeout + 10,
        )
        return result
    finally:
        try:
            os.unlink(tf_path)
        except:
            pass


def main():
    p = argparse.ArgumentParser(description="Generate subtitles for video folder")
    p.add_argument("folder", help="Folder containing mp4/mkv videos")
    p.add_argument("--lang", default="en", help="Language code or auto (default: en)")
    p.add_argument("--format", choices=["srt", "vtt"], default="srt", help="Output format")
    p.add_argument("--model", default="small", help="Whisper model: tiny/base/small/medium/large-v3")
    p.add_argument("--timeout", type=int, default=1200, help="Per-file timeout seconds (default: 1200)")
    p.add_argument("--venv", default=str(pathlib.Path.home() / ".local/share/fw-venv/bin/python"), help="Path to fw-venv python")
    args = p.parse_args()

    folder = pathlib.Path(args.folder)
    if not folder.is_dir():
        print(f"not a directory: {folder}", file=sys.stderr)
        sys.exit(1)

    venv_python = args.venv
    if not pathlib.Path(venv_python).exists():
        print(f"venv python not found: {venv_python} — run: uv venv {pathlib.Path(venv_python).parent.parent} --seed && {pathlib.Path(venv_python).parent / 'pip'} install -q faster-whisper", file=sys.stderr)
        sys.exit(1)

    # support mp4, mkv, mov, avi, webm
    exts = ["*.mp4", "*.mkv", "*.mov", "*.avi", "*.webm", "*.m4v"]
    mp4s = []
    for ext in exts:
        mp4s.extend(folder.glob(ext))
        mp4s.extend(folder.glob(ext.upper()))
    mp4s = sorted(mp4s)
    print(f"found {len(mp4s)} videos in {folder}", flush=True)
    if not mp4s:
        return

    suffix = f".{args.format}"
    for vid in mp4s:
        srt = vid.with_suffix(suffix)
        if srt.exists() and srt.stat().st_size > 0:
            print(f"skip {vid.name}", flush=True)
            continue
        failed = pathlib.Path(str(srt) + ".failed")
        if failed.exists():
            failed.unlink()
        tmp = pathlib.Path(str(srt) + ".tmp")
        if tmp.exists():
            tmp.unlink()
        print(f"-> {vid.name}", flush=True)
        result = transcribe_with_timeout(str(vid), str(srt), args.lang, args.model, args.format, args.timeout, venv_python)
        if result.returncode == 0:
            print(f"  done", flush=True)
            if result.stdout:
                print(f"  {result.stdout.strip()[:120]}", flush=True)
        elif result.returncode == 124:
            print(f"  TIMEOUT {args.timeout}s {vid.name}", flush=True)
            with open(str(srt) + ".failed", "w") as f:
                f.write(f"timeout{args.timeout}\n")
            if tmp.exists():
                tmp.unlink()
        else:
            print(f"  FAIL {vid.name} code={result.returncode} err={result.stderr[:400]}", flush=True)
            if tmp.exists():
                try:
                    tmp.unlink()
                except:
                    pass
            # create placeholder for corrupted that will be retried next run via file check
            # leave no srt so next run retries

if __name__ == "__main__":
    main()

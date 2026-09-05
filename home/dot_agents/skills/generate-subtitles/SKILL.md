---
name: generate-subtitles
description: Generate SRT/VTT subtitles for local video folders using faster-whisper (small/base) on CPU. Use when user mentions subtitles, transcribing videos, whisper, srt/vtt generation, omarchy video tools, or batch transcription of mp4/mkv folders.
---

# Generate Subtitles

Batch transcription for local video courses. Omarchy has no built-in subtitle tool — uses `faster-whisper` (CTranslate2) via isolated `uv` venv, `ffmpeg` already present. Reuses `~/.local/share/fw-venv`, `small` model, `en` default, sidecar `.srt` output.

## Quick start

```bash
# install once (Arch/Omarchy, no system pip needed)
uv venv ~/.local/share/fw-venv --seed
~/.local/share/fw-venv/bin/pip install -q faster-whisper
# single folder, english, srt, small
~/.local/share/fw-venv/bin/python -u scripts/generate.py "/path/to/videos" --lang en --format srt --model small
# mpv/vlc auto-loads sidecar
mpv "/path/to/videos/01. Intro.mp4"
```

## Workflows

### 1. Pre-checks (always)
- [ ] `ls "$FOLDER"/*.mp4 | wc -l` vs `*.srt` — count expected
- [ ] `du -sh "$FOLDER"` + `df -h` — 300MB model + ~1KB per srt, ensure 10GB free
- [ ] `ffmpeg -version` + `uv --version` present (Omarchy provides both)
- [ ] `ls ~/.local/share/fw-venv/bin/python` or create venv
- [ ] Check not already transcoding: `ls *.srt.tmp` should be empty

### 2. Batch transcribe
```bash
python -u scripts/generate.py "$FOLDER" --lang en --format srt --model small --timeout 1200
```
- Isolated per-file `timeout` process (kills C++ hangs, SIGALRM doesn't work for ctranslate2)
- `device=cpu compute_type=int8 cpu_threads=1 beam_size=1` — stable on i5/GTX1050, avoids `libcublas.so.12` missing
- Skips `*.srt` with `size>0`, resumes interrupted runs
- 600s enough for <400s videos, 1200s for 500-650s (e.g. 39. Lighthouse 637s). Use 1200 default.

### 3. Post-checks
- [ ] `ls *.srt | wc -l` == `ls *.mp4 | wc -l` and `find . -name "*.srt" -size 0 | wc -l` == 0 (except placeholder for corrupted)
- [ ] `find . -name "*.srt.tmp" -o -name "*.failed"` == 0
- [ ] `head -n 10 "01. Intro.srt"` shows `00:00:00,000 -->`
- [ ] `ffprobe -show_streams` for any 0-byte srt — corrupted source (Invalid NAL) needs re-download

## Advanced

- **Corrupted mp4** (e.g. `92. Context Switching 2280K.mp4` 26M with `Invalid NAL unit size`): ffmpeg extracts 78B wav → no audio. Create placeholder srt and re-download source. See [REFERENCE.md](REFERENCE.md).
- **Burn-in**: `ffmpeg -i in.mp4 -vf subtitles=in.srt -c:a copy out.mp4`
- **VTT**: `--format vtt` or `ffmpeg -i in.srt out.vtt`
- **GPU**: `--device cuda` only if `pacman -S cuda && nvidia-smi` shows free VRAM, else cpu fallback
- **Other models**: `tiny`/`base` 2x faster for long courses, `medium`/`large-v3` slower but more accurate. See [REFERENCE.md](REFERENCE.md)


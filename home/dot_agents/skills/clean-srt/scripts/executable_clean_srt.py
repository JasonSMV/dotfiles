#!/usr/bin/env python3
"""clean_srt.py — strip SRT timestamps/numbers → plain txt per file for LLM context."""
import re
import sys
from pathlib import Path

SRC = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path(__file__).parent.resolve()
DST = SRC / "cleaned_txt"

TIMESTAMP_RE = re.compile(r"\d{2}:\d{2}:\d{2},\d{3}\s*-->\s*\d{2}:\d{2}:\d{2},\d{3}")
TAG_RE = re.compile(r"<[^>]+>")
NUM_RE = re.compile(r"^\d+$")

def clean_srt_text(path: Path) -> str:
    parts: list[str] = []
    prev = None
    for raw in path.read_text(encoding="utf-8", errors="ignore").splitlines():
        line = raw.strip()
        if not line:
            continue
        if NUM_RE.match(line):
            continue
        if TIMESTAMP_RE.search(line):
            continue
        # strip html tags
        line = TAG_RE.sub("", line).strip()
        # collapse internal whitespace
        line = re.sub(r"\s+", " ", line)
        if not line:
            continue
        # dedup consecutive identical cues
        if line == prev:
            continue
        prev = line
        parts.append(line)
    # join cues with space → flowing paragraph(s)
    text = " ".join(parts)
    # final whitespace normalize
    text = re.sub(r"\s+", " ", text).strip()
    return text

def main():
    DST.mkdir(exist_ok=True)
    srts = sorted(SRC.glob("*.srt"))
    if not srts:
        print("No .srt files in", SRC)
        return
    count = 0
    for srt in srts:
        text = clean_srt_text(srt)
        out = DST / (srt.stem + ".txt")
        out.write_text(text + "\n", encoding="utf-8")
        count += 1
        print(f"✓ {srt.name} → {out.relative_to(SRC)} ({len(text)} chars, {len(text.split())} words)")
    print(f"\nDone: {count} files → {DST}/")

if __name__ == "__main__":
    main()

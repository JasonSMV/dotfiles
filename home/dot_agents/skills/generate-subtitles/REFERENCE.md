# Reference — generate-subtitles

## Why this stack

Omarchy bins (`/usr/share/omarchy/bin`) have no subtitle generator. `ffmpeg` + `yt-dlp` are present, `whisper` not. `faster-whisper` beats `openai-whisper` 4x on CPU via CTranslate2, needs no API key, runs offline. `whisper.cpp` similar but needs compile. Cloud Whisper API costs + upload 1GB+ — skip unless accuracy gap proven.

## Hardware notes (this machine: i5-8300H, UHD630, GTX 1050 4GB, driver 580/CUDA13)

- `device=auto` tries cuda → fails `libcublas.so.12 not found` without `cuda` pacman package. Use `device=cpu`.
- `cpu_threads=1` stable; `4` hung on `16. Pattern Matching...` (beam5) due to threading deadlock. `beam_size=1` vs 5: ~30% faster, minor accuracy loss for lecture English.
- `compute_type=int8` for cpu, `float16` for cuda.

## Durations vs timeout

| File | Size | Duration | Transcribe (small/int8/cpu1) | Timeout needed |
|------|------|----------|------------------------------|----------------|
| 35 Documentation | 445K | 540s | ~1080s | 1200 |
| 36 Implementation | 780K | 572s | ~900s | 1200 |
| 39 Lighthouse | 993K | 637s | ~240s | 600+ |
| 92 Context Switching | 2280K | 138s | corrupted (0) | — |
| short 15-20 | 300K | 180s | 30-60s | 600 |

Long videos need 1200s (20m) default, not 180s/600s. Signal `alarm(180)` doesn't interrupt C++ ctranslate2 — use `timeout` subprocess per file.

## Model selection

- `tiny` ~39M, fastest, rough lecture ok
- `base` ~74M, 2x faster than small, good tradeoff for 101-file courses
- `small` ~244M, balanced (used here), ~1h for 101 files on i5
- `medium` ~769M, slower, better for accented speech
- `large-v3` ~1550M, slowest, best accuracy, needs 6000s+ total

## Script behavior

`scripts/generate.py`:
- Iterates `sorted(folder.glob("*.mp4"))` — alphabetical, not numeric
- Skips if `srt.exists() and size>0` — resumes. Cleans `*.srt.tmp` before each file, deletes `*.failed` on retry.
- Per-file isolated `timeout <sec> python tmp.py` — loads model per file (2s overhead) but isolates hangs and allows `kill -9`.
- Writes `tmp.srt.tmp` then `rename` — avoids 0-byte srt on crash (previous bug).
- On `124` (timeout) writes `*.srt.failed` marker; on success deletes marker.
- Corrupted handling: if `srt` stays 0 after retries, leave placeholder with message.

## Troubleshooting

- `0-byte srt` → check `ffprobe -v error -show_streams` and `ffmpeg -vn -c:a pcm_s16le` — if 78B wav, file corrupted, re-download.
- `resource_tracker: leaked semaphore` → kill stale `fw-venv` python (`kill -9 <pid>` from `ps` or `for d in /proc/[0-9]*; do readlink $d/exe; done`) then restart.
- `/tmp` wiped → venv at `~/.local/share/fw-venv` persists, but `/tmp/fw.log` lost. Use `~/fw2.log`.
- `Invalid NAL unit size` → video stream corrupted, but audio may still be extractable via `ffmpeg -c:v copy` first.

## Example commands

```bash
# retry only failed with larger timeout
ls *.srt.failed | while read f; do rm "${f%.failed}.srt"; done  # or keep and script will retry
python -u scripts/generate.py "$FOLDER" --timeout 1200

# check all
ls *.mp4 | wc -l; ls *.srt | wc -l; find . -name "*.srt" -size 0
head -n 20 "01. Intro.srt"
```


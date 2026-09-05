---
name: clean-srt
description: Strip SRT timestamps, indices and tags into plain joined txt per file for LLM context. Use when user mentions cleaning srt, srt to txt, subtitle to plain text, removing timestamps, preparing transcripts for AI.
---

# Clean SRT

Batch-clean `.srt` sidecars into token-efficient `.txt` for LLM context. Flat `*.srt` → `cleaned_txt/*.txt`, joined paragraphs, no timestamps.

## Quick start

```bash
# from folder containing *.srt
python3 clean_srt.py
# or via skill script
python3 ~/.agents/skills/clean-srt/scripts/clean_srt.py /path/to/videos
ls cleaned_txt/*.txt | wc -l  # == ls *.srt | wc -l
head -c 300 cleaned_txt/*.txt
```

## Workflows

### 1. Pre-checks (always)
- [ ] `ls *.srt | wc -l` expected count
- [ ] `head -n 5 *.srt` shows `00:00:00,000 -->` (valid SRT)
- [ ] `ls cleaned_txt` exists? will be created, existing `.txt` overwritten
- [ ] Script present: `ls clean_srt.py` or `ls ~/.agents/skills/clean-srt/scripts/clean_srt.py`

### 2. Clean

```bash
# local copy (project folder)
python3 clean_srt.py
# explicit path
python3 ~/.agents/skills/clean-srt/scripts/clean_srt.py /path/to/folder
# flat only, non-recursive by design
```

Behavior:
- Skips lines matching `^\d+$` and `00:00:00,000 --> 00:00:00,000`
- Strips `<i>`/`</i>` etc via `<[^>]+>`
- Collapses `\s+` → single space, trims
- Dedups consecutive identical cues
- Joins all cues with single space → one paragraph + trailing `\n`
- Output: `cleaned_txt/<stem>.txt` UTF-8

### 3. Post-checks
- [ ] `ls *.srt | wc -l` == `ls cleaned_txt/*.txt | wc -l`
- [ ] `grep -l "-->" cleaned_txt/*.txt | wc -l` == 0 (no timestamps leaked)
- [ ] `grep -l "^[0-9]*$" cleaned_txt/*.txt | wc -l` == 0 (no indices)
- [ ] `wc -w cleaned_txt/*.txt` — spot-check word count

## Advanced

- **Recursive needed?** Replace `SRC.glob("*.srt")` with `SRC.rglob("*.srt")` and mirror tree under `cleaned_txt/`.
- **One line per cue?** Change `" ".join(parts)` → `"\n".join(parts)` in `scripts/clean_srt.py:26`.
- **Keep tags?** Remove `TAG_RE` line.
- **Other input folder:** `python3 scripts/clean_srt.py /other/path` — `SRC` is argv[1] if given.

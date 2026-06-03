# Package Restore

All installed applications backed up via UniGetUI's **automatic backup** feature.

## Backup location

| Location | URL / Path |
|----------|-----------|
| **GitHub Gist (cloud, auto-synced)** | https://gist.github.com/JasonSMV/8eaa284d0ba17aec06d61e3f2e573e0d |
| **Local backup** | `C:\Users\devje\Documents\UniGetUI\JEISON installed packages.ubundle` |

UniGetUI auto-syncs the `.ubundle` to the Gist on a schedule. No manual export needed.

## Current package count (last export)

| Manager | Count |
|---------|-------|
| winget | 96 |
| chocolatey | 7 |
| scoop | 7 |
| npm (global) | 4 |
| cargo | 2 |
| winps (PowerShell) | 2 |
| dotnet-tool | 1 |
| pip | 1 |
| pwsh | 1 |
| **Total** | **121** |

## File format

`.ubundle` = JSON, UniGetUI's native format (`export_version: 3`).
Captures all managers — richer than `winget export` which only covers winget.

## How to restore on new machine

### Step 1 — Install UniGetUI first

```powershell
winget install Devolutions.UniGetUI --accept-package-agreements --accept-source-agreements
```

### Step 2 — Connect Gist backup (preferred)

1. Open UniGetUI
2. **Settings** → **Backup and Restore** → enter Gist URL or token
3. UniGetUI will pull the bundle and offer to restore

### Step 3 — OR restore manually from file

1. Download `.ubundle` from the Gist, or copy from `Documents\UniGetUI\`
2. Open UniGetUI → **Software** tab → `⋯` → **"Import packages"**
3. Select the `.ubundle` file
4. Review list → **Install selected**
5. Allow 20–60 min depending on package count

### Step 4 — Handle failures

UniGetUI shows failed installs. For those:
- Re-run import (select only failed ones)
- Or install manually: `winget install <Id>`

## Scoop buckets (add before restoring scoop packages)

```powershell
scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add versions
```

## Gotchas

- Apps needing license activation (JetBrains, etc.) — install via bundle, activate after
- `npm` global packages restore only works if Node is installed first
- `cargo` packages need Rust toolchain installed first
- `pip` packages need Python installed first
- App settings/configs are handled by chezmoi — this only restores the executables

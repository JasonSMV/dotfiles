# Dotfiles

My dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Quick Start — New Windows Machine

### Prerequisites (install manually first)

1. **Git**: `winget install Git.Git`
2. **chezmoi**: `winget install twpayne.chezmoi`

### Apply dotfiles

```powershell
# Clone and apply in one step
chezmoi init https://github.com/JasonSMV/dotfiles.git
chezmoi apply
```

> chezmoi will automatically skip Linux-only configs (komorebi, yasb, whkdrc, glazewm)
> when running on non-Windows via `.chezmoiignore` templates.

---

## Daily Usage

```powershell
# Add a new file
chezmoi add ~\.config\someapp\config.json

# Edit a managed file
chezmoi edit ~\.config\someapp\config.json

# Check what has drifted
chezmoi status

# Preview changes without applying
chezmoi diff

# Apply all changes
chezmoi apply

# Pull latest from repo and apply
chezmoi update
```

## Committing Changes

```powershell
cd (chezmoi source-path)
git add .
git commit -m "chore: update config"
git push
```

---

## Cross-Platform Configuration

Git config uses chezmoi templates to support Windows and Linux from same source:

- **Windows**: `~\.gitconfig` (from `dot_gitconfig.tmpl`)
- **Linux**: `~/.config/git/config` (from `dot_config/git/config.tmpl`)

Common settings live in `.chezmoitemplates/gitconfig` — edit there for changes on all platforms.

## Manual Configs (not auto-deployed)

See `manual-configs/` for setup guides that require manual steps:
- AltSnap, ExplorerPatcher, FlowLauncher, Nilesoft Shell, Windhawk, Thide

# New Machine Setup Guide

Complete ordered checklist to restore dev environment from scratch on a new Windows machine.

---

## Before you start

- [ ] New machine has internet access
- [ ] You have access to GitHub (JasonSMV account)
- [ ] You have the UniGetUI Gist URL: https://gist.github.com/JasonSMV/8eaa284d0ba17aec06d61e3f2e573e0d
- [ ] You have your Azure DevOps PAT for npm (NOT in dotfiles — stored separately)

Estimated total time: **1–3 hours** (mostly waiting for installs)

---

## Stage 1: Bootstrap (manual, no tools yet)

These MUST be installed before anything else. Open **PowerShell as Administrator**.

```powershell
# 1. Git
winget install Git.Git --accept-package-agreements --accept-source-agreements

# 2. chezmoi
winget install twpayne.chezmoi --accept-package-agreements --accept-source-agreements

# 3. UniGetUI
winget install Devolutions.UniGetUI --accept-package-agreements --accept-source-agreements
```

**Verification:**
```powershell
git --version        # should print git version
chezmoi --version    # should print chezmoi version
# UniGetUI: check Start menu
```

> ⚠️ Restart PowerShell after this step so PATH is refreshed.

---

## Stage 2: Apply dotfiles via chezmoi

```powershell
# Clone repo and apply all dotfiles in one command
chezmoi init https://github.com/JasonSMV/dotfiles.git
chezmoi apply
```

**What this restores automatically:**

| Config | Target path |
|--------|-------------|
| Git config | `~\.gitconfig` |
| Git shared config | `~\.config\git\` |
| PowerShell profile | `~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` |
| Windows Terminal | `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json` |
| VS Code settings | `%APPDATA%\Code\User\settings.json` |
| Claude Code config | `~\.claude\CLAUDE.md`, `settings.json`, `RTK.md` |
| OpenCode config | `%APPDATA%\opencode\` and `~\.config\opencode\` |
| GlazeWM | `~\.glzr\glazewm\config.yaml` |
| YASB | `~\.config\yasb\` |
| fastfetch | `~\.config\fastfetch\` |
| mpv | `~\.config\mpv\` |
| IdeaVim | `~\.ideavimrc` |

**Verification:**
```powershell
chezmoi status   # should be empty (no output = all clean)
chezmoi diff     # should be empty
```

> ⚠️ If chezmoi prompts about existing files — choose **overwrite**. Those are Windows defaults, not your config.

---

## Stage 3: Restore all applications via UniGetUI

1. Open UniGetUI
2. **Settings** → **Backup and Restore** → connect your Gist token  
   OR: **Software** tab → `⋯` → **Import packages** → paste Gist URL or use local `.ubundle`
3. Review the 121 packages → click **Install selected**
4. Walk away. This takes 20-60 min.

**If scoop packages fail** — add buckets first:
```powershell
# Install scoop first if not already
irm get.scoop.sh | iex

scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add versions
```
Then re-run the UniGetUI import for scoop packages.

**Verification:**
```powershell
winget list | Measure-Object   # count installed winget packages
```

---

## Stage 4: Restore .npmrc (Azure DevOps feed)

> ⚠️ This is NOT in dotfiles — contains a PAT token. Recreate manually.

```powershell
# Get a fresh PAT from https://dev.azure.com/trip-arc → User settings → PATs
# Scope needed: Packaging (read)

# Then run the Azure DevOps npm auth command:
$pat = "YOUR_NEW_PAT_HERE"
$b64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$pat"))

@"
//pkgs.dev.azure.com/trip-arc/_packaging/trip-arc/npm/registry/:username=VssSessionToken
//pkgs.dev.azure.com/trip-arc/_packaging/trip-arc/npm/registry/:_password=$b64
//pkgs.dev.azure.com/trip-arc/_packaging/trip-arc/npm/registry/:email=not-used@example.com
registry=https://registry.npmjs.org/
"@ | Set-Content "$env:USERPROFILE\.npmrc"
```

**Verification:**
```powershell
npm whoami --registry https://pkgs.dev.azure.com/trip-arc/_packaging/trip-arc/npm/registry/
```

---

## Stage 5: SSH keys

SSH keys are NOT in dotfiles (private key must never be committed).

**Option A — Copy from old machine:**
```powershell
# On OLD machine: copy to USB or secure transfer
Copy-Item "$env:USERPROFILE\.ssh" "D:\ssh-backup" -Recurse

# On NEW machine:
New-Item -ItemType Directory "$env:USERPROFILE\.ssh" -Force
Copy-Item "D:\ssh-backup\*" "$env:USERPROFILE\.ssh\"
icacls "$env:USERPROFILE\.ssh\id_rsa" /inheritance:r /grant:r "$env:USERNAME:R"
```

**Option B — Generate new keys:**
```powershell
ssh-keygen -t ed25519 -C "jeison.martinez@trip-arc.com"
# Then add public key to GitHub + Azure DevOps
cat "$env:USERPROFILE\.ssh\id_ed25519.pub"
```

**Verification:**
```powershell
ssh -T git@github.com   # should say "Hi JasonSMV!"
```

---

## Stage 6: OpenCode plugins and packages

```powershell
# Install OpenCode (if not already in UniGetUI bundle)
winget install opencode --accept-package-agreements --accept-source-agreements

# The config is already restored by chezmoi (Stage 2)
# But plugins need to be installed fresh:
cd "$env:USERPROFILE\.config\opencode"
npm install   # or bun install if you use bun
```

**Verification:**
```powershell
opencode --version
```

---

## Stage 7: Windows-specific manual steps

These cannot be automated. Do each one manually.

### 7a. Windows Terminal
Already restored by chezmoi. Verify profiles look correct — open Windows Terminal settings.

### 7b. VS Code extensions
```powershell
# On OLD machine — export extension list
code --list-extensions > "$env:USERPROFILE\vscode-extensions.txt"

# On NEW machine — install all
Get-Content "$env:USERPROFILE\vscode-extensions.txt" | ForEach-Object { code --install-extension $_ }
```
> Store `vscode-extensions.txt` in chezmoi if you want: `chezmoi add ~/vscode-extensions.txt`

### 7c. Manual configs (from dotfiles `manual-configs/` folder)
See `manual-configs/` in the dotfiles repo. Each subdirectory has a `README.md` with setup steps for:
- AltSnap
- ExplorerPatcher
- FlowLauncher
- Nilesoft Shell
- Windhawk
- Thide
- Task Scheduler configs

### 7d. GlazeWM autostart
```powershell
# These need to be set up as startup tasks
# See manual-configs/Task-Scheduler-Configs/README.md
```

### 7e. Windows Settings
See `manual-configs/Windows-Settings/README.md` for documented tweaks (performance, transparency, etc.)

---

## Stage 8: Final verification checklist

Run these to confirm everything is working:

```powershell
# Dotfiles clean
chezmoi status

# Git identity correct
git config --global user.email
git config --global user.name

# PowerShell profile loaded
$PROFILE | Test-Path
. $PROFILE   # reload profile, check for errors

# SSH
ssh -T git@github.com

# npm Azure feed
npm whoami --registry https://pkgs.dev.azure.com/trip-arc/_packaging/trip-arc/npm/registry/

# OpenCode
opencode --version

# chezmoi version
chezmoi --version
```

---

## Gotchas & Windows-specific warnings

| Issue | Solution |
|-------|----------|
| chezmoi applies but PowerShell profile errors | Run `. $PROFILE` to see exact error; often a missing module |
| Windows Terminal settings don't apply | App may need to be installed first before chezmoi can write to the path |
| OpenCode config missing after apply | The `%APPDATA%\opencode` path requires OpenCode to be installed first |
| VS Code settings overwritten by sync | Disable Settings Sync in VS Code, then re-apply chezmoi |
| Scoop packages fail | Add buckets first (see Stage 3) |
| GlazeWM doesn't start | Requires Task Scheduler setup (see manual-configs) |
| `.npmrc` auth fails | PAT may have expired — generate new one in Azure DevOps |
| chezmoi prompts on apply | Use `chezmoi apply --force` to skip interactive prompts |

---

## Keeping dotfiles in sync (ongoing)

```powershell
# Check for drift anytime
chezmoi status

# Re-add a file you edited directly
chezmoi re-add ~/.config/someapp/config

# Pull latest dotfiles from GitHub
chezmoi update

# Push your changes
cd (chezmoi source-path)
git add -A
git commit -m "chore: update configs"
git push
```

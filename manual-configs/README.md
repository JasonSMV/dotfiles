# Windows-Dots

> [!NOTE]
> 1. Make sure to go through this readme entirely for a complete setup. Pick only what you like.
> 2. `$USER` means your Windows username.
> 3. If `$PROFILE` does not exist, create it with `New-Item -Path $PROFILE -Type File -Force`.
> 4. If script execution is blocked, run `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine`.
> 5. This folder is only for manual setup notes/screenshots/exports. Dotfiles already tracked by chezmoi are not duplicated here.

### Tools Used:

- [komorebi](https://github.com/LGUG2Z/komorebi) - Tiling window manager for Windows with workspace and monitor control.
- [whkd](https://github.com/LGUG2Z/whkd) - Hotkey daemon used to control komorebi actions.
- [GlazeWM](https://github.com/glzr-io/glazewm) - i3-like tiling manager for Windows (alternative setup path).
- [Yet Another Status Bar (YASB)](https://github.com/amnweb/yasb) - Python status bar with widgets and runtime customization.
- [Flow Launcher](https://github.com/Flow-Launcher/Flow.Launcher) - Fast launcher and plugin system for apps, files, and web.
- [Nilesoft Shell](https://github.com/moudey/Shell) - Context menu customization tool with scriptable options.
- [ExplorerPatcher](https://github.com/valinet/ExplorerPatcher) - Taskbar and Explorer behavior customization for Windows 10/11.
- [Windhawk](https://github.com/ramensoftware/windhawk) - Windows customization mods with advanced per-app tweaking.
- [Oh My Posh](https://github.com/JanDeDobbeleer/oh-my-posh) - Prompt theming engine for PowerShell.
- [Thide](https://github.com/amnweb/thide) - Lightweight taskbar hider for clean tiling workflows.

---

### Preview:

![PIC 1](Images/Updated-Dots-1.png)

![PIC 2](Images/Updated-Dots-2.png)

![PIC 3](Images/Updated-Dots-3.png)

![PIC 4](Images/Updated-Dots-4.png)

![PIC 5](Images/Updated-Dots-5.png)

---

### Rice Setup Guide

#### Managed by chezmoi (no duplicate in this folder)

- Komorebi files: `komorebi.json`, `komorebi.bar.json`, `komorebi.bar.monitor2.json`
- whkd file: `dot_config/whkdrc`
- YASB files: `dot_config/yasb/config.yaml`, `dot_config/yasb/styles.css`
- GlazeWM files: `dot_glzr/glazewm/config.yaml`, `dot_glzr/glazewm/README.md`

---

#### ExplorerPatcher

Import/manual notes: `manual-configs/ExplorerPatcher/README.md`

---

#### Flow Launcher

Manual plugin/theme setup notes: `manual-configs/FlowLauncher/README.md`

---

#### Nilesoft Shell

Manual setup notes: `manual-configs/Nilesoft-Shell/README.md`

---

#### Thide

Manual setup notes: `manual-configs/Thide/README.md`

---

#### Task Scheduler

Task import flow and XML export notes: `manual-configs/Task-Scheduler-Configs/README.md`

---

#### Windows Settings

System UI checklist and screenshots: `manual-configs/Windows-Settings/README.md`

---

#### Windhawk

Mods list and manual tuning notes: `manual-configs/Windhawk/README.md`

---

#### YASB

Manual runtime notes and environment reminders: `manual-configs/YASB/README.md`

# GlazeWM Configuration

This directory contains my personal GlazeWM configuration for Windows tiling window management.

## Overview

- **Modifier Key**: `F13` (mapped as the main modifier for all shortcuts)
- **Monitor Setup**: 2 monitors
  - Monitor 0: Workspace 1 (Chats)
  - Monitor 1: Workspaces 2-3 (Browser, Code)
- **Startup**: Automatically launches `gat-gwm` and `yasb` on boot
- **Gaps**: 10px inner gap, 6px outer gap

---

## Quick Reference

| Action | Shortcut |
|--------|----------|
| Focus window left | `F13 + H` / `F13 + Left` |
| Focus window right | `F13 + L` / `F13 + Right` |
| Focus window up | `F13 + K` / `F13 + Up` |
| Focus window down | `F13 + J` / `F13 + Down` |
| Move window left | `F13 + Shift + H` |
| Move window right | `F13 + Shift + L` |
| Move window up | `F13 + Shift + K` |
| Move window down | `F13 + Shift + J` |

---

## Workspace Shortcuts

### Focus Workspace

| Workspace | Shortcut |
|-----------|----------|
| Workspace 1 (Chats) | `F13 + 1` |
| Workspace 2 (Browser) | `F13 + 2` |
| Workspace 3 (Code) | `F13 + 3` |
| Workspace 4 | `F13 + 4` |
| Workspace 5 | `F13 + 5` |
| Workspace 6 | `F13 + 6` |
| Workspace 7 | `F13 + 7` |
| Workspace 8 | `F13 + 8` |
| Workspace 9 | `F13 + 9` |

### Move Window to Workspace

| Workspace | Shortcut |
|-----------|----------|
| Move to WS 1 | `F13 + Shift + 1` |
| Move to WS 2 | `F13 + Shift + 2` |
| Move to WS 3 | `F13 + Shift + 3` |
| Move to WS 4 | `F13 + Shift + 4` |
| Move to WS 5 | `F13 + Shift + 5` |
| Move to WS 6 | `F13 + Shift + 6` |
| Move to WS 7 | `F13 + Shift + 7` |
| Move to WS 8 | `F13 + Shift + 8` |
| Move to WS 9 | `F13 + Shift + 9` |

### Cycle Workspaces

| Action | Shortcut |
|--------|----------|
| Focus next active workspace | `F13 + S` / `F13 + Tab` |
| Focus previous active workspace | `F13 + A` / `F13 + Shift + Tab` |
| Focus last workspace | `F13 + Ctrl + Tab` |

### Move Workspace Between Monitors

| Action | Shortcut |
|--------|----------|
| Move workspace left | `F13 + Shift + Ctrl + Left` / `F13 + Shift + Ctrl + H` |
| Move workspace right | `F13 + Shift + Ctrl + Right` / `F13 + Shift + Ctrl + L` |

---

## Window States

| Action | Shortcut |
|--------|----------|
| Toggle floating (centered) | `F13 + Shift + Space` |
| Toggle tiling | `F13 + T` |
| Toggle fullscreen | `F13 + F` |
| Toggle minimized | `F13 + M` |
| Cycle focus (tiling -> floating -> fullscreen) | `F13 + Space` |

---

## Resize Mode

Resize mode allows you to resize windows using arrow keys or HJKL.

1. **Enter resize mode**: `F13 + R`
2. **Resize commands** (while in resize mode):
   - `H` / `Left`: Shrink width 2%
   - `L` / `Right`: Grow width 2%
   - `K` / `Up`: Grow height 2%
   - `J` / `Down`: Shrink height 2%
3. **Exit resize mode**: `Enter` or `Escape`

### Alternative Resize Shortcuts

These work without entering resize mode:

| Action | Shortcut |
|--------|----------|
| Grow width 2% | `F13 + =` |
| Shrink width 2% | `F13 + -` |
| Grow height 2% | `F13 + Shift + =` |
| Shrink height 2% | `F13 + Shift + -` |

---

## Application Launchers

| Application | Shortcut |
|-------------|----------|
| Windows Terminal | `F13 + Enter` |
| Flow Launcher | `F13 + D` |
| Brave Browser | `F13 + B` |
| File Explorer | `F13 + Shift + F` |
| Lock Computer | `F13 + Ctrl + L` |

---

## Quick Actions

| Action | Shortcut |
|--------|----------|
| Close window | `F13 + Q` |
| Reload config | `F13 + Shift + R` |
| Redraw all windows | `F13 + Shift + W` |
| Exit GlazeWM | `F13 + Shift + E` |
| Toggle pause mode | `F13 + Shift + Z` |
| Toggle tiling direction | `F13 + V` |

---

## Window Rules

Certain applications automatically get special treatment:

### Auto-Ignored (Not Managed)
- `zebar`, `yasb` (status bars)
- `Lightshot`, `Greenshot`, `ShareX` (screenshot apps)
- `PowerToys` (including Peek)
- Browser PiP windows

### Auto-Floating
- `explorer`, `cmd`, `regedit`, `mspaint`
- `speedcrunch`, `vlc`, `mpv`
- `Task Manager`, `Settings`, `Snipping Tool`
- Visual Studio dialogs (Rename, Find/Replace, Search)
- JetBrains dotPeek

### Workspace Assignments
- **Workspace 1 (Chats)**: Microsoft Teams, Notion, Outlook
- **Workspace 2 (Browser)**: Firefox, Chrome, Brave, LibreWolf

---

## Keyboard Remapping

This configuration uses **F13** as the modifier key. Since most keyboards don't have an F13 key, the Windows key is remapped to F13 via the Windows Registry.

### Apply Remapping

Save the following as `remap-win-to-f13.reg` and double-click to apply:

```reg
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout]
"Scancode Map"=hex:00,00,00,00,00,00,00,00,02,00,00,00,64,00,5b,e0,00,00,00,00
```

> **Note**: A system restart is required after applying this change.

### Revert Remapping

Save the following as `revert-win-to-f13.reg` and double-click to restore the default Windows key:

```reg
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout]
"Scancode Map"=-
```

> **Note**: A system restart is required after applying this change.

---

## Notes

- **Pause Mode** (`F13 + Shift + Z`): Disables all window management keybindings. Press again to re-enable.
- **Focus follows cursor**: Enabled - windows automatically focus when the cursor moves over them.
- **Cursor jump**: Enabled - cursor jumps to window when focusing.
- **Hide method**: Cloak (recommended, no animation).

---

## Starting GlazeWM and AltSnap at Logon

To automatically start GlazeWM and AltSnap when you log in to Windows, create two scheduled tasks using Task Scheduler.

### Step 1: Open Task Scheduler

1. Press `Win + R`, type `taskschd.msc`, and press Enter
2. In the right panel, click **"Create Task..."** (not "Create Basic Task")

### Step 2: General Settings

1. **Name**: `GlazeWM Startup`
2. **Description**: `Starts GlazeWM with system tray`
3. Check **"Run only when user is logged on"**
4. Check **"Run with highest privileges"**
5. Configure **"Configure for"**: `Windows 10` or `Windows 11`

### Step 3: Triggers Tab

1. Click **"New..."**
2. **Begin the task**: `At log on`
3. **Settings**: `Any user`
4. Click **OK**

### Step 4: Actions Tab

1. Click **"New..."**
2. **Action**: `Start a program`
3. **Program/script**: Click **"Browse..."** and navigate to the GlazeWM executable:
4. **Add arguments**: `--tray`
5. Click **OK**

### Step 5: Create AltSnap Task

Repeat Steps 1-4 with these differences:

- **Name**: `AltSnap Startup`
- **Description**: `Starts AltSnap with system tray`
- **Program/script**: Browse to the AltSnap executable:
- **Add arguments**: `--tray`


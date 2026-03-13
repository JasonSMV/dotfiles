Use this folder for Windhawk mod notes and manual settings.
Some useful mods I found for my Windows workflow

- Alt + Tab per monitor
- Block Win + V - I prefer Flow Launcher clipboard
- Control Panel Color Fix
- CTRL+SHIFT+C Quotes remover - really handy
- Customize Windows Notification Placement
  - Customize Windows Notification Placement - Use the following settings
  - Monitor: 0
  - Horizontal placement: Right
  - Distance from right/left: -8
  - Vertical placement: Top
  - Distance from bottom/top: -22
  - Notification appearance animation: Automatic
- Dark Mode Context Menus
- Dark Mode for Notepad
- Disable rounded corners in Windows 11 - I hate rounded corners with a square monitors so yes 
- Disable Virtual Desktop Transition Animation
- Disable Windows Ink Modifier Tooltips
- F1 Blocker
- Fix white flashes in explorer
- Message Box Fix
- No Focus Rectangle
- Primary Taskbar on Second Monitor
- RegEdit Auto Trim Whitespace
- Select filename extension on double F2
- Show All Apps by Default in Start Menu
- Smart Copy and Paste
- Start Menu open location - Monitor 0
- Start Menu Size - Width: 450 Height: 650
- Taskbar Height and Icon Size
- Taskbar on top
- Taskbar Tray System Icon Tweaks - Toggle everything on
- Turn off change file extension warning
- UXTheme Hook (For Implementing Windows 10 theme for 11. Theme Link: [10ThemesFor11](https://github.com/SandTechStuff/10ThemeFor11))
- Windows 11 Custom Title Bar Colors
- Windows 11 File Explorer Styler - To remove rounded borders (still buggy and yet to fix)
- Windows 11 Notification Center Styler - Use this to change border to square for and `Action Center` and `Toast Notifications`
- Windows 11 Start Menu Styler - To remove rounded borders for it as well 
- Windows 11 Taskbar Styler - To make taskbar transparent and configure border for `Flyouts`

For square corners in other windows elements (Action Center, Flyouts, Start Menu), copy the respective file content from `Windhawk` directory and paste it in Advanced Settings --> Mod Settings in the following mods
- Action Center - Windows 11 Notification Center Styler
- Volume and Brightness Flyouts - Windows 11 Taskbar Styler
- Start Menu and other elements - Windows 11 Start Menu Styler
- File explorer - Windows 11 File Explorer Styler

Changes to be made from some mods
- Customize Windows Notification Placement - Use the following settings
  - Monitor: 0
  - Horizontal placement: Right
  - Distance from right/left: -8
  - Vertical placement: Top
  - Distance from bottom/top: -22
  - Notification appearance animation: Automatic
- Smart Copy and Paste - Toggle the following options enabled
  - Remove Tracking Parameters
  - Auto-trim whitespace
- Taskbar Height and Icon Size - Set taskbar height and all other elements to `-1`. Then use `thide` to completely hide it. This is to ensure taskbar isn't visible anymore at any time.
- Taskbar Tray System Icon Tweaks - Hide everything
- Windows 11 Custom Title Bar Colors - For this make sure to add the following process in exclusion list in Advanced tab
  - notepad.exe
  - Taskmgr.exe
- Windows 11 File Explorer Styler - Set Translucent background effect to `None` to utilize Windows 11 Custom Title Bar Colors mod color.



![Mods](../Images/Windhawk.png)

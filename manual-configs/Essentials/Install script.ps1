Clear-Host
Write-Host ""
Write-Host "========================================================"
Write-Host ""
Write-Host "        __  __      _ ______     __  __  ______" -ForegroundColor Cyan
Write-Host "       / / / /___  (_) ____/__  / /_/ / / /  _/" -ForegroundColor Cyan
Write-Host "      / / / / __ \/ / / __/ _ \/ __/ / / // /" -ForegroundColor Cyan
Write-Host "     / /_/ / / / / / /_/ /  __/ /_/ /_/ // /" -ForegroundColor Cyan
Write-Host "     \____/_/ /_/_/\____/\___/\__/\____/___/" -ForegroundColor Cyan
Write-Host "          UniGetUI Package Installer Script" 
Write-Host "        Created with UniGetUI Version 2026.2.0"
Write-Host ""
Write-Host "========================================================"
Write-Host ""
Write-Host "NOTES:" -ForegroundColor Yellow
Write-Host "  - The install process will not be as reliable as importing a bundle with UniGetUI. Expect issues and errors." -ForegroundColor Yellow
Write-Host "  - Packages will be installed with the install options specified at the time of creation of this script." -ForegroundColor Yellow
Write-Host "  - Error/Sucess detection may not be 100% accurate." -ForegroundColor Yellow
Write-Host "  - Some of the packages may require elevation. Some of them may ask for permission, but others may fail. Consider running this script elevated." -ForegroundColor Yellow
Write-Host "  - You can skip confirmation prompts by running this script with the parameter `/DisablePausePrompts` " -ForegroundColor Yellow
Write-Host ""
Write-Host ""
if ($args[0] -ne "/DisablePausePrompts") { pause }
Write-Host ""
Write-Host "This script will attempt to install the following packages:"
Write-Host "  - Microsoft .NET Windows Desktop Runtime 6.0 from WinGet"
Write-Host "  - Microsoft .NET Native Runtime from WinGet"
Write-Host "  - T3 Code from WinGet"
Write-Host "  - Microsoft Visual Studio Code from WinGet"
Write-Host "  - Chocolatey from Chocolatey"
Write-Host "  - ExplorerPatcher from WinGet"
Write-Host "  - Microsoft .NET Windows Desktop Runtime 5.0 from WinGet"
Write-Host "  - Windows Subsystem for Linux from WinGet"
Write-Host "  - Windows App from WinGet"
Write-Host "  - Fzf from Chocolatey"
Write-Host "  - fastfetch from WinGet"
Write-Host "  - Nilesoft Shell from WinGet"
Write-Host "  - Docker Desktop from WinGet"
Write-Host "  - Microsoft .NET Windows Desktop Runtime 8.0 from WinGet"
Write-Host "  - Microsoft .NET Windows Desktop Runtime 7.0 from WinGet"
Write-Host "  - Azure Cli from Chocolatey"
Write-Host "  - Microsoft .NET Windows Desktop Runtime 3.1 from WinGet"
Write-Host "  - AutoHotkey from WinGet"
Write-Host "  - Microsoft .NET Framework 4.6.2 Developer Pack from WinGet"
Write-Host "  - MongoDB Compass from WinGet"
Write-Host "  - GlazeWM from WinGet"
Write-Host "  - yasb from WinGet"
Write-Host "  - opencode from WinGet"
Write-Host "  - Curl from Scoop"
Write-Host "  - Chrome Remote Desktop Host from WinGet"
Write-Host "  - Windhawk from WinGet"
Write-Host "  - JetBrains Rider from WinGet"
Write-Host "  - lazygit from WinGet"
Write-Host "  - Brave from WinGet"
Write-Host "  - JetBrains Toolbox from WinGet"
Write-Host "  - ShareX from WinGet"
Write-Host "  - Cargo Update from Cargo"
Write-Host "  - Todoist from WinGet"
Write-Host "  - JetBrainsMono Nerd Font from WinGet"
Write-Host "  - Notion from WinGet"
Write-Host "  - Microsoft .NET Windows Desktop Runtime 9.0 from WinGet"
Write-Host "  - Cursor from WinGet"
Write-Host "  - OBS Studio from WinGet"
Write-Host "  - Buzz from WinGet"
Write-Host "  - Flow Launcher from WinGet"
Write-Host "  - Visual Studio Community 2026 from WinGet"
Write-Host "  - AltSnap from WinGet"
Write-Host "  - Git Extensions from WinGet"
Write-Host "  - Cargo Binstall from Cargo"
Write-Host "  - Cloudflare One Client from WinGet"
Write-Host "  - NVM for Windows from WinGet"
Write-Host "  - Google Chrome (EXE) from WinGet"
Write-Host "  - Bitwarden from WinGet"
Write-Host "  - PowerToys from WinGet"
Write-Host "  - Microsoft .NET Windows Desktop Runtime 10.0 from WinGet"
Write-Host "  - Microsoft ASP.NET Core Runtime 5.0 from WinGet"
Write-Host "  - Anki from WinGet"
Write-Host "  - DataGrip from WinGet"
Write-Host "  - GitButler from WinGet"
Write-Host "  - Handy from WinGet"
Write-Host ""
if ($args[0] -ne "/DisablePausePrompts") { pause }
Clear-Host

$success_count=0
$failure_count=0
$commands_run=0
$results=""

$commands= @(
    'cmd.exe /C winget.exe install --id "Microsoft.DotNet.DesktopRuntime.6" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Microsoft.DotNet.Native.Runtime" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "T3Tools.T3Code" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Microsoft.VisualStudioCode" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C choco.exe install chocolatey -y --no-progress',
    'cmd.exe /C winget.exe install --id "valinet.ExplorerPatcher" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Microsoft.DotNet.DesktopRuntime.5" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Microsoft.WSL" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Microsoft.WindowsApp" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C choco.exe install fzf -y --no-progress',
    'cmd.exe /C winget.exe install --id "Fastfetch-cli.Fastfetch" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Nilesoft.Shell" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Docker.DockerDesktop" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Microsoft.DotNet.DesktopRuntime.8" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Microsoft.DotNet.DesktopRuntime.7" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C choco.exe install azure-cli -y --no-progress',
    'cmd.exe /C winget.exe install --id "Microsoft.DotNet.DesktopRuntime.3_1" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "AutoHotkey.AutoHotkey" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Microsoft.DotNet.Framework.DeveloperPack.4.6" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "MongoDB.Compass.Full" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "glzr-io.glazewm" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "AmN.yasb" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "SST.opencode" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C scoop install main/curl',
    'cmd.exe /C winget.exe install --id "Google.ChromeRemoteDesktopHost" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "RamenSoftware.Windhawk" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "JetBrains.Rider" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "JesseDuffield.lazygit" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Brave.Brave" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "JetBrains.Toolbox" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "ShareX.ShareX" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C cargo.exe binstall --version Latest cargo-update --no-confirm',
    'cmd.exe /C winget.exe install --id "Doist.Todoist" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "DEVCOM.JetBrainsMonoNerdFont" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Notion.Notion" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Microsoft.DotNet.DesktopRuntime.9" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Anysphere.Cursor" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "OBSProject.OBSStudio" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "ChidiWilliams.Buzz" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Flow-Launcher.Flow-Launcher" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Microsoft.VisualStudio.Community" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "AltSnap.AltSnap" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "GitExtensionsTeam.GitExtensions" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C cargo.exe binstall --version Latest cargo-binstall --no-confirm',
    'cmd.exe /C winget.exe install --id "Cloudflare.Warp" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "CoreyButler.NVMforWindows" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Google.Chrome.EXE" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Bitwarden.Bitwarden" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Microsoft.PowerToys" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Microsoft.DotNet.DesktopRuntime.10" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Microsoft.DotNet.AspNetCore.5" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "Anki.Anki" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "JetBrains.DataGrip" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "GitButler.GitButler" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force',
    'cmd.exe /C winget.exe install --id "cjpais.Handy" --exact --source winget --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force'
)

foreach ($command in $commands) {
    Write-Host "Running: $command" -ForegroundColor Yellow
    cmd.exe /C $command
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[  OK  ] $command" -ForegroundColor Green
        $success_count++
        $results += "$([char]0x1b)[32m[  OK  ] $command`n"
    }
    else {
        Write-Host "[ FAIL ] $command" -ForegroundColor Red
        $failure_count++
        $results += "$([char]0x1b)[31m[ FAIL ] $command`n"
    }
    $commands_run++
    Write-Host ""
}

Write-Host "========================================================"
Write-Host "                  OPERATION SUMMARY"
Write-Host "========================================================"
Write-Host "Total commands run: $commands_run"
Write-Host "Successful: $success_count"
Write-Host "Failed: $failure_count"
Write-Host ""
Write-Host "Details:"
Write-Host "$results$([char]0x1b)[37m"
Write-Host "========================================================"

if ($failure_count -gt 0) {
    Write-Host "Some commands failed. Please check the log above." -ForegroundColor Yellow
}
else {
    Write-Host "All commands executed successfully!" -ForegroundColor Green
}
Write-Host ""
if ($args[0] -ne "/DisablePausePrompts") { pause }
exit $failure_count
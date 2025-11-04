#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Windows 11 Debloat Script
.DESCRIPTION
    Interactive script to remove bloatware and unnecessary features from Windows 11
.NOTES
    Run as Administrator
    Created: November 2025
#>

# Check if running on Windows
if ($PSVersionTable.Platform -eq 'Unix' -or $PSVersionTable.Platform -eq 'MacOSX' -or $IsLinux -or $IsMacOS) {
    Write-Host "ERROR: This script is designed for Windows 11 only!" -ForegroundColor Red
    Write-Host "This script cannot run on Linux or macOS." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Check Windows version (Windows 11 is build 22000+)
$winVersion = [System.Environment]::OSVersion.Version
if ($winVersion.Major -lt 10 -or ($winVersion.Major -eq 10 -and $winVersion.Build -lt 22000)) {
    Write-Host "WARNING: This script is optimized for Windows 11 (Build 22000+)" -ForegroundColor Yellow
    Write-Host "You are running: Windows $($winVersion.Major).$($winVersion.Minor) Build $($winVersion.Build)" -ForegroundColor Yellow
    $continue = Read-Host "Some features may not work correctly. Continue anyway? (Y/N)"
    if ($continue -ne "Y" -and $continue -ne "y") {
        exit 0
    }
}

# Color functions
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

# Check if running as administrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-ColorOutput Red "This script must be run as Administrator!"
    Read-Host "Press Enter to exit"
    exit
}

# Welcome message
Clear-Host
Write-ColorOutput Cyan "================================================"
Write-ColorOutput Cyan "    Windows 11 Debloat Script"
Write-ColorOutput Cyan "================================================"
Write-Host ""
Write-ColorOutput Yellow "WARNING: This script will make significant changes to your system."
Write-ColorOutput Yellow "It is recommended to create a system restore point before proceeding."
Write-Host ""

$createRestore = Read-Host "Do you want to create a system restore point now? (Y/N)"
if ($createRestore -eq "Y" -or $createRestore -eq "y") {
    Write-ColorOutput Green "Creating system restore point..."
    try {
        Checkpoint-Computer -Description "Before Windows 11 Debloat" -RestorePointType "MODIFY_SETTINGS"
        Write-ColorOutput Green "Restore point created successfully!"
    } catch {
        Write-ColorOutput Red "Failed to create restore point: $_"
    }
    Start-Sleep -Seconds 2
}

# Function to prompt user
function Get-UserChoice {
    param (
        [string]$Question
    )
    $choice = Read-Host "$Question (Y/N)"
    return ($choice -eq "Y" -or $choice -eq "y")
}

# Function to remove app packages
function Remove-AppPackages {
    param (
        [string[]]$AppNames,
        [string]$CategoryName
    )
    Write-ColorOutput Cyan "`nRemoving $CategoryName..."
    foreach ($app in $AppNames) {
        try {
            Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
            Write-ColorOutput Green "  [✓] Removed: $app"
        } catch {
            Write-ColorOutput Red "  [✗] Failed to remove: $app"
        }
    }
}

# Start debloating process
Write-Host ""
Write-ColorOutput Cyan "================================================"
Write-ColorOutput Cyan "    Select What to Remove"
Write-ColorOutput Cyan "================================================"
Write-Host ""

# OneDrive
if (Get-UserChoice "Remove OneDrive?") {
    Write-ColorOutput Cyan "`nRemoving OneDrive..."
    try {
        taskkill /f /im OneDrive.exe 2>$null
        Start-Sleep -Seconds 2
        
        if (Test-Path "$env:SystemRoot\System32\OneDriveSetup.exe") {
            & "$env:SystemRoot\System32\OneDriveSetup.exe" /uninstall
        }
        if (Test-Path "$env:SystemRoot\SysWOW64\OneDriveSetup.exe") {
            & "$env:SystemRoot\SysWOW64\OneDriveSetup.exe" /uninstall
        }
        
        Remove-Item -Path "HKCU:\Software\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:USERPROFILE\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:ProgramData\Microsoft OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
        
        Write-ColorOutput Green "  [✓] OneDrive removed successfully"
    } catch {
        Write-ColorOutput Red "  [✗] Failed to remove OneDrive: $_"
    }
}

# Microsoft Teams
if (Get-UserChoice "Remove Microsoft Teams?") {
    $teamsApps = @(
        "MicrosoftTeams",
        "Microsoft.Teams"
    )
    Remove-AppPackages -AppNames $teamsApps -CategoryName "Microsoft Teams"
}

# Cortana
if (Get-UserChoice "Remove Cortana?") {
    $cortanaApps = @(
        "Microsoft.549981C3F5F10"
    )
    Remove-AppPackages -AppNames $cortanaApps -CategoryName "Cortana"
}

# Office Hub
if (Get-UserChoice "Remove Office Hub?") {
    $officeApps = @(
        "Microsoft.MicrosoftOfficeHub",
        "Microsoft.Office.OneNote"
    )
    Remove-AppPackages -AppNames $officeApps -CategoryName "Office Hub"
}

# Mail and Calendar
if (Get-UserChoice "Remove Mail and Calendar?") {
    $mailApps = @(
        "microsoft.windowscommunicationsapps"
    )
    Remove-AppPackages -AppNames $mailApps -CategoryName "Mail and Calendar"
}

# Weather, News, and other MSN apps
if (Get-UserChoice "Remove Weather, News, Money, and Sports apps?") {
    $msnApps = @(
        "Microsoft.BingWeather",
        "Microsoft.BingNews",
        "Microsoft.BingFinance",
        "Microsoft.BingSports"
    )
    Remove-AppPackages -AppNames $msnApps -CategoryName "MSN Apps"
}

# Maps
if (Get-UserChoice "Remove Windows Maps?") {
    $mapsApps = @(
        "Microsoft.WindowsMaps"
    )
    Remove-AppPackages -AppNames $mapsApps -CategoryName "Maps"
}

# People
if (Get-UserChoice "Remove People app?") {
    $peopleApps = @(
        "Microsoft.People"
    )
    Remove-AppPackages -AppNames $peopleApps -CategoryName "People"
}

# Alarms and Clock
if (Get-UserChoice "Remove Alarms & Clock?") {
    $alarmApps = @(
        "Microsoft.WindowsAlarms"
    )
    Remove-AppPackages -AppNames $alarmApps -CategoryName "Alarms & Clock"
}

# Feedback Hub
if (Get-UserChoice "Remove Feedback Hub?") {
    $feedbackApps = @(
        "Microsoft.WindowsFeedbackHub"
    )
    Remove-AppPackages -AppNames $feedbackApps -CategoryName "Feedback Hub"
}

# Get Help
if (Get-UserChoice "Remove Get Help?") {
    $helpApps = @(
        "Microsoft.GetHelp"
    )
    Remove-AppPackages -AppNames $helpApps -CategoryName "Get Help"
}

# Paint 3D
if (Get-UserChoice "Remove Paint 3D?") {
    $paint3dApps = @(
        "Microsoft.MSPaint"
    )
    Remove-AppPackages -AppNames $paint3dApps -CategoryName "Paint 3D"
}

# Skype
if (Get-UserChoice "Remove Skype?") {
    $skypeApps = @(
        "Microsoft.SkypeApp"
    )
    Remove-AppPackages -AppNames $skypeApps -CategoryName "Skype"
}

# Sticky Notes
if (Get-UserChoice "Remove Sticky Notes?") {
    $stickyApps = @(
        "Microsoft.MicrosoftStickyNotes"
    )
    Remove-AppPackages -AppNames $stickyApps -CategoryName "Sticky Notes"
}

# Voice Recorder
if (Get-UserChoice "Remove Voice Recorder?") {
    $voiceApps = @(
        "Microsoft.WindowsSoundRecorder"
    )
    Remove-AppPackages -AppNames $voiceApps -CategoryName "Voice Recorder"
}

# Your Phone
if (Get-UserChoice "Remove Your Phone/Phone Link?") {
    $phoneApps = @(
        "Microsoft.YourPhone"
    )
    Remove-AppPackages -AppNames $phoneApps -CategoryName "Your Phone"
}

# 3D Viewer
if (Get-UserChoice "Remove 3D Viewer?") {
    $3dApps = @(
        "Microsoft.Microsoft3DViewer"
    )
    Remove-AppPackages -AppNames $3dApps -CategoryName "3D Viewer"
}

# Mixed Reality Portal
if (Get-UserChoice "Remove Mixed Reality Portal?") {
    $mrApps = @(
        "Microsoft.MixedReality.Portal"
    )
    Remove-AppPackages -AppNames $mrApps -CategoryName "Mixed Reality Portal"
}

# Solitaire Collection
if (Get-UserChoice "Remove Microsoft Solitaire Collection?") {
    $solitaireApps = @(
        "Microsoft.MicrosoftSolitaireCollection"
    )
    Remove-AppPackages -AppNames $solitaireApps -CategoryName "Solitaire Collection"
}

# Candy Crush and other games
if (Get-UserChoice "Remove Candy Crush and promoted games?") {
    $gameApps = @(
        "king.com.CandyCrushSaga",
        "king.com.CandyCrushSodaSaga",
        "king.com.CandyCrushFriends"
    )
    Remove-AppPackages -AppNames $gameApps -CategoryName "Promoted Games"
}

# Disable Telemetry
if (Get-UserChoice "Disable Telemetry and Data Collection?") {
    Write-ColorOutput Cyan "`nDisabling Telemetry..."
    try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 0 -Force -ErrorAction SilentlyContinue
        Stop-Service DiagTrack -Force -ErrorAction SilentlyContinue
        Set-Service DiagTrack -StartupType Disabled -ErrorAction SilentlyContinue
        Stop-Service dmwappushservice -Force -ErrorAction SilentlyContinue
        Set-Service dmwappushservice -StartupType Disabled -ErrorAction SilentlyContinue
        Write-ColorOutput Green "  [✓] Telemetry disabled"
    } catch {
        Write-ColorOutput Red "  [✗] Failed to disable telemetry: $_"
    }
}

# Disable Windows Tips
if (Get-UserChoice "Disable Windows Tips and Suggestions?") {
    Write-ColorOutput Cyan "`nDisabling Windows Tips..."
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SoftLandingEnabled" -Value 0 -Force
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Value 0 -Force
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Value 0 -Force
        Write-ColorOutput Green "  [✓] Windows Tips disabled"
    } catch {
        Write-ColorOutput Red "  [✗] Failed to disable tips: $_"
    }
}

# Disable Bing in Start Menu
if (Get-UserChoice "Disable Bing Search in Start Menu?") {
    Write-ColorOutput Cyan "`nDisabling Bing Search..."
    try {
        New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows" -Name "Explorer" -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "DisableSearchBoxSuggestions" -Value 1 -Force
        Write-ColorOutput Green "  [✓] Bing Search disabled"
    } catch {
        Write-ColorOutput Red "  [✗] Failed to disable Bing: $_"
    }
}

# Disable Activity History
if (Get-UserChoice "Disable Activity History?") {
    Write-ColorOutput Cyan "`nDisabling Activity History..."
    try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Value 0 -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Value 0 -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Value 0 -Force -ErrorAction SilentlyContinue
        Write-ColorOutput Green "  [✓] Activity History disabled"
    } catch {
        Write-ColorOutput Red "  [✗] Failed to disable Activity History: $_"
    }
}

# Disable Automatic Updates for Store Apps
if (Get-UserChoice "Disable automatic updates for Microsoft Store apps?") {
    Write-ColorOutput Cyan "`nDisabling Store Auto-Updates..."
    try {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore" -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore" -Name "AutoDownload" -Value 2 -Force
        Write-ColorOutput Green "  [✓] Store Auto-Updates disabled"
    } catch {
        Write-ColorOutput Red "  [✗] Failed to disable auto-updates: $_"
    }
}

# Cleanup
Write-Host ""
Write-ColorOutput Cyan "================================================"
Write-ColorOutput Green "Debloat process completed!"
Write-ColorOutput Cyan "================================================"
Write-Host ""
Write-ColorOutput Yellow "It is recommended to restart your computer for all changes to take effect."
Write-Host ""

$restart = Read-Host "Do you want to restart now? (Y/N)"
if ($restart -eq "Y" -or $restart -eq "y") {
    Write-ColorOutput Green "Restarting in 10 seconds..."
    Start-Sleep -Seconds 10
    Restart-Computer -Force
} else {
    Write-ColorOutput Yellow "Please restart your computer manually when convenient."
    Read-Host "Press Enter to exit"
}

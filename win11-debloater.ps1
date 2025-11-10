#Requires -RunAsAdministrator
<#
.SYNOPSIS
    win11-debloater - PowerShell Version

.DESCRIPTION
    Interactive script to remove bloatware and unnecessary features from Windows 11.
    Each prompt gives you full control - answer Y to remove, N to keep.

.NOTES
    Filename    : win11-debloater.ps1
    Author      : rtdsx
    Created     : November 2025
    Requires    : PowerShell 5.1+ and Administrator privileges
    
.EXAMPLE
    .\win11-debloater.ps1
    Run the script interactively with prompts for each removal option
#>

#==============================================================================
# SYSTEM VALIDATION
#==============================================================================

# Check if running on Windows
if ($PSVersionTable.Platform -eq 'Unix' -or $PSVersionTable.Platform -eq 'MacOSX' -or $IsLinux -or $IsMacOS) {
    Write-Host "ERROR: This script is designed for Windows 11 only!" -ForegroundColor Red
    Write-Host "This script cannot run on Linux or macOS." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Check Windows version (Windows 11 is build 22000+)
$winVersion = [System.Environment]::OSVersion.Version
if ($winVersion.Build -lt 22000) {
    Write-Host "WARNING: This script is optimized for Windows 11 (Build 22000+)" -ForegroundColor Yellow
    Write-Host "You are running: Windows $($winVersion.Major).$($winVersion.Minor) Build $($winVersion.Build)" -ForegroundColor Yellow
    $continue = Read-Host "Some features may not work correctly. Continue anyway? (Y/N)"
    if ($continue -ne "Y" -and $continue -ne "y") {
        exit 0
    }
}

#==============================================================================
# HELPER FUNCTIONS
#==============================================================================

<#
.SYNOPSIS
    Writes colored output to the console
.PARAMETER ForegroundColor
    The color to use for the output text
#>
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

<#
.SYNOPSIS
    Prompts user for Y/N choice
.PARAMETER Question
    The question to ask the user
.OUTPUTS
    Boolean - True if user answered Y, False otherwise
#>
function Get-UserChoice {
    param (
        [string]$Question
    )
    $choice = Read-Host "$Question (Y/N)"
    return ($choice -eq "Y" -or $choice -eq "y")
}

<#
.SYNOPSIS
    Removes Windows Store app packages
.PARAMETER AppNames
    Array of app package names to remove
.PARAMETER CategoryName
    Display name for the category being removed
#>
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

#==============================================================================
# DEBLOAT MENU
#==============================================================================

Write-Host ""
Write-ColorOutput Cyan "================================================"
Write-ColorOutput Cyan "    Select What to Remove"
Write-ColorOutput Cyan "================================================"
Write-Host ""

#==============================================================================
# APPLICATIONS REMOVAL
#==============================================================================

#------------------------------------------------------------------------------
# OneDrive
#------------------------------------------------------------------------------
if (Get-UserChoice "Remove OneDrive?") {
    Write-ColorOutput Cyan "`nRemoving OneDrive..."
    try {
        # Kill OneDrive process
        taskkill /f /im OneDrive.exe 2>$null
        Start-Sleep -Seconds 2
        
        # Uninstall OneDrive
        if (Test-Path "$env:SystemRoot\System32\OneDriveSetup.exe") {
            & "$env:SystemRoot\System32\OneDriveSetup.exe" /uninstall
        }
        if (Test-Path "$env:SystemRoot\SysWOW64\OneDriveSetup.exe") {
            & "$env:SystemRoot\SysWOW64\OneDriveSetup.exe" /uninstall
        }
        
        # Remove OneDrive folders and registry entries
        Remove-Item -Path "HKCU:\Software\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:USERPROFILE\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:ProgramData\Microsoft OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
        
        Write-ColorOutput Green "  [✓] OneDrive removed successfully"
    } catch {
        Write-ColorOutput Red "  [✗] Failed to remove OneDrive: $_"
    }
}

#------------------------------------------------------------------------------
# Microsoft Teams
#------------------------------------------------------------------------------
if (Get-UserChoice "Remove Microsoft Teams?") {
    $teamsApps = @(
        "MicrosoftTeams",
        "Microsoft.Teams"
    )
    Remove-AppPackages -AppNames $teamsApps -CategoryName "Microsoft Teams"
}

#------------------------------------------------------------------------------
# Office Hub
#------------------------------------------------------------------------------
if (Get-UserChoice "Remove Office Hub?") {
    $officeApps = @(
        "Microsoft.MicrosoftOfficeHub",
        "Microsoft.Office.OneNote"
    )
    Remove-AppPackages -AppNames $officeApps -CategoryName "Office Hub"
}

#------------------------------------------------------------------------------
# MSN Apps (News, Money, Sports)
#------------------------------------------------------------------------------
if (Get-UserChoice "Remove News, Money, and Sports apps?") {
    $msnApps = @(
        "Microsoft.BingNews",
        "Microsoft.BingFinance",
        "Microsoft.BingSports"
    )
    Remove-AppPackages -AppNames $msnApps -CategoryName "MSN Apps"
}

#------------------------------------------------------------------------------
# Paint 3D
#------------------------------------------------------------------------------
if (Get-UserChoice "Remove Paint 3D?") {
    $paint3dApps = @(
        "Microsoft.MSPaint"
    )
    Remove-AppPackages -AppNames $paint3dApps -CategoryName "Paint 3D"
}

#------------------------------------------------------------------------------
# 3D Viewer
#------------------------------------------------------------------------------
if (Get-UserChoice "Remove 3D Viewer?") {
    $3dApps = @(
        "Microsoft.Microsoft3DViewer"
    )
    Remove-AppPackages -AppNames $3dApps -CategoryName "3D Viewer"
}

#------------------------------------------------------------------------------
# Mixed Reality Portal
#------------------------------------------------------------------------------
if (Get-UserChoice "Remove Mixed Reality Portal?") {
    $mrApps = @(
        "Microsoft.MixedReality.Portal"
    )
    Remove-AppPackages -AppNames $mrApps -CategoryName "Mixed Reality Portal"
}

#------------------------------------------------------------------------------
# Microsoft Solitaire Collection
#------------------------------------------------------------------------------
if (Get-UserChoice "Remove Microsoft Solitaire Collection?") {
    $solitaireApps = @(
        "Microsoft.MicrosoftSolitaireCollection"
    )
    Remove-AppPackages -AppNames $solitaireApps -CategoryName "Solitaire Collection"
}

#==============================================================================
# SYSTEM TWEAKS & PRIVACY SETTINGS
#==============================================================================

#------------------------------------------------------------------------------
# Telemetry and Data Collection
#------------------------------------------------------------------------------
if (Get-UserChoice "Disable Telemetry and Data Collection?") {
    Write-ColorOutput Cyan "`nDisabling Telemetry..."
    try {
        # Disable telemetry through registry
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force -ErrorAction SilentlyContinue | Out-Null
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force -ErrorAction SilentlyContinue
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Force -ErrorAction SilentlyContinue | Out-Null
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 0 -Force -ErrorAction SilentlyContinue
        
        # Disable telemetry services
        Stop-Service DiagTrack -Force -ErrorAction SilentlyContinue
        Set-Service DiagTrack -StartupType Disabled -ErrorAction SilentlyContinue
        Stop-Service dmwappushservice -Force -ErrorAction SilentlyContinue
        Set-Service dmwappushservice -StartupType Disabled -ErrorAction SilentlyContinue
        
        Write-ColorOutput Green "  [✓] Telemetry disabled"
    } catch {
        Write-ColorOutput Red "  [✗] Failed to disable telemetry: $_"
    }
}

#------------------------------------------------------------------------------
# Windows Tips and Suggestions
#------------------------------------------------------------------------------
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

#------------------------------------------------------------------------------
# Bing Search in Start Menu
#------------------------------------------------------------------------------
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

#------------------------------------------------------------------------------
# Activity History
#------------------------------------------------------------------------------
if (Get-UserChoice "Disable Activity History?") {
    Write-ColorOutput Cyan "`nDisabling Activity History..."
    try {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Force -ErrorAction SilentlyContinue | Out-Null
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Value 0 -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Value 0 -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Value 0 -Force -ErrorAction SilentlyContinue
        Write-ColorOutput Green "  [✓] Activity History disabled"
    } catch {
        Write-ColorOutput Red "  [✗] Failed to disable Activity History: $_"
    }
}

#------------------------------------------------------------------------------
# Microsoft Store Auto-Updates
#------------------------------------------------------------------------------
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

#==============================================================================
# COMPLETION
#==============================================================================

Write-Host ""
Write-ColorOutput Cyan "================================================"
Write-ColorOutput Green "Debloat process completed!"
Write-ColorOutput Cyan "================================================"
Write-Host ""
Write-ColorOutput Yellow "It is recommended to restart your computer for all changes to take effect."
Write-Host ""

# Offer to restart the computer
$restart = Read-Host "Do you want to restart now? (Y/N)"
if ($restart -eq "Y" -or $restart -eq "y") {
    Write-ColorOutput Green "Restarting in 10 seconds..."
    Start-Sleep -Seconds 10
    Restart-Computer -Force
} else {
    Write-ColorOutput Yellow "Please restart your computer manually when convenient."
    Read-Host "Press Enter to exit"
}

# End of script

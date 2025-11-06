@echo off
:: ============================================================================
:: Windows 11 Debloat Script - Batch Version
:: ============================================================================
:: Description: Interactive script to remove bloatware from Windows 11
:: Requirements: Run as Administrator
:: Created: November 2025
:: ============================================================================

title Windows 11 Debloat Script

:: ============================================================================
:: SYSTEM CHECKS
:: ============================================================================

:: Check if running on Windows
ver | find "Windows" >nul
if errorlevel 1 (
    echo [ERROR] This script is designed for Windows 11 only!
    echo This script cannot run on Linux or macOS.
    pause
    exit /b 1
)

:: Check for administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] This script must be run as Administrator!
    echo Right-click the file and select "Run as administrator"
    pause
    exit /b 1
)

:: ============================================================================
:: WELCOME & SYSTEM RESTORE POINT
:: ============================================================================

:welcome
cls
echo ================================================
echo     Windows 11 Debloat Script
echo ================================================
echo.
echo WARNING: This script will make significant changes to your system.
echo It is recommended to create a system restore point before proceeding.
echo.

choice /C YN /M "Do you want to create a system restore point now"
if errorlevel 2 goto main_menu

if errorlevel 1 (
    echo Creating system restore point...
    wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Before Windows 11 Debloat", 100, 7 >nul 2>&1
    if %errorlevel% equ 0 (
        echo [SUCCESS] Restore point created successfully!
    ) else (
        echo [WARNING] Failed to create restore point. Continuing anyway...
    )
    timeout /t 2 >nul
)

:: ============================================================================
:: DEBLOAT MENU
:: ============================================================================

:main_menu
cls
echo ================================================
echo     Select What to Remove
echo ================================================
echo.

:: ============================================================================
:: APPLICATIONS REMOVAL
:: ============================================================================

:: ----------------------------------------------------------------------------
:: OneDrive
:: ----------------------------------------------------------------------------
choice /C YN /M "Remove OneDrive"
if errorlevel 2 goto skip_onedrive

if errorlevel 1 (
    echo.
    echo [INFO] Removing OneDrive...
    
    :: Kill OneDrive process
    taskkill /f /im OneDrive.exe >nul 2>&1
    timeout /t 2 >nul
    
    :: Uninstall OneDrive
    if exist "%SystemRoot%\System32\OneDriveSetup.exe" (
        "%SystemRoot%\System32\OneDriveSetup.exe" /uninstall >nul 2>&1
    )
    if exist "%SystemRoot%\SysWOW64\OneDriveSetup.exe" (
        "%SystemRoot%\SysWOW64\OneDriveSetup.exe" /uninstall >nul 2>&1
    )
    
    :: Remove OneDrive folders and registry entries
    rd /s /q "%USERPROFILE%\OneDrive" >nul 2>&1
    rd /s /q "%LOCALAPPDATA%\Microsoft\OneDrive" >nul 2>&1
    rd /s /q "%ProgramData%\Microsoft OneDrive" >nul 2>&1
    reg delete "HKCU\Software\Microsoft\OneDrive" /f >nul 2>&1
    
    echo   [SUCCESS] OneDrive removed
)
:skip_onedrive

:: ----------------------------------------------------------------------------
:: Microsoft Teams
:: ----------------------------------------------------------------------------
choice /C YN /M "Remove Microsoft Teams"
if errorlevel 2 goto skip_teams

if errorlevel 1 (
    echo.
    echo [INFO] Removing Microsoft Teams...
    powershell -Command "Get-AppxPackage *MicrosoftTeams* | Remove-AppxPackage" >nul 2>&1
    powershell -Command "Get-AppxPackage *Microsoft.Teams* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Microsoft Teams removed
)
:skip_teams

:: ----------------------------------------------------------------------------
:: Office Hub
:: ----------------------------------------------------------------------------
choice /C YN /M "Remove Office Hub"
if errorlevel 2 goto skip_office

if errorlevel 1 (
    echo.
    echo [INFO] Removing Office Hub...
    powershell -Command "Get-AppxPackage *Microsoft.MicrosoftOfficeHub* | Remove-AppxPackage" >nul 2>&1
    powershell -Command "Get-AppxPackage *Microsoft.Office.OneNote* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Office Hub removed
)
:skip_office

:: ----------------------------------------------------------------------------
:: MSN Apps (News, Money, Sports)
:: ----------------------------------------------------------------------------
choice /C YN /M "Remove News, Money, and Sports apps"
if errorlevel 2 goto skip_msn

if errorlevel 1 (
    echo.
    echo [INFO] Removing MSN Apps...
    powershell -Command "Get-AppxPackage *Microsoft.BingNews* | Remove-AppxPackage" >nul 2>&1
    powershell -Command "Get-AppxPackage *Microsoft.BingFinance* | Remove-AppxPackage" >nul 2>&1
    powershell -Command "Get-AppxPackage *Microsoft.BingSports* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] MSN Apps removed
)
:skip_msn

:: ----------------------------------------------------------------------------
:: Paint 3D
:: ----------------------------------------------------------------------------
choice /C YN /M "Remove Paint 3D"
if errorlevel 2 goto skip_paint3d
if errorlevel 1 (
    echo.
    echo [INFO] Removing Paint 3D...
    powershell -Command "Get-AppxPackage *Microsoft.MSPaint* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Paint 3D removed
)
:skip_paint3d

:: ----------------------------------------------------------------------------
:: 3D Viewer
:: ----------------------------------------------------------------------------
:: ----------------------------------------------------------------------------
:: 3D Viewer
:: ----------------------------------------------------------------------------
choice /C YN /M "Remove 3D Viewer"
if errorlevel 2 goto skip_3d

if errorlevel 1 (
    echo.
    echo [INFO] Removing 3D Viewer...
    powershell -Command "Get-AppxPackage *Microsoft.Microsoft3DViewer* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] 3D Viewer removed
)
:skip_3d

:: ----------------------------------------------------------------------------
:: Mixed Reality Portal
:: ----------------------------------------------------------------------------
choice /C YN /M "Remove Mixed Reality Portal"
if errorlevel 2 goto skip_mr

if errorlevel 1 (
    echo.
    echo [INFO] Removing Mixed Reality Portal...
    powershell -Command "Get-AppxPackage *Microsoft.MixedReality.Portal* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Mixed Reality Portal removed
)
:skip_mr

:: ----------------------------------------------------------------------------
:: Microsoft Solitaire Collection
:: ----------------------------------------------------------------------------
choice /C YN /M "Remove Microsoft Solitaire Collection"
if errorlevel 2 goto skip_solitaire

if errorlevel 1 (
    echo.
    echo [INFO] Removing Solitaire Collection...
    powershell -Command "Get-AppxPackage *Microsoft.MicrosoftSolitaireCollection* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Solitaire Collection removed
)
:skip_solitaire

:: ============================================================================
:: SYSTEM TWEAKS & PRIVACY SETTINGS
:: ============================================================================

:: ----------------------------------------------------------------------------
:: Telemetry and Data Collection
:: ----------------------------------------------------------------------------
choice /C YN /M "Disable Telemetry and Data Collection"
if errorlevel 2 goto skip_telemetry

if errorlevel 1 (
    echo.
    echo [INFO] Disabling Telemetry...
    
    :: Disable telemetry through registry
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
    
    :: Disable telemetry services
    sc stop DiagTrack >nul 2>&1
    sc config DiagTrack start=disabled >nul 2>&1
    sc stop dmwappushservice >nul 2>&1
    sc config dmwappushservice start=disabled >nul 2>&1
    
    echo   [SUCCESS] Telemetry disabled
)
:skip_telemetry

:: ----------------------------------------------------------------------------
:: Windows Tips and Suggestions
:: ----------------------------------------------------------------------------
choice /C YN /M "Disable Windows Tips and Suggestions"
if errorlevel 2 goto skip_tips

if errorlevel 1 (
    echo.
    echo [INFO] Disabling Windows Tips...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f >nul 2>&1
    echo   [SUCCESS] Windows Tips disabled
)
:skip_tips

:: ----------------------------------------------------------------------------
:: Bing Search in Start Menu
:: ----------------------------------------------------------------------------
choice /C YN /M "Disable Bing Search in Start Menu"
if errorlevel 2 goto skip_bing

if errorlevel 1 (
    echo.
    echo [INFO] Disabling Bing Search...
    reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f >nul 2>&1
    echo   [SUCCESS] Bing Search disabled
)
:skip_bing

:: ----------------------------------------------------------------------------
:: Activity History
:: ----------------------------------------------------------------------------
choice /C YN /M "Disable Activity History"
if errorlevel 2 goto skip_activity

if errorlevel 1 (
    echo.
    echo [INFO] Disabling Activity History...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v UploadUserActivities /t REG_DWORD /d 0 /f >nul 2>&1
    echo   [SUCCESS] Activity History disabled
)
:skip_activity

:: ----------------------------------------------------------------------------
:: Microsoft Store Auto-Updates
:: ----------------------------------------------------------------------------
choice /C YN /M "Disable automatic updates for Microsoft Store apps"
if errorlevel 2 goto skip_store

if errorlevel 1 (
    echo.
    echo [INFO] Disabling Store Auto-Updates...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v AutoDownload /t REG_DWORD /d 2 /f >nul 2>&1
    echo   [SUCCESS] Store Auto-Updates disabled
)
:skip_store

:: ============================================================================
:: COMPLETION
:: ============================================================================

:complete
echo.
echo ================================================
echo [SUCCESS] Debloat process completed!
echo ================================================
echo.
echo It is recommended to restart your computer for all changes to take effect.
echo.

choice /C YN /M "Do you want to restart now"
if errorlevel 2 goto exit

if errorlevel 1 (
    echo.
    echo Restarting in 10 seconds...
    timeout /t 10
    shutdown /r /f /t 0
)

:exit
echo.
echo Please restart your computer manually when convenient.
pause
exit /b 0

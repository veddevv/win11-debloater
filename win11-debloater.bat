@echo off
:: Windows 11 Debloat Script - Batch Version
:: Run as Administrator
:: Created: November 2025

title Windows 11 Debloat Script

:: Check for administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] This script must be run as Administrator!
    echo Right-click the file and select "Run as administrator"
    pause
    exit /b 1
)

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

:main_menu
cls
echo ================================================
echo     Select What to Remove
echo ================================================
echo.

:: Xbox Apps
choice /C YN /M "Remove Xbox apps? (Game Bar, Xbox, Gaming Services)"
if errorlevel 2 goto skip_xbox
if errorlevel 1 (
    echo.
    echo [INFO] Removing Xbox Apps...
    powershell -Command "Get-AppxPackage *Microsoft.GamingApp* | Remove-AppxPackage" >nul 2>&1
    powershell -Command "Get-AppxPackage *Microsoft.XboxApp* | Remove-AppxPackage" >nul 2>&1
    powershell -Command "Get-AppxPackage *Microsoft.XboxGameOverlay* | Remove-AppxPackage" >nul 2>&1
    powershell -Command "Get-AppxPackage *Microsoft.XboxGamingOverlay* | Remove-AppxPackage" >nul 2>&1
    powershell -Command "Get-AppxPackage *Microsoft.XboxIdentityProvider* | Remove-AppxPackage" >nul 2>&1
    powershell -Command "Get-AppxPackage *Microsoft.XboxSpeechToTextOverlay* | Remove-AppxPackage" >nul 2>&1
    powershell -Command "Get-AppxPackage *Microsoft.Xbox.TCUI* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Xbox Apps removed
)
:skip_xbox

:: OneDrive
choice /C YN /M "Remove OneDrive"
if errorlevel 2 goto skip_onedrive
if errorlevel 1 (
    echo.
    echo [INFO] Removing OneDrive...
    taskkill /f /im OneDrive.exe >nul 2>&1
    timeout /t 2 >nul
    if exist "%SystemRoot%\System32\OneDriveSetup.exe" (
        "%SystemRoot%\System32\OneDriveSetup.exe" /uninstall >nul 2>&1
    )
    if exist "%SystemRoot%\SysWOW64\OneDriveSetup.exe" (
        "%SystemRoot%\SysWOW64\OneDriveSetup.exe" /uninstall >nul 2>&1
    )
    rd /s /q "%USERPROFILE%\OneDrive" >nul 2>&1
    rd /s /q "%LOCALAPPDATA%\Microsoft\OneDrive" >nul 2>&1
    rd /s /q "%ProgramData%\Microsoft OneDrive" >nul 2>&1
    reg delete "HKCU\Software\Microsoft\OneDrive" /f >nul 2>&1
    echo   [SUCCESS] OneDrive removed
)
:skip_onedrive

:: Microsoft Teams
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

:: Cortana
choice /C YN /M "Remove Cortana"
if errorlevel 2 goto skip_cortana
if errorlevel 1 (
    echo.
    echo [INFO] Removing Cortana...
    powershell -Command "Get-AppxPackage *Microsoft.549981C3F5F10* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Cortana removed
)
:skip_cortana

:: Office Hub
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

:: Mail and Calendar
choice /C YN /M "Remove Mail and Calendar"
if errorlevel 2 goto skip_mail
if errorlevel 1 (
    echo.
    echo [INFO] Removing Mail and Calendar...
    powershell -Command "Get-AppxPackage *microsoft.windowscommunicationsapps* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Mail and Calendar removed
)
:skip_mail

:: MSN Apps
choice /C YN /M "Remove Weather, News, Money, and Sports apps"
if errorlevel 2 goto skip_msn
if errorlevel 1 (
    echo.
    echo [INFO] Removing MSN Apps...
    powershell -Command "Get-AppxPackage *Microsoft.BingWeather* | Remove-AppxPackage" >nul 2>&1
    powershell -Command "Get-AppxPackage *Microsoft.BingNews* | Remove-AppxPackage" >nul 2>&1
    powershell -Command "Get-AppxPackage *Microsoft.BingFinance* | Remove-AppxPackage" >nul 2>&1
    powershell -Command "Get-AppxPackage *Microsoft.BingSports* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] MSN Apps removed
)
:skip_msn

:: Maps
choice /C YN /M "Remove Windows Maps"
if errorlevel 2 goto skip_maps
if errorlevel 1 (
    echo.
    echo [INFO] Removing Windows Maps...
    powershell -Command "Get-AppxPackage *Microsoft.WindowsMaps* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Windows Maps removed
)
:skip_maps

:: People
choice /C YN /M "Remove People app"
if errorlevel 2 goto skip_people
if errorlevel 1 (
    echo.
    echo [INFO] Removing People app...
    powershell -Command "Get-AppxPackage *Microsoft.People* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] People app removed
)
:skip_people

:: Photos
choice /C YN /M "Remove Photos app? (WARNING: Default photo viewer)"
if errorlevel 2 goto skip_photos
if errorlevel 1 (
    echo.
    echo [INFO] Removing Photos app...
    powershell -Command "Get-AppxPackage *Microsoft.Windows.Photos* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Photos app removed
)
:skip_photos

:: Alarms and Clock
choice /C YN /M "Remove Alarms and Clock"
if errorlevel 2 goto skip_alarms
if errorlevel 1 (
    echo.
    echo [INFO] Removing Alarms and Clock...
    powershell -Command "Get-AppxPackage *Microsoft.WindowsAlarms* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Alarms and Clock removed
)
:skip_alarms

:: Calculator
choice /C YN /M "Remove Calculator? (WARNING: Useful app)"
if errorlevel 2 goto skip_calc
if errorlevel 1 (
    echo.
    echo [INFO] Removing Calculator...
    powershell -Command "Get-AppxPackage *Microsoft.WindowsCalculator* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Calculator removed
)
:skip_calc

:: Camera
choice /C YN /M "Remove Camera app"
if errorlevel 2 goto skip_camera
if errorlevel 1 (
    echo.
    echo [INFO] Removing Camera app...
    powershell -Command "Get-AppxPackage *Microsoft.WindowsCamera* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Camera app removed
)
:skip_camera

:: Feedback Hub
choice /C YN /M "Remove Feedback Hub"
if errorlevel 2 goto skip_feedback
if errorlevel 1 (
    echo.
    echo [INFO] Removing Feedback Hub...
    powershell -Command "Get-AppxPackage *Microsoft.WindowsFeedbackHub* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Feedback Hub removed
)
:skip_feedback

:: Get Help
choice /C YN /M "Remove Get Help"
if errorlevel 2 goto skip_help
if errorlevel 1 (
    echo.
    echo [INFO] Removing Get Help...
    powershell -Command "Get-AppxPackage *Microsoft.GetHelp* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Get Help removed
)
:skip_help

:: Groove Music
choice /C YN /M "Remove Groove Music"
if errorlevel 2 goto skip_music
if errorlevel 1 (
    echo.
    echo [INFO] Removing Groove Music...
    powershell -Command "Get-AppxPackage *Microsoft.ZuneMusic* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Groove Music removed
)
:skip_music

:: Movies and TV
choice /C YN /M "Remove Movies and TV"
if errorlevel 2 goto skip_video
if errorlevel 1 (
    echo.
    echo [INFO] Removing Movies and TV...
    powershell -Command "Get-AppxPackage *Microsoft.ZuneVideo* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Movies and TV removed
)
:skip_video

:: Paint 3D
choice /C YN /M "Remove Paint 3D"
if errorlevel 2 goto skip_paint3d
if errorlevel 1 (
    echo.
    echo [INFO] Removing Paint 3D...
    powershell -Command "Get-AppxPackage *Microsoft.MSPaint* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Paint 3D removed
)
:skip_paint3d

:: Skype
choice /C YN /M "Remove Skype"
if errorlevel 2 goto skip_skype
if errorlevel 1 (
    echo.
    echo [INFO] Removing Skype...
    powershell -Command "Get-AppxPackage *Microsoft.SkypeApp* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Skype removed
)
:skip_skype

:: Sticky Notes
choice /C YN /M "Remove Sticky Notes"
if errorlevel 2 goto skip_sticky
if errorlevel 1 (
    echo.
    echo [INFO] Removing Sticky Notes...
    powershell -Command "Get-AppxPackage *Microsoft.MicrosoftStickyNotes* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Sticky Notes removed
)
:skip_sticky

:: Voice Recorder
choice /C YN /M "Remove Voice Recorder"
if errorlevel 2 goto skip_voice
if errorlevel 1 (
    echo.
    echo [INFO] Removing Voice Recorder...
    powershell -Command "Get-AppxPackage *Microsoft.WindowsSoundRecorder* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Voice Recorder removed
)
:skip_voice

:: Your Phone
choice /C YN /M "Remove Your Phone/Phone Link"
if errorlevel 2 goto skip_phone
if errorlevel 1 (
    echo.
    echo [INFO] Removing Your Phone...
    powershell -Command "Get-AppxPackage *Microsoft.YourPhone* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Your Phone removed
)
:skip_phone

:: 3D Viewer
choice /C YN /M "Remove 3D Viewer"
if errorlevel 2 goto skip_3d
if errorlevel 1 (
    echo.
    echo [INFO] Removing 3D Viewer...
    powershell -Command "Get-AppxPackage *Microsoft.Microsoft3DViewer* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] 3D Viewer removed
)
:skip_3d

:: Mixed Reality Portal
choice /C YN /M "Remove Mixed Reality Portal"
if errorlevel 2 goto skip_mr
if errorlevel 1 (
    echo.
    echo [INFO] Removing Mixed Reality Portal...
    powershell -Command "Get-AppxPackage *Microsoft.MixedReality.Portal* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Mixed Reality Portal removed
)
:skip_mr

:: Solitaire
choice /C YN /M "Remove Microsoft Solitaire Collection"
if errorlevel 2 goto skip_solitaire
if errorlevel 1 (
    echo.
    echo [INFO] Removing Solitaire Collection...
    powershell -Command "Get-AppxPackage *Microsoft.MicrosoftSolitaireCollection* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Solitaire Collection removed
)
:skip_solitaire

:: Candy Crush
choice /C YN /M "Remove Candy Crush and promoted games"
if errorlevel 2 goto skip_games
if errorlevel 1 (
    echo.
    echo [INFO] Removing Promoted Games...
    powershell -Command "Get-AppxPackage *king.com.CandyCrush* | Remove-AppxPackage" >nul 2>&1
    echo   [SUCCESS] Promoted Games removed
)
:skip_games

:: Telemetry
choice /C YN /M "Disable Telemetry and Data Collection"
if errorlevel 2 goto skip_telemetry
if errorlevel 1 (
    echo.
    echo [INFO] Disabling Telemetry...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
    sc stop DiagTrack >nul 2>&1
    sc config DiagTrack start=disabled >nul 2>&1
    sc stop dmwappushservice >nul 2>&1
    sc config dmwappushservice start=disabled >nul 2>&1
    echo   [SUCCESS] Telemetry disabled
)
:skip_telemetry

:: Windows Tips
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

:: Bing Search
choice /C YN /M "Disable Bing Search in Start Menu"
if errorlevel 2 goto skip_bing
if errorlevel 1 (
    echo.
    echo [INFO] Disabling Bing Search...
    reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f >nul 2>&1
    echo   [SUCCESS] Bing Search disabled
)
:skip_bing

:: Activity History
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

:: Store Auto-Updates
choice /C YN /M "Disable automatic updates for Microsoft Store apps"
if errorlevel 2 goto skip_store
if errorlevel 1 (
    echo.
    echo [INFO] Disabling Store Auto-Updates...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v AutoDownload /t REG_DWORD /d 2 /f >nul 2>&1
    echo   [SUCCESS] Store Auto-Updates disabled
)
:skip_store

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

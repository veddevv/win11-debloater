# win11-debloater

Interactive scripts to remove bloatware and unnecessary features from Windows 11. Each prompt gives you full control - answer Y to remove, N to keep.

## 🎮 NEW - Gaming Versions Available

**For gamers seeking maximum performance**, check out the enhanced gaming versions on [win11-debloater-gaming](https://github.com/notrtdsx/win11-debloater-gaming)!

- **`win11-debloater-gaming.ps1`** - Gaming-optimized PowerShell version
- **`win11-debloater-gaming.bat`** - Gaming-optimized Batch version

Gaming versions include **advanced tweaks**: GPU scheduling, network optimizations, input lag reduction, CPU core parking, and more!

## Features

- **Interactive prompts** - Choose what to remove with Y/N for each item
- **Safe operation** - Optional system restore point creation before changes
- **Four versions** - Standard and Gaming variants in both PowerShell and Batch
- **No surprises** - Every change requires your confirmation
- **Gaming optimizations** - Remove Xbox bloat and disable performance-impacting features

## What Can Be Removed

### Apps & Programs

OneDrive, Microsoft Teams, Office Hub, News, Sports, Money, Paint 3D, 3D Viewer, Mixed Reality Portal, Solitaire Collection

### Gaming Apps & Features

- **Xbox Apps** - Xbox App, Game Bar, Xbox Live services, Gaming Overlay
- **Game Bar** - Disable Win+G overlay
- **Game DVR** - Background recording and screen capture
- **Game Mode** - Optional (some games benefit from this)

### System Tweaks

- **Telemetry** - Disable data collection and diagnostic tracking
- **Windows Tips** - Stop suggestions and tips
- **Bing Search** - Remove Bing integration from Start Menu
- **Activity History** - Stop tracking your activities
- **Store Auto-Updates** - Disable automatic app updates

## Usage

### PowerShell (Recommended)

**Standard Version:**

1. Right-click `win11-debloater.ps1`
2. Select **"Run with PowerShell"**
3. Allow administrator privileges when prompted
4. Answer Y/N to each prompt

**Gaming Version (Enhanced Performance):**

1. Right-click `win11-debloater-gaming.ps1`
2. Select **"Run with PowerShell"**
3. Follow prompts for gaming-specific optimizations

**Alternative:** Open PowerShell as admin and run:

```powershell
.\win11-debloater.ps1
# OR for gaming version
.\win11-debloater-gaming.ps1
```

### Batch

**Standard Version:**

1. Right-click `win11-debloater.bat`
2. Select **"Run as administrator"**
3. Answer Y/N to each prompt

**Gaming Version:**

1. Right-click `win11-debloater-gaming.bat`
2. Select **"Run as administrator"**
3. Answer Y/N to each prompt

## Important Notes

- **Administrator rights required** - System modifications need elevated permissions
- **Create restore point** - Highly recommended when the script offers it
- **Backup important data** - Especially OneDrive files before removal
- **Game Mode warning** - Some games perform better with Game Mode enabled; only disable if you know what you're doing
- **Reinstalling apps** - Most can be reinstalled from Microsoft Store, some may require PowerShell
- **System restart** - Recommended after completion for changes to take effect

## Undo Changes

If you need to restore your system:

1. Search for "Create a restore point" in Windows Start Menu
2. Click **"System Restore"**
3. Select the restore point created by the script
4. Follow the restoration wizard

## Recommended Tool

For more advanced privacy and telemetry controls, check out [O&O ShutUp10++](https://www.oo-software.com/en/shutup10) - a free tool with additional Windows privacy settings.

---

Made with ❤️ for a cleaner Windows

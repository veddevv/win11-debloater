# win11-debloater

Interactive scripts to remove bloatware and unnecessary features from Windows 11. Each prompt gives you full control - answer Y to remove, N to keep.

## Features

- **Interactive prompts** - Choose what to remove with Y/N for each item
- **Safe operation** - Optional system restore point creation before changes
- **Two versions** - PowerShell (.ps1) with colors, or Batch (.bat) for compatibility
- **No surprises** - Every change requires your confirmation

## What Can Be Removed

### Apps & Programs

Xbox apps, OneDrive, Microsoft Teams, Cortana, Office Hub, Mail & Calendar, Weather, News, Sports, Money, Maps, People, Photos, Camera, Alarms & Clock, Calculator, Groove Music, Movies & TV, Paint 3D, Skype, Sticky Notes, Voice Recorder, Your Phone/Phone Link, 3D Viewer, Mixed Reality Portal, Solitaire Collection, Candy Crush, Feedback Hub, Get Help

### System Tweaks

- **Telemetry** - Disable data collection and diagnostic tracking
- **Windows Tips** - Stop suggestions and tips
- **Bing Search** - Remove Bing integration from Start Menu
- **Activity History** - Stop tracking your activities
- **Store Auto-Updates** - Disable automatic app updates

## Usage

### PowerShell (Recommended)

1. Right-click `windows11-debloat.ps1`
2. Select **"Run with PowerShell"**
3. Allow administrator privileges when prompted
4. Answer Y/N to each prompt

**Alternative:** Open PowerShell as admin and run `.\windows11-debloat.ps1`

### Batch

1. Right-click `windows11-debloat.bat`
2. Select **"Run as administrator"**
3. Answer Y/N to each prompt

## Important Notes

- **Administrator rights required** - System modifications need elevated permissions
- **Create restore point** - Highly recommended when the script offers it
- **Backup important data** - Especially OneDrive files before removal
- **Reinstalling apps** - Most can be reinstalled from Microsoft Store, some may require PowerShell
- **System restart** - Recommended after completion for changes to take effect

## Undo Changes

If you need to restore your system:

1. Search for "Create a restore point" in Windows Start Menu
2. Click **"System Restore"**
3. Select the restore point created by the script
4. Follow the restoration wizard

## License

MIT License - Use at your own risk. See [LICENSE](LICENSE) for details.

---

Made with ❤️ for a cleaner Windows

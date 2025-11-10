# Which Version Should I Use?

Quick guide to help you choose the right debloater script for your needs.

## 🎯 Quick Decision Tree

```text
Do you primarily use your PC for gaming?
├─ YES → Use Gaming Version (win11-debloater-gaming.ps1/.bat)
│         Get maximum FPS and lowest latency
│
└─ NO → Use Standard Version (win11-debloater.ps1/.bat)
          Clean and simple debloating

PowerShell or Batch?
├─ PowerShell (.ps1) - Colorful output, better error handling (Recommended)
└─ Batch (.bat) - Simple, works everywhere
```

## 📊 Version Comparison

| Use Case | Recommended Version | Why? |
|----------|-------------------|------|
| **Competitive Gaming** | Gaming (PS1) | Network optimizations, input lag reduction, maximum FPS |
| **Casual Gaming** | Gaming (PS1) | Performance improvements without complexity |
| **Productivity/Office** | Standard (PS1) | Clean bloatware removal, keeps helpful features |
| **General Use** | Standard (PS1) | Balanced approach, easier to reverse |
| **Older Hardware** | Gaming (Batch) | Every bit of performance helps |
| **Quick Cleanup** | Standard (Batch) | Fast and simple |

## 🎮 Gaming Version - Best For

✅ **Competitive gamers** (CS2, Valorant, Apex, COD, etc.)  
✅ **Streamers** (need every bit of performance)  
✅ **VR users** (high frame rates are critical)  
✅ **People with mid-range PCs** (maximize what you have)  
✅ **FPS-sensitive users** (120Hz/144Hz/240Hz monitors)  
✅ **Anyone experiencing micro-stuttering**  

### Gaming Version Includes

- All standard debloat features
- Hardware GPU scheduling
- Network latency optimizations
- CPU core parking disabled
- Input lag reduction
- Mouse acceleration removal
- Background service optimization
- Power plan tweaks
- Visual effects optimization
- SysMain/Superfetch disabled

### Performance Expectations

- 5-15% FPS increase (game-dependent)
- 10-30ms lower network latency
- Smoother 1% and 0.1% lows
- Reduced system latency
- Faster boot times

## 🖥️ Standard Version - Best For

✅ **Office/productivity users**  
✅ **Light gamers** (Sims, indie games, older titles)  
✅ **Users who want minimal changes**  
✅ **People sharing PC with others**  
✅ **Those who prefer stock Windows feel**  

### Standard Version Includes

- Bloatware removal
- Privacy settings
- Telemetry disabled
- Optional Xbox removal
- Basic system tweaks
- No aggressive optimizations

### Good Because

- Less intrusive
- Easier to reverse
- Maintains Windows defaults
- Safer for non-gamers
- Better compatibility

## 🔧 Technical Differences

| Feature | Standard | Gaming |
|---------|----------|--------|
| **Bloatware Removal** | ✅ Full | ✅ Full |
| **Privacy Tweaks** | ✅ Yes | ✅ Yes |
| **GPU Scheduling** | ❌ No | ✅ Yes |
| **Network Optimizations** | ❌ No | ✅ Yes (Nagle, TCP, throttling) |
| **Power Plan** | ⚠️ Default | ✅ Ultimate Performance |
| **CPU Core Parking** | ⚠️ Default | ✅ Disabled |
| **Mouse Acceleration** | ⚠️ Default | ✅ Disabled |
| **Visual Effects** | ⚠️ Default | ✅ Performance Mode |
| **SysMain/Superfetch** | ⚠️ Enabled | ✅ Disabled |
| **Windows Search** | ⚠️ Enabled | ✅ Disabled |
| **Background Services** | ⚠️ Running | ✅ Minimized |
| **Input Optimization** | ❌ No | ✅ Yes |

## 🤔 Still Not Sure?

### Start with Standard if

- You're not sure what you need
- You share your PC with others
- You use your PC for work
- You're new to Windows optimization
- You prefer conservative changes

### Go with Gaming if

- You play competitive games
- You experience stuttering
- You want maximum performance
- You have a gaming-focused PC
- You're comfortable with tweaks

## 💡 Pro Tips

### Can I run both?

**No!** They will conflict. Choose one based on your primary use case.

### Can I switch later?

**Yes**, but recommended method:

1. Create a restore point
2. Restore to clean Windows state
3. Run the other version

### What if I game AND work?

Choose **Gaming version**. The optimizations won't hurt productivity, and you'll benefit during gaming sessions.

### What about laptops?

- **Gaming laptops**: Gaming version
- **Business laptops**: Standard version
- **Hybrid laptops**: Standard version (gaming tweaks can hurt battery life)

## 🔄 Migration Guide

### From Standard → Gaming

1. Create system restore point
2. Run gaming version
3. Answer Y to new optimizations
4. Restart

### From Gaming → Standard

1. Use System Restore to go back
2. Run standard version
3. Manually re-enable services if needed

## 📝 Summary

**TL;DR:**

- **Gaming PC + Want best performance** = Gaming Version (PowerShell)
- **Everything else** = Standard Version (PowerShell)
- **Old PC/Compatibility issues** = Use Batch versions
- **When in doubt** = Start with Standard, upgrade to Gaming if needed

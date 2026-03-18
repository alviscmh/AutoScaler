# AutoScaler: Dynamic Windows DPI Switcher

**Your laptop is further away when docked. Why is your text still the same size?**

When you dock your laptop, it sits further away from your eyes. The scaling that looked great at a café makes the UI impossible to read at your desk. Instead of suffering through microscopic text or constantly digging through Windows Settings, let your computer do the work

AutoScaler is a zero-touch, lightweight, background automation tool. It actively monitors your physical hardware state. Dock your machine, and AutoScaler instantly forces your laptop's DPI to a readable "desk distance" size. Unplug, and it shrinks back down for travel. 

**Set it to launch on startup, and it becomes a seamless, invisible fix for one of Windows' most frustrating design flaws.**

## ✨ Features
* **Zero-Touch Automation:** Automatically changes scaling when plugging/unplugging an external monitor.
* **Pre-emptive Sleep/Shutdown Reset:** Intercepts Windows power states to reset your laptop to its "travel size" *before* it goes to sleep or shuts down. This bypasses the infamous Windows bug where the lock screen remains oversized upon waking up unplugged.
* **Phantom Monitor Protection:** Actively measures screen resolution to detect "Second Screen Only" modes, preventing the script from accidentally resizing the wrong display.
* **Hardware Debouncing:** Uses optimized timers to wait for the graphics card to finish its hardware "handshake" before executing, preventing CPU spam.
* **Crash Armor:** Fully wrapped in `try...catch` blocks to survive chaotic OS display transitions without silently crashing in the background.

<img width="1856" height="2304" alt="Gemini_Generated_Image_1oxkyd1oxkyd1oxk" src="https://github.com/user-attachments/assets/67bce869-6727-4841-a445-722608f69544" />

## 🛠️ Prerequisites
1. **AutoHotkey v2:** You must have [AutoHotkey v2](https://www.autohotkey.com/) installed. (This script will not work on v1).
2. **SetDpi.exe:** This script relies on a lightweight, open-source command-line tool called `SetDpi` created by GitHub user *imniko*. 
   * Download the latest `SetDpi.exe` file from the **[Official imniko/SetDPI Releases Page](https://github.com/imniko/SetDPI/releases)**.
   * Create a dedicated folder on your C:\ drive (e.g., `C:\SetDPI\`) and place the executable inside it.

## 🚀 Installation & Setup
1. Download the `AutoScaler.ahk` file from this repository.
2. Open the file in any text editor (like Notepad) to configure your specific setup.

## ⚡ Running on Startup (The Task Scheduler Method)
To make AutoScaler truly "zero-touch," it needs to run automatically when you turn on your computer. 

While you could put it in the standard Windows `shell:startup` folder, Windows intentionally delays apps in that folder. To get the script running the exact millisecond you log in, we use the Windows Task Scheduler.

## ⚡ Running on Startup (The Task Scheduler Method)
To make AutoScaler truly "zero-touch," it needs to run automatically when you turn on your computer. 

While you could put it in the standard Windows `shell:startup` folder, Windows intentionally delays apps in that folder. Furthermore, the default "Fast Startup" feature on modern laptops often skips standard startup folders entirely. To bypass this and get the script running instantly, we use the Windows Task Scheduler with two specific triggers.

1. Open **Task Scheduler** in Windows and click **Create Task...** (Do not use "Basic Task").
2. **General Tab:** Name the task `AutoScaler`. Make sure *"Run only when user is logged on"* is selected. **Do not** check "Run with highest privileges" (leaving it unchecked ensures the script's green 'H' icon stays visible in your system tray).
3. **Triggers Tab:** You need to add two triggers here. 
   * Click **New**, set "Begin the task" to **At log on**, and click OK.
   * Click **New** again, set "Begin the task" to **On workstation unlock** (Any user), and click OK. *(This secondary trigger ensures the script survives Windows laptop hibernation/Fast Startup states).*
4. **Actions Tab:** Click **New**, select **Start a program**, and click Browse to locate your configured `AutoScaler.ahk` file.
5. **Conditions Tab:** **Uncheck** *"Start the task only if the computer is on AC power"* (This is crucial so the script still runs when you boot your laptop on battery!).
6. Click **OK** to save.

## ⌨️ Manual Override
If you ever need to manually force the script to check the monitors and update the scaling, press:
**`Ctrl` + `Alt` + `S`**

### Configuration
At the very top of the script, you will find a Configuration block. Modify these variables to match your hardware:

```autohotkey
; ==========================================
; CONFIGURATION
global ToolPath    := '"C:\SetDPI\SetDpi.exe"' ; Path to your SetDpi tool
global TravelSize  := 200                      ; Scaling % when unplugged (1 screen)
global DeskSize    := 225                      ; Scaling % when plugged in (2 screens)
global LaptopID    := 1                        ; Your laptop's monitor ID in Windows
global LaptopWidth := 2880                     ; Your laptop's native horizontal resolution
; ==========================================

#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

; ==========================================
; CONFIGURATION (Change these if your setup changes)
global ToolPath    := '"C:\SetDPI\SetDpi.exe"'
global TravelSize  := 200
global DeskSize    := 225
global LaptopID    := 1
global LaptopWidth := 2880 ; <--- Your laptop's horizontal resolution
; ==========================================

global lastMonitorCount := 0

; 1. Initial check on startup
UpdateScaling()

; Listeners
OnMessage(0x007E, OnDisplayChange)
OnMessage(0x0218, OnPowerBroadcast)
OnMessage(0x0011, OnShutdown)

OnDisplayChange(wParam, lParam, msg, hwnd) {
    ; DEBOUNCE: Starts a 1s countdown. Resets if spammed.
    SetTimer(UpdateScaling, -1000)
}

OnPowerBroadcast(wParam, lParam, msg, hwnd) {
    if (wParam == 0x0004) { ; Going to Sleep
        if (MonitorGetCount() > 1) {
            try RunWait(ToolPath " " TravelSize " " LaptopID, , "Hide")
        }
    }
    if (wParam == 0x0007 or wParam == 0x0012) { ; Waking Up
        ; DEBOUNCE: Starts a 1.2s countdown to let hardware wake up.
        SetTimer(UpdateScaling, -1200)
    }
}

OnShutdown(wParam, lParam, msg, hwnd) {
    if (MonitorGetCount() > 1) { ; Shutting down
        try RunWait(ToolPath " " TravelSize " " LaptopID, , "Hide")
    }
    return true
}

UpdateScaling() {
    global lastMonitorCount
    
    ; Wrap the entire check in a 'try' block. If Windows throws a missing monitor error 
    ; during a wild display transition, the script catches it and survives.
    try {
        monitorCount := MonitorGetCount()

        if (monitorCount != lastMonitorCount) {
            if (monitorCount > 1) {
                ; EXTEND MODE (Both screens active)
                try Run(ToolPath " " DeskSize " " LaptopID, , "Hide")
            } else {
                ; SINGLE SCREEN MODE (Travel OR Second Screen Only)
                ; Measure the width of the currently active Monitor 1
                MonitorGet(1, &Left, &Top, &Right, &Bottom)
                currentWidth := Right - Left

                ; Only apply the 200% scaling if the width matches the laptop's fingerprint
                if (currentWidth == LaptopWidth) {
                    try Run(ToolPath " " TravelSize " " LaptopID, , "Hide")
                }
            }
            lastMonitorCount := monitorCount
        }
    }
}

; Manual Override Hotkey (Ctrl + Alt + S)
^!s:: {
    global lastMonitorCount := 0 
    UpdateScaling()              
}
#Requires AutoHotkey v2
#Warn
SetWorkingDir(A_ScriptDir)
DetectHiddenWindows(false)
SetTitleMatchMode(2)            ; 1=start, 2=substring, 3=exact, "RegEx"=regex
CoordMode("Mouse", "Screen")

; ========= הגדרות =========
gap  := 8                        ; ריווח בין חלונות (px)
edge := 8                        ; שוליים חיצוניים (px)
minW := 320                      ; סינון חלונות קטנים מדי (רוחב)
minH := 200                      ; סינון חלונות קטנים מדי (גובה)

; חלונות/תהליכים שלא נרצה לפרוס
excludeExe := Map(
    "ApplicationFrameHost.exe", true,
    "SearchUI.exe",             true,
    "TextInputHost.exe",        true,
    "ShellExperienceHost.exe",  true
)
excludeClass := Map(
    "Shell_TrayWnd",              true,
    "Shell_SecondaryTrayWnd",     true,
    "TaskListThumbnailWnd",       true,
    "Windows.UI.Core.CoreWindow", true
)
excludeTitleSubstrings := ["Task Switching", "Settings", "Open File", "Save As"]

; רשימת חריגות זמנית (טוגל) לפי HWND
global toggleSkip := Map()       ; key="HWND" (string) -> true

; ========= הודעת פתיחה קצרה =========
vW := SysGet(78), vH := SysGet(79)
winsCount := WinGetList().Length
MsgBox(Format("Virtual screen: {}×{}`r`nOpen windows: {}", vW, vH, winsCount))

; ========= קיצורי דרך =========
; Esc — יציאה
Esc:: {
    ExitApp()
}

; Ctrl+Alt+T — פריסה עכשיו
^!t:: {
    TileAllVisible()
}

; Ctrl+Alt+R — שחרור מקסימום לכולם + פריסה
^!r:: {
    NormalizeAll()
    TileAllVisible()
}

; Ctrl+Alt+X — הוספה/הסרה של החלון הפעיל לרשימת דילוג זמנית
^!x:: {
    hwnd := WinExist("A")
    if !hwnd
        return
    key := String(hwnd)
    if toggleSkip.Has(key) {
        toggleSkip.Delete(key)
        Toast("Removed from skip list")
    } else {
        toggleSkip[key] := true
        Toast("Added to skip list")
    }
}

; ========= פונקציות =========
TileAllVisible() {
    global gap, edge, minW, minH, excludeExe, excludeClass, excludeTitleSubstrings, toggleSkip

    ; שטח העבודה הווירטואלי (כל המסכים)
    vLeft   := SysGet(76)  ; SM_XVIRTUALSCREEN
    vTop    := SysGet(77)  ; SM_YVIRTUALSCREEN
    vWidth  := SysGet(78)  ; SM_CXVIRTUALSCREEN
    vHeight := SysGet(79)  ; SM_CYVIRTUALSCREEN

    wins := []
    for hwnd in WinGetList() {

        if toggleSkip.Has(String(hwnd))
            continue

        title := WinGetTitle("ahk_id " . hwnd)
        if (title = "")
            continue

        mm := WinGetMinMax("ahk_id " . hwnd)
        if (mm = -1) ; ממוזער
            continue

        exStyle := WinGetExStyle("ahk_id " . hwnd)
        if (exStyle & 0x00000080) ; WS_EX_TOOLWINDOW
            continue

        winClass := WinGetClass("ahk_id " . hwnd)
        if excludeClass.Has(winClass)
            continue

        winProc := WinGetProcessName("ahk_id " . hwnd)
        if excludeExe.Has(winProc)
            continue

        skip := false
        for s in excludeTitleSubstrings {
            if InStr(title, s) {
                skip := true
                break
            }
        }
        if skip
            continue

        if (winClass = "Progman" or winClass = "WorkerW")
            continue

        x:=0, y:=0, w:=0, h:=0
        WinGetPos(&x, &y, &w, &h, "ahk_id " . hwnd)
        if (w < minW or h < minH)
            continue

        wins.Push(hwnd)
    }

    count := wins.Length
    if (count = 0) {
        Toast("No windows to tile")
        return
    }

    ; חישוב גריד
    cols := Ceil(Sqrt(count))
    rows := Ceil(count / cols)

    areaX := vLeft  + edge
    areaY := vTop   + edge
    areaW := vWidth - (edge*2)
    areaH := vHeight- (edge*2)

    cellW := Floor((areaW - gap*(cols-1)) / cols)
    cellH := Floor((areaH - gap*(rows-1)) / rows)

    ; הזזה/שינוי גודל
    i := 0
    for hwnd in wins {
        r := Floor(i / cols)
        c := Mod(i, cols)

        x := areaX + c * (cellW + gap)
        y := areaY + r * (cellH + gap)
        w := cellW
        h := cellH

        if (WinGetMinMax("ahk_id " . hwnd) = 1)
            WinRestore("ahk_id " . hwnd)

        try WinMove(x, y, w, h, "ahk_id " . hwnd)
        catch {
            ; מתעלם משגיאות נקודתיות
        }
        i++
    }

    Toast(Format("Tiled {} window(s) in {}×{}", count, rows, cols))
}

NormalizeAll() {
    for hwnd in WinGetList() {
        if (WinGetMinMax("ahk_id " . hwnd) = 1) {
            WinRestore("ahk_id " . hwnd)
        }
    }
}

Toast(msg, ms := 1200) {
    ToolTip(msg)
    SetTimer(() => ToolTip(), -ms)
}

; This entire line is a comment.
; dash | %USERPROFILE%\AppData\Local\Programs\AutoHotkey\UX\AutoHotkeyUX.exe "ui-dash.ahk"
; WindowSpy | %USERPROFILE%\AppData\Local\Programs\AutoHotkey\UX\AutoHotkeyUX.exe "WindowSpy.ahk"
; https://www.autohotkey.com/docs/v2/lib/WinMove.htm
; WinMove X, Y, Width, Height, WinTitle, WinText, ExcludeTitle, ExcludeText
; 
; MyWinTitle := "Command & Conquer (TM) Generals Zero Hour"
;if WinExist(MyWinTitle)
;{
;	WinActivate ; Use the window found by WinExist.
;	WinMove 100, 100, 1600 , 1024, MyWinTitle
;	; multiplier button = 1200 300
;	MouseMove, 1200, 300, 50 
;}
; ======= set =======
#Warn  ; Enable warnings to assist with detecting common errors.
SetWorkingDir A_ScriptDir  ; Forces the script to use the folder it was initially launched from as its working directory.
; ======= Get Screen Size =======
VirtualScreenWidth := SysGet(78)
VirtualScreenHeight := SysGet(79)
; ======= Start message =======
msg := "screen size: "
msg := msg "`r`n"
msg := msg VirtualScreenWidth " x " VirtualScreenHeight
msg := msg "`r`n"
MsgBox(msg)
; ======= Main =======
MainLabel:
MyWinTitle := "Command Prompt"
if WinExist(MyWinTitle)
	WinMove 100, 100, 100, 512, MyWinTitle
MyWinTitle := "смотреть онлайн" 
if WinExist(MyWinTitle)
	WinMove 1345 , 18 , 1192 , 672, MyWinTitle
MyWinTitle := "YouTube"
if WinExist(MyWinTitle)
	WinMove 1353 , 789 , 1201 , 596, MyWinTitle
MyWinTitle := "ישראל נלחמת"
if WinExist(MyWinTitle)
	WinMove 1659 , 699 , 886 , 660, MyWinTitle
;else
;	Run, chrome.exe "https://www.youtube.com/watch?v=JpS383vI1_I" " --new-window "
;{
;	
; 	
;}


; AHK | Error: Target window not found.
; AHK | ahk see if WinTitle exist | WinExist(WinTitle, WinText, ExcludeTitle, ExcludeText)
; AHK | open web page
; Run, chrome.exe "https://www.youtube.com/watch?v=JpS383vI1_I" " --new-window "
Esc::ExitApp  ; Pres Esc to get here
^!m::my_func()
my_func()
{
	MsgBox("secret key")
	Click "Down Right"
	
}


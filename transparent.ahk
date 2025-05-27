;250528 
; some ref from google
^!RButton::
MakeAllWindowsTransparent:
WinGet, idList, List
Loop, %idList%
{
    this_id := idList%A_Index%
    WinGet, currentTransparency, Transparent, ahk_id %this_id%
    if (currentTransparency = OFF)
    {
        WinSet, Transparent, 220, ahk_id %this_id%
    }
	else
	{
		WinSet, Transparent, OFF, ahk_id %this_id%
	}
}
return
Esc::ExitApp  ; Pres Esc to get here

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 3
IfWinNotExist, SMM_WE
{
Msgbox, Don't you need SMM_WE open to copy somethin' in it?`n go open it and then try again...
Exitapp
}

SetKeyDelay, -100
SetMouseDelay, 50
SetBatchLines, -1
Listlines, off
if (!FileExist("Snap.dll"))
{
	FileInstall, Snap.dll, Snap.dll, 1
}
CoordMode, mouse, screen
Menu, Tray, NoStandard
Menu, Tray, Add, Recapture SMM_WE,reload
Menu, Tray, Add
Menu, Tray, Add, Exit SMM_WE copy, exitapp

IfExist, Image.png
{
FileDelete, Image.png
}


WinGet, pid, PID, SMM_WE ; Get the PID of the window with the exact title "SMM_WE"

WinGetPos, GUI_X, GUI_Y, GUI_W, GUI_H, SMM_WE
If (GUI_W = A_ScreenWidth && GUI_H = A_ScreenHeight) {
notfullscreen := false
fullscreen := true
} else {
notfullscreen := true
fullscreen := false
}










Run, snap.dll -save "$appdir$\Image.png" -capturepid %pid% -exit, , Hide

Loop
{
    IfExist, %A_ScriptDir%\Image.png
        break
    Sleep, 100
}

WinGetPos, GUI_X, GUI_Y, GUI_W, GUI_H, SMM_WE
Gui, +LastFound -Caption -Border +ToolWindow +AlwaysOnTop +E0x20 
Gui, Add, Picture, vBP x0 y0, Image.png
Gui, Show, x0 y0 w0 h0, SMM_WECopy
WinSet, TransColor, f0f0f0 100
sleep, 2
If (notfullscreen) {
GUI_X += 7
}
If (fullscreen) {
WinMinimizeAll
}
Gui, Show, x%GUI_X% y%GUI_Y% w%GUI_W% h%GUI_H%, SMM_WECopy

sleep, 500
IfWinNotActive, SMM_WE
{
WinActivate, SMM_WE
}



Settimer, ONTOPORNOT, 100
Loop
{
WinGetPos, GUI_X, GUI_Y, GUI_W, GUI_H, SMM_WE
If (notfullscreen) {
GUI_X += 7
}
WinMove, %GUI_X%, %GUI_Y%
}

ONTOPORNOT:
IfWinNotExist, SMM_WE
{
Exitapp
}
IfWinActive, SMM_WE
{
WinSet, AlwaysOnTop, On, SMM_WECopy
WinSet, Top,, SMM_WECopy
}
IfWinNotActive, SMM_WE
{
WinSet, AlwaysOnTop, Off, SMM_WECopy
WinSet, Bottom,, SMM_WECopy
}
return

#IfWinActive, SMM_WE
reload:
^c::
reload
esc::
exitapp:
ExitApp
#If

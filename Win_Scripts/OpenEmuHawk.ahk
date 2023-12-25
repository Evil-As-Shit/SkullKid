#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
IfWinExist, ahk_exe EmuHawk.exe
{
	WinSet, AlwaysOnTop, On, ahk_exe EmuHawk.exe
	WinActivate, ahk_exe EmuHawk.exe
}
IfWinNotExist, ahk_exe EmuHawk.exe
{
	Run C:\SkullKid\EmuHawk\EmuHawk.exe
	WinWaitActive, ahk_exe EmuHawk.exe
	;Send, !{ENTER}
	WinSet, AlwaysOnTop, On, SkullKidGame (DEBUG)
	WinActivate, SkullKidGame (DEBUG)
	WinWaitActive, SkullKidGame (DEBUG)
}
return

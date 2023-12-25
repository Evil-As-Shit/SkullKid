#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
c::
IfWinNotExist, SkullKidGame (DEBUG)
{
Send, c
ExitApp
}

WinActivate, SkullKidGame (DEBUG)
Send, p
return

a::
IfWinNotExist, SkullKidGame (DEBUG)
{
Send, a
ExitApp
}

WinActivate, SkullKidGame (DEBUG)
Send, o
return

b::
IfWinNotExist, SkullKidGame (DEBUG)
{
Send, b
ExitApp
}

WinActivate, SkullKidGame (DEBUG)
Send, y
return
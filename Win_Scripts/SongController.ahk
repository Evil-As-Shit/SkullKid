#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance [Ignore]

Esc::
WinClose, SkullKidGame (DEBUG)
ExitApp

c::
WinActivate, SkullKidGame (DEBUG)
Send, p
return

a::
WinActivate, SkullKidGame (DEBUG)
Send, o
return

b::
WinActivate, SkullKidGame (DEBUG)
Send, y
return
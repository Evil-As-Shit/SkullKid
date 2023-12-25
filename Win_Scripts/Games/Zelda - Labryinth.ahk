#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Run, "C:\SkullKid\Roms\The Legend of Zelda.nes"
WinWaitActive, ahk_exe EmuHawk.exe
Send {F2}
return
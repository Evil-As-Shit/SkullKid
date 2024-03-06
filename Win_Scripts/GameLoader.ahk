SendMode Input
SetWorkingDir %A_ScriptDir%
Send {F3}
Sleep,200
WinActivate, ahk_exe EmuHawk.exe
return
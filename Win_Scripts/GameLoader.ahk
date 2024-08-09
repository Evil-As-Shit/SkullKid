SendMode Input
SetWorkingDir %A_ScriptDir%
Run, C:/SkullKid/Roms/Super Smash Bros.n64
sleep, 1000
Send {F1}
sleep, 300
WinActivate, ahk_exe EmuHawk.exe
return
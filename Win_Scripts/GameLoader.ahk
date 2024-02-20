SendMode Input
SetWorkingDir %A_ScriptDir%
Run, C:/SkullKid/Roms/Link's Awakening.gbc
sleep, 1000
Send {F3}
sleep, 300
WinActivate, ahk_exe EmuHawk.exe
return
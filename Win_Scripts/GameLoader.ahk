SendMode Input
SetWorkingDir %A_ScriptDir%
Run, C:/SkullKid/Roms/Karnov.nes
sleep, 1000
Send {F2}
sleep, 300
WinActivate, ahk_exe EmuHawk.exe
return
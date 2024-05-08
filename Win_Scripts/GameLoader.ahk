SendMode Input
SetWorkingDir %A_ScriptDir%
Run, C:/SkullKid/Roms/The Legend of Zelda.nes
sleep, 1000
Send {F3}
sleep, 300
WinActivate, ahk_exe EmuHawk.exe
return
SendMode Input
SetWorkingDir %A_ScriptDir%
Run, C:/SkullKid/Roms/Castlevania 3 - Dracula's Curse.nes
sleep, 1000
Send {F1}
sleep, 300
WinActivate, ahk_exe EmuHawk.exe
return
SendMode Input
SetWorkingDir %A_ScriptDir%
Run, C:\SkullKid\Roms\The Legend of Zelda.nes
WinWaitActive, ahk_exe EmuHawk.exe
Send {F4}
return
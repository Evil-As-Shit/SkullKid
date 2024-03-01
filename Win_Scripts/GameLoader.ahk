SendMode Input
SetWorkingDir %A_ScriptDir%
Run, C:/SkullKid/Roms/SuperMarioSunshine.iso,,Min
WinWaitActive, ahk_exe Dolphin.exe
sleep, 1000
Send, {F2 down}
sleep 10
Send, {F2 up}
return
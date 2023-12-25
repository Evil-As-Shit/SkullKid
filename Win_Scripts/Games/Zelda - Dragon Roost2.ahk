SendMode Input
SetWorkingDir %A_ScriptDir%
Run, C:\SkullKid\Roms\ZeldaWindWaker.iso
WinWaitActive, Dolphin 5.0-16627 | JIT64 DC
Send, {F1 down}
sleep 10
Send, {F1 up}
WinSet, AlwaysOnTop, On, Dolphin 5.0-16627 | JIT64 DC
WinActivate, Dolphin 5.0-16627 | JIT64 DC
return
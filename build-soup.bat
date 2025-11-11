@echo off

:: Make sure to change the DOSBox path to your own DOSBox Installation folder

F:\DOSBox\DOSBox-0.74-3\DOSBox.exe exit -noconsole -conf "DOSBoxConf.txt"

IF EXIST SPS_Build.md move /Y SPS_Build.bin SPS_Build.SkillIssue.bin >NUL
CD Source
..\Assembler\asm68k /m /k /p /o ae- s2.asm, ..\SPS_Build.bin, , ..\s2.lst
..\Assembler\fixheadr.exe ..\SPS_Build.bin

pause

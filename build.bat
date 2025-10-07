@echo off

IF EXIST SPS_Build.bin move /Y SPS_Build.bin SPS_Build.prev.bin >NUL
CD Source
..\Assembler\asm68k /m /k /p /o ae- s2.asm, ..\SPS_Build.bin, , ..\s2.lst
..\Assembler\fixheadr.exe ..\SPS_Build.bin
pause
@echo off

..\..\..\Assembler\asm68k /m /p /k /o ae- build.asm, logodata.bin , , .debug.lst
"C:\Program Files\7-Zip\7z.exe" a -tzip "logodata.zip" "logodata.bin"
pause
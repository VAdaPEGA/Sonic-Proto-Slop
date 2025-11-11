@echo off

ECHO Assembling...
..\..\Assembler\wla-6502.exe -vio SWAP.ASM SWAP.o > build_report.txt

IF %ERRORLEVEL% NEQ 0 GOTO assemble_fail
IF NOT EXIST SWAP.o GOTO assemble_fail

ECHO Linking...
..\..\Assembler\wlalink -rs link.txt SWAP.BIN
IF %ERRORLEVEL% NEQ 0 GOTO link_fail

ECHO ==========================
ECHO Build Success.
ECHO ==========================

GOTO end

:assemble_fail
ECHO Error while assembling.
GOTO fail
:link_fail
ECHO Error while linking.
:fail

ECHO ==========================
ECHO Build failure.
ECHO ==========================

:end

pause
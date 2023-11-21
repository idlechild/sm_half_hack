@echo off

if "%1" equ "" echo Specify assembly to build
if "%1" equ "" goto done
if not exist src\%1.asm echo Assembly not found
if not exist src\%1.asm goto done

echo Building %1
if not exist build mkdir build
cd resources
python create_dummies.py 00.sfc ff.sfc

copy *.sfc ..\build
..\tools\asar.exe --no-title-check --symbols=wla --symbols-path=..\build\%1.sym ..\src\%1.asm ..\build\00.sfc
..\tools\asar.exe --no-title-check --symbols=wla --symbols-path=..\build\%1.sym ..\src\%1.asm ..\build\ff.sfc
python create_ips.py ..\build\00.sfc ..\build\ff.sfc ..\build\%1.ips
python dos_to_unix.py ..\build\%1.sym
python sort_debug_symbols.py ..\build\%1.sym ..\build\%1_Sorted.sym ..\build\%1_Combined.sym

del 00.sfc ff.sfc ..\build\00.sfc ..\build\ff.sfc
cd ..

:done
@echo on

@echo off
cls

if "%1" equ "" echo Specify assembly to build
if "%1" equ "" goto done
if not exist src\%1.asm echo Assembly not found
if not exist src\%1.asm goto done

if "%2" equ "" set sfc_src=build\Super Metroid NTSC.sfc
if "%2" equ "" echo Building %1
if "%2" equ "" goto building
set sfc_src=build\%2.sfc
echo Building %1 for %2

:building
if not exist "%sfc_src%" echo Cannot find source to patch (%sfc_src%)
if not exist "%sfc_src%" goto done
if not exist build mkdir build
if exist build\%1.ips del build\%1.ips
if exist build\%1.sfc del build\%1.sfc
cd resources
python create_dummies.py 00.sfc ff.sfc

copy *.sfc ..\build
..\tools\asar.exe --no-title-check --symbols=wla --symbols-path=..\build\%1.sym ..\src\%1.asm ..\build\00.sfc
if ERRORLEVEL 1 goto end_build
..\tools\asar.exe --no-title-check --symbols=wla --symbols-path=..\build\%1.sym ..\src\%1.asm ..\build\ff.sfc
python create_ips.py ..\build\00.sfc ..\build\ff.sfc ..\build\%1.ips
python dos_to_unix.py ..\build\%1.sym
python sort_debug_symbols.py ..\build\%1.sym ..\build\%1_Sorted.sym ..\build\%1_Combined.sym
:end_build

del 00.sfc ff.sfc ..\build\00.sfc ..\build\ff.sfc
cd ..
if not exist build\%1.ips goto done
copy "%sfc_src%" build\%1.sfc
"tools\Lunar IPS.exe" -ApplyIPS build\%1.ips build\%1.sfc

:done
@echo on

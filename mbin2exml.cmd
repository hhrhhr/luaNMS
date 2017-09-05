@echo off

set MBIN=d:\Users\user\Documents\GitHub\luaNMS\bin\MBINCompiler.exe
set NMSU=d:\tmp\nms_unpacked

for /r %NMSU%\LANGUAGE %%i in (*.MBIN) do (
    echo %%i
    rem %MBIN% "%%i"
)
for /r %NMSU%\METADATA\REALITY\TABLES %%i in (*.MBIN) do (
    echo %%i
    %MBIN% "%%i"
)

 

:eof
set MBIN=
set NMSU=
pause

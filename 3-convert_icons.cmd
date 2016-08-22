@echo off
setlocal enabledelayedexpansion

set UNP=d:\tmp\NMS_unpacked\
set NVD=E:\soft\tools\NVIDIA Texture Tools 2\bin\nvdecompress.exe
set IM=convert.exe

if not exist img mkdir img

for /f %%i in (icons_list.txt) do (
    set fp=%UNP%%%i
    set tga=!fp:~,-4!.tga
    set fn=%%~ni.png
    echo !fp!...
    "%NVD%" "!fp!"
    "%IM%" "!tga!" -resize 64x64 "img\!fn!"
    del "!tga!"
)

for /f %%i in (icons_list2.txt) do (
    set fp=%UNP%%%i
    set tga=!fp:~,-4!.tga
    set fn=%%~ni.png
    echo !fp!...
    "%NVD%" "!fp!"
    "%IM%" "!tga!" -resize 64x64 "img\!fn!"
    del "!tga!"
)
@echo off
setlocal enabledelayedexpansion

set UNP=d:\tmp\NMS_unpacked\
set IM=magick convert
set PN=pngquant

if not exist docs mkdir docs
if not exist docs\img mkdir docs\img

for /f %%i in (icons_list.txt) do (
    set fp=%UNP%%%i
    set fn=%%~ni.png
    echo !fp!
    %IM% "!fp!" -resize 64x64 "docs\img\!fn!"
    %PN% --strip -f --ext .png "docs\img\!fn!"
)

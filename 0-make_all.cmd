@echo off
setlocal enabledelayedexpansion

if %1.==. (set LANG=) else (set LANG=%1)

set NMSU=d:\tmp\nms_unpacked
set WORK=.\tmp
set IM=magick convert
set IMM=magick montage
set PN=pngquant


if not exist %WORK% mkdir %WORK%
if not exist docs mkdir docs

:step1
lua 1-generate_lang.lua %NMSU% %WORK%

:step2
lua 2_make_html.lua %NMSU% %WORK% %LANG%

:step3_1
for /f %%i in (%WORK%\_icons_list.txt) do (
    set fp=%NMSU%\%%i
    set fn=%%~ni.png
    echo !fp!
    %IM% "!fp!" -resize 64x64 "%WORK%\!fn!"
)

:step3_2
rem rem. > %WORK%\sprites.css
set /a x=1
set /a y=0

for /f %%i in (%WORK%\_icons_list.txt) do (
    set css_name=%%~ni
    set css_name=!css_name:.=\.!

    set /a xx=!x! * 64
    set /a yy=!y! * 64
    rem echo .!css_name! { background-position: -!xx!px -!yy!px; } >> %WORK%\sprites.css
    echo .!css_name! { background-position: -!xx!px -!yy!px; } >> %WORK%\style.css

    set /a x+=1
    if !x! equ 16 set /a x=0 && set /a y+=1
)

:step3_3
pushd %work%
set files=
for /f %%i in (_icons_list.txt) do (
    set files=!files! %%~ni.png
)
%IMM% -size 64x64 xc:transparent %files% -tile 16x24 -geometry 64x64+0+0 -background transparent _sprites.png
popd

:step3_4
%PN% --strip -f -v -s1 %WORK%\_sprites.png -o %WORK%\sprites.png

:step4
move %WORK%\*.html docs
move %WORK%\style.css docs
move %WORK%\sprites.png docs


:eof
setlocal disabledelayedexpansion

@echo off

rem config start
set NMSU=d:\tmp\nms_unpacked
set WORK=.\tmp
set DOCS=.\docs

set IM=magick convert
set IMM=magick montage
set LUA=.\bin\lua
set PN=.\bin\pngquant
set ICON_SZ=64
rem config end

setlocal enabledelayedexpansion
if %1.==. (set LANG=) else (set LANG=%1)
if not exist %WORK% mkdir %WORK%
if not exist %DOCS% mkdir %DOCS%


:step1
if exist %WORK%\_lang.lua goto step2
echo step1
%LUA% 1-generate_lang.lua %NMSU% %WORK%
if not exist %WORK%\_lang.lua @echo step1 ERR && goto eof


:step2
if exist %WORK%\_icons_list.txt goto step3_2
echo step2
%LUA% 2-make_html.lua %NMSU% %WORK% %LANG%
if not exist %WORK%\_icons_list.txt @echo step2 ERR && goto eof


:step3_1
echo step3_1
for /f %%i in (%WORK%\_icons_list.txt) do (
    set fp=%NMSU%\%%i
    set fn=%%~ni.png
    rem echo !fp!
    %IM% "!fp!" -resize %ICON_SZ%x%ICON_SZ% "%WORK%\!fn!"
)


:step3_2
echo step3_2
set /a x = 1
set /a y = 0

set /a TILE_N = 1
for /f %%i in (%WORK%\_icons_list.txt) do set /a TILE_N+=1
if %TILE_N% leq 1 @echo step3_2 ERR1 && goto eof

rem count square ;)
set /a n = 0
:step3_2_1
set /a n += 1
set /a nn = %n% * %n%
if %TILE_N% gtr %nn% goto step3_2_1
set TILE_N=%n%

echo generate %TILE_N%x%TILE_N% texture atlas 

if %TILE_N% leq 1 @echo step3_2 ERR2 && goto eof

for /f %%i in (%WORK%\_icons_list.txt) do (
    set css_name=%%~ni
    set css_name=!css_name:.=\.!

    set /a xx = !x! * %ICON_SZ%
    set /a yy = !y! * %ICON_SZ%
    echo .!css_name! { background-position: -!xx!px -!yy!px; } >> %WORK%\style.css

    set /a x += 1
    if !x! equ %TILE_N% set /a x = 0 && set /a y += 1
)


:step3_3
echo step3_3
pushd %work%
rem. > _filenames.txt
for /f %%i in (_icons_list.txt) do (
    echo %%~ni.png>> _filenames.txt
)
%IMM% -size %ICON_SZ%x%ICON_SZ% xc:transparent @_filenames.txt -tile %TILE_N%x%TILE_N% -geometry %ICON_SZ%x%ICON_SZ%+0+0 -background transparent _sprites.png
popd


:step3_4
echo step3_4
%PN% --strip -f -v -s1 --nofs %WORK%\_sprites.png -o %WORK%\sprites.png


:step4
echo step4
move %WORK%\*.html %DOCS% >NUL
move %WORK%\style.css %DOCS% >NUL
move %WORK%\sprites.png %DOCS% >NUL


:eof
echo done
setlocal disabledelayedexpansion
pause

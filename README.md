# luaNMS

[ready multi-lingual game database](https://hhrhhr.github.io/luaNMS/)

## used tools
* monkeyman192/MBINCompiler
* Lua 5.3
* LuaDist/luaxml
* ImageMagick
* pngquant

## process
1. unpack these files retaining the directory structure
* `...\NMSARC.86055253.pak\LANGUAGE\NMS_*.MBIN`
* `...\NMSARC.515F1D3.pak\METADATA\REALITY\TABLES\NMS_REALITY_*.MBIN`
* `...\NMSARC.552FA799.pak\TEXTURES\UI\FRONTEND\ICONS\*.DDS`
2. prepare utils
3. edit `0-make_all.cmd` (specify the working and temporary directories, paths to utilities) and run it

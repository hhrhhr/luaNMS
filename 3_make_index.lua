assert("Lua 5.3" == _VERSION)

langcode = {
    "English",
    "French",
    "Italian",
    "German",
    "Spanish",
    "Russian",
    "Polish",
    "Dutch",
    "Portuguese",
    "LatinAmericanSpanish",
    "BrazilianPortuguese",
    "SimplifiedChinese",
    "TraditionalChinese",
    "Korean",
    "Japanese",
    "USEnglish"
}

--[[ index.html ]]-------------------------------------------------------------

io.write("write index.html... ")
html = assert(io.open("index.html", "w+"))

html:write([[
<html>
<head>
<link rel="stylesheet" href="style.css">
<body>
]])

html:write("<ul>")

for i = 1, #langcode do
    local l = langcode[i]
    html:write("<li><a href='index_" .. i .. ".html'>" .. l .. "</a></li>")
end

html:write("</ul>")

html:write("</body>\n")
html:close()

print("OK")

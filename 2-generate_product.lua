assert("Lua 5.3" == _VERSION)

L = 2 -- lang code, 1 - EN, 2 - RU...

local in_file = assert(arg[1], "\nno input\n\n")
xml = require("LuaXML")
local x = xml.load(in_file)

assert("GcProductTable" == x.template)

local product = {}
local id = {}

local icons = assert(io.open("icons_list.txt", "w+"))

local x1 = x[1]
for i = 1, #x1 do
    assert("GcProductData" == x1[i].template)
    local x2 = x1[i]

    local j = x2[1].value
    table.insert(id, j)
    product[j] = {}
    
    local p = product[j]
    p.name = x2[3].value
    p.cost = x2[8].value
    
    p.icon = x2[10][1].value
    icons:write(string.gsub(p.icon, "/", "\\") .. "\n")
    
    p.rarity = x2[14][1].value
    p.charge = x2[17].value

    p.craft = {}
    if #x2[18] > 0 then
        for j = 1, #x2[18] do
            local item = x2[18][j][1].value
            local count = x2[18][j][3].value
            table.insert(p.craft, {item, count})
        end
    end
end
icons:close()
x = nil


table.sort(id)
local html = assert(io.open("product.html", "w+"))
dofile("_lang.lua")


html:write([[
<html>
<head>
<style type="text/css">
   table { border-collapse: collapse; }
   td, th { padding: 0.3em; border: 1px solid; }
</style>
<body>
<table>
<tr>
<th>название</th>
<th>иконка</th>
<th>цена</th>
<th>редкость</th>
<th>заряд</th>
<th>крафт</th>
</tr>
]])

local function get_icon_name(path)
    local s = string.match(path, "^.+/(.+)$")
    s = string.sub(s, 1, -5)
    s = "img/" .. s .. ".png"
    return s
end

for i = 1, #id do
    local k = id[i]
    local p = product[k]
    html:write("<tr>")

    html:write("<td id='" .. k .. "'>")
    html:write(k .. "<br />")
    html:write(lang[p.name][L])
    html:write("</td>")

    html:write("<td><img src='")
    html:write(get_icon_name(p.icon))
    html:write("' /></td>")

    html:write("<td>")
    html:write(p.cost)
    html:write("</td>")

    html:write("<td>")
    html:write(lang[string.upper(p.rarity)][L])
    html:write("</td>")

    html:write("<td>")
    html:write(p.charge)
    html:write("</td>")

    html:write("<td>")
    if #p.craft > 0 then
        html:write("<ul>")
        for i = 1, #p.craft do
            html:write("<li>")
            html:write(lang[p.craft[i][1] .. "_NAME_L"][L])
            html:write(" &times;" .. p.craft[i][2])
            html:write("</li>")
        end
        html:write("</ul>")
    end
    html:write("</td>")

    html:write("</tr>\n")
end

html:write("</table>\n")
html:write("</body>\n")

html:close()

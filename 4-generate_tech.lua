assert("Lua 5.3" == _VERSION)

L = 2 -- lang code, 1 - EN, 2 - RU...

local in_file = assert(arg[1], "\nno input\n\n")
xml = require("LuaXML")
local x = xml.load(in_file)

assert("GcTechnologyTable" == x.template)

local tech = {}
local idx = {}
local icon = {}

local x1 = x[1]
for i = 1, #x1 do
    assert("GcTechnology" == x1[i].template)
    local x2 = x1[i]

    local id = x2[1].value
    table.insert(idx, id)
    tech[id] = {}

    local t = tech[id]
    t.name = x2[3].value
    t.teach = x2[6].value

    t.icon = x2[9][1].value
    table.insert(icon, x2[9][1].value)

    t.level = x2[11].value
    t.chargeable = x2[12].value
    t.chargeamount = x2[13].value
    t.subcat = x2[14][1].value

    t.chargeby = {}
    for j = 1, #x2[15] do
        table.insert(t.chargeby, x2[15][j][1].value)
    end
    t.buildcharged = x2[16].value
    t.upgrade = x2[17].value
    t.core = x2[18].value
    t.techcat = x2[19][1].value
    t.rarity = x2[20][1].value
    t.value = x2[21].value

    t.craft = {}
    if #x2[22] > 0 then
        for j = 1, #x2[22] do
            local item = x2[22][j][1].value
            local count = x2[22][j][3].value
            table.insert(t.craft, {item, count})
        end
    end

    t.bonus = {}
    if #x2[23] > 0 then
        for j = 1, #x2[23] do
            local item = x2[23][j][1][1].value
            local typ = x2[23][j][2].value
            local count = x2[23][j][3].value
            table.insert(t.bonus, {item, typ, count})
        end
    end

    t.reqtech = x2[24].value
    t.reqlevel = x2[25].value
    t.rewardgroup = x2[28].value

end
x = nil



table.sort(icon)
local icon_uniq = {}
local icon_old = ""
for i = 1, #icon do
    local icon_cur = icon[i]
    if icon_old ~= icon_cur then
        table.insert(icon_uniq, icon_cur)
        icon_old = icon_cur
    end
end
icon = nil

local icons = assert(io.open("icons_list2.txt", "w+"))
for i = 1, #icon_uniq do
    icons:write(string.gsub(icon_uniq[i], "/", "\\") .. "\n")
end
icons:close()



--os.exit()


table.sort(idx)
local html = assert(io.open("tech.html", "w+"))
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
<th>заряд</th>
<th>чем заряжать</th>
<th>тип</th>
<th>редкость</th>
<th>крафт</th>
<th>бонусы</th>
</tr>
]])

local function get_icon_name(path)
    local s = string.match(path, "^.+/(.+)$")
    s = string.sub(s, 1, -5)
    s = "img/" .. s .. ".png"
    return s
end

for i = 1, #idx do
    local k = idx[i]
    local t = tech[k]
    html:write("<tr>")

    html:write("<td id='" .. k .. "'>")
    html:write(k .. "<br />")
    html:write(lang[t.name][L])
    html:write("</td>")

    html:write("<td><img src='")
    html:write(get_icon_name(t.icon))
    html:write("' /></td>")

--[[
    html:write("<!td>")
    html:write(t.teach)
    html:write("</td>")

    html:write("<!td>")
    html:write(t.level)
    html:write("</td>")

    html:write("<!td>")
    html:write(t.chargeable)
    html:write("</td>")
--]]
    html:write("<td>")
    html:write(t.chargeamount)
    html:write("</td>")

    html:write("<td>")
    if #t.chargeby > 0 then
        html:write("<ul>")
        for i = 1, #t.chargeby do
            html:write("<li>")
            local item = t.chargeby[i]
            if lang[item .. "_NAME_L"] then
                item = lang[item .. "_NAME_L"][L]
            end

            html:write(item)
            html:write("</li>")
        end
        html:write("</ul>")
    end
    html:write("</td>")

--[[
    html:write("<td>")
    html:write(t.buildcharged)
    html:write("</td>")

    html:write("<td>")
    html:write(t.upgrade)
    html:write("</td")

    html:write("<td>")
    html:write(t.core)
    html:write("</td>")
--]]

    html:write("<td>")
    html:write(t.techcat)
    html:write("</td>")

    html:write("<td>")
    html:write(t.rarity)
    html:write("</td>")

--[[
    html:write("<!td>")
    html:write(t.value)
    html:write("</td>")
--]]

    html:write("<td>")
    if #t.craft > 0 then
        html:write("<ul>")
        for i = 1, #t.craft do
            html:write("<li>")
            local item = t.craft[i][1]
            if lang[item .. "_NAME_L"] then
                item = lang[item .. "_NAME_L"][L]
            end

            html:write(item)
            html:write(" &times;" .. t.craft[i][2])
            html:write("</li>")
        end
        html:write("</ul>")
    end
    html:write("</td>")
    
    html:write("<td>")
    if #t.bonus > 0 then
        html:write("<ul>")
        for i = 1, #t.bonus do
            html:write("<li>")
            html:write(t.bonus[i][1] .. " => ")
            html:write(t.bonus[i][2] .. " (+")
            html:write(t.bonus[i][3] .. ")")
            html:write("</li>")
        end
        html:write("</ul>")
    end
    html:write("</td>")

--[[
    html:write("<!td>")
    html:write(t.reqtech)
    html:write("</td>")

    html:write("<td>")
    html:write(t.reqlevel)
    html:write("</td>")
--]]

    html:write("</tr>\n")
end

html:write("</table>\n")
html:write("</body>\n")

html:close()

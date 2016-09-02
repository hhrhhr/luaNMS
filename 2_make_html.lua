assert("Lua 5.3" == _VERSION)

--[[
langcode = {
    ["English"] = 1,
    ["French"] = 2,
    ["Italian"] = 3,
    ["German"] = 4,
    ["Spanish"] = 5,
    ["Russian"] = 6,
    ["Polish"] = 7,
    ["Dutch"] = 8,
    ["Portuguese"] = 9,
    ["LatinAmericanSpanish"] = 10,
    ["BrazilianPortuguese"] = 11,
    ["SimplifiedChinese"] = 12,
    ["TraditionalChinese"] = 13,
    ["Korean"] = 14,
    ["Japanese"] = 15,
    ["USEnglish"] = 16
}
--]]

local in_dir = assert(arg[1], "\n\n[ERROR] no input\n\n")
local L = tonumber(arg[2]) or 1 -- lang code

xml = require("LuaXml")

local substance = {}
local product = {}
local technology = {}

local icon = {}
local x1

local function get_icon_name(path)
    local s = string.match(path, "^.+/(.+)$")
    s = string.sub(s, 1, -5)
    s = "img/" .. s .. ".png"
    return s
end

--[[ substance ]]--------------------------------------------------------------

local x = xml.load(in_dir .. "\\NMS_REALITY_GCSUBSTANCETABLE.exml")
assert("GcSubstanceTable" == x.template)

x1 = x[1]
for i = 1, #x1 do
    assert("GcSubstanceData" == x1[i].template)
    local x2 = x1[i]

    local t = {}
    t.Name          = x2[1].value
    t.NameLower     = x2[2].value
    t.Id            = x2[3].value
    t.Symbol        = x2[4].value
    t.Icon          = get_icon_name(x2[5][1].value)
    --              = x2[6][1].value
    t.Subtitle      = x2[7][1].value
    t.Description   = x2[8][1].value
    t.Colour = {}
    for i = 1, 4 do
        local c = x2[9][i].value
        c = string.gsub(c, ",", ".")
        c = tonumber(c) * 255
        c = math.floor(c)
        table.insert(t.Colour, c)
    end
    t.WorldColour = {}
    for i = 1, 4 do
        local c = x2[10][i].value
        c = string.gsub(c, ",", ".")
        c = tonumber(c) * 255
        c = math.floor(c)
        table.insert(t.WorldColour, c)
    end
    t.BaseValue     = x2[11].value
    t.SubstanceCategory = x2[12][1].value
    t.Rarity        = x2[13][1].value
    t.Legality      = x2[14][1].value
    t.ChargeValue   = x2[15].value
    -- 16 Cost
    local c = string.gsub(x2[17].value, ",", ".")    
    t.NormalisedValueOnWorld = tonumber(c)
    -- 18 NormalisedValueOffWorld

    local s = string.gsub(x2[5][1].value, "/", "\\")
    table.insert(icon, s)  -- for Win
--  table.insert(icon, x2[5][1].value))  -- for *Nix
    table.insert(substance, t)
end

print("substances: " .. #substance)


--[[ product ]]----------------------------------------------------------------

x = xml.load(in_dir .. "\\NMS_REALITY_GCPRODUCTTABLE.exml")
assert("GcProductTable" == x.template)

x1 = x[1]
for i = 1, #x1 do
    assert("GcProductData" == x1[i].template)
    local x2 = x1[i]

    local t = {}
    t.Id            = x2[1].value
    t.Name          = x2[2].value
    t.NameLower     = x2[3].value
    t.Subtitle      = x2[4][1].value
    t.Description   = x2[5][1].value
    t.Hint          = x2[6].value
    -- 7 DebrisFile
    t.BaseValue     = x2[8].value
    t.Level         = x2[9].value
    t.Icon          = get_icon_name(x2[10][1].value)
    t.Colour = {}
    for i = 1, 4 do
        local c = x2[11][i].value
        c = string.gsub(c, ",", ".")
        c = tonumber(c) * 255
        c = math.floor(c)
        table.insert(t.Colour, c)
    end
    t.SubstanceCategory = x2[12][1].value
    t.Category      = x2[13][1].value
    t.Rarity        = x2[14][1].value
    t.Legality      = x2[15][1].value
    t.Consumable    = x2[16].value
    t.ChargeValue   = x2[17].value
    t.Requirements  = {}
    if #x2[18] > 0 then
        for j = 1, #x2[18] do
            local Id     = x2[18][j][1].value
            local IType  = x2[18][j][2][1].value -- "Substance", "Product"
            local Amount = x2[18][j][3].value
            table.insert(t.Requirements, {Id, IType, Amount})
            -- print(Id, IType, Amount)
        end
    end
    -- 19 Cost
    -- 20 SpecificChargeOnly
    -- 21 NormalisedValueOnWorld
    -- 22 NormalisedValueOffWorld

    local s = string.gsub(x2[10][1].value, "/", "\\")
    table.insert(icon, s)  -- for Win
--  table.insert(icon, x2[10][1].value))  -- for *Nix
    table.insert(product, t)
end

print("products: " .. #product)


--[[ technology ]]-------------------------------------------------------------

x = xml.load(in_dir .. "\\NMS_REALITY_GCTECHNOLOGYTABLE.exml")
assert("GcTechnologyTable" == x.template)

x1 = x[1]
for i = 1, #x1 do
    assert("GcTechnology" == x1[i].template)
    local x2 = x1[i]

    local t = {}
    t.Id                = x2[1].value
    t.Name              = x2[2].value
    t.NameLower         = x2[3].value
    t.Subtitle          = x2[4][1].value
    t.Description       = x2[5][1].value
    t.Teach             = x2[6].value
    t.HintStart         = x2[7].value
    t.HintEnd           = x2[8].value
    t.Icon              = get_icon_name(x2[9][1].value)
    t.Colour = {}
    for i = 1, 4 do
        local c = x2[10][i].value
        c = string.gsub(c, ",", ".")
        c = tonumber(c) * 255
        c = math.floor(c)
        table.insert(t.Colour, c)
    end
    t.Level             = x2[11].value
    t.Chargeable        = x2[12].value
    t.ChargeAmount      = x2[13].value
    t.SubstanceCategory = x2[14][1].value
    t.ChargeBy = {}
    if #x2[15] > 0 then
        for j = 1, #x2[15] do
            local item = x2[15][j][1].value
            table.insert(t.ChargeBy, item)
            --print(item)
        end
    end
    t.BuildFullyCharged     = x2[16].value
    t.Upgrade               = x2[17].value
    t.Core                  = x2[18].value
    t.TechnologyCategory    = x2[19][1].value
    t.TechnologyRarity      = x2[20][1].value
    t.Value                 = x2[21].value
    t.Requirements          = {}
    if #x2[22] > 0 then
        for j = 1, #x2[22] do
            local Id        = x2[22][j][1].value
            local IType     = x2[22][j][2][1].value -- "Substance", "Product"
            local Amount    = x2[22][j][3].value
            table.insert(t.Requirements, {Id, IType, Amount})
            -- print(Id, IType, Amount)
        end
    end
    t.StatBonuses = {}
    if #x2[23] > 0 then
        for j = 1, #x2[23] do
            local StatsType = x2[23][j][1][1].value
            local Bonus     = x2[23][j][2].value
            local Level     = x2[23][j][3].value
            table.insert(t.StatBonuses, {StatsType, Bonus, Level})
            -- print(StatsType, Bonus, Level)
        end
    end
    t.RequiredTech  = x2[24].value
    t.RequiredLevel = x2[25].value
    t.UpgradeColour = {}
    -- 26
    t.LinkColour    = {}
    -- 27
    t.RewardGroup   = x2[28].value

    local s = string.gsub(x2[9][1].value, "/", "\\")
    table.insert(icon, s)  -- for Win
--  table.insert(icon, x2[9][1].value))  -- for *Nix
    table.insert(technology, t)
end

print("technologies: " .. #technology)


--[[ ]]------------------------------------------------------------------------

x1 = nil
xml = nil

table.sort(icon)
local t = {}
local t_old = ""
for i = 1, #icon do
    local t_new = icon[i]
    if t_new ~= t_old then
        table.insert(t, t_new)
    end
    t_old = t_new
end
icon = nil

local w = assert(io.open("icons_list.txt", "w+"))
for i = 1, #t do
    w:write(t[i])
    w:write("\n")
end
w:close()

print("icons: " .. #t)

--[[ ]]------------------------------------------------------------------------

local function td(body, bg)
    local bc = ""
    if bg then
        bc = string.format(" bgcolor='#%02x%02x%02x'", bg[1], bg[2], bg[3])
--        bc = string.format(" bgcolor='rgb(%d,%d,%d)'", bg[1], bg[2], bg[3])
    end
    return "<td" .. bc .. ">" .. body .. "</td>"
end

local function anchor(id)
    return "<a id='" .. id .. "' class='anchor'></a>"
end

local function div(class, body)
    return "<div class='" .. class .. "'>" .. body .. "</div>"
end

local function img(src)
    return "<img src='" .. src .. "' />"
end

local function find_by_id(tname, id)
    local res = ""
    local t
    if tname == "Substance" then
        t = substance
    elseif tname == "Product" then
        t = product
    else
        t = technology
    end
    for i = 1, #t do
        if id == t[i].Id then
            return t[i]
        end
    end
    return nil
end

dofile("_lang.lua")

    
--[[ substance.html]]---------------------------------------------------------

io.write("write substance_" .. L .. ".html... ")
local html = assert(io.open("substance_" .. L .. ".html", "w+"))

html:write([[
<html>
<head>
<link rel="stylesheet" href="style.css">
</style>
<body>
<table>
<tr>
]])

html:write("</tr>\n")

for i = 1, #substance do
--    print(substance[i].Id)
    local s = substance[i]
    html:write("<tr>")

    html:write(td(img(s.Icon), s.Colour))
    html:write("<td>")
    html:write(anchor(s.Id))
    html:write(div("Name", lang[s.NameLower][L]))
    html:write(div("Subtitle", lang[s.Subtitle][L]))
    html:write("</td>")
    html:write(td(lang[s.Symbol][L]))
    html:write(td(s.BaseValue .. "U"))
    html:write(td(lang[s.Description][L]))

    html:write("</tr>\n")
end

html:write("</table>\n")
html:write("</body>\n")
html:close()

print("OK")


--[[ product.html]]-----------------------------------------------------------

io.write("write product_" .. L .. ".html... ")
html = assert(io.open("product_" .. L .. ".html", "w+"))

html:write([[
<html>
<head>
<link rel="stylesheet" href="style.css">
<body>
<table>
<tr>
]])

html:write("</tr>\n")

for i = 1, #product do
--    print(substance[i].Id)
    local p = product[i]
    html:write("<tr>")

    html:write(td(img(p.Icon), p.Colour))
    html:write("<td>")
    html:write(anchor(p.Id))
    html:write(div("Name", lang[p.NameLower][L]))
    html:write(div("Subtitle", lang[p.Subtitle][L]))
    html:write("</td>")
    html:write(td(p.BaseValue .. "U"))
    html:write("<td>")
    if #p.Requirements > 0 then
        html:write("<table class='Requirements'>")
        local sum = 0
        for j = 1, #p.Requirements do
            local id      = p.Requirements[j][1]
            local invtype = p.Requirements[j][2]
            local amount  = p.Requirements[j][3]

            local t = find_by_id(invtype, id)
            local name = lang[t.NameLower][L]
            name = "<a href='" .. invtype:lower() .. "_" .. L .. ".html#" .. id .. "'>" .. name .. "</a>"
            local price = (t.BaseValue * amount) >> 0
            sum = (sum + price)
            html:write("<tr><td>" .. name .. "</td>")
            html:write("<td>x" .. amount .. "</td>")
            html:write("<td>" .. price .. "U</td></tr>")
        end
        html:write("<tr><td class='total'></td><td class='total'>∑:</td><td class='total'>" .. sum .. "U</td></tr></table>")
    end
    html:write("</td>")
    html:write(td(lang[p.Description][L]))

    html:write("</tr>\n")
end

html:write("</table>\n")
html:write("</body>\n")
html:close()

print("OK")


--[[ technology.html]]-----------------------------------------------------------

io.write("write technology_" .. L .. ".html... ")
html = assert(io.open("technology_" .. L .. ".html", "w+"))

html:write([[
<html>
<head>
<link rel="stylesheet" href="style.css">
<body>
<table>
<tr>
]])

html:write("</tr>\n")

for i = 1, #technology do
--    print(substance[i].Id)
    local t = technology[i]
    html:write("<tr>")

    html:write(td(img(t.Icon), t.Colour))
    html:write("<td>")
    html:write(anchor(t.Id))
    html:write(div("Name", lang[t.NameLower][L]))
    html:write(div("Subtitle", lang[t.Subtitle][L]))
    html:write("</td>")
    html:write(td(t.Value .. "U"))

    html:write("<td>")
    if #t.Requirements > 0 then
        html:write("<table class='Requirements'>")
        local sum = 0
        for j = 1, #t.Requirements do
            local id      = t.Requirements[j][1]
            local invtype = t.Requirements[j][2]
            local amount  = t.Requirements[j][3]

            local tid = find_by_id(invtype, id)
            local name = lang[tid.NameLower][L]
            name = "<a href='" .. invtype:lower() .. "_" .. L .. ".html#" .. id .. "'>" .. name .. "</a>"
            local price = (tid.BaseValue * amount) >> 0
            sum = (sum + price)
            html:write("<tr><td>" .. name .. "</td>")
            html:write("<td>x" .. amount .. "</td>")
            html:write("<td>" .. price .. "U</td></tr>")
        end
        html:write("<tr><td class='total'></td><td class='total'>∑:</td><td class='total'>" .. sum .. "U</td></tr></table>")
    end

    html:write("</td><td>")

    if #t.ChargeBy > 0 then
        html:write("<table class='ChargeBy'>")
        for j = 1, #t.ChargeBy do
            html:write("<tr>")
            local id = t.ChargeBy[j]

            local tid = find_by_id("Substance", id)
            local name
            if tid then
                name = lang[tid.NameLower][L]
                name = "<a href='substance_" .. L .. ".html#" .. id .. "'>" .. name .. "</a>"
            else
                tid = find_by_id("Product", id)
                name = lang[tid.NameLower][L]
                name = "<a href='product_" .. L .. ".html#" .. id .. "'>" .. name .. "</a>"
            end
            html:write("<td>" .. name .. "</td>")

            local charge = string.format("%.1f", t.ChargeAmount / tid.ChargeValue)
            html:write("<td>" .. charge .. "</td>")
            html:write("</tr>")
        end
        html:write("</table>")
    end

    html:write("</td><td>")

    if #t.StatBonuses > 0 then
        html:write("<table class='StatBonuses'>")
        for j = 1, #t.StatBonuses do
            html:write("<tr>")
            html:write("<td>" .. t.StatBonuses[j][1] .. "</td>")
            html:write("<td>=> " .. t.StatBonuses[j][2] .. "</td>")
            html:write("<td>(+" .. t.StatBonuses[j][3] .. ")</td>")
            html:write("</tr>")
        end
        html:write("</table>")
    end

    html:write("</td>")

    html:write(td(lang[t.Description][L]))

    html:write("</tr>\n")
end

html:write("</table>\n")
html:write("</body>\n")
html:close()

print("OK")


--[[ index.html ]]-------------------------------------------------------------

local loc_names = {
    lang["SUBSTANCE"][L],
    lang["PRODUCT"][L],
    lang["TRA_TECHNOLOGY"][L]
}

io.write("write index_" .. L .. ".html... ")
html = assert(io.open("index_" .. L .. ".html", "w+"))

html:write([[
<html>
<head>
<link rel="stylesheet" href="style.css">
<body>
]])

html:write("<ul>")
html:write("<li><a href='substance_" .. L .. ".html'>" .. loc_names[1] .. "</a></li>")
html:write("<li><a href='product_" .. L .. ".html'>" .. loc_names[2] .. "</a></li>")
html:write("<li><a href='technology_" .. L .. ".html'>" .. loc_names[3] .. "</a></li>")
html:write("</ul>")

html:write("</body>\n")
html:close()

print("OK")
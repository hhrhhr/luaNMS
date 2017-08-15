assert("Lua 5.3" == _VERSION)
xml = require("LuaXml")

assert(arg[1], "\n\n[ERROR] no input dir with NMS_REALITY_*.exml\n\n")
local exml_dir = arg[1] .. "/METADATA/REALITY/TABLES/"
local out_dir = arg[2] or "."
local L = tonumber(arg[3]) or -1 -- manual lang code

local language = dofile("util_lang.lua")
local lang = dofile(out_dir .. "/_lang.lua")

local substance = {}
local product = {}
local technology = {}

local icon = {}
local x1

local function get_icon_name(path)
    local s = string.match(path, "^.+/(.+)$")
    return s and string.sub(s, 1, -5) or ""
end

local function get_colors(v)
    local t = {}
    for i = 1, 4 do
        local c = v[i].value
        c = tonumber(c) * 255
        c = math.floor(c)
        table.insert(t, c)
    end
    return t
end

local function get_requirments(v)
    local t = {}
    if #v > 0 then
        for i = 1, #v do
            local Id     = v[i][1].value
            local IType  = v[i][2][1].value -- "Substance", "Product"
            local Amount = v[i][3].value
            table.insert(t, {Id, IType, Amount})
        end
    end
    return t
end

local function get_chargeby(v)
    local t = {}
    if #v > 0 then
        for j = 1, #v do
            local item = v[j][1].value
            table.insert(t, item)
        end
    end
    return t
end

local function get_statbonuses(v)
    local t = {}
    if #v > 0 then
        for i = 1, #v do
            local StatsType = v[i][1][1].value
            local Bonus     = v[i][2].value
            local Level     = v[i][3].value
            table.insert(t, {StatsType, Bonus, Level})
        end
    end
    return t
end


--[[ substance ]]--------------------------------------------------------------

local x = xml.load(exml_dir .. "/NMS_REALITY_GCSUBSTANCETABLE.exml")
assert("GcSubstanceTable" == x.template)

x1 = x[1]
for i = 1, #x1 do
    assert("GcRealitySubstanceData.xml" == x1[i].value)
    local x2 = x1[i]

    local t = {}
    t.Name              = x2[1].value
    t.NameLower         = x2[2].value
    t.Id                = x2[3].value
    t.Symbol            = x2[4].value
    t.Icon              = get_icon_name(x2[5][1].value)
--    t.DebrisFile        = x2[6]
    t.Subtitle          = x2[7][1].value
    t.Description       = x2[8][1].value
    t.Colour            = get_colors(x2[9])
    t.WorldColour       = get_colors(x2[10])
    t.BaseValue         = x2[11].value
    t.SubstanceCategory = x2[12][1].value
    t.Rarity            = x2[13][1].value
    t.Legality          = x2[14][1].value
    t.ChargeValue       = x2[15].value
--    t.Cost              = x2[16]
--    t.NormalisedValueOnWorld = tonumber(x2[17].value)
--    t.NormalisedValueOffWorld = tonumber(x2[18].value)
    t.tradeCategory      = x2[19][1].value
--    t.WikiEnabled       = x2[20].value
--    t.EconomyInfluenceMultiplier = tonumber(x2[21])

    local s = x2[5][1].value
    if "\\" == package.config:sub(1,1) then -- Win check
        s = string.gsub(s, "/", "\\")
    end
    table.insert(icon, s)
    table.insert(substance, t)
end

print("substances: " .. #substance)


--[[ product ]]----------------------------------------------------------------

x = xml.load(exml_dir .. "NMS_REALITY_GCPRODUCTTABLE.exml")
assert("GcProductTable" == x.template)

x1 = x[1]
for i = 1, #x1 do
    assert("GcProductData.xml" == x1[i].value)
    local x2 = x1[i]

    local t = {}
    t.Id                = x2[1].value
    t.Name              = x2[2].value
    t.NameLower         = x2[3].value
    t.Subtitle          = x2[4][1].value
    t.Description       = x2[5][1].value
    t.Hint              = x2[6].value
--    t.DebrisFile        = x2[7][1].value
    t.BaseValue         = tonumber(x2[8].value)
    t.Level             = tonumber(x2[9].value)
    t.Icon              = get_icon_name(x2[10][1].value)
    t.Colour            = get_colors(x2[11])
    t.SubstanceCategory = x2[12][1].value
    t.ProductCategory   = x2[13][1].value
    t.Rarity            = x2[14][1].value
    t.Legality          = x2[15][1].value
    t.Consumable        = x2[16].value
    t.ChargeValue       = tonumber(x2[17].value)
    t.Requirements      = get_requirments(x2[18])
    -- 19 Cost
    -- 20 SpecificChargeOnly
    -- 21 NormalisedValueOnWorld
    -- 22 NormalisedValueOffWorld
    -- 23 TradeCategory
    -- 24 WikiEnabled
    -- 25 IsCraftable
    -- 26 EconomyInfluenceMultiplier

    local s = x2[10][1].value
    if "\\" == package.config:sub(1,1) then -- Win check
        s = string.gsub(s, "/", "\\")
    end
    table.insert(icon, s)
    table.insert(product, t)
end

print("products: " .. #product)


--[[ technology ]]-------------------------------------------------------------

x = xml.load(exml_dir .. "NMS_REALITY_GCTECHNOLOGYTABLE.exml")
assert("GcTechnologyTable" == x.template)

x1 = x[1]
for i = 1, #x1 do
    assert("GcTechnology.xml" == x1[i].value)
    local x2 = x1[i]

    local t = {}
    t.Id                    = x2[1].value
    t.Name                  = x2[2].value
    t.NameLower             = x2[3].value
    t.Subtitle              = x2[4][1].value
    t.Description           = x2[5][1].value
    t.Teach                 = x2[6].value
    t.HintStart             = x2[7].value
    t.HintEnd               = x2[8].value
    t.Icon                  = get_icon_name(x2[9][1].value)
    t.Colour                = get_colors(x2[10])
    t.Level                 = tonumber(x2[11].value)
    t.Chargeable            = x2[12].value
    t.ChargeAmount          = tonumber(x2[13].value)
    t.SubstanceCategory     = x2[14][1].value
    t.ChargeBy              = get_chargeby(x2[15])
    t.BuildFullyCharged     = x2[16].value
    t.Upgrade               = x2[17].value
    t.Core                  = x2[18].value
    t.TechnologyCategory    = x2[19][1].value
    t.TechnologyRarity      = x2[20][1].value
    t.Value                 = tonumber(x2[21].value)
    t.Requirements          = get_requirments(x2[22])
    t.BaseStat              = x2[23][1].value
    t.StatBonuses           = get_statbonuses(x2[24])
--    t.RequiredTech          = x2[25].value
--    t.RequiredLevel         = tonumber(x2[26].value)
--    t.UpgradeColour         = get_colors(x2[27])
--    t.LinkColour            = get_colors(x2[28])
--    t.RewardGroup           = x2[29].value
--    t.BaseValue             = tonumber(x2[30].value)
--    t.Cost                  = x2[31]
--    t.RequiredRank          = tonumber(x2[32].value)
--    t.DispensingRace        = x2[33][1].value
--    t.FragmentCost          = tonumber(x2[34].value)
--    t.TechShopRarity        = x2[35][1].value
--    t.WikiEnabled           = x2[36].value

    local s = x2[9][1].value
    if "\\" == package.config:sub(1,1) then -- Win check
        s = string.gsub(s, "/", "\\")
    end
    table.insert(icon, s)
    table.insert(technology, t)
end

print("technologies: " .. #technology)


x1 = nil
xml = nil


--[[ used icon list ]]----------------------------------------------------------

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

local w = assert(io.open(out_dir .. "/_icons_list.txt", "w+"))
for i = 1, #t do
    w:write(t[i])
    w:write("\n")
end
w:close()

print("icons: " .. #t)


--[[ html utils ]]--------------------------------------------------------------

local function td(src, bg, class)
    local bc = ""
    if bg then
        bc = (" class='icon' bgcolor='#%02x%02x%02x'"):format(bg[1], bg[2], bg[3])
    elseif class then
        bc = (" class='%s'"):format(class)
    end
    
    return ("<td%s>%s</td>\n"):format(bc, src)
end

local function anchor(id)
    return ("<a id='%s' class='anchor'></a>"):format(id)
end

local function div(class, src, popup)
    local title = popup and ("' title='" .. popup) or ""
    return ("<div class='%s%s'>%s</div>"):format(class, title, src)
end

--local function img(src)
--    return ("<img src='%s' />\n"):format(src)
--end

local function css_sprite(src, popup)
    local title = popup and ("' title='" .. popup) or ""
    return ("<i class='%s%s'>&nbsp;</i>"):format(src, title)
end

local function span(src, popup)
    local title = popup and (" title='" .. popup .. "'") or ""
    return ("<span%s>%s</span>"):format(title, src)
end

local function find_by_id(tname, id)
    local t
    if     tname == "Substance" then
        t = substance
    elseif tname == "Product" then
        t = product
    elseif tname == "Technology" then
        t = technology
    else
        assert(false, "[ERR] " .. tname)
    end
    for i = 1, #t do
        if id == t[i].Id then
            return t[i]
        end
    end
    return nil
end


--------------------------------------------------------------------------------

local function html_output(L)

    --[[ substance_#.html]]-----------------------------------------------------

    io.write("write substance_" .. L .. ".html...")
    local html = assert(io.open(out_dir .. "/substance_" .. L .. ".html", "w+"))

    html:write([[
<html>
<head><link rel="stylesheet" href="style.css"></head>
<body>
<table cols="5">
]])

    for i = 1, #substance do
        local s = substance[i]
        html:write("<tr>\n")
        html:write(td(css_sprite(s.Icon, s.Id), s.Colour))

        html:write("<td>")
        html:write(anchor(s.Id))
        html:write(div("Name", lang[s.NameLower][L], s.NameLower))
        html:write(div("Subtitle", lang[s.Subtitle][L], s.Subtitle))
        html:write("</td>\n")

        html:write(td(lang[s.Symbol] and lang[s.Symbol][L] or "--"))
        html:write(td(s.BaseValue .. "U"))

        html:write("<td>")
        html:write(div("Desc", lang[s.Description][L], s.Description))
        html:write("<br/>")
        local str = ("%s: %s, %s"):format(
            lang["UI_LOG_CATEGORIES"][L], s.SubstanceCategory, s.tradeCategory)
        html:write(div("Category", span(str)))
        
        html:write("</td></tr>\n")
    end

    html:write("</table>\n</body>\n")
    html:close()


    --[[ product_#.html]]-------------------------------------------------------

    io.write(" product_" .. L .. ".html...")
    html = assert(io.open(out_dir .. "/product_" .. L .. ".html", "w+"))

    html:write([[
<html>
<head><link rel="stylesheet" href="style.css"></head>
<body>
<table cols="5">
]])

    for i = 1, #product do
        local p = product[i]
        html:write("<tr>")
        html:write(td(css_sprite(p.Icon, p.Id), p.Colour))
        html:write("<td>")
        html:write(anchor(p.Id))
        
        local s = p.NameLower
        if lang[s] then
            s = lang[s][L]
            html:write(div("Name", s, p.NameLower))
        else
            html:write(div("Name wrong", s, p.NameLower))
        end
        
        s = p.Subtitle
        if lang[s] then s = lang[s][L] end
        html:write(div("Subtitle", s, p.Subtitle))

        html:write("</td>")
        html:write(td(p.BaseValue .. "U"))
        html:write("<td>")
        if #p.Requirements > 0 then
            html:write("<table class='Requirements' cols='3'>")
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
            html:write("<tr><td></td>")
            html:write(td("∑:", nil, "total"))
            html:write(td(sum .. "U", nil, "total"))
            html:write("</tr></table>")
        end
        html:write("</td>")
        
        s = p.Description
        if lang[s] then s = lang[s][L] end
        html:write("<td>")
        html:write(div("Desc", s, p.Description))
        html:write("<br/>")
        
        s = ("%s: %s, %s"):format(
            lang["UI_LOG_CATEGORIES"][L], p.SubstanceCategory, p.ProductCategory)
        html:write(div("Category", span(s)))
        html:write("</td></tr>\n")
    end

    html:write("</table>\n")
    html:write("</body>\n")
    html:close()


    --[[ technology_#.html]]----------------------------------------------------

    io.write(" technology_" .. L .. ".html...")
    html = assert(io.open(out_dir .. "/technology_" .. L .. ".html", "w+"))

    html:write([[
<html>
<head><link rel="stylesheet" href="style.css"></head>
<body>
<table cols="7">
]])

    for i = 1, #technology do
        local t = technology[i]
        html:write("<tr>")
        html:write(td(css_sprite(t.Icon, t.Id), t.Colour))
        html:write("<td>")
        html:write(anchor(t.Id))

        -- workaround for localization errors
        local nm = lang[t.NameLower] and lang[t.NameLower][L] or "[TMP]" .. t.NameLower

        html:write(div("Name", nm, t.NameLower))
        html:write(div("Subtitle", lang[t.Subtitle][L], t.Subtitle))

        if #t.ChargeBy > 0 then
            html:write("<table class='ChargeBy' cols='2'>")
            html:write("<caption>" .. lang["CHARGE"][L] .. "</caption>")
            for j = 1, #t.ChargeBy do
                html:write("<tr>")
                local id = t.ChargeBy[j]

                local name, prefix
                local tid = find_by_id("Substance", id)
                if tid then
                    name = lang[tid.NameLower][L]
                    prefix = "substance"
                else
                    tid = find_by_id("Product", id)
                    name = lang[tid.NameLower][L]
                    prefix = "product"
                end

                local link = ("<a href='%s_%d.html#%s'>%s</a>"):format(prefix, L, id, name)
                html:write(td(link))

                local charge = ("x%.1f"):format(t.ChargeAmount / tid.ChargeValue)
                html:write(td(charge))
                html:write("</tr>")
            end
            html:write("</table>")
        end
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
                name = ("<a href='%s_%s.html#%s'>%s</a>"):format(
                    invtype:lower(), L, id, name)
                local price = (tid.BaseValue * amount) >> 0
                sum = (sum + price)
                html:write("<tr>")
                html:write(td(name))
                html:write(td("x" .. amount))
                html:write(td(price .. "U"))
                html:write("</tr>")
            end
            html:write("<tr><td></td>")
            html:write(td("∑:", nil, "total"))
            html:write(td(sum .. "U", nil, "total"))
            html:write("</tr></table>")
        end

        html:write("</td><td>")
        if #t.StatBonuses > 0 then
            html:write("<table class='StatBonuses'>")
            for j = 1, #t.StatBonuses do
                html:write("<tr>")
                html:write(td(t.StatBonuses[j][1]))
                html:write(td("=>&nbsp" .. t.StatBonuses[j][2]))
                html:write(td("(+" .. t.StatBonuses[j][3] .. ")"))
                html:write("</tr>")
            end
            html:write("</table>")
        end
        html:write("</td><td>")
        
        html:write(div("Desc", lang[t.Description][L], t.Description))
        html:write("<br/>")
        
        local str = ("%s: %s, %s"):format(
            lang["UI_LOG_CATEGORIES"][L], t.SubstanceCategory, t.TechnologyCategory)
        html:write(div("Category", span(str)))
        html:write("</td></tr>\n")
    end

    html:write("</table>\n")
    html:write("</body>\n")
    html:close()

    print(" OK")
end


--[[ index.html ]]--------------------------------------------------------------

local function index_output()
    io.write("write index.html... ")
    local html = assert(io.open(out_dir .. "/index.html", "w+"))

    html:write([[
<html>
<head><link rel="stylesheet" href="style.css"></head>
<body>
<h1>ver 1.31</h1>
<table cols='4'>
]])

    for i = 1, language.count do
        html:write("<tr>\n")
        html:write(td(language.list[i]))
        html:write(td(("<a href='substance_%d.html'>%s</a>"):format(i, lang["SUBSTANCE"][i])))
        html:write(td(("<a href='product_%d.html'>%s</a>"):format(i, lang["SHOP_PRODUCT"][i])))
        html:write(td(("<a href='technology_%d.html'>%s</a>"):format(i, lang["TECH"][i])))
        html:write("</tr>\n")
    end
    html:write([[
</table>
<br /><a href='https://github.com/hhrhhr/luaNMS'>https://github.com/hhrhhr/luaNMS</a>
</body>
]])
    html:close()

    print("OK")
end


--[[ main ]]--------------------------------------------------------------------

if L > 0 then
    html_output(L)
elseif L == 0 then
    index_output()
else
    for i = 1, language.count do
        html_output(i)
    end
    index_output()
end


--[[ style.css ]]---------------------------------------------------------------

io.write("write style.css... ")
local css = assert(io.open(out_dir .. "/style.css", "w+"))
css:write([[
table { border-collapse: collapse; }
td, th { padding: 0.3em; border: 1px solid; }
table .ChargeBy { font-size: smaller; }
.ChargeBy caption { text-align: right; }
.ChargeBy td { padding: 0 0.1em; border: none; }
.Category, .Requirements, .StatBonuses, .wrong { font-size: smaller; }
.Requirements td { padding: 0.2em; border: none; }
caption, .Requirements .total { border-top: 1px solid; }
.Requirements .total { font-weight: bold; }
.StatBonuses td { padding: 0.2em; border: none; }
.anchor { display:block; position:relative; top:-2em; }
.anchor:target + .Name { outline:#808080 1px dotted; font-size: larger; }
.Name { font-weight: bold; }
.Subtitle { font-style: italic; }
.icon > i { width: 64px; height: 64px; display: block; background-image: url(sprites.png); }
]])
css:close()

print("OK")

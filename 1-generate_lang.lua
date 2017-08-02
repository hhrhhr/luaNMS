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

local exml_dir = assert(arg[1], "\n\n[ERROR] no input dir with NMS_LOC1.exml\n\n")
local out_dir = arg[2] or "."

xml = require("LuaXML")

local x = xml.load(exml_dir .. "/LANGUAGE/NMS_LOC1.exml")
assert("TkLocalisationTable" == x.template)
local lang = {}

local x1 = x[1]
for i = 1, #x1 do
    assert("TkLocalisationEntry.xml" == x1[i].value)
    local x2 = x1[i]
    local id
    local t = {}

    for j = 1, #x2 do
        local x3 = x2[j]
        if j == 1 then
            id = x3.value
            lang[id] = {}
        else
            local s = string.gsub(x3[1].value, "<IMG>", "#")
            s = string.gsub(s, "<>", "#")
            table.insert(lang[id], s)
        end
    end
end

local w = assert(io.open(out_dir .. "/_lang.lua", "w+"))
w:write("lang = {\n")
for k, v in pairs(lang) do
    w:write("[\"" .. k .. "\"] = {\n")
    for i = 1, #v do
        w:write("\"" .. v[i] .. "\",\n")
    end
    w:write("},\n")
end
w:write("}\n")
w:close()

assert("Lua 5.3" == _VERSION)

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

local language = {
"LOC1_BRAZILIANPORTUGUESE", "LOC1_DUTCH", "LOC1_ENGLISH", "LOC1_FRENCH", "LOC1_GERMAN", "LOC1_ITALIAN", "LOC1_JAPANESE", "LOC1_KOREAN", "LOC1_LATINAMERAICANSPANISH", "LOC1_POLISH", "LOC1_PORTUGUESE", "LOC1_RUSSIAN", "LOC1_SIMPLIFIEDCHINESE", "LOC1_SPANISH", "LOC1_TRADITIONALCHINESE", "LOC1_USENGLISH", "UPDATE3_BRAZILIANPORTUGUESE", "UPDATE3_DUTCH", "UPDATE3_ENGLISH", "UPDATE3_FRENCH", "UPDATE3_GERMAN", "UPDATE3_ITALIAN", "UPDATE3_JAPANESE", "UPDATE3_KOREAN", "UPDATE3_LATINAMERAICANSPANISH", "UPDATE3_POLISH", "UPDATE3_PORTUGUESE", "UPDATE3_RUSSIAN", "UPDATE3_SIMPLIFIEDCHINESE", "UPDATE3_SPANISH", "UPDATE3_TRADITIONALCHINESE", "UPDATE3_USENGLISH"
}

local exml_dir = assert(arg[1], "\n\n[ERROR] no input dir with NMS_*.exml\n\n")
local out_dir = arg[2] or "."

xml = require("LuaXML")
local lang = {}

local function parse_lang(filename)
    local x = xml.load(exml_dir .. "/LANGUAGE/" .. filename)
    assert("TkLocalisationTable" == x.template)
    
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
                if not lang[id] then
                    lang[id] = {}
                end
            else
                local s = x3[1].value
                if #s > 0 then
                    s = string.gsub(s, "<IMG>", "#")
                    s = string.gsub(s, "<>", "#")
                    s = string.gsub(s, "\\", "\\\\")
                    local l = x2[j].name
                    lang[id][langcode[l]] = s
                end
            end
        end
    end
end

local l = language
local lc = #l
for i = 1, lc do
    print("parse " .. i .. "\\" .. lc .. " " .. l[i] .. "...")
    parse_lang("NMS_" .. l[i] .. ".exml")
end


print("key sort...")
local keys_sorted = {}
for k, v in pairs(lang) do 
    table.insert(keys_sorted, k)
end
table.sort(keys_sorted)


print("write...")
local w = assert(io.open(out_dir .. "/_lang.lua", "w+"))
w:write("lang = {\n")
for i = 1, #keys_sorted do
    local k = keys_sorted[i]
    w:write("[\"" .. k .. "\"] = {\n")
    for j = 1, 16 do
        local s = lang[k][j]
        if not s then
            s = "[EN]" .. lang[k][1]  -- failback to EN
        end
        w:write("[" .. j .. "] = \"" .. s .. "\",\n")
    end
    w:write("},\n")
end
w:write("}\n")
w:close()

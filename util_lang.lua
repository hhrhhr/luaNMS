assert("Lua 5.3" == _VERSION)

-- generate lang table
local language = {}

language.list = {
    "English", "French", "Italian", "German", "Spanish", "Russian", "Polish",
    "Dutch", "Portuguese", "LatinAmericanSpanish", "BrazilianPortuguese",
    "SimplifiedChinese", "TraditionalChinese", "Korean", "Japanese", "USEnglish"
}

language.count = #language.list

language.code = {}
for i = 1, language.count do
    language.code[language.list[i]] = i
end

language.file = {}
for i = 1, language.count do
    local filename
    if i ~= 10 then
        filename = language.list[i]:upper() .. ".exml"
    else
        -- devs misprint ----v !!!
        filename = "LATINAMERAICANSPANISH.exml"
    end
    table.insert(language.file, "NMS_LOC1_" .. filename)
    table.insert(language.file, "NMS_UPDATE3_" .. filename)
end

language.data = {}

return language

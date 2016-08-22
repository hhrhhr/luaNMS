assert("Lua 5.3" == _VERSION)

local in_file = assert(arg[1], "\nno input\n\n")
xml = require("LuaXML")

local x = xml.load(in_file)
assert("TkLocalisationTable" == x.template)
local lang = {}

local x1 = x[1]
for i = 1, #x1 do
    assert("TkLocalisationEntry" == x1[i].template)
    local x2 = x1[i]
    local id, en, ru
    
    for j = 1, #x2 do   -- 3
        local x3 = x2[j]
        
        local name = x3.name
        
        if "Id" == name then
            id = x3.value
        else
            if "English" == name then
                en = x3[1].value
            elseif "Russian" == name then
                ru = x3[1].value
            end
        end
        --lang[id] = {en, ru}
    end
    lang[id] = {en, ru}
end

local w = assert(io.open("_lang.lua", "w+"))
w:write("lang = {\n")
for k, v in pairs(lang) do
    w:write("[\"" .. k .. "\"] = {\n")
    w:write("\"" .. v[1] .. "\",\n")
    w:write("\"" .. v[2] .. "\"\n")
    w:write("},\n")
end
w:write("}\n")
w:close()

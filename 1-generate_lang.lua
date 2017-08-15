assert("Lua 5.3" == _VERSION)
xml = require("LuaXml")

assert(arg[1], "\n\n[ERROR] no input dir\n\n")
local exml_dir = arg[1] .. "/LANGUAGE/"
local out_dir = arg[2] or "."

local language = dofile("util_lang.lua")


-- main
local lc = #language.file
for i = 1, lc do
    local filename = language.file[i]
    io.write(i .. "\\" .. lc .. " load " .. filename .. "... ")

    local x = xml.load(exml_dir .. filename)
    assert("TkLocalisationTable" == x.template)

    io.write("process... ")
    local x1 = x[1]
    for i = 1, #x1 do
        assert("TkLocalisationEntry.xml" == x1[i].value)
        local x2 = x1[i]
        local id = x2[1].value
        if not language.data[id] then language.data[id] = {} end
        for j = 2, #x2 do
            local x3 = x2[j]
            local s = x3[1].value
            if s ~= "" then
                s = string.gsub(s, "<IMG>", "#")
                s = string.gsub(s, "<>", "#")
                s = string.gsub(s, "\\", "\\\\")
                local l = x3.name
                language.data[id][language.code[l]] = s
            end
        end
    end
    io.write("done.\n")
end


print("key sort...")
local keys = {}
for k, _ in pairs(language.data) do 
    table.insert(keys, k)
end
table.sort(keys)


print("write...")
local w = assert(io.open(out_dir .. "/_lang.lua", "w+"))
w:write("local lang = {\n")
for i = 1, #keys do
    local k = keys[i]
    w:write("[\"" .. k .. "\"] = {\n")
    for j = 1, language.count do
        local s = language.data[k][j]
        if s then
            w:write("[" .. j .. "] = \"" .. s .. "\",\n")
        else
            --s = "[EN]" .. lang[k][1]  -- failback to EN
        end
    end
    w:write("},\n")
end
w:write("}\nreturn lang\n")
w:close()

assert("Lua 5.3" == _VERSION)
assert(arg[1], "\n\n[ERROR] no input file\n\n")
local OUT = arg[2] or "tmp"
local FILTER = arg[3] or nil

require("mod_binary_reader")
local r = BinaryReader

local zlib = require("zlib")


--[[ funcs ]]------------------------------------------------------------------
local function read_header()
    r:idstring("PSAR")
    r:uint16(1) -- major version
    r:uint16(1) -- minor version
    local h = {}
    h.zformat = r:str(4)
    h.size = r:uint32(1)
    h.entry_sz = r:uint32(1)
    h.entry_num = r:uint32(1) - 1
    h.block_sz = r:uint32(1)
    h.flags = r:uint32(1)
    return h
end

local function read_entry()
    local t = {}
    t.hash = r:hex32() .. r:hex32() .. r:hex32() .. r:hex32()
    t.idx = r:uint32(1)
    t.size = r:sint40(1)
    t.offset = r:sint40(1)
    return t
end


local function unlz(data)
    local out, eof, b_in, b_out = zlib.inflate()(data)
    return out, eof, b_in, b_out
end


local block_idx = 0

local function read_filenames(off, size, z)
    r:seek(off)
    local sz = 0
    local mem = {}
    local data
    while sz < size do
        local zs = z[block_idx]
        data = r:str(zs)
        local eof, b_in, b_out
        data, eof, b_in, b_out = unlz(data)
--print(eof, b_in, b_out)
        table.insert(mem, data)

        sz = sz + b_out
        block_idx = block_idx + 1
    end

    data = table.concat(mem)

    local fn = {}
    for s in string.gmatch(data, "[^\n]+") do
        table.insert(fn, s)
    end
    return fn
end


--[[ main ]]-------------------------------------------------------------------

r:open(arg[1])

local h = read_header()
--print(h.zformat, h.size, h.entry_num, h.block_sz)

local files = {}
for i = 0, h.entry_num do
    files[i] = read_entry()
end

local zsize = {}
local z = 0
while r:pos() < h.size do
    zsize[z] = r:uint16(1)
    z = z + 1
end

local fname = read_filenames(files[0].offset, files[0].size, zsize)
--print(table.concat(fname, "\n"))

for i = 1, h.entry_num do
    local f = files[i]
    r:seek(f.offset)
    local size = 0
    local mem = {}
    while size < f.size do
        local zs = zsize[block_idx]
        local data = r:str(zs)
        local eof, b_in, b_out
        data, eof, b_in, b_out = unlz(data)
        table.insert(mem, data)

        size = size + b_out
        block_idx = block_idx + 1
    end

print(f.offset, f.size, fname[i])
--    local w = assert(io.open(OUT .. "/" .. fname[i], "w+b"))
--    w:write(table.concat(mem))
--    w:close()
end

r:close()

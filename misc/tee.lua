--[[
  The writer deleted this from their site,
  AFTER giving the files and permission to include them in an open source environment
  and well... I need it =].
  but it doesn't include any append mode...
  so maybe ill fix it later.

       by Aerolivier

  Usage: tee [-f] [FILES]
  
  Copies data from stdin to stdout and listed FILES.
  
  By default, tee does not overwrite files.
  Use the -f option to allow the overwriting of files.
]]--

local fs = require("filesystem")
local shell = require("shell")

local writers = {}

local args, options = shell.parse(...)

for _, filename in pairs(args) do
  local fn = shell.resolve(filename)
  if options.f or not fs.exists(fn) then
    table.insert(writers, io.open(filename, "w"))
  else
    io.stderr:write("tee: " .. fn .. " already exists, use -f to overwrite.\n")
  end
end

while true do
  local data = io.read("*L")
  
  if data == nil then
    -- stdin closed
    break
  else
    data = data
    io.write(data)
    io.flush()
    for _, w in pairs(writers) do
      w:write(data)
    end
  end
end

for _, w in pairs(writers) do
  w:close()
end

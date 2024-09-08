local component = require("component")
local rs = component.redstone
local me = component.me_interface

local function setRedstone(state)
    rs.setOutput({[0]=(state*15),(state*15),(state*15),(state*15),(state*15),(state*15)})
end

local function detect_fluids()
    local fluids = me.getFluidsInNetwork()
    if fluids[1] then
        return true
    else
        return false
    end
end

while true do
    if detect_fluids() then
        setRedstone(1)
    else
        setRedstone(0)
    end
    os.sleep(5)
end

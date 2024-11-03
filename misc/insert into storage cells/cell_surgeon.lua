local component = require("component")
local robot = require("robot")
local sides = require("sides")

local inv = component.inventory_controller
local me = component.upgrade_me

local function grab_cell()
    robot.select(2)
    robot.turnAround()
    robot.suck()
    robot.turnAround()
end

local function place_cell()
    robot.select(2)
    inv.dropIntoSlot(sides.front, 2)
end

local function grab_circuits()
    robot.select(1)
    robot.turnLeft()
    robot.suck()
    robot.turnRight()
    if inv.getStackInInternalSlot(1) == nil then
        os.execute("shutdown")
    end
end

local function place_circuits()
    robot.select(1)
    me.sendItems(1)
end

local function remove_cell()
    robot.select(3)
    robot.suck()
    robot.turnRight()
    robot.drop()
    robot.turnLeft()
end

local function main()
    grab_circuits()
    while true do
        local circ = inv.getStackInInternalSlot(1)
        if circ == nil then
            return
        else
            grab_cell()
            place_cell()
            place_circuits()
            remove_cell()
        end
    end
end

while true do
    main()
end
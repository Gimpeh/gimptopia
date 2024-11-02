local component = require("component")
local robot = require("robot")
local sides = require("sides")

local inv = component.inventory_controller
local me = component.upgrade_me
local geo = component.geolyzer
local db = component.database
local tunnel = component.tunnel
local generator = component.generator

local old_forward = robot.forward

robot.forward = function()
    if old_forward() then
        return true
    else
        robot.down()
        if old_forward() then
            return true
        else
            robot.up()
            robot.up()
            if old_forward() then
                return true
            else
                return false
            end
        end
    end
end

local function get_heat_vent()
    robot.select(1)
    local suc, err = pcall(function ()
        local derp = me.requestItems(db.address, 1, 48)
        return derp
    end)
    if not suc then
        tunnel.send("error", err)
        return false
    elseif err ~= 48 then
        me.sendItems(64)
        local craft = me.getCraftables({label = "Advanced Heat Vent"})[1].request(48)
        while true do
            if craft.isCanceled() then
                tunnel.send("message", "You FUCK! I needed those!")
                craft = me.getCraftables({label = "Advanced Heat Vent"})[1].request(48)
            elseif craft.hasFailed() then
                tunnel.send("error", "can't craft heat vents")
                os.execute("shutdown")
            elseif craft.isDone() then
                me.requestItems(db.address, 1, 48)
                return true
            end
        end
    elseif err == 48 then
        return true
    else
        tunnel.send("error", "unknown error in obtaining heat vents")
        return false
    end
end

local function get_apus()
    robot.select(2)
    local suc, err = pcall(function ()
        local derp = me.requestItems(db.address, 2, 48)
        return derp
    end)
    if not suc then
        tunnel.send("error", err)
        return false
    elseif err ~= 48 then
        me.sendItems(64)
        local craft = me.getCraftables({label = "Accelerated Processing Unit (APU) (Tier 3)"})[2].request(48)
        while true do
            if craft.isCanceled() then
                tunnel.send("message", "You FUCK! I needed those!")
                craft = me.getCraftables({label = "Accelerated Processing Unit (APU) (Tier 3)"})[2].request(48)
            elseif craft.hasFailed() then
                tunnel.send("error", "can't craft APUs")
                return false
            elseif craft.isDone() then
                me.requestItems(db.address, 1, 48)
                return true
            end
        end
    elseif err == 48 then
        return true
    else
        tunnel.send("error", "unknown error in obtaining heat vents")
        return false
    end
end

local function find_computer()
    for i = 1, 10 do
        if geo.detect(sides.left) then
            robot.forward()
            if geo.detect(sides.left) then
                robot.turnAround()
                robot.forward()
                robot.forward()
                robot.turnRight()
                robot.forward()
                robot.forward()
                return
            else
                robot.turnAround()
                robot.forward()
                robot.forward()
                robot.forward()
                robot.turnRight()
                robot.forward()
                robot.forward()
                return
            end
        elseif geo.detect(sides.right) then
            robot.forward()
            if geo.detect(sides.right) then
                for i = 1, 10 do
                    robot.forward()
                end
                robot.turnRight()
                robot.forward()
                robot.forward()
                return
            else
                for i = 1, 9 do
                    robot.forward()
                end
                robot.turnRight()
                robot.forward()
                robot.forward()
                return
            end
        elseif robot.detect(sides.front) then
            robot.turnRight()
            robot.forward()
            if geo.detect(sides.left) then
                robot.turnAround()
                robot.forward()
                robot.forward()
                robot.turnRight()
                robot.forward()
                robot.forward()
                return
            else
                robot.turnAround()
                robot.forward()
                robot.forward()
                robot.forward()
                robot.turnRight()
                robot.forward()
                robot.forward()
                return
            end
        else
            robot.forward()
        end
    end
end

local function place_crap()
    while robot.down() do end
    robot.up()
    for i = 1, 12 do
        robot.forward()
        robot.turnRight()
        robot.select(1)
        inv.dropIntoSlot(sides.front, 1, 1)
        inv.dropIntoSlot(sides.front, 2, 1)
        robot.select(2)
        inv.dropIntoSlot(sides.front, 3, 1)
        inv.dropIntoSlot(sides.front, 4, 1)
        
        robot.up()
        robot.select(1)
        inv.dropIntoSlot(sides.front, 1, 1)
        inv.dropIntoSlot(sides.front, 2, 1)
        robot.select(2)
        inv.dropIntoSlot(sides.front, 3, 1)
        inv.dropIntoSlot(sides.front, 4, 1)

        robot.down()
        robot.turnLeft()
    end
end

local function go_next()
    robot.turnAround()
    for i = 1, 14 do
        robot.forward()
    end
    robot.turnLeft()
    robot.forward()
    robot.forward()
    robot.forward()
    robot.turnLeft()
    robot.forward()
    robot.forward()
end

local function charge()
    robot.select(3)
    me.requestItems(db.address, 3)
    generator.insert(64)
end

local function main()
    charge()
    if not get_heat_vent() then
        tunnel.send("error", "can't get heat vents")
        os.execute("shutdown")
    end
    if not get_apus() then
        tunnel.send("error", "can't get APUs")
        os.execute("shutdown")
    end
    find_computer()
    for i = 1, 3 do
        place_crap()
        go_next()
        if not get_heat_vent() then
            tunnel.send("error", "can't get heat vents")
            os.execute("shutdown")
        end
        if not get_apus() then
            tunnel.send("error", "can't get APUs")
            os.execute("shutdown")
        end
    end
    place_crap()
end

main()
tunnel.send("message", "done")
print("done")
os.execute("shutdown")
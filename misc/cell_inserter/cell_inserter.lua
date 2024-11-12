local robot = require("robot")
local component = require("component")

local me = component.upgrade_me

for i = 1, 7 do
    for i = 1, 16 do
        robot.forward()
        robot.suckDown()
        robot.turnRight()
        robot.drop()
        robot.turnLeft()
        me.requestItems(component.database.address, 1, 1)
        robot.dropDown()
    end

    robot.forward()
    robot.turnRight()
    robot.forward()
    robot.forward()
    robot.turnRight()

    for i = 1, 16 do
        robot.forward()
        robot.suckDown()
        robot.turnLeft()
        robot.drop()
        robot.turnRight()
        me.requestItems(component.database.address, 1, 1)
        robot.dropDown()
    end

    robot.forward()
    robot.turnLeft()
    robot.forward()
    robot.forward()
    robot.forward()
    robot.forward()
    robot.turnLeft()
end
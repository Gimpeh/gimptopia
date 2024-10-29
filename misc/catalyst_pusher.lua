local component = require("component")
local robot = require("robot")
local sides = require("sides")
local event = require("event")

local rs = component.redstone
local me = component.upgrade_me
local database = component.database
local tank_controller = component.tank_controller

local function is_forge_idle()
    if rs.getInput(4) < 10 then
        local a, b, c, d, e = event.pull("redstone_changed")

        if e > 1 then
            return true
        end
    else
        return true
    end
end

local function is_particle_on_subnet()
    local particle = me.getItemsInNetwork({label = database.get(1).label})
    if particle[1] and particle[1].label and particle[1].label == "Unknown Particle" then
        return true
    else
        return false
    end
end

local function main()
    print("Main function called")
    if is_forge_idle() then
        print("Forge is idle")
        if is_particle_on_subnet() then
            print("Particle is on subnet, starting infinite loop")
            while true do
                print("checking fluid in bus")
                if tank_controller.getFluidInTank(sides.top)[1].amount < 5000 then
                    print("Fluid is low, refilling")
                    robot.drainDown(15000)
                    robot.fillUp(15000)
                    robot.drainDown(15000)
                    robot.fillUp(15000)
                end

                print("pausing for 5 seconds")
                os.sleep(5)

                if is_particle_on_subnet() then
                    print("Particle is still on subnet")
                else
                    print("Particle is no longer on subnet, cleaning up")
                    while robot.drainUp() do
                        print("stole a bit from the bus")
                        robot.fill()
                        print("and put it into the recycle tank right in front")
                    end
                    print("done cleaning up, Breaking Loop and starting over")
                    return true
                end
            end
        end
    end
end

while true do
    print("Starting a loop")
    local suc, err = pcall(main)
    print("Taking a break for 25 seconds")
    os.sleep(25)
    if not suc then
        print("Error: " .. err)
    end
end
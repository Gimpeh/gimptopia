local component = require("component")
local sides = require("sides")
local me = component.upgrade_me
local inv = component.inventory_controller
local robot = require("robot")
local rs = component.redstone
local card_slots = {}
local target_levels = {}
local max_target = 0
local shell = require("shell")

local voice
if component.isAvailable("speech") then
  voice = component.speech
else
  voice = {}
  voice.say = print
end

local args, options = shell.parse(...)

if args and args[1] and args[1] == "stfu" then
  voice.say("mee. ohnlee. wuhhnt. puunnch. puhmp.")
  os.sleep(1)
  voice.setVolume(0.5)
  voice.say("uhhhg")
  os.sleep(1)
  voice.setVolume(0.25)
  voice.say("SNNSHnSHhnn")
  voice.say = function() end
end
 
print("Reading Cards...")

for i = 1, robot.inventorySize() + 1 do
  local stack = inv.getStackInInternalSlot(i)
  if stack == nil then
    break
  end
  local label = stack.label
  local j, _ = string.find(label, ":", 1, true)
  local name = string.sub(label, 1, j - 1)
  local target = tonumber(string.sub(label, j + 2))
  card_slots[name] = i
  target_levels[name] = target
  if target > max_target then
    max_target = target
  end
end

print("Done, max target is "..max_target)

local function set_redstone(l)
  rs.setOutput({[0]=l,l,l,l,l,l})
end

local function set_fluid(name)
  voice.say("PUUHNCH")
  robot.select(card_slots[name])
  inv.equip()
  robot.use()
  inv.equip()
end

local function punch_pump()
  print("Stopping pump")
  set_redstone(0)
  os.sleep(1)
  print("Finding lowest fluid ...")
  local min_level = max_target
  local min_name = "[disabled]"
  local cur_levels = {}
  local cur_target = 0
  voice.say("HAS FLUUD?")
  for _, fluid in ipairs(me.getFluidsInNetwork()) do
    local target = target_levels[fluid.label]
    if target ~= nil then
      cur_levels[fluid.label] = fluid.amount
    end
  end
  for name, level in pairs(target_levels) do
    if cur_levels[name] == nil then
      min_level = 0
      min_name = name
      cur_target = level
      break
    end
    local c = cur_levels[name]
    if c < level and c < min_level then
      min_level = c
      min_name = name
      cur_target = level
    end
  end
  if min_name == "[disabled]" then
    voice.say("NOO PUNNNCH. WAHHHAHHHHHGHHHGHGHHH")
    print("All fluids are full!")
    os.sleep(180)
    return
  end
  print("Lowest fluid: "..min_name)
  set_fluid(min_name)
  set_redstone(1)
  os.sleep(10)
  local new_level = cur_target
  for _, fluid in ipairs(me.getFluidsInNetwork()) do
    if fluid.label == min_name then
      new_level = fluid.amount
      break
    end
  end
  if new_level >= cur_target then
    set_redstone(0)
    print("Done pumping fluid")
    return
  end
  local pump_rate = (new_level - min_level)/10
  local pump_time = 180
  local stop_when_done = false
  print("Pump rate:", pump_rate)
  if pump_rate > 0 then
    local time_to_full = (cur_target - new_level)/pump_rate
    if time_to_full < pump_time then
      pump_time = time_to_full
      stop_when_done = true
    end
  end
  os.sleep(pump_time)
  if stop_when_done then
    set_redstone(0)
  end
end

local function check_me_upgrade()
  local derp = component.list("upgrade_me")
  local upgrade = false
  for k, v in pairs(derp) do
    upgrade = true
  end
  if upgrade then
    print("ME Upgrade component has been located and is in fact installed")
    print("punch pump?")
  else
    print("ME Upgrade component does not exist within this robot. Hope you have a Tier 3 Upgrade Container installed...")
    print("Because if you don't then this robot is unable to work at this establishment")
    print("Next Time include the ME Upgrade component, and make sure its the tier 3 one. BLUE.. ITS BLUE!!!")
    print("If its not blue throw it in the trash and get a blue one. I don't care if its a tier 3, if its not blue its not good enough!")
    return false
  end

  if me.isLinked() then
    print("ME Upgrade is linked to A network")
    print("Whether or not it is actually linked to the correct network is still up for grabs..")
  else
    print("Bruh, you gotta link it...")
    print("Go put the robot in a Security Terminal")
    print("And make sure the terminal is connected to the correct network...")
    print("It is incredibly difficult for I, the robit, to detect that i has been linked to the wrong network")
    return false
  end

  local success, err = pcall(me.getFluidsInNetwork)
  if not success then
    print("problem with upgrade_me", err)
    return false
  end
  return true
end


local problem = false
local success, err = pcall(check_me_upgrade)
if not success then
  print("SOMETHING HAS GONE TERRIBLY WRONG!!!")
  print("aAN UNnnCOntrOLLABLE URrrGE IS STrIkING ME")
  print("II i IIi II PUINCH PUMP THE PUMPMP")
  if robot.up() then
    robot.turnRight()
    robot.turnLeft()
    robot.down()
  end
  print(err)
  return false
else 
  if success and err then
    print("ME Upgrade is functioning properly")
  elseif success and not err then
    os.sleep(5)
    print("")
    problem = true
  end
end
if problem then
  return
end
while true do
  local success, err = pcall(punch_pump)
  if not success then print(err) end
end

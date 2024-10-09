local component = require("component")
local robot = require("robot")

local me = component.upgrade_me
local inv = component.inventory_controller
local rs = component.redstone

local memory_cards = {}
--[[
    memory_cards = {
        [1] ={
            label = "desired_resource_label: target_amount",
            desired_resource_label = "resource_label",
            desired_amount = target_amount,
            inventory_slot_techTech = slot_number,
            inventory_slot_datastick = slot_number
        },
        [2] = {...}
]]

-----------------------------------------
--- Prep

local function read_memory_cards()
    print("Line 16: Starting read_memory_cards()")
    local invSize = robot.inventorySize()
    memory_cards = {}
    for i = 1, invSize do
        print("Line 20: Checking inventory slot " .. i)
        local card = inv.getStackInInternalSlot(i)
        if card and card.name and card.name == "tectech:item.em.parametrizerMemoryCard" then
            print("Line 23: Found memory card in slot " .. i)
            local string_location, _ = string.find(card.label, ":", 1, true)
            local memory_card_info = {
                label = card.label,
                desired_resource_label = string.sub(card.label, 1, string_location-1),
                desired_amount = tonumber(string.sub(card.label, string_location+2)),
                inventory_slot_techTech = i
            }
            for j = 1, invSize do
                print("Line 30: Checking for datastick in slot " .. j)
                local data = inv.getStackInInternalSlot(j)
                if data and data.name and data.name == "gregtech:gt.metaitem.01" then
                    if data.label == card.label then
                        print("Line 33: Found matching datastick in slot " .. j)
                        memory_card_info.inventory_slot_datastick = j
                        break
                    end
                end
            end
            table.insert(memory_cards, memory_card_info)
        end
    end
end

-----------------------------------------
--- Process

local function main()
    print("Line 45: Starting main()")
    local alls_good = true

    local function recheck_cards()
        print("Line 49: Rechecking memory cards")
        for card_num, card_info in ipairs(memory_cards) do
            print("Line 51: Rechecking card number " .. card_num)
            local resource_in_stock = me.getItemsInNetwork({label = card_info.desired_resource_label})
            if resource_in_stock and resource_in_stock[1] and resource_in_stock[1].size then
                if resource_in_stock[1].size < card_info.desired_amount then
                    print("Line 55: Not enough resources for card number " .. card_num)
                    memory_cards[card_num].good = false
                    alls_good = false
                else
                    print("Line 58: Enough resources for card number " .. card_num)
                    memory_cards[card_num].good = true
                end
            end
        end
    end

    local function recheck_slot(card_label, slot)
        print("Line 64: Rechecking slot " .. slot .. " for card label " .. card_label)
        local itemInSlot = inv.getStackInInternalSlot(slot)
        if itemInSlot and itemInSlot.label == card_label then
            print("Line 67: Slot " .. slot .. " contains the correct item")
            return true
        else
            print("Line 69: Slot " .. slot .. " does not contain the correct item, rereading memory cards")
            read_memory_cards()
        end
    end

    for card_num, card_info in ipairs(memory_cards) do
        print("Line 74: Processing card number " .. card_num)
        if card_info.good then
            print("Line 76: Card number " .. card_num .. " is good, setting redstone output")
            rs.setOutput({[0] = 15, 15, 15, 15, 15, 15})
        else
            alls_good = false
            local resource_in_stock = me.getItemsInNetwork({label = card_info.desired_resource_label})
            if resource_in_stock and resource_in_stock[1] and resource_in_stock[1].size then
                if resource_in_stock[1].size < card_info.desired_amount then
                    print("Line 83: Not enough resources for card number " .. card_num)
                    if recheck_slot(card_info.label, card_info.inventory_slot_techTech) and recheck_slot(card_info.label, card_info.inventory_slot_datastick) then
                        print("Line 85: Rechecking slots successful, using robot to process")
                        robot.select(card_info.inventory_slot_techTech)
                        inv.equip()
                        robot.use()
                        inv.equip()
                        robot.down()
                        robot.select(card_info.inventory_slot_datastick)
                        inv.equip()
                        robot.use()
                        inv.equip()
                        robot.up()
                        rs.setOutput({[0] = 0, 0, 0, 0, 0 ,0})
                        while (me.getItemsInNetwork({label = card_info.desired_resource_label})[1].size or 0) < card_info.desired_amount do
                            print("Line 95: Waiting for resources to reach desired amount")
                            os.sleep(20)
                        end
                    else
                        print("Line 98: Rechecking slots failed")
                    end
                else
                    print("Line 101: Resources are sufficient for card number " .. card_num)
                    memory_cards[card_num].good = true
                end
            else
                print("Line 104: Resource not found in network, using robot to process")
                robot.select(card_info.inventory_slot_techTech)
                inv.equip()
                robot.use()
                inv.equip()
                robot.down()
                robot.select(card_info.inventory_slot_datastick)
                inv.equip()
                robot.use()
                inv.equip()
                robot.up()
                rs.setOutput({[0] = 0, 0, 0, 0, 0 ,0})
                os.sleep(200)
            end
        end
    end
    if alls_good then
        print("Line 118: All cards are good, setting redstone output and starting recheck loop")
        rs.setOutput({[0] = 15, 15, 15, 15, 15, 15})
        read_memory_cards()
        recheck_cards()
        if alls_good then
            while true do
                print("Line 124: Rechecking cards in loop")
                recheck_cards()
                if not alls_good then
                    print("Line 126: Not all cards are good, breaking loop")
                    break
                end
                os.sleep(30)
            end
        end
    end
end

-----------------------------------------
--- The Loop

print("Line 134: Reading memory cards initially")
read_memory_cards()

while true do
    print("Line 137: Starting main loop")
    main()
end


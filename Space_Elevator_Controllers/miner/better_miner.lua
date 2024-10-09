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
    local invSize = robot.inventorySize()
    memory_cards = {}
    for i = 1, invSize do
        local card = inv.getStackInInternalSlot(i)
        if card and card.name and card.name == "tectech:item.em.parametrizerMemoryCard" then
            local string_location, _ = string.find(card.label, ":", 1, true)
            local memory_card_info = {
                label = card.label,
                desired_resource_label = string.sub(card.label, 1, string_location-1),
                desired_amount = tonumber(string.sub(card.label, string_location+2)),
                inventory_slot_techTech = i
            }
            for j = 1, invSize do
                local data = inv.getStackInInternalSlot(j)
                if data and data.name and data.name == "gregtech:gt.metaitem.01" then
                    if data.label == card.label then
                        memory_card_info.inventory_slot_datastick = j
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
    local alls_good = true

    local function recheck_cards()
        for card_num, card_info in ipairs(memory_cards) do
            local resource_in_stock = me.getItemsInNetwork({label = card_info.desired_resource_label})
            if resource_in_stock and resource_in_stock[1] and resource_in_stock[1].size then
                if resource_in_stock[1].size < card_info.desired_amount then
                    memory_cards[card_num].good = false
                    alls_good = false
                else
                    memory_cards[card_num].good = true
                end
            end
        end
    end

    local function recheck_slot(card_label, slot)
        local itemInSlot = inv.getStackInInternalSlot(slot)
        if itemInSlot and itemInSlot.label == card_label then
            return true
        else
            read_memory_cards()
        end
    end

    for card_num, card_info in ipairs(memory_cards) do
        if card_info.good then
            rs.setOutput({ [0] = 15, 15, 15, 15, 15, 15})
        else
            alls_good = false
            local resource_in_stock = me.getItemsInNetwork({label = card_info.desired_resource_label})
            if resource_in_stock and resource_in_stock[1] and resource_in_stock[1].size then
                if resource_in_stock[1].size < card_info.desired_amount then
                    if recheck_slot(card_info.label, card_info.inventory_slot_techTech) and recheck_slot(card_info.label, card_info.inventory_slot_datastick) then
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
                            os.sleep(20)
                        end
                    else

                    end
                else
                    memory_cards[card_num].good = true
                end
            else
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
        rs.setOutput({[0] = 15, 15, 15, 15, 15, 15})
        read_memory_cards()
        recheck_cards()
        if alls_good then
            while true do
                recheck_cards()
                if not alls_good then
                    break
                end
                os.sleep(30)
            end
        end
    end
end

-----------------------------------------
--- The Loop

read_memory_cards()

while true do
    main()
end


local component = require("component")
local event = require("event")
local me = component.upgrade_me
local inv = component.inventory_controller
local robot = require("robot")
local rs = component.redstone

--name as variable name actually refers to the label of the item we want to mine.

-----------------------------------------
--- Returning information about resources we are to stock

local function get_maintained_resource_information(memory_card)
    local stack = inv.getStackInInternalSlot(memory_card)
    local label = stack.label
    local j, _ = string.find(label, ":", 1, true)
    local name = string.sub(label, 1, j - 1)
    local target = tonumber(string.sub(label, j + 2))

    return name, target
end

local function get_amount_in_storage(name)
    local amount_in_storage = me.getItemsInNetwork({label = name})[1].size

    return tonumber(amount_in_storage)
end

local function is_resource_stocked(target, amount_in_storage)
    return amount_in_storage >= target
end

-----------------------------------------'
--- Setting up information for control logic

local function create_table_of_unique_cards()
    local memory_cards = {}
    for i = 1, robot.inventorySize() do
        local memory_card = inv.getStackInInternalSlot(i)
        if memory_card and memory_card.name == "tectech:item.em.parametrizerMemoryCard" then
            memory_cards[memory_card.label] = {}

            local resource_to_be_mined, target = get_maintained_resource_information(memory_card)

            memory_cards[memory_card.label].resource_to_be_mined = resource_to_be_mined
            memory_cards[memory_card.label].target = target
        end
    end
    return memory_cards
end

--[[
    memory_cards = {
        memory_card_label = {
            resource_to_be_mined = "resource_label",
            target = target_amount }}
]]


-----------------------------------------
--- control logic

local function determine_next_cards_label(memory_cards)
    local selected_card = {
        memory_card_label = nil, --memory_cards[index]
        amount_still_required = 0
    }

    for index, memory_card_label in pairs(memory_cards) do
        local amount_in_storage = get_amount_in_storage(memory_card_label.resource_to_be_mined)
        if is_resource_stocked(memory_card_label.target, amount_in_storage) then
            --goto next_memory_card
        else
            local current_needs = memory_card_label.target - amount_in_storage
            if selected_card.resource < current_needs then
                selected_card.label = memory_card_label
                selected_card.amount_still_required = current_needs
            end
        end
        --::next_memory_card::
    end

    if selected_card.memory_card_label == nil then
        return nil
    end
    return selected_card
end

-----------------------------------------
--- Operation

local function set_redstone(l)
    rs.setOutput({[0]=l,l,l,l,l,l})
end

local function wait_for_redstone_signal()
    event.pull("redstone_changed")
end

local function right_click_on_miner(i)
    robot.select(i)
    inv.equip()
    robot.use()
    inv.equip()
end

local function set_new_miner_config(selected_card)
    for i = 1, robot.inventorySize() do
        local memory_card = inv.getStackInInternalSlot(i)
        if memory_card and memory_card.label == selected_card.memory_card_label and memory_card.name == "tectech:item.em.parametrizerMemoryCard" then
            right_click_on_miner(i)
            break
        end
    end
    while not robot.up() do
        os.sleep(0.2)    ------------- perfect place to make your robot use a speech upgrade if enabled and installed to start wailing about its head.. 
    end 
    for i = 1, robot.inventorySize() do
        local memory_card = inv.getStackInInternalSlot(i)
        if memory_card and memory_card.label == selected_card.memory_card_label and memory_card.name == "gregtech:gt.metaitem.01" then
            right_click_on_miner(i)
            break
        end
    end
    while not robot.down() do
        os.sleep(0.2)    ------------- perfect place to make your robot use a sound card to make start making fart noises.. couple with speech to really sell it
    end
end

-----------------------------------------
--- Handle Changes to maintaining requirements

local reinitialize = false

local function notify_loop_to_reset()
    reinitialize = true
end

event.listen("inventory_changed", notify_loop_to_reset)

-----------------------------------------
--- Main Loop

while true do
    reinitialize = false
    local memory_cards = create_table_of_unique_cards()
    local previous_card_label = nil
    while true do
        if reinitialize then break end

        local selected_card = determine_next_cards_label(memory_cards)

        if selected_card and selected_card.label ~= previous_card_label then
            set_redstone(0)
            wait_for_redstone_signal()
            set_new_miner_config(selected_card)
            set_redstone(15)
        end

        if selected_card then
            previous_card_label = selected_card.label
        end
        os.sleep(100)
    end
end

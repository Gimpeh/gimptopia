local component = require("component")
local robot = require("robot")
local inv = component.inventory_controller
local sides = require("sides")

local amount = 10000000

local tbl = {
    [1] = {
            type = "fluid",
            [1] = "Molten Silicone Rubber",
            [2] = "Molten Styrene-Butadiene Rubber",
            [3] = "Molten Polyphenylene Sulfide",
            [4] = "Molten Rubber"
    },
    [2] = {
            type = "fluid",
            [1] = "Molten Polyethylene",
            [2] = "Molten Polyvinyl Chloride",
            [3] = "Molten Polytetrafluoroethylene",
            [4] = "Molten Polystyrene",
            [5] = "Molten Epoxid",
            [6] = "Molten Polybenzimidazole"
    },
    [3] = {
            type = "solid",
            [1] = "Thorium 232 Dust",
            [2] = "Uranium 233 Dust",
            [3] = "Uranium 235 Dust",
            [4] = "Plutonium-238 Dust",
            [5] = "Plutonium 239 Dust"
            --[6] = "Plutonium 241 Dust"
    },
    [4] = {
            type = "solid",
            [1] = "Titanium Dust",
            [2] = "Tungstensteel Dust",
            [3] = "Tungstencarbide Dust",
            [4] = "Indium Dust"
    },
    [5] = {
            type = "solid",
            [1] = "Rhodium Dust",
            [2] = "Ruthenium Dust"
    },
    [6] = {
            type = "fluid",
            [1] = "Molten Osmium",
            [2] = "Molten Iridium",
            [3] = "Molten Platinum",
            [4] = "Molten Palladium"
    },
    [7] = {
            type = "fluid",
            [1] = "Ethyl Cyanoacrylate (Super Glue)",
            [2] = "Advanced Glue",
            [3] = "Molten Indalloy 140",
            [4] = "Molten Soldering Alloy"
    },
    [8] = {
            type = "solid",
            [1] = "Cerium Dust",
            [2] = "Gadolinium Dust",
            [3] = "Samarium Dust",
            [4] = "Hafnia Dust",
            [5] = "Zirconium Dust"
    },
    [9] = {
            type = "solid",
            [1] = "Holmium Dust",
            [2] = "Lanthanum Dust"
    },
    [10] = {
            type = "fluid",
            [1] = "Grade 1 Purified Water",
            [2] = "Grade 2 Purified Water",
            [3] = "Grade 3 Purified Water",
            [4] = "Grade 4 Purified Water"
    },
    [11] = {
            type = "fluid",
            [1] = "Hydrogen Plasma"
    },
    [12] = {
            type = "mixed",
            solid = {
                [1] = "Stemcells"
            },
            fluid = {
                [1] = "Raw Growth Catalyst Medium",
                --[2] = "Growth Catalyst Medium"
            }
    },
    [13] = {
            type = "solid",
            --[1] = "Inert Naquadah Dust",
            [1] = "Adamantium Dust",
            [2] = "Gallium Dust"
    },
    [14] = {
            type = "solid",
            --[1] = "Inert Enriched Naquadah Dust",
            [1] = "Trinium Dust"
    },
    [15] = {
            type = "mixed",
            solid = {
                [1] = "Biocells"
            },
            fluid = {
                --[1] = "Mutated Living Solder",
                --[2] = "Sterilized Bio Catalyst Medium",
                [1] = "Raw Bio Catalyst Medium"
            }
    },
    [16] = {
        --
        --rest of the purified waters
            type = "fluid",
            [1] = "Grade 5 Purified Water",
            [2] = "Grade 6 Purified Water",
            [3] = "Grade 7 Purified Water",
            [4] = "Grade 8 Purified Water"
        
    },
    [17] = {
            type = "mixed",
            solid = {
                [1] = "T Ceti E Seaweed",
                [2] = "TCetiE-Seaweed Extract"
            },
            fluid = {
                [1] = "Seaweed Broth",
                [2] = "Iodine"
            }
    },
    [18] = {
            type = "fluid",
            --[1] = "Xenoxene",
            --[2] = "Molten Radox Polymer",
            [1] = "Heavy Radox",
    },
    [19] = {
            type = "fluid",
            [1] = "Polyurethane Resin",
            [2] = "Liquid Crystal Kevlar",
            [3] = "Molten Kevlar"
    },
    [20] = {
            type = "solid",
            --[1] = "Inert Naquadria Dust",
            [1] = "Barium Dust"
    },
    [21] = {
            type = "mixed",
            solid = {
                [1] = "Shirabon Dust"
            },
            fluid = {
                [1] = "Molten Eternity",
                [2] = "Tachyon Rich Temporal Fluid"
            }
    }
}

local tbl2 = {
    ["Plutonium 241 Dust"] = {
        card = 3,
        amount = 100000
    },
    ["Unknown Particle"] = {
        card = 11,
        amount = 10000
    },
    ["Inert Naquadah Dust"] = {
        card = 13,
        amount = 200 -- don't need more, stocking molten
    },
    ["Inert Enriched Naquadah Dust"] = {
        card = 14,
        amount = 200 -- don't need more, stocking molten
    },
    ["Inert Naquadria Dust"] = {
        card = 20,
        amount = 200 -- don't need more, stocking molten
    },
    ["Black Body Naquadria Supersolid"] = {
        card = 20,
        amount = 3000 
    }
}
local tbl3 = {
    ["Growth Catalyst Medium"] = {
        card = 12,
        amount = 500000000 --need for circuits
    },
    --[[ ["Mutated Living Solder"] = {
        card = 15,
        amount = 500000000 --need for everything
    }, ]]
    ["Sterilized Bio Catalyst Medium"] = {
        card = 15,
        amount = 500000000 --need for circuits
    },
    ["Xenoxene"] = {
        card = 18,
        amount = 450000000 --need for everything
    },
    ["Molten Radox Polymer"] = {
        card = 18,
        amount = 150000000 --need for everything
    },
    ["Molten Polybenzimidazole"] = {
        card = 2,
        amount = 1000000000
    },
    ["Molten Iridium"] = {
        card = 6,
        amount = 1000000000
    }
}

local function wait_till_done(item_name, item_type, amount2)
    local item
    local amount3 = (amount2 or amount)
    while true do
        if item_type == "solid" then
            item = component.upgrade_me.getItemsInNetwork({label = item_name})
            if item and item[1] then
                print("Waiting For: " .. tostring(item[1].label))
            else
                print("Item not in storage")
                item = {}
                item[1] = {}
                item[1].size = 0
                item[1].label = item_name
            end
            if item[1].size >= amount3 then
                print("Item Stocked", item_name)
                return
            end
        elseif item_type == "fluid" then
            local item_flag = false
            item = component.upgrade_me.getFluidsInNetwork()
            for d = 1, #item do
                if item[d].label == item_name then
                    item_flag = true
                    print("Waiting For: " .. tostring(item[d].label))
                    if item[d].amount >= amount3 then
                        print("Item Stocked", item_name)
                        return
                    end
                end
            end
            if not item_flag then
                print("212 - Item not in storage")
            end
        end
        os.sleep(10)
    end
end

local function findCard(card_name, item_name, item_type, amount2)
    for e = 1, robot.inventorySize() do
        if inv.getStackInInternalSlot(e) and inv.getStackInInternalSlot(e).label and inv.getStackInInternalSlot(e).label == tostring(card_name) then
            robot.select(e)
            inv.equip()
            robot.useUp()
            inv.equip()
            wait_till_done(item_name, item_type, amount2)
--[[            local derping = component.upgrade_me.getItemsInNetwork({label = derp})
            if derping and derping[1] then
                while component.upgrade_me.getItemsInNetwork({label = derp})[1].size < amount do
                    print(name .. " : " .. tostring(component.upgrade_me.getItemsInNetwork({label = derp})[1].size))
                    os.sleep(2)
                end
                return true
            else
                derping = component.upgrade_me.getFluidsInNetwork()
                for i = 1, #derping do
                    if derping[i].label == derp then
                        while true do
                            os.sleep(2)
                            derping = component.upgrade_me.getFluidsInNetwork()
                            for j = 1, #derping do
                                if derping[j].label == derp then
                                    if derping[j].amount >= amount then
                                        return true
                                    end
                                    break
                                end
                            end
                        end
                    end
                end
                return false
            end]]
        end
    end
    return false
end

local function main()
    for k, v in ipairs(tbl) do
        print("at point " .. tostring(k) .. " in table")
        for _, j in ipairs(tbl[k]) do
            print("checking material " .. j)
            if tbl[k].type == "solid" then
                print("table type is solid")
                local item = component.upgrade_me.getItemsInNetwork({label = j})
                if item and item[1] then
                    print("checking against: " .. tostring(item[1].label))
                else
                    print("no item found")
                    item = {}
                    item[1] = {}
                    item[1].size = 0
                    item[1].label = j
                end
                if item[1].size < amount then
                    print("Not Enough In Stock : ", tostring(j))
                    --find the card named i and sleep for 100 seconds or wtvr
                    local suc, err = pcall(findCard, k, j, tbl[k].type)
                    if suc and err then
                        print("farmed a material : ", tostring(j))
                    elseif suc and not err then
                        print("No card found")
                    elseif not suc then
                        print("Error in findCard : " .. err)
                    end
                end
            elseif tbl[k].type == "fluid" then
                print("table type is fluid")
                local item_flag = false
                local item = component.upgrade_me.getFluidsInNetwork()
                for e = 1, #item do
                    if item[e].label == j then
                        item_flag = true
                        print("checking " .. item[e].label .. " against " .. j) 
                        if item[e].amount < amount then
                            print("Not Enough In Stock : ", tostring(j))
                            --find the card named i and sleep for 100 seconds or wtvr
                            local suc, err = pcall(findCard, k, j, tbl[k].type)
                            if suc and err then
                                print("farmed a material : ", tostring(j))
                            elseif suc and not err then
                                print("No card found")
                            elseif not suc then
                                print("Error in findCard : " .. err)
                            end
                        end
                    end
                end
                if not item_flag then
                    print("No item found")
                    local suc, err = pcall(findCard, k, j, tbl[k].type)
                    if suc and err then
                        print("farmed a material : ", tostring(j))
                    elseif suc and not err then
                        print("No card found")
                    elseif not suc then
                        print("Error in findCard : " .. err)
                    end
                end
            elseif tbl[k].type == "mixed" then
                print("table type is mixed")
                for _, i in ipairs(tbl[k].solid) do
                    print("checking solid material " .. i)
                    local item = component.upgrade_me.getItemsInNetwork({label = i})
                    if item and item[1] then
                        print("checking " .. item[1].label .. " against " .. i)
                    else
                        print("no item found")
                        item = {}
                        item[1] = {}
                        item[1].size = 0
                        item[1].label = i
                    end
                    if item[1].size < amount then
                        print("Not Enough In Stock : ", tostring(i))
                        --find the card named i and sleep for 100 seconds or wtvr
                        local suc, err = pcall(findCard, k, j, "solid")
                        if suc and err then
                            print("farmed a material : ", tostring(j))
                        elseif suc and not err then
                            print("No card found")
                        elseif not suc then
                            print("Error in findCard : " .. err)
                        end
                    end
                end
                for _, i in ipairs(tbl[k].fluid) do
                    local item_flag = false
                    print("checking fluid material " .. i)
                    local item = component.upgrade_me.getFluidsInNetwork()
                    for e = 1, #item do
                        print("checking " .. item[e].label .. " against " .. i)
                        if item[e].label == i then
                            item_flag = true
                            print("found a match")
                            if item[e].amount < amount then
                                print("Not Enough In Stock : ", tostring(i))
                                --find the card named i and sleep for 100 seconds or wtvr
                                local suc, err = pcall(findCard, k, j, "fluid")
                                if suc and err then
                                    print("farmed a material : ", tostring(j))
                                elseif suc and not err then
                                    print("No card found")
                                elseif not suc then
                                    print("Error in findCard : " .. err)
                                end
                            end
                        end
                    end
                    if not item_flag then
                        print("No item found")
                        local suc, err = pcall(findCard, k, j, "fluid")
                        if suc and err then
                            print("farmed a material : ", tostring(j))
                        elseif suc and not err then
                            print("No card found")
                        elseif not suc then
                            print("Error in findCard : " .. err)
                        end
                    end
                end
            end
        end
    end
    for k, v in pairs(tbl2) do
        print("checking for " .. k)
        local item = component.upgrade_me.getItemsInNetwork({label = k})
        if item and item[1] then
            print("checking against: " .. tostring(item[1].label))
        else
            print("no item found")
            item = {}
            item[1] = {}
            item[1].size = 0
            item[1].label = k
        end
        if item[1].size < v.amount then
            print("Not Enough In Stock : ", tostring(k))
            --find the card named i and sleep for 100 seconds or wtvr
            local suc, err = pcall(findCard, v.card, k, "solid", v.amount)
            print("farmed a material : ", tostring(k))
        else
            print("No card found")
        end
    end
    for k, v in pairs(tbl3) do
        local fluids = component.upgrade_me.getFluidsInNetwork()
        for index, fluid in ipairs(fluids) do
            if fluid.label == k then
                if fluid.amount < v.amount then
                    print("Not Enough " .. k .. " In Stock")
                    local suc, err = pcall(findCard, v.card, k, "fluid", v.amount)
                    if not suc then print("Error in findCard : " .. err) end
                end
                break
            end
        end
    end
    print("one full loop dunzo!")
    os.sleep(300)
end

while true do
    local suc, err = pcall(main)
    if not suc then
        print("DERPING ERROR IN MAIN!!! - " .. err)
    end
    os.sleep(1)
end

local function getPeripheral(name)
    
    local peri = peripheral.wrap(name)

    if peri > 0 then
        return peri
    else
        error("can't find peripheral type: "..type)
    end
end

local function inventoryFactory(name)
    local peri = getPeripheral(name)

    local getStackInSlot = function(slot)
        return peri.getStackInSlot(slot)
    end

    local getAllStacks = function()
        local allStacks = {}
        for slot = 1, peri.getInventorySize() do
            allStacks[#allStacks+1] = getStackInSlot(slot)
        end

        return allStacks
    end

    local pullItem = function(direction, slot, maxAmount, intoSlot)
        maxAmount = maxAmount or 64
        intoSlot = intoSlot or 1

        if not direction then 
            return false, "inventoryFactory:pullItem --> missing direction argument"
        end

        if not slot then 
            return false, "inventoryFactory:pullItem --> missing direction argument"
        end

        return peri.pullItem(direction, slot, maxAmount, intoSlot)
    end

    local pushItem = function(direction, slot, maxAmount, intoSlot)
        maxAmount = maxAmount or 64
        intoSlot = intoSlot or 1

        if not direction then 
            return false, "inventoryFactory:pushItem --> missing direction argument"
        end

        if not slot then 
            return false, "inventoryFactory:pushItem --> missing direction argument"
        end

        return peri.pushItem(direction, slot, maxAmount, intoSlot)
    end

    return {
            peri = peri,
            getStackInSlot= getStackInSlot,
            getAllStacks = getAllStacks,
            pullItem = pullItem,
            pushItem = pushItem
        }
end
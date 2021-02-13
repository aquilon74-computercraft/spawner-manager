os.loadAPI("inventory.lua")

local function getPeripheral(name)
    
    local peri = peripheral.wrap(name)

    if peri > 0 then
        return peri
    else
        error("can't find peripheral type: "..type)
    end
end

local function meInterfaceFactory(name)
    
    local peri = getPeripheral(name)
    local inv = inventory.inventoryFactory(name)


    local getAllItems = function()
        return peri.getAvailableItems("ALL")
    end

    local getItemDetail = function(fingerprint)
        return peri.getItemDetail(fingerprint).all()
    end


    local exportItem = function(fingerprint, direction, maxAmount, intoSlot)
        maxAmount = maxAmount or 64
        intoSlot = intoSlot or 1

        if not fingerprint then 
            return false, "meInterfaceFactory:exportItem --> missing fingerprint argument"
        end

        if not direction then 
            return false, "meInterfaceFactory:exportItem --> missing direction argument"
        end

        if not peri.canExport(direction) then
            return false, "meInterfaceFactory:exportItem --> can't export to "..direction
        end

        return peri.exportItem(fingerprint, direction, maxAmount, intoSlot).size
    end

    return {
        pushItem = inv.pushItem,
        pullItem = inv.pullItem,
        getAllItems = getAllItems,
        getItemDetail = getItemDetail,
        exportItem = exportItem
    }
end
--API json
if fs.exists('json') == false then
    shell.run('pastebin get SVATc8pr json')
end
  
os.loadAPI("/lib/json")
os.loadAPI("me_interface.lua")




    
-- get config
local fh = fs.open("config.json", "r")
local config = json.decode(fh.readAll())
fh.close()


-- get item moving directions in config
local direction = config.direction


-- get peripherals types in config
local meInterfaceName = config.peripheralName

-- get meInterface object
local meInterface = me_interface.meInterfaceFactory(meInterfaceName)

-- get items in config
local items = config.items

-- sort items by priority (highest priority first)
table.sort(items, function(first, second)
    if first.priority > second.priority then
        return true
    else
        return false
    end
end)



-- main part of the program
while true do
    -- remove potential safari net in spawner
    meInterface.pullItem(direction, 1)

    -- go through each item and check if there is enough of it
    -- otherwise, take the corresponding safari net and put it in the spawner
    for k, item in items do
        print("--------------------------")
        print("checking item "..item.name)
        print("quantity to keep: "..item.keep)

        -- get the quantity of the item
        local itemQty = meInterface.getItemDetail(item.itemFingerprint).all().qty
        print("quantity in storage: "..itemQty)


        -- if the quantity is less than to keep put the safari net
        if itemQty < item.keep then
            print("there isn't enough of this item")
            -- check if the safari net is in the me
            if meInterface.getItemDetail(item.safariNetFingerprint) then
                print("corresponding safari net is present.")
                print("moving safari net to spawner")

                -- move the safari net to the spawner
                local r, err = meInterface.exportItem(item.safariNetFingerprint, direction)
                
                if r then 
                    break
                else
                    print(err)
                    print("skipping to the next item") 
                end
            end
        end
        print("--------------------------")
    end
end




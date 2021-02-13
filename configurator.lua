--API json
if fs.exists('json') == false then
    shell.run('pastebin get SVATc8pr json')
end
  
os.loadAPI("/lib/json")

os.loadAPI("inventory.lua")
local inv = inventory.inventoryFactory("top")


local function loadConfig()
    if fs.exists("config.json", "r") then
        local fh = fs.open("config.json")
        local config = json.decode(fh.readAll())
        fh.close()
        return config
    end
end

local function saveConfig(config)
    local fh = fs.open("config.json", "w")
    fh.write(json.encode(config))
    fh.close()
end


local function clearConsole()
    term.clear()
    term.setCursorPos(1, 1)
end

local function prompt(message)
    print(message)
    local r = read()
    return r
end

local function printItems(items)
    for k, item in pairs(items) do
        print(k.." - "..item.name.." | "..item.priority.." | "..item.keep)
    end
end


local function setDirection()
    local config = loadConfig()
    clearConsole()
    local direction = prompt("Enter the direction to the spawner (DOWN,UP,NORTH,SOUTH,WEST,EAST):")

    config.direction = direction
    saveConfig(config)

    prompt("To return to the menu, press ENTER...")
end


local function setPeripheralName()
    local config = loadConfig()

    clearConsole()
    local type = prompt("Enter the direction to the spawner:")

    config.peripheralTypes = type
    saveConfig(config)

    prompt("To return to the menu, press ENTER...")
end



local function addItem()
    local config = loadConfig()
    
    if not config.items then
        config.items = {}
    end

    clearConsole()
    printItems()
    local name = prompt("Name of the item:")

    clearConsole()
    printItems()
    local keep = tonumber(prompt("Enter the quantity of "..name.."to keep:"))

    clearConsole()
    printItems()
    local priority = tonumber(prompt('Enter the priority for '..name))
    
    clearConsole()

    local itemFingerPrint = {}
    while itemFingerPrint == false do
        print("place the item to add in the first slot")
        prompt("and press ENTER...")

        itemFingerPrint = inv.getStackInSlot(1)
        if itemFingerPrint then
            print("Item: "..itemFingerPrint.display_name)
            prompt("To confirm, press ENTER...")
        else
            prompt("There is no item, retry")
        end
    end

    clearConsole()

    local safarinetFingerprint = {}
    while safarinetFingerprint == false do
        print("place the safari net in the first slot")
        prompt("and press ENTER...")

        safarinetFingerprint = inv.getStackInSlot(1)
        if safarinetFingerprint then
            prompt("To confirm, press ENTER...")
        else
            prompt("There is no safari net, retry")
        end
    end

    

    local item = {}
    item.itemsitemFingerprint = itemFingerPrint
    item.safariNetFingerprint = safarinetFingerprint
    item.name = name
    item.keep = keep
    item.priority = priority

    table.insert(config.items, item)
    saveConfig(config)

    clearConsole()
    print("Item: "..name.." added.")
    prompt("To return to the menu, press ENTER...")
    
end

local function removeItem()
    local config = loadConfig()
    
    if not config.items then
        print("No item to remove")
        prompt("To return to the menu, press ENTER...")
        return false
    end

    clearConsole()
    printItems()

    local n = tonumber(prompt("Enter the number of the item: "))

    local removed = config.items[n].name
    table.remove(config.items, n)
    saveConfig(config)

    print(removed.." has been removed")
    prompt("To return to the menu, press ENTER...")
end
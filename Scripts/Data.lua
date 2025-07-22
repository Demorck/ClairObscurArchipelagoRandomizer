JSON = require("json")

---@class ItemData
---@field type string Type of the item
---@field name string Internal name of the item
---@field progressive integer 0 is junk, 1 is progressive, 2 is useful


local Data = {}


Data.file_path = "F:/Project/UE4SS/Expedition 33/Mods/ClairObscureArchipelagoRandomizer/Archipelago33" -- need to change for relative path from the game when the mod is installed
Data.items = {}
Data.locations = {}



function Data.Load()
    if #Data.items > 0 then return end


    local items_path = "F:/Project/UE4SS/Expedition 33/Mods/ClairObscureArchipelagoRandomizer/Archipelago33/Items/items.json"
    local locations_path = "F:/Project/UE4SS/Expedition 33/Mods/ClairObscureArchipelagoRandomizer/Archipelago33/locations/locations.json"
    
    local content_items = JSON.read_file(items_path)
    local content_locations = JSON.read_file(locations_path)

    Data.items = content_items
    Data.locations = content_locations
end


return Data
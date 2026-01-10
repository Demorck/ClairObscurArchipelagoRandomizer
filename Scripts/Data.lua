JSON = require("Utils.json")

---@class ItemData
---@field type string Type of the item
---@field name string Player name of the item
---@field internal_name string Internal name of the item
---@field quantity integer
---@field progressive integer 0 is junk, 1 is progressive, 2 is useful


---@class LocationData
---@field internal_name string Internal name of the location (Chest_AncientSanctuary_2)
---@field name string Readable name of the location (Ancient Sanctuary: Sanctuary Maze - In dark cave before shortcut to flag 1)
---@field location string The region where is the location (Ancient Sanctuary)
---@field original_item string
---@field condition table not used here
---@field type string The type (chest, boss, dive, etc.)

---@class Data
---@field items ItemData[] | nil
---@field locations LocationData[] | nil
---@field local_variable table<string, any>
local Data = {}


Data.items = {}
Data.locations = {}
Data.local_variable = {}


function Data.Load()
    if #Data.items > 0 then return end
    Logger:info("Loading data...")

    local items_path = "ue4ss/Mods/COE33AP/data/items.json"
    local locations_path = "ue4ss/Mods/COE33AP/data/locations.json"
    local content_items = JSON.read_file(items_path)
    local content_locations = JSON.read_file(locations_path)

    Data.items = content_items
    if Data.items == nil then
        Logger:error("Failed to load items from " .. items_path)
    end
    
    Data.locations = content_locations
    if Data.locations == nil then
        Logger:error("Failed to load locations from " .. locations_path)
    end
end

---Return an entry if find it Data
---@param search_table ItemData[] | LocationData[]
---@param internal_name string
---@return ItemData | LocationData | table<ItemData> | table<LocationData> | nil
function Data:FindEntry(search_table, internal_name)
    local count = 0;
    local res = {}
    for _, row in pairs(search_table) do
        if row.internal_name == internal_name then
            count = count + 1
            table.insert(res, row)
        end
    end

    if count == 1 then
        return res[1]
    end

    if count > 1 then
        return res
    end

    Logger:warn("Entry not found in Data: " .. internal_name)
    return nil
end


return Data
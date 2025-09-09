JSON = require("json")
AREA_NAMES = {"GoblusLair", "AncientSanctuary", "SideLevel_RedForest", "EsquieNest", "SideLevel_OrangeForest", "SideLevel_CleasFlyingHouse", "ForgottenBattlefield", "SidelLevel_FrozenHearts", "GestralVillage", "MonocoStation", "Lumiere", "Monolith_Interior_PaintressIntro", "OldLumiere", "SideLevel_Reacher", "SideLevel_AxonPath", "SeaCliff", "Sirene", "SideLevel_TwilightSanctuary", "Visages", "SideLevel_YellowForest", "SideLevel_CleasTower_Entrance"}

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


Data.file_path = "F:/Project/UE4SS/Expedition 33/Mods/ClairObscureArchipelagoRandomizer/Archipelago33" -- need to change for relative path from the game when the mod is installed
Data.items = {}
Data.locations = {}
Data.local_variable = {}


function Data.Load()
    if #Data.items > 0 then return end
    Logger:info("Loading data...")

    local items_path = "F:/Project/UE4SS/Expedition 33/Mods/ClairObscureArchipelagoRandomizer/data/items.json"
    local locations_path = "F:/Project/UE4SS/Expedition 33/Mods/ClairObscureArchipelagoRandomizer/data/locations.json"
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
---@param table ItemData[] | LocationData[]
---@param internal_name string
---@return ItemData | LocationData | nil
function Data:FindEntry(table, internal_name)
    for _, row in pairs(table) do
        if row.internal_name == internal_name then
            return row
        end
    end

    Logger:warn("Entry not found in Data: " .. internal_name)
    return nil
end


return Data
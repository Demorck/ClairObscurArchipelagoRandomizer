---Location Sender
---Handles sending location checks and managing location data
local ArchipelagoState = require("Archipelago.ArchipelagoState")

---@class LocationSender
local LocationSender = {}

---Send a location check to the AP server
---@param location_name string Name of the location
function LocationSender:SendLocationCheck(location_name)
    local location_data = self:GetLocationFromAPData(location_name)
    if location_data == nil then return end

    local location_to_send = {}
    location_to_send[1] = location_data["id"]
    
    if not location_data then
        return
    end
    
    local function async()
        if ArchipelagoState.apSystem then
            ArchipelagoState.apSystem:GetClient():GetClient():LocationChecks(location_to_send)
        end
    end

    Logger:info("Location: \"" .. location_name .. "\" checked !")
    ExecuteAsync(async)
end

---Send victory/completion to the AP server
function LocationSender:SendVictory()
    if not ArchipelagoState.apSystem then return end
    
    ArchipelagoState.apSystem:GetClient():SendCompletion()
end

---Get location data from AP data
---@param location_name string Location name
---@return table|nil location Location data with id and name
function LocationSender:GetLocationFromAPData(location_name)
    local location_data = Data:FindEntry(Data.locations, location_name)
    
    if type(location_data) == "table" and #location_data > 1 then
        local res = self:HandleMultipleLocations(location_name, location_data)
        location_data = res
    end
    
    local location = {}

    if location_data == nil then
        Debug.print("Location_data is nil. Name of location: " .. location_name)
        return nil
    end

    if not ArchipelagoState.apSystem then
        return nil
    end
    
    location["id"] = ArchipelagoState.apSystem:GetClient():GetLocationId(location_data.name)

    if not location["id"] then
        return nil
    end

    location["name"] = location_data.name

    return location
end

---Handle locations with same name like generic chroma, petank
---@param location_name string Location name
---@param locations_data table<LocationData> Array of location data
---@return LocationData location The correct location data
function LocationSender:HandleMultipleLocations(location_name, locations_data)
    local level_name = ClientBP:GetLevelName()
    if level_name == nil then
        return locations_data[1]
    end

    local function HandleGenericChroma()
        local predicate = {
            ["World Map"] = "Level_WorldMap_Main_V2",
            ["Spring Meadows"] = "Level_SpringMeadows_Main_V2",
            ["The Monolith"] = "Level_Monolith_Interior_Climb_Main",
            ["Esquies Nest"] = "LevelMain_EsquieNest",
        }

        for _, loc in pairs(locations_data) do
            local region = loc["location"]
            if predicate[region] ~= nil and predicate[region] == level_name then
                return loc
            end
        end
    end

    local function HandleDiveItems()
        local res = locations_data[Storage.dive_items + 1]
        Storage.dive_items = Storage.dive_items + 1
        Storage:Update("LocationSender:HandleDiveItems")
        return res
    end

    local function HandlePetank()
        local predicate = {
            ["Sirene"] = "Level_Sirene_Main_V2",
            ["Ancient Sanctuary"] = "Level_AncientSanctuary_Main_V2",
            ["Frozen Hearts"] = "Level_Side_FrozenHeart",
            ["The Monolith"] = "Level_Monolith_Interior_Climb_Main",
            ["Isle of the Eyes"] = "SmallLevel_MF_Zone_01",
            ["Stone Wave Cliffs"] = "ConceptLevel_SeaCliff_V1",
            ["Flying Manor"] = "Level_CleaFlyingHouse_Main",
            ["Forgotten Battlefield"] = "Level_Main_ForgottenBattlefield_V2",
            ["Endless Night Sanctuary"] = "Level_Side_TwilightSanctuary",
            ["Esquie's Nest"] = "LevelMain_EsquieNest",
            ["The Reacher"] = "Level_Reacher_Main_V2"
        }

        for _, loc in pairs(locations_data) do
            local region = loc["location"]
            if predicate[region] ~= nil and predicate[region] == level_name then
                return loc
            end
        end
    end

    local res = nil
    if location_name == "Chest_Generic_Chroma" then
        res = HandleGenericChroma()
    elseif location_name == "Chest_Generic_5xLuminaPoint" then
        res = HandleDiveItems()
    elseif string.find(location_name, "^Petank") then
        res = HandlePetank()
    end

    return res or locations_data[1]
end

return LocationSender

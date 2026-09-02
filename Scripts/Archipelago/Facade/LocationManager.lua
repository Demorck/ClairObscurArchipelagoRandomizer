---Location Sender
---Handles sending location checks and managing location data
local ArchipelagoState = require("Archipelago.ArchipelagoState")

---@class LocationManager
local LocationManager = {}

---Send a location check to the AP server
---@param location_name string Name of the location
---@param force boolean If true, the location is not retrieve from json table but directly from the name and id from AP server
function LocationManager:SendLocationCheck(location_name, force)
    local location_data = self:GetLocationFromAPData(location_name, force)
    if location_data == nil or not location_data then 
        Logger:warn("Try to send location but the location_data is nil or empty. Location_name is: " .. location_name)
        return
    end

    local location_id = location_data["id"]
    local location_to_send = {}
    location_to_send[1] = location_id
    
    local function async()
        if ArchipelagoState.apSystem then
            ArchipelagoState.apSystem:GetClient():SendLocationChecks(location_to_send)
        end
    end

    Logger:info("Location: \"" .. location_name .. "\" checked, ID: " .. location_id .. " !")
    Storage:AddInTable("locations_checked", location_id)
    Storage:Update("LocationSender:SendLocationCheck")
    ExecuteAsync(async)
end

---Send a location check to the AP server
---@param location_id number ID of the location
function LocationManager:SendLocationCheckByID(location_id)
    local location_to_send = {}
    location_to_send[1] = location_id

    local function async()
        local apClient = ArchipelagoState.apSystem and ArchipelagoState.apSystem:GetClient()
        if apClient and apClient:IsConnected() then
            apClient:SendLocationChecks(location_to_send)
        else
            Logger:warn("Location '" .. location_id .. "' queued (not connected), will be sent on reconnect")
        end
    end


    Logger:info("Location checked, ID: " .. location_id .. " !")
    ExecuteAsync(async)
end

---Send victory/completion to the AP server
function LocationManager:SendVictory()
    if not ArchipelagoState.apSystem then return end
    
    ArchipelagoState.apSystem:GetClient():SendCompletion()
end

---Get location data from AP data
---@param location_name string Location name
---@return table|nil location Location data with id and name
function LocationManager:GetLocationFromAPData(location_name, force)
    if not ArchipelagoState.apSystem then
        return nil
    end
    
    local location = {}

    if force then
        location["id"] = ArchipelagoState.apSystem:GetClient():GetLocationId(location_name)
        location["name"] = location_name
    else
        location = self:GetLocationFromTable(location_name)
    end

    if location == nil or not location["id"] then
        return nil
    end
    
    return location
end

function LocationManager:GetLocationFromTable(location_name)
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

    location["id"] = ArchipelagoState.apSystem:GetClient():GetLocationId(location_data.name)

    if not location["id"] then
        return nil
    end

    location["name"] = location_data.name

    return location
end


function LocationManager:ScoutLocation(location_names, create_hint)
    if type(location_names) == "string" then
        location_names = { location_names }
    end

    local location_ids = {} 

    for _, location_name in ipairs(location_names) do
        local id = ArchipelagoState.apSystem:GetClient():GetLocationId(location_name)
        table.insert(location_ids, id)
    end


    -- print(location_ids)
    ArchipelagoState.apSystem:GetClient():ScoutLocations(location_ids, create_hint)
end

---Handle locations with same name like generic chroma, petank
---@param location_name string Location name
---@param locations_data table<LocationData> Array of location data
---@return LocationData location The correct location data
function LocationManager:HandleMultipleLocations(location_name, locations_data)
    local level_name = ClientBP:GetLevelName()
    if level_name == nil then
        return locations_data[1]
    end

    local function MatchCurrentLevel()
        local current = Regions.BY_LEVEL_ASSET[level_name]
        if current == nil then return nil end

        for _, loc in pairs(locations_data) do
            if Regions.BY_AP_NAME[loc["location"]] == current then
                return loc
            end
        end
    end

    local function HandleDiveItems()
        local position_world = Characters:GetPosition()
        if position_world == nil then return end

        --- Calculate the euclidian distance 
        ---@param d1 Position
        ---@param d2 Position
        local function euclidian_distance(d1, d2)
            return math.sqrt((d1.X - d2.X) ^ 2 + (d1.Y - d2.Y) ^ 2)
        end

        local location = nil
        local min_value = 9999999
        for _, value in pairs(CONSTANTS.GAME.TABLE.WORLDMAP_DIVE_POSITION) do
            local distance = euclidian_distance(value, position_world)
            if distance < min_value then
                min_value = distance
                for _, location_data in ipairs(locations_data) do
                    if location_data.name == value.NAME_AP then
                        location = location_data
                        break
                    end
                end
            end
        end
        
        return location
    end

    local res = nil
    if location_name == "Chest_Generic_Chroma" then
        res = MatchCurrentLevel()
    elseif location_name == "Chest_Generic_5xLuminaPoint" then
        res = HandleDiveItems()
    elseif string.find(location_name, "^Petank") then
        res = MatchCurrentLevel()
    end

    return res or locations_data[1]
end

return LocationManager

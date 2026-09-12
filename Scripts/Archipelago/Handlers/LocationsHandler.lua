---@class LocationsHandler
local LocationsHandler = {}

---Handle a batch of locations that has been checked
---This is the main entry point called by the EventDispatcher
---@param locations table<number> Locations id
function LocationsHandler:Handle(locations)
    if not locations then return end

    local playerInfo = ArchipelagoSystem:GetClient():GetPlayerInfo()

    for _, locationId in ipairs(locations) do
        self:ProcessLocation(locationId, playerInfo)
    end
end

---Process a single location from the server (currently does nothing but can be useful if we can remove loot on floor)
---Valdiates the location, send it to the server and mark as sent.
---@param locationId string|number the id of the Location
---@param playerInfo any
---@private
function LocationsHandler:ProcessLocation(locationId, playerInfo)
    local id = tonumber(locationId)
    if not id then
        Logger:error("Error converting location_id to number: " .. locationId)
        return
    end

    local locationName = ArchipelagoSystem:GetClient():GetLocationName(id, playerInfo.game)
    if not locationName then
        return
    end

    -- Mark as sent in data (for later, it can be useful but not in data)
    if Data and Data.locations then
        for _, loc in pairs(Data.locations) do
            if loc.name == locationName then
                --loc.sent = true
                break
            end
        end
    end
end

return LocationsHandler
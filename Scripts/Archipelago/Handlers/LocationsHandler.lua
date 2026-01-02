---@class LocationsHandlerDependencieis
---@field logger Logger Logger instance for logging item reception events
---@field apClient APClient AP client for getting item names and player info

---@class LocationsHandler
---@field logger Logger Logger instance for debugging and tracking
---@field apClient APClient Client for AP server communication
local LocationsHandler = {}

---Create a new LocationsHandler instance
---@param dependencies LocationsHandlerDependencieis Required dependencies
---@return LocationsHandler handler New LocationsHandler instance
function LocationsHandler:New(dependencies)
    local instance = {
        logger = dependencies.logger,
        apClient = dependencies.apClient,
    }

    setmetatable(instance, { __index = LocationsHandler })
    return instance
end

---Handle a batch of locations that has been checked
---This is the main entry point called by the EventDispatcher
---@param locations table<number> Locations id
function LocationsHandler:Handle(locations)
    if not locations then return end

    local playerInfo = self.apClient:GetPlayerInfo()

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
        self.logger:error("Error converting location_id to number: " .. locationId)
        return
    end

    local locationName = self.apClient:GetLocationName(id, playerInfo.game)
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
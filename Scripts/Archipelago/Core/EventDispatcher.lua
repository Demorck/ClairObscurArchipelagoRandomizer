---@class EventDispatcherDependencies
---@field logger Logger Logger instance for logging

---@alias EventHandler fun(data: any): nil

---@class EventDispatcher
---@field logger Logger Logger instance
---@field handlers table<string, EventHandler> Registered event handlers
local EventDispatcher = {}

---Create a new EventDispatcher instance
---@param dependencies EventDispatcherDependencies
---@return EventDispatcher
function EventDispatcher:New(dependencies)
    local instance = {
        logger = dependencies.logger,
        handlers = {
            slotConnected = function() end,
            itemsReceived = function() end,
            locationsChecked = function() end,
            bounced = function() end,
            retrieved = function() end,
        }
    }

    setmetatable(instance, { __index = EventDispatcher })
    return instance
end

--- Register a handler for an event type
---@param eventType string The type of event ("slotConnected", "itemsReceived", etc.)
---@param handler EventHandler The function to call when the event occurs
function EventDispatcher:RegisterHandler(eventType, handler)
    if not self.handlers[eventType] then
        self.logger:warn("Unknown event type: " .. eventType)
        return
    end

    self.handlers[eventType] = handler
    self.logger:info("Registered handler for event: " .. eventType)
end

---Dispatch slot connected event
---Called when successfully connected to an Archipelago slot
---@param slotData table Slot data received from AP server
function EventDispatcher:OnSlotConnected(slotData)
    self.logger:info("Slot connected event received")

    local ok, err = pcall(self.handlers.slotConnected, slotData)
    if not ok then
        self.logger:error("Error in slotConnected handler: " .. tostring(err))
    end
end

---Dispatch items received event
---Called when items are received from the AP server
---@param items NetworkItem[] Array of received items
function EventDispatcher:OnItemsReceived(items)
    self.logger:debug("Items received event")

    local ok, err = pcall(self.handlers.itemsReceived, items)
    if not ok then
        self.logger:error("Error in itemsReceived handler: " .. tostring(err))
    end
end

---Dispatch locations checked event
---Called when locations have been checked by other players
---@param locations number[] Array of location IDs that were checked
function EventDispatcher:OnLocationsChecked(locations)
    self.logger:debug("Locations checked event")

    local ok, err = pcall(self.handlers.locationsChecked, locations)
    if not ok then
        self.logger:error("Error in locationsChecked handler: " .. tostring(err))
    end
end

---Dispatch bounced event
---Called when a bounce message is received (DeathLink)
---@param data table|string Bounced data (can be JSON string or table)
function EventDispatcher:OnBounced(data)
    self.logger:debug("Bounced event received")

    local ok, err = pcall(self.handlers.bounced, data)
    if not ok then
        self.logger:error("Error in bounced handler: " .. tostring(err))
    end
end

---Dispatch retrieved event
---Called when data storage retrieval completes
---@param data any Retrieved data
function EventDispatcher:OnRetrieved(data)
    self.logger:debug("Retrieved event received")

    local ok, err = pcall(self.handlers.retrieved, data)
    if not ok then
        self.logger:error("Error in retrieved handler: " .. tostring(err))
    end
end

return EventDispatcher
---@class DeathLinkHandlerDependencies
---@field logger Logger Logger instance for logging

---@class DeathLinkHandler
---@field logger Logger Logger instance
---@field archipelago Archipelago|nil Archipelago instance for legacy support (for now)
local DeathLinkHandler = {}

---Create a new EventDispatcher instance
---@param dependencies DeathLinkHandlerDependencies
---@return DeathLinkHandler
function DeathLinkHandler:New(dependencies)
    local instance = {
        logger = dependencies.logger,
        archipelago = nil,
    }

    setmetatable(instance, { __index = DeathLinkHandler })
    return instance
end

---Set the Archipelago reference (called after initialization)
---This is needed because of circular dependencies between DeathLinkHandler and Archipelago
---@param archipelago Archipelago The main Archipelago facade instance
function DeathLinkHandler:SetArchipelago(archipelago)
    self.archipelago = archipelago
end

---Handle a bounce data
---This is the main entry point called by the EventDispatcher
---Filter and process the data ensuring is a correct format before handle death link
---@param bounceData any Array of items received from server
function DeathLinkHandler:Handle(bounceData)
    local json = bounceData
    if type(json) == "string" then
        json = JSON.decode(json)
    end

    local tags = json.tags
    local data = json.data

    if not tags or not data then
        return
    end

    for _, tag in ipairs(tags) do
        if tag == "DeathLink" then
            self:HandleDeathLink(data)
            return
        end
    end
end

---Handle death link (if a player with the tag "DeathLink" dies)
---@param data table<string, any> The death link data
function DeathLinkHandler:HandleDeathLink(data)
    if not self.archipelago then return end

    local currentDeathLink = data.time

    self.logger:info("DeathLink received: " .. Dump(data))
    self.logger:info("Last received at: " .. self.archipelago.lastDeathLink)

    -- Process death link
    if Battle and Battle:InBattle() then
        self.logger:info("DeathLink during battle: " .. data.cause)
        if Characters then
            Characters:KillAll()
        end
    else
        self.logger:info("DeathLink outside battle: " .. data.cause)
        if Inventory then
            Inventory:RemoveConsumable()
        end
        if Characters then
            Characters:SetHPAll(1)
        end
    end

    self.archipelago.lastDeathLink = currentDeathLink
end

return DeathLinkHandler
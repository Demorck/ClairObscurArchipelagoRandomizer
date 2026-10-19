---@class DeathLinkHandler
local DeathLinkHandler = {}

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
    if not Archipelago then return end

    if data.source == Archipelago.slot then
        return
    end

    if not Archipelago:CanReceiveDeathLink() then
        local last = Archipelago:LastDeathLinkInSeconds()
        Logger:info("Receiving deathlink but the last one was in " .. last .. " seconds, aborting it...")
        return
    end

    Archipelago.wasDeathLinked = true
    local currentDeathLink = data.time

    Logger:info("DeathLink received: " .. Dump(data))
    Logger:info("Last received at: " .. Archipelago.lastDeathLink)

    if data.cause == nil then
        data.cause = data.source
    end

    -- Process death link
    if Battle and Battle:InBattle() then
        Logger:info("DeathLink during battle: " .. data.cause)
        if Characters then
            Characters:KillAll()
        end
    else
        Logger:info("DeathLink outside battle: " .. data.cause)
        if Inventory then
            Inventory:RemoveConsumable()
        end
        if Characters then
            Characters:SetHPAll(1)
        end
    end

    Archipelago.lastDeathLink = currentDeathLink
    Archipelago.wasDeathLinked = false
end

return DeathLinkHandler
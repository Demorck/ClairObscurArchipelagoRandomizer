---DeathLink Manager
---Handles DeathLink sending and receiving

---@class DeathLinkManager
local DeathLinkManager = {}

---Send DeathLink to other players
---@param msg string Death message
---@param players_id table|nil Player IDs to send to
---@param games table|nil Games to send to
---@param tags table|nil Tags for the bounce
function DeathLinkManager:SendDeathLink(msg, players_id, games, tags)
    if not Archipelago:IsInitialized() then return end

    players_id = players_id or {}
    games      = games or {}
    tags       = tags or {}
    msg        = msg or {}

    local data = {}
    data["time"] = Archipelago:GetClient():GetServerTime()

    local playerInfo = Archipelago:GetClient():GetPlayerInfo()
    local slotName = playerInfo.alias or "Unknown"

    if not string.find(msg, slotName) then
        msg = slotName .. " " .. msg
    end

    data["cause"] = msg
    data["source"] = slotName

    table.insert(tags, "DeathLink")

    Archipelago:GetClient():Bounce(data, games, players_id, tags)
    Logger:info("Sending DeathLink with cause: " .. msg .. " from source: " .. slotName)
end

return DeathLinkManager

---DeathLink Manager
---Handles DeathLink sending and receiving
local ArchipelagoState = require("Archipelago.ArchipelagoState")

---@class DeathLinkManager
local DeathLinkManager = {}

---Handle incoming DeathLink
---@param data table DeathLink data from AP
function DeathLinkManager:HandleDeathLink(data)
    local currentDeathLink = data["time"]

    Logger:info("DeathLink Received with data: " .. Dump(data))
    Logger:info("Last received in: " .. ArchipelagoState.lastDeathLink)

    if Battle:InBattle() then
        Logger:info("Death link receiving during battle.")
        Logger:info(data["cause"])
        Characters:KillAll()
    else
        Logger:info("Death link receiving outside of battle.")
        Logger:info(data["cause"])
        Inventory:RemoveConsumable()
        Characters:SetHPAll(1)
    end

    ArchipelagoState.lastDeathLink = currentDeathLink
end

---Send DeathLink to other players
---@param msg string Death message
---@param players_id table|nil Player IDs to send to
---@param games table|nil Games to send to
---@param tags table|nil Tags for the bounce
function DeathLinkManager:SendDeathLink(msg, players_id, games, tags)
    if not ArchipelagoState.apSystem then return end

    players_id = players_id or {}
    games      = games or {}
    tags       = tags or {}
    msg        = msg or {}

    local data = {}
    data["time"] = math.floor(ArchipelagoState.apSystem:GetClient():GetServerTime())

    local playerInfo = ArchipelagoState.apSystem:GetClient():GetPlayerInfo()
    local slotName = playerInfo.alias or "Unknown"

    if not string.find(msg, slotName) then
        msg = slotName .. " " .. msg
    end

    data["cause"] = msg
    data["source"] = slotName

    table.insert(tags, "DeathLink")

    ArchipelagoState.apSystem:GetClient():Bounce(data, games, players_id, tags)
    Logger:info("Sending DeathLink with cause: " .. msg .. " from source: " .. slotName)
end

---Send Gommage DeathLink (not used yet)
function DeathLinkManager:SendGommage()
    if not ArchipelagoState.canDeathLink then return end

    local players_id = {}
    for i = ArchipelagoState.current_year_gommage, 3000, 1 do
        table.insert(players_id, i)
    end

    self:SendDeathLink("The gommage happens for " .. ArchipelagoState.current_year_gommage .. " years old", players_id, {}, {})
    ArchipelagoState.current_year_gommage = ArchipelagoState.current_year_gommage - 1
end

return DeathLinkManager

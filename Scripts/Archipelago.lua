---Archipelago Facade
---Main interface between the game and Archipelago
local ArchipelagoState = require("Archipelago.ArchipelagoState")
local Facade = require("Archipelago.Facade.index")

---@class Archipelago : ArchipelagoState
local Archipelago = ArchipelagoState

---Check if connected to AP server
---@return boolean connected
function Archipelago:IsConnected()
    if not self.apSystem then
        return false
    end
    return self.apSystem:IsConnected()
end

---Get player information
---@return table playerInfo Player information from AP
function Archipelago:GetPlayer()
    if not self.apSystem then
        return {}
    end
    
    return self.apSystem:GetClient():GetPlayerInfo()
end

---Sync with AP server
function Archipelago:Sync()
    self.waitingForSync = true
    if not self:CanReceiveItems() then
        return
    end
    
    if not self.apSystem then
        return
    end
    
    self.apSystem:GetClient():Sync()
    self.waitingForSync = false
end

---Check if player can receive items
---@return boolean canReceive
function Archipelago:CanReceiveItems()
    if not self:IsConnected() then
        return false
    end

    if not ClientBP:IsInitialized() then
        return false
    end

    if ClientBP:IsMainMenu() then
        return false
    end

    if ClientBP:IsLumiereActI() then
        return false
    end

    if not ClientBP:InLevel() then
        return false
    end
    
    return true
end

---Receive an item from Archipelago
---@param item_data table Item data from AP
---@return boolean success
function Archipelago:ReceiveItem(item_data)
    return Facade.ItemReceiver:ReceiveItem(item_data)
end

---Send a location check
---@param location_name string Location name
function Archipelago:SendLocationCheck(location_name)
    Facade.LocationSender:SendLocationCheck(location_name)
end

---Send victory/completion
function Archipelago:SendVictory()
    Facade.LocationSender:SendVictory()
end

---Send Gommage DeathLink
function Archipelago:SendGommage()
    Facade.DeathLinkManager:SendGommage()
end

---Send DeathLink
---@param msg string Death message
---@param players_id table|nil Player IDs
---@param games table|nil Games
---@param tags table|nil Tags
function Archipelago:SendDeathLink(msg, players_id, games, tags)
    Facade.DeathLinkManager:SendDeathLink(msg, players_id, games, tags)
end

---Handle incoming DeathLink
---@param data table DeathLink data
function Archipelago:HandleDeathLink(data)
    Facade.DeathLinkManager:HandleDeathLink(data)
end

---Handle capacity item (legacy compatibility)
---@param item_data ItemData
function Archipelago:HandleCapacityItem(item_data)
    Facade.CapacityHandler:Handle(item_data)
end

---Handle trap item (legacy compatibility)
---@param item_data ItemData
function Archipelago:HandleTrapItem(item_data)
    Facade.TrapHandler:Handle(item_data)
end

---Get level for an item (legacy compatibility)
---@param gear_type string
---@param id integer
---@return integer level
function Archipelago:GetLevelItem(gear_type, id)
    return Facade.ItemReceiver:GetLevelItem(gear_type, id)
end

---Get item from AP data (utility function)
---@param item_id integer
---@return table|nil item
function GetItemFromAPData(item_id)
    local player = Archipelago:GetPlayer()
    local item = {}
    
    if not Archipelago.apSystem then
        return nil
    end
    
    item["name"] = Archipelago.apSystem:GetClient():GetItemName(item_id, player["game"])

    if not item["name"] then
        return nil
    end

    item["id"] = item_id

    return item
end

return Archipelago
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

function Archipelago:IsInitialized()
    return self:CanReceiveItems() and Storage:Get("initialized")
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

function Archipelago:SendAlreadyChecked()
    local locations_already_checked = Storage:Get("locations_checked")
    for i, v in ipairs(locations_already_checked) do
        self:SendLocationCheckByID(v)
    end
end

---Check if player can receive items
---@return boolean canReceive
function Archipelago:CanReceiveItems()
    if not self:IsConnected() then
        return false
    end

    if not ClientBP then
        return false
    end

    if not ClientBP:IsInitialized() then
        return false
    end

    if ClientBP:IsMainMenu() then
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
    Facade.LocationManager:SendLocationCheck(location_name, false)
end

function Archipelago:ForceSendLocationCheck(location_name)
    Facade.LocationManager:SendLocationCheck(location_name, true)
end

function Archipelago:ScoutLocation(location_name, create_hint)
    Facade.LocationManager:ScoutLocation(location_name, create_hint)
end

function Archipelago:ScoutMerchants()
    local location_names = {}
    for _, shop in ipairs(Data.shops) do
        if self:isRegionExcluded(shop.region) then goto continue end


        for i = 1, self.options.location_per_shop, 1 do
            local current_name = "Shop: " .. shop.name .. " - Item " .. tostring(i)
            table.insert(location_names, current_name)
        end

        if shop.has_fight then
            local fight = "Shop: " .. shop.name .. " - Fight"
            table.insert(location_names, fight)

            for i = 1, self.options.extra_location_per_shop, 1 do
                local current_name = "Shop: " .. shop.name .. " - Extra Item " .. tostring(i)
                table.insert(location_names, current_name)
            end
        end
        
        ::continue::
    end

    self:ScoutLocation(location_names, false)

end

---Send a location check
---@param location_id number Location ID
function Archipelago:SendLocationCheckByID(location_id)
    Facade.LocationManager:SendLocationCheckByID(location_id)
end

---Send victory/completion
function Archipelago:SendVictory()
    Facade.LocationManager:SendVictory()
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
    if self:CanReceiveDeathLink() then
        Facade.DeathLinkManager:SendDeathLink(msg, players_id, games, tags)
    end
end

function Archipelago:CanReceiveDeathLink()
    local time = self.apSystem:GetClient():GetServerTime()
    
    return time >= self.lastDeathLink + 30 and not self.wasDeathLinked
end

function Archipelago:LastDeathLinkInSeconds()
    local time = self.apSystem:GetClient():GetServerTime()

    return time - self.lastDeathLink
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

function Archipelago:isRegionExcluded(region_name) 
    if self.options.exclude_endgame_locations ~= 0 and self.options.exclude_endless_tower ~= 0 then
        return false
    end

    if self.options.exclude_endless_tower == 0 and region_name == "Endless Tower" then
        return true
    end

    local exclusion_level = self:GetExclusionLevel()
    if self.options.exclude_endgame_locations == 0 and CONSTANTS.CONFIG.REGION_LEVEL[region_name] > exclusion_level then
        return true
    end
end

function Archipelago:GetExclusionLevel()
    local level = 33
    if self.options.goal == 0 then
        level = 15
    elseif self.options.goal == 1 then
        level = 16
    elseif self.options.goal == 4 then
        level = 28
    end 

    return level
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
---Main interface between the game and Archipelago
local ItemReceiver     = require("Archipelago.Effects.ItemReceiver")
local CapacityHandler  = require("Archipelago.Effects.CapacityHandler")
local TrapHandler      = require("Archipelago.Effects.TrapHandler")
local LocationManager  = require("Archipelago.Outbound.LocationManager")
local DeathLinkManager = require("Archipelago.Outbound.DeathLinkManager")

---@class Archipelago
local Archipelago = {}

-- Connection
Archipelago.seed = nil
Archipelago.slot = nil
Archipelago.apSystem = nil
Archipelago.trying_to_connect = false
Archipelago.hasConnectedPrior = false
Archipelago.waitingForSync = false
Archipelago.pendingLocationsFlush = false

-- Slot data
Archipelago.totals = {}
Archipelago.weapons_data = {}
Archipelago.pictos_data = {}
Archipelago.shop_data = {}
Archipelago.max_level_gear = 33
Archipelago.chroma = 0
Archipelago.want_to_scout_shop = false

-- DeathLink
Archipelago.death_link = false
Archipelago.canDeathLink = false
Archipelago.wasDeathLinked = false
Archipelago.lastDeathLink = 0.0

-- Not used yet
Archipelago.current_year_gommage = 34
Archipelago.number_of_players = 0



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
    if not self:IsConnected() then
        return {}
    end
    
    return self:GetClient():GetPlayerInfo()
end

function Archipelago:GetClient()
    if self.apSystem == nil then
        return nil
    end

    return self.apSystem:GetClient()
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
    
    self:GetClient():Sync()
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

    if not ClientBP:IsInitialized() then
        return false
    end

    local level = ClientBP:GetLevelName()
    return level ~= "" and level ~= CONSTANTS.GAME.MAIN_MENU_LEVEL
end

---Receive an item from Archipelago
---@param item_data table Item data from AP
---@return boolean success
function Archipelago:ReceiveItem(item_data)
    return ItemReceiver:ReceiveItem(item_data)
end

---Send a location check
---@param location_name string Location name
function Archipelago:SendLocationCheck(location_name)
    LocationManager:SendLocationCheck(location_name, false)
end

function Archipelago:ForceSendLocationCheck(location_name)
    LocationManager:SendLocationCheck(location_name, true)
end

function Archipelago:ScoutLocation(location_name, create_hint)
    LocationManager:ScoutLocation(location_name, create_hint)
end

function Archipelago:ScoutMerchants()
    local location_names = {}
    for _, shop in ipairs(Data.shops) do
        if self:isRegionExcluded(shop.region) then goto continue end


        for i = 1, Options.values.location_per_shop, 1 do
            table.insert(location_names, MerchantLocations.Build(shop, MerchantLocations.ITEM, i))
        end

        if shop.has_fight then
            table.insert(location_names, MerchantLocations.Build(shop, MerchantLocations.FIGHT))

            for i = 1, Options.values.extra_location_per_shop, 1 do
                table.insert(location_names, MerchantLocations.Build(shop, MerchantLocations.EXTRA, i))
            end
        end
        
        ::continue::
    end

    Logger:info("Total merchant scoutted : " .. #location_names)
    for index, loc_name in ipairs(location_names) do
        Logger:info(index .. " -> " .. loc_name)
    end
    self:ScoutLocation(location_names, false)

end

---Send a location check
---@param location_id number Location ID
function Archipelago:SendLocationCheckByID(location_id)
    LocationManager:SendLocationCheckByID(location_id)
end

---Send victory/completion
function Archipelago:SendVictory()
    LocationManager:SendVictory()
end

---Send DeathLink
---@param msg string Death message
---@param players_id table|nil Player IDs
---@param games table|nil Games
---@param tags table|nil Tags
function Archipelago:SendDeathLink(msg, players_id, games, tags)
    if self:CanReceiveDeathLink() then
        DeathLinkManager:SendDeathLink(msg, players_id, games, tags)
    end
end

function Archipelago:CanReceiveDeathLink()
    local time = self:GetClient():GetServerTime()
    
    return time >= self.lastDeathLink + 30 and not self.wasDeathLinked
end

function Archipelago:LastDeathLinkInSeconds()
    local time = self:GetClient():GetServerTime()

    return time - self.lastDeathLink
end

---Price of a merchant slot, nil when the slot data does not describe it
---@param shop_name string
---@param extra boolean
---@param index integer
---@return number|nil
function Archipelago:GetShopPrice(shop_name, extra, index)
    local shop = self.shop_data[shop_name]
    if shop == nil then
        Logger:warn("No slot data for shop: " .. tostring(shop_name))
        return nil
    end

    local prices = shop[extra and "extra_prices" or "prices"]
    if prices == nil then
        Logger:warn(("Shop %q has no %s in the slot data"):format(shop_name, extra and "extra_prices" or "prices"))
        return nil
    end

    return prices[index]
end

function Archipelago:isRegionExcluded(region_name) 
    if Options.values.exclude_endgame_locations ~= Options.EXCLUSION.EXCLUDED and 
       Options.values.exclude_endless_tower ~= Options.EXCLUSION.EXCLUDED then
        return false
    end

    if Options.values.exclude_endless_tower ~= Options.EXCLUSION.EXCLUDED and region_name == "Endless Tower" then
        return true
    end

    local exclusion_level = self:GetExclusionLevel()
    local region = Regions.BY_AP_NAME[region_name]
    if region == nil then
        Logger:warn(region_name .. ' is not found in config region level, returning false')
        return false
    end
    
    if Options.values.exclude_endgame_locations ~= Options.EXCLUSION.EXCLUDED and region.level > exclusion_level then
        Logger:info(("Region %q excluded (level %d > %d)"):format(region_name, region.level, exclusion_level))
        return true
    end

    return false
end

function Archipelago:GetExclusionLevel()
    local goal = CONSTANTS.GOAL[Options.values.goal]
    return goal and goal.exclusion_level or 33
end

return Archipelago
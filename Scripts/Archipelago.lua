---@class ArchipelagoOptions
---@field char_shuffle integer
---@field gestral_shuffle integer
---@field goal integer
---@field gear_scaling integer
---@field starting_char integer
---@field shuffle_free_aim integer

---@class Archipelago
---@field options ArchipelagoOptions
---@field weapons_data integer[]
---@field pictos_data integer[]
---@field totals integer[]

local Archipelago = {}



Archipelago.seed = nil
Archipelago.slot = nil

Archipelago.options = {} ---@type ArchipelagoOptions -- comes over in slot data
Archipelago.totals = {}
Archipelago.weapons_data = {}
Archipelago.pictos_data = {}
Archipelago.death_link = false
Archipelago.number_of_players = 0
Archipelago.current_year_gommage = 34
Archipelago.trying_to_connect = false


Archipelago.hasConnectedPrior = false -- keeps track of whether the player has connected at all so players don't have to remove AP mod to play vanilla
Archipelago.isInit = false -- keeps track of whether init things like handlers need to run
Archipelago.waitingForSync = false -- randomizer calls APSync when "waiting for sync"; i.e., when you die
Archipelago.canDeathLink = false
Archipelago.wasDeathLinked = false
Archipelago.lastDeathLink = 0.0
Archipelago.waitingForSync = true
Archipelago.itemsQueue = {}
Archipelago.isProcessingItems = false -- this is set to true when the queue is being processed so we don't over-give

function Archipelago:Init()
    if not Archipelago.isInit then
        Archipelago.isInit = true
    end
end

function Archipelago:IsConnected()
    return AP_REF.APClient ~= nil and AP_REF.APClient:get_state() == AP_REF.AP.State.SLOT_CONNECTED
end

function Archipelago:GetPlayer()
    local player = {}

    if AP_REF.APClient == nil then
        return {}
    end

    player["slot"] = AP_REF.APClient:get_slot()
    player["seed"] = AP_REF.APClient:get_seed()
    player["number"] = AP_REF.APClient:get_player_number()
    player["alias"] = AP_REF.APClient:get_player_alias(player['number'])
    player["game"] = AP_REF.APClient:get_player_game(player['number'])

    return player
end

function Archipelago:Sync()
    if AP_REF.APClient == nil then
        return
    end

    -- AP_REF.APClient:Sync()
end

function APSlotConnectedHandler(slot_data)
    Archipelago.hasConnectedPrior = true
    Archipelago.trying_to_connect = false
    
    Hooks:Register()
    Storage:Load()
    return Archipelago:SlotDataHandler(slot_data)
end
AP_REF.on_slot_connected = APSlotConnectedHandler

function Archipelago:SlotDataHandler(slot_data)
    local player = Archipelago:GetPlayer()

    Archipelago.seed = player["seed"]
    Archipelago.slot = player["slot"]

    if slot_data.death_link ~= nil then
        Archipelago.death_link = slot_data.death_link
    end

    Archipelago.options = slot_data.options
    Archipelago.totals = slot_data.totals or {}
    Archipelago.pictos_data = slot_data.pictos or {}
    Archipelago.weapons_data = slot_data.weapons or {}

    Logger:info("Receiving Slot Data: ")
    Logger:info("Options: " .. Dump(Archipelago.options))
    Logger:info("Totals: " .. Dump(Archipelago.totals))
    -- Logger:info("Pictos data: " .. Dump(Archipelago.pictos_data))
    -- Logger:info("Weapons data: " .. Dump(Archipelago.weapons_data))

    Data.Load()
end

function APItemsReceivedHandler(items_received)
    return Archipelago:ItemsReceivedHandler(items_received)
end
AP_REF.on_items_received = APItemsReceivedHandler


---comment
---@param items_received table<integer, NetworkItem>
function Archipelago:ItemsReceivedHandler(items_received)
    if Storage.initialized_after_lumiere and not Archipelago:CanReceiveItems() then
        return
    end

    for _, row in pairs(items_received) do
        if row.index ~= nil and row.index > Storage.lastReceivedItemIndex then
            Logger:StartIGT("ItemsReceivedHandler")
            local item_data = GetItemFromAPData(row.item)

            if item_data ~= nil then
                if Archipelago:ReceiveItem(item_data) then
                    Logger:info("Received item: " .. item_data["name"] .. " (" .. row.item .. ") at index: " .. row.index .. " for player: " .. row.player)
                    -- ClientBP:PushNotification(item_data["name"], row.player)
                    Storage.lastReceivedItemIndex = row.index
                    Storage:Update("Archipelago:ItemsReceivedHandler")
                end
            else
                Logger:error("Item data is nil for item: " .. row.item)
            end

            
            Logger:EndIGT("ItemsReceivedHandler")
        end
    end

end


--- Receives an item and adds it to the inventory.
---@param item_data table<string, any>
---@return boolean returns true if the item was successfully received, false otherwise
function Archipelago:ReceiveItem(item_data)
    local local_item_data = nil ---@type ItemData

    for _, item in pairs(Data.items) do
        if item.name == item_data["name"] then
            local_item_data = item
        end
    end

    if local_item_data == nil then
        Logger:error("Item data nil when receiving item, here the item data received: " .. Dump(item_data))
        return false
    end

    if local_item_data.type == "Area" then
        Storage.tickets[local_item_data.internal_name] = true
        Storage:Update("Archipelago:ReceiveItem - Area")

        if local_item_data.name == "Area - Esquie's Nest" then
            Quests:SetObjectiveStatus("Main_GoldenPath", "6_EsquieNest", QUEST_STATUS.STARTED)
        elseif local_item_data.name == "Area - Stone Wave Cliffs" then
            Quests:SetObjectiveStatus("Main_ForcedCamps", "4_ForcedCamp_PostEsquieNest", QUEST_STATUS.COMPLETED)
        elseif local_item_data.name == "Area - Old Lumiere" then
            Quests:SetObjectiveStatus("Main_GoldenPath", "10_OldLumiere", QUEST_STATUS.STARTED)
        elseif local_item_data.name == "Area - The Monolith" then
            Quests:SetObjectiveStatus("Main_GoldenPath", "12_Axon2", QUEST_STATUS.COMPLETED)
            Quests:SetObjectiveStatus("Main_GoldenPath", "13_EnterTheMonolith", QUEST_STATUS.STARTED)
        elseif local_item_data.name == "Area - Lumiere" then
            Quests:SetObjectiveStatus("Main_GoldenPath", "16_GoBackToLumiereAndDefeatRenoir", QUEST_STATUS.STARTED)
        end
        return true
    end

    if local_item_data.type == "Exploration capacities" then
        self:HandleCapacityItem(local_item_data)
        return true
    end

    if local_item_data.type == "Trap" then
        self:HandleTrapItem(local_item_data)
        return true
    end

    if local_item_data.type == "Character" then
        Characters:EnableCharacter(local_item_data.internal_name)
        table.insert(Storage.characters, local_item_data.internal_name)
        Storage:Update("Archipelago:ReceiveItem - Character")
        return true
    end

    if local_item_data ~= nil then
        local level = self:GetLevelItem(local_item_data.type, item_data["id"])

        if Inventory:AddItem(local_item_data.internal_name, local_item_data.quantity, level) then
            return true
        end
    else
        Logger:error("Item not found in local data: " .. Dump(item_data))
        return false
    end

    return false
end

--- Gets the level of an item based on its type and ID.
---@param gear_type string
---@param id integer
---@return integer
function Archipelago:GetLevelItem(gear_type, id)
    function FindIDinTable(t)
        for i, v in ipairs(t) do
            if id == v then
                return math.ceil(33 * i / #t)
            end
        end

        return 15
    end
    
    local level = 15
    if self.options.gear_scaling == 0 or self.options.gear_scaling == 2 then
        if gear_type == "Picto" then
            level = FindIDinTable(self.pictos_data)
        elseif gear_type == "Weapon" then
            level = FindIDinTable(self.weapons_data)
        end
    elseif self.options.gear_scaling == 1 then
        local percent = 0
        if gear_type == "Picto" then
            percent = Storage.pictosIndex / 190
            Storage.pictosIndex = Storage.pictosIndex + 1
        elseif gear_type == "Weapons" then
            percent = Storage.weaponsIndex / 100
            Storage.weaponsIndex = Storage.weaponsIndex + 1
        end
        Storage:Update("Archipelago:GetLevelItem")
        level = math.ceil(33 * percent)
    elseif self.options.gear_scaling == 3 then
        level = math.random(1, 33)
    end

    return level
end

--- Handles the reception of exploration capacity items.
---@param item_data ItemData
function Archipelago:HandleCapacityItem(item_data)
    if item_data.name == "Progressive Rock" then
        Capacities:UnlockNextWorldMapAbility()
    elseif item_data.name == "Paint Break" then
        Capacities:UnlockDestroyPaintedRock()
    elseif item_data.name == "Free Aim" then
        Capacities:UnlockExplorationCapacity("FreeAim")
        Storage.free_aim_unlocked = true
        Storage:Update("Archipelago:HandleCapacityItem - Free Aim")
    end
end

function APBounceHandler(json)
    if type(json) == "string" then
        json = JSON.decode(json)
    end

    local tags = json["tags"]
    local data = json["data"]

    if tags ~= nil then
        for _, tag in ipairs(tags) do
            if tag == "DeathLink" then
                Archipelago:HandleDeathLink(data)
            end
        end
    end
    
end
AP_REF.on_bounced = APBounceHandler

function Archipelago:HandleTrapItem(item_data)
    Logger:info("Trap activated: " .. item_data.name)
    
    if item_data.name == "Feet Trap" then
        ClientBP:FeetTrap()
    end
end

function Archipelago:HandleDeathLink(data)
    local lastDeathLink = self.lastDeathLink
    local currentDeathLink = data["time"]
    self.lastDeathLink = data["time"]
    
    if currentDeathLink - lastDeathLink < 10000 then
        return
    end 

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

end

function Archipelago:CanReceiveItems()
    if not Archipelago:IsConnected() then
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

---comment
---@param item_id integer
function GetItemFromAPData(item_id)
    local player = Archipelago:GetPlayer()
    local item = {}
    
    item["name"] = AP_REF.APClient:get_item_name(item_id, player["game"])

    if not item["name"] then
        return nil
    end

    item["id"] = item_id

    return item
end

function APRetrievedData(map)
    return Archipelago:RetrieveData(map)
end
AP_REF.on_retrieved_data = APRetrievedData

function Archipelago:RetrieveData(map)
    print(Dump(map))
end

function APLocationsCheckedHandler(locations_checked)
    return Archipelago.LocationsCheckedHandler(locations_checked)
end
AP_REF.on_location_checked = APLocationsCheckedHandler

function Archipelago:LocationsCheckedHandler(locations_checked)
    local player = Archipelago:GetPlayer()
    if locations_checked == nil then return end

    for k, location_id in ipairs(locations_checked) do
        local id = tonumber(location_id)
        if id == nil then
            error("Error when converting location_id to number: " .. location_id)
        end
        local location_name = AP_REF.APClient:get_location_name(id, player['game'])

        for k, loc in pairs(Data.locations) do
            if loc['name'] == location_name then
                loc['sent'] = true
                break
            end
        end
    end
end

--- need to add location to storage to avoid redoing the same thing if a crash happens
function Archipelago:SendLocationCheck(location_name)
    local location_data = GetLocationFromAPData(location_name)
    if location_data == nil then return end

    local location_to_send = {} -- LocationChecks need an array
    location_to_send[1] = location_data["id"]
    
    if not location_data then
        return
    end
    
    local function async() -- needed otherwise it crashes
        AP_REF.APClient:LocationChecks(location_to_send)
    end

    ExecuteAsync(async)
end

function Archipelago:SendVictory()
    AP_REF.APClient:StatusUpdate(AP_REF.AP.ClientStatus.GOAL)
end

function Archipelago:SendGommage()
    if not Archipelago.canDeathLink then return end

    local players_id = {}
    for i = Archipelago.current_year_gommage, 3000, 1 do
        table.insert(players_id, i)
    end

    Archipelago:SendDeathLink("The gommage happens for " .. Archipelago.current_year_gommage .. " years old", players_id, {}, {})
    Archipelago.current_year_gommage = Archipelago.current_year_gommage - 1
end

function Archipelago:SendDeathLink(msg, players_id, games, tags)
    players_id = players_id or {}
    games = games or {}
    tags = tags or {}


    local data = {}
    data["time"] = os.time()

    if not string.find(msg, AP_REF.APSlot) then
        msg = AP_REF.APSlot .. " : " .. msg
    end

    data["cause"] = msg
    data["source"] = AP_REF.APSlot

    table.insert(tags, "DeathLink")
    AP_REF.APClient:Bounce(data, games, players_id, tags)
end

---Handle multiple locations
---@param locations_data table<LocationData>
---@return LocationData
function HandleMultipleLocations(location_name, locations_data)
    local level_name = ClientBP:GetLevelName()
    if level_name == nil then
        return locations_data[1]
    end

    function HandleGenericChroma()
        local predicate = {
            ["World Map"] = "Level_WorldMap_Main_V2",
            ["Spring Meadows"] = "Level_SpringMeadows_Main_V2",
            ["The Monolith"] = "Level_Monolith_Interior_Climb_Main",
            ["Esquies Nest"] = "LevelMain_EsquieNest",
        }

        for _, loc in pairs(locations_data) do
            local region = loc["location"]
            if predicate[region] ~= nil and predicate[region] == level_name then
                return loc
            end
        end
    end

    function HandleDiveItems()
        local res = locations_data[Storage.dive_items + 1]
        Storage.dive_items = Storage.dive_items + 1
        Storage:Update("HandleMultipleLocations - Dive items")
        return res
    end

    function HandlePetank()
        local predicate = {
            ["Sirene"] = "Level_Sirene_Main_V2",
            ["Ancient Sanctuary"] = "Level_AncientSanctuary_Main_V2",
            ["Frozen Hearts"] = "Level_Side_FrozenHeart",
            ["The Monolith"] = "Level_Monolith_Interior_Climb_Main",
            ["Isle of the Eyes"] = "SmallLevel_MF_Zone_01",
            ["Stone Wave Cliffs"] = "ConceptLevel_SeaCliff_V1",
            ["Flying Manor"] = "Level_CleaFlyingHouse_Main",
            ["Forgotten Battlefield"] = "Level_Main_ForgottenBattlefield_V2",
            ["Endless Night Sanctuary"] = "Level_Side_TwilightSanctuary",
            ["Esquie’s Nest"] = "LevelMain_EsquieNest",
            ["The Reacher"] = "Level_Reacher_Main_V2"
        }

        for _, loc in pairs(locations_data) do
            local region = loc["location"]
            if predicate[region] ~= nil and predicate[region] == level_name then
                return loc
            end
        end
    end

    local res = nil
    if location_name == "Chest_Generic_Chroma" then
        res = HandleGenericChroma()
    elseif location_name == "Chest_Generic_5xLuminaPoint" then
        res = HandleDiveItems()
    elseif string.find(location_name, "^Petank") then
        res = HandlePetank()
    end

    return res or locations_data[1]
end

function GetLocationFromAPData(location_name)
    local location_data = Data:FindEntry(Data.locations, location_name) ---@cast location_data LocationData | table<LocationData> | nil
    if type(location_data) == "table" and #location_data > 1 then
        local res = HandleMultipleLocations(location_name, location_data)
        location_data = res
    end
    local location = {}

    if location_data == nil then
        Debug.print("Location_data is nul. Name of location: " .. location_name)
        return nil
    end

    location["id"] = AP_REF.APClient:get_location_id(location_data.name)

    if not location["id"] then
        return nil
    end

    location["name"] = location_data.name

    return location
    
end

return Archipelago

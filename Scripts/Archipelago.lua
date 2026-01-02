---@class Archipelago
local Archipelago = {}

-- State variables (for compatibility for now)
Archipelago.seed = nil
Archipelago.slot = nil
Archipelago.options = {}
Archipelago.totals = {}
Archipelago.weapons_data = {}
Archipelago.pictos_data = {}
Archipelago.death_link = false
Archipelago.number_of_players = 0
Archipelago.current_year_gommage = 34
Archipelago.trying_to_connect = false
Archipelago.hasConnectedPrior = false
Archipelago.waitingForSync = false
Archipelago.canDeathLink = false
Archipelago.wasDeathLinked = false
Archipelago.lastDeathLink = 0.0

-- AP reference but initialize later
Archipelago.apSystem = nil

function Archipelago:IsConnected()
    if not self.apSystem then
        return false
    end
    return self.apSystem:IsConnected()
end

function Archipelago:GetPlayer()
    if not self.apSystem then
        return {}
    end
    
    return self.apSystem:GetClient():GetPlayerInfo()
end

function Archipelago:Sync()
    if not self:CanReceiveItems() then
        return
    end
    
    if not self.apSystem then
        return
    end
    
    self.apSystem:GetClient():Sync()
    self.waitingForSync = false
end

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

--- Receive an item
---@param item_data table
---@return boolean
function Archipelago:ReceiveItem(item_data)
    local local_item_data = nil ---@type ItemData

    for _, item in pairs(Data.items) do
        if item.name == item_data["name"] then
            local_item_data = item
            break
        end
    end

    if local_item_data == nil then
        Logger:error("Item data nil when receiving item: " .. Dump(item_data))
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
        elseif local_item_data.name == "Area - The Reacher" then
            Save:WriteFlagByID("NID_MaelleRelationshipLvl6_Quest", true)
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
    local function FindIDinTable(t)
        for i, v in ipairs(t) do
            if id == v then
                return math.ceil(CONSTANTS.MAX_LEVEL_GEAR * i / #t)
            end
        end
        return 15
    end
    
    local level = 15
    if  self.options.gear_scaling == CONSTANTS.OPTIONS.GEAR_SCALING.SPHERE_PLACEMENT or
        self.options.gear_scaling == CONSTANTS.OPTIONS.GEAR_SCALING.BALANCED_RANDOM then
        if gear_type == "Picto" then
            level = FindIDinTable(self.pictos_data)
        elseif gear_type == "Weapon" then
            level = FindIDinTable(self.weapons_data)
        end
    elseif self.options.gear_scaling == 1 then
        local percent = 0
        percent = (Storage.pictosIndex + Storage.weaponsIndex) / (CONSTANTS.NUMBER_OF_PICTOS + CONSTANTS.NUMBER_OF_WEAPONS)
        if gear_type == "Picto" then
            Storage.pictosIndex = Storage.pictosIndex + 1
        elseif gear_type == "Weapon" then
            Storage.weaponsIndex = Storage.weaponsIndex + 1
        end
        Storage:Update("Archipelago:GetLevelItem")
        level = math.ceil(CONSTANTS.MAX_LEVEL_GEAR * percent)
    elseif self.options.gear_scaling == 3 then
        level = math.random(1, CONSTANTS.MAX_LEVEL_GEAR)
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

function Archipelago:HandleTrapItem(item_data)
    Logger:info("Trap activated: " .. item_data.name)
    
    if item_data.name == "Feet Trap" then
        ClientBP:FeetTrap()
    end
end

function Archipelago:HandleDeathLink(data)
    local currentDeathLink = data["time"]
    
    Logger:info("DeathLink Received with data: " .. Dump(data))
    Logger:info("Last received in: " .. self.lastDeathLink)

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

    self.lastDeathLink = currentDeathLink
end

--- Send a location check
---@param location_name string
function Archipelago:SendLocationCheck(location_name)
    local location_data = GetLocationFromAPData(location_name)
    if location_data == nil then return end

    local location_to_send = {}
    location_to_send[1] = location_data["id"]
    
    if not location_data then
        return
    end
    
    local function async()
        if self.apSystem then
            self.apSystem:GetClient():GetClient():LocationChecks(location_to_send)
        end
    end

    Logger:info("Location: \"" .. location_name .. "\" checked !")
    ExecuteAsync(async)
end

function Archipelago:SendVictory()
    if not self.apSystem then return end
    
    self.apSystem:GetClient():SendCompletion()
end

function Archipelago:SendGommage()
    if not self.canDeathLink then return end

    local players_id = {}
    for i = self.current_year_gommage, 3000, 1 do
        table.insert(players_id, i)
    end

    self:SendDeathLink("The gommage happens for " .. self.current_year_gommage .. " years old", players_id, {}, {})
    self.current_year_gommage = self.current_year_gommage - 1
end

function Archipelago:SendDeathLink(msg, players_id, games, tags)
    if not self.apSystem then return end
    
    players_id = players_id or {}
    games      = games or {}
    tags       = tags or {}
    msg        = msg or {}

    local data = {}
    data["time"] = math.floor(self.apSystem:GetClient():GetServerTime())

    local playerInfo = self:GetPlayer()
    local slotName = playerInfo.alias or "Unknown"
    
    if not string.find(msg, slotName) then
        msg = slotName .. " " .. msg
    end

    data["cause"] = msg
    data["source"] = slotName

    table.insert(tags, "DeathLink")
    
    self.apSystem:GetClient():Bounce(data, games, players_id, tags)
    Logger:info("Sending DeathLink with cause: " .. msg .. " from source: " .. slotName)
end

---Handle multiple locations
---@param locations_data table<LocationData>
---@return LocationData
function HandleMultipleLocations(location_name, locations_data)
    local level_name = ClientBP:GetLevelName()
    if level_name == nil then
        return locations_data[1]
    end

    local function HandleGenericChroma()
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

    local function HandleDiveItems()
        local res = locations_data[Storage.dive_items + 1]
        Storage.dive_items = Storage.dive_items + 1
        Storage:Update("HandleMultipleLocations - Dive items")
        return res
    end

    local function HandlePetank()
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
            ["Esquie's Nest"] = "LevelMain_EsquieNest",
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
    local location_data = Data:FindEntry(Data.locations, location_name)
    
    if type(location_data) == "table" and #location_data > 1 then
        local res = HandleMultipleLocations(location_name, location_data)
        location_data = res
    end
    
    local location = {}

    if location_data == nil then
        Debug.print("Location_data is nil. Name of location: " .. location_name)
        return nil
    end

    if not Archipelago.apSystem then
        return nil
    end
    
    location["id"] = Archipelago.apSystem:GetClient():GetLocationId(location_data.name)

    if not location["id"] then
        return nil
    end

    location["name"] = location_data.name

    return location
end

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
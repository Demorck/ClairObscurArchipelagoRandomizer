

local Archipelago = {}

Archipelago.seed = nil
Archipelago.slot = nil

Archipelago.death_link = false -- comes over in slot data
Archipelago.hasConnectedPrior = false -- keeps track of whether the player has connected at all so players don't have to remove AP mod to play vanilla
Archipelago.isInit = false -- keeps track of whether init things like handlers need to run
Archipelago.waitingForSync = false -- randomizer calls APSync when "waiting for sync"; i.e., when you die
Archipelago.canDeathLink = false 
Archipelago.wasDeathLinked = false 
Archipelago.waitingForSync = true 
Archipelago.itemsQueue = {}
Archipelago.isProcessingItems = false -- this is set to true when the queue is being processed so we don't over-give

function Archipelago.Init()
    if not Archipelago.isInit then
        Archipelago.isInit = true
    end
end

function Archipelago.IsConnected()
    return AP_REF.APClient ~= nil and AP_REF.APClient:get_state() == AP_REF.AP.State.SLOT_CONNECTED
end

function Archipelago.GetPlayer()
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

function Archipelago.Sync()
    if AP_REF.APClient == nil then
        return
    end

    AP_REF.APClient:Sync()
end

function APSlotConnectedHandler(slot_data)
    Archipelago.hasConnectedPrior = true
    print('Connected.')

    return Archipelago.SlotDataHandler(slot_data)
end
AP_REF.on_slot_connected = APSlotConnectedHandler


function Archipelago.SlotDataHandler(slot_data)
    local player = Archipelago.GetPlayer()

    Archipelago.seed = player["seed"]
    Archipelago.slot = player["slot"]

    if slot_data.death_link ~= nil then
        Archipelago.death_link = slot_data.death_link
    end
    
    Data.Load()
end

function APItemsReceivedHandler(items_received)
    return Archipelago.ItemsReceivedHandler(items_received)
end
AP_REF.on_items_received = APItemsReceivedHandler

---comment
---@param items_received table<integer, NetworkItem>
function Archipelago.ItemsReceivedHandler(items_received)
    local items = {}

    for k, row in pairs(items_received) do
        if row.index ~= nil and row.index > Storage.lastReceivedItemIndex then
            local item_data = GetItemFromAPData(row.item)
            local location_data = nil
            
            if row.location ~= nil then
                location_data = GetLocationFromAPData(row.location)
            end
            
            if item_data ~= nil then
                Archipelago.ReceiveItem(item_data["name"])
                Storage.lastReceivedItemIndex = row.index
            end
        end
    end
    
    Storage.Update()
end

function Archipelago.ReceiveItem(item_name)
    local local_item_data = nil ---@type ItemData

    for _, item in pairs(Data.items) do
        if item.name == item_name then
            local_item_data = item
        end
    end

    if local_item_data ~= nil then
        Inventory.AddItem(local_item_data.name, 1)
    end
end


function Archipelago.CanReceiveItems()
    return Archipelago.IsConnected()
end

---comment
---@param item_id integer
function GetItemFromAPData(item_id)
    local player = Archipelago.GetPlayer()
    local item = {}
    
    item["name"] = AP_REF.APClient:get_item_name(item_id, player["game"])

    if not item["name"] then
        return nil
    end

    item["id"] = item_id

    return item
end

function APLocationsCheckedHandler(locations_checked)
    return Archipelago.LocationsCheckedHandler(locations_checked)
end
AP_REF.on_location_checked = APLocationsCheckedHandler

function Archipelago.LocationsCheckedHandler(locations_checked)
    local player = Archipelago.GetPlayer()
    print("feur")

    for k, location_id in pairs(locations_checked) do
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
function Archipelago.SendLocationCheck(location_name)
    local location_data = GetLocationFromAPData(location_name)

    if location_data == nil then return end

    local location_to_send = {} -- LocationChecks need an array
    location_to_send[1] = location_data["id"]
    
    if not location_data then
        return
    end

    AP_REF.APClient:LocationChecks(location_to_send)
end


function GetLocationFromAPData(location_name)
    local player = Archipelago.GetPlayer()
    local location = {}

    location["id"] = AP_REF.APClient:get_location_id(location_name)

    if not location["id"] then
        return nil
    end

    location["name"] = location_name

    return location
    
end

return Archipelago
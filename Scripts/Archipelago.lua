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

    print(player["alias"])

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




return Archipelago
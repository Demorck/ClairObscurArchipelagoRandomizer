local Storage = {}
Storage.initialized = false
Storage.lastReceivedItemIndex = -1
Storage.lastSavedItemIndex = -1
Storage.pictosIndex = -1
Storage.weaponsIndex = -1
Storage.initialized_after_lumiere = false
Storage.tickets = {
    GoblusLair = false,
    AncientSanctuary = false,
    SideLevel_RedForest = false,
    EsquieNest = false,
    SideLevel_OrangeForest = false,
    SideLevel_CleasFlyingHouse = false,
    ForgottenBattlefield = false,
    SidelLevel_FrozenHearts = false,
    GestralVillage = false,
    MonocoStation = false,
    Lumiere = false,
    Monolith_Interior_PaintressIntro = false,
    OldLumiere = false,
    SideLevel_Reacher = false,
    SideLevel_AxonPath = false,
    SeaCliff = false,
    Sirene = false,
    SideLevel_TwilightSanctuary = false,
    Visages = false,
    SideLevel_YellowForest = false,
    SideLevel_CleasTower_Entrance = false,
}

Storage.characters = {} --- Unfortunately, i can't add Sophie, Alicia and Julie
Storage.flags = {}
Storage.currentLocation = "None"
Storage.free_aim_unlocked = false
Storage.dive_items = 0
Storage.gestral_found = 0
Storage.capacities = {}
Storage.transition_lumiere = false

local Default_storage = {}
Default_storage.initialized = false
Default_storage.lastReceivedItemIndex = -1
Default_storage.lastSavedItemIndex = -1
Default_storage.pictosIndex = -1
Default_storage.weaponsIndex = -1
Default_storage.initialized_after_lumiere = false
Default_storage.tickets = {
    GoblusLair = false,
    AncientSanctuary = false,
    SideLevel_RedForest = false,
    EsquieNest = false,
    SideLevel_OrangeForest = false,
    SideLevel_CleasFlyingHouse = false,
    ForgottenBattlefield = false,
    SidelLevel_FrozenHearts = false,
    GestralVillage = false,
    MonocoStation = false,
    Lumiere = false,
    Monolith_Interior_PaintressIntro = false,
    OldLumiere = false,
    SideLevel_Reacher = false,
    SideLevel_AxonPath = false,
    SeaCliff = false,
    Sirene = false,
    SideLevel_TwilightSanctuary = false,
    Visages = false,
    SideLevel_YellowForest = false,
    SideLevel_CleasTower_Entrance = false,
}

Default_storage.characters = {} --- Unfortunately, i can't add Sophie, Alicia and Julie
Default_storage.flags = {}
Default_storage.currentLocation = "None"
Default_storage.free_aim_unlocked = false
Default_storage.dive_items = 0
Default_storage.gestral_found = 0
Default_storage.capacities = {}


function Storage:Load()
    local file = JSON.read_file(Storage:GetFilePath())

    if file ~= nil then
        Storage.lastReceivedItemIndex     = file["last_received"] or Default_storage.lastReceivedItemIndex
        Storage.lastSavedItemIndex        = file["last_saved"] or Default_storage.lastSavedItemIndex
        Storage.pictosIndex               = file["pictos_index"] or Default_storage.pictosIndex
        Storage.weaponsIndex              = file["weapons_index"] or Default_storage.weaponsIndex
        Storage.initialized_after_lumiere = file["lumiere_done"] or Default_storage.initialized_after_lumiere
        Storage.tickets                   = file["tickets"] or Default_storage.tickets
        Storage.characters                = file["characters"] or Default_storage.characters
        Storage.free_aim_unlocked         = file["free_aim_unlocked"] or Default_storage.free_aim_unlocked 
        Storage.dive_items                = file["dive_items"] or Default_storage.dive_items
        Storage.gestral_found             = file["gestral_found"] or Default_storage.gestral_found
        Storage.capacities                = file["capacities"] or Default_storage.capacities

        Logger:info("Storage loaded from " .. Storage:GetFilePath())
        Logger:info("Last received item index: " .. Storage.lastReceivedItemIndex)
        Logger:info("Last saved item index: " .. Storage.lastSavedItemIndex)
        Logger:info("Pictos index: " .. Storage.pictosIndex)
        Logger:info("Weapons index: " .. Storage.weaponsIndex)
        Logger:info("Lumiere done: " .. tostring(Storage.initialized_after_lumiere))
        Logger:info("Tickets: " .. Dump(Storage.tickets))
        Logger:info("Characters: " .. Dump(Storage.characters))
        Logger:info("Free Aim unlocked: " .. tostring(Storage.free_aim_unlocked))
        Logger:info("Number of gestral rescued: " .. Storage.gestral_found)
    else
        Storage:Update("Storage:Load - New file")
    end

    Storage.initialized = true
end


function Storage:Update(from)
    local player = Archipelago:GetPlayer()

    if not (player["seed"] and player["slot"]) then
        return
    end

    local values = {
        from              = from or "Storage:Update",
        last_received     = Storage.lastReceivedItemIndex,
        last_saved        = Storage.lastSavedItemIndex,
        pictos_index      = Storage.pictosIndex,
        weapons_index     = Storage.weaponsIndex,
        lumiere_done      = Storage.initialized_after_lumiere,
        tickets           = Storage.tickets,
        characters        = Storage.characters,
        free_aim_unlocked = Storage.free_aim_unlocked,
        dive_items        = Storage.dive_items,
        gestral_found     = Storage.gestral_found,
        capacities        = Storage.capacities
    }

    JSON.write_file(Storage:GetFilePath(), values)
end

function Storage:GetFilePath()
    local player = Archipelago:GetPlayer()

    return player["seed"] .. "_" .. player["slot"] .. ".json"
end



return Storage

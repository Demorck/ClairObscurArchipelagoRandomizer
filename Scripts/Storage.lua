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

function Storage:Load()
    local file = JSON.read_file(Storage:GetFilePath())

    if file ~= nil then
        Storage.lastReceivedItemIndex     = file["last_received"]
        Storage.lastSavedItemIndex        = file["last_saved"]
        Storage.pictosIndex               = file["pictos_index"]
        Storage.weaponsIndex              = file["weapons_index"]
        Storage.initialized_after_lumiere = file["lumiere_done"]
        Storage.tickets                   = file["tickets"]
        Storage.characters                = file["characters"]
    else
        Storage:Update("Storage:Load - New file")
    end

    Logger:info("Storage loaded from " .. Storage:GetFilePath())
    Logger:info("Last received item index: " .. Storage.lastReceivedItemIndex)
    Logger:info("Last saved item index: " .. Storage.lastSavedItemIndex)
    Logger:info("Pictos index: " .. Storage.pictosIndex)
    Logger:info("Weapons index: " .. Storage.weaponsIndex)
    Logger:info("Lumiere done: " .. tostring(Storage.initialized_after_lumiere))
    Logger:info("Tickets: " .. Dump(Storage.tickets))
    Logger:info("Characters: " .. Dump(Storage.characters))
    Storage.initialized = true
end


function Storage:Update(from)
    local player = Archipelago:GetPlayer()

    if not (player["seed"] and player["slot"]) then
        return
    end

    local values = {
        from          = from or "Storage:Update",
        last_received = Storage.lastReceivedItemIndex,
        last_saved    = Storage.lastSavedItemIndex,
        pictos_index  = Storage.pictosIndex,
        weapons_index = Storage.weaponsIndex,
        lumiere_done  = Storage.initialized_after_lumiere,
        tickets       = Storage.tickets,
        characters    = Storage.characters
    }

    JSON.write_file(Storage:GetFilePath(), values)
end

function Storage:GetFilePath()
    local player = Archipelago:GetPlayer()

    return player["seed"] .. "_" .. player["slot"] .. ".json"
end



return Storage

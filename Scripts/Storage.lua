local Storage = {}
Storage.initialized = false
Storage.lastReceivedItemIndex = -1
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

function Storage:Load()
    local file = JSON.read_file(Storage:GetFilePath())

    if file ~= nil then
        Storage.lastReceivedItemIndex = file["last_received"]
        Storage.lastSavedItemIndex = file["last_saved"]
        Storage.pictosIndex = file["pictos_index"]
        Storage.weaponsIndex = file["weapons_index"]
        Storage.initialized_after_lumiere = file["lumiere_done"]
        Storage.tickets = file["tickets"]
    else
        Storage:Update()
    end

    Storage.initialized = true
end


function Storage:Update()
    local player = Archipelago:GetPlayer()

    if not (player["seed"] and player["slot"]) then
        return
    end

    local values = {
        last_received = Storage.lastReceivedItemIndex,
        pictos_index = Storage.pictosIndex,
        weapons_index = Storage.weaponsIndex,
        lumiere_done = Storage.initialized,
        tickets = Storage.tickets
    }

    JSON.write_file(Storage:GetFilePath(), values)
end

function Storage:GetFilePath()
    local player = Archipelago:GetPlayer()

    return player["seed"] .. "_" .. player["slot"] .. ".json"
end



return Storage
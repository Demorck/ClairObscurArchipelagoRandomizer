local Storage = {}
Storage.initialized = false
Storage.lastReceivedItemIndex = -1
Storage.pictosIndex = -1
Storage.weaponsIndex = -1

function Storage:Load()
    local file = JSON.read_file(Storage:GetFilePath())

    if file ~= nil then
        Storage.lastReceivedItemIndex = file["last_received"]
        Storage.lastSavedItemIndex = file["last_saved"]
        Storage.pictosIndex = file["pictos_index"]
        Storage.weaponsIndex = file["weapons_index"]
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
        weapons_index = Storage.weaponsIndex
    }

    JSON.write_file(Storage:GetFilePath(), values)
end

function Storage:GetFilePath()
    local player = Archipelago:GetPlayer()

    return player["seed"] .. "_" .. player["slot"] .. ".json"
end



return Storage
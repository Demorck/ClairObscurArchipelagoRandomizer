---@class Save
local Save = {}

local BluePrintName = "BP_SaveManager_C"

function Save:SaveGame()
    local savemanager = FindFirstOf(BluePrintName) ---@type UBP_SaveManager_C
    if savemanager == nil or not savemanager:IsValid() then
        Logger:error("Impossible to save: SaveManager nil")
        return
    end

    local save_name = savemanager:GetSaveNameForSelectedSlot()
    savemanager:SaveGameToFile(save_name)
end



return Save
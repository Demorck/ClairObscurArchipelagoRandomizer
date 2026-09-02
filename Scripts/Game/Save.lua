---@class Save
local Save = {}

local BluePrintName = "BP_SaveManager_C"

---comment
---@return nil | UBP_SaveManager_C
function Save:GetManager()
    local savemanager = FindAllOf(CONSTANTS.BLUEPRINT.SAVE_MANAGER)
    if savemanager == nil or not savemanager:IsValid() then
        Logger:error("Impossible to save: SaveManager nil")
        return nil
    end

    return savemanager
end

function Save:SaveGame()
    ExecuteInGameThread(function()
        local savemanager = FindFirstOf(CONSTANTS.BLUEPRINT.SAVE_MANAGER)
        if savemanager == nil or not savemanager:IsValid() then
            Logger:error("Impossible to save: SaveManager nil")
            return
        end
        savemanager:RequestSaveInternal(true, "Archipelago needed to save internal")
    end)
end

---This function calls just GetAllNamedIDs and the hook function will do the rest.
---@param flag_name string
---@param boolean_value boolean
function Save:WriteFlagByName(flag_name, boolean_value)
    local helper = FindFirstOf(CONSTANTS.BLUEPRINT.GI_CUSTOM) ---@cast helper UBP_jRPG_GI_Custom_C
    RuntimeState:QueueNamedIdWrite(flag_name, boolean_value)
    helper:GetAllNamedIDs({})
end

return Save
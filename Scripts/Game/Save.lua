---@class Save
local Save = {}

local BluePrintName = "BP_SaveManager_C"

---comment
---@return nil | UBP_SaveManager_C
function Save:GetManager()
    local savemanager = FindAllOf(BluePrintName)
    if savemanager == nil or not savemanager:IsValid() then
        Logger:error("Impossible to save: SaveManager nil")
        return nil
    end

    return savemanager
end

function Save:SaveGame()
    local savemanager = FindFirstOf(BluePrintName) ---@type UBP_SaveManager_C
    if savemanager == nil or not savemanager:IsValid() then
        Logger:error("Impossible to save: SaveManager nil")
        return
    end

    -- local save_name = savemanager:GetSaveNameForSelectedSlot()
    -- savemanager:SaveGameToFile(save_name)
    savemanager:RequestSaveInternal(true, "Archipelago needed to save internal")
end

function Save:TriggerSaveIssue()
    local savemanager = FindFirstOf(BluePrintName) ---@type UBP_SaveManager_C
    if savemanager == nil or not savemanager:IsValid() then
        Logger:error("Impossible to save: SaveManager nil")
        return
    end

    savemanager:RequestAutoSave("Archipelago needed to save issue")
end

--- Modify the GPE (Gameplay Experience) settings if needed 
---@param save_data UBP_SaveGameData_C
function Save:ModifyGPEIfNeeded(save_data)
    local gpe = save_data.GPE_States
    if gpe == nil then return end

    local found_boulder = false

    gpe:Add(FName("ObjectID_Destructible_Level_Camp_Main_BP_BoulderBreak_Lvl1_C_0B3D65ED4ACB6050879EEE869B749856"), true)
end

---This function calls just GetAllNamedIDs and the hook function will do the rest.
---@param flag_name string
---@param boolean_value boolean
function Save:WriteFlagByName(flag_name, boolean_value)
    local helper = FindFirstOf("BP_jRPG_GI_Custom_C") ---@cast helper UBP_jRPG_GI_Custom_C
    CONSTANTS.RUNTIME.NAMEDID_TO_BE_ADDED[flag_name] = boolean_value
    helper:GetAllNamedIDs({})
end

return Save
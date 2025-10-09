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

--- Modify the GPE (Gameplay Experience) settings if needed 
---@param save_data UBP_SaveGameData_C
function Save:ModifyGPEIfNeeded(save_data)
    local gpe = save_data.GPE_States
    if gpe == nil then return end

    local found_boulder = false

    gpe:Add(FName("ObjectID_Destructible_Level_Camp_Main_BP_BoulderBreak_Lvl1_C_0B3D65ED4ACB6050879EEE869B749856"), true)
    -- gpe:ForEach(function (key, value)
    --     local gpe_name = key:get():ToString()
    --     local gpe_value = value:get()

    --     if gpe_name == "ObjectID_Destructible_Level_Camp_Main_BP_BoulderBreak_Lvl1_C_0B3D65ED4ACB6050879EEE869B749856" and gpe_value == false then
    --         gpe:Add(FName(gpe_name), true)
    --         found_boulder = true
    --     end
    -- end)

    -- if not found_boulder then
    --     gpe:Add(FName("ObjectID_Destructible_Level_Camp_Main_BP_BoulderBreak_Lvl1_C_0B3D65ED4ACB6050879EEE869B749856"), true)
    -- end
end

function Save:WriteFlagByID(flag_id, boolean_value)
    local helper = FindFirstOf("BP_jRPG_GI_Custom_C") ---@cast helper UBP_jRPG_GI_Custom_C
    if helper == nil or not helper:IsValid() then return end

    local flags = {}
    helper:GetPersistentFlags(flags)
    for k, v in ipairs(flags) do
        local value = v:get() ---@cast value UNamedID
        local name = value.Name:ToString()
        if name == flag_id then
            helper:WritePersistentFlag(value, boolean_value)
        end
    end
end

return Save
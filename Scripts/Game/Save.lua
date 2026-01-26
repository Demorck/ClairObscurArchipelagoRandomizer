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
end

---This function calls just GetAllNamedIDs and the hook function will do the rest.
---@param flag_name string
---@param boolean_value boolean
function Save:WriteFlagByName(flag_name, boolean_value)
    local helper = FindFirstOf("BP_jRPG_GI_Custom_C") ---@cast helper UBP_jRPG_GI_Custom_C
    helper:GetAllNamedIDs({})
end

function Save:WriteFlagByID(flag_id, boolean_value)
    local helper = FindFirstOf("BP_jRPG_GI_Custom_C") ---@cast helper UBP_jRPG_GI_Custom_C
    if helper == nil or not helper:IsValid() then return end

    local flags = {}
    helper:GetPersistentFlags(flags)
    local found = false
    local struct = {}
    for _, v in ipairs(flags) do
        local value = v:get() ---@cast value UNamedID
        if value == nil or not value:IsValid() then
            goto continue
        end

        if value.Name == nil then
            goto continue
        end
        local name = value.Name:ToString()
        if name == flag_id then
            helper:WritePersistentFlag(value, boolean_value)
            found = true
        end

        -- use for retrieve the data for ClientConstants.
        -- if name == "" then
        --     print(string.format("%x, %x, %x, %x", value.Guid.A, value.Guid.B, value.Guid.C, value.Guid.D))
        -- end

        struct = value
        ::continue::
    end

    if not found then
        local GUID = nil
        if flag_id == "NID_EsquieUnderwaterUnlocked" then
            GUID = CONSTANTS.NID.DIVE_GUID
        elseif flag_id == "NID_ForgottenBattlefield_GradientCounterTutorial" then
            GUID = CONSTANTS.NID.FB_GRADIENT_TUTORIAL
        elseif flag_id == "NID_Goblu_JumpTutorial" then
            GUID = CONSTANTS.NID.FW_JUMP_TUTORIAL
        elseif flag_id == "NID_MaelleRelationshipLvl6_Quest" then
            GUID = CONSTANTS.NID.REACHER_LVL6_MAELLE
        elseif flag_id == "NID_LuneRelationshipLvl6_Quest" then
            GUID = CONSTANTS.NID.RELATION_LVL6_LUNE
        elseif flag_id == "NID_Monoco_RelationshipLvl6_Quest" then
            GUID = CONSTANTS.NID.RELATION_LVL6_MONOCO
        end

        if GUID == nil or struct.Guid == nil then
            Logger:error("No GUID found with " .. flag_id)
            return
        end

        struct.Guid.A = GUID.A
        struct.Guid.B = GUID.B
        struct.Guid.C = GUID.C
        struct.Guid.D = GUID.D
        struct.Name = FName(flag_id)

        helper:WritePersistentFlag(struct, boolean_value)
    end
end

return Save
---Character-related hooks
---@class CharacterHooks
local CharacterHooks = {}


---Register all character hooks
---@param hookManager HookManager
---@param dependencies table
function CharacterHooks:Register(hookManager, dependencies)
    local storage = dependencies.storage
    local logger = dependencies.logger
    local clientBP = dependencies.clientBP

    -- Save characters from unavoidable death
    hookManager:Register(
        "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_CharactersManager.AC_jRPG_CharactersManager_C:RemoveCharacterFromCollection",
        function(_, data_param)
            if not storage.initialized_after_lumiere then
                return
            end

            local data = data_param:get() ---@cast data UBP_CharacterData_C
            local charName = data.HardcodedNameID:ToString()

            -- Check if it's a playable character
            local isPlayableChar = charName == "Frey" or
                                   charName == "Lune" or
                                   charName == "Maelle" or
                                   charName == "Sciel" or
                                   charName == "Verso" or
                                   charName == "Monoco"

            if isPlayableChar then
                local charManager = clientBP:GetHelper() ---@type ABP_ArchipelagoHelper_C
                if charManager == nil then return end

                Logger:callMethod(charManager, "AddCharacterToCollectionFromSaveState", data)
            end
        end,
        "Character - Save from Death"
    )

    hookManager:Register(
        "/Game/Gameplay/GameActionsSystem/ReplaceCharacter/BP_GameActionInstance_ReplaceCharacter.BP_GameActionInstance_ReplaceCharacter_C:GetReplaceCharacterParameters",
        function(ctx, parameters)
            if (Contains(CONSTANTS.RUNTIME.TABLE_CURRENT_AP_FUNCTION, "ComputeNewCharacterSaveState")) then return end

            local ctx = ctx:get() ---@cast ctx UBP_GameActionInstance_ReplaceCharacter_C
            local char_data = Characters:GetCharacterDataByID("Verso")
            if char_data == nil then
                Logger:warn("AAAAAAAAA")
                return
            end

            ctx.OldCharacterData = char_data
            ctx.NewCharacterData = char_data

            table.insert(CONSTANTS.RUNTIME.TABLE_CURRENT_AP_FUNCTION, "ComputeNewCharacterSaveState")
            ctx:ComputeNewCharacterSaveState()
            Remove(CONSTANTS.RUNTIME.TABLE_CURRENT_AP_FUNCTION, "ComputeNewCharacterSaveState")
        end,
        "Character - Save Verso being remplaced"
    )

    logger:info("Character hooks registered")
end

return CharacterHooks
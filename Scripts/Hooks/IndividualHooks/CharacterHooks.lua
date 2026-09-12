---Character-related hooks
---@class CharacterHooks
local CharacterHooks = {}


---Register all character hooks
---@param hookManager HookManager
function CharacterHooks:Register(hookManager)

    -- Save characters from unavoidable death
    hookManager:Register(
        "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_CharactersManager.AC_jRPG_CharactersManager_C:RemoveCharacterFromCollection",
        function(_, data_param)
            if not Archipelago:IsInitialized() then return end

            local data = data_param:get() ---@cast data UBP_CharacterData_C
            local charName = data.HardcodedNameID:ToString()

            -- Check if it's a playable character
            local isPlayableChar = CONSTANTS.CHARACTERS.BY_ID[charName] ~= nil

            if isPlayableChar then
                ClientBP:CallHelper("AddCharacterToCollectionFromSaveState", data)
            end
        end,
        "Character - Save from Death"
    )

    hookManager:Register(
        "/Game/Gameplay/GameActionsSystem/ReplaceCharacter/BP_GameActionInstance_ReplaceCharacter.BP_GameActionInstance_ReplaceCharacter_C:GetReplaceCharacterParameters",
        function(ctx, parameters)
            local param = parameters:get() ---@type FS_ReplaceCharacterParameters
            param.NewCharacter_4_7AD35D254B3EE7F97626C3931279DBF8 = param.OldCharacter_2_76B268A34EDC34B4823397BC5C8FA5E2
        end,
        "Character - Save Verso being remplaced"
    )

    Logger:info("Character hooks registered")
end

return CharacterHooks
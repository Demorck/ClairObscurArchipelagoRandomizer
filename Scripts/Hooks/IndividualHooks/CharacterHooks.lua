---@class CharacterDependencies
---@field archipelago Archipelago
---@field storage Storage
---@field logger Logger
---@field clientBP ClientBP

---Character-related hooks
---@class CharacterHooks
local CharacterHooks = {}


---Register all character hooks
---@param hookManager HookManager
---@param dependencies CharacterDependencies
function CharacterHooks:Register(hookManager, dependencies)
    local archipelago = dependencies.archipelago
    local storage = dependencies.storage
    local logger = dependencies.logger
    local clientBP = dependencies.clientBP

    -- Save characters from unavoidable death
    hookManager:Register(
        "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_CharactersManager.AC_jRPG_CharactersManager_C:RemoveCharacterFromCollection",
        function(_, data_param)
            if not archipelago:IsInitialized() then return end

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
            local param = parameters:get() ---@type FS_ReplaceCharacterParameters
            param.NewCharacter_4_7AD35D254B3EE7F97626C3931279DBF8 = param.OldCharacter_2_76B268A34EDC34B4823397BC5C8FA5E2
        end,
        "Character - Save Verso being remplaced"
    )

    logger:info("Character hooks registered")
end

return CharacterHooks
---Save-related hooks
---@class SaveHooks
local SaveHooks = {}

---Register all save hooks
---@param hookManager HookManager
---@param dependencies table
function SaveHooks:Register(hookManager, dependencies)
    local archipelago = dependencies.archipelago
    local storage = dependencies.storage
    local logger = dependencies.logger
    local characters = dependencies.characters
    local capacities = dependencies.capacities

    local AddingButtonHook = false

    hookManager:Register(
        "/Game/Gameplay/Save/BP_SaveManager.BP_SaveManager_C:SaveGameToFile",
        function(self, SaveName)
            local manager = self:get() ---@type UBP_SaveManager_C
            if not archipelago.apSystem or not manager or not manager:IsValid() then
                return
            end

            local data = FindFirstOf("BP_SaveGameData_C") ---@type UBP_SaveGameData_C
            if not data or not data:IsValid() then
                logger:error("Impossible to save: SaveGameData nil")
                return
            end

            if not storage.initialized_after_lumiere then
                return
            end

            if not Hooks.AddingButtonHook then
                hookManager:Register(
                    "/Game/UI/Widgets/HUD_Exploration/WBP_SavePointMenu.WBP_SavePointMenu_C:UpdateUpgradeWeaponsButtonVisibility",
                    function (context)
                        local a = context:get() ---@cast a UWBP_SavePointMenu_C
                        if a == nil or not a:IsValid() then return end
                        a.UpgradeWeaponsButton:SetVisibility(0)
                        a.UpgradeTeamButton:SetVisibility(0)
                    end,
                    "Save - AddingButtonSavePoint"
                )
                Hooks.AddingButtonHook = true
            end

            -- Update flags for PopTracker
            local flags = data.UnlockedSpawnPoints ---@type TArray<FS_LevelSpawnPointsData>
            local newFlags = false

            flags:ForEach(function(_, element)
                local value = element:get() ---@type FS_LevelSpawnPointsData
                local levelName = value.LevelAssetName_7_D872F94549A7C2601ECF70AC3C4BAB27:ToString()

                if storage.flags[levelName] == nil then
                    storage.flags[levelName] = {}
                end

                local points = value.SpawnPointTags_3_511D41A44873049B1F83559F7CCBA8D7 ---@type TArray<FGameplayTag>
                points:ForEach(function(_, point)
                    local tag = point:get() ---@type FGameplayTag
                    local tagname = tag.TagName:ToString()
                    local last = tagname:match("([^%.]+)$")

                    if not Contains(storage.flags[levelName], last) then
                        table.insert(storage.flags[levelName], last)
                        newFlags = true
                        logger:info("New flag found: " .. levelName .. " - " .. last)
                    end
                end)
            end)

            if newFlags then
                storage:Update("SaveHooks:SaveGameToFile - New flags")

                -- Send to AP server
                local operation = {
                    operation = "update",
                    value = storage.flags
                }
                local playerInfo = archipelago.apSystem:GetClient():GetPlayerInfo()
                archipelago.apSystem:GetClient():SetDataStorage(
                    playerInfo.number .. "-coe33-flags",
                    storage.flags,
                    false,
                    {operation}
                )
            end

            -- Update party and characters
            characters:ModifyPartyIfNeeded()
            characters:EnableCharactersInCollectionOnlyUnlocked()
            capacities:DisableFreeAimIfNeeded()

            storage.lastSavedItemIndex = storage.lastReceivedItemIndex
            storage:Update("SaveHooks:SaveGameToFile")
        end,
        "Save - Game Save"
    )

    logger:info("Save hooks registered")
end

return SaveHooks
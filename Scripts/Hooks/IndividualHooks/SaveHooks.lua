---Save-related hooks
---@class SaveHooks
local SaveHooks = {}

---Register all save hooks
---@param hookManager HookManager
---@param dependencies table
function SaveHooks:Register(hookManager, dependencies)
    local archipelago = dependencies.archipelago
    local logger = dependencies.logger

    self.AddingButtonHook = false

    hookManager:Register(
        "/Game/Gameplay/Save/BP_SaveManager.BP_SaveManager_C:SaveGameToFile",
        self:SaveGame(logger, hookManager, archipelago),
        "Save - Game Save"
    )

    hookManager:Register(
        "/Game/UI/Widgets/FullScreenNotificationSystem/WBP_FullScreenNotificationContainer.WBP_FullScreenNotificationContainer_C:OnSaveGameSlotStarted",
        self:SaveNotificationUI(),
        "Save - Save Notification UI"
    )

    hookManager:Register(
        "/Game/jRPGTemplate/Blueprints/Basics/BP_jRPG_GI_Custom.BP_jRPG_GI_Custom_C:GetAllNamedIDs",
        self:AddNamedID(),
        "Save - Get All Named ID"
    )

    logger:info("Save hooks registered")
end

function SaveHooks:SaveGame(logger, hookManager, archipelago)
    return function(ctx, SaveName)
        local manager = ctx:get() ---@type UBP_SaveManager_C
        if not Archipelago:IsInitialized() or not manager or not manager:IsValid() then
            return
        end

        local data = FindFirstOf("BP_SaveGameData_C") ---@type UBP_SaveGameData_C
        if not data or not data:IsValid() then
            logger:error("Impossible to save: SaveGameData nil")
            return
        end

        if not Storage:Get("initialized_after_lumiere") then
            return
        end

        if not self.AddingButtonHook then
            hookManager:Register(
                "/Game/UI/Widgets/HUD_Exploration/WBP_SavePointMenu.WBP_SavePointMenu_C:UpdateUpgradeWeaponsButtonVisibility",
                function (context)
                    local a = context:get() ---@cast a UWBP_SavePointMenu_C
                    if a == nil or not a:IsValid() then return end
                    a.UpgradeWeaponsButton:SetVisibility(0)
                    a.UpgradeTeamButton:SetVisibility(0)
                    a.BackToWorldMapButton:SetVisibility(0)
                end,
                "Save - AddingButtonSavePoint"
            )
            self.AddingButtonHook = true
        end

        -- Build flags for PopTracker (not stored in Storage)
        local flags = data.UnlockedSpawnPoints ---@type TArray<FS_LevelSpawnPointsData>
        local currentFlags = {}

        flags:ForEach(function(_, element)
            local value = element:get() ---@type FS_LevelSpawnPointsData
            local levelName = value.LevelAssetName_7_D872F94549A7C2601ECF70AC3C4BAB27:ToString()

            if currentFlags[levelName] == nil then
                currentFlags[levelName] = {}
            end

            local points = value.SpawnPointTags_3_511D41A44873049B1F83559F7CCBA8D7 ---@type TArray<FGameplayTag>
            points:ForEach(function(_, point)
                local tag = point:get() ---@type FGameplayTag
                local tagname = tag.TagName:ToString()
                local last = tagname:match("([^%.]+)$")

                if not Contains(currentFlags[levelName], last) then
                    table.insert(currentFlags[levelName], last)
                end
            end)
        end)

        -- Send to AP server (only operation, no storage)
        local operation = {
            operation = "update",
            value = currentFlags
        }
        local playerInfo = archipelago.apSystem:GetClient():GetPlayerInfo()
        archipelago.apSystem:GetClient():SetDataStorage(
            playerInfo.number .. "-coe33-flags",
            currentFlags,
            false,
            {operation}
        )

        -- Update party and characters
        Characters:ModifyPartyIfNeeded()
        Characters:EnableCharactersInCollectionOnlyUnlocked()
        Capacities:DisableFreeAimIfNeeded()

        local lastReceived = Storage:Get("lastSavedItemIndex")
        Storage:Set("lastSavedItemIndex", lastReceived)
        Storage:Update("SaveHooks:SaveGameToFile")
    end
end


RegisterHook("", function (ctx)
    
end)

function SaveHooks:SaveNotificationUI()
    return function(ctx)
        local a = ctx:get() ---@cast a UWBP_FullScreenNotificationContainer_C

        local random_string = Utils.TableHelper.GetRandomElement(CONSTANTS.GAME.TABLE.SAVE_NOTIFICATION)
        a.WBP_SaveGameNotification.TextBlock_SaveInProgress:SetText(FText(random_string))

        ---@type ABP_ArchipelagoHelper_C
        local client = FindFirstOf("BP_ArchipelagoHelper_C")
        local texture = client.BaguetteTexture
        a.WBP_SaveGameNotification.Image_CircleDot:SetBrushFromTexture(texture, false)
    end
end

function SaveHooks:AddNamedID()
    return function(ctx, ids)
        local ctx = ctx:get() ---@type UBP_jRPG_GI_Custom_C
        local namedID = ids:get() ---@type TArray<UNamedID>

        namedID:ForEach(function (index, element)
            local value = element:get() ---@type UNamedID
            local name = value.Name:ToString()

            local found = false
            for need_to_add, bool_value in pairs(CONSTANTS.RUNTIME.NAMEDID_TO_BE_ADDED) do
                if name == need_to_add then
                    ctx:WritePersistentFlag(value, bool_value)
                    found = true
                end
            end

            if found then Remove(CONSTANTS.RUNTIME.NAMEDID_TO_BE_ADDED, name) end
        end)
   end
end

return SaveHooks
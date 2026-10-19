---Location/level-related hooks
---@class LocationHooks
local LocationHooks = {}


---Register all location hooks
---@param hookManager HookManager
function LocationHooks:Register(hookManager)
    local AddingGestralHook = false

    local function change_data_storage(level)
        if not Archipelago:IsConnected() then return end
        
        local operation = {
            operation = "replace",
            value = level
        }

        local playerInfo = Archipelago:GetClient():GetPlayerInfo()
        Archipelago:GetClient():SetDataStorage(
            playerInfo.number .. "-coe33-currentLocation",
            level,
            false,
            {operation}
        )
    end

    local function register_sastro(level)
        if level == "Camps" and not AddingGestralHook then
            ExecuteWithDelay(1000 * 10, function ()
                hookManager:Register(
                    "/Game/Narrative/Dialogs/LevelsDialogs/Camp/BP_Dialogue_Quest_LostGestralChief.BP_Dialogue_Quest_LostGestralChief_C:GetFoundLostGestralCount",
                    function (context)
                        if not Archipelago:CanReceiveItems() then return end

                        for i = 1, Storage:Get("gestral_found") do
                            Archipelago:SendLocationCheck("Lost Gestral reward " .. tostring(i))
                        end
                    end,
                    "Location - Gestral Hook"
                )
            end)
            AddingGestralHook = true
        end
    end

    hookManager:Register("/Game/jRPGTemplate/Blueprints/Basics/FL_jRPG_CustomFunctionLibrary.FL_jRPG_CustomFunctionLibrary_C:ChangeMapByName",
         function (ctx, level_destination, spawn_point_tag, world_context)
            local level = level_destination:get():ToString()

            if level ~= "None" then
                register_sastro(level)
                change_data_storage(level)
                Storage:Set("currentLocation", level)

                local region = Regions.BY_NAME[level]
                if region == nil or region.asset == nil then return end

                local level_asset = region.asset
                Logger:info(("Level change -> %s (%s)"):format(level, level_asset))
            end

         end,
        "LocationHooks - ChangeMapByName"
    )

    hookManager:Register("/Game/jRPGTemplate/Blueprints/Basics/FL_jRPG_CustomFunctionLibrary.FL_jRPG_CustomFunctionLibrary_C:ChangeMapByAssetName",
         function (ctx, level_destination, spawn_point_tag, world_context)
            local level_asset = level_destination:get():ToString()

            local region = Regions.BY_LEVEL_ASSET[level_asset]
            if region == nil or region.name == nil then return end

            local level = region.name
            if level ~= "None" then
                register_sastro(level)
                change_data_storage(level)
                Storage:Set("currentLocation", level)

                Logger:info(("Level change -> %s (%s)"):format(level, level_asset))
            end
         end,
        "LocationHooks - ChangeMapByAssetName"
    )

    hookManager:Register("/Game/Gameplay/WorldInfo/BP_WorldInfoComponent.BP_WorldInfoComponent_C:RegisterTeleportPoint",
        function (self, tp_UObject)
            local level_name = ClientBP:GetLevelName()
            if level_name ~= Regions.BY_NAME.WorldMap.asset then return end

            local portal = tp_UObject:get() ---@cast portal ABP_jRPG_MapTeleportPoint_C

            local a = {
                    Rotation = {
                        X = 0,
                        Y = 0,
                        Z = 0,
                        W = 0
                    },

                    Translation = {
                        X = 0,
                        Y = -1000,
                        Z = 0,
                    },

                    Scale3D = {
                        X = 0,
                        Y = 0,
                        Z = 0,
                    },
                }
                
            if portal == nil or not portal:IsValid() then return end

            local class_name = portal:GetClass():GetFName():ToString()
            if class_name ~= "BP_jRPG_MapTeleportPoint_Interactible_C" then return end

            local scene = portal.LevelDestination.RowName:ToString()

            if not Storage:IsAreaUnlocked(scene) then
                portal:K2_SetActorRelativeTransform(a, false, {}, true)
            else
                if portal.DestinationSpawnPointTag.TagName:ToString() == "Level.SpawnPoint.OldLumiere.EndPath" and Quests:GetObjectiveStatus("Main_GoldenPath", "10_OldLumiere") ~= QUEST_STATUS.COMPLETED then
                    portal:K2_SetActorRelativeTransform(a, false, {}, true)
                end
            end
        end,
        "LocationHooks - RegisterTeleportPoint")

    Logger:info("Location hooks registered")
end


-- RegisterHook("/Game/jRPGTemplate/Blueprints/Basics/FL_jRPG_CustomFunctionLibrary.FL_jRPG_CustomFunctionLibrary_C:ChangeMapByName", function (ctx, level_destination, spawn_point_tag, world_context)
--     local level = level_destination:get():ToString()

--     print("ChangeMapByName: " .. level)
-- end)

-- RegisterHook("/Game/jRPGTemplate/Blueprints/Basics/FL_jRPG_CustomFunctionLibrary.FL_jRPG_CustomFunctionLibrary_C:ChangeMapByAssetName", function (ctx, level_destination, spawn_point_tag, world_context)
--     local level = level_destination:get():ToString()

--     print("ChangeMapByAssetName: " .. level)

-- end)


return LocationHooks
---@class LocationDependencies
---@field archipelago Archipelago
---@field storage Storage
---@field logger Logger
---@field clientBP ClientBP

---Location/level-related hooks
---@class LocationHooks
local LocationHooks = {}


---Register all location hooks
---@param hookManager HookManager
---@param dependencies LocationDependencies
function LocationHooks:Register(hookManager, dependencies)
    local archipelago = dependencies.archipelago
    local storage = dependencies.storage
    local logger = dependencies.logger
    local clientBP = dependencies.clientBP
    local AddingGestralHook = false

    local function change_data_storage()
        local operation = {
            operation = "replace",
            value = storage:Get("currentLocation")
        }

        local playerInfo = archipelago.apSystem:GetClient():GetPlayerInfo()
        archipelago.apSystem:GetClient():SetDataStorage(
            playerInfo.number .. "-coe33-currentLocation",
            storage:Get("currentLocation"),
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
                        if not archipelago.apSystem then return end
                        if Archipelago.options.gestral_shuffle == 0 then return end

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

            if storage:Get("currentLocation") ~= level and level ~= "None" then
                register_sastro(level)
                change_data_storage()
            end
         end,
        "LocationHooks - ChangeMapByName"
    )

    hookManager:Register("/Game/jRPGTemplate/Blueprints/Basics/FL_jRPG_CustomFunctionLibrary.FL_jRPG_CustomFunctionLibrary_C:ChangeMapByAssetName",
         function (ctx, level_destination, spawn_point_tag, world_context)
            local level_asset = level_destination:get():ToString()

            local index = -1
            for i, value in ipairs(CONSTANTS.GAME.TABLE.MAP_NAME.ASSETS_TABLE) do
                if value == level_asset then
                    index = i
                    break
                end
            end

            if index == -1 then
                return
            end

            local level = CONSTANTS.GAME.TABLE.MAP_NAME.READABLE_TABLE[index]
            if storage:Get("currentLocation") ~= level and level ~= "None" then
                register_sastro(level)
                change_data_storage()
            end
         end,
        "LocationHooks - ChangeMapByAssetName"
    )

    hookManager:Register("/Game/Gameplay/WorldInfo/BP_WorldInfoComponent.BP_WorldInfoComponent_C:RegisterTeleportPoint",
        function (self, tp_UObject)
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

            portal:K2_SetActorRelativeTransform(a, false, {}, true)
        end,
        "LocationHooks - RegisterTeleportPoint")

    logger:info("Location hooks registered")
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
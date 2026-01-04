---Location/level-related hooks
---@class LocationHooks
local LocationHooks = {}

local function RemovePortals()
    local a = FindFirstOf("BP_WorldInfoComponent_C") ---@cast a UBP_WorldInfoComponent_C
    if a == nil or not a:IsValid() then return end

    local portal_array = a.WorldTeleportPoints
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
    } ---@type FTransform
    portal_array:ForEach(function (_, portal)
        portal = portal:get()
        ---@cast portal ABP_jRPG_MapTeleportPoint_C
        if portal == nil or not portal:IsValid() then return end

        local class_name = portal:GetClass():GetFName():ToString()
        if class_name ~= "BP_jRPG_MapTeleportPoint_Interactible_C" then return end

        local scene = portal.LevelDestination.RowName:ToString()
        if Storage.tickets[scene] == false then

            portal:K2_SetActorRelativeTransform(a, false, {}, true)
        else
            if portal.DestinationSpawnPointTag.TagName:ToString() == "Level.SpawnPoint.OldLumiere.EndPath" and Quests:GetObjectiveStatus("Main_GoldenPath", "10_OldLumiere") ~= QUEST_STATUS.COMPLETED then
                portal:K2_SetActorRelativeTransform(a, false, {}, true)
            end
        end
    end)
end

---Register all location hooks
---@param hookManager HookManager
---@param dependencies table
function LocationHooks:Register(hookManager, dependencies)
    local archipelago = dependencies.archipelago
    local storage = dependencies.storage
    local logger = dependencies.logger
    local clientBP = dependencies.clientBP
    local AddingGestralHook = false

    hookManager:Register(
        "/Game/jRPGTemplate/Blueprints/Basics/FL_jRPG_CustomFunctionLibrary.FL_jRPG_CustomFunctionLibrary_C:GetCurrentLevelData",
        function(self, _worldContext, found, levelData, rowName)
            if not storage.initialized_after_lumiere then
                return
            end

            local name = rowName:get()
            local level = name:ToString()

            -- Handle transition from Lumiere
            if level == "SpringMeadows" and storage.transition_lumiere then
                storage.transition_lumiere = false
                archipelago:Sync()
            end

            -- Update current location
            if storage.currentLocation ~= level and level ~= "None" then
                if level == "WorldMap" then
                    RemovePortals()
                elseif level == "Camps" and not AddingGestralHook then
                    hookManager:Register(
                        "/Game/Narrative/Dialogs/LevelsDialogs/Camp/BP_Dialogue_Quest_LostGestralChief.BP_Dialogue_Quest_LostGestralChief_C:GetFoundLostGestralCount",
                        function (context)
                            if not archipelago.apSystem then return end
                            if Archipelago.options.gestral_shuffle == 0 then return end

                            for i = 1, Storage.gestral_found do
                                Archipelago:SendLocationCheck("Lost Gestral reward " .. tostring(i))
                            end
                        end,
                        "Location - Gestral Hook"
                    )
                    AddingGestralHook = true
                end
                logger:info("Changing level. New level is: " .. level)
                storage.currentLocation = level

                -- Send to AP server
                local operation = {
                    operation = "replace",
                    value = storage.currentLocation
                }

                local playerInfo = archipelago.apSystem:GetClient():GetPlayerInfo()
                archipelago.apSystem:GetClient():SetDataStorage(
                    playerInfo.number .. "-coe33-currentLocation",
                    storage.currentLocation,
                    false,
                    {operation}
                )
            end
        end,
        "Location - Level Change"
    )

    logger:info("Location hooks registered")
end


return LocationHooks
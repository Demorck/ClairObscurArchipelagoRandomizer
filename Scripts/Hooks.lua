local Hooks = {}

Hooks.TableIDs = {}
Hooks.AddingButtonHook = false
Hooks.AddingGestralHook = false

function Hooks:Register()
    Logger:info("Registering hooks...")
    
    Register_AddItemsFromChestToInventory()
    Register_AllChestsContentIsZero()
    Register_UpdateFeedback()
    Register_SaveCharacterFromAnUnvoidableDeath()
    Register_EnableTPButtonInWorldMap()
    Register_UpdateSubquests()
    Register_BattleEndVictory()
    Register_BattleRewards()
    Register_SaveData()
    Register_CurrentLocation()
    Register_AddItemToInventory()

    Logger:info("Hooks registered.")
end

function Hooks:Unregister()
    for _, id_table in pairs(Hooks.TableIDs) do
        local preID = id_table[1]
        local postID = id_table[2]
        local function_name = id_table[3]

        UnregisterHook(function_name, preID, postID)
    end
end

---This function is called when an item is added from chest to inventory. When it occurs, we send a location to Archipelago
function Register_AddItemsFromChestToInventory()
    local function_name = "/Game/Gameplay/GPE/Chests/BP_Chest_Regular.BP_Chest_Regular_C:AddItemsFromChestToInventory"

    local preID, postID = RegisterHook(function_name, function (Context)
        if AP_REF.APClient == nil then return end
        if not Storage.initialized_after_lumiere then
            return
        end

        
        local chest_regular = Context:get() ---@type ABP_Chest_Regular_C
        local fname = chest_regular.ChestSetupHandle["RowName"] ---@type FName
        local name_of_chest = fname:ToString()

        Archipelago:SendLocationCheck(name_of_chest)
    end)

    Hooks.TableIDs["AddItemsFromChestToInventory"] = {preID, postID, function_name}
end

---This function is called when we roll chest items, ie when a level is loading.
---We change all the number of loot to 0 (so, the player don't receive the default loot)
function Register_AllChestsContentIsZero()
    local function_name = "/Game/Gameplay/GPE/Chests/BP_Chest_Regular.BP_Chest_Regular_C:RollChestItems"

    local preID, postID = RegisterHook(function_name, function(self, lootContext, itemsToLoot)
        if AP_REF.APClient == nil then return end
        if not Storage.initialized_after_lumiere then
            return
        end

        local map = itemsToLoot:get() ---@type TMap<FName, int32>
        map:Empty()
    end)

    
    Hooks.TableIDs["AllChestsContentIsZero"] = {preID, postID, function_name}
end

---This function is called when the player loot a chest. It used to change the color of the "dust" (can be cool for chest matches content)
function Register_UpdateFeedback()
    local function_name = "/Game/Gameplay/GPE/Chests/BP_Chest_Regular.BP_Chest_Regular_C:UpdateFeedbackParametersFromLoot"

    local preID, postID = RegisterHook(function_name, function(self)
        if AP_REF.APClient == nil then return end
        if not Storage.initialized_after_lumiere then
            return
        end


        local chest = self:get() ---@type ABP_Chest_Regular_C   
        local colors = chest.ColorWhenOpening -- When you pick the item, there is some dust. That's this color 
        colors.R = 0
        colors.G = 0
        colors.B = 1

        local fx = chest.FX_Chest
        if fx then
            local color = {
                R = 0.0,
                G = 1.0,
                B = 0.0,
                A = 1.0
            } ---@type FLinearColor

            fx:SetColorParameter(FName("Color"), color)  -- the fx when the item is on the floor

                
            chest:UpdateVisuals()
        end
    end)

    Hooks.TableIDs["UpdateFeedback"] = {preID, postID, function_name}
end

---Basically save Gustave at the end of Act 1
--- If we don't test if it's Frey (Gustave internal name), we can save Sophie at the end of prologue and Alicia from the act 3.
function Register_SaveCharacterFromAnUnvoidableDeath()
    local function_name = "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_CharactersManager.AC_jRPG_CharactersManager_C:RemoveCharacterFromCollection"

    local preID, postID = RegisterHook(function_name, function (self, data_param)
        if not Storage.initialized_after_lumiere then
            return
        end

        local data = data_param:get() ---@cast data UBP_CharacterData_C

        if data.HardcodedNameID:ToString() == "Frey" then
            local char_manager = ClientBP:GetHelper() ---@type ABP_ArchipelagoHelper_C
            if char_manager == nil then return end
            Logger:callMethod(char_manager, "AddCharacterToCollectionFromSaveState", data)
            -- char_manager:AddCharacterToCollectionFromSaveState(data)
        end

    end)

    Hooks.TableIDs["SaveCharacterFromAnUnvoidableDeath"] = {preID, postID, function_name}
end

--- Enable the teleport button. 
--- TODO: Changing the button to enable it only in world map
function Register_EnableTPButtonInWorldMap()
    local function_name = "/Game/Gameplay/Audio/BP_AudioControlSystem.BP_AudioControlSystem_C:OnPauseMenuOpened"

    local preID, postID = RegisterHook(function_name, function (context)
        if not Storage.initialized_after_lumiere then
            return
        end

        local buttons = FindAllOf("WBP_BaseButton_C") ---@cast buttons UWBP_BaseButton_C[]
        for _, value in ipairs(buttons) do
            local name = value:GetFName():ToString()
            if name == "TeleportPlayerButton" then
                value:SetVisibility(0)
                local content = value.ButtonContent
                if content ~= nil and content:IsValid() then
                    local overlay = content:GetContent() ---@cast overlay UOverlay
                    if overlay ~= nil and overlay:IsValid() then
                    local wrapping_text = overlay:GetChildAt(0) ---@cast wrapping_text UWBP_WrappingText_C
                        if wrapping_text ~= nil and wrapping_text:IsValid() then
                            wrapping_text.ContentText = FText("I'M STUCK ! (stepbro)")
                            wrapping_text:UpdateText()
                        end
                    end
                end
            end
        end
    end)


    Hooks.TableIDs["EnableTPButtonInWorldMap"] = {preID, postID, function_name}
end

--- This function is called when a subquest is updated (started, completed, etc)
--- We use it to:
--- * Initialize the save after Lumiere (so the APWorld starts)
--- * Mark the forced camp after spring meadows as completed when starting it (Because Lune wants to camp)
--- * Send the location gestral reward when finding a lost gestral
function Register_UpdateSubquests()
    local function_name = "/Game/Gameplay/Quests/System/BP_QuestSystem.BP_QuestSystem_C:UpdateActivitySubTaskStatus"


    local preID, postID = RegisterHook(function_name, function (self, objective_name, status)
        if AP_REF.APClient == nil then return end

        local objective_name_param = objective_name:get():ToString()
        local status_param = status:get()
        
        Logger:info("Game change subquest: " .. objective_name_param .. " to " .. status_param)
        if not Storage.initialized_after_lumiere and objective_name_param == "2_SpringMeadow" and status_param == QUEST_STATUS.STARTED then
            InitSaveAfterLumiere()
        elseif objective_name_param == "1_LumiereBeginning" and status_param ~= QUEST_STATUS.COMPLETED then
            Storage.initialized_after_lumiere = false
            Storage:Update("Hooks:UpdateSubquests - _LumiereBeginning")
        elseif objective_name_param == "1_ForcedCamp_PostSpringMeadows" and status_param == QUEST_STATUS.STARTED then
            Quests:SetObjectiveStatus("Main_ForcedCamps", "1_ForcedCamp_PostSpringMeadows", QUEST_STATUS.COMPLETED)
        elseif string.find(objective_name_param, "FindLostGestral") and status_param == QUEST_STATUS.COMPLETED then
            if Archipelago.options.gestral_shuffle == 1 then 
                Archipelago:SendLocationCheck(objective_name_param)
             end
        end
    end)

    
    Hooks.TableIDs["UpdateSubquests"] = {preID, postID, function_name}
end

--- This hook is called when a battle ends with a victory.
--- We check if the encounter defeated is the goal, and if yes, we send a victory
--- If it's a boss but not the goal, we send a location check 
function Register_BattleEndVictory()
    local function_name = "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_BattleManager.AC_jRPG_BattleManager_C:OnBattleEndVictory"

    local preID, postID = RegisterHook(function_name, function (self)
        if AP_REF.APClient == nil then return end
        if not Storage.initialized_after_lumiere then
            return
        end


        local current_context = self:get() ---@cast current_context UAC_jRPG_BattleManager_C

        local encounter_name = current_context.EncounterName:ToString()

        if Battle:IsEncounterGoal(encounter_name) then
            Logger:info("Goal achieved: " .. encounter_name .. " ! Bravo !")
            Archipelago:SendVictory()
        end

        if Battle:IsBossNotGoal(encounter_name) then
            Logger:info("Boss defeated but not a goal: " .. encounter_name)
            Archipelago:SendLocationCheck(encounter_name)
        end

        if Archipelago.options.char_shuffle == 0 then
            local can_unlock, char_name = Battle:IsBattleCanUnlockCharacter(encounter_name)
            if can_unlock and char_name ~= nil then
                if not Contains(Storage.characters, char_name) then
                    Logger:info("Unlocking character " .. char_name .. " from battle " .. encounter_name)
                    AddingCharacterFromArchipelago = true
                    Characters:EnableCharacter(char_name)
                    table.insert(Storage.characters, char_name)
                    Storage:Update("Hooks:BattleEndVictory - Char unlocked: " .. char_name)
                end
            end
        end

    end)

    Hooks.TableIDs["BattleEndVictory"] = {preID, postID, function_name}
end

--- Called when rolling battle rewards, at the start of the battle.
--- We empty the rolled loot, so the player doesn't receive anything from battles.
function Register_BattleRewards()
    local function_name = "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_BattleManager.AC_jRPG_BattleManager_C:RollBattleRewards"
    local preID, postID = RegisterHook(function_name, function (self, rewards)
        if AP_REF.APClient == nil then return end
        if not Storage.initialized_after_lumiere then
            return
        end

        local battle_rewards = rewards:get() ---@cast battle_rewards FS_BattleRewards
        battle_rewards.RolledLootEntries_12_64C7AB394C92E36998E1CAB6944CA883:ForEach(function (_, entry)
            entry = entry:get() ---@cast entry FS_RolledLootEntry
            if not string.find(entry.ItemID_2_FDDBE5744EC164155E4C959474052581:ToString(), "foot") and not string.find(entry.ItemID_2_FDDBE5744EC164155E4C959474052581:ToString(), "Merchant") then
                entry.Quantity_5_6316FB3244212C5481CB6E8C09995EF0 = 0
            else

            end
        end)
    end)

    Hooks.TableIDs["BattleRewards"] = {preID, postID, function_name}
end

--- This function is called when the game is saved.
--- We use it to:
--- * Update the flags (for poptracker)
--- * Update the battle team (if it's not valid anymore)
function Register_SaveData()
    local function_name = "/Game/Gameplay/Save/BP_SaveManager.BP_SaveManager_C:SaveGameToFile"

    local preID, postID = RegisterHook(function_name, function(self, SaveName)
        local manager = self:get() ---@cast manager UBP_SaveManager_C
        if AP_REF.APClient == nil or manager == nil or not manager:IsValid() then return end

        local data = FindFirstOf("BP_SaveGameData_C") ---@type UBP_SaveGameData_C
        if data == nil or not data:IsValid() then
            print("Impossible to save: SaveGameData nil")
            return
        end

        if not Storage.initialized_after_lumiere then
            return
        end

        if not Hooks.AddingButtonHook then
            Register_AddingButtonSavePoint()
            Hooks.AddingButtonHook = true
        end


        local flags = data.UnlockedSpawnPoints ---@type TArray<FS_LevelSpawnPointsData>
        local new = false
        flags:ForEach(function (_, element)
            local value = element:get() ---@type FS_LevelSpawnPointsData

            local level_name = value.LevelAssetName_7_D872F94549A7C2601ECF70AC3C4BAB27:ToString()
            if Storage.flags[level_name] == nil then
                Storage.flags[level_name] = {}
            end

            local points = value.SpawnPointTags_3_511D41A44873049B1F83559F7CCBA8D7 ---@type TArray<FGameplayTag>
            points:ForEach(function (_, point)
                local tag = point:get() ---@type FGameplayTag
                local tagname = tag.TagName:ToString()
                local last = tagname:match("([^%.]+)$")
                if not Contains(Storage.flags[level_name], last) then
                    table.insert(Storage.flags[level_name], last)
                    new = true
                    Logger:info("New flag found: " .. level_name .. " - " .. last)
                end
            end)
        end)

        if new then
            Storage:Update("Hooks:SaveData - New flags")
            local operation = {
                operation = "update",
                value = Storage.flags
            }
            AP_REF.APClient:Set(AP_REF.APClient:get_player_number().."-coe33-flags", Storage.flags, false, {operation})
        end

        Characters:ModifyPartyIfNeeded()
        Characters:EnableCharactersInCollectionOnlyUnlocked()
        Capacities:DisableFreeAimIfNeeded()

    end)

    Hooks.TableIDs["SaveData"] = {preID, postID, function_name}
end

--- This function is called when the current location is changing (loading a new level)
--- We use it to update the current location in poptracker for autotab
function Register_CurrentLocation()
    local function_name = "/Game/jRPGTemplate/Blueprints/Basics/FL_jRPG_CustomFunctionLibrary.FL_jRPG_CustomFunctionLibrary_C:GetCurrentLevelData"

    function RemovePortals()
        local a = FindFirstOf("BP_WorldInfoComponent_C") ---@cast a UBP_WorldInfoComponent_C
        if a == nil or not a:IsValid() then return end

        Logger:StartIGT("RemovePortals")
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
        Logger:EndIGT("RemovePortals")
    end

    local preID, postID = RegisterHook(function_name, function (self, _worldContext, found, levelData, rowName)
        if not Storage.initialized_after_lumiere then
            return
        end

        Logger:StartIGT("GetCurrentLevelData")

        local name = rowName:get()
        local level = name:ToString()

        if Storage.currentLocation ~= level then

            print("Level changed to: "..level)
            
            local new = false

            if level == "WorldMap" then
                RemovePortals()
            elseif level == "Camps" and not Hooks.AddingGestralHook then
                Register_GetGestralCount()
                Hooks.AddingGestralHook = true
            end

            if level ~= "None" then
                Logger:info("Changing level. New level is: " .. level)
                Storage.currentLocation = level
                new = true
            end

            if new then
                Logger:info("Current location changed to "..level)
                --Storage:Update("Hooks:SaveData - Current Location")
                local operation = {
                    operation = "replace",
                    value = Storage.currentLocation
                }
                AP_REF.APClient:Set(AP_REF.APClient:get_player_number().."-coe33-currentLocation", Storage.currentLocation, false, {operation})
            end
        end

        
        Logger:EndIGT("GetCurrentLevelData")

    end)

    Hooks.TableIDs["CurrentLocation"] = {preID, postID, function_name}
end

function Register_AddingButtonSavePoint()
    local function_name = "/Game/UI/Widgets/HUD_Exploration/WBP_SavePointMenu.WBP_SavePointMenu_C:UpdateUpgradeWeaponsButtonVisibility"

    local preID, postID = RegisterHook(function_name, function (context)
        local a = context:get() ---@cast a UWBP_SavePointMenu_C
        if a == nil or not a:IsValid() then return end
        a.UpgradeWeaponsButton:SetVisibility(0)
        a.UpgradeTeamButton:SetVisibility(0)
    end)

    Hooks.TableIDs["AddingButtonSavePoint"] = {preID, postID, function_name}
end

function Register_AddItemToInventory()
    local function_name = "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_InventoryManager.AC_jRPG_InventoryManager_C:AddItemToInventory"

    local preID, postID = RegisterHook(function_name, function (context, ItemHardcodedName, Amount, LootContext, GeneratedItem)
        if not Storage.initialized_after_lumiere then return end
        if Contains(TABLE_CURRENT_AP_FUNCTION, "AddItemToInventory") then return end

        local item_name = ItemHardcodedName:get():ToString()
        local inv_manager = context:get() ---@cast inv_manager UAC_jRPG_InventoryManager_C
        if item_name == "LostGestral" then
            if Archipelago.options.char_shuffle == 1 then
                Storage.gestral_found = Storage.gestral_found + 1
                inv_manager:RemoveItemFromInventory(FName(item_name), 1, true)
                Storage:Update("AddItemToInventory - LostGestral")
            end
        end
    end)

    Hooks.TableIDs["AddItemToInventory"] = {preID, postID, function_name}
end

function Register_GetGestralCount()
    local function_name = "/Game/Narrative/Dialogs/LevelsDialogs/Camp/BP_Dialogue_Quest_LostGestralChief.BP_Dialogue_Quest_LostGestralChief_C:GetFoundLostGestralCount"

    local preID, postID = RegisterHook(function_name, function (self)
        if AP_REF.APClient == nil then return end

        if Archipelago.options.gestral_shuffle == 0 then return end

        for i = 1, Storage.gestral_found do
            Archipelago:SendLocationCheck("Lost Gestral reward " .. tostring(i))
        end
    end)

    
    Hooks.TableIDs["GetGestralCount"] = {preID, postID, function_name}
end


return Hooks

local Hooks = {}

Hooks.TableIDs = {}

function Hooks:Register()
    Logger:info("Registering hooks...")
    
    Register_AddItemsFromChestToInventory()
    Register_AllChestsContentIsZero()
    Register_UpdateFeedback()
    Register_RemovePortalIfNoTickets()
    Register_SaveCharacterFromAnUnvoidableDeath()
    Register_EnableTPButtonInWorldMap()
    Register_UpdateSubquests()
    Register_BattleEndVictory()
    Register_BattleRewards()
    Register_SaveData()
    Register_CurrentLocation()
    Register_AddCharacter()

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

--- This hook is called when the player is loaded into a new map.
--- Only in the worldmap has a MapTeleportPoint_Interactible actor, so we check if we are in the worldmap
--- Then, we check all the teleport points. If the player doesn't have the ticket for the destination, we remove the portal with the blueprint mod.
function Register_RemovePortalIfNoTickets()
    local function_name = "/Game/Gameplay/GPE/Chests/BP_Chest_Regular.BP_Chest_Regular_C:UpdateFeedbackParametersFromLoot"

    local preID, postID = RegisterHook(function_name, function(self, _)
        if AP_REF.APClient == nil then return end

        local interactible = FindAllOf("BP_jRPG_MapTeleportPoint_Interactible_C") ---@cast interactible ABP_jRPG_MapTeleportPoint_Interactible_C[]
        local AP_Helper = ClientBP:GetHelper() ---@type ABP_ArchipelagoHelper_C
        if interactible == nil or AP_Helper == nil or not AP_Helper:IsValid() then return end

        for _, tp in ipairs(interactible) do
            local scene = tp.LevelDestination.RowName:ToString()
            if Storage.tickets[scene] == false then
                AP_Helper:RemoveInteractibleIfNoTicket(tp)
            else
                if tp.DestinationSpawnPointTag.TagName:ToString() == "Level.SpawnPoint.OldLumiere.EndPath" and Quests:GetObjectiveStatus("Main_GoldenPath", "10_OldLumiere") ~= QUEST_STATUS.COMPLETED then
                    AP_Helper:RemoveInteractibleIfNoTicket(tp)
                end
            end
        end
    end)
    

    Hooks.TableIDs["RemovePortalIfNoTickets"] = {preID, postID, function_name}
end

---Basically save Gustave at the end of Act 1
--- If we don't test if it's Frey (Gustave internal name), we can save Sophie at the end of prologue and Alicia from the act 3.
function Register_SaveCharacterFromAnUnvoidableDeath()
    local function_name = "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_CharactersManager.AC_jRPG_CharactersManager_C:RemoveCharacterFromCollection"

    local preID, postID = RegisterHook(function_name, function (self, data_param)
        local data = data_param:get() ---@cast data UBP_CharacterData_C

        if data.HardcodedNameID:ToString() == "Frey" then
            local char_manager = ClientBP:GetHelper() ---@type ABP_ArchipelagoHelper_C
            if char_manager == nil then return end
            char_manager:AddCharacterToCollectionFromSaveState(data)
        end
    end)

    Hooks.TableIDs["SaveCharacterFromAnUnvoidableDeath"] = {preID, postID, function_name}
end

--- Enable the teleport button. 
--- TODO: Changing the button to enable it only in world map
function Register_EnableTPButtonInWorldMap()
    local function_name = "/Game/Gameplay/Audio/BP_AudioControlSystem.BP_AudioControlSystem_C:OnPauseMenuOpened"

    local preID, postID = RegisterHook(function_name, function (context)
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
        
        if not Storage.initialized_after_lumiere and objective_name_param == "2_SpringMeadow" and status_param == QUEST_STATUS.STARTED then
            InitSaveAfterLumiere()
        elseif objective_name_param == "1_LumiereBeginning" and status_param ~= QUEST_STATUS.COMPLETED then
            Storage.initialized_after_lumiere = false
            Storage:Update("Hooks:UpdateSubquests - _LumiereBeginning")
        elseif objective_name_param == "1_ForcedCamp_PostSpringMeadows" and status_param == QUEST_STATUS.STARTED then
            Quests:SetObjectiveStatus("Main_ForcedCamps", "1_ForcedCamp_PostSpringMeadows", QUEST_STATUS.COMPLETED)
        elseif string.find(objective_name_param, "FindLostGestral") and status_param == QUEST_STATUS.COMPLETED then
            Quests:SendNextGestralReward(objective_name_param)
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
    end)

    Hooks.TableIDs["BattleEndVictory"] = {preID, postID, function_name}
end

--- Called when rolling battle rewards, at the start of the battle.
--- We empty the rolled loot, so the player doesn't receive anything from battles.
function Register_BattleRewards()
    local function_name = "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_BattleManager.AC_jRPG_BattleManager_C:RollBattleRewards"
    local preID, postID = RegisterHook(function_name, function (self, rewards)
        if AP_REF.APClient == nil then return end
        local battle_rewards = rewards:get() ---@cast battle_rewards FS_BattleRewards
        battle_rewards.RolledLootEntries_12_64C7AB394C92E36998E1CAB6944CA883:Empty()
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
       ---@cast self UBP_SaveManager_C
       ---@cast SaveName FName

        local data = FindFirstOf("BP_SaveGameData_C") ---@type UBP_SaveGameData_C
        if data == nil or not data:IsValid() then
            print("Impossible to save: SaveGameData nil")
            return
        end

        if not Storage.initialized_after_lumiere then
            return
        end

        local a = data.InteractedObjects;
        local count = 0;
        a:ForEach(function (_, _)
            count = count + 1
        end)
        print("Number of interacted objects: " .. count)

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
        Capacities:DisableFreeAimIfNeeded()
        Save:ModifyGPEIfNeeded(data)
    end)

    Hooks.TableIDs["SaveData"] = {preID, postID, function_name}
end

--- This function is called when the current location is changing (loading a new level)
--- We use it to update the current location in poptracker for autotab
function Register_CurrentLocation()
    local function_name = "/Game/jRPGTemplate/Blueprints/Basics/FL_jRPG_CustomFunctionLibrary.FL_jRPG_CustomFunctionLibrary_C:GetCurrentLevelData"

    local preID, postID = RegisterHook(function_name, function (self, _worldContext, found, levelData, rowName)

        local name = rowName:get()
        local level = name:ToString()
        local new = false

        --Logger:info("Current location changed to "..level)

        if Storage.currentLocation ~= level and level ~= "None" then

            Logger:info("Changing level. New level is: " .. level)
            Storage.currentLocation = level
            new = true
        end

        if new then
            --Storage:Update("Hooks:SaveData - Current Location")
            local operation = {
                operation = "replace",
                value = Storage.currentLocation
            }
            AP_REF.APClient:Set(AP_REF.APClient:get_player_number().."-coe33-currentLocation", Storage.currentLocation, false, {operation})
        end
    end)

    Hooks.TableIDs["CurrentLocation"] = {preID, postID, function_name}
end

--- This function is called when a character is added to the collection 
--- If char rando is on, don't do anything. Otherwise, enable the character added.
function Register_AddCharacter()
    local function_name = "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_CharactersManager.AC_jRPG_CharactersManager_C:AddNewCharacterToCollection"

    local preID, postID = RegisterHook(function_name, function (self, CharacterSaveState)
        if AP_REF.APClient == nil then return end
        local save_state = CharacterSaveState:get() ---@cast save_state FS_jRPG_CharacterSaveState
        if Archipelago.options.char_shuffle == 0 then
            if not AddingCharacterFromArchipelago then
                local name = save_state.CharacterHardcodedName_36_FB9BA9294D02CFB5AD3668B0C4FD85A5:ToString()
                Logger:info("Character " .. name .. " added to collection, but char shuffle is off. Enable it.")
                Characters:EnableCharacter(name)
            end
        end

        if AddingCharacterFromArchipelago then
            AddingCharacterFromArchipelago = false
            return
        end
    end)

    Hooks.TableIDs["AddCharacter"] = {preID, postID, function_name}
end


return Hooks

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

function Register_UpdateSubquests()
    local function_name = "/Game/Gameplay/Quests/System/BP_QuestSystem.BP_QuestSystem_C:UpdateActivitySubTaskStatus"


    local preID, postID = RegisterHook(function_name, function (self, objective_name, status)
        if AP_REF.APClient == nil then return end


        local quest_system = self:get() ---@type UBP_QuestSystem_C
        local objective_name_param = objective_name:get():ToString()
        local status_param = status:get()
        
        -- print(objective_name_param)
        if not Storage.initialized_after_lumiere and objective_name_param == "2_SpringMeadow" and status_param == 2 then
            InitSaveAfterLumiere()
        elseif objective_name_param == "1_LumiereBeginning" and status_param ~= 2 then
            Storage.initialized_after_lumiere = false
            Storage:Update()
        elseif objective_name_param == "1_ForcedCamp_PostSpringMeadows" and status_param == 1 then
            Quests:SetObjectiveStatus("Main_ForcedCamps", "1_ForcedCamp_PostSpringMeadows", QUEST_STATUS.STARTED)
        end
    end)

    
    Hooks.TableIDs["UpdateSubquests"] = {preID, postID, function_name}
end

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

function Register_BattleRewards()
    local function_name = "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_BattleManager.AC_jRPG_BattleManager_C:RollBattleRewards"
    local preID, postID = RegisterHook(function_name, function (self, rewards)
        if AP_REF.APClient == nil then return end
        local battle_rewards = rewards:get() ---@cast battle_rewards FS_BattleRewards
        battle_rewards.RolledLootEntries_12_64C7AB394C92E36998E1CAB6944CA883:Empty()
    end)

    Hooks.TableIDs["BattleRewards"] = {preID, postID, function_name}
end

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
            Storage:Update()
            local operation = {
                operation = "update",
                value = Storage.flags
            }
            AP_REF.APClient:Set(AP_REF.APClient:get_player_number().."-coe33-flags", Storage.flags, false, {operation})
        end
    end)

    Hooks.TableIDs["SaveData"] = {preID, postID, function_name}
end


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

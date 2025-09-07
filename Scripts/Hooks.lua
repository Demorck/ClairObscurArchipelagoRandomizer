local Hooks = {}

Hooks.TableIDs = {}

function Hooks:Register()
    Logger:info("Registering hooks...")
    Register_AddItemsFromChestToInventory()
    Register_AllChestsContentIsZero()
    Register_UpdateFeedback()
    Register_RemovePortalIfNoTickets()
    Register_SaveCharacterFromAnUnvoidableDeath()
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

        map:ForEach(function (key, value)
            map:Add(key:get(), 0)
        end)
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
        local AP_Helper = FindFirstOf("BP_ArchipelagoHelper_C") ---@cast AP_Helper ABP_ArchipelagoHelper_C

        for _, tp in ipairs(interactible) do
            local scene = tp.LevelDestination.RowName:ToString()
            if Data.current_ticket[scene] == nil then
                AP_Helper:RemoveInteractibleIfNoTicket(tp)
            else
                if scene == "OldLumiere" and Quests:GetObjectiveStatus("Main_GoldenPath", "10_OldLumiere") ~= QUEST_STATUS.COMPLETED then
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
            local char_manager = FindFirstOf("BP_ArchipelagoHelper_C") ---@type ABP_ArchipelagoHelper_C
            char_manager:AddCharacterToCollectionFromSaveState(data)
        end
    end)

    Hooks.TableIDs["SaveCharacterFromAnUnvoidableDeath"] = {preID, postID, function_name}
end

function Regiser_EnableTPButtonInWorldMap()
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





return Hooks
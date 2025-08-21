local Hooks = {}

Hooks.TableIDs = {}

function Hooks.Register()
    Logger:info("Registering hooks...")
    Register_AddItemsFromChestToInventory()
    Register_AllChestsContentIsZero()
    Register_UpdateFeedback()
end

function Hooks.Unregister()
    for name, id_table in pairs(Hooks.TableIDs) do
        local preID = id_table[1]
        local postID = id_table[2]

        UnregisterHook(name, preID, postID)
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

        Archipelago.SendLocationCheck(name_of_chest)
    end)

    Hooks.TableIDs[function_name] = {preID, postID}
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

    
    Hooks.TableIDs[function_name] = {preID, postID}
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

    Hooks.TableIDs[function_name] = {preID, postID}
end

function Register_RemovePortalIfNoTickets()
    local function_name = "/Game/Gameplay/GPE/Chests/BP_Chest_Regular.BP_Chest_Regular_C:UpdateFeedbackParametersFromLoot"

    local preID, postID = RegisterHook(function_name, function(self, _)
        
    end)
    
end


return Hooks
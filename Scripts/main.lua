AP_REF     = require "Archipelago/Init"
Data       = require "Data"
Debug      = require "Archipelago.Debug"
Storage    = require "Storage"
Inventory  = require "Inventory"
Capacities = require "Capacities"
Characters = require "Characters"
Archipelago = require "Archipelago"
local UEHelpers = require "UEHelpers"

function TestSomeFunctions()
   AP_REF:Connect()
end

function PrintMessage()
end

function Debug_things()
   local battle_manager = FindFirstOf("AC_jRPG_BattleManager_C") ---@type UAC_jRPG_BattleManager_C

   print(battle_manager.EncounterName:ToString())
end

function Dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. Dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

RegisterKeyBind(Key.F1, { ModifierKey.CONTROL }, function()
    ExecuteInGameThread(function()
        TestSomeFunctions()
    end)
end)

RegisterKeyBind(Key.F2, { ModifierKey.CONTROL }, function()
    ExecuteInGameThread(function()
        PrintMessage()
    end)
end)


RegisterKeyBind(Key.F3, { ModifierKey.CONTROL }, function()
    ExecuteInGameThread(function()
        Debug_things()
    end)
end)


LoopAsync(33, function ()
   if AP_REF.APClient == nil then return false end

   if Archipelago.waitingForSync then
         Archipelago.waitingForSync = false
         Archipelago.Sync()
   end

    if not Archipelago.waitingForSync then
      Archipelago.waitingForSync = true
   end

   return false
end)

RegisterHook("/Game/Gameplay/GPE/Chests/BP_Chest_Regular.BP_Chest_Regular_C:AddItemsFromChestToInventory", function (Context)
   if AP_REF.APClient == nil then return end
   
   local chest_regular = Context:get() ---@type ABP_Chest_Regular_C
   local fname = chest_regular.ChestSetupHandle["RowName"] ---@type FName
   local name_of_chest = fname:ToString()

   local function Apagnan()
      Archipelago.SendLocationCheck(name_of_chest)
   end

   ExecuteAsync(Apagnan)
end)

-- Don't give the initial item (when loading, set all quantity to 0 -> it can be cool to change color if item is progressive or not (if the option is enabled))
RegisterHook("/Game/Gameplay/GPE/Chests/BP_Chest_Regular.BP_Chest_Regular_C:RollChestItems", function(self, lootContext, itemsToLoot)
   if AP_REF.APClient == nil then return end
   
   local map = itemsToLoot:get() ---@type TMap<FName, int32>

   map:ForEach(function (key, value)
      map:Add(key:get(), 0)
   end)
end)

RegisterHook("/Game/Gameplay/GPE/Chests/BP_Chest_Regular.BP_Chest_Regular_C:UpdateFeedbackParametersFromLoot", function(self)
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

--- 701
RegisterHook("/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_BattleManager.AC_jRPG_BattleManager_C:OnBattleEndVictory", function (self)
   local current_context = self:get() ---@type UAC_jRPG_BattleManager_C

   print(current_context.EncounterName:ToString()) 
end)
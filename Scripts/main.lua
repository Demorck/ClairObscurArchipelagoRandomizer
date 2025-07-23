AP_REF     = require "Archipelago/Init"
Data       = require "Data"
Storage    = require "Storage"
Inventory  = require "Inventory"
Characters = require "Characters"
Archipelago = require "Archipelago"


local running = true

local UEHelpers = require "UEHelpers"

function TestSomeFunctions()
   AP_REF:Connect()
   -- Archipelago.Init()

   -- if Archipelago.waitingForSync then
   --    Archipelago.waitingForSync = false
   --    Archipelago.Sync()
   -- end
end

function PrintMessage()
   local manager = FindFirstOf("AC_jRPG_CharactersManager_C") ---@type UAC_jRPG_CharactersManager_C

   local fname = FName("Frey")
   manager:AddCharacterToParty(fname)

end

function Debug_things()
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
   
   local context = self:get() ---@type ABP_Chest_Regular_C
   local colors = context.ColorWhenOpening -- When you pick the item, there is some dust. That's this color 
   colors.R = 0
   colors.G = 0
   colors.B = 1
   context:UpdateVisuals()
   

   local map = itemsToLoot:get() ---@type TMap<FName, int32>

   map:ForEach(function (key, value)
      map:Add(key:get(), 0)
   end)
end)

RegisterHook("/Game/Gameplay/GPE/Chests/BP_Chest_Regular.BP_Chest_Regular_C:UpdateFeedbackParametersFromLoot", function(self)
   if AP_REF.APClient == nil then return end

   local chest = self:get() ---@type ABP_Chest_Regular_C

   local fx = chest.FX_Chest
   if fx then
   local color = {
      R = 0.0,
      G = 1.0,
      B = 0.0,
      A = 1.0
   } ---@type FLinearColor

      fx:SetColorParameter(FName("Color"), color)  -- the fx when the item is on the floor
   end
end)

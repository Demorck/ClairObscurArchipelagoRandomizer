Logger      = require "Logger"
Hooks       = require "Hooks"
Data        = require "Data"
Debug       = require "Archipelago.Debug"
Storage     = require "Storage"
Inventory   = require "Inventory"
Capacities  = require "Capacities"
Characters  = require "Characters"
Quests      = require "Quests"
Save        = require "Save"
ClientBP    = require "ClientBP"
Battle      = require "Battle"
CONSTANTS   = require "ClientConstants"


Archipelago       = require "Archipelago"
ArchipelagoSystem = require "Archipelago.Init"
Archipelago.apSystem = ArchipelagoSystem

-- Just for compatbility for now
AP_REF = {
    APClient = nil,
}

setmetatable(AP_REF, {
    __index = function(t, key)
        if key == "APClient" then
            if ArchipelagoSystem and ArchipelagoSystem:IsConnected() then
                return ArchipelagoSystem:GetClient():GetClient()
            end
            return nil
        end
        return rawget(t, key)
    end
})

RequestInitLumiere = false
AddingCharacterFromArchipelago = false
TABLE_CURRENT_AP_FUNCTION = {}


local function_helper = nil
local address = 0

function TestSomeFunctions()
   Save:SaveGame()
end
function PrintMessage()
   Archipelago:Sync()
end

function Debug_things()
   -- if function_helper == nil then return end
   -- ---@cast function_helper UFL_jRPG_CustomFunctionLibrary_C
   
   -- local helper = FindFirstOf("BP_ItemUpgradeSystem_C") ---@cast helper UBP_ItemUpgradeSystem_C
   
   -- print("1")
   -- local bool = {}
   -- local res = function_helper:GetItemStaticDefinitionFromID(FName("UpgradeMaterial_Level2"), helper:GetWorld(), bool)

   -- print("2")
   -- local ret = {} 
   -- print(Dump(bool))
   -- helper:CreateItemInstanceInternal(res, 1, ret)
   -- print("3")
   -- ---@cast ret UBP_ItemInstance_Base_C

   -- print(ret.ItemDefinitionID:ToString())
   -- print("4")
end

-- And maybe the party issues in act 3 ? there is one iirc

RegisterCustomEvent("ConnectButtonPressed", function(Context, host, port, slot, password, deathlink, musicrando)
    local hostStr = host:get():ToString()
    local portStr = port:get():ToString()
    local slotStr = slot:get():ToString()
    local passwordStr = password:get():ToString()
    local deathlinkBool = deathlink:get()
    

    ExecuteAsync(function ()
      ArchipelagoSystem:SetConnectionConfig(hostStr, portStr, slotStr, passwordStr, deathlinkBool)
      ArchipelagoSystem:ToggleConnection()
    end)
end)

function Dump(o, depth)
   depth = depth or 0
   local indent = string.rep('  ', depth * 4)

   if type(o) == 'table' then
      local s = '{\n'
      for k,v in pairs(o) do
         if type(k) == "userdata" then k = k:get()  end
         
         if type(k) == 'string' then k = '"'..k..'"'
         elseif type(k) == "number" then k = k
         elseif string.find(tostring(k), "FName") then k = k:ToString()
         else k = type(k)
         end

         if string.find(tostring(v), "FName") then v = v:ToString()
         elseif type(v) == "userdata" then v = v:get() 
            if string.find(tostring(v), "FName") then v = v:ToString()
         end
         
         if type(v) == 'string' then v = '"'..v..'"'
         elseif type(v) == "number" then v = v
         else v = type(v) end
         end
         
         s = s .. indent .. '['.. k .. '] = ' .. Dump(v, depth + 1) .. ',\n'
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function Contains(table, val)
   for i=1,#table do
      if table[i] == val then 
         return true
      end
   end
   return false
end

function Remove(t, val)
   for i=1,#t do
      if t[i] == val then
         table.remove(t, i)
         return
      end
   end
end

function Trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
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


function InitSaveAfterLumiere()
   if Storage.initialized_after_lumiere then
      return false
   end

   
   Logger:info("The festival ended...")
   Characters:AddEveryone()

   if Archipelago.options.char_shuffle == 0 then
      table.insert(Storage.characters, "Frey")
   end

   Characters:EnableOnlyUnlockedCharacters()
   Characters:EnableCharactersInPartyOnlyUnlocked()
   Inventory:Adding999Recoat()
   Capacities:UnlockAllExplorationCapacities()

   Save:WriteFlagByID("NID_ForgottenBattlefield_GradientCounterTutorial", true)
   Save:WriteFlagByID("NID_Goblu_JumpTutorial", true)
   Save:WriteFlagByID("NID_LuneRelationshipLvl6_Quest", true)
   Save:WriteFlagByID("NID_Monoco_RelationshipLvl6_Quest", true)

   Storage.initialized_after_lumiere = true
   Storage:Update("InitSaveAfterLumiere")
   Logger:info("Lumiere is done, ciao")

   Storage.transition_lumiere = true
   -- Archipelago:Sync()
end

-- RegisterHook("/Game/jRPGTemplate/Blueprints/Basics/FL_jRPG_CustomFunctionLibrary.FL_jRPG_CustomFunctionLibrary_C:GetItemStaticDefinitionFromID", function (self, id, wc, found)
--    local a = self:get() ---@type UFL_jRPG_CustomFunctionLibrary_C
--    if address ~= a:GetAddress() then
--       function_helper = a
--       address = a:GetAddress()
--       print("Changed !!!!!!!!!!!!!!!!!!!!!!!!")
--    end 
-- end)

-- RegisterHook("/Game/Gameplay/Inventory/Merchant/BP_MerchantComponent.BP_MerchantComponent_C:ComputeItemToSell", function (self, ItemsDataTable, ItemRowName, MerchantItemSellData)
--    local a = ItemsDataTable:get() ---@type UDataTable
--    local struct = {
--       ItemRowName_18_22FD2F5E42C1473FBA6AB9BF09E4890C  = FName("WM_13_2"),
--       PriceOverride_6_7DE9A0224D826DBF8CF033AD6077A4EE = 500,
--       LevelOverride_8_A53457704B4D0037ECA806A29C727EF4 = 33,
--       Quantity_10_A62DFEDB41EF5DA12CE979AB3F742758     = 50,
--    } ---@type FS_MerchantItemData

--    a:EmptyTable()
--    a:AddRow("WM_13_2", struct)
--    a:AddRow("WM_13_3", struct)
-- end)

-- RegisterHook("/Game/Gameplay/Inventory/Merchant/BP_MerchantComponent.BP_MerchantComponent_C:AddItemToInventory", function (context, map)
--    local map = map:get() ---@type FS_MerchantItemSellData
--    print(map.MerchantItemRowName_19_99825E3B4AFE8709C171D08CC8D8DEEC:ToString())
-- end)

-- RegisterHook("/Game/Gameplay/Inventory/Merchant/BP_MerchantComponent.BP_MerchantComponent_C:ComputeAvailableItemsFromTable", function (context, map)
--    local ctx = context:get() ---@type UBP_MerchantComponent_C

--    local a = ctx.AvailableItems
--    a:ForEach(function (key, value)
--       local k = key:get()
--       local v = value:get() ---@type FS_MerchantItemSellData
      
--       print(v.MerchantItemRowName_19_99825E3B4AFE8709C171D08CC8D8DEEC:ToString())
--       v.Item_15_2E3DFF0F4A92DBADAFACE98DDB1141DE.Item_DisplayName_89_41C0C54E4A55598869C84CA3B5B5DECA = FText("Archipelago item")
--       v.Item_15_2E3DFF0F4A92DBADAFACE98DDB1141DE.ItemDescription_32_0A978AFB4AB4B316342DD6A72ACDD4E1 = FText("apagnan bien sûr")
--       v.Item_15_2E3DFF0F4A92DBADAFACE98DDB1141DE.Item_Icon_95_4D742A7E46F761161F9173969C69F468 = ClientBP:GetHelper().Icon_AP

--    end)
-- end)
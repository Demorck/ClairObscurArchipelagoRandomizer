Logger     = require "Logger"
Hooks      = require "Hooks.index"
Data       = require "Data"
Debug      = require "Archipelago.Debug"
Storage    = require "Storage.index" ---@type Storage
Inventory  = require "Game.Inventory"
Capacities = require "Game.Capacities"
Characters = require "Game.Characters"
Quests     = require "Game.Quests"
Save       = require "Game.Save"
ClientBP   = require "Game.ClientBP"
Battle     = require "Game.Battle"
CONSTANTS  = require "Constants.index"
Utils      = require "Utils.index"
Commands   = require "Commands"

Dump = Utils.TableHelper.Dump
Contains = Utils.TableHelper.Contains
Trim = Utils.StringHelper.Trim
Remove = Utils.TableHelper.Remove


Archipelago          = require "Archipelago"
ArchipelagoSystem    = require "Archipelago.Init"
Archipelago.apSystem = ArchipelagoSystem

Commands:RegisterKeybinds()

-- Just for compatbility for now
AP_REF               = {
   APClient = nil,
}

NEEDED_TO_INIT = false

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

AddingCharacterFromArchipelago = false
FLAG_COMMAND = false

-- And maybe the party issues in act 3 ? there is one iirc

RegisterCustomEvent("ConnectButtonPressed", function(Context, host, port, slot, password, deathlink, musicrando)
   local hostStr = host:get():ToString()
   local portStr = port:get():ToString()
   local slotStr = slot:get():ToString()
   local passwordStr = password:get():ToString()
   local deathlinkBool = deathlink:get()

   print("[COE33AP - Before connection] Connect button pressed")

   ExecuteAsync(function()
      ArchipelagoSystem:SetConnectionConfig(hostStr, portStr, slotStr, passwordStr, deathlinkBool)
      ArchipelagoSystem:ToggleConnection()
   end)
end)

RegisterCustomEvent("ConnectionSettings_CB_SaveIcon", function(ctx, is_checked)
   CONSTANTS.RUNTIME.CHANGE_SAVE_ICON = is_checked:get()
end)


function InitSaveAfterLumiere()
   Logger:info("Initialized after Lumière")
   Characters:AddEveryone()
   Characters:HealEveryone()

   if Archipelago.options.char_shuffle == 0 then
      Storage:UnlockCharacter("Frey")
   end

   Archipelago:Sync()

   Characters:EnableCharactersInPartyOnlyUnlocked()
   Inventory:Adding999Recoat()
   Capacities:UnlockAllExplorationCapacities()

   Save:WriteFlagByName(CONSTANTS.NID.FB_GRADIENT_TUTORIAL.NAME, true)
   Save:WriteFlagByName(CONSTANTS.NID.FW_JUMP_TUTORIAL.NAME, true)
   Save:WriteFlagByName(CONSTANTS.NID.REACHER_LVL6_MAELLE.NAME, true)
   Save:WriteFlagByName(CONSTANTS.NID.RELATION_LVL6_LUNE.NAME, true)
   Save:WriteFlagByName(CONSTANTS.NID.RELATION_LVL6_MONOCO.NAME, true)

   Quests:SetObjectiveStatus(CONSTANTS.QUEST.GOLDEN_PATH.QUEST_NAME, CONSTANTS.QUEST.GOLDEN_PATH.LUMIERE_BEGINNING, QUEST_STATUS.COMPLETED)
   Quests:SetObjectiveStatus(CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME, CONSTANTS.QUEST.LUMIERE_ACT1.DUEL_MAELLE, QUEST_STATUS.COMPLETED)
   Quests:SetObjectiveStatus(CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME, CONSTANTS.QUEST.LUMIERE_ACT1.FLOWER, QUEST_STATUS.COMPLETED)
   Quests:SetObjectiveStatus(CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME, CONSTANTS.QUEST.LUMIERE_ACT1.MIME, QUEST_STATUS.COMPLETED)
   Quests:SetObjectiveStatus(CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME, CONSTANTS.QUEST.LUMIERE_ACT1.FIND_TRASHMAN, QUEST_STATUS.COMPLETED)
   Quests:SetObjectiveStatus(CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME, CONSTANTS.QUEST.LUMIERE_ACT1.NEWSPAPER_PETALS, QUEST_STATUS.COMPLETED)
   Quests:SetObjectiveStatus(CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME, CONSTANTS.QUEST.LUMIERE_ACT1.PAINTER, QUEST_STATUS.COMPLETED)
   Quests:SetObjectiveStatus(CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME, CONSTANTS.QUEST.LUMIERE_ACT1.RUN_MAELLE_1, QUEST_STATUS.COMPLETED)
   Quests:SetObjectiveStatus(CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME, CONSTANTS.QUEST.LUMIERE_ACT1.RUN_MAELLE_2, QUEST_STATUS.COMPLETED)
   Quests:SetObjectiveStatus(CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME, CONSTANTS.QUEST.LUMIERE_ACT1.SCULPTURE_NEVRON, QUEST_STATUS.COMPLETED)
   Quests:SetObjectiveStatus(CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME, CONSTANTS.QUEST.LUMIERE_ACT1.SOPHIE, QUEST_STATUS.COMPLETED)


   -- LoopAsync(1000 * 10, function ()
   --    local pause_menu = FindFirstOf("WBP_PauseMenu_C") ---@type UWBP_PauseMenu_C
   --    pause_menu:TeleportToSafeLocation()
   --    return true
   -- end)
end

print("[COE33AP - Before Connection] Main initialized")

local struct = {
      ItemRowName_18_22FD2F5E42C1473FBA6AB9BF09E4890C  = FName("Consumable_LuminaPoint"),
      PriceOverride_6_7DE9A0224D826DBF8CF033AD6077A4EE = 500,
      LevelOverride_8_A53457704B4D0037ECA806A29C727EF4 = 33,
      Quantity_10_A62DFEDB41EF5DA12CE979AB3F742758     = 50,
   } ---@type FS_MerchantItemData

function registerhooks()
   -- --- Pour les armes et pictos déjà eu + WBP 
   RegisterHook("/Game/UI/Widgets/InGame_Menu/Merchant/WBP_Merchant_Item_Row.WBP_Merchant_Item_Row_C:IsMerchantItemBetterThanOwnedItem", function (row, value)
      value:set(true)
      local merchant_row = row:get() ---@type UWBP_Merchant_Item_Row_C
      if merchant_row ~= nil and merchant_row:IsValid() then
         merchant_row.OwnedBox:SetVisibility(1)

         local hbox = merchant_row.WBP_BaseButton.ButtonContent:GetContent() ---@type UHorizontalBox
         local last = hbox:GetChildAt(4) ---@type UScaleBox
         last:SetVisibility(1)
      end
   end)

   -- --- Modification de la ligne du marchant
   RegisterHook("/Game/Gameplay/Inventory/Merchant/BP_MerchantComponent.BP_MerchantComponent_C:GetItemFromName", function (self, ItemName, ItemStaticData)
      local item_data = ItemStaticData:get() ---@type FS_jRPG_Item_StaticData

      item_data.Item_Icon_95_4D742A7E46F761161F9173969C69F468 = ClientBP:GetHelper().IconAP
      item_data.Item_DisplayName_89_41C0C54E4A55598869C84CA3B5B5DECA = FText("An item")

      item_data.HideInInventory_105_28F500C94EA8D5C6632F7E8E4A85586E = true
      item_data.HideInLootPopup_107_333FB0CB4314A0D9E40A7F8480A5686A = true
   end)
   
   -- --- Modifie droite + injecter le rowname (main)
   RegisterHook("/Game/Gameplay/Inventory/Merchant/BP_MerchantComponent.BP_MerchantComponent_C:ComputeItemToSell", function (self, ItemsDataTable, ItemRowName, MerchantItemSellData)
      local a = MerchantItemSellData:get() ---@type FS_MerchantItemSellData
      print(ItemRowName:get():ToString())
      
      a.Price_9_248FCE8A44F45DA941E4588E69DEC974 = struct.PriceOverride_6_7DE9A0224D826DBF8CF033AD6077A4EE

      a.IsConditional_21_88432AA744B13A1E76DA06A6BE959C5B = false
      a.IsVisible_14_1EA2C6EF4F1FD7E6D108ACA2706ACF30 = true -- can be use with gestral item
      a.RemainingQuantity_11_1B190D314C37EDBB84752194D11E5070 = math.random(2) - 1

      local instance = a.ItemInstance_30_348E27D442782C0B63BEEE9F20829FC9
      local item_data = instance.ItemStaticData
      instance.ItemDefinitionID = ItemRowName:get()
      item_data.Item_HardcodedName_90_C7F763B74AAB28EF890A66854D7D95AA = FName("FaceMaelle_DoubleBraid")
      item_data.Item_Type_88_2F24F8FB4235429B4DE1399DBA533C78 = 4
      item_data.Item_Type_88_2F24F8FB4235429B4DE1399DBA533C78 = 8
      item_data.ItemDescription_32_0A978AFB4AB4B316342DD6A72ACDD4E1 = FText("An important item for Hollow Knight")
      item_data.Item_DisplayName_89_41C0C54E4A55598869C84CA3B5B5DECA = FText(ItemRowName:get():ToString())
      item_data.Item_Icon_95_4D742A7E46F761161F9173969C69F468 = ClientBP:GetHelper().IconAP
      item_data.Consumable_MaxStackAmount_76_2DD073774D235ED7EE5C8F99817D7FFA = 99
      item_data.Pictos_Data_103_EE44D66B4E4F16A7FD44FF9F25777CF4 = nil
      item_data.Pictos_ItemStats_91_229F4A00415AB214191377B73987FF7B = nil
      item_data.HideInInventory_105_28F500C94EA8D5C6632F7E8E4A85586E = true
      item_data.HideInLootPopup_107_333FB0CB4314A0D9E40A7F8480A5686A = true
   end)

   --- Aucun autre moyen de modifier après car les hooks se font post appel
   --- Possiblement obliger d'itérer sur toutes les datatable. Peut être qu'avec le self, on peut trovuer le bon cependant (ou la map)
   RegisterHook("/Game/Gameplay/DialogueSystem/BP_DialogueSystemComponent.BP_DialogueSystemComponent_C:ActivateDialogue", function (self, ...)
      local a = StaticFindObject("/Game/Gameplay/Inventory/Merchant/Merchants_Content_DT/DT_Merchant_OldLumiere.DT_Merchant_OldLumiere") ---@type UDataTable
      
      a:EmptyTable()

      for i = 1, 10, 1 do
         local struct = {
            ItemRowName_18_22FD2F5E42C1473FBA6AB9BF09E4890C  = FName("Consumable_LuminaPoint"),
            PriceOverride_6_7DE9A0224D826DBF8CF033AD6077A4EE = 500,
            LevelOverride_8_A53457704B4D0037ECA806A29C727EF4 = 33,
            Quantity_10_A62DFEDB41EF5DA12CE979AB3F742758     = 50,
         } ---@type FS_MerchantItemData

         a:AddRow("OL_" .. tostring(i), struct)
      end
   end)

end
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

RegisterCustomEvent("ConnectButtonPressed", function(Context, settings)
   local ap_settings = settings:get() ---@type FS_AP_Settings
   local hostStr = ap_settings.host_5_57D7FAAE4EE105D7FFBA43836D0EB068:ToString()
   local portStr = ap_settings.port_6_667302EB4A0B1D65E7126FA80C5F37A9:ToString()
   local slotStr = ap_settings.slot_8_F865C5C946B8CEFF2A3CBC95B903BC9C:ToString()
   local passwordStr = ap_settings.password_9_29E90B5A490FB64EF37D899B7FE35702:ToString()
   local deathlinkBool = ap_settings.death_link_16_BD6444064CB7AF2080DA9F86599CD9A0
   CONSTANTS.RUNTIME.CHANGE_SAVE_ICON = ap_settings.save_icon_18_CAE18D2E4FC0450B5A48BABB660DF652
   
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

local tablel = {}
print("[COE33AP - Before Connection] Main initialized")

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

      local data = table.remove(tablel, 1)
      item_data.Item_Icon_95_4D742A7E46F761161F9173969C69F468 = ClientBP:GetHelper().IconAP:Find(data["classification"]):get()
      item_data.Item_DisplayName_89_41C0C54E4A55598869C84CA3B5B5DECA = FText(data["name"])
      

      item_data.HideInInventory_105_28F500C94EA8D5C6632F7E8E4A85586E = true
      item_data.HideInLootPopup_107_333FB0CB4314A0D9E40A7F8480A5686A = true
      table.insert(tablel, data)
   end)
   
   -- --- Modifie droite + injecter le rowname (main)
   RegisterHook("/Game/Gameplay/Inventory/Merchant/BP_MerchantComponent.BP_MerchantComponent_C:ComputeItemToSell", function (self, ItemsDataTable, ItemRowName, MerchantItemSellData)
      local a = MerchantItemSellData:get() ---@type FS_MerchantItemSellData
      local location_name = ItemRowName:get():ToString()
      local scouted_location = Storage:Get("merchant_scouted")[location_name]
      local found = Storage:IsLocationInMerchantFound(location_name)
      local item_unlock = "Merchant: Mandelgo - Extra shop unlock"
      local internal_name = Data:FindInternalNameItemFromName(item_unlock)
            -- print(internal_name)
      local has_item = Inventory:HasItem(internal_name)
      local f = string.find(location_name, "Extra Item")
      local extra = f ~= nil

      local string_builded = ""
      local easter_egg = math.random(10000)
      if easter_egg == 1 then
         string_builded = "A fucking item for a fucking player probably for yezzdia then"
      else
         string_builded = scouted_location.item_name .. " for " .. scouted_location.player_name
      end
      
      a.Price_9_248FCE8A44F45DA941E4588E69DEC974 = math.random(6000)

      a.IsConditional_21_88432AA744B13A1E76DA06A6BE959C5B = false
      a.IsVisible_14_1EA2C6EF4F1FD7E6D108ACA2706ACF30 = not extra or has_item -- can be use with gestral item
      a.RemainingQuantity_11_1B190D314C37EDBB84752194D11E5070 = found and 0 or 1

      local instance = a.ItemInstance_30_348E27D442782C0B63BEEE9F20829FC9
      local item_data = instance.ItemStaticData
      instance.ItemDefinitionID = ItemRowName:get()
      item_data.Item_HardcodedName_90_C7F763B74AAB28EF890A66854D7D95AA = FName("FaceMaelle_DoubleBraid")
      item_data.Item_Type_88_2F24F8FB4235429B4DE1399DBA533C78 = 4
      item_data.Item_Type_88_2F24F8FB4235429B4DE1399DBA533C78 = 8
      item_data.ItemDescription_32_0A978AFB4AB4B316342DD6A72ACDD4E1 = FText(string_builded)
      item_data.Item_DisplayName_89_41C0C54E4A55598869C84CA3B5B5DECA = FText(location_name)
      item_data.Item_Icon_95_4D742A7E46F761161F9173969C69F468 = ClientBP:GetHelper().IconAP:Find(scouted_location.classification):get()
      item_data.Consumable_MaxStackAmount_76_2DD073774D235ED7EE5C8F99817D7FFA = 1
      item_data.Pictos_Data_103_EE44D66B4E4F16A7FD44FF9F25777CF4 = nil
      item_data.Pictos_ItemStats_91_229F4A00415AB214191377B73987FF7B = nil
      item_data.HideInInventory_105_28F500C94EA8D5C6632F7E8E4A85586E = true
      item_data.HideInLootPopup_107_333FB0CB4314A0D9E40A7F8480A5686A = true
   end)

   --- Aucun autre moyen de modifier après car les hooks se font post appel
   --- Possiblement obliger d'itérer sur toutes les datatable. Peut être qu'avec le self, on peut trovuer le bon cependant (ou la map)
   RegisterHook("/Game/Gameplay/DialogueSystem/BP_DialogueSystemComponent.BP_DialogueSystemComponent_C:ActivateDialogue", function (self, ...)

      local shop_data = Data.shops

      if shop_data == nil then return end
      -- for _, shop in ipairs(shop_data) do
         local datatable = StaticFindObject("/Game/Gameplay/Inventory/Merchant/Merchants_Content_DT/DT_Merchant_OldLumiere.DT_Merchant_OldLumiere") ---@type UDataTable
         if datatable ~= nil and datatable:IsValid() then 
            datatable:EmptyTable()
            local item_unlock = "Merchant: Mandelgo - Extra shop unlock"
            local internal_name = Data:FindInternalNameItemFromName(item_unlock)
            local has_item = Inventory:HasItem(internal_name)

            for i = 1, Archipelago.options.location_per_shop, 1 do
               local name = "Shop: Old Lumiere Merchant - Item " .. tostring(i)
               local scouted_location = Storage:Get("merchant_scouted")[name]
               if scouted_location.found then
                  goto continue
               end


               local struct = {
                  ItemRowName_18_22FD2F5E42C1473FBA6AB9BF09E4890C  = FName("Consumable_LuminaPoint"),
                  PriceOverride_6_7DE9A0224D826DBF8CF033AD6077A4EE = 666,
                  LevelOverride_8_A53457704B4D0037ECA806A29C727EF4 = -1,
                  Quantity_10_A62DFEDB41EF5DA12CE979AB3F742758     = 1,
               } ---@type FS_MerchantItemData

               -- local name = "Shop: " .. shop.name .. " - Item " .. tostring(i)
               datatable:AddRow(name, struct)
               table.insert(tablel, { ["name"] = name, ["classification"] = scouted_location.classification})

               ::continue::
            end

            -- if not is fight then
            --    return
            -- end

            for i = 1, Archipelago.options.extra_location_per_shop, 1 do
               local name = "Shop: Old Lumiere Merchant - Extra Item " .. tostring(i)
               local scouted_location = Storage:Get("merchant_scouted")[name]
               if scouted_location.found then
                  goto continue
               end


               local struct = {
                  ItemRowName_18_22FD2F5E42C1473FBA6AB9BF09E4890C  = FName("Consumable_LuminaPoint"),
                  PriceOverride_6_7DE9A0224D826DBF8CF033AD6077A4EE = 666,
                  LevelOverride_8_A53457704B4D0037ECA806A29C727EF4 = -1,
                  Quantity_10_A62DFEDB41EF5DA12CE979AB3F742758     = 1,
               } ---@type FS_MerchantItemData

               -- local name = "Shop: " .. shop.name .. " - Item " .. tostring(i)
               datatable:AddRow(name, struct)
               table.insert(tablel, { ["name"] = name, ["classification"] = scouted_location.classification})

               ::continue::
            end
         end
      -- end
   end)

end

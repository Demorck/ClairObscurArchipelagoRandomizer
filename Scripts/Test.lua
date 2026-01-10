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

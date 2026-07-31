---Battle-related hooks
---@class ShopHooks
local ShopHooks = {}


---comment
---@param datatable UDataTable
---@param shop_data ShopData
---@param table_to_insert_data_inserted_in_datatable table
local function AddItemRowsInDataTable(datatable, shop_data, is_extra, table_to_insert_data_inserted_in_datatable)
    local base_struct = {
        ItemRowName_18_22FD2F5E42C1473FBA6AB9BF09E4890C  = FName("Consumable_LuminaPoint"),
        PriceOverride_6_7DE9A0224D826DBF8CF033AD6077A4EE = 666,
        LevelOverride_8_A53457704B4D0037ECA806A29C727EF4 = -1,
        Quantity_10_A62DFEDB41EF5DA12CE979AB3F742758     = 1,
    } ---@type FS_MerchantItemData

    local item_type = is_extra and "Extra Item" or "Item"
    local number_to_add = is_extra and Archipelago.options.extra_location_per_shop or Archipelago.options.location_per_shop

    print(tostring(number_to_add))
    for i = 1, number_to_add, 1 do
        local name = "Shop: " .. shop_data.name .. " - " .. item_type .. " " .. tostring(i)
        local scouted_location = Storage:Get("merchant_scouted")[name]
        if scouted_location.found then
            goto scout_found
        end

        datatable:AddRow(name, base_struct)
        table.insert(table_to_insert_data_inserted_in_datatable[datatable:GetFName():ToString()], 
            { ["name"] = name, ["classification"] = scouted_location.classification}
        )

        ::scout_found::
    end
end

---Register all battle hooks
---@param hookManager HookManager
---@param dependencies table
function ShopHooks:Register(hookManager, dependencies)
    self.last_shop_visited = nil
    local logger = dependencies.logger

    local table_current_shop = {}

    -- Removing "Owned: x" in the row
    hookManager:Register(
        "/Game/UI/Widgets/InGame_Menu/Merchant/WBP_Merchant_Item_Row.WBP_Merchant_Item_Row_C:IsMerchantItemBetterThanOwnedItem",
        self:RemoveShopOwnedBox(),
        "Shop - Modify Shop row"
    )

    -- Changing the row image and name
    hookManager:Register(
        "/Game/Gameplay/Inventory/Merchant/BP_MerchantComponent.BP_MerchantComponent_C:GetItemFromName",
        self:ChangeShopRowData(table_current_shop),
        "Shop - Modify Shop row"
    )

    -- Changing the right description
    hookManager:Register(
        "/Game/Gameplay/DialogueSystem/BP_DialogueSystemComponent.BP_DialogueSystemComponent_C:ActivateDialogue",
        self:ModifyDatatable(table_current_shop),
        "Shop - Modify Datatable"
    )

    -- Changing the datatable for retrieving item informations
    hookManager:Register(
        "/Game/Gameplay/Inventory/Merchant/BP_MerchantComponent.BP_MerchantComponent_C:ComputeItemToSell",
        self:ChangeItemInformation(),
        "Shop - Modify Shop row"
    )

    logger:info("Shop hooks registered")
end

function ShopHooks:RemoveShopOwnedBox()
    return function(row, value)
        value:set(true)
        local merchant_row = row:get() ---@type UWBP_Merchant_Item_Row_C
        if merchant_row ~= nil and merchant_row:IsValid() then
            merchant_row.OwnedBox:SetVisibility(1)

            local hbox = merchant_row.WBP_BaseButton.ButtonContent:GetContent() ---@type UHorizontalBox
            local last = hbox:GetChildAt(4) ---@type UScaleBox
            last:SetVisibility(1)
        end
    end
end

function ShopHooks:ChangeShopRowData(t)
    return function (ctx, ItemName, ItemStaticData)
        local item_data = ItemStaticData:get() ---@type FS_jRPG_Item_StaticData
        local merchant = ctx:get() ---@cast merchant UBP_MerchantComponent_C

        print("Merchant DT: ", merchant.Items:GetFName():ToString())

        local data_merchant = t[merchant.Items:GetFName():ToString()]
        local data = table.remove(data_merchant, 1)

        local icon = ClientBP:GetHelper().IconAP:Find(2):get()
        local display_name     = FText("An item")

        if not Archipelago.options.show_shop_items then
            display_name     = FText(data["name"])
            icon             = ClientBP:GetHelper().IconAP:Find(data["classification"]):get()
        end
        
        item_data.Item_Icon_95_4D742A7E46F761161F9173969C69F468 = icon
        item_data.Item_DisplayName_89_41C0C54E4A55598869C84CA3B5B5DECA = display_name

        item_data.HideInInventory_105_28F500C94EA8D5C6632F7E8E4A85586E = true
        item_data.HideInLootPopup_107_333FB0CB4314A0D9E40A7F8480A5686A = true
        table.insert(data_merchant, data)
   end
end

function ShopHooks:ModifyDatatable(table_to_insert_data_inserted_in_datatable)
    return function (ctx, ...)

        local shop_data = Data.shops
        if shop_data == nil then 
            print("shop data nil")
            return 
        end
        
        local level_asset_name = ClientBP:GetLevelName()
        local shop_datatable_in_level = CONSTANTS.GAME.TABLE.SHOP_DATATABLE_BY_MAP[level_asset_name]
        for _, shop in ipairs(shop_data) do
            local found = false
            for _, shop_datatable in ipairs(shop_datatable_in_level) do
                if shop.datatable == shop_datatable then
                    found = true
                    break
                end
            end

            if not found then
                goto next_shop_data
            end

            local datatable_location = "/Game/Gameplay/Inventory/Merchant/Merchants_Content_DT/" .. shop.datatable
            local datatable = StaticFindObject(datatable_location) ---@cast datatable UDataTable
            if datatable == nil or not datatable:IsValid() then return end

            if self.last_shop_visited == nil or self.last_shop_visited ~= shop.name then
                self.last_shop_visited = shop.name
                local _, _, dt_name  = string.find(shop.datatable, ".*%.(.*)", 1, false)
                if dt_name == nil then 
                    print("dfojipadnoka")
                    return 
                end

                table_to_insert_data_inserted_in_datatable[dt_name] = {}
            end

            datatable:EmptyTable()
            AddItemRowsInDataTable(datatable, shop, false, table_to_insert_data_inserted_in_datatable)

            if shop.has_fight then
                AddItemRowsInDataTable(datatable, shop, true, table_to_insert_data_inserted_in_datatable)
            end

            ::next_shop_data::
        end
   end
end

function ShopHooks:ChangeItemInformation()
    return function (self, ItemsDataTable, ItemRowName, MerchantItemSellData)
        local a = MerchantItemSellData:get() ---@type FS_MerchantItemSellData
        local location_name = ItemRowName:get():ToString()

        -- Find the shop name based on the locations name
        local scouted_location = Storage:Get("merchant_scouted")[location_name]
        local _, _, shop_name  = string.find(location_name, ".*:%s(.*)%s%-.*", 1, false)
        local _, _, item_id_str    = string.find(location_name, ".*Item%s(.*)", 1, false)
        if shop_name == nil or item_id_str == nil then 
            print("nil somewhere shop name: " .. tostring(shop_name) .. " or item_id_str: " .. tostring(item_id_str))
            return
        end

        local item_id = tonumber(item_id_str)

        -- Find the shop data based on the shops name
        local found = Storage:IsLocationInMerchantFound(location_name)
        local shop_data = Data:FindShop(shop_name)
        if shop_data == nil then 
            print("shop_data nil")
            return 
        end

        
        local f = string.find(location_name, "Extra Item")
        local extra = f ~= nil

        local has_item = not extra
        local price = Archipelago.shop_data[shop_data.name]["prices"][item_id]
        if extra then
            local internal_name = Data:FindInternalNameItemFromName(shop_data.unlock_item)
            has_item = Inventory:HasItem(internal_name)
            price = Archipelago.shop_data[shop_data.name]["extra_prices"][item_id]
        end


        local string_builded = ""
        local easter_egg = math.random(10000)
        if easter_egg == 1 then
            string_builded = "A fucking item for a fucking player probably for yezzdia then"
        else
            string_builded = scouted_location.item_name .. " for " .. scouted_location.player_name
        end

        local item_description = FText("An item")
        local display_name = FText("An item")
        local icon = ClientBP:GetHelper().IconAP:Find(2):get()

        if Archipelago.options.show_shop_items then
            item_description = FText(string_builded)
            display_name     = FText(location_name)
            icon             = ClientBP:GetHelper().IconAP:Find(scouted_location.classification):get()
        end

        if Archipelago.options.create_hint and not extra then
            Archipelago:ScoutLocation(location_name, true)
        end

        if Archipelago.options.create_hint_extra and extra then
            Archipelago:ScoutLocation(location_name, true)
        end
        
        a.Price_9_248FCE8A44F45DA941E4588E69DEC974 = price

        a.IsConditional_21_88432AA744B13A1E76DA06A6BE959C5B = false
        a.IsVisible_14_1EA2C6EF4F1FD7E6D108ACA2706ACF30 = not extra or has_item
        a.RemainingQuantity_11_1B190D314C37EDBB84752194D11E5070 = found and 0 or 1

        local instance = a.ItemInstance_30_348E27D442782C0B63BEEE9F20829FC9
        local item_data = instance.ItemStaticData
        instance.ItemDefinitionID = ItemRowName:get()
        item_data.Item_HardcodedName_90_C7F763B74AAB28EF890A66854D7D95AA = FName("FaceMaelle_DoubleBraid")
        item_data.Item_Type_88_2F24F8FB4235429B4DE1399DBA533C78 = 4
        item_data.Item_Type_88_2F24F8FB4235429B4DE1399DBA533C78 = 8
        item_data.ItemDescription_32_0A978AFB4AB4B316342DD6A72ACDD4E1 = item_description
        item_data.Item_DisplayName_89_41C0C54E4A55598869C84CA3B5B5DECA = display_name
        item_data.Item_Icon_95_4D742A7E46F761161F9173969C69F468 = icon
        item_data.Consumable_MaxStackAmount_76_2DD073774D235ED7EE5C8F99817D7FFA = 1
        item_data.Pictos_Data_103_EE44D66B4E4F16A7FD44FF9F25777CF4 = nil
        item_data.Pictos_ItemStats_91_229F4A00415AB214191377B73987FF7B = nil
        item_data.HideInInventory_105_28F500C94EA8D5C6632F7E8E4A85586E = true
        item_data.HideInLootPopup_107_333FB0CB4314A0D9E40A7F8480A5686A = true
   end
end

return ShopHooks
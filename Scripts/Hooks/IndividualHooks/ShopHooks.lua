---Battle-related hooks
---@class ShopHooks
local ShopHooks = {}


---comment
---@param datatable UDataTable
---@param shop_data ShopData
---@param state table
local function AddItemRowsInDataTable(datatable, shop_data, is_extra, state)
    local base_struct = {
        ItemRowName_18_22FD2F5E42C1473FBA6AB9BF09E4890C  = FName("Consumable_LuminaPoint"),
        PriceOverride_6_7DE9A0224D826DBF8CF033AD6077A4EE = 666,
        LevelOverride_8_A53457704B4D0037ECA806A29C727EF4 = -1,
        Quantity_10_A62DFEDB41EF5DA12CE979AB3F742758     = 1,
    } ---@type FS_MerchantItemData

    local kind = is_extra and MerchantLocations.EXTRA or MerchantLocations.ITEM
    local number_to_add = is_extra and Options.values.extra_location_per_shop
                                    or Options.values.location_per_shop

    for i = 1, number_to_add, 1 do
        local name = MerchantLocations.Build(shop_data, kind, i)
        local scouted_location = Storage:Get("merchant_scouted")[name]
        if scouted_location == nil then
            Logger:warn("Shop location not scouted, skipping: " .. name)
            goto scout_found
        end

        if scouted_location.found then
            goto scout_found
        end

        local rows = state[datatable:GetFName():ToString()]
        if rows == nil then
            Logger:warn("No row list for datatable: " .. datatable:GetFName():ToString())
            goto scout_found
        end

        datatable:AddRow(name, base_struct)
        table.insert(rows, { ["name"] = name, ["classification"] = scouted_location.classification })

        ::scout_found::
    end
end

---One in ten thousand
---@param scouted_location table
---@return string
local function BuildItemDescription(scouted_location)
    if math.random(10000) == 1 then
        return "A fucking item for a fucking player probably for yezzdia then"
    end

    return scouted_location.item_name .. " for " .. scouted_location.player_name
end

---Register all battle hooks
---@param hookManager HookManager
function ShopHooks:Register(hookManager)
    ---@class ShopHookState
    local state = {
        rows_by_datatable = {},
        last_shop_visited = nil
    }

    -- Removing "Owned: x" in the row
    hookManager:Register(
        "/Game/UI/Widgets/InGame_Menu/Merchant/WBP_Merchant_Item_Row.WBP_Merchant_Item_Row_C:IsMerchantItemBetterThanOwnedItem",
        self:RemoveShopOwnedBox(),
        "Shop - Modify Shop row"
    )

    -- Changing the row image and name
    hookManager:Register(
        "/Game/Gameplay/Inventory/Merchant/BP_MerchantComponent.BP_MerchantComponent_C:GetItemFromName",
        self:ChangeShopRowData(state),
        "Shop - Modify Shop row"
    )

    -- Changing the right description
    hookManager:Register(
        "/Game/Gameplay/DialogueSystem/BP_DialogueSystemComponent.BP_DialogueSystemComponent_C:ActivateDialogue",
        self:ModifyDatatable(state),
        "Shop - Modify Datatable"
    )

    -- Changing the datatable for retrieving item informations
    hookManager:Register(
        "/Game/Gameplay/Inventory/Merchant/BP_MerchantComponent.BP_MerchantComponent_C:ComputeItemToSell",
        self:ChangeItemInformation(),
        "Shop - Modify Shop row"
    )

    Logger:info("Shop hooks registered")
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

---@param state ShopHookState
function ShopHooks:ChangeShopRowData(state)
    return function (ctx, ItemName, ItemStaticData)
        local item_data = ItemStaticData:get() ---@type FS_jRPG_Item_StaticData
        local merchant = ctx:get() ---@cast merchant UBP_MerchantComponent_C

        local datatable_name = merchant.Items:GetFName():ToString()
        local data_merchant = state.rows_by_datatable[datatable_name]
        if data_merchant == nil or #data_merchant == 0 then
            Logger:warn("No AP row queued for datatable: " .. datatable_name)
            return
        end

        local data = table.remove(data_merchant, 1)

        local icon = ClientBP:GetAPIcon(2)
        local display_name     = FText("An item")

        if Options:IsEnabled("show_shop_items") then
            display_name     = FText(data["name"])
            icon             = ClientBP:GetAPIcon(data["classification"])
        end
        
        item_data.Item_Icon_95_4D742A7E46F761161F9173969C69F468 = icon
        item_data.Item_DisplayName_89_41C0C54E4A55598869C84CA3B5B5DECA = display_name

        item_data.HideInInventory_105_28F500C94EA8D5C6632F7E8E4A85586E = true
        item_data.HideInLootPopup_107_333FB0CB4314A0D9E40A7F8480A5686A = true
        table.insert(data_merchant, data)
   end
end

---
---@param state ShopHookState
function ShopHooks:ModifyDatatable(state)
    return function (ctx, ...)

        local shop_data = Data.shops
        if shop_data == nil then 
            Logger:warn("shop data nil in ShopHookds:ModifyDatatable")
            return 
        end
        
        local level_asset_name = ClientBP:GetLevelName()
        local shop_datatable_in_level = Regions.DATATABLES_BY_LEVEL_ASSET[level_asset_name] or {}
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
            if datatable == nil or not datatable:IsValid() then 
                Logger:warn("Datatable is nil or not valid: " .. datatable_location)
                goto next_shop_data
            end

            if state.last_shop_visited ~= shop.name then
                state.last_shop_visited = shop.name
                local _, _, dt_name  = string.find(shop.datatable, ".*%.(.*)", 1, false)
                if dt_name == nil then 
                    Logger:warn("Can't change data table, dt_name is nil: " .. shop.datatable)
                    goto next_shop_data
                end

                state.rows_by_datatable[dt_name] = {}
            end

            datatable:EmptyTable()
            AddItemRowsInDataTable(datatable, shop, false, state.rows_by_datatable)

            if shop.has_fight then
                AddItemRowsInDataTable(datatable, shop, true, state.rows_by_datatable)
            end

            ::next_shop_data::
        end
   end
end

function ShopHooks:ChangeItemInformation()
    return function (ctx, ItemsDataTable, ItemRowName, MerchantItemSellData)
        local a = MerchantItemSellData:get() ---@type FS_MerchantItemSellData
        local location_name = ItemRowName:get():ToString()

        -- Find the shop name based on the locations name
        local scouted_location = Storage:Get("merchant_scouted")[location_name]
        if scouted_location == nil then
            Logger:warn("Shop location not scouted: " .. location_name)
            return
        end

        local parts = MerchantLocations.Parse(location_name)
        if parts == nil then
            Logger:warn("Not a merchant item location: " .. location_name)
            return
        end

        local item_id = parts.index
        local extra = parts.kind == MerchantLocations.EXTRA

        -- Find the shop data based on the shops name
        local found = Storage:IsLocationInMerchantFound(location_name)
        local shop_data = Data:FindShop(parts.shop)
        if shop_data == nil then 
            Logger:warn("Unknown shop in location: " .. location_name)
            return 
        end

        local has_item = not extra
        if extra then
            local internal_name = Data:FindInternalNameItemFromName(shop_data.unlock_item)
            has_item = internal_name ~= nil and Inventory:HasItem(internal_name)
        end

        local price = Archipelago:GetShopPrice(shop_data.name, extra, item_id)
        if price == nil then
            Logger:warn("No price for " .. location_name .. ", leaving the row untouched")
            return
        end

        local item_description = FText("An item")
        local display_name = FText("An item")
        local icon = ClientBP:GetAPIcon(2)

        if Options:IsEnabled("show_shop_items") then
            item_description = FText(BuildItemDescription(scouted_location))
            display_name     = FText(location_name)
            icon             = ClientBP:GetAPIcon(scouted_location.classification)
        end

        local already_hinted = Storage:IsShopItemAlreadyHinted(location_name)
        if not already_hinted then
            if Options:IsEnabled("create_hint") and not extra then
                Archipelago:ScoutLocation(location_name, true)
                Storage:HintMerchant(location_name, true)
            end

            if Options:IsEnabled("create_hint_extra") and extra then
                Archipelago:ScoutLocation(location_name, true)
                Storage:HintMerchant(location_name, true)
            end
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
        if icon ~= nil then
            item_data.Item_Icon_95_4D742A7E46F761161F9173969C69F468 = icon
        end
        item_data.Consumable_MaxStackAmount_76_2DD073774D235ED7EE5C8F99817D7FFA = 1
        item_data.Pictos_Data_103_EE44D66B4E4F16A7FD44FF9F25777CF4 = nil
        item_data.Pictos_ItemStats_91_229F4A00415AB214191377B73987FF7B = nil
        item_data.HideInInventory_105_28F500C94EA8D5C6632F7E8E4A85586E = true
        item_data.HideInLootPopup_107_333FB0CB4314A0D9E40A7F8480A5686A = true
   end
end

return ShopHooks
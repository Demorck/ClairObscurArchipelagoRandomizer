---Merchant location names
---The only place where the "Merchant (<region>): <shop> - <kind> <n>" format is written
---@class MerchantLocations
local MerchantLocations = {}

MerchantLocations.ITEM  = "Item"
MerchantLocations.EXTRA = "Extra Item"
MerchantLocations.FIGHT = "Fight"

---@param shop ShopData
---@param kind string ITEM, EXTRA or FIGHT
---@param index integer|nil rank of the item (1 to 8), nil for a fight
---@return string
function MerchantLocations.Build(shop, kind, index)
    local name = ("Merchant (%s): %s - %s"):format(shop.region, shop.name, kind)

    if index == nil then
        return name
    end

    return name .. " " .. tostring(index)
end

---Read the "Merchant (<region>): <shop>" part of any merchant string, location or unlock item
---@param name string
---@return { region: string, shop: string }|nil
function MerchantLocations.ParseShop(name)
    local head = name:match("^(.*) %- .+$")
    if head == nil then return nil end

    local region, shop = head:match("^Merchant %((.+)%): (.+)$")
    if region == nil then return nil end

    return { region = region, shop = shop }
end

---@class MerchantLocationParts
---@field region string
---@field shop string
---@field kind string
---@field index integer|nil

---@param location_name string
---@return MerchantLocationParts|nil parts nil when the name is not a merchant location
function MerchantLocations.Parse(location_name)
    local owner = MerchantLocations.ParseShop(location_name)
    if owner == nil then return nil end

    local tail = location_name:match("^.* %- (.+)$")

    if tail == MerchantLocations.FIGHT then
        return { region = owner.region, shop = owner.shop, kind = MerchantLocations.FIGHT }
    end

    local kind, index = tail:match("^(.+) (%d+)$")
    if kind ~= MerchantLocations.ITEM and kind ~= MerchantLocations.EXTRA then
        return nil
    end

    return { region = owner.region, shop = owner.shop, kind = kind, index = tonumber(index) }
end

return MerchantLocations
local Runner = require("runner")
local ML = require("Archipelago.MerchantLocations")

local test, check, equal = Runner.test, Runner.check, Runner.equal

local function ReadJson(path)
    local data = JSON.read_file(path)
    check(data ~= nil, "cannot read " .. path)
    return data
end

test("build and parse agree on every shop", function()
    local cases = {
        { kind = ML.ITEM,  index = 1 },
        { kind = ML.ITEM,  index = 12 },
        { kind = ML.EXTRA, index = 3 },
        { kind = ML.FIGHT, index = nil },
    }

    for _, shop in ipairs(ReadJson("data/shops.json")) do
        for _, case in ipairs(cases) do
            local name = ML.Build(shop, case.kind, case.index)
            local parts = ML.Parse(name)

            check(parts ~= nil, ("cannot parse back %q"):format(name))
            equal(parts.region, shop.region, ("wrong region in %q"):format(name))
            equal(parts.shop, shop.name, ("wrong shop in %q"):format(name))
            equal(parts.kind, case.kind, ("wrong kind in %q"):format(name))
            equal(parts.index, case.index, ("wrong index in %q"):format(name))
        end
    end
end)

test("a name that is not a merchant item location is rejected", function()
    check(ML.Parse("Chest_AncientSanctuary_1") == nil, "a chest was parsed as a merchant location")
    check(ML.Parse("Merchant (Sirene): Klaudiso - Banana 3") == nil, "an unknown kind was accepted")
    check(ML.Parse("Merchant (Sirene): Klaudiso - Item") == nil, "a missing index was accepted")
end)

test("every fight shop has an unlock item that exists", function()
    local names = {}
    for _, item in ipairs(ReadJson("data/items.json")) do names[item.name] = true end

    for _, shop in ipairs(ReadJson("data/shops.json")) do
        if shop.has_fight then
            check(shop.unlock_item ~= nil, ("shop %q has a fight but no unlock item"):format(shop.name))
            check(names[shop.unlock_item],
                ("shop %q needs %q, absent from items.json"):format(shop.name, shop.unlock_item))
        end
    end
end)

test("an unlock item names the shop it unlocks", function()
    for _, shop in ipairs(ReadJson("data/shops.json")) do
        if shop.has_fight and shop.unlock_item ~= nil then
            local owner = ML.ParseShop(shop.unlock_item)

            check(owner ~= nil, ("unlock item %q is not in the merchant format"):format(shop.unlock_item))
            equal(owner.region, shop.region, ("unlock item of %q names another region"):format(shop.name))
            equal(owner.shop, shop.name, ("unlock item of %q names another shop"):format(shop.name))
        end
    end
end)
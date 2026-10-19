local Runner = require("runner")
local Archipelago = require("Scripts.Archipelago")

local test, check, equal = Runner.test, Runner.check, Runner.equal


test("a price missing from the slot data is reported, not crashed on", function()
    Archipelago.shop_data = {
        ["Klaudiso"] = { prices = { 100, 200 }, extra_prices = { 500 } },
    }

    equal(Archipelago:GetShopPrice("Klaudiso", false, 2), 200, "wrong price")
    equal(Archipelago:GetShopPrice("Klaudiso", true, 1), 500, "wrong extra price")
    equal(Archipelago:GetShopPrice("Klaudiso", false, 9), nil, "an out of range index returned something")
    equal(Archipelago:GetShopPrice("Inconnu", false, 1), nil, "an unknown shop returned something")
end)
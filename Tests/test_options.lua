local Runner = require("runner")
local Options = require("Archipelago.Options")

local test, check, equal = Runner.test, Runner.check, Runner.equal

test("a missing option falls back to its default", function()
    Options:Load({})

    for key, spec in pairs(Options.SPEC) do
        local expected = spec.default
        if spec.toggle then
            expected = spec.default == true or spec.default == 1
        end

        equal(Options.values[key], expected, ("option %q did not fall back to its default"):format(key))
    end
end)

test("an unknown option value falls back to the default", function()
    Options:Load({ gear_scaling = 99 })

    equal(Options.values.gear_scaling, Options.SPEC.gear_scaling.default,
        "an out of range value was kept")
end)

test("slot data wins over the defaults", function()
    Options:Load({ goal = 3, location_per_shop = 5 })

    equal(Options.values.goal, 3, "goal was not read from the slot data")
    equal(Options.values.location_per_shop, 5, "location_per_shop was not read from the slot data")
end)

test("a toggle sent as a number becomes a boolean", function()
    Options:Load({ shopsanity = 1, show_shop_items = 0 })

    equal(Options.values.shopsanity, true, "1 was not read as enabled")
    equal(Options.values.show_shop_items, false, "0 was not read as disabled")
    check(Options:IsEnabled("shopsanity"), "IsEnabled disagrees with the stored value")
    check(not Options:IsEnabled("show_shop_items"), "a disabled toggle read as enabled")
end)

test("a toggle sent as a boolean stays a boolean", function()
    Options:Load({ shopsanity = true, show_shop_items = false })

    check(Options:IsEnabled("shopsanity"), "true was not read as enabled")
    check(not Options:IsEnabled("show_shop_items"), "false was not read as disabled")
end)

test("every option the mod reads is declared", function()
    -- The list below mirrors the reads found in the code, keep it in sync when adding an option
    local read_by_the_mod = {
        "goal", "gear_scaling", "char_shuffle", "shuffle_free_aim", "gestral_shuffle",
        "shopsanity", "show_shop_items", "create_hint", "create_hint_extra",
        "location_per_shop", "extra_location_per_shop",
        "exclude_endgame_locations", "exclude_endless_tower",
        "chroma_pack_type", "min_chroma_pack", "max_chroma_pack",
    }

    for _, key in ipairs(read_by_the_mod) do
        check(Options.SPEC[key] ~= nil, ("option %q is read by the mod but not declared"):format(key))
    end
end)
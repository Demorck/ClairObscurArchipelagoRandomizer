local Runner = require("runner")
local Regions = require("Constants.RegionConstants")

local test, check, equal = Runner.test, Runner.check, Runner.equal

local function ReadJson(path)
    local data = JSON.read_file(path)
    check(data ~= nil, "cannot read " .. path)
    return data
end

-- Registry consistency

test("a level asset belongs to a single region", function()
    local seen = {}
    for _, region in ipairs(Regions.ENTRIES) do
        for asset in pairs(region.levels or {}) do
            equal(seen[asset], nil, ("level asset %q is claimed by %q and %q")
                :format(asset, seen[asset] or "", region.ap))
            seen[asset] = region.ap
        end
    end
end)

test("region names and aliases do not collide", function()
    local seen = {}
    for _, region in ipairs(Regions.ENTRIES) do
        for _, key in ipairs({ region.ap, table.unpack(region.aliases or {}) }) do
            equal(seen[key], nil, ("region name %q is used by two entries"):format(key))
            seen[key] = true
        end
    end
end)

test("the canonical asset is one of the region levels", function()
    for _, region in ipairs(Regions.ENTRIES) do
        if region.levels ~= nil then
            check(region.asset ~= nil, ("region %q has levels but no canonical asset"):format(region.ap))
            check(region.levels[region.asset] ~= nil,
                ("region %q declares asset %q, which is not one of its levels")
                    :format(region.ap, region.asset))
        end
    end
end)

test("a multi level region names its canonical asset explicitly", function()
    for _, region in ipairs(Regions.ENTRIES) do
        local count = 0
        for _ in pairs(region.levels or {}) do count = count + 1 end

        if count > 1 then
            -- Derivation picks an arbitrary key when several levels exist, so it must be written down
            local written = false
            for _, line in ipairs({ region.asset }) do written = line ~= nil end
            check(written, ("region %q owns %d levels and must declare `asset`")
                :format(region.ap, count))
        end
    end
end)

-- Registry against the apworld data

test("every Area item matches a region ticket", function()
    for _, item in ipairs(ReadJson("data/items.json")) do
        if item.type == "Area" then
            local region = Regions.BY_NAME[item.internal_name]
            check(region ~= nil,
                ("no region owns the ticket %q (item %q)"):format(item.internal_name, item.name))
            check(region.area, ("region %q is not flagged as an area"):format(region.ap))
        end
    end
end)

test("every region ticket is granted by an Area item", function()
    local granted = {}
    for _, item in ipairs(ReadJson("data/items.json")) do
        if item.type == "Area" then granted[item.internal_name] = true end
    end

    for name, region in pairs(Regions.BY_NAME) do
        if region.area then
            check(granted[name], ("ticket %q is never granted by any Area item"):format(name))
        end
    end
end)

test("every shop region is known", function()
    for _, shop in ipairs(ReadJson("data/shops.json")) do
        check(Regions.BY_AP_NAME[shop.region] ~= nil,
            ("shop %q sits in unknown region %q"):format(shop.name, shop.region))
    end
end)

test("a merchant datatable belongs to a single level", function()
    local seen = {}
    for _, region in ipairs(Regions.ENTRIES) do
        for asset, datatables in pairs(region.levels or {}) do
            for _, datatable in ipairs(datatables) do
                equal(seen[datatable], nil, ("datatable %q is claimed by %q and %q")
                    :format(datatable, seen[datatable] or "", asset))
                seen[datatable] = asset
            end
        end
    end
end)

test("every shop datatable is reachable from some level", function()
    local declared = {}
    for _, region in ipairs(Regions.ENTRIES) do
        for _, datatables in pairs(region.levels or {}) do
            for _, datatable in ipairs(datatables) do declared[datatable] = true end
        end
    end

    for _, shop in ipairs(ReadJson("data/shops.json")) do
        check(declared[shop.datatable],
            ("shop %q uses datatable %q, which no level declares"):format(shop.name, shop.datatable))
    end
end)

test("two shops never share a datatable", function()
    local seen = {}
    for _, shop in ipairs(ReadJson("data/shops.json")) do
        equal(seen[shop.datatable], nil, ("datatable %q is shared by %q and %q")
            :format(shop.datatable, seen[shop.datatable] or "", shop.name))
        seen[shop.datatable] = shop.name
    end
end)
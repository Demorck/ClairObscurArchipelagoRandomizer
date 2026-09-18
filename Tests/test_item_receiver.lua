local Runner = require("runner")
local ItemReceiver = require("Archipelago.Effects.ItemReceiver")

local test, check, equal = Runner.test, Runner.check, Runner.equal

local function ReadJson(path)
    local data = JSON.read_file(path)
    check(data ~= nil, "cannot read " .. path)
    return data
end


test("every item type in the data is handled", function()
    for _, item in ipairs(ReadJson("data/items.json")) do
        check(ItemReceiver.HANDLERS_BY_TYPE[item.type] ~= nil
              or ItemReceiver.INVENTORY_TYPES[item.type],
            ("item type %q (item %q) is not handled"):format(item.type, item.name))
    end
end)
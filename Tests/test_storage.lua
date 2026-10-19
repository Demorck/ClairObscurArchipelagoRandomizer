local Runner = require("runner")
local Storage = require("Storage.index")

local test, check, equal = Runner.test, Runner.check, Runner.equal

local written = nil
Archipelago = { GetPlayer = function() return { seed = "seed", slot = "slot" } end }
Storage.GetFilePath = function() return os.getenv("TEMP") .. "/coe33ap_test_storage.json" end

test("defaults come from the schema", function()
    Storage:Initialize()

    equal(Storage:Get("lastReceivedItemIndex"), -1, "wrong default")
    equal(Storage:Get("progressive_rock"), 0, "wrong default")
    equal(Storage:Get("characters").Frey, false, "characters default is not built")
end)

test("a value outside its validator is refused", function()
    Storage:Initialize()

    check(not Storage:Set("progressive_rock", 99), "an out of range value was accepted")
    equal(Storage:Get("progressive_rock"), 0, "the refused value was stored anyway")
end)

test("an unknown key is refused", function()
    check(not Storage:Set("not_a_field", 1), "an unknown key was accepted")
end)

test("AddInTable appends without replacing the table", function()
    Storage:Initialize()
    local before = Storage:Get("locations_checked")

    Storage:AddInTable("locations_checked", 42)

    equal(Storage:Get("locations_checked")[1], 42, "the value was not appended")
    check(Storage:Get("locations_checked") == before, "the table was replaced instead of appended to")
end)

test("the file is written once for several updates", function()
    Storage:Initialize()
    os.remove(Storage:GetFilePath())

    Storage:Update("first")
    Storage:Update("second")

    check(Storage:Flush(), "the first flush did not write")
    check(not Storage:Flush(), "a second flush wrote again with nothing to save")

    local file = io.open(Storage:GetFilePath(), "r")
    check(file ~= nil, "no file was written")
    file:close()
    os.remove(Storage:GetFilePath())
end)
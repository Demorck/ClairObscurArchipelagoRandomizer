local Runner = require("runner")
local RuntimeState = require("RuntimeState")

local test, check, equal = Runner.test, Runner.check, Runner.equal

test("a call is marked while it runs and cleared afterwards", function()
    local marked_inside = false

    RuntimeState:AsModCall("AddItemToInventory", function()
        marked_inside = RuntimeState:IsModCall("AddItemToInventory")
    end)

    check(marked_inside, "the call was not marked while running")
    check(not RuntimeState:IsModCall("AddItemToInventory"), "the mark outlived the call")
end)

test("the mark is cleared even when the call raises", function()
    RuntimeState:AsModCall("Raising", function()
        error("boom")
    end)

    check(not RuntimeState:IsModCall("Raising"), "a failing call left its mark behind")
end)

test("a call does not mark another function name", function()
    RuntimeState:AsModCall("First", function()
        check(not RuntimeState:IsModCall("Second"), "an unrelated name was marked")
    end)
end)

test("nested calls of the same name stay marked until the outer one returns", function()
    local marked_after_inner = false

    RuntimeState:AsModCall("UnlockWorldMapCapacities", function()
        RuntimeState:AsModCall("UnlockWorldMapCapacities", function() end)
        marked_after_inner = RuntimeState:IsModCall("UnlockWorldMapCapacities")
    end)

    check(marked_after_inner, "the inner call cleared the mark of the outer one")
    check(not RuntimeState:IsModCall("UnlockWorldMapCapacities"), "the mark outlived both calls")
end)

test("named id writes are queued and cleared", function()
    RuntimeState:QueueNamedIdWrite("NID_Test", true)
    equal(RuntimeState.named_ids_to_write["NID_Test"], true, "the flag was not queued")

    RuntimeState:ClearNamedIdWrite("NID_Test")
    equal(RuntimeState.named_ids_to_write["NID_Test"], nil, "the flag was not cleared")
end)

test("a flag queued as false is still a queued flag", function()
    RuntimeState:QueueNamedIdWrite("NID_False", false)
    equal(RuntimeState.named_ids_to_write["NID_False"], false, "false was treated as absent")
    RuntimeState:ClearNamedIdWrite("NID_False")
end)
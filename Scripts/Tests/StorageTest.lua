---Test suite for Storage refactoring (maybe should do more tests lmao)
---Verifies schema-based validation, getters/setters, and backward compatibility
local function runTests()
    print("====== Storage Refactoring Tests ======\n")

    local testsPassed = 0
    local testsFailed = 0

    local function assert_equal(actual, expected, testName)
        if actual == expected then
            print(testName .. " passed")
            testsPassed = testsPassed + 1
        else
            print(testName .. " cringe")
            print("\tExpected: " .. tostring(expected))
            print("\tGot: " .. tostring(actual))
            testsFailed = testsFailed + 1
        end
    end

    local function assert_true(condition, testName)
        assert_equal(condition, true, testName)
    end

    local function assert_false(condition, testName)
        assert_equal(condition, false, testName)
    end

    print("\n--- Test 1: Initialization ---")
    Storage:Initialize()
    assert_equal(Storage:Get("lastReceivedItemIndex"), -1, "lastReceivedItemIndex initialized to -1")
    assert_equal(Storage:Get("lastSavedItemIndex"), -1, "lastSavedItemIndex initialized to -1")
    assert_equal(Storage:Get("pictosIndex"), -1, "pictosIndex initialized to -1")
    assert_equal(Storage:Get("weaponsIndex"), -1, "weaponsIndex initialized to -1")
    assert_false(Storage:Get("initialized_after_lumiere"), "initialized_after_lumiere initialized to false")
    assert_false(Storage:Get("free_aim_unlocked"), "free_aim_unlocked initialized to false")
    assert_equal(Storage:Get("dive_items"), 0, "dive_items initialized to 0")
    assert_equal(Storage:Get("gestral_found"), 0, "gestral_found initialized to 0")
    assert_equal(Storage:Get("currentLocation"), "None", "currentLocation initialized to 'None'")


    print("\n--- Test 2: Tickets Table Initialization ---")
    local tickets = Storage:Get("tickets")
    assert_false(tickets.GoblusLair, "tickets.GoblusLair initialized to false")
    assert_false(tickets.Lumiere, "tickets.Lumiere initialized to false")
    assert_false(tickets.Visages, "tickets.Visages initialized to false")


    print("\n--- Test 3: Type Validation ---")
    local success = Storage:Set("lastReceivedItemIndex", "invalid")
    assert_false(success, "Setting string to number field should fail")

    success = Storage:Set("lastReceivedItemIndex", 69)
    assert_true(success, "Setting number to number field should succeed")
    assert_equal(Storage:Get("lastReceivedItemIndex"), 69, "Value should be updated")

    success = Storage:Set("initialized_after_lumiere", "not a boolean")
    assert_false(success, "Setting string to boolean field should fail")

    success = Storage:Set("initialized_after_lumiere", true)
    assert_true(success, "Setting boolean to boolean field should succeed")
    assert_true(Storage:Get("initialized_after_lumiere"), "Boolean value should be updated")

    print("\n--- Test 4: Custom Validators ---")
    success = Storage:Set("lastReceivedItemIndex", -5)
    assert_false(success, "Setting negative value (< -1) should fail validation")

    success = Storage:Set("gestral_found", -1)
    assert_false(success, "Setting negative gestral_found should fail validation")

    success = Storage:Set("gestral_found", 10)
    assert_true(success, "Setting positive gestral_found should succeed")
    assert_equal(Storage:Get("gestral_found"), 10, "gestral_found should be updated")

    print("\n--- Test 5: Backward Compatibility ---")
    Storage.pictosIndex = 15
    assert_equal(Storage.pictosIndex, 15, "Direct assignment via metatable should work")
    assert_equal(Storage:Get("pictosIndex"), 15, "Get method should return same value")

    Storage.free_aim_unlocked = true
    assert_true(Storage.free_aim_unlocked, "Direct boolean assignment should work")
    assert_true(Storage:Get("free_aim_unlocked"), "Get method should return same value")

    print("\n--- Test 6: Table Fields ---")
    local newTickets = {
        GoblusLair = true,
        Lumiere = true,
        Visages = false,
    }
    success = Storage:Set("tickets", newTickets)
    assert_true(success, "Setting table field should succeed")

    local retrievedTickets = Storage:Get("tickets")
    assert_true(retrievedTickets.GoblusLair, "tickets.GoblusLair should be true")
    assert_true(retrievedTickets.Lumiere, "tickets.Lumiere should be true")

    print("\n--- Test 7: Characters Table ---")
    local characters = {"Frey", "Maelle", "Sophie"}
    success = Storage:Set("characters", characters)
    assert_true(success, "Setting characters array should succeed")

    local retrievedChars = Storage:Get("characters")
    assert_equal(#retrievedChars, 3, "Characters array should have 3 elements")
    assert_equal(retrievedChars[1], "Frey", "First character should be Frey")

    print("\n--- Test 8: Unknown Field Handling ---")
    local value = Storage:Get("nonexistent_field")
    assert_equal(value, nil, "Getting unknown field should return nil")

    success = Storage:Set("nonexistent_field", "value")
    assert_false(success, "Setting unknown field should fail")

    print("\n--- Test 9: Schema JSON Key Mapping ---")
    local schema = Storage.schema
    assert_equal(schema:GetJsonKey("lastReceivedItemIndex"), "last_received", "JSON key mapping for lastReceivedItemIndex")
    assert_equal(schema:GetJsonKey("initialized_after_lumiere"), "lumiere_done", "JSON key mapping for initialized_after_lumiere")
    assert_equal(schema:GetJsonKey("tickets"), "tickets", "JSON key mapping for tickets (no custom key)")

    print("\n--- Test 10: GetAll Method ---")
    local allData = Storage:GetAll()
    assert_equal(type(allData), "table", "GetAll should return a table")
    assert_equal(allData.pictosIndex, 15, "GetAll should contain pictosIndex")
    assert_true(allData.free_aim_unlocked, "GetAll should contain free_aim_unlocked")

    -- Summary
    print("\n=== Test Summary ===")
    print("Tests passed: " .. testsPassed)
    print("Tests failed: " .. testsFailed)

    if testsFailed == 0 then
        print("\nAll tests passed!")
    else
        print("\nSome tests failed but the code is perfect so don't worry.")
    end
end

runTests()

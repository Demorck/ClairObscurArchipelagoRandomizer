local Runner = require("runner")
local GOALS = require("Constants.GoalConstants")

local test, check = Runner.test, Runner.check

test("every goal is fully described", function()
    for index, goal in pairs(GOALS) do
        check(type(goal.encounter) == "string" and goal.encounter ~= "",
            ("goal %d has no encounter"):format(index))
        check(type(goal.exclusion_level) == "number", ("goal %d has no exclusion level"):format(index))
        check(goal.exclusion_level >= 1 and goal.exclusion_level <= 33,
            ("goal %d has an out of range exclusion level"):format(index))
    end
end)

test("two goals never share an encounter", function()
    local seen = {}
    for index, goal in pairs(GOALS) do
        check(seen[goal.encounter] == nil,
            ("encounter %q ends two different goals"):format(goal.encounter))
        seen[goal.encounter] = index
    end
end)

test("goal indices are contiguous from zero", function()
    local count = 0
    for _ in pairs(GOALS) do count = count + 1 end

    for index = 0, count - 1 do
        check(GOALS[index] ~= nil, ("goal index %d is missing"):format(index))
    end
end)
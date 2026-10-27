---Goal tracking
---Every goal boss is an AP location so the server already knows what is done
---here, we only read back what AP told us
---@class Goals
local Goals = {}

---The goals the slot data asked for
---@return table<string, GoalEntry>
function Goals:Selected()
    local selected = {}

    for _, key in ipairs(Options.values.goal) do
        local entry = CONSTANTS.GOAL[key]
        if entry == nil then
            Logger:error("Unknown goal in slot data: " .. tostring(key))
        else
            selected[key] = entry
        end
    end

    return selected
end

---@param encounter_name string
---@return boolean
function Goals:IsGoalEncounter(encounter_name)
    for _, entry in pairs(self:Selected()) do
        if entry.encounter == encounter_name then
            return true
        end
    end

    return false
end

---How many goals are done out of how many
---@return integer done
---@return integer total
function Goals:Progress()
    local done, total = 0, 0

    for _, entry in pairs(self:Selected()) do
        total = total + 1
        if Archipelago:IsLocationChecked(entry.encounter) then
            done = done + 1
        end
    end

    return done, total
end

---True when the run is over, following goal_requirement
---@return boolean
function Goals:IsComplete()
    local done, total = self:Progress()
    if total == 0 then
        return false
    end

    if Options.values.goal_requirement == Options.GOAL_REQUIREMENT.ANY then
        return done >= 1
    end

    return done == total
end

return Goals
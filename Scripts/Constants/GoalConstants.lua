---Goal definitions: which encounter ends the run and how far the world extends
---@class GoalEntry
---@field encounter string encounter name id
---@field exclusion_level integer regions above this level are excluded when the option asks for it
---@field name string readable name

---@type table<integer, GoalEntry>
local GOALS = {
    [0] = { encounter = "L_Boss_Paintress_P1", exclusion_level = 15, name = "The Paintress" },
    [1] = { encounter = "L_Boss_Curator_P1",   exclusion_level = 16, name = "The Curator" },
    [2] = { encounter = "TowerBattle_33",      exclusion_level = 33, name = "Endless Tower" },
    [3] = { encounter = "Boss_SimonPhase2*1",  exclusion_level = 33, name = "Simon" },
    [4] = { encounter = "CFH_Boss_Clea",       exclusion_level = 28, name = "Clea" },
}

return GOALS
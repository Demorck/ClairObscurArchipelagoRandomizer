---Goal definitions: which encounter ends the run and how far the world extends
---@class GoalEntry
---@field encounter string encounter name id
---@field name string readable name

---@type table<string, GoalEntry>
local GOALS = {
    paintress    = { encounter = "L_Boss_Paintress_P1", name = "The Paintress" },
    curator      = { encounter = "L_Boss_Curator_P1",   name = "The Curator" },
    painted_love = { encounter = "TowerBattle_33",      name = "Endless Tower" },
    simon        = { encounter = "Boss_SimonPhase2*1",  name = "Simon" },
    clea         = { encounter = "CFH_Boss_Clea",       name = "Clea" },
    osquio       = { encounter = "VD_Osquio*1",         name = "Osquio" }
}

return GOALS
---Capacity Handler
---Handles exploration capacity items
local ArchipelagoState = require("Archipelago.ArchipelagoState")

---@class CapacityHandler
local CapacityHandler = {}

---Handle exploration capacity item
---@param item_data ItemData
---@return boolean success
function CapacityHandler:Handle(item_data)
    if item_data.name == "Progressive Rock" then
        Capacities:UnlockNextWorldMapAbility()
        Storage:Increment("progressive_rock")
        Storage:Update("CapacityHandler:Handle - Progressive Rock")
    elseif item_data.name == "Paint Break" then
        Capacities:SetDestroyPaintedRock(true)
        Storage:Set("paint_break_unlocked", true)
        Storage:Update("CapacityHandler:Handle - Paint Break")
    elseif item_data.name == "Free Aim" then
        Capacities:SetExplorationCapacity("FreeAim", true)
        Storage:Set("free_aim_unlocked", true)
        Storage:Update("CapacityHandler:Handle - Free Aim")
    end
    
    return true
end

return CapacityHandler

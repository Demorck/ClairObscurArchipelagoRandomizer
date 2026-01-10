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
    elseif item_data.name == "Paint Break" then
        Capacities:UnlockDestroyPaintedRock()
    elseif item_data.name == "Free Aim" then
        Capacities:UnlockExplorationCapacity("FreeAim")
        Storage.free_aim_unlocked = true
        Storage:Update("CapacityHandler:Handle - Free Aim")
    end
    
    return true
end

return CapacityHandler

---Trap Handler
---Handles trap items from Archipelago
local ArchipelagoState = require("Archipelago.ArchipelagoState")

---@class TrapHandler
local TrapHandler = {}

---Handle trap item
---@param item_data ItemData
---@return boolean success
function TrapHandler:Handle(item_data)
    Logger:info("Trap activated: " .. item_data.name)

    if item_data.name == "Feet Trap" then
        ClientBP:FeetTrap()
    end

    return true
end

return TrapHandler

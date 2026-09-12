---@class ScoutedLocationHandler
local ScoutedLocationHandler = {}

---Handle a batch of locations that has been checked
---This is the main entry point called by the EventDispatcher
---@param items NetworkItem[] Locations id
function ScoutedLocationHandler:Handle(items)
    if not items then return end


    for _, item in ipairs(items) do
        self:ProcessItem(item)
    end

    Storage:Update("ScoutedLocationHandler - Handle")
end

---Process a single location from the server (currently does nothing but can be useful if we can remove loot on floor)
---Valdiates the location, send it to the server and mark as sent.
---@param item NetworkItem
---@private
function ScoutedLocationHandler:ProcessItem(item)
    local player_name = ArchipelagoSystem:GetClient():GetPlayerNameFromID(item.player)
    local item_name = ArchipelagoSystem:GetClient():GetItemNameFromPlayerID(item.item, item.player)
    local player_info = ArchipelagoSystem:GetClient():GetPlayerInfo()
    local location_name = ArchipelagoSystem:GetClient():GetLocationName(item.location, player_info.game)

    Storage:AddScoutedMerchant(location_name, item_name, player_name, item.flags)
end

return ScoutedLocationHandler
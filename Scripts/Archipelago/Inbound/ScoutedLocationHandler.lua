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
    local client = Archipelago:GetClient()
    if client == nil then return end

    local player_name = client:GetPlayerNameFromID(item.player)
    local item_name = client:GetItemNameFromPlayerID(item.item, item.player)
    local player_info = client:GetPlayerInfo()
    local location_name = client:GetLocationName(item.location, player_info.game)

    Storage:AddScoutedMerchant(location_name, item_name, player_name, item.flags)
end

return ScoutedLocationHandler
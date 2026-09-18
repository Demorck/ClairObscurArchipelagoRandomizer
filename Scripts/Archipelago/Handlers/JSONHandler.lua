---@class JSONMessagePart
---@field text string | nil
---@field type string | nil
---@field color string | nil
---@field flags integer | nil
---@field player integer | nil

---@class JSONHandler
local JSONHandler = {}

---This is the main entry point called by the EventDispatcher
---@param json_data table<JSONMessagePart> JSONMessagePart
function JSONHandler:Handle(json_data)
    if not json_data then return end
    local client = Archipelago:GetClient()
    if client == nil then return end

    local string_build = ""
    for i, value in ipairs(json_data) do
        ---@cast value JSONMessagePart
        
        if value.type == nil then
            string_build = string_build .. (value.text or "")
        elseif value.type == "location_id" then
            local location_id = tonumber(value.text) or 0
            local player_id = tonumber(value.player) or 0
            local location_name = client:GetLocationNameFromPlayerID(location_id, player_id) or ''

            local styled_location = "<Location>" .. location_name .. "</>"
            string_build = string_build .. styled_location
        elseif value.type == "item_id" then
            local item_id = tonumber(value.text) or 0
            local player_id = tonumber(value.player) or 0
            local location_name = client:GetItemNameFromPlayerID(item_id, player_id) or ''
            -- flags are for item type (progressive, useful, nothing or trap)
            string_build = string_build .. location_name
        elseif value.type == "player_id" then
            local player_id = tonumber(value.text) or 0 
            string_build = string_build .. self:GetStyledPlayer(player_id)
        end
    end

    ClientBP:PushToLogger(string_build)
end

function JSONHandler:GetStyledPlayer(player_id)
    local client = Archipelago:GetClient()
    if client == nil then return end

    local player_alias = client:GetPlayerNameFromID(player_id)
    local current_player = client:GetPlayerInfo()

    local string_build = ""
    if current_player["slot"] == player_id then
        string_build = "<CurrentPlayer>" .. player_alias .. "</>"
    else
        string_build = player_alias or ""
    end

    return string_build
end

return JSONHandler
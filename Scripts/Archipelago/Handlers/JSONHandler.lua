---@class JSONHandlerDependencies
---@field logger Logger Logger instance for logging item reception events
---@field apClient APClient AP client for getting item names and player info

---@class JSONMessagePart
---@field text string | nil
---@field type string | nil
---@field color string | nil
---@field flags integer | nil
---@field player integer | nil

---@class JSONHandler
---@field logger Logger Logger instance for debugging and tracking
---@field apClient APClient Client for AP server communication
local JSONHandler = {}

---Create a new JSONHandler instance
---@param dependencies JSONHandlerDependencies Required dependencies
---@return JSONHandler handler New JSONHandler instance
function JSONHandler:New(dependencies)
    local instance = {
        logger = dependencies.logger,
        apClient = dependencies.apClient,
    }

    setmetatable(instance, { __index = JSONHandler })
    return instance
end


---This is the main entry point called by the EventDispatcher
---@param json_data table<JSONMessagePart> JSONMessagePart
function JSONHandler:Handle(json_data)
    if not json_data then return end

    local string_build = ""
    for i, value in ipairs(json_data) do
        ---@cast value JSONMessagePart
        
        if value.type == nil then
            string_build = string_build .. (value.text or "")
        elseif value.type == "location_id" then
            local location_id = tonumber(value.text) or 0
            local player_id = tonumber(value.player) or 0
            local location_name = self.apClient:GetLocationNameFromPlayerID(location_id, player_id) or ''

            local styled_location = "<Location>" .. location_name .. "</>"
            string_build = string_build .. styled_location
        elseif value.type == "item_id" then
            local item_id = tonumber(value.text) or 0
            local player_id = tonumber(value.player) or 0
            local location_name = self.apClient:GetItemNameFromPlayerID(item_id, player_id) or ''
            -- flags are for item type (progressive, useful, nothing or trap)
            string_build = string_build .. location_name
        elseif value.type == "player_id" then
            local player_id = tonumber(value.player) or 0
            string_build = string_build .. self:GetStyledPlayer(player_id)
        end
    end

    ClientBP:PushToLogger(string_build)
end

function JSONHandler:GetStyledPlayer(player_id)
    local player_alias = self.apClient:GetPlayerNameFromID(player_id)
    local current_player = self.apClient:GetPlayerInfo()

    local string_build = ""
    if current_player["slot"] == player_id then
        string_build = "<CurrentPlayer>" .. player_alias .. "</>"
    else
        string_build = player_alias or ""
    end

    return string_build
end

return JSONHandler


-- [00:08:24.0071787] [Lua] data 1: {
-- ["type"] = "player_id",
-- ["text"] = "1",
-- } 
-- [00:08:24.0073596] [Lua] data 2: {
-- ["text"] = " found their ",
-- } 
-- [00:08:24.0077681] [Lua] data 3: {
-- ["type"] = "item_id",
-- ["text"] = "330391",
-- ["flags"] = 1,
-- ["player"] = 1,
-- } 
-- [00:08:24.0079705] [Lua] data 4: {
-- ["text"] = " (",
-- } 
-- [00:08:24.0081403] [Lua] data 5: {
-- ["text"] = "333305",
-- ["type"] = "location_id",
-- ["player"] = 1,
-- } 
-- [00:08:24.0083011] [Lua] data 6: {
-- ["text"] = ")",
-- } 
-- [00:09:55.2920011] [Lua] -----------------------
-- [00:09:55.2924136] [Lua] All data: {
-- [1] = table,
-- } 
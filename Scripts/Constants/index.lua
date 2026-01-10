---@class Constants
---@field NID NID_Constants
---@field CONFIG Config_Constants
---@field QUEST Quests_Constants
local Constants = {}

Constants.NID = require "Constants.NIDConstants"
Constants.CONFIG = require "Constants.ConfigConstants"
Constants.QUEST = require "Constants.QuestConstants"

return Constants
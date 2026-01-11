---@class Constants
---@field NID NID_Constants
---@field CONFIG Config_Constants
---@field QUEST Quests_Constants
---@field BLUEPRINT Blueprint_Constants
---@field GAME Game_Constants
local Constants = {}

Constants.NID = require "Constants.NIDConstants"
Constants.CONFIG = require "Constants.ConfigConstants"
Constants.QUEST = require "Constants.QuestConstants"
Constants.BLUEPRINT = require "Constants.BlueprintConstants"
Constants.GAME = require "Constants.GameConstants"

return Constants
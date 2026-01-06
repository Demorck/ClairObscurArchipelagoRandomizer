---@class Gear_Scaling
---@field SPHERE_PLACEMENT  number
---@field ORDER_RECEIVED    number
---@field BALANCED_RANDOM   number
---@field FULL_RANDOM       number

---@class OPTIONS_Constants
---@field GEAR_SCALING Gear_Scaling

---@class Config_Constants
---@field MAX_LEVEL_GEAR number
---@field DEFAULT_MAX_LEVEL_GEAR number
---@field NUMBER_OF_PICTOS number
---@field NUMBER_OF_WEAPONS number
---@field OPTIONS OPTIONS_Constants
local CONFIG = {
    MAX_LEVEL_GEAR = 33,
    DEFAULT_MAX_LEVEL_GEAR = 33,
    NUMBER_OF_PICTOS = 190,
    NUMBER_OF_WEAPONS = 100,
    
    OPTIONS = {
        GEAR_SCALING = {
            SPHERE_PLACEMENT = 0,
            ORDER_RECEIVED   = 1,
            BALANCED_RANDOM  = 2,
            FULL_RANDOM      = 3
        }
    }
}

return CONFIG
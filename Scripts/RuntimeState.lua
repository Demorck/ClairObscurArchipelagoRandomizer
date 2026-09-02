--- Mutable runtime state, shared between the mod and its hooks
---@class RuntimeState
local RuntimeState = {
    --- Names of UE functions the mod is calling right now so hooks can know
    --- if it's a mod call or from the game (and so, to not have infinite call loop)
    ---@type string[]
    mods_calls = {},

    ---Persistent flags waiting to be written by the GetAllNamedIDs hook
    ---@type table<string, boolean>
    named_ids_to_write = {},

    ---@type boolean
    change_save_icon = false,
}

---Run a UE call while marking it as coming from the mod
---@param function_name string
---@param fn function
function RuntimeState:AsModCall(function_name, fn)
    table.insert(self.mods_calls, function_name)
    local ok, err = pcall(fn)
    Remove(self.mods_calls, function_name)

    if not ok then
        Logger:error("Mod call failed [" .. function_name .. "]: " .. tostring(err))
    end
end

---Returns true if the mod is calling the function `function_name`
---@param function_name string
---@return boolean
function RuntimeState:IsModCall(function_name)
    return Contains(self.mods_calls, function_name)
end

---Add the flag_name NID and it's value to the current list to write it into the NID states
---@param flag_name string
---@param value boolean
function RuntimeState:QueueNamedIdWrite(flag_name, value)
    self.named_ids_to_write[flag_name] = value
end

---Clear the dict.
---@param flag_name string
function RuntimeState:ClearNamedIdWrite(flag_name)
    self.named_ids_to_write[flag_name] = nil
end

return RuntimeState
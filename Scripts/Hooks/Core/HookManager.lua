---@class HookRegistration
---@field preID number Pre-hook ID from UE4SS
---@field postID number Post-hook ID from UE4SS
---@field description string Human-readable description
---@field functionPath string Full UE5 function path

---Central manager for COE33 hooks
---Handles registration, unregistration, and error handling
---@class HookManager
---@field logger Logger Logger instance
---@field registeredHooks table<string, HookRegistration> All registered hooks
local HookManager = {}


---Create new HookManager instance
---@param dependencies table
---@return HookManager
function HookManager:New(dependencies)
    local instance = {
        logger = dependencies.logger,
        registeredHooks = {}
    }

    setmetatable(instance, { __index = HookManager })
    return instance
end


---Register a hook with automatic error handling
---@param functionPath string Full UE5 function path
---@param callback function Function to call when hook triggers
---@param description string Human-readable description for debugging
---@return boolean success True if hook registered successfully
function HookManager:Register(functionPath, callback, description)
    if self.registeredHooks[functionPath] then
        self.logger:warn("Hook already registered: " .. functionPath)
        return false
    end

    local preID, postID = RegisterHook(functionPath, function(...)
        local success, error = pcall(callback, ...)
        if not success then
            self.logger:error(string.format(
                "Hook error [%s]: %s",
                description,
                tostring(error)
            ))
        end
    end)

    self.registeredHooks[functionPath] = {
        preID = preID,
        postID = postID,
        description = description,
        functionPath = functionPath,
    }

    self.logger:info("Registered hook: " .. description)
    return true
end


---Unregister a specific hook
---@param functionPath string Function path to unregister
---@return boolean success
function HookManager:Unregister(functionPath)
    local hook = self.registeredHooks[functionPath]
    if not hook then
        return false
    end

    UnregisterHook(hook.functionPath, hook.preID, hook.postID)
    self.registeredHooks[functionPath] = nil

    self.logger:info("Unregistered hook: " .. hook.description)
    return true
end

---Unregister all hooks
function HookManager:UnregisterAll()
    local count = 0
    for _, hook in pairs(self.registeredHooks) do
        UnregisterHook(hook.functionPath, hook.preID, hook.postID)
        count = count + 1
    end

    self.registeredHooks = {}
    self.logger:info("Unregistered " .. count .. " hooks")
end


return HookManager
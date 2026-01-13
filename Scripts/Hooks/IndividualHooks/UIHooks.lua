---UI related hooks 
---@class UIHooks
local UIHooks = {}

---Register all inventory hooks
---@param hookManager HookManager
---@param dependencies table
function UIHooks:Register(hookManager, dependencies)
    local archipelago = dependencies.archipelago
    local storage = dependencies.storage
    local logger = dependencies.logger

    hookManager:Register(
        "/Game/Gameplay/Audio/BP_AudioControlSystem.BP_AudioControlSystem_C:OnPauseMenuOpened",
        function (_)
            if not Storage.initialized_after_lumiere then
                return
            end

            local buttons = FindAllOf("WBP_BaseButton_C") ---@cast buttons UWBP_BaseButton_C[]
            for _, value in ipairs(buttons) do
                local name = value:GetFName():ToString()
                if name == "TeleportPlayerButton" then
                    value:SetVisibility(0)
                    local content = value.ButtonContent
                    if content ~= nil and content:IsValid() then
                        local overlay = content:GetContent() ---@cast overlay UOverlay
                        if overlay ~= nil and overlay:IsValid() then
                        local wrapping_text = overlay:GetChildAt(0) ---@cast wrapping_text UWBP_WrappingText_C
                            if wrapping_text ~= nil and wrapping_text:IsValid() then
                                wrapping_text.ContentText = FText("I'M STUCK ! (stepbro)")
                                wrapping_text:UpdateText()
                            end
                        end
                    end
                end
            end
        end,
        "UI - Adding stuck button"
    )

    logger:info("UI hooks registered")
end

return UIHooks
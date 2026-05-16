---Capacities-related hooks
---@class OtherHooks
local OtherHooks = {}

---Register all character hooks
---@param hookManager HookManager
---@param dependencies table
function OtherHooks:Register(hookManager, dependencies)
    local logger = dependencies.logger

    -- Music randomizer
    hookManager:Register(
        "/Game/Gameplay/InteractiveMusic/BP_InteractiveMusicSystem.BP_InteractiveMusicSystem_C:CreateInteractiveMusicWithContextIfNeeded",
        function(ctx, music_context, sound, music)
            if not Archipelago:IsInitialized() then
                return
            end

            local InteractiveMusic = music:get()

            local audio_comp = InteractiveMusic["AudioComponent_7_F10237DD43456A26DE6840B3DC60292D"]

            local music_table = Utils.TableHelper.GetRandomElement(CONSTANTS.ASSETS.MUSIC) ---@type Music_randomizer
            
            local asset = music_table.ASSET
            if asset and asset:IsValid() then
                audio_comp.Sound = asset
            end
        end,
        "Individual Hook - Music Randomizer"
    )

    logger:info("Capacity hook registered")
end

return OtherHooks
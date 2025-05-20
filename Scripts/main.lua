print("[MyLuaMod] Mod loaded\n")

function TestSomeFunctions()
  
    ---@class UAC_jRPG_InventoryManager_C
    local a = FindFirstOf("AC_jRPG_InventoryManager_C")
    if a:IsValid() then
        local s = FText("aa")
        a:ReceiveGold(500000, s:ToString())
    end
end

function Dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. Dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

RegisterKeyBind(Key.F1, { ModifierKey.CONTROL }, function()
    ExecuteInGameThread(function()
        TestSomeFunctions()
    end)
end)

local asset_monoco = "/Game/Audio/MetaSound/MUSIC/Tracks/MonocoStation/MUS_Track_MonocoStation_BT_Monoco.MUS_Track_MonocoStation_BT_Monoco"


RegisterHook("/Game/Gameplay/InteractiveMusic/BP_InteractiveMusicSystem.BP_InteractiveMusicSystem_C:CreateInteractiveMusicWithContextIfNeeded", function(self, context, sound, music)

    ---@class FS_InteractiveMusic
    local InteractiveMusic = music:get()

    local audio_comp = InteractiveMusic["AudioComponent_7_F10237DD43456A26DE6840B3DC60292D"]

    local asset = LoadAsset(asset_monoco)
    if asset and asset:IsValid() then
        audio_comp.Sound = asset
    end
    print(audio_comp.Sound:GetFullName())
end)
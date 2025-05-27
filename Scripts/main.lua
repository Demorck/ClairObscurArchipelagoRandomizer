print("[MyLuaMod] Mod loaded\n")

function TestSomeFunctions()
  
    ---@class FS_ChestLootTableSetup
    -- local a = FindFirstOf("S_ChestLootTableSetup")
    -- if a:IsValid() then
    --     local s = FText("aa")
    --     a:ReceiveGold(500000, s:ToString())
    -- end

    local a = FindFirstOf("DT_ChestsContent")
    if a:IsValid() then
        print("valide la datatable ma couille")
    end

    local a = StaticFindObject("Game/Content/Gameplay/GPE/Chests/Content/DT_ChestsContent.DT_ChestsContent")
    if a:IsValid() then
        print("valide la datatable ma couille 2")
    end

    local a = LoadAsset("Game/Content/Gameplay/GPE/Chests/Content/DT_ChestsContent.DT_ChestsContent")
    if a:IsValid() then
        print("valide la datatable ma couille 2")
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

RegisterHook("/Game/Gameplay/GPE/Chests/BP_Chest_Regular.BP_Chest_Regular_C:RollChestItems", function(self, context, ItemsToLoot)
    ---@class FS_LootContext
    local context = context:get()

    ---@class TMap<FName, int32>
    local ItemsToLoot = ItemsToLoot:get()

    ItemsToLoot:ForEach(function (key, values)
        print("Key: " .. key:get():ToString() .. " - Quantity: " .. tostring(values:get()))

        -- key:set("ChromaPack_Regular")
    end)
end)


NotifyOnNewObject("/Game/Gameplay/GPE/Chests/BP_Chest_Regular.BP_Chest_Regular_C", function (component)
    -- local chest = component:get()
    local lootMap = component.ItemsToLoot
    print(tostring(lootMap["Chest_SeaCliff_36"]))
end)




-- RegisterHook("/Game/Gameplay/InteractiveMusic/BP_InteractiveMusicSystem.BP_InteractiveMusicSystem_C:CreateInteractiveMusicWithContextIfNeeded", function(self, context, sound, music)

--     ---@class FS_InteractiveMusic
--     local InteractiveMusic = music:get()

--     local audio_comp = InteractiveMusic["AudioComponent_7_F10237DD43456A26DE6840B3DC60292D"]

--     local asset = LoadAsset(asset_monoco)
--     if asset and asset:IsValid() then
--         audio_comp.Sound = asset
--     end
--     print(audio_comp.Sound:GetFullName())
-- end)
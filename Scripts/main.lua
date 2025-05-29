function TestSomeFunctions()
  
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

-- Tested in Small level StoneWave Cliff
-- Change loot 
RegisterHook("/Game/Gameplay/GPE/Chests/BP_Chest_Regular.BP_Chest_Regular_C:ComputeChestLootTableSections", function (Context, lootTable, RollChance)
    -- local chest = component:get()
    local context = Context:get()

    print(context:GetFullName()) -- BP_Chest_Regular_C /Game/Levels/ConceptLevels/ConceptLevel_SeaCliff_V1/_Generated_/67GS4DT6NH7SMG9O1U5ZQ8VWU.ConceptLevel_SeaCliff_V1:PersistentLevel.BP_Chest_Regular_C_UAID_C87F5409F1EC60F801_1853506310
    local test = context["ChestSetupHandle"]["RowName"]---@cast test FName
    print(test:ToString()) -- Chest_SmallLevel_StonewaveCliffsCave_1


    ---@class TArray<FS_LootTableSection>
    local loot_table = lootTable:get()


    ---@class TArray<FS_LootTableEntry>
    local loot_entries = loot_table[1]["LootEntries_14_4A650E0F4C998FBA66B50DAEE60C253A"]

    ---@class FS_LootTableEntry
    local loot_table_entry = loot_entries[1]

    ---@class FName
    local loot_name = loot_table_entry["ItemID_7_8AE2C1FA4D5144FF4549F59430C1FC3A"]

    ---@class double
    local roll_chance = RollChance:get()

    if loot_name:ToString() == "Consumable_LuminaPoint" then
        loot_table_entry["ItemID_7_8AE2C1FA4D5144FF4549F59430C1FC3A"] = FName("ChromaPack_Large") -- Change occurs here !
        loot_table_entry["Quantity_4_E9AC4373432C806BD7F0B4BE05A1303D"] = 50
    end

    print(loot_name:ToString())
    print(tostring(roll_chance))
end)



-- Change music
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
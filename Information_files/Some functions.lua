
--  CallFunc_GetEncounterDataTableRow_EncounterData = 
-- (
--    Enemies_14_3D2609EC487DFDF67CB27FAC3F632728=(
--       (0, (DataTable="/Script/Engine.DataTable'/Game/jRPGTemplate/Datatables/DT_jRPG_Enemies.DT_jRPG_Enemies'",RowName="SM_Portier")),
--       (1, (DataTable="/Script/Engine.DataTable'/Game/jRPGTemplate/Datatables/DT_jRPG_Enemies.DT_jRPG_Enemies'",RowName="GO_Luster")),
--       (2, (DataTable="/Script/Engine.DataTable'/Game/jRPGTemplate/Datatables/DT_jRPG_Enemies.DT_jRPG_Enemies'",RowName="GO_Bruler"))
--    ),
--    FleeImpossible_13_2764B2B94142E1FC99C8A182A4BC0B06=False,
--    EncounterLevelOverride_17_FF0AA3B94D98F48F0541B8B7F8EC5A57=10,
--    DisableCameraEndMovement_19_508A8A1D45CCD8697AD9F5A5C7444229=False,
--    DisableReactionBattleLines_21_FB0F2FB047481CC64738E1A9C0D75BC4=False,
--    IsNarrativeBattle_23_C3BA36324CC3DEC332F6E4B049A535C9=False
-- )
    

-- RegisterHook("/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_BattleManager.AC_jRPG_BattleManager_C:LoadEncounterSettings", function (Context)
--    ---@class UAC_jRPG_BattleManager_C
--    local battle_manager = Context:get()
--    local params = battle_manager.CurrentBattleStartParams ---@cast params FFBattleStartParams
--    -- Afficher toute la TMap des ennemis
--    -- print(encounter_row["RowName"]:ToString())

   

--    params["EncounterRow_25_76E166214BC95AA2A6A68DAD97A47C62"]["RowName"] = FName("L_Boss_Curator")
   
--    -- Ou utiliser la fonction spécialisée pour les ennemis
--    -- DisplayEnemyRowNames(enemies_data)
-- end)


-- Tested in Small level StoneWave Cliff
-- Change loot 
-- RegisterHook("/Game/Gameplay/GPE/Chests/BP_Chest_Regular.BP_Chest_Regular_C:ComputeChestLootTableSections", function (Context, lootTable, RollChance)
--     -- local chest = component:get()
--     local context = Context:get()

--     print(context:GetFullName()) -- BP_Chest_Regular_C /Game/Levels/ConceptLevels/ConceptLevel_SeaCliff_V1/_Generated_/67GS4DT6NH7SMG9O1U5ZQ8VWU.ConceptLevel_SeaCliff_V1:PersistentLevel.BP_Chest_Regular_C_UAID_C87F5409F1EC60F801_1853506310
--     local test = context["ChestSetupHandle"]["RowName"]---@cast test FName
--     print(test:ToString()) -- Chest_SmallLevel_StonewaveCliffsCave_1


--     ---@class TArray<FS_LootTableSection>
--     local loot_table = lootTable:get()


--     ---@class TArray<FS_LootTableEntry>
--     local loot_entries = loot_table[1]["LootEntries_14_4A650E0F4C998FBA66B50DAEE60C253A"]

--     ---@class FS_LootTableEntry
--     local loot_table_entry = loot_entries[1]

--     ---@class FName
--     local loot_name = loot_table_entry["ItemID_7_8AE2C1FA4D5144FF4549F59430C1FC3A"]

--     ---@class double
--     local roll_chance = RollChance:get()

--     if loot_name:ToString() == "Consumable_LuminaPoint" then
--         loot_table_entry["ItemID_7_8AE2C1FA4D5144FF4549F59430C1FC3A"] = FName("ChromaPack_Large") -- Change occurs here !
--         loot_table_entry["Quantity_4_E9AC4373432C806BD7F0B4BE05A1303D"] = 50
--     end

--     print(loot_name:ToString())
--     print(tostring(roll_chance))
-- end)



-- Change music

-- local asset_monoco = "/Game/Audio/MetaSound/MUSIC/Tracks/MonocoStation/MUS_Track_MonocoStation_BT_Monoco.MUS_Track_MonocoStation_BT_Monoco"
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
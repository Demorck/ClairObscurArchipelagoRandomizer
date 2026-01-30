---@class NID
---@field A number
---@field B number
---@field C number
---@field D number
---@field NAME string

---@class NID_Constants
---@field DIVE_GUID NID
---@field FB_GRADIENT_TUTORIAL NID
---@field FW_JUMP_TUTORIAL NID
---@field REACHER_LVL6_MAELLE NID
---@field RELATION_LVL6_LUNE NID
---@field RELATION_LVL6_MONOCO NID
local NID = {
    DIVE_GUID = { -- NID_EsquieUnderwaterUnlocked
        A = 0xffffffffc6049eb0,
        B = 0x4851b254,
        C = 0xffffffffe484769a,
        D = 0xffffffffb9f84714,
        NAME = "NID_EsquieUnderwaterUnlocked"
    },
    FB_GRADIENT_TUTORIAL = { -- NID_ForgottenBattlefield_GradientCounterTutorial (A=820155502,B=1127002344,C=910086808,D=290946608)
        A = 0x30e2946e,
        B = 0x432cb0e8,
        C = 0x363ed298,
        D = 0x11577e30,
        NAME = "NID_ForgottenBattlefield_GradientCounterTutorial"
    },
    FW_JUMP_TUTORIAL = { -- NID_Goblu_JumpTutorial
        A = 0xffffffff8e3263a7,
        B = 0x493bf6fd,
        C = 0xfffffffff260549a,
        D = 0xfffffffff74ea0db,
        NAME = "NID_Goblu_JumpTutorial"
    },
    REACHER_LVL6_MAELLE = {  -- NID_MaelleRelationshipLvl6_Quest
        A = 0xffffffffe3367623,
        B = 0x40bcb33c,
        C = 0x788d9cb7,
        D = 0xffffffffffe1b656,
        NAME = "NID_MaelleRelationshipLvl6_Quest"
    },
    RELATION_LVL6_LUNE = { -- NID_LuneRelationshipLvl6_Quest
        A = 0x2a55f5a4,
        B = 0x4ef0b15c,
        C = 0x7b4d53b6,
        D = 0xfffffffff3e5cc39,
        NAME = "NID_LuneRelationshipLvl6_Quest"
    },
    RELATION_LVL6_MONOCO = { -- NID_Monoco_RelationshipLvl6_Quest
        A = 0xffffffffa73a9b68,
        B = 0x4aceacd1,
        C = 0x721bcb90,
        D = 0x1f428538,
        NAME = "NID_Monoco_RelationshipLvl6_Quest"
    }
}


return NID




  -- [17:15:30.1134016] [Lua] NID_GommageCineSeen
  -- [17:15:30.1136885] [Lua] 2dc8b1d6-44563a7b-ffffffffce3474b2-ffffffffe791d807
  -- [17:15:30.1138468] [Lua] NID_CharacterOverviewTutorial
  -- [17:15:30.1141059] [Lua] 21ca87f4-4e358a24-ffffffffddeaba84-ffffffff881a95db
  -- [17:15:30.1142354] [Lua] NID_PictosTutorial
  -- [17:15:30.1143596] [Lua] ffffffff8d843b41-4bd492a5-72e60b91-9ead34e
  -- [17:15:30.1145374] [Lua] NID_FirstLancelierBeaten
  -- [17:15:30.1148174] [Lua] 6e8d109-4c064007-ffffffffa98fa190-ffffffffe7eacfee
  -- [17:15:30.1150160] [Lua] NID_LuneUnlock1
  -- [17:15:30.1151539] [Lua] 606d3e62-4bc427ff-ffffffff9bffad97-284286a0
  -- [17:15:30.1153735] [Lua] NID_LuminaTutorial
  -- [17:15:30.1155183] [Lua] fffffffff87b8c10-46c612a9-ffffffffb90e29a9-500396dd
  -- [17:15:30.1157300] [Lua] NID_EntryWorldMap
  -- [17:15:30.1159344] [Lua] 430e49b6-4dee3a1b-7c2d329b-17f480fb
  -- [17:15:30.1160844] [Lua] NID_MaelleUnlock1
  -- [17:15:30.1162823] [Lua] 73067fa-4fa91572-2f2932a5-1b1fb722
  -- [17:15:30.1164025] [Lua] NID_MaelleUnlock
  -- [17:15:30.1166134] [Lua] 3a601f56-44a2228f-ffffffffd7d77594-ffffffffe7374a08
  -- [17:15:30.1167474] [Lua] NID_Goblu_JumpTutorial
  -- [17:15:30.1168681] [Lua] ffffffff8e3263a7-493bf6fd-fffffffff260549a-fffffffff74ea0db
  -- [17:15:30.1170873] [Lua] NID_MaelleUnlock1
  -- [17:15:30.1172820] [Lua] ffffffffefdc9a38-4f931063-3386c793-3f81a2e2
  -- [17:15:30.1174140] [Lua] NID_CuratorTutorial
  -- [17:15:30.1176512] [Lua] 7d5f9151-4a9038ed-37ecd191-ffffffffbc5cceb1
  -- [17:15:30.1178119] [Lua] NID_CuratorExpeditionTutorial1
  -- [17:15:30.1180692] [Lua] fffffffff9ef27d7-4862e895-2315d98-ffffffffa6b77155
  -- [17:15:30.1185788] [Lua] NID_ScielUnlock
  -- [17:15:30.1188506] [Lua] ffffffffd863d1f9-4730f13b-ffffffffa8d3fb8f-ffffffffe465e774
  -- [17:15:30.1191719] [Lua] NID_GestralVillage_TalkToTheChief
  -- [17:15:30.1193363] [Lua] ffffffffd9761a73-47b1d711-238dbd93-781aae5c
  -- [17:15:30.1194713] [Lua] NID_CIN_EnteringEsquieNestPlayed
  -- [17:15:30.1195931] [Lua] ffffffffc8c70cd3-4fe1a9cc-5c8aa99b-ffffffffd37034f2
  -- [17:15:30.1197145] [Lua] NID_EsquieNest_FrancoisDefeated1
  -- [17:15:30.1198642] [Lua] ffffffffd0a6dfb1-454b657f-6e9cefbf-ffffffffdbfe9929
  -- [17:15:30.1200137] [Lua] NID_EsquieNest_FrancoisDefeated
  -- [17:15:30.1201538] [Lua] ffffffffae65dd07-458c4ad1-390fdb89-ffffffffacfd953e
  -- [17:15:30.1202854] [Lua] NID_ForgottenBattlefield_GradientCounterTutorial
  -- [17:15:30.1204429] [Lua] 30e2946e-432cb0e8-363ed298-11577e30
  -- [17:15:30.1205983] [Lua] NID_DuallistIntroPlayed
  -- [17:15:30.1207468] [Lua] 2c768577-486f9298-58f131b5-ffffffffe6f96f87
  -- [17:15:30.1209047] [Lua] NID_Camp_DS_CampMaelleLune
  -- [17:15:30.1213849] [Lua] 541e32d9-4886c428-fffffffffb2c1399-2629b2d9
  -- [17:15:30.1215879] [Lua] NID_Lumiere_MyFlowerCINPlayed
  -- [17:15:30.1218400] [Lua] 71bae11f-4574e90d-ffffffffe907fbab-4f471ab7
  -- [17:15:30.1233944] [Lua] NID_MonocoStation_StalactAttack1
  -- [17:15:30.1235684] [Lua] ffffffffbedc3616-4c3359e2-ffffffffa24c01b5-4e081257
  -- [17:15:30.1237144] [Lua] NID_MonocoStation_GrandisFashion_EloquenceBattle
  -- [17:15:30.1238706] [Lua] ffffffffd8ad6611-4162c20f-58a7a2af-4fa5cd79
  -- [17:15:30.1240060] [Lua] NID_OldL_MonocoSmash
  -- [17:15:30.1242035] [Lua] ffffffffb1fd5ca7-43796a7c-fad8e89-733ee79a
  -- [17:15:30.1243607] [Lua] NID_OldLumiere_VersoDisapeared
  -- [17:15:30.1246128] [Lua] 79ffe61f-42911df0-7200c3a0-67dfbf1b
  -- [17:15:30.1247274] [Lua] NID_EsquieArmbandUnlocked
  -- [17:15:30.1249318] [Lua] ffffffff894303d3-43248548-ffffffffdf5951b6-4725db32
  -- [17:15:30.1250532] [Lua] NID_Camp_DS_Sisters_Trigger
  -- [17:15:30.1252506] [Lua] ffffffffcd2568aa-4bbd270b-102ed3a0-5fac0324
  -- [17:15:30.1254115] [Lua] NID_JoyMaskDefeated2
  -- [17:15:30.1255611] [Lua] 1262ed04-4c4b3314-ffffffffa7a281a2-ffffffff99720310
  -- [17:15:30.1257252] [Lua] NID_AngerMaskDefeated1
  -- [17:15:30.1259163] [Lua] 60e6aed-4743c27d-41a222ab-22d097c0
  -- [17:15:30.1260709] [Lua] NID_SireneDefeated
  -- [17:15:30.1262327] [Lua] 657b4f90-4b864cfd-fffffffff74824a7-4bb2e0fc
  -- [17:15:30.1263628] [Lua] NID_SadnessMaskDefeated1
  -- [17:15:30.1265134] [Lua] ffffffffad00a708-4e8296c4-61f60a98-ffffffffd4cb487b
  -- [17:15:30.1266728] [Lua] NID_SireneDefeated1
  -- [17:15:30.1268036] [Lua] ffffffffe56beae9-48567fe3-16054abb-ffffffff9eb3ae57
  -- [17:15:30.1269095] [Lua] NID_SireneDefeated
  -- [17:15:30.1270651] [Lua] 190f0499-4f3bc25d-ffffffffb0d85d80-52bbc94e
  -- [17:15:30.1272279] [Lua] NID_DatingSciel
  -- [17:15:30.1273665] [Lua] ffffffffc9740bc8-429d79a7-ffffffffde87bb82-ffffffffd824aa6e
  -- [17:15:30.1274836] [Lua] NID_EsquieHardWaterUnlock1
  -- [17:15:30.1276636] [Lua] 6a9553f7-4df3dc95-21419590-ffffffffcca043aa
  -- [17:15:30.1277647] [Lua] NID_ScielUnlock
  -- [17:15:30.1280025] [Lua] ffffffffa082f7f0-4a94eab3-59a693a0-7c60205b
  -- [17:15:30.1281656] [Lua] NID_Camp_AfterMeetingRealRenoir
  -- [17:15:30.1283987] [Lua] ffffffffdf673638-42b372b3-ffffffff8fc8bb8a-2a98f8f2
  -- [17:15:30.1285856] [Lua] NID_CampAftermathDialogs
  -- [17:15:30.1287167] [Lua] 1c5f62cb-44df660f-ffffffff9a3f22a8-19516533
  -- [17:15:30.1288340] [Lua] NID_Camp_DS_AftermathLadies_Trigger
  -- [17:15:30.1289709] [Lua] 117dbeb4-4b2e5608-54b7d8bb-10acdb08
  -- [17:15:30.1291188] [Lua] NID_LuneRelationshipLvl6_Quest
  -- [17:15:30.1293033] [Lua] 2a55f5a4-4ef0b15c-7b4d53b6-fffffffff3e5cc39
  -- [17:15:30.1294466] [Lua] NID_MaelleRelationshipLvl6_Quest
  -- [17:15:30.1295813] [Lua] ffffffffe3367623-40bcb33c-788d9cb7-ffffffffffe1b656
  -- [17:15:30.1296943] [Lua] NID_Monoco_RelationshipLvl6_Quest
  -- [17:15:30.1298312] [Lua] ffffffffa73a9b68-4aceacd1-721bcb90-1f428538
  -- [17:15:30.1299408] [Lua] NID_EsquieUnderwaterUnlocked
  -- [17:15:30.1301219] [Lua] ffffffffc6049eb0-4851b254-ffffffffe484769a-ffffffffb9f84714
  -- [17:15:30.1303154] [Lua] NID_Lumiere_MyFlowerCINPlayed1
  -- [17:15:30.1304451] [Lua] ffffffffaa6633b1-4feda61d-92eed80-ffffffffcd949751
  -- [17:15:30.1305614] [Lua] NID_Reacher_AliciaDefeated1
  -- [17:15:30.1307290] [Lua] ffffffff88b11d0f-4862554e-ffffffffdda35eb0-ffffffff9310cdd8
  -- [17:15:30.1308490] [Lua] NID_AliciaEncountered
  -- [17:15:30.1309673] [Lua] ffffffffb155c643-4303f75c-389c1f86-ffffffffa7f09b7c
  -- [17:15:30.1310863] [Lua] NID_Reacher_AliciaDefeated
  -- [17:15:30.1312294] [Lua] 426cc205-4586ee41-ffffffffdd4f6587-7ecd78a4
  -- [17:15:30.1313718] [Lua] NID_Camp_DS_CampScielEsquie
  -- [17:15:30.1329619] [Lua] ffffffff8bca1363-4e12c628-3c39afaa-ffffffffd03a3b5c
  -- [17:15:30.1331360] [Lua] NID_MetCleaInFlyingHouse
  -- [17:15:30.1333103] [Lua] 70e5f818-4badd566-25a359b3-ffffffffded04d35
  -- [17:15:30.1335100] [Lua] NID_MetSimon
  -- [17:15:30.1336322] [Lua] fffffffffd4eaf4d-4aa4b3ae-ffffffffd1ed1ba1-6108c00a
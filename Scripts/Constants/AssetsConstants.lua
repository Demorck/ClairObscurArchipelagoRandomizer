  ---@class Music_randomizer
  ---@field ASSET string
  ---@field READABLE_NAME string
  ---@field TAGS table<string>
  ---@field DURATION number

  ---@class Assets_Constants
  ---@field MUSIC table<string, Music_randomizer>
local ASSETS = {
    MUSIC = {
        ALINE_PIANO_SOLO = {
            ASSET         = "Sandfall/Content/Audio/WAV/MUSIC/Alpha/Characters/MUS_Aline_PianoSolo",
            READABLE_NAME = "Aline - Piano Solo",
            TAGS          = {"Aline", "Piano", "Solo"},
            DURATION      = 184.5
        },
        CLEA_FULL = {
            ASSET         = "Sandfall/Content/Audio/WAV/MUSIC/Alpha/Characters/MUS_Character_Clea_Full_130bpm",
            READABLE_NAME = "Clea - Fight",
            TAGS          = {"Clea"},
            DURATION      = 192.0
        },
        SCIEL_SEA_BREEZE = {
            ASSET         = "Sandfall/Content/Audio/WAV/MUSIC/Alpha/Characters/MUS_Character_Sciel_SeaBreeze_100bpm",
            READABLE_NAME = "Sciel",
            TAGS          = {"Sciel"},
            DURATION      = 208.80002
        },
        GUSTAVE = {
            ASSET         = "Sandfall/Content/Audio/WAV/MUSIC/Alpha/Characters/MUS_Gustave_160bpm",
            READABLE_NAME = "Gustave",
            TAGS          = {"Gustave"},
            DURATION      = 228.0
        },
        ALICIA_NAISSANCE = {
            ASSET         = "Sandfall/Content/Audio/WAV/MUSIC/Alpha/Characters/MUS_LaNaissanceDAlicia_OrchestralChoir",
            READABLE_NAME = "Alicia - Birth Orchestral",
            TAGS          = {"Alicia"},
            DURATION      = 166.96973
        },
        LUNE_INSTRU = {
            ASSET         = "Sandfall/Content/Audio/WAV/MUSIC/Alpha/Characters/MUS_Lune_Instru_Loop_NoRiser_92bpm",
            READABLE_NAME = "Lune - Instrumental",
            TAGS          = {"Lune", "Instrumental"},
            DURATION      = 187.82611
        },
        LUNE_PIANO_SOLO = {
            ASSET         = "",
            READABLE_NAME = "Lune - Piano Solo",
            TAGS          = {"Lune", "Piano", "Solo"},
            DURATION      = 220.44113
        },
        ALICIA_MUSICBOX = {
            ASSET         = "Sandfall/Content/Audio/WAV/MUSIC/Alpha/Characters/MUS_MusicBox_Alicia_Full_106bpm",
            READABLE_NAME = "Alicia - Music box",
            TAGS          = {"Alicia", "Music box"},
            DURATION      = 79.245316
        },
        LUNE_MUSICBOX = {
            ASSET         = "Sandfall/Content/Audio/WAV/MUSIC/Alpha/Characters/MUS_MusicBox_Lune_Full_92bpm",
            READABLE_NAME = "Lune - Music box",
            TAGS          = {"Lune", "Music box"},
            DURATION      = 221.73915
        },
        SCIEL_MUSICBOX = {
            ASSET         = "Sandfall/Content/Audio/WAV/MUSIC/Alpha/Characters/MUS_MusicBox_Sciel_Full_100bpm",
            READABLE_NAME = "Sciel - Music box",
            TAGS          = {"Sciel", "Music box"},
            DURATION      = 114.60002
        },
        VERSO_MUSICBOX = {
            ASSET         = "Sandfall/Content/Audio/WAV/MUSIC/Alpha/Characters/MUS_MusicBox_Verso_Full_90bpm",
            READABLE_NAME = "Verso - Music box",
            TAGS          = {"Verso", "Music box"},
            DURATION      = 86.00002
        },
        RENOIR_PIANO_SOLO = {
            ASSET         = "Sandfall/Content/Audio/WAV/MUSIC/Alpha/Characters/MUS_Renoir_PianoSolo",
            READABLE_NAME = "Renoir - Piano Solo",
            TAGS          = {"Renoir", "Piano", "Solo"},
            DURATION      = 162.40929
        },
        SCIEL_PIANO_SOLO = {
            ASSET         = "Sandfall/Content/Audio/WAV/MUSIC/Alpha/Characters/MUS_Sciel_PianoSolo",
            READABLE_NAME = "Sciel - Piano Solo",
            TAGS          = {"Sciel", "Piano", "Solo"},
            DURATION      = 239.99884
        },
        THE_CURATOR = {
            ASSET         = "Sandfall/Content/Audio/WAV/MUSIC/Alpha/Characters/MUS_TheCurator_Full_60bpm",
            READABLE_NAME = "The Curator",
            TAGS          = {"Curator"},
            DURATION      = 78.0
        },
        VERSO_IMMORTEL = {
            ASSET         = "Sandfall/Content/Audio/WAV/MUSIC/Alpha/Characters/MUS_Verso_ImmortelAuClairObscur_Full_106bpm",
            READABLE_NAME = "Verso - Immortel Au Clair Obscur",
            TAGS          = {"Verso"},
            DURATION      = 198.67902
        },
    }
    
}

  --- ASSET = "Sandfall/Content/((?:.*/)?)([^/]+)",
  --- ASSET = "/Game/$1$2.$2",
  --- Sandfall/Content/Audio/WAV/MUSIC/Alpha/ChromaZone <- Currently here
  --- what am i doing ??
  --- l10n for french localization

return ASSETS
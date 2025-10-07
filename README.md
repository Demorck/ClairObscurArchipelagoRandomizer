# ClairObscurArchipelagoRandomizer
A Clair Obscur : Expedition 33 mod for the Archipelago multi-game randomizer system

# APWorld

[Here](https://github.com/Demorck/ClairObscur_APWorld/releases)


# Setup Guide

### Two mods for the client ?
The setup guide is pretty simple but you will need to understand how the complete client works because there are 3 things:

- **The lua mod** : It's the main mod that changes loot, connect to AP, etc.
- **The blueprint mod** : It's the functionnalities the lua mod can't do easily (or can't do at all). Like the main menu, the feet trap.
- **UE4SS** : That's the thing needs to the injecting the mod into the game.

The release will have all theses three things. If you understand this, it can be easier to us, developers, to understand where the bug occurs.

### Install it

You will need the last version of the [release](https://github.com/Demorck/ClairObscurArchipelagoRandomizer/releases).

1. Download the right file in the release tab. (Steam or gamepass version).
2. Extract it in the root of the game folder. To be sure that is well extract, you need to find 3 files called ClairObscurRandomizer.smth in `\Sandfall\Content\Paks\LogicMods` and ue4ss folder in `\Sandfall\Binaries\[WinGDK or Win64]`
3. ???
4. Profit

### Recommended mods
- [**Minimap mod**](https://www.nexusmods.com/clairobscurexpedition33/mods/383) by paboyafx. 
- [**Tracker for Poptracker**](https://github.com/Demorck/ClairObscur-Archipelago-Poptracker/releases) for tracking item and locations.
- [**Save editor**](https://www.nexusmods.com/clairobscurexpedition33/mods/201) if a bug occurs

### Where are the three things from above ?

- **The lua mod** is in `Expedition 33\Sandfall\Binaries\Win64\UE4SS\Mods\COE33AP`
- **The blueprint mod** is in `\Expedition 33\Sandfall\Content\Paks\LogicMods`
- **UE4SS** is in `Expedition 33\Sandfall\Binaries\Win64\UE4SS`

### Uninstall it

- Remove the folder `Expedition 33\Sandfall\Binaries\Win64\UE4SS\`
- Remove the file `Expedition 33\Sandfall\Binaries\Win64\lua-apclientpp.dll`
- Remove the file `Expedition 33\Sandfall\Binaries\Win64\dwmapi.dll`
- Remove files which start by "ClairObscurRandomizer" in `\Expedition 33\Sandfall\Content\Paks\LogicMods`

# How can i connect to the multiworld ?
1. Press **Archipelago** in the main menu.
2. Enter your informations (host, port, slot, password)
3. Click connect and wait until it says "Connected" below.
4. Profit

# I found a bug
### Who i need to ping ?
Yes, it's common. The client is currently in alpha. You can ping me (Demorck) in the AP Dark Server in [this channel](https://discord.com/channels/1085716850370957462/1371907053626593301).
There are also logs here: `\Expedition 33\Sandfall\Content\Paks\LogicMods\ClairObscurRandomizer_data\Logs`

### The game crashes
The game crashes perdiodically for no reasons. I need to understand why it happens but for now, just relaunch the game. **Do not play by moving the error out of the way, you may lose progress**. The rando is in alpha. It's a lot of work to understand how the game handles things, etc. Don't be rude of course ! 

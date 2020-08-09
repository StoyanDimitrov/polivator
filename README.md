# Polivator
This is *very basic* UI helper application that automates the aiding process of the game Forge of Empires.

**Note**: Although full rewrite it still has rough edges. Handle with care!

## Features
- FAST! Implements an algorithm that adapts to system and network loads.
- Handles multi-monitor workstations (not pretty for now).
- Prepares and navigates the social bar.
- Handles the blueprint window (not perfectly for now, still misses sometimes - it turns out very network sensitive and not very well handled by FoE side).
- Handles the Friends Tavern visits (mandatory for now).
- Keeps simple stats in the configuration file.
- ~~After aiding all players displays stats of aids made (rough estimate number), found blueprints (precise number) and visited taverns (precise number).~~ Turned off for this version

## What needs to be done
- The interface is far from ready for prime-time but does the job pretty well.
- Better handling of the blueprint windows.
- Handling the kicked/left/disappeared guildie/neighbor still present in the social bar.

## How to use
1. Open the `config.ini` file and change the worlds list according to your preferences. Add or remove worlds if necessary. Take care to match the prefix of `.settings` and `.stats` sections to match the corresponding world key.
2. Open the application
    1. From the World menu select the world about to polivate.
    2. From the Actions menu select the tabs that you want polivated.
    **Note**: Taverns are always visited despite what actions are selected.
4. Switch to the opened and logged in game.
5. Wait a bit.
6. Profit!

## Build
This is [AutoIt](https://autoitscript.com/) application so you won't need Visual Studio.

## Download
The [latest binary](https://github.com/StoyanDimitrov/polivator/raw/bin/Polivator.exe) is always available here.

**Note**: Please manually download `config.ini` from the repo.

## Privacy Policy
The application works completely off-line and does not collects nor sends personal information. It just moves the cursor of your mouse guided by some patches of color on your screen. The collected stats of aided players, collected blueprints and visited taverns is stored only on your computer. Up to you to safeguard it if you feel that information sensitive.

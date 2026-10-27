require "common/sdk"
require "admins"

EventManager.Listen("ServerPlayer:SendMessage", function(player, message)
    if not table.contains(Admins, player.playerId) then return end
    if message:len() < 2 then return end
    local messageSplit = string.split(message)

    if #messageSplit <= 0 then return end
    if messageSplit[1]:len() < 3 then return end
    if messageSplit[1]:sub(1, 1) ~= '/' then return end

    local command = messageSplit[1]:lower():sub(2)

    EventManager.SetCancelled(true)

    -- Kicks a player of the server
    -- Example: /kick player
    if command == "kick" then
        if #messageSplit < 2 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        target:Kick("Kicked by an admin")

    -- Sets a players team
    -- Example: /setteam player 1
    elseif command == "setteam" or command == "st" then
        if #messageSplit < 3 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        local team = tonumber(messageSplit[3])
        if team ~= 1 and team ~= 2 then return end
        target:SetTeam(team)

    -- Swaps a player to the opposite team
    -- Example: /swap player
    elseif command == "swap" then
        if #messageSplit < 2 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        target:SetTeam((math.fmod(target.team, 2)) + 1)

    -- Swaps every player of team 1 to team 2 and team 2 to team 1
    -- Example: /fullteamswap
    elseif command == "fullteamswap" or command == "fts" then
        Console.Execute("Kyber.FullTeamSwap")

    -- Gives battlepoints to a player
    -- Example: /givebp player 1500
    elseif command == "givebp" then
        if #messageSplit < 3 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        local amount = tonumber(messageSplit[3])
        if amount == nil or amount % 1 ~= 0 then return end
        target:GiveBattlepoints(amount)

    -- Sets the amount of battlepoints of a player
    -- Example: /setbp player 1500
    elseif command == "setbp" then
        if #messageSplit < 3 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        local amount = tonumber(messageSplit[3])
        if amount == nil or amount < 0 or amount % 1 ~= 0 then return end
        target:SetBattlepoints(amount)

    -- Sets the amount of health of a player
    -- /sethealth player 1500
    elseif command == "sethealth" then 
        if #messageSplit < 3 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        local amount = tonumber(messageSplit[3])
        if amount == nil or amount < 0 or amount % 1 ~= 0 then return end
        target:SetHealth(amount)

    -- Makes a player invisible
    -- Example: /invisible player true
    elseif command == "invisible" then 
        if #messageSplit < 3 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        local val = messageSplit[3]:lower()
        if val ~= "true" and val ~= "false" then return end
        target:SetInvisible(val == "true")

    -- Ends the round and takes you to the eor screen
    -- Example: /endofround
    elseif command == "endofround" or command == "eor" then
        Console.Execute("Kyber.endofround")

    -- Ends the round
    -- Example: /endround
    elseif command == "endround" or command == "er" then
        Console.Execute("Kyber.endround")

    -- Ends the round and team1 wins
    -- Example: /endgameteam1
    elseif command == "endgameteam1" or command == "endteam1" or command == "egt1" then
        Console.Execute("Kyber.endgameteam1")

    -- Ends the round and team2 wins
    -- Example: /endgameteam2
    elseif command == "endgameteam2" or command == "endteam2" or command == "egt2" then
        Console.Execute("Kyber.endgameteam2")

    -- Loads a level/map
    -- Example: /loadlevel Levels/MP/Naboo_01/Naboo_01 Mode1
    elseif command == "loadlevel" or command == "loadmap" then
        if #messageSplit < 3 then return end
        Console.Execute("Kyber.LoadLevel " .. messageSplit[2] .. " " .. messageSplit[3])

    -- Broadcasts a message to the chat
    -- Example: /broadcast Hi
    elseif command == "broadcast" or command == "bc" then
        if #messageSplit < 2 then return end
        local msg = table.concat(messageSplit, " ", 2)
        Console.Execute("Kyber.Broadcast " .. msg)

    -- Prints on the console a list of all the players in the server
    -- Example: /listplayers
    elseif command == "listplayers" or command == "lp" then
        for _, player in pairs(PlayerManager.GetPlayers()) do
            print(player.name .. " | Team: " .. player.team .. " | ID: " .. tostring(player.playerId) .. " | Bot: " .. tostring(player.isBot))
        end

    -- Crashes the game/server
    -- Example: /crashgame
    elseif command == "crashgame" or command == "crash" then
        Console.Execute("Kyber.CrashGame")

    -- Shuffles the teams
    -- Example: /shuffleteams
    elseif command == "shuffleteams" or command == "shuffle" then
        Console.Execute("Kyber.ShuffleTeams")

    -- Reloads changes without needing to restart the server
    -- To use this you need to set the `KYBER_DEV_PLUGIN_PATH` environment variable to load your plugin without packaging it as a `.kbplugin` file
    -- Example: /hotreloadlua
    elseif command == "hotreloadlua" or command == "hotreload" or command == "reload" or command == "hrl" or command == "rl" then
        Console.Execute("Kyber.HotReloadLua")

    -- Starts the game/round
    -- Example: /startgame
    elseif command == "startgame" or command == "start" or command == "sg" then
        Console.Execute("Kyber.startgame")

    -- There's 2 ways to use this
    -- 1. Teleport playerA to playerB
    -- Example: /teleport playerA playerB
    -- 2. Teleport a player to x y z positions
    -- Example: /teleport player 1 2 3
    elseif command == "teleport" or command == "tp" then
        if #messageSplit < 3 then return end
        if #messageSplit == 3 then
            Console.Execute("Kyber.Teleport " .. messageSplit[2] .. " " .. messageSplit[3]) -- teleport playerA to playerB
        elseif #messageSplit == 5 then
            Console.Execute("Kyber.Teleport " .. messageSplit[2] .. " " .. messageSplit[3] .. " " .. messageSplit[4] .. " " .. messageSplit[5]) -- teleport a player to x y z
        end

    -- Makes the player take no damage
    -- Example: /setimmortal player true
    elseif command == "setimmortal" or command == "si" then
        if #messageSplit < 3 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        local val = messageSplit[3]:lower()
        if val ~= "true" and val ~= "false" then return end
        target:SetImmortal(val == "true")

    -- This is identical to the 1 hp cheat/bug
    -- it basically lets you get damaged until 1hp and then you can't die
    -- Example: /setfakeimmortal player true
    elseif command == "setfakeimmortal" or command == "sfi" then
        if #messageSplit < 3 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        local val = messageSplit[3]:lower()
        if val ~= "true" and val ~= "false" then return end
        target:SetFakeImmortal(val == "true")

    -- Sets the amount of explosion damage
    -- Example: /setexplosionmodifier player 1
    elseif command == "setexplosionmodifier" or command == "sem" then
        if #messageSplit < 3 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        local val = tonumber(messageSplit[3])
        if val == nil then return end
        target:SetExplosionDamageModifier(val)

    -- Sets the speed of a player
    -- Example: /setspeed player 10
    elseif command == "setspeed" or command == "ss" then
        if #messageSplit < 3 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        local val = tonumber(messageSplit[3])
        if val == nil then return end
        target:SetMoveSpeedMultiplier(val)

    -- Sets the amount of the abilities cooldown
    -- Example: /setcooldown player 10
    elseif command == "setcooldown" or command == "sc" then
        if #messageSplit < 3 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        local val = tonumber(messageSplit[3])
        if val == nil then return end
        target:SetCooldownModifier(val)

    -- Enables the Unlimited Power Event
    -- Example: /unlimitedpowerevent true
    elseif command == "unlimitedpowerevent" or command == "upe" then
        if #messageSplit < 2 then return end
        local val = messageSplit[2]:lower()
        if val ~= "true" and val ~= "false" then return end
        Console.Execute("Kyber.EnableUnlimitedPowerEvent " .. val)

    -- Enables team suffling
    -- Example: /enableshuffle true
    elseif command == "enableshuffle" or command == "es" then
        if #messageSplit < 2 then return end
        local val = messageSplit[2]:lower()
        if val ~= "true" and val ~= "false" then return end
        Console.Execute("Kyber.EnableShuffleTeams " .. val)

    -- Disables team balancing
    -- Example: /disableteambalancing true
    elseif command == "disableteambalancing" or command == "dtb" then
        if #messageSplit < 2 then return end
        local val = messageSplit[2]:lower()
        if val ~= "true" and val ~= "false" then return end
        Console.Execute("Kyber.DisableTeamBalancing " .. val)

    -- Adds a level/map
    -- Example: /addlevel Levels/MP/Naboo_01/Naboo_01 Mode1
    elseif command == "addlevel" then
        if #messageSplit < 3 then return end
        Console.Execute("Kyber.AddLevel " .. messageSplit[2] .. " " .. messageSplit[3])

    -- Sets a players team by id
    -- Example: /setteambyid playerid 1
    elseif command == "setteambyid" or command == "stbi" then
        if #messageSplit < 3 then return end
        local playerId = tonumber(messageSplit[2])
        local team = tonumber(messageSplit[3])
        if playerId == nil or team == nil then return end
        if playerId % 1 ~= 0 or team % 1 ~= 0 then return end
        if team ~= 1 and team ~= 2 then return end
        Console.Execute("Kyber.SetTeamById " .. playerId .. " " .. team)

    -- Sets the health multiplier
    -- Example: /sethumanhealthmultiplier 20
    elseif command == "sethumanhealthmultiplier" or command == "shhm" then
        if #messageSplit < 2 then return end
        local amount = tonumber(messageSplit[2])
        if amount == nil then return end
        Console.Execute("Server.HumanHealthMultiplier " .. amount)

    -- Sets the max amount of battlepoints players can gain
    -- /setmaxbattlepoints 9999
    elseif command == "setmaxbattlepoints" or command == "smb" then
        if #messageSplit < 2 then return end
        local amount = tonumber(messageSplit[2])
        if amount == nil or amount < 0 or amount % 1 ~= 0 then return end
        Console.Execute("Whiteshark.MaximumBattlepoints " .. amount)

    -- Sets the teams max sized difference
    -- Example: /setmaxteamsizedifference 10
    elseif command == "setmaxteamsizedifference" or command == "smtsd" then
        if #messageSplit < 2 then return end
        local amount = tonumber(messageSplit[2])
        if amount == nil or amount < 0 or amount % 1 ~= 0 then return end
        Console.Execute("Whiteshark.MaxTeamSizeDifference " .. amount)

    -- Adds an x amount of bots to team1
    -- Example: /addbotsteam1 10
    elseif command == "addbotsteam1" or command == "abt1" then
        if #messageSplit < 2 then return end
        local amount = tonumber(messageSplit[2])
        if amount == nil or amount < 0 or amount % 1 ~= 0 then return end
        Console.Execute("AutoPlayers.ForceFillGameplayBotsTeam1 " .. amount)

    -- Adds an x amount of bots to team2
    -- Example: /addbotsteam2 11
    elseif command == "addbotsteam2" or command == "abt2" then
        if #messageSplit < 2 then return end
        local amount = tonumber(messageSplit[2])
        if amount == nil or amount < 0 or amount % 1 ~= 0 then return end
        Console.Execute("AutoPlayers.ForceFillGameplayBotsTeam2 " .. amount)

    -- Sets the probability of ai spawning as a hero
    -- the max amount is 1 and the min is 0
    -- Example: /herospawnprobability 0.4
    elseif command == "herospawnprobability" or command == "hsp" then
        if #messageSplit < 2 then return end
        local amount = tonumber(messageSplit[2])
        if amount == nil then return end
        Console.Execute("AutoPlayers.HeroSpawnProbability_Gameplay " .. amount)

    -- Sets the probability of ai spawning as a hero vehicle 
    -- the max amount is 1 and the min is 0
    -- Example: /herovehiclespawnprobability 0.4
    elseif command == "herovehiclespawnprobability" or command == "hvsp" then
        if #messageSplit < 2 then return end
        local amount = tonumber(messageSplit[2])
        if amount == nil then return end
        Console.Execute("AutoPlayers.HeroVehicleSpawnProbability_Gameplay " .. amount)

    -- Makes the ai ignore human players
    -- Example: /aiignorehumans true
    elseif command == "aiignorehumans" or command == "aiih" then
        if #messageSplit < 2 then return end
        local val = messageSplit[2]:lower()
        if val ~= "true" and val ~= "false" then return end
        Console.Execute("AutoPlayers.IgnoreHumanPlayers " .. val)

    -- Sets the probability of ai spawning as a vehicle 
    -- the max amount is 1 and the min is 0
    -- Example: /vehiclespawnprobability 0.4
    elseif command == "vehiclespawnprobability" or command == "vsp" then
        if #messageSplit < 2 then return end
        local amount = tonumber(messageSplit[2])
        if amount == nil then return end
        Console.Execute("AutoPlayers.VehicleSpawnProbability_Gameplay " .. amount)

    -- Configure the amount of inactive time in seconds until someone is kicked
    -- Example: /afktimeout 67
    -- Set it to 0 to disable
    elseif command == "afktimeout" then
        if #messageSplit < 2 then return end
        local amount = tonumber(messageSplit[2])
        if amount == nil or amount < 0 then return end
        Console.Execute("Whiteshark.NoInteractivityTimeoutTime " .. amount)

    elseif command == "setteambyindex" then
        if #messageSplit < 3 then return end
        local playerIndex = tonumber(messageSplit[2])
        local team = tonumber(messageSplit[3])
        if playerIndex == nil or team == nil then return end
        if playerIndex % 1 ~= 0 or team % 1 ~= 0 then return end
        if team ~= 1 and team ~= 2 then return end
        Console.Execute("Kyber.SetTeamByIndex " .. playerIndex .. " " .. team)

    -- Sets the amount of score of a player
    -- Example: /setscore player 1738
    elseif command == "setscore" then
        if #messageSplit < 3 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        local amount = tonumber(messageSplit[3])
        if amount == nil or amount < 0 or amount % 1 ~= 0 then return end
        target:SetScore(amount)

    -- Sets the amount of kills of a player
    -- Example: /setkills player 10
    elseif command == "setkills" then
        if #messageSplit < 3 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        local amount = tonumber(messageSplit[3])
        if amount == nil or amount < 0 or amount % 1 ~= 0 then return end
        target:SetKills(amount)

    -- Sets the amount of assists of a player
    -- Example: /setassists player 9
    elseif command == "setassists" then
        if #messageSplit < 3 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        local amount = tonumber(messageSplit[3])
        if amount == nil or amount < 0 or amount % 1 ~= 0 then return end
        target:SetAssists(amount)

    -- Sets the amount of deaths of a player
    -- Example: /setdeaths 21
    elseif command == "setdeaths" then
        if #messageSplit < 3 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        local amount = tonumber(messageSplit[3])
        if amount == nil or amount < 0 or amount % 1 ~= 0 then return end
        target:SetDeaths(amount)

    -- Sets the weapon of a player
    -- Example: /setweapon player Gameplay/Equipment/Pistols/PingLauncher/U_DefaultAbility_Assault_ScanDart
    elseif command == "setweapon" or command == "sw" then
        if #messageSplit < 3 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        target:SetWeapon(messageSplit[3])

    -- Sets the active character ability of a player by ID
    -- Example: /setability player abilityId
    elseif command == "setability" or command == "sa" then
        if #messageSplit < 3 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        local abilityId = tonumber(messageSplit[3])
        if abilityId == nil or abilityId % 1 ~= 0 then return end
        target:SetAbility(abilityId)

    -- EXPERIMENTAL
    -- Sets the players customization asset by resource name
    -- Example: /setcustomizationasset player assetResourceName
    elseif command == "setcustomizationasset" or command == "sca" then
        if #messageSplit < 3 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        target:SetCustomizationAsset(messageSplit[3])

    -- Grants or revokes a specific unlock on the player by GUID string
    -- Example: /setunlock player assetGuid true
    elseif command == "setunlock" or command == "su" then
        if #messageSplit < 4 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        local val = messageSplit[4]:lower()
        if val ~= "true" and val ~= "false" then return end
        target:SetUnlock(messageSplit[3], val == "true")

    -- Prints a players info on the console
    -- Example: /playerinfo player
    elseif command == "playerinfo" or command == "pi" then
        if #messageSplit < 2 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        print("Name: " .. target.name
        .. " | Kills: " .. tostring(target.kills)
        .. " | Assists: " .. tostring(target.assists)
        .. " | Deaths: " .. tostring(target.deaths)
        .. " | BP: " .. tostring(target.battlepoints)
        .. " | Score: " .. tostring(target.score)
        .. " | ID: " .. tostring(target.playerId)
        .. " | Team: " .. tostring(target.team)
        .. " | Bot: " .. tostring(target.isBot)
        .. " | Alive: " .. tostring(target.isAlive)
        .. " | AFK: " .. tostring(target.afkTime))

    -- Sets the max health of a player
    -- Example: /setmaxhealth 2000
    elseif command == "setmaxhealth" or command == "smh" then
        if #messageSplit < 3 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        local amount = tonumber(messageSplit[3])
        if amount == nil or amount < 1 or amount % 1 ~= 0 then return end
        target:SetMaxHealth(amount)

    elseif command == "setinput" then
        if #messageSplit < 4 then return end
        local target = PlayerManager.GetPlayer(messageSplit[2])
        if target == nil then return end
        local actionId = tonumber(messageSplit[3])
        if actionId == nil or actionId % 1 ~= 0 then return end
        local val = messageSplit[4]:lower()
        if val ~= "true" and val ~= "false" then return end
        target:SetInputEnabled(actionId, val == "true")

    -- Creates a bot player
    -- Example: /createbot JohnKyber
    elseif command == "createbot" or command == "cb" then
        if #messageSplit < 2 then return end
        local team = nil

        if #messageSplit >= 3 then
            team = tonumber(messageSplit[3])
            if team ~= 1 and team ~= 2 then return end
        end

        local bot = PlayerManager.CreatePlayer(messageSplit[2])
        if bot == nil then return end

        if team ~= nil then
            bot:SetTeam(team)
        end

    -- Allows ai to spawn as a vehicle
    -- Example: /allowvehiclespawn true
    elseif command == "allowvehiclespawn" then
        if #messageSplit < 2 then return end
        local val = messageSplit[2]:lower()
        if val ~= "true" and val ~= "false" then return end
        Console.Execute("AutoPlayers.AllowVehicleSpawn " .. val)

    -- Enables the old friendly fire that existed before the squads update
    -- Example: /defaultfriendlyfire true
    elseif command == "defaultfriendlyfire" then
        if #messageSplit < 2 then return end
        local val = messageSplit[2]:lower()
        if val ~= "true" and val ~= "false" then return end
        Console.Execute("Kyber.UseDefaultGameFriendlyFire " .. val)

    --elseif command == "help" then
        --player:SendChatMessage("Available commands: /kick <playername>, /setteam <playername> <teamid>, /swap, /fullteamswap, /givebp <playername> <amount>, /setbp <playername> <amount>, /sethealth <playername> <amount>, /invisible <playername> <true>, /endofround. /endgameteam1, /endgameteam2, /loadlevel, /broadcast <msg>, /crashgame, /shuffleteams, /hotreloadlua, /startgame, /teleport <playernameA> <playernameB>, /teleport <playername> <x> <y> <z>, /setimmortal <playername> <true>, /setfakeimmortal <playername> <true>, /setexplosionmodifier <playername> <amount>, /setspeed <playername> <amount>, /setcooldown <playername> <amount>")
    else
        print("Invalid command: " .. command)
    end
end)
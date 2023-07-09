function getWeeklyAffixes(affix_level)
    --[[
         Grabs weekly Affixes after making a request to
         WoW API for RequestMapInfo since current Affixes
         cannot be pulled. See:
         https://wowpedia.fandom.com/wiki/API_C_MythicPlus.RequestMapInfo
         However, the data for affixes does not populate until RequestMapInfo
         triggers CHALLENGE_MODE_MAPS_UPDATE.
    ]]
    
    local weekly_affixes = {}

    local request = C_MythicPlus.RequestMapInfo() 
    local affixes = C_MythicPlus.GetCurrentAffixes()
    for i=1,3 do
        for k,v in pairs(affixes[i]) do
            if v ~= 0 then
                -- Level 2 Affixes
                if v == 9 then 
                    weekly_affixes[1] = "Tyrannical" 
                elseif v == 10 then 
                    weekly_affixes[1] = "Fortified" 
                -- Level 7 Affixes
                elseif v == 134 then 
                    weekly_affixes[2] = "Entangling"
                elseif v == 135 then 
                    weekly_affixes[2] = "Afflicted"
                elseif v == 136 then 
                    weekly_affixes[2] = "Incorporeal"
                elseif v == 124 then 
                    weekly_affixes[2] = "Storming"
                elseif v == 3 then 
                    weekly_affixes[2] = "Volcanic"   
                -- Level 14 Affixes
                elseif v == 7 then 
                    weekly_affixes[3] = "Bolstering"
                elseif v == 11 then 
                    weekly_affixes[3]  = "Bursting"
                elseif v == 6 then 
                    weekly_affixes[3] = "Raging"
                elseif v == 8 then 
                    weekly_affixes[3] = "Sanguine" 
                elseif v == 13 then 
                    weekly_affixes[3] = "Explosive" 
                elseif v == 123 then 
                    weekly_affixes[3] = "Spiteful"


                -- Affixes Currently Out of Band
                -- elseif v == 12 then 
                --     weekly_affixes[3] = "Grievous"
                -- elseif v == 5 then 
                --     weekly_affixes[2] = "Teeming"   
                -- elseif v == 122 then 
                --     weekly_affixes[2] = "Inspiring"  
                -- elseif v == 14 then 
                --     weekly_affixes[3] = "Quaking" 
                -- elseif v == 4 then 
                --     weekly_affixes[3] = "Necrotic"
                -- elseif v == 1 then 
                --     weekly_affixes[3] = "Overflowing" 
                -- elseif v == 2 then 
                --     weekly_affixes[3] = "Skitish"
                end
            end
        end
    end
    return weekly_affixes[affix_level]
end

function getCurrentMap()
    --[[ 
        Get the map from the active key and
        if it is nil assign it to '9999' so
        the translateMapID function can assign
        the map name to "NoData".
    ]]

    local mapChallengeModeID = C_ChallengeMode.GetActiveChallengeMapID()
    if mapChallengeModeID == 0 then
        mapChallengeModeID = 9999
    elseif mapChallengeModeID == nil then
        mapChallengeModeID  = 9999
    end
    return  mapChallengeModeID
end

function translateMapID(mapId)
    --[[ 
        Translate Key Map ID to Dungeon Name.
        List of Current Challenge Maps pulled from WoW Tools. See:
        (https://wow.tools/dbc/?dbc=mapchallengemode&build=10.0.5.47660#page=1)
    ]]

    local dungeonNameTable = {}
    if mapId ~= 9999 then
        dungeonNameTable = {
            [402]	=	"Algeth'ar Academy",
            [244]	=	"Atal'Dazar",
            [164]	=	"Auchindoun",
            [199]	=	"Black Rook Hold",
            [163]	=	"Bloodmaul Slag Mines",
            [405]	=	"Brackenhide Hollow",
            [233]	=	"Cathedral of Eternal Night",
            [210]	=	"Court of Stars",
            [198]	=	"Darkheart Thicket",
            [377]	=	"De Other Side",
            [197]	=	"Eye of Azshara",
            [245]	=	"Freehold",
            [57]	=	"Gate of the Setting Sun",
            [166]	=	"Grimrail Depot",
            [378]	=	"Halls of Atonement",
            [406]	=	"Halls of Infusion",
            [200]	=	"Halls of Valor",
            [169]	=	"Iron Docks",
            [249]	=	"Kings' Rest",
            [208]	=	"Maw of Souls",
            [375]	=	"Mists of Tirna Scithe",
            [60]	=	"Mogu'shan Palace",
            [206]	=	"Neltharion's Lair",
            [404]	=	"Neltharus",
            [369]	=	"Operation: Mechagon - Junkyard",
            [370]	=	"Operation: Mechagon - Workshop",
            [379]	=	"Plaguefall",
            [227]	=	"Return to Karazhan: Lower",
            [234]	=	"Return to Karazhan: Upper",
            [399]	=	"Ruby Life Pools",
            [380]	=	"Sanguine Depths",
            [77]	=	"Scarlet Halls",
            [78]	=	"Scarlet Monastery",
            [76]	=	"Scholomance",
            [239]	=	"Seat of the Triumvirate",
            [58]	=	"Shado-Pan Monastery",
            [165]	=	"Shadowmoon Burial Grounds",
            [252]	=	"Shrine of the Storm",
            [353]	=	"Siege of Boralus",
            [59]	=	"Siege of Niuzao Temple",
            [161]	=	"Skyreach",
            [381]	=	"Spires of Ascension",
            [56]	=	"Stormstout Brewery",
            [392]	=	"Tazavesh: So'leah's Gambit",
            [391]	=	"Tazavesh: Streets of Wonder",
            [250]	=	"Temple of Sethraliss",
            [2]	=	"Temple of the Jade Serpent",
            [209]	=	"The Arcway",
            [401]	=	"The Azure Vault",
            [168]	=	"The Everbloom",
            [247]	=	"The MOTHERLODE!!",
            [376]	=	"The Necrotic Wake",
            [400]	=	"The Nokhud Offensive",
            [251]	=	"The Underrot",
            [382]	=	"Theater of Pain",
            [246]	=	"Tol Dagor",
            [403]	=	"Uldaman: Legacy of Tyr",
            [167]	=	"Upper Blackrock Spire",
            [207]	=	"Vault of the Wardens",
            [402]	=	"Waycrest Manor",
            [438]   =   "Vortex Pinnacle"
        }
    else dungeonNameTable[mapId] = "NoData"
    end
    return dungeonNameTable[mapId]
end

function getKeyTimeLimit()
    -- Returns TimeLimit of the Key in Seconds

    local map = C_ChallengeMode.GetCompletionInfo()
    local name, id, timeLimit = C_ChallengeMode.GetMapUIInfo(getCurrentMap())
    return timeLimit
end

function getCurrentKeyLevel()
    -- Get Active Key Level

    local activeKeystoneLevel, activeAffixIDs, wasActiveKeystoneCharged = C_ChallengeMode.GetActiveKeystoneInfo()
    return activeKeystoneLevel
end
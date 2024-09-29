-- Instantiate tables
local weeklyAffixesTbl = {}
local translatedTbl = {}
local currentAffixesTbl = {}
local affixNameTbl = {
    [1] = "Overflowing",
    [2] = "Skittish",
    [3] = "Volcanic",
    [4] = "Necrotic",
    [5] = "Teeming",
    [6] = "Raging",
    [7] = "Bolstering",
    [8] = "Sanguine",
    [9] = "Tyrannical",
    [10] = "Fortified",
    [11] = "Bursting",
    [12] = "Grievous",
    [13] = "Explosive",
    [14] = "Quaking",
    [122] = "Inspiring",
    [123] = "Spiteful",
    [124] = "Storming",
    [134] = "Entangling",
    [135] = "Afflicted",
    [136] = "Incorporeal",
    [147] = "Xal'atath's Guile",
    [148] = "Xal'atath's Bargain: Ascendant",
    [152] = "Challenger's Peril",
    [158] = "Xal'atath's Bargain: Voidbound",
    [159] = "Xal'atath's Bargain: Oblivion",
    [160] = "Xal'atath's Bargain: Devour"
}



--[[
-- Returns a table of weekly Affixes after making a request to
-- the WoW API for RequestMapInfo. See:
-- https://wowpedia.fandom.com/wiki/API_C_MythicPlus.RequestMapInfo
-- The data for affixes does not populate until RequestMapInfo
-- triggers the in-game event CHALLENGE_MODE_MAPS_UPDATE or
-- MYTHIC_PLUS_CURRENT_AFFIX_UPDATE
]]
function getAffixIds()
    C_MythicPlus.RequestMapInfo()
    local affixes = C_MythicPlus.GetCurrentAffixes()

    for _,tbl in pairs(affixes) do
       local id = tbl["id"] or nil
       if id ~= nil then
          table.insert(currentAffixesTbl, id)            
       end
    end    
 end

--[[
-- Returns a table of the translated weekly affix names derived
-- from the affix ids.
--
-- @param affixesTable the weeks current affixes
]]
 function translateAffixIds(affixesTable)
    getAffixIds()
    for _,id in ipairs(affixesTable) do
       local translatedId = affixNameTbl[id] or nil
       table.insert(translatedTbl, translatedId)
    end
    return translatedTbl
 end 

 --[[
-- Returns the name of the affix for the level (1, 2, 3, 4, 5)
-- that is passed in. 
-- Level 1 affix starts at Keystone Level 2.
-- Level 2 affix starts at Keystone level 4.
-- Level 3 affix starts at Keystone level 7.
-- Level 4 affix starts at Keystone level 10.
-- Level 5 affix starts at Keystone level 12.

-- @param affix_level level of affix
 ]]
function getWeeklyAffixes(affix_level)
    local weeklyAffixesTbl = translateAffixIds(currentAffixesTbl)
    return weeklyAffixesTbl[affix_level]
end


--[[ 
-- Returns the challenge mode map id based on the players 
-- current location. If player is not in a dungeon at the
-- time of the call (id=0 or nil) the function returns the
-- dummy value of 9999.
]]
function getCurrentMap()
    local mapChallengeModeID = C_ChallengeMode.GetActiveChallengeMapID()
    if mapChallengeModeID == 0 then
        mapChallengeModeID = 0999
    elseif mapChallengeModeID == nil then
        mapChallengeModeID  = 9999
    end
    return  mapChallengeModeID
end

--[[ 
-- Returns the translated challenge mode map id to dungeon name.
-- Map id is pulled from getCurrentMap() and if player is not
-- in a dungeon for the call or the function returns nil a dummy 
-- value of 9999 is provided.
-- Dummy value of 9999 returns 'NoData' to csvDataStruct().
-- List of current challenge maps pulled from Wago Tools. See:
-- https://wago.tools/db2/MapChallengeMode
--
-- @param mapId current challenge mode map id of user
]]
function translateMapID(mapId)
    local challengeModeMapTbl = {}
    if mapId ~= 9999 then
        challengeModeMapTbl = {
            [402]	=	"Algeth'ar Academy",
            [503]   =   "Ara-Kara, City of Echoes",
            [244]	=	"Atal'Dazar",
            [164]	=	"Auchindoun",
            [199]	=	"Black Rook Hold",
            [163]	=	"Bloodmaul Slag Mines",
            [405]	=	"Brackenhide Hollow",
            [233]	=	"Cathedral of Eternal Night",
            [502]   =   "City of Threads",
            [506]   =   "Cinderbew Meadery",
            [210]	=	"Court of Stars",
            [504]   =   "Darkflame Cleft",
            [198]	=	"Darkheart Thicket",
            [463]   =   "Dawn of the Infinite: Galakrond's Fall",
            [464]   =   "Dawn of the Infinite: Murozond's Rise",
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
            [499]   =   "Priory of the Sacred Flame",
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
            [2]	    =	"Temple of the Jade Serpent",
            [209]	=	"The Arcway",
            [401]	=	"The Azure Vault",
            [505]   =   "The Dawnbreaker",
            [168]	=	"The Everbloom",
            [247]	=	"The MOTHERLODE!!",
            [376]	=	"The Necrotic Wake",
            [400]	=	"The Nokhud Offensive",
            [500]   =   "The Rookery",
            [501]   =   "The Stonevault",
            [251]	=	"The Underrot",
            [382]	=	"Theater of Pain",
            [456]   =   "Throne of the Tides",
            [246]	=	"Tol Dagor",
            [403]	=	"Uldaman: Legacy of Tyr",
            [167]	=	"Upper Blackrock Spire",
            [207]	=	"Vault of the Wardens",
            [402]	=	"Waycrest Manor",
            [438]   =   "Vortex Pinnacle"
        }
    elseif mapId == 9999 then
        name = GetInstanceInfo()
        challengeModeMapTbl[mapId] = name
    else challengeModeMapTbl[mapId] = "NoData"
    end
    return challengeModeMapTbl[mapId]
end

-- Returns TimeLimit of the Key in Seconds
function getKeyTimeLimit()
    local map = C_ChallengeMode.GetCompletionInfo()
    local name, id, timeLimit = C_ChallengeMode.GetMapUIInfo(getCurrentMap())
    return timeLimit
end

-- Returns current keystone level of keystone in player's inventory
function getCurrentKeyLevel()
    local activeKeystoneLevel, activeAffixIDs, wasActiveKeystoneCharged = C_ChallengeMode.GetActiveKeystoneInfo()
    return activeKeystoneLevel
end

--[[
-- Returns the value of "Timed" or "Deplete" or "Abandon"
-- depending on if a key is completed within time (Timed), 
-- completed but not in time (Deplete), or if the players
-- disband the party before completion (Abandon).

]]
function checkKeyResult()
    local mapChallengeModeID, level, time, onTime = C_ChallengeMode.GetCompletionInfo()
    local isFull = C_PartyInfo.IsPartyFull()
    if isFull ~= false then
        if onTime == true then
            return "Timed"
        else 
            return "Deplete"
        end
    else
        return "Abandon"
    end
end

--[[
-- Returns the io before the dungeon or after the dungeon
-- depending on the request given.
--
-- @param request the requested time of before or after the dungeon.
]]

function checkIO(request)
    local mapChallengeModeID, level, time, onTime, keystoneUpgradeLevels, practiceRun,
    oldOverallDungeonScore, newOverallDungeonScore, IsMapRecord, IsAffixRecord,
    PrimaryAffix, isEligibleForScore, members
       = C_ChallengeMode.GetCompletionInfo()
    if request == "old" and oldOverallDungeonScore ~= nil then 
        return oldOverallDungeonScore  
    elseif request =="new" and newOverallDungeonScore ~= nil then
        return newOverallDungeonScore
    else
        return "IO Not Found"
    end
end
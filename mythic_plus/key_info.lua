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
    [136] = "Incorporeal"
}


--[[
-- Returns a table of weekly Affixes after making a request to
-- the WoW API for RequestMapInfo. See:
-- https://wowpedia.fandom.com/wiki/API_C_MythicPlus.RequestMapInfo
-- The data for affixes does not populate until RequestMapInfo
-- triggers the in-game event CHALLENGE_MODE_MAPS_UPDATE.
]]
function getAffixIds()
    local request = C_MythicPlus.RequestMapInfo() 
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
       translatedId = affixNameTbl[id] or nil
       table.insert(translatedTbl, translatedId)
    end
    return translatedTbl
 end 

 --[[
-- Returns the name of the affix for the level (1, 2, 3)
-- that is passed in. 
-- Level 1 affix starts at Keystone Level 2.
-- Level 2 affix starts at Keystone level 7.
-- Level 3 affix starts at Keystone level 14

-- @param affix_level level of affix
 ]]
function getWeeklyAffixes(affix_level)
     
    weeklyAffixesTbl = translateAffixIds(currentAffixesTbl)
    return weeklyAffixesTbl[affix_level]
end


--[[ 
-- Get the map from the active key and
-- if it is nil assign it to '9999' so
-- the translateMapID function can assign
-- the map name to "NoData".
]]
function getCurrentMap()


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
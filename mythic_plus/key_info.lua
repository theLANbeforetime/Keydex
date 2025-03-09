-- All C_<> are unndefined globals and are calls to the WoW API meant to be ran
-- in the game.

-- Instantiate tables
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
    [147] = "Xal'atath's Guile", -- Replace's level 2 affix (Xal'atath's Bargain) at 12+
    [148] = "Ascendant", -- Xal'atath's Bargain
    [152] = "Challenger's Peril",
    [158] = "Voidbound", -- Xal'atath's Bargain
    [159] = "Oblivion", -- Xal'atath's Bargain
    [160] = "Devour", -- Xal'atath's Bargain
    [162] = "Pulsar" -- Xal'atath's Bargain
}

---Makes a call to WoW API to get the map info which then allows a call
---to get the current affixes. The data for affixes does NOT populate until
---a successful RequestMapInfo call. It then updates the global table with the 
---affixes for the week.
---See: https://wowpedia.fandom.com/wiki/API_C_MythicPlus.RequestMapInfo
--- Related events: CHALLENGE_MODE_MAPS_UPDATE or MYTHIC_PLUS_CURRENT_AFFIX_UPDATE
function GetAffixIds()
    C_MythicPlus.RequestMapInfo()
    local affixes = C_MythicPlus.GetCurrentAffixes()

    for _,tbl in pairs(affixes) do
       local id = tbl["id"] or nil
       if id ~= nil then
          table.insert(currentAffixesTbl, id)
       end
    end
 end

---Organizes the weekly affix ids into a table of affix strings for consumption.
---@param affixesTable table table of affixes in id format
---@return table translatedTbl table of affixes in string format
 function TranslateAffixIds(affixesTable)
    GetAffixIds()
    for _,id in ipairs(affixesTable) do
       local translatedId = affixNameTbl[id] or nil
       table.insert(translatedTbl, translatedId)
    end
    return translatedTbl
 end

 ---Pulls the affix name from the weekly affixes based 
 ---which position the affix is.
 ---@param affix_level integer the position of the affix you want to pull (1, 2, 3, 4, or 5.)
 ---@return string affix_name the name of the affix for the affix_level pulled
function GetWeeklyAffixes(affix_level)
    --TODO: Kind of nested might want to refactor and clean up the call tree.
    local weeklyAffixesTbl = TranslateAffixIds(currentAffixesTbl)
    return weeklyAffixesTbl[affix_level]
end

---Utilizes call to WoW API to get active keystone map id.
---@return integer mapChallengeModeId integer representation of current map
function GetCurrentMap()
    local mapChallengeModeId = C_ChallengeMode.GetActiveChallengeMapID()
    if mapChallengeModeId == 0 then
        mapChallengeModeId = 0999
    elseif mapChallengeModeId == nil then
        mapChallengeModeId  = 9999
    end
    return  mapChallengeModeId
end

---Converts the challenge mode map id from an integer to a string.
---If the data cannot be pulled then a value of 9999 is returned.
---Maps are pulled from Wago Tools: https://wago.tools/db2/MapChallengeMode
---@param mapId integer the id from the GetCurrentMap() call 
---@return string mapName the name of the challenge mode map
function TranslateMapID(mapId)
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
            [525]   =   "Operation: Floodgate",
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
            [248]	=	"Waycrest Manor",
            [438]   =   "Vortex Pinnacle"
        }
    elseif mapId == 9999 then
        -- GetInstanceInfo() is a WoW API call: https://wowwiki-archive.fandom.com/wiki/API_GetInstanceInfo
        local name = GetInstanceInfo()
        challengeModeMapTbl[mapId] = name
    else challengeModeMapTbl[mapId] = "NoData"
    end
    return challengeModeMapTbl[mapId]
end



---Requests the time limit of the current active keystone.
---@return integer timelimit measured in seconds
function GetKeyTimeLimit()
    local map = C_ChallengeMode.GetCompletionInfo()
    local name, id, timeLimit = C_ChallengeMode.GetMapUIInfo(GetCurrentMap())
    return timeLimit
end

---Returns the keystone level of the active key.
---@return integer level returns level of active keystone i.e. +10 -> 10
function GetCurrentKeyLevel()
    local activeKeystoneLevel, activeAffixIDs, wasActiveKeystoneCharged = C_ChallengeMode.GetActiveKeystoneInfo()
    return activeKeystoneLevel
end

---Checks the result of the key at the end. 
---Assumes that if the party is not full the key is an Abandon.
---@return string result final result of the key if it was timed, depleted, or abandoned.
function CheckKeyResult()
    local mapChallengeModeId, level, time, onTime = C_ChallengeMode.GetCompletionInfo()
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

---Makes a call to WoW API C_ChallengeMode.GetCompetionInfo to get
---current players IO at the start of the dungeon and at the end of the dungeon.
---@param request string either "new" or "old"
---@return (integer|string) score returns score as integer (success) or string (fail)
function CheckIO(request)
    local mapChallengeModeId, level, time, onTime, keystoneUpgradeLevels, practiceRun,
    oldOverallDungeonScore, newOverallDungeonScore, IsMapRecord, IsAffixRecord,
    PrimaryAffix, isEligibleForScore, members
       = C_ChallengeMode.GetCompletionInfo()
    if request == "old" and oldOverallDungeonScore ~= nil then
        return oldOverallDungeonScore
    elseif request == "new" and newOverallDungeonScore ~= nil then
        return newOverallDungeonScore
    else
        return "Failed to pull IO"
    end
end
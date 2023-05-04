-- WoW Key Codex (Keydex)

local openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0")

-- Get Date of Instance Run
function getDate()
    currentDate = date("%m/%d/%y")
    return currentDate
end

-- Get Player Data
function getPlayerInformation(arg)
    local sentRequest = openRaidLib.RequestAllData()
    local unitInfo = openRaidLib.GetUnitInfo("player")
    local playerGear = openRaidLib.GetUnitGear("player")

    playerTable = {}
    playerTable["playerName"] = unitInfo.name
    playerTable["playeriLevel"] = playerGear.ilevel
    playerTable["playerRole"] = unitInfo.role
    playerTable["playerSpec"] = unitInfo.specName

    return playerTable[arg]
 end 

-- Get Weekly Affixes
function getWeeklyAffixes(arg)
    local RequestMapInfo = C_MythicPlus.RequestMapInfo()
    local affixes = C_MythicPlus.GetCurrentAffixes()
    local r_affixes = {}
    -- Pull first three affixes; after 10.1 will likely have to re-evaluate best way to pull affixes.
    for i=1,3 do
        for k,v in pairs(affixes[i]) do
            if v ~= 0 then
                -- Level 2 Affixes
                if v == 9 then 
                    r_affixes[1] = "Tyrannical" 
                elseif v == 10 then 
                    r_affixes[1] = "Fortified" 
                -- Level 4 Affixes
                elseif v == 5 then 
                    r_affixes[2] = "Teeming" 
                elseif v == 6 then 
                    r_affixes[2] = "Raging" 
                elseif v == 7 then 
                    r_affixes[2] = "Bolstering" 
                elseif v == 8 then 
                    r_affixes[2] = "Sanguine"
                elseif v == 11 then 
                    r_affixes[2]  = "Bursting" 
                elseif v == 122 then 
                    r_affixes[2] = "Inspiring" 
                elseif v == 123 then 
                    r_affixes[2] = "Spiteful" 
                -- Level 7 Affixes
                elseif v == 13 then 
                    r_affixes[3] = "Explosive" 
                elseif v == 3 then 
                    r_affixes[3] = "Volcanic" 
                elseif v == 12 then 
                    r_affixes[3] = "Grievous" 
                elseif v == 124 then 
                    r_affixes[3] = "Storming" 
                elseif v == 14 then 
                    r_affixes[3] = "Quaking" 
                elseif v == 4 then 
                    r_affixes[3] = "Necrotic"
                elseif v == 1 then 
                    r_affixes[3] = "Overflowing" 
                elseif v == 2 then 
                    r_affixes[3] = "Skitish"
                end
            end
        end
    end
    -- Level 10 Affix
    r_affixes[4] = "Thundering"
    return r_affixes[arg]
end
 
-- Get Active Key Level
function getCurrentKeyLevel()
    local activeKeystoneLevel, activeAffixIDs, wasActiveKeystoneCharged = C_ChallengeMode.GetActiveKeystoneInfo()
    return activeKeystoneLevel
end

-- Get Active Key Map
function getCurrentMap()
    local mapChallengeModeID = C_ChallengeMode.GetActiveChallengeMapID()
    if mapChallengeModeID == 0 then
        mapChallengeModeID = 9999
    elseif mapChallengeModeID == nil then
        mapChallengeModeID  = 9999
    end
return  mapChallengeModeID
end

-- Translate Key Map ID to Dungeon Name
function translateMapID(arg)
    -- List of Current Challenge Maps pulled from WoW Tools (https://wow.tools/dbc/?dbc=mapchallengemode&build=10.0.5.47660#page=1)
    local dungeonNameTable = {}
    if arg ~= 9999 then
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
        }
    else dungeonNameTable[arg] = "NoData"
    end
    
    return dungeonNameTable[arg]
end

-- Returns TimeLimit of the Key in Seconds
function getKeyTimeLimit()
    local map = C_ChallengeMode.GetCompletionInfo()
    local name, id, timeLimit = C_ChallengeMode.GetMapUIInfo(getCurrentMap())

    return timeLimit
end



function escapeCSV(s)
    if string.find(s, '[,"]') then
      s = '"' .. string.gsub(s, '"', '""') .. '"'
    end
    return s
  end

function toCSV(tt)
    local s = ""
  -- ChM 23.02.2014: changed pairs to ipairs 
  -- assumption is that fromCSV and toCSV maintain data as ordered array
    for _,p in ipairs(tt) do  
      s = s .. "," .. escapeCSV(p)
    end
    return string.sub(s, 2)      -- remove first comma
  end

  

 -- Create structure to store data that will be copied.
 -- TODO: Make this dynamic so players can choose how they want to structure 
 -- own data in CSV format.
 function csvDataStruct()
    local sheetTable = {}
    
    sheetTable[1] = getDate()
    sheetTable[2] = getPlayerInformation("playerName")
    sheetTable[3] = translateMapID(getCurrentMap())
    sheetTable[4] = getCurrentKeyLevel()
    sheetTable[5] = getWeeklyAffixes(1)
    sheetTable[6] = getWeeklyAffixes(2)
    sheetTable[7] = getWeeklyAffixes(3)
    -- sheetTable[8] = getKeyCompletion()
    -- sheetTable[9] = getGroupComposition("Tank")
    -- sheetTable[10] = getGroupComposition("Healer")
    -- sheetTable[11] = getGroupComposition("Dmg1")
    -- sheetTable[12]= getGroupComposition("Dmg2")
    -- sheetTable[13] = getGroupComposition("Dmg3")
    -- sheetTable[14] = getQuickNote()
    
    return sheetTable
 end 

--  Events I need to add functions for:
-- C_ChallengeMode
-- CHALLENGE_MODE_COMPLETED
-- CHALLENGE_MODE_DEATH_COUNT_UPDATED
-- CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN
-- CHALLENGE_MODE_KEYSTONE_SLOTTED: keystoneID
-- CHALLENGE_MODE_LEADERS_UPDATE
-- CHALLENGE_MODE_MAPS_UPDATE
-- CHALLENGE_MODE_MEMBER_INFO_UPDATED
-- CHALLENGE_MODE_RESET: mapID
-- CHALLENGE_MODE_START: mapID


-- Function Get_Dungeon()
--  On key start get Dungeon Name
-- Return Dungeon Name

-- Function Get Key Level ()
--  On key start get Key Level
-- Return Key Level

-- Function Get Player Data ()
-- On key start
--  Get Name
--  Get Class
--  Get Spec
--  Get iLvl
-- Return Name, Class, Spec, iLvl

-- Function Get Party Data ()
-- GetSpecializationInfoByID(spec)
-- partyOne = {}
-- partyTwo = {}
-- On key start
--  For member in party:
--      Get Name ~> 
--      Get Class
--      Get Spec
--      Get iLvl
-- Return Party NumArray

-- Function Spec Sort ()

-- function MyAddonObject.OnGearUpdate(unitId, unitGear, allUnitsGear)
--     local itemLevelNumber = unitGear.ilevel
--     local durabilityNumber = unitGear.durability
--     --hasWeaponEnchant is 1 have enchant or 0 is don't
--     local hasWeaponEnchantNumber = unitGear.weaponEnchant
--     local noEnchantTable = unitGear.noEnchants
--     local noGemsTable = unitGear.noGems

--     for index, slotIdWithoutEnchant in ipairs(noEnchantTable) do
--     end

--     for index, slotIdWithEmptyGemSocket in ipairs(noGemsTable) do
--     end
-- end

-- --registering the callback:
-- openRaidLib.RegisterCallback(MyAddonObject, "GearUpdate", "OnGearUpdate")

function getPartyInformation(partyNum, ...)

    local unitInfo = openRaidLib.GetUnitInfo(partyNum)
    local playerGear = openRaidLib.GetUnitGear(partyNum)

    partyTable = {}
    if unitInfo ~= nil then
        partyTable["partyName"] = unitInfo.name
        partyTable["partyRole"] = unitInfo.role
        partyTable["partySpecName"] = unitInfo.specName
        partyTable["partyiLevel"] = playerGear.ilevel
    else partyTable[...] = "unknown" end
    return partyTable[...]

end

local frame = CreateFrame("FRAME", "KeydexAddonFrame");
frame:RegisterEvent("CHALLENGE_MODE_START");
local function eventHandler(self, event, ...)
 print(getDate(), getPlayerInformation("playeriLevel"), getWeeklyAffixes(1), getWeeklyAffixes(2), getWeeklyAffixes(3), getWeeklyAffixes(4), getCurrentMap(), getCurrentKeyLevel());
end
frame:SetScript("OnEvent", eventHandler);


StaticPopupDialogs["KEYDEX_COPYWINDOW"] = {
    text = "Copy the string below and import it to your preferred spreadsheet.",
    button1 = "Done",
    button2 = "Cancel",
    OnShow = function (self, data)
        self.editBox:SetText(toCSV(csvDataStruct()))
    end,
    timeout = 0,
    hasEditBox = true,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
  }
  
-- OnShow = function (self, data)
--     self.editBox:SetText("Some text goes here")
-- end,
-- OnAccept = function (self, data, data2)
--     local text = self.editBox:GetText()
--     -- do whatever you want with it
-- end,
-- hasEditBox = true



 -- SLASH COMMANDS FOR TESTING
 SLASH_KEY1, SLASH_KEY2 = '/keyd', "/keydex";
function SlashCmdList.KEY(msg, editBox)

    if msg then msg = string.lower( msg ); end
    --if msg == "test" then
         StaticPopup_Show ("KEYDEX_COPYWINDOW")

    -- TESTING OF FUNCTIONS
        print("Current date is: ", getDate())
        print("Your Item Level is: ", getPlayerInformation("playeriLevel"))
        print("Weekly Affixes are: ", getWeeklyAffixes(1), getWeeklyAffixes(2), getWeeklyAffixes(3), getWeeklyAffixes(4))
        print("Current Key Level: ", getCurrentKeyLevel())
        print("Current Map is: ", translateMapID(getCurrentMap()))
        print(getCurrentMap())
        print("Party One Information: ", getPartyInformation("party1", "partyName", "partyRole", "partySpecName", "partyiLevel"))
        print("Party Two Information: ", getPartyInformation("party2", "partyName", "partyRole", "partySpecName", "partyiLevel"))
        print("Party Three Information: ", getPartyInformation("party3", "partyName", "partyRole", "partySpecName", "partyiLevel"))
        print("Party Four Information: ", getPartyInformation("party4", "partyName", "partyRole", "partySpecName", "partyiLevel"))
        -- print(getKeyCompletion())
        print(getKeyTimeLimit())
    --end 
end


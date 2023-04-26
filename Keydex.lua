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

 -- Get key information 

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
 
 -- Create structure to store data that will be copied.
 -- TODO: Make this dynamic so players can choose how they want to structure 
 -- own data in CSV format.
--  function csvDataStruct(arg)
--     sheetTable = {}
--     sheetTable[1] = getDate()
--     sheetTable[2] = getPlayerInformation("playerName")
--     sheetTable[3] = getKeyDungeonName()
--     sheetTable[4] = getKeyDungeonLevel()
--     sheetTable[5] = getWeeklyAffixes(1)
--     sheetTable[6] = getWeeklyAffixes(2)
--     sheetTable[7] = getWeeklyAffixes(3)
--     sheetTable[8] = getKeyCompletion()
--     sheetTable[9] = getGroupComposition("Tank")
--     sheetTable[10] = getGroupComposition("Healer")
--     sheetTable[11] = getGroupComposition("Dmg1")
--     sheetTable[12]= getGroupComposition("Dmg2")
--     sheetTable[13] = getGroupComposition("Dmg3")
--     sheetTable[14] = getQuickNote()
--     return sheetTable[arg]
--  end 

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


-- Function Get Weekly Affixes ()

-- local function RequestMythicPlusData()
--     C_MythicPlus.RequestCurrentAffixes()
--     C_MythicPlus.RequestMapInfo()
--  end

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

function getPartyInformation(arg)
    -- UnitID:
    --UnitID use: "player", "target", "raid18", "party3", etc...
    --If passing the unit name, use GetUnitName(unitId, true) or Ambiguate(playerName, 'none')

    -- unitInfo = {
    --     .specId = number
    --     .specName = string
    --     .role = string
    --     .renown = number
    --     .covenantId = number
    --     .talents = {talentId, talentId, talentId, ...}
    --     .pvpTalents = {talentId, talentId, talentId}
    --     .conduits = {spellId, conduitLevel, spellId, conduitLevel, spellId, conduitLevel, ...}
    --     .class = string class eng name 'ROGUE'
    --     .classId = number
    --     .className = string class localized name
    --     .name = string name without realm
    --     .nameFull = string name with realm 'unitName-ServerName'
    -- }
    -- Get Party Members Information
    -- local allPlayersGear = openRaidLib.GetAllUnitsGear()
    -- local allUnitsInfo = openRaidLib.GetAllUnitsInfo()

    local unitInfo = openRaidLib.GetUnitInfo("party1")
    local playerGear = openRaidLib.GetUnitGear("party1")

    partyTable = {}
    if unitInfo ~= nil then
        partyTable["partyName"] = unitInfo.name
        partyTable["partyRole"] = unitInfo.role
        partyTable["partySpecName"] = unitInfo.specName
        partyTable["partyiLevel"] = playerGear.ilevel
    else partyTable[arg] = "unknown" end
    return partyTable[arg]

end

local frame = CreateFrame("FRAME", "KeydexAddonFrame");
frame:RegisterEvent("CHALLENGE_MODE_START");
local function eventHandler(self, event, ...)
 print(getDate(), getPlayerInformation("playeriLevel"));
end
frame:SetScript("OnEvent", eventHandler);


StaticPopupDialogs["KEYDEX_COPYWINDOW"] = {
    text = "Copy the string below and import it to your preferred spreadsheet.",
    button1 = "Done",
    button2 = "Cancel",
    OnShow = function (self, data)
        self.editBox:SetText(csvOutputTxt)
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
 SLASH_KEY1, SLASH_KEY2 = '/key', "/keydex";
function SlashCmdList.KEY(msg, editBox)

    if msg then msg = string.lower( msg ); end

    --if msg == "test" then
        -- StaticPopup_Show ("KEYDEX_COPYWINDOW")
        print(getDate())
        print(getPlayerInformation("playeriLevel"))
        print(getPartyInformation("partyName"))
        print(getPartyInformation("partySpecName"))
        print(getPartyInformation("partyRole"))
        print(getPartyInformation("partyiLevel"))
        -- print(getPlayerInformation("partyOne"))
        -- print(getPlayerInformation("specName"))
        -- print(getPlayerInformation("roundedEquipped")) 
        print(getWeeklyAffixes(1))
        print(getWeeklyAffixes(2))
        print(getWeeklyAffixes(3))
        print(getWeeklyAffixes(4))
    --end 
end


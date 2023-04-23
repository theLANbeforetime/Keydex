-- WoW Key Codex (Keydex)

local openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0")

-- Function Get Date ()
function getDate()
    currentDate = date("%m/%d/%y")
    return currentDate
end

-- Function Get Weekly Affixes ()

-- local function RequestMythicPlusData()
--     C_MythicPlus.RequestCurrentAffixes()
--     C_MythicPlus.RequestMapInfo()
--  end
 

-- function getWeeklyAffixes(arg)
--     r_affixes = {}
--      local affixes = C_MythicPlus.GetCurrentAffixes()
--     -- Pull first three affixes; after 10.1 will likely have to re-evaluate best way to pull affixes.
--     for i=1,3 do
--         for k,v in pairs(affixes[i]) do
--             if v ~= 0 then
--                 if v == 9 then r_affixes[1] = "Tyrannical" end
--                 if v == 10 then r_affixes[1] = "Fortified" end
--                 if v == 11 then r_affixes[2]  = "Bursting" end
--             end
--         end
--     end
--     return r_affixes[arg]
-- end
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
-- Rounding function for item level.
function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

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

function getPlayerInformation(arg)
    local sentRequest = openRaidLib.RequestAllData()
    local playerGear = openRaidLib.GetUnitGear("player")
    -- local party1Gear = openRaidLib.GetUnitGear("party1")
    -- playerName = UnitName("player")
    -- specId, specName = GetSpecializationInfo(GetSpecialization())
    -- overall, equipped = GetAverageItemLevel()

    -- roundedEquipped = round(equipped, 2)

    playerTable = {}
    playerTable["playerName"] = playerGear.ilevel
    -- playerTable["partyOne"] = party1Gear.ilevel
    -- playerTable["specName"] =  specName
    -- playerTable["roundedEquipped"] = roundedEquipped

    return playerTable[arg]
 end 

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
    else partyTable[arg] = "Player data cannot be retrieved at this time." end
    return partyTable[arg]

end


 -- SLASH COMMANDS FOR TESTING
 SLASH_KEY1, SLASH_KEY2 = '/key', "/keydex";
function SlashCmdList.KEY(msg, editBox)

    if msg then msg = string.lower( msg ); end

    --if msg == "test" then
        print(getDate())
        print(getPlayerInformation("playerName"))
        print(getPartyInformation("partyName"))
        print(getPartyInformation("partySpecName"))
        print(getPartyInformation("partyRole"))
        print(getPartyInformation("partyiLevel"))
        -- print(getPlayerInformation("partyOne"))
        -- print(getPlayerInformation("specName"))
        -- print(getPlayerInformation("roundedEquipped")) 
        -- print(getWeeklyAffixes(1))
    --end 
end


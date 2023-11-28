-- WoW Key Codex (Keydex)

-- Initialize WoWAce
Keydex = LibStub("AceAddon-3.0"):NewAddon("Keydex", "AceConsole-3.0", "AceEvent-3.0")
openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0")

--[[
-- Code that is ran on the initialization of the addon.
-- After 5 seconds sends the initial requests to the 
-- WoW API for C_MythicPlus.RequestMapInfo() and 
-- C_MythicPlus.GetCurrentAffixes(). This triggers 
-- the event "MYTHIC_PLUS_CURRENT_AFFIX_UPDATE".
]]
function Keydex:OnInitialize()
    C_Timer.After(5, initialRequestsForEvents)

end

function Keydex:OnEnable()
	
end

function Keydex:OnDisable()
	-- Called when the addon is disabled
end
--[[
-- Returns two requests to the WoW API that are required
-- for pulling the affixes for the week.
]]--
function initialRequestsForEvents()
    return C_MythicPlus.RequestMapInfo(), C_MythicPlus.GetCurrentAffixes()
end

function getDate()
    -- Get Date of Instance Run

    currentDate = date("%m/%d/%y")
    return currentDate
end

function openRaidLib.OnUnitUpdate(unitId, unitInfo, allUnitsInfo)
    for unitName, unitInfo in pairs(allUnitsInfo) do
        local specId = unitInfo.specId
        local specName = unitInfo.specName
        local role = unitInfo.role
        local renown = unitInfo.renown
        local covenantId = unitInfo.covenantId
        local talents = unitInfo.talents
        local pvpTalents = unitInfo.pvpTalents
        local conduits = unitInfo.conduits
        local class = unitInfo.class
        local classId = unitInfo.classId
        local className = unitInfo.className
        local unitName = unitInfo.name
        local unitNameFull = unitInfo.nameFull
    end
end

openRaidLib.RegisterCallback(openRaidLib, "UnitInfoUpdate", "OnUnitUpdate")

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

function Keydex:CHALLENGE_MODE_START()
    exportOutput = toCSV(csvDataStruct())
end
Keydex:RegisterEvent("CHALLENGE_MODE_START");

function Keydex:CHALLENGE_MODE_COMPLETED()
    StaticPopup_Show ("KEYDEX_COPYWINDOW")
end
Keydex:RegisterEvent("CHALLENGE_MODE_COMPLETED");

--[[
-- Returns getAffixIds() table of affixes 5 seconds after
-- the event "MYTHIC_PLUS_CURRENT_AFFIX_UPDATE" is fired.
-- This event is naturally fired at the start of each M+
-- run, but also manually on the initialization of Keydex
-- via Keydex:OnInitialize() by way of a call to 
-- initialRequestsForEvents().
]]
function Keydex:MYTHIC_PLUS_CURRENT_AFFIX_UPDATE()
    C_Timer.After(5, getAffixIds)
end
Keydex:RegisterEvent("MYTHIC_PLUS_CURRENT_AFFIX_UPDATE")



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

  
 function csvDataStruct()
    -- Function to build the CSV data we push out into the StaticDiaglogPopup
    
    local sheetTable = {}
    -- Table will not print after null value.
    sheetTable[1] = getDate()
    sheetTable[2] = getPlayerInformation("playerName")
    sheetTable[3] = translateMapID(getCurrentMap())
    sheetTable[4] = getCurrentKeyLevel()
    if getCurrentKeyLevel() <= 6 then
        sheetTable[5] = getWeeklyAffixes(1)
        sheetTable[6] = ''
        sheetTable[7] = ''
    elseif (getCurrentKeyLevel() >= 7 and getCurrentKeyLevel() <=13) then
        sheetTable[5] = getWeeklyAffixes(1)
        sheetTable[6] = getWeeklyAffixes(2)
        sheetTable[7] = ''
    elseif getCurrentKeyLevel() >= 14 then
        sheetTable[5] = getWeeklyAffixes(1)
        sheetTable[6] = getWeeklyAffixes(2)
        sheetTable[7] = getWeeklyAffixes(3)
    else
        sheetTable[5] = ''
        sheetTable[6] = ''
        sheetTable[7] = ''
    end
    sheetTable[8] = checkKeyResult()
    sheetTable[9] = sortPartyRolesAndSpec("tank")
    sheetTable[10] = sortPartyRolesAndSpec("healer")
    sheetTable[11] = sortPartyRolesAndSpec("dps1")
    sheetTable[12] = sortPartyRolesAndSpec("dps2")
    sheetTable[13] = sortPartyRolesAndSpec("dps3")
    sheetTable[14] = checkIO("old")
    sheetTable[15] = checkIO("new")    
    return sheetTable
end

 -- SLASH COMMANDS FOR TESTING
 SLASH_KEY1, SLASH_KEY2 = '/keyd', "/keydex";
function SlashCmdList.KEY(msg, editBox)

    if msg then msg = string.lower( msg ); end
        if msg == "showbox" then
            StaticPopup_Show ("KEYDEX_COPYWINDOW")

        elseif msg == "runtests" then
            print("Placeholder for now...")
            --TODO: add testing :)
        else
        end
end


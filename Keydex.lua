-- WoW Key Codex (Keydex)

-- Initialize WoWAce/OpenRaidLib External Library Dependencies
Keydex = LibStub("AceAddon-3.0"):NewAddon("Keydex", "AceConsole-3.0", "AceEvent-3.0")
openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0")

-- Code that is ran on the initialization of the addon.
-- After 5 seconds sends the initial requests to the 
-- WoW API for C_MythicPlus.RequestMapInfo() and 
-- C_MythicPlus.GetCurrentAffixes(). This triggers 
-- the event "MYTHIC_PLUS_CURRENT_AFFIX_UPDATE".
function Keydex:OnInitialize()
    C_Timer.After(5, initialRequestsForEvents)
end

-- Empty function but may be useful in the future.
-- Runs when add-on is enabled.
function Keydex:OnEnable()
end

-- Empty function but may be useful in the future.
-- Runs when add-on is disabled.
function Keydex:OnDisable()
end

-- Initial trigger used to hit WoW API to pre-pull affixes
-- for the week. This is done due to a weird issue where 
-- occasionally the first call to the API does not return
-- information but the subsequent calls do.
-- @return two requests for pulling the affixes for the week.
function initialRequestsForEvents()
    return C_MythicPlus.RequestMapInfo(), C_MythicPlus.GetCurrentAffixes()
end

-- Simple function used to get the date in mm/dd/yyyy format.
-- @return the current date.
function GetDate()
    local currentDate = date("%m/%d/%y")
    return currentDate
end

-- External library used to collect unit informations.
-- @param unitId
-- @param unitInfo
-- @param allUnitsInfo
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

-- Call-back for external library.
openRaidLib.RegisterCallback(openRaidLib, "UnitInfoUpdate", "OnUnitUpdate")

-- Function to clean a string of escape characters.
-- If the string contains a comma (,) or a double quote ("), it wraps the string in 
-- double quotes and doubles any existing double quotes within the string.
-- This escaping is done because in CSV format, a comma separates values, and double quotes 
-- are used to enclose values that might contain commas or other special characters.
-- For example, the string He said "Hello" would be transformed into "He said ""Hello""" 
-- to ensure it is correctly represented in CSV.
-- @param str a string
function escapeCSV(str)
    if string.find(str, '[,"]') then
      str = '"' .. string.gsub(str, '"', '""') .. '"'
    end
    return str
end

-- This function takes a table (tbl) and converts it into a CSV string. It does this by:
-- Iterating over each element in the table tt using ipairs.
-- For each element, it calls escapeCSV to handle any necessary escaping.
-- It appends the escaped value to a string s, prefixed by a comma.
-- After iterating through all the elements, it removes the first comma using string.sub(s, 2) 
-- to return the CSV string without an unwanted leading comma.
-- @param tbl a table to be converted to CSV
function toCSV(tbl)
    local s = ""
    for _,p in ipairs(tbl) do  
      s = s .. "," .. escapeCSV(p)
    end
    return string.sub(s, 2)
end

-- Callback function that runs on the event "CHALLENGE_MODE_START".
-- Function is currently not being used but may add some functionality
-- here in the future.
function Keydex:CHALLENGE_MODE_START()
end

-- Registers the "CHALLENGE_MODE_START" WoW event with Keydex
-- so we can run our callback function whenever this event happens.
Keydex:RegisterEvent("CHALLENGE_MODE_START");

-- Callback function that runs on the event "CHALLENGE_MODE_COMPLETED".
-- Function displays the StaticPopupDialog "KEYDEX_COPYWINDOW" which
-- is the window that allows user to copy their CSV data for export.
function Keydex:CHALLENGE_MODE_COMPLETED()
    StaticPopup_Show("KEYDEX_COPYWINDOW")
end

-- Registers the "CHALLENGE_MODE_COMPLETED" WoW event with Keydex
-- so we can run our callback function whenever this event happens.
Keydex:RegisterEvent("CHALLENGE_MODE_COMPLETED");

-- Callback function for the event "MYTHIC_PLUS_CURRENT_AFFIX_UPDATE"
-- which is used to pull the current M+ affix ids.
-- The event is naturally fired at the start of each M+
-- run, but also manually on the initialization of Keydex
-- via Keydex:OnInitialize(). 
function Keydex:MYTHIC_PLUS_CURRENT_AFFIX_UPDATE()
    C_Timer.After(5, GetAffixIds())
end

-- Registers the "MYTHIC_PLUS_CURRENT_AFFIX_UPDATE" WoW event with Keydex
-- so we can run our callback function whenever this event happens.
Keydex:RegisterEvent("MYTHIC_PLUS_CURRENT_AFFIX_UPDATE")


-- FrameXML element that displays a simple dialog box on the screen.
-- This dialog box holds the CSV data as a string.
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

-- Builder function that constructs the table that will
-- be converted into CSV via the toCSV function called in 
-- the StaticPopupDialog box that is displayed in-game at 
-- the end of a M+ run.
-- If an entry in the table returns a null value it will not
-- finish populating the rest of the table.
function csvDataStruct()
    local sheetTable = {}
    sheetTable[1] = GetDate()
    sheetTable[2] = GetPlayerInformation("playerName")
    sheetTable[3] = TranslateMapID(GetCurrentMap())
    sheetTable[4] = GetCurrentKeyLevel()
    if GetCurrentKeyLevel() <= 2 then
        sheetTable[5] = GetWeeklyAffixes(1) --Xalatath's Bargain
        sheetTable[6] = ''
        sheetTable[7] = ''
        sheetTable[8] = ''
    elseif (GetCurrentKeyLevel() >= 4 and GetCurrentKeyLevel() <=6) then
        sheetTable[5] = GetWeeklyAffixes(1) -- Xalatath's Bargain
        sheetTable[6] = GetWeeklyAffixes(2) -- Fortified/Tyrannical
        sheetTable[7] = ''
        sheetTable[8] = ''
    elseif (GetCurrentKeyLevel() >= 7 and GetCurrentKeyLevel() <=9) then
        sheetTable[5] = GetWeeklyAffixes(1) -- Xalatath's Bargain
        sheetTable[6] = GetWeeklyAffixes(2) -- Fortified/Tyranical
        sheetTable[7] = ''
        sheetTable[8] = GetWeeklyAffixes(3) -- Challenger's Peril
    elseif (GetCurrentKeyLevel() >= 10 and GetCurrentKeyLevel() <=11) then
        sheetTable[5] = GetWeeklyAffixes(1) -- Xalatath's Bargain
        sheetTable[6] = GetWeeklyAffixes(2) -- Fortified/Tyranical
        sheetTable[7] = GetWeeklyAffixes(4) -- Foritified/Tyrannical
        sheetTable[8] = GetWeeklyAffixes(3) -- Challenger's Peril
    elseif (GetCurrentKeyLevel() >= 12) then
        sheetTable[5] = GetWeeklyAffixes(5) -- Xalatath's Guile
        sheetTable[6] = GetWeeklyAffixes(2) -- Fortified/Tyranical
        sheetTable[7] = GetWeeklyAffixes(3) -- Challenger's Peril
        sheetTable[8] = GetWeeklyAffixes(4) -- Foritified/Tyrannical
    else
        sheetTable[5] = ''
        sheetTable[6] = ''
        sheetTable[7] = ''
        sheetTable[8] = ''

    end
    sheetTable[9] = CheckKeyResult()
    sheetTable[10] = SortPartyRolesAndSpec("tank")
    sheetTable[11] = SortPartyRolesAndSpec("healer")
    sheetTable[12] = SortPartyRolesAndSpec("dps1")
    sheetTable[13] = SortPartyRolesAndSpec("dps2")
    sheetTable[14] = SortPartyRolesAndSpec("dps3")
    sheetTable[15] = CheckIO("old")
    sheetTable[16] = CheckIO("new")
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


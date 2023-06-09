-- WoW Key Codex (Keydex)

-- Initialize WoWAce
Keydex = LibStub("AceAddon-3.0"):NewAddon("Keydex", "AceConsole-3.0", "AceEvent-3.0")
openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0")

function Keydex:OnInitialize()
	-- Place Holder
end

function Keydex:OnEnable()
	-- Place Holder
end

function Keydex:OnDisable()
	-- Called when the addon is disabled
end

-- Get Date of Instance Run
function getDate()
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

  -- Function to build the CSV data we push out into the StaticDiaglogPopup
 function csvDataStruct()
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
    sheetTable[8] = "Timed" -- TODO: Implement logic so this is not static
    sheetTable[9] = sortPartyRolesAndSpec("tank")
    sheetTable[10] = sortPartyRolesAndSpec("healer")
    sheetTable[11] = sortPartyRolesAndSpec("dps1")
    sheetTable[12] = sortPartyRolesAndSpec("dps2")
    sheetTable[13] = sortPartyRolesAndSpec("dps3")
    
    return sheetTable
end

 -- SLASH COMMANDS FOR TESTING
 SLASH_KEY1, SLASH_KEY2 = '/keyd', "/keydex";
function SlashCmdList.KEY(msg, editBox)

    if msg then msg = string.lower( msg ); end
        if msg == "showbox" then
            StaticPopup_Show ("KEYDEX_COPYWINDOW")
        else
        end
end


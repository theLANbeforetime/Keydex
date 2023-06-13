-- WoW Key Codex (Keydex)

-- Initialize WoWAce
Keydex = LibStub("AceAddon-3.0"):NewAddon("Keydex", "AceConsole-3.0", "AceEvent-3.0")

-- function Keydex:OnInitialize()
-- 	-- Called when the addon is loaded
--     -- The events we see when we try to initial request
--     -- MYTHIC_PLUS_CURRENT_AFFIX_UPDATE
--     -- CHALLENGE_MODE_MAPS_UPDATE
-- 	self:Print("Starting Map Info Request")
--     C_MythicPlus.RequestMapInfo()
--     self:Print("Map Info Request Complete")
-- end

-- function Keydex:OnEnable()
-- 	-- Called when the addon is enabled
--     event = self:RegisterEvent("CHALLENGE_MODE_MAPS_UPDATE")
--     self:Print(event)
-- end

-- function Keydex:CHALLENGE_MODE_MAPS_UPDATE()
-- 	affixes = C_MythicPlus.GetCurrentAffixes()
-- end

-- function Keydex:OnDisable()
-- 	-- Called when the addon is disabled
-- end




-- Get Date of Instance Run
function getDate()
    currentDate = date("%m/%d/%y")
    return currentDate
end

function initKeyInfo()
    C_MythicPlus.RequestMapInfo()
end

function initRaidLib()
    local data = openRaidLib.RequestAllData()
    return data
end

function initAffixInfo()
    local affixes = C_MythicPlus.GetCurrentAffixes()
    return affixes
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

local frame = CreateFrame("FRAME", "KeydexAddonFrame");
frame:RegisterEvent("CHALLENGE_MODE_COMPLETED");
local function eventHandler(self, event, ...)
--  print(getDate(), getPlayerInformation("playerName"), getCurrentMap(), getCurrentKeyLevel(), getWeeklyAffixes(1), getWeeklyAffixes(2), getWeeklyAffixes(3), sortPartyRolesAndSpec("tank"), sortPartyRolesAndSpec("healer"), sortPartyRolesAndSpec("dps1"), sortPartyRolesAndSpec("dps2"), sortPartyRolesAndSpec("dps3"))
    -- TODO: Note (Not sure if this should be implemented)
    StaticPopup_Show ("KEYDEX_COPYWINDOW")
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
 -- Create structure to store data that will be copied.
 -- TODO: Make this dynamic so players can choose how they want to structure 
 -- own data in CSV format. 

 function csvDataStruct()
    initKeyInfo()
    local sheetTable = {}
    -- Table will not print after null value.
    sheetTable[1] = getDate()
    sheetTable[2] = getPlayerInformation("playerName")
    sheetTable[3] = translateMapID(getCurrentMap())
    sheetTable[4] = getCurrentKeyLevel()
    sheetTable[5] = getWeeklyAffixes(1)
    sheetTable[6] = getWeeklyAffixes(2)
    sheetTable[7] = getWeeklyAffixes(3)
    sheetTable[8] = sortPartyRolesAndSpec("tank")
    sheetTable[9] = sortPartyRolesAndSpec("healer")
    sheetTable[10] = sortPartyRolesAndSpec("dps1")
    sheetTable[11] = sortPartyRolesAndSpec("dps2")
    sheetTable[12] = sortPartyRolesAndSpec("dps3")
    -- sheetTable[13] = getKeyCompletion()
    -- sheetTable[14] = getQuickNote()
    
    return sheetTable
end

 -- SLASH COMMANDS FOR TESTING
 SLASH_KEY1, SLASH_KEY2 = '/keyd', "/keydex";
function SlashCmdList.KEY(msg, editBox)

    if msg then msg = string.lower( msg ); end
    --if msg == "test" then
         StaticPopup_Show ("KEYDEX_COPYWINDOW")

    -- TESTING OF FUNCTIONS
        -- print("Current date is: ", getDate())
        -- print("Your Item Level is: ", getPlayerInformation("playeriLevel"))
        -- print("Your Role is: ", getPlayerInformation("playerRole"))
        -- print("Your Spec is: ", getPlayerInformation("playerSpec"))
        -- print("Weekly Affixes are: ", getWeeklyAffixes(1), getWeeklyAffixes(2), getWeeklyAffixes(3))
        -- print("Current Key Level: ", getCurrentKeyLevel())
        -- print("Current Map is: ", translateMapID(getCurrentMap()))
        -- print(getCurrentMap())
        -- print("Party One Information: ", getPartyInformation("party1", "partyName", "partyRole", "partySpecName", "partyiLevel"))
        -- print("Party One Role: ", getPartyInformation("party1", "partyRole"))
        -- print("Party Two Information: ", getPartyInformation("party2", "partyName", "partyRole", "partySpecName", "partyiLevel"))
        -- print("Party Three Information: ", getPartyInformation("party3", "partyName", "partyRole", "partySpecName", "partyiLevel"))
        -- print("Party Four Information: ", getPartyInformation("party4", "partyName", "partyRole", "partySpecName", "partyiLevel"))
    --end 
end


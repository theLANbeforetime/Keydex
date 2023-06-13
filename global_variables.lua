openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0")


-- local keydex_listener = CreateFrame("FRAME", "on_world_enter");
-- keydex_listener:RegisterEvent("PLAYER_ENTERING_WORLD");
-- function eventHandler(self, event, ...)
--     C_Timer.After(5, C_MythicPlus.RequestMapInfo())

--     affixes = C_MythicPlus.GetCurrentAffixes()
--     if affixes ~= nil then
--         print("Affixes loaded successfully")
--     else
--         print("Affix load failed.")
--     end
-- end
-- keydex_listener:SetScript("OnEvent", eventHandler);

-- function initAffix()
--     C_MythicPlus.RequestMapInfo()
-- end


-- function reqMI()
--         C_MythicPlus.RequestMapInfo()
--     end
--     affixes = C_MythicPlus.GetCurrentAffixes()
--     print(affixes)
--     print("test")
    
--  end
--  reqMI()
-- local frame = CreateFrame("FRAME", "FooAddonFrame");
-- frame:RegisterEvent("PLAYER_ENTERING_WORLD");
-- local function eventHandler(self, event, ...)
--  print("Hello World! Hello " .. event);
-- end
-- frame:SetScript("OnEvent", eventHandler);
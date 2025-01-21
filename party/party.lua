---Uses Open Raid lib to query information about a party member.
---@param partyNum integer the placement of the party member (1-5)
---@param ... string the information to pull from the partyTable
---@return string partyInformation either name, role, specId, or ilvl
function GetPartyInformation(partyNum, ...)
    local unitInfo = openRaidLib.GetUnitInfo(partyNum)
    local playerGear = openRaidLib.GetUnitGear(partyNum)
    local partyTable = {}

    if unitInfo ~= nil then
        partyTable["partyName"] = unitInfo.name
        partyTable["partyRole"] = unitInfo.role
        partyTable["partySpecId"] = unitInfo.specId
        partyTable["partyiLevel"] = playerGear.ilevel
    else partyTable[...] = "unknown" end
    return partyTable[...]
end

---Takes a party member and return their role/specId.
---@param partyNum integer the placement of the party member (1-5)
---@return table roleAndSpec the role (tank, healer, dps) and spec of the player
function DeterminePartyRole(partyNum)
    local role = GetPartyInformation(partyNum, "partyRole")
    local specId = GetPartyInformation(partyNum, "partySpecId")
    local partyRoleSpec = {role, specId}
    return partyRoleSpec
end

--TODO: Create some logic to update these names as the user would like.
---Simple translator function between spec id (int) and name (string)
---https://wow.tools/dbc/?dbc=chrspecialization&build=10.0.5.47660#page=1
---@param specId integer specialization id number
---@return string specializationName the name of the specialization
function SpecIdTranslationTank(specId)
    local specializationName = "empty"
    if specId == 250 then
        specializationName = "Blood DK"
    elseif specId == 581 then
        specializationName = "Vengeance"
    elseif specId == 104 then
        specializationName = "Guardian"
    elseif specId == 268 then
        specializationName = "Brewmaster"
    elseif specId == 66 then
        specializationName = "Prot Pal"
    elseif specId == 73 then
        specializationName = "Prot War"
    else
    end
    return specializationName
end

--TODO: Create some logic to update these names as the user would like.
---Simple translator function between spec id (int) and name (string)
---@param specId integer specialization id number
---@return string specializationName the name of the specialization
function SpecIdTranslationHealer(specId)
    local specializationName = ""
    if specId == 105 then
        specializationName = "Rdruid"
    elseif specId == 270 then
        specializationName = "Mistweaver"
    elseif specId == 65 then
        specializationName = "Hpal"
    elseif specId == 256 then
        specializationName = "Disc"
    elseif specId == 257 then
        specializationName = "Hpriest"
    elseif specId == 264 then 
        specializationName = "Rsham"
    elseif specId == 1468 then
        specializationName = "Pres"
    else
    end
    return specializationName
end

--TODO: Create some logic to update these names as the user would like.
---Simple translator function between spec id (int) and name (string)
---@param specId integer specialization id number
---@return string specializationName the name of the specialization
function SpecIdTranslationDPS(specId)
    local specializationName = ""
    if specId == 251 then
        specializationName = "Frost DK"
    elseif specId == 252 then
        specializationName = "Unholy"
    elseif specId == 577 then
        specializationName = "Havoc"
    elseif specId == 102 then
        specializationName = "Boomkin"
    elseif specId == 103 then
        specializationName = "Feral"
    elseif specId == 253 then 
        specializationName = "BM"
    elseif specId == 254 then
        specializationName = "MM"
    elseif specId == 255 then
        specializationName = "Survival"
    elseif specId == 62 then
        specializationName = "Arcane"
    elseif specId == 63 then
        specializationName = "Fire"
    elseif specId == 64 then
        specializationName = "Frost"
    elseif specId == 269 then 
        specializationName = "WW"
    elseif specId == 70 then
        specializationName = "Ret"
    elseif specId == 258 then
        specializationName = "Shadow"
    elseif specId == 259 then
        specializationName = "Assass"
    elseif specId == 260 then
        specializationName = "Outlaw"
    elseif specId == 261 then
        specializationName = "Sub"
    elseif specId == 262 then
        specializationName = "Ele"
    elseif specId == 263 then
        specializationName = "Enhance"
    elseif specId == 265 then
        specializationName = "Afflic"
    elseif specId == 266 then
        specializationName = "Demo"
    elseif specId == 267 then
        specializationName = "Destro"
    elseif specId == 71 then
        specializationName = "Arms"
    elseif specId == 72 then
        specializationName = "Fury"
    elseif specId == 1467 then
        specializationName = "Dev"
    elseif specId == 1473 then
        specializationName = "Aug"
    else
    end
    return specializationName
end

---Sort the party and get the specs.
---@param selector string role of the party (tank, healer, dps1, dps3, dps3)
---@return string specializationName the name of the spec for the given role
function SortPartyRolesAndSpec(selector)
    local party1 = DeterminePartyRole("party1")
    local party2 = DeterminePartyRole("party2")
    local party3 = DeterminePartyRole("party3")
    local party4 = DeterminePartyRole("party4")
    local player = DeterminePartyRole()

    local unsortedPartyTable = {party1, party2, party3, party4, player}
    local sortedPartyTable = {}
    sortedPartyTable.tank = "No Tank Found"
    sortedPartyTable.healer = "No Healer Found"
    sortedPartyTable.dps1 = "No DPS(1) Found"
    sortedPartyTable.dps2 = "No DPS(2) Found"
    sortedPartyTable.dps3 = "No DPS(3) Found"

    for pnum = 1,5 do
        if unsortedPartyTable[pnum][1] == "TANK" then
            sortedPartyTable.tank = SpecIdTranslationTank(unsortedPartyTable[pnum][2])
        elseif unsortedPartyTable[pnum][1] == "HEALER" then
            sortedPartyTable.healer = SpecIdTranslationHealer(unsortedPartyTable[pnum][2])
        elseif unsortedPartyTable[pnum][1] == "DAMAGER" then
            if sortedPartyTable.dps1 == "No DPS(1) Found" then
                sortedPartyTable.dps1 = SpecIdTranslationDPS(unsortedPartyTable[pnum][2])
            elseif sortedPartyTable.dps2 == "No DPS(2) Found" then
                sortedPartyTable.dps2 = SpecIdTranslationDPS(unsortedPartyTable[pnum][2])
            elseif sortedPartyTable.dps3 == "No DPS(3) Found" then
                sortedPartyTable.dps3 = SpecIdTranslationDPS(unsortedPartyTable[pnum][2])
            end
        end
    end
    return sortedPartyTable[selector]
end

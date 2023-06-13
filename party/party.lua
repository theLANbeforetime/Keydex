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

-- Function takes in player role and sets them in order of TANK - HEALER - DAMAGER - DAMAGER - DAMAGER
function determinePartyRole(partyNum)
    initRaidLib()
    local role = getPartyInformation(partyNum, "partyRole")
    local spec = getPartyInformation(partyNum, "partySpecName")
    local partyRoleSpec = {role, spec}
    return partyRoleSpec
end

-- Sort Party and get Specs
function sortPartyRolesAndSpec(selector)
    local party1 = determinePartyRole("party1")
    local party2 = determinePartyRole("party2")
    local party3 = determinePartyRole("party3")
    local party4 = determinePartyRole("party4")
    local player = determinePlayerRole()

    unsortedPartyTable = {party1, party2, party3, party4, player}
    sortedPartyTable = {}
    sortedPartyTable.tank = "No Tank Found"
    sortedPartyTable.healer = "No Healer Found"
    sortedPartyTable.dps1 = "No DPS Found"
    sortedPartyTable.dps2 = "No DPS Found"
    sortedPartyTable.dps3 = "No DPS Found"
    
    for pnum = 1,5 do
        if unsortedPartyTable[pnum][1] == "TANK" then
            sortedPartyTable.tank = unsortedPartyTable[pnum][2]
        elseif unsortedPartyTable[pnum][1] == "HEALER" then
            sortedPartyTable.healer = unsortedPartyTable[pnum][2]
        elseif unsortedPartyTable[pnum][1] == "DAMAGER" then
            if sortedPartyTable.dps1 == "No DPS Found" then
                sortedPartyTable.dps1 = unsortedPartyTable[pnum][2]
            elseif sortedPartyTable.dps2 == "No DPS Found" then
                sortedPartyTable.dps2 = unsortedPartyTable[pnum][2]
            elseif sortedPartyTable.dps3 == "No DPS Found" then
                sortedPartyTable.dps3 = unsortedPartyTable[pnum][2]
            end
        end
    end
    return sortedPartyTable[selector]
end
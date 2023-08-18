function getPartyInformation(partyNum, ...)
    --[[ Take party member's party num and use it to 
    pull party information. ]]

    local unitInfo = openRaidLib.GetUnitInfo(partyNum)
    local playerGear = openRaidLib.GetUnitGear(partyNum)

    partyTable = {}
    if unitInfo ~= nil then
        partyTable["partyName"] = unitInfo.name
        partyTable["partyRole"] = unitInfo.role
        partyTable["partySpecId"] = unitInfo.specId
        partyTable["partyiLevel"] = playerGear.ilevel
    else partyTable[...] = "unknown" end
    return partyTable[...]

end

function determinePartyRole(partyNum)
    --[[ Function takes in player role and sets them in order of 
    TANK - HEALER - DAMAGER - DAMAGER - DAMAGER ]]

    local role = getPartyInformation(partyNum, "partyRole")
    local specId = getPartyInformation(partyNum, "partySpecId")
    local partyRoleSpec = {role, specId}
    return partyRoleSpec
end

function specIdTranslation_Tank(id)
    --[[Take SpecId and translate to Spec Name.]]

    local specializationName = "empty"
    if id == 250 then
        specializationName = "Blood DK"
    elseif id == 581 then
        specializationName = "Vengeance"
    elseif id == 104 then
        specializationName = "Guardian"
    elseif id == 268 then
        specializationName = "Brewmaster"
    elseif id == 66 then
        specializationName = "Prot Pal"
    elseif id == 73 then
        specializationName = "Prot War"
    else
    end
    return specializationName
end

function specIdTranslation_Healer(id)
    --[[
    Take SpecId and translate to Spec Name.
    https://wow.tools/dbc/?dbc=chrspecialization&build=10.0.5.47660#page=1
    ]]

    local specializationName = ""
    if id == 105 then
        specializationName = "Rdruid"
    elseif id == 270 then
        specializationName = "Mistweaver"
    elseif id == 65 then
        specializationName = "Hpal"
    elseif id == 256 then
        specializationName = "Disc"
    elseif id == 257 then
        specializationName = "Hpriest"
    elseif id == 264 then 
        specializationName = "Rsham"
    elseif id == 1468 then
        specializationName = "Pres"
    else
    end
    return specializationName
    
end

function specIdTranslation_DPS(id)
    --[[Take SpecId and translate to Spec Name.]]

    local specializationName = ""
    if id == 251 then
        specializationName = "Frost DK"
    elseif id == 252 then
        specializationName = "Unholy"
    elseif id == 577 then
        specializationName = "Havoc"
    elseif id == 102 then
        specializationName = "Boomkin"
    elseif id == 103 then
        specializationName = "Feral"
    elseif id == 253 then 
        specializationName = "BM"
    elseif id == 254 then
        specializationName = "MM"
    elseif id == 255 then
        specializationName = "Survival"
    elseif id == 62 then
        specializationName = "Arcane"
    elseif id == 63 then
        specializationName = "Fire"
    elseif id == 64 then
        specializationName = "Frost"
    elseif id == 269 then 
        specializationName = "WW"
    elseif id == 70 then
        specializationName = "Ret"
    elseif id == 258 then
        specializationName = "Shadow"
    elseif id == 259 then
        specializationName = "Assass"
    elseif id == 260 then
        specializationName = "Outlaw"
    elseif id == 261 then
        specializationName = "Sub"
    elseif id == 262 then
        specializationName = "Ele"
    elseif id == 263 then
        specializationName = "Enhance"
    elseif id == 265 then
        specializationName = "Afflic"
    elseif id == 266 then
        specializationName = "Demo"
    elseif id == 267 then
        specializationName = "Destro"
    elseif id == 71 then
        specializationName = "Arms"
    elseif id == 72 then
        specializationName = "Fury"
    elseif id == 1467 then
        specializationName = "Dev"
    elseif id == 1473 then
        specializationName = "Aug"
    else
    end
    return specializationName
end

function sortPartyRolesAndSpec(selector)
    -- Sort Party and get Specs
    
    local party1 = determinePartyRole("party1")
    local party2 = determinePartyRole("party2")
    local party3 = determinePartyRole("party3")
    local party4 = determinePartyRole("party4")
    local player = determinePlayerRole()

    unsortedPartyTable = {party1, party2, party3, party4, player}
    sortedPartyTable = {}
    sortedPartyTable.tank = "No Tank Found"
    sortedPartyTable.healer = "No Healer Found"
    sortedPartyTable.dps1 = "No DPS(1) Found"
    sortedPartyTable.dps2 = "No DPS(2) Found"
    sortedPartyTable.dps3 = "No DPS(3) Found"
    
    for pnum = 1,5 do
        if unsortedPartyTable[pnum][1] == "TANK" then
            sortedPartyTable.tank = specIdTranslation_Tank(unsortedPartyTable[pnum][2])
        elseif unsortedPartyTable[pnum][1] == "HEALER" then
            sortedPartyTable.healer = specIdTranslation_Healer(unsortedPartyTable[pnum][2])
        elseif unsortedPartyTable[pnum][1] == "DAMAGER" then
            if sortedPartyTable.dps1 == "No DPS(1) Found" then
                sortedPartyTable.dps1 = specIdTranslation_DPS(unsortedPartyTable[pnum][2])
            elseif sortedPartyTable.dps2 == "No DPS(2) Found" then
                sortedPartyTable.dps2 = specIdTranslation_DPS(unsortedPartyTable[pnum][2])
            elseif sortedPartyTable.dps3 == "No DPS(3) Found" then
                sortedPartyTable.dps3 = specIdTranslation_DPS(unsortedPartyTable[pnum][2])
            end
        end
    end
    return sortedPartyTable[selector]
end

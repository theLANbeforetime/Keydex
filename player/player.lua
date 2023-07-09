function getPlayerInformation(arg)
    -- Get Player Data
    
    local unitInfo = openRaidLib.GetUnitInfo("player")
    local playerGear = openRaidLib.GetUnitGear("player")

    playerTable = {}
    playerTable["playerName"] = unitInfo.name
    playerTable["playeriLevel"] = playerGear.ilevel
    playerTable["playerRole"] = unitInfo.role
    playerTable["playerSpecId"] = unitInfo.specId

    return playerTable[arg]
end 

function determinePlayerRole()
    -- Get Player Role/SpecId

    local role = getPlayerInformation("playerRole")
    local specId = getPlayerInformation("playerSpecId")
    local playerRoleSpec = {role, specId}
    return playerRoleSpec
end
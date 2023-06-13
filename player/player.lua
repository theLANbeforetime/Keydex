-- Get Player Data
function getPlayerInformation(arg)
    local unitInfo = openRaidLib.GetUnitInfo("player")
    local playerGear = openRaidLib.GetUnitGear("player")

    playerTable = {}
    playerTable["playerName"] = unitInfo.name
    playerTable["playeriLevel"] = playerGear.ilevel
    playerTable["playerRole"] = unitInfo.role
    playerTable["playerSpec"] = unitInfo.specName

    return playerTable[arg]
end 
-- Player Role
function determinePlayerRole()
    initRaidLib()
    local role = getPlayerInformation("playerRole")
    local spec = getPlayerInformation("playerSpec")
    local playerRoleSpec = {role, spec}
    return playerRoleSpec
end
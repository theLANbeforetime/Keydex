--- Returns requested player information from OpenRaidLib.
---@param playerDetail string
---|"playerName"
---|"playeriLevel"
---|"playerRole"
---|"playerSpecId"
---@return string 
function GetPlayerInformation(playerDetail)
    local unitInfo = openRaidLib.GetUnitInfo("player")
    local playerGear = openRaidLib.GetUnitGear("player")

    local playerTable = {}
    playerTable["playerName"] = unitInfo.name
    playerTable["playeriLevel"] = playerGear.ilevel
    playerTable["playerRole"] = unitInfo.role
    playerTable["playerSpecId"] = unitInfo.specId

    return playerTable[playerDetail]
end

---Returns players role and specialization.
---@return table playerRoleSpec
function DeterminePlayerRole()
    local role = GetPlayerInformation("playerRole")
    local specId = GetPlayerInformation("playerSpecId")
    local playerRoleSpec = {role, specId}
    return playerRoleSpec
end
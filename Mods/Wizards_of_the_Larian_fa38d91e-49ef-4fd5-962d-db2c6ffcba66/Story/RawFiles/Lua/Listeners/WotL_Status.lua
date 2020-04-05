-- Statuses armor bypassing. Kept this one for hardcoded statuses,
-- specially CHARMED. Need to keep a lookout for possible bugs
-- caused by this.
local function WotL_StatusGetEnterChance(status, useCharacterStats)
    if status.ForceStatus then
        return 100
    end
    return status.CanEnterChance
end

if Ext.IsServer() then
    Ext.RegisterListener("StatusGetEnterChance", WotL_StatusGetEnterChance)
end

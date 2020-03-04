-- Serves as a DB to keep track of the current characters with the buff
-- The buffs are removed when the target's turn ends
local WotL_LeadershipCurrentBuffs = {}

-- Damaging an enemy in range applies the leadership status, but removes
-- any previous leadership status applied
function WotL_Leadership(target, source, handle)
    if not WotL_Bool(GetVarInteger(source, "WotL_Ability_Leadership")) then
        return
    end

    local combatID = CombatGetIDForCharacter(source)
    local currentTurn = Osi.DB_WotL_CurrentTurn:Get(source, combatID)
    if next(currentTurn) == nil then
        return
    end

    if not WotL_Bool(CharacterIsEnemy(target, source)) then
        return
    end

    if not WotL_Bool(NRD_StatusGetInt(target, handle, "Hit")) then
        return
    end

    local distance = GetDistanceTo(target, source)
    if distance > 5.0 then
        return
    end

    RemoveStatus(target, "WotL_LeadershipTarget")
    ApplyStatus(target, "WotL_LeadershipTarget", 6.0, 1, source)
end

-- Upon target's turn start, applies a dodge bonus to all allies of the leadership source
function WotL_LeadershipTurn(target)
    if not WotL_Bool(HasActiveStatus(target, "WotL_LeadershipTarget")) then
        return
    end

    local handle = NRD_StatusGetHandle(target, "WotL_LeadershipTarget")
    local source = NRD_StatusGetGuidString(target, handle, "StatusSourceHandle")

    local distance = GetDistanceTo(target, source)
    if distance > 5.0 then
        RemoveStatus(target, "WotL_LeadershipTarget")
        return
    end

    local leadership = GetVarInteger(source, "WotL_Ability_Leadership")
    local status = "WotL_LeadershipBuff_" .. tostring(leadership)
    
    local combatID = CombatGetIDForCharacter(target)
    local combatants = Osi.DB_CombatCharacters:Get(nil, combatID)
    -- Escapes the '-' on the source GUID to allow string.find to work
    local rxpSource = string.gsub(source, "%-", "%%%0")
    for _, combatant in pairs(combatants) do
        if WotL_Bool(CharacterIsAlly(source, combatant[1])) and string.find(combatant[1], rxpSource) == nil then
            ApplyStatus(combatant[1], status, 6.0, 1)
            WotL_TableInsertTable(WotL_LeadershipCurrentBuffs, target, {combatant[1], status})
        end
    end
end

-- Removes all dodge buffs after the target's turn ends
function WotL_LeadershipEndTurn(target)
    local currentBuffs = WotL_LeadershipCurrentBuffs[target]
    if currentBuffs == nil then
        return
    end
    for _, curr in pairs (currentBuffs) do
        RemoveStatus(curr[1], curr[2])
    end
    WotL_TableRemove(WotL_LeadershipCurrentBuffs, target)
end

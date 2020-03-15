-- Serves as a DB to keep track of the current characters with the debuff
-- The debuffs are removed when the target's turn ends
local WotL_LeadershipCurrentDebuffs = {}

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

    RemoveStatus(target, "WotL_LeadershipEffect")
    ApplyStatus(target, "WotL_LeadershipEffect", 6.0, 1, source)
end

-- Upon target's turn start, applies an accuracy debuff to them, and a dodge debuff to the source
function WotL_LeadershipTurn(target)
    if not WotL_Bool(HasActiveStatus(target, "WotL_LeadershipEffect")) then
        return
    end

    local handle = NRD_StatusGetHandle(target, "WotL_LeadershipEffect")
    local source = NRD_StatusGetGuidString(target, handle, "StatusSourceHandle")

    local distance = GetDistanceTo(target, source)
    if distance > 5.0 then
        RemoveStatus(target, "WotL_LeadershipEffect")
        return
    end

    local leadership = GetVarInteger(source, "WotL_Ability_Leadership")
    local statusTarget = "WotL_LeadershipTarget_" .. tostring(leadership)
    local statusSource = "WotL_LeadershipSource_" .. tostring(leadership)

    ApplyStatus(target, statusTarget, 6.0, 1)
    ApplyStatus(source, statusSource, 6.0, 1)
    WotL_LeadershipCurrentDebuffs[target] = {statusTarget, source, statusSource}
end

-- Removes the debuffs upon the target's turn end
function WotL_LeadershipEndTurn(target)
    local current = WotL_LeadershipCurrentDebuffs[target]
    if current == nil then
        return
    end

    local statusTarget = current[1]
    local source = current[2]
    local statusSource = current[3]

    RemoveStatus(target, statusTarget)
    RemoveStatus(source, statusSource)
    WotL_TableRemove(WotL_LeadershipCurrentDebuffs, target)
end

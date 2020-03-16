-- ------------------------------------------ ARMOR SPECIALITY ------------------------------------------
ENUM_WotL_ArmorSpecialityDamageTypes = {
    "Air",
    "Chaos",
    "Earth",
    "Fire",
    "Poison",
    "Water",
}

WotL_ArmorSpeciality_DamageReductionPerPoint = 0.1
function WotL_ArmorSpeciality(target, handle)
    local armor = NRD_CharacterGetStatInt(target, "CurrentMagicArmor")
    if armor == 0 or armor == nil then
        return
    end

    local speciality = GetVarInteger(target, "WotL_Ability_ArmorSpeciality")
    if speciality == 0 or speciality == nil then
        return
    end
    
    for _, type in pairs(ENUM_WotL_ArmorSpecialityDamageTypes) do
        local damage = NRD_HitStatusGetDamage(target, handle, type)
        if damage ~= 0 then
            local reduction = - math.floor(damage * speciality * WotL_ArmorSpeciality_DamageReductionPerPoint)
            NRD_HitStatusAddDamage(target, handle, type, reduction)
        end
    end
end

-- ------------------------------------------ FOCUS ------------------------------------------
ENUM_WotL_StatusTypeBlockExtension = WotL_Set {
    "CHARMED",
    "FEAR",
    "INCAPACITATED",
    "KNOCKED_DOWN",
    "POLYMORPHED",
}

function WotL_Focus(target, status, handle, source)
    if not WotL_Bool(NRD_StatExists(status)) then
        return
    end

    local type = NRD_StatGetString(status, "StatusType")
    if ENUM_WotL_StatusTypeBlockExtension[type] then
        return
    end

    local turns = NRD_StatusGetReal(target, handle, "CurrentLifeTime")
    if turns <= 0.0 then
        return
    end

    local focus = GetVarInteger(source, "WotL_Ability_Focus")
    if focus == 0 or focus == nil then
        return
    end

    turns = turns + 6.0*focus
    NRD_StatusSetReal(target, handle, "LifeTime", turns)
    NRD_StatusSetReal(target, handle, "CurrentLifeTime", turns)
end

-- ------------------------------------------ LEADERSHIP ------------------------------------------
-- Serves as a DB to keep track of the current characters with the debuff
-- The debuffs are removed when the target's turn ends
local WotL_LeadershipCurrentDebuffs = {}

-- Damaging an enemy in range applies the leadership status, but removes
-- any previous leadership status applied
function WotL_Leadership(target, source, handle)
    if not WotL_Bool(GetVarInteger(source, "WotL_Ability_Leadership")) then
        return
    end

    if not WotL_IsCurrentTurn(source) then
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

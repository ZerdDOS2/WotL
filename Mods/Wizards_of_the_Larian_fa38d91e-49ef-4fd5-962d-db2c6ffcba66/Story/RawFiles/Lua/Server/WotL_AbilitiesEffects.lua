-- ------------------------------------------ FOCUS ------------------------------------------
ENUM_WotL_StatusFocusBlacklist = WotL_Set {
    "WotL_Sentinel_Debuff",
    "WotL_Adrenaline",
}

ENUM_WotL_StatusTypeFocusBlacklist = WotL_Set {
    "CHARMED",
    "FEAR",
    "INCAPACITATED",
    "KNOCKED_DOWN",
    "POLYMORPHED",
}

WotL_Focus_TurnsExtendedPerPoint = 1.0
local function Focus(target, status, handle, source)
    if not WotL_Bool(NRD_StatExists(status)) then
        return
    end

    if ENUM_WotL_StatusFocusBlacklist[status] then
        return
    end

    local type = NRD_StatGetString(status, "StatusType")
    if ENUM_WotL_StatusTypeFocusBlacklist[type] then
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

    turns = turns + 6.0 * WotL_Focus_TurnsExtendedPerPoint * focus
    NRD_StatusSetReal(target, handle, "LifeTime", turns)
    NRD_StatusSetReal(target, handle, "CurrentLifeTime", turns)
end
Ext.NewCall(Focus, "WotL_Focus", "(CHARACTERGUID)_Target, (STRING)_Status, (INTEGER64)_Handle, (CHARACTERGUID)_Source")

-- ------------------------------------------ LEADERSHIP ------------------------------------------
local function Leadership(char)
    local neutralLeadership = "WotL_Leadership_Source_0"
    if WotL_Bool(WotL_IsCurrentTurn(char)) then
        if not WotL_Bool(HasActiveStatus(char, neutralLeadership)) then
            ApplyStatus(char, neutralLeadership, -1.0, 1)
        end
        return
    end

    local leadership = GetVarInteger(char, "WotL_Ability_Leadership")
    if WotL_Bool(CharacterGetMagicArmorPercentage(char)) then
        leadership = leadership * 2
    end

    local status = "WotL_Leadership_Source_" .. tostring(leadership)
    if not WotL_Bool(HasActiveStatus(char, status)) then
        ApplyStatus(char, status, -1.0, 1)
    end
end
Ext.NewCall(Leadership, "WotL_Leadership", "(CHARACTERGUID)_Char")

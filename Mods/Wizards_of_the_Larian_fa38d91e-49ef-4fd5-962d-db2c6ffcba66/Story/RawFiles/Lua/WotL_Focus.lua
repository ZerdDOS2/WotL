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
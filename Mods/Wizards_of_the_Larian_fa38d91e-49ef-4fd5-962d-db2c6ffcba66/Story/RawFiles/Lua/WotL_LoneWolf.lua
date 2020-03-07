function WotL_LoneWolf(char)
    if not WotL_Bool(CharacterIsPlayer(char)) then
        return
    end

    local count = 0
    local isPlayer = false

    local players = Osi.DB_IsPlayer:Get(nil)
    for _, player in pairs(players) do
        if WotL_Bool(CharacterIsInPartyWith(char, player[1])) then
            count = count + 1
        end
        if player[1] == char then
            isPlayer = true
        end
    end
    
    if not isPlayer then
        return
    end

    if count <= 2 then
        if not WotL_Bool(HasAppliedStatus(char, "WotL_LW_Base")) then
            ApplyStatus(char, "WotL_LW_Base", -1.0, 1)
        end
    else
        if WotL_Bool(HasAppliedStatus(char, "WotL_LW_Base")) then
            RemoveStatus(char, "WotL_LW_Base")
        end
    end

    for attribute, _ in pairs(ENUM_WotL_AttributesNames) do
        local value = CharacterGetBaseAttribute(char, attribute)
        local boost = NRD_CharacterGetPermanentBoostInt(char, attribute)
        local final = 0
        if count <= 2 then
            final = (value - 10) - boost
        end
        if final ~= boost then
            NRD_CharacterSetPermanentBoostInt(char, attribute, final)
            CharacterAddAttribute(char, "WotL_Dummy", 0)
        end
    end
end
function WotL_ReworkedTalents_Torturer(char)
    local hasTalent = WotL_Bool(CharacterHasTalent(char, "Torturer"))
    local status = "WotL_GenerousHost"
    local hasStatus = WotL_Bool(HasActiveStatus(char, status))

    if hasTalent and not hasStatus then
        ApplyStatus(char, status, -1.0, 1)
    elseif not hasTalent and hasStatus then
        RemoveStatus(char, status)
    end

    if not hasTalent then
        return
    end

    local maxSummons = NRD_CharacterGetStatInt(char, "MaxSummons")
    local summons = Osi.DB_WotL_SummonsCount:Get(char, nil)
    local count = 0
    for _ in pairs(summons) do
        count = count + 1
    end

    status = "WotL_GenerousHost_Debuff"
    hasStatus = WotL_Bool(HasActiveStatus(char, status))

    -- TODO: Change `count >= 2` and `count < 2` to use maxSummons when NRD_CharacterGetStatInt
    -- is fixed, to allow more compatibility (looking at you, Odin_NECRO)
    if count >= 2 and not hasStatus then
        ApplyStatus(char, status, -1.0, 1)
    elseif count < 2 and hasStatus then
        RemoveStatus(char, status)
    end
end

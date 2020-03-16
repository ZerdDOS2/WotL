-- ------------------------------------------ GENEROUS HOST ------------------------------------------
function WotL_ReworkedTalents_GenerousHost(char)
    -- Vanilla's Torturer became Generous Host
    local hasTalent = WotL_Bool(CharacterHasTalent(char, "Torturer"))
    local status = "WotL_GenerousHost"
    local hasStatus = WotL_Bool(HasActiveStatus(char, status))

    -- Manage status that increases Max Summons application and removal
    if hasTalent and not hasStatus then
        ApplyStatus(char, status, -1.0, 1)
    elseif not hasTalent and hasStatus then
        RemoveStatus(char, status)
    end

    if not hasTalent then
        return
    end

    -- Counts the number of summons currently active (WotL_Summon.txt)
    local summons = Osi.DB_WotL_SummonsCount:Get(char, nil)
    local count = 0
    for _ in pairs(summons) do
        count = count + 1
    end

    local maxSummons = NRD_CharacterGetStatInt(char, "BaseMaxSummons")
    status = "WotL_GenerousHost_Debuff"
    hasStatus = WotL_Bool(HasActiveStatus(char, status))

    -- Applies the Debuff it the summoner has its limit of summons at once
    -- and removes otherwise
    if count >= maxSummons and not hasStatus then
        ApplyStatus(char, status, -1.0, 1)
    elseif count < maxSummons and hasStatus then
        RemoveStatus(char, status)
    end
end

-- ------------------------------------------ SENTINEL ------------------------------------------
WotL_Sentinel_DamageIncrease = 0.25
function WotL_ReworkedTalents_Sentinel(target, source, handle)
    -- Vanilla's Parry Master became Sentinel
    local hasTalent = WotL_Bool(CharacterHasTalent(source, "DualWieldingDodging"))
    if not hasTalent then
        return
    end

    -- Both the target and the source gets an engine-applied status called
    -- AOO (Attack Of Opportunity) when the AOO happens
    local hasStatus = WotL_Bool(HasActiveStatus(target, "AOO"))
    if not hasStatus then
        return
    end

    hasStatus = WotL_Bool(HasActiveStatus(source, "AOO"))
    if not hasStatus then
        return
    end

    -- Extra safety check
    if not WotL_IsCurrentTurn(target) then
        return
    end

    -- More safety checks
    local damageSourceType = NRD_StatusGetString(target, handle, "DamageSourceType")
    local hit = NRD_StatusGetInt(target, handle, "Hit")
    local hitReason = NRD_StatusGetInt(target, handle, "HitReason")
    local hitWithWeapon = NRD_StatusGetInt(target, handle, "HitWithWeapon")

    if damageSourceType ~= "Attack" or hit ~= 1 or hitReason ~= 0 or hitWithWeapon ~= 1 then
        return
    end

    -- Increase damage on the AOO
    for _, type in pairs(ENUM_WotL_AllDamageTypes) do
        local damage = NRD_HitStatusGetDamage(target, handle, type)
        if damage ~= 0 then
            local increase = math.ceil(damage * WotL_Sentinel_DamageIncrease)
            NRD_HitStatusAddDamage(target, handle, type, increase)
        end
    end

    -- If the source still has armor, it applies Crippled for the current turn
    local armor = NRD_CharacterGetStatInt(source, "CurrentMagicArmor")
    if armor == 0 or armor == nil then
        return
    end

    -- Check WotL_TurnManager.txt and WotL_StatusRequestDelete.lua
    ApplyStatus(target, "CRIPPLED", WotL_StatusRemovalAtTurnEndCustomNumber, 0, source)
end

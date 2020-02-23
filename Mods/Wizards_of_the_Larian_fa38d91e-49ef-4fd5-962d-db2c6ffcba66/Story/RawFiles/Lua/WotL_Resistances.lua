ENUM_WotL_ResistanceStatuses = {
    AirResistance = {"WotL_AirVulnerability", "WotL_AirResistance", "WotL_AirImmunity", "WotL_AirAbsorption"},
    EarthResistance = {"WotL_EarthVulnerability", "WotL_EarthResistance", "WotL_EarthImmunity", "WotL_EarthAbsorption"},
    FireResistance = {"WotL_FireVulnerability", "WotL_FireResistance", "WotL_FireImmunity", "WotL_FireAbsorption"},
    PoisonResistance = {"WotL_PoisonVulnerability", "WotL_PoisonResistance", "WotL_PoisonImmunity", "WotL_PoisonAbsorption"},
    WaterResistance = {"WotL_WaterVulnerability", "WotL_WaterResistance", "WotL_WaterImmunity", "WotL_WaterAbsorption"},
}

-- If the status is one of the resistance changing statuses, it'll return the associated resistance
function WotL_IsResistanceStatus(status)
    for stat, statuses in pairs(ENUM_WotL_ResistanceStatuses) do
        for _, type in pairs (statuses) do
            if type == status then
                return stat
            end
        end
    end
end

-- Calculates the final resistance a character must have considering the innate resistances and the statuses currently applied
function WotL_CalculateFinalResistance(target, stat, original)
    local statuses = ENUM_WotL_ResistanceStatuses[stat]
    local hasAbsorption = bool(HasActiveStatus(target, statuses[4]))
    local hasImmunity = bool(HasActiveStatus(target, statuses[3]))
    local hasResistance = bool(HasActiveStatus(target, statuses[2]))
    local hasVulnerability = bool(HasActiveStatus(target, statuses[1]))

    local final = 0
    local bender = false
    -- If Vulnerability is applied by a character with the Bender talent, Absorption and Immunity behaves differently
    if hasVulnerability then
        local handle = NRD_StatusGetHandle(target, statuses[1])
        local source = NRD_StatusGetGuidString(target, handle, "StatusSourceHandle")
        if source ~= nil then
            if bool(CharacterHasTalent(source, "WotL_Bender_Placeholder")) then -- TODO: Add the Talent Code Name for Bender
                bender = true
            end
        end
    end

    -- If the target has Absorption or naturally absorbs, it rounds to 200
    if hasAbsorption or original >= 150 then
        final = 200
        if bender then
            final = 100
        end
    
    -- If the target has Immunity or is naturally immune, it rounds to 100
    elseif hasImmunity or original >= 75 then
        final = 100
        if bender then
            final = 50
        end
    
    -- Target with only Resistance and no other status
    elseif hasResistance and not hasVulnerability then
        -- A resistance lower or equal to -25 is considered an innate Vulnerability, which cancels the Resistance
        if original <= -25 then
            final = 0
        else
            final = 50
        end
    
    -- Target with only Vulnerability and no other status
    elseif hasVulnerability and not hasResistance then
        -- A resistance higher or equal to 25 is considered an innate Resistance, which cancels the Vulnerability
        if original >= 25 then
            final = 0
        else
            final = -50
        end
    
    -- Target either has both Resistance and Vulnerability or none
    else
        -- A resistance higher or equal 25 is considered an innate Resistance
        if original >= 25 then
            final = 50
        elseif original > -25 then
            final = 0
        -- A resistance lower or equal -25 is considered an innate Vulnerability
        else
            final = -50
        end
    end

    return final
end

-- Sets the proper resistance boost to achieve the final resistance calculated
function WotL_ResistancesInteraction(target, status)
    local stat = WotL_IsResistanceStatus(status)
    if stat ~= nil then
        local resistance = NRD_CharacterGetComputedStat(target, stat, 1)
        local boost = NRD_CharacterGetPermanentBoostInt(target, stat)
        local original = resistance - boost

        local final = WotL_CalculateFinalResistance(target, stat, original)
        local newBoost = final - original

        if newBoost ~= boost then
            NRD_CharacterSetPermanentBoostInt(target, stat, newBoost)
            CharacterAddAttribute(target, "Dummy", 0)
        end
    end
end

-- function WotL_ResistanceStatusHandler(target, status)
--     NRD_DebugLog("Status: " .. tostring(status))
--     local type = NRD_StatGetString(status, "StatusType")
--     if type == "CONSUME" and not WotL_IsResistanceStatus(status) then
--         local potion = NRD_StatGetString(status, "StatsId")
--         NRD_DebugLog("Potion: " .. tostring(potion))
--         if WotL_PotionResistanceTable[potion] ~= nil then
--             local handle = NRD_StatusGetHandle(target, status)
--             local source = NRD_StatusGetGuidString(target, handle, "StatusSourceHandle")
--             local duration = NRD_StatusGetReal(target, handle, "CurrentLifeTime")
--             for _, resistStatus in pairs(WotL_PotionResistanceTable[potion]) do
--                 NRD_DebugLog("Status: " .. tostring(resistStatus))
--                 ApplyStatus(target, resistStatus, duration, 1, source)
--             end
--         end
--     end
-- end

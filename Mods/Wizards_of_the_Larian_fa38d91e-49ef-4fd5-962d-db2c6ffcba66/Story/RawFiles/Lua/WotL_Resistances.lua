ENUM_WotL_ResistanceStatuses = {
    EarthResistance = {"WotL_EarthVulnerability", "WotL_EarthResistance", "WotL_EarthImmunity", "WotL_EarthAbsorption"},
    FireResistance = {"WotL_FireVulnerability", "WotL_FireResistance", "WotL_FireImmunity", "WotL_FireAbsorption"},
}

-- If the status is one of the resistance changing statuses, it'll return the
-- associated resistance and the type of status based on the following relation
-- 1: Vulnerability
-- 2: Resistance
-- 3: Immunity
-- 4: Absorption
function WotL_IsResistanceStatus(status)
    for stat, statuses in pairs(ENUM_WotL_ResistanceStatuses) do
        for key, type in pairs (statuses) do
            if type == status then
                return stat, key
            end
        end
    end
end 

function WotL_ResistancesInteraction(target, status, handle, source)
    local stat, type = WotL_IsResistanceStatus(status)
    if stat ~= nil then
        local resistance = NRD_CharacterGetComputedStat(target, stat, 1)
        local delta = 0
        NRD_DebugLog("Type: " .. tostring(type))
        NRD_DebugLog("Resistance to " .. stat .. ": " .. tostring(resistance))
        
        -- Type 1 means applying vulnerability
        if type == 1 then
            -- Applying vulnerability to a regular character applies vulnerability (-50)
            if resistance > -50 and resistance <= 0 then
                delta = - 50 - resistance
            -- Applying vulnerability to a resistant target cancels the resistance (0)
            elseif resistance > 0 and resistance <= 50 then
                delta = - resistance
                
            -- The following rules can be implementend with the talent Bender
            -- Bender: Applying vulnerability to a immune character makes it resistant (50)
            -- else if resistance <= 100  then
            --     delta = 50 - resistance
            -- Bender: Applying vulnerability to a absorbing character makes it immune (100)
            -- else
            --     delta = 100 - resistance
            end
        -- Type 2 means applying resistance
        elseif type == 2 then
            -- Applying resistance to a vulnerable target cancels the vulnerability (0)
            if resistance < 0 then
                delta = - resistance
            -- Applying resistance to a regular character applies resistance (50)
            elseif resistance < 50 then
                delta = 50 - resistance
            end

        -- Type 3 means applying invulnerability
        elseif type == 3 then
            -- Applying invulnerability to character with up to resistance applies invulnerability (100)
            if resistance < 100 then
                delta = 100 - resistance
            end
            
        -- Type 4 means applying absorption
        elseif type == 4 then
            -- Applying absorption to a character with up to invulnerability applies absorption (200)
            if resistance < 200 then
                delta = 200 - resistance
            end
        end

        NRD_DebugLog("Delta: " .. tostring(delta))

        if delta ~= 0 then
            local boost = NRD_CharacterGetPermanentBoostInt(target, stat)
            boost = boost + delta
            NRD_CharacterSetPermanentBoostInt(target, stat, boost)
            CharacterAddAttribute(target, "Dummy", 0)
        -- If delta wasn't set, the status was blocked by an interaction of resistances
        -- Extra check to not block status renovation
        elseif not bool(HasActiveStatus(target, status)) then
            NRD_StatusPreventApply(target, handle, 1)
        end
    end
end

function WotL_ResistancesRemoval(target, status)
    local stat, type = WotL_IsResistanceStatus(status)
    if stat ~= nil then
        -- Check if the target has any other resistance related status
        local hasStatus = false
        for key, statuses in pairs(ENUM_WotL_ResistanceStatuses[stat]) do
            if bool(HasActiveStatus(target, statuses)) then
                NRD_DebugLog("there")
                hasStatus = true
                break
            end
        end

        -- In case there's no resistance related status, remove the boost
        if not hasStatus then
            NRD_DebugLog("here")
            NRD_CharacterSetPermanentBoostInt(target, stat, 0)
            CharacterAddAttribute(target, "Dummy", 0)
        end
    end
end
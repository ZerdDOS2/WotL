function WotL_CustomStatusGetEnterChance(status, useCharacterStats)
    if status.ForceStatus then
        return 100
    end
    return status.CanEnterChance
end

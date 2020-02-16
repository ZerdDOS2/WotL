function WotL_CheckMagicArtifact(char)
    local weaponSlot = CharacterGetEquippedItem(char, "Weapon")
    local weaponStatsID, weaponSlotType
    if weaponSlot ~= nil then
        weaponStatsID = NRD_ItemGetStatsId(weaponSlot)
        weaponSlotType = NRD_StatGetString(weaponStatsID, "WeaponType")
    end

    local shieldSlot = CharacterGetEquippedItem(char, "Shield")
    local shieldStatsID, shieldSlotType
    if shieldSlot ~= nil then
        shieldStatsID = NRD_ItemGetStatsId(shieldSlot)
        if NRD_StatGetType(shieldStatsID) == "Weapon" then
            shieldSlotType = NRD_StatGetString(shieldStatsID, "WeaponType")
        end
    end

    local hasMagicArtifact = false
    if weaponSlotType == "Wand" or weaponSlotType == "Staff" or shieldSlotType == "Wand" then
        hasMagicArtifact = true
    end
    
    if not bool(HasActiveStatus(char, "WotL_MagicArtifactUser")) and hasMagicArtifact then
        ApplyStatus(char, "WotL_MagicArtifactUser", -1.0, 1)
    elseif bool(HasActiveStatus(char, "WotL_MagicArtifactUser")) and  not hasMagicArtifact then
        RemoveStatus(char, "WotL_MagicArtifactUser")
    end
end

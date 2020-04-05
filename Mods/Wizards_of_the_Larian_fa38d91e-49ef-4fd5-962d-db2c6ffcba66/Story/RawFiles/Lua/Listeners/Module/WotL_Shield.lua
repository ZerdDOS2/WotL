-- Replaces physical armor for magic armor on shield equipments.
-- Mostly used for boosts, since the base shield was changed using stats overwrites.
local function WotL_ChangeShieldArmor(shield)
    local phys = Ext.StatGetAttribute(shield, "Armor Defense Value")
    if phys ~= nil and phys ~= 0 then
        local mag = Ext.StatGetAttribute(shield, "Magic Armor Value")
        WotL_ModulePrint("Physical: " .. tostring(phys) .. " | Magic: " .. tostring(mag), "Armor")
        if phys > mag then
            Ext.StatSetAttribute(shield, "Magic Armor Value", phys)
        end
        Ext.StatSetAttribute(shield, "Armor Defense Value", 0)
    end
end

---------------------------------------- MODULE FUNCTION ----------------------------------------

function WotL_ModuleShield()
    for _, shield in pairs(Ext.GetStatEntries("Shield")) do
        WotL_ModulePrint("Shield: " .. shield, "Shield")

        WotL_ChangeShieldArmor(shield)
    end
end

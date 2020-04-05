-- Changes the HealStat property of from physical armor
-- or all armor to magic armor.
local function WotL_ChangeStatusArmor(status)
    local healStat = Ext.StatGetAttribute(status, "HealStat")
    if healStat == "PhysicalArmor" or healStat == "AllArmor" then
        WotL_ModulePrint("Changed HealStat", "Status")
        Ext.StatSetAttribute(status, "HealStat", "MagicArmor")
    end
end

-- Removes the saving throw property of all statuses. There are
-- still some hardcoded statuses that are handled with the
-- StatusEnterChance listener, but this helps removing the
-- little shield in the skill's descriptions
local function WotL_RemoveStatusSavingThrow(status)
    Ext.StatSetAttribute(status, "SavingThrow", "None")
end

---------------------------------------- MODULE FUNCTION ----------------------------------------

function WotL_ModuleStatus()
    for _, status in pairs(Ext.GetStatEntries("StatusData")) do
        WotL_ModulePrint("Status" .. status, "Status")

        WotL_ChangeStatusArmor(status)
        WotL_RemoveStatusSavingThrow(status)
    end
end

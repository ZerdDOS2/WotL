Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_Abilities.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ArmorSpeciality.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_Attributes.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_CustomHitChance.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_MagicArtifacts.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_PhysicalDamage.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_StatusEnterChance.lua")

local gameSessionLoad = function ()
   Ext.StatusGetEnterChance = CustomStatusGetEnterChance_WotL
   Ext.GetHitChance = CustomGetHitChance_WotL
   Ext.EnableStatOverride("HitChance")
end

-- local moduleLoad = function ()
--    for i,name in pairs(Ext.GetStatEntries("SkillData")) do
--        Ext.StatSetAttribute(name, "DamageType", "Air")
--    end
-- end

Ext.RegisterListener("SessionLoading", gameSessionLoad)
-- Ext.RegisterListener("ModuleLoading", moduleLoad)

function bool(v)
    if v == 0 then
       return false
    elseif v == 1 then
       return true
    else
       return false
    end
end

Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_Helpers.lua")

Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_Abilities.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ArmorSpeciality.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_Attributes.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_Backstab.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_CustomHitChance.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_MagicArtifacts.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_PhysicalDamage.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_Resistances.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_StatusEnterChance.lua")

-- Module Load Functions
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModuleSkillAP.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModuleSkillMemorization.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModuleSkillRange.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModuleSkillWeaponize.lua")

local WotL_GameSessionLoad = function ()
    Ext.StatusGetEnterChance = WotL_CustomStatusGetEnterChance
    Ext.GetHitChance = WotL_CustomGetHitChance
    Ext.EnableStatOverride("HitChance")
end

local WotL_ModuleLoad = function ()
    Ext.Print("===================================================================")
    Ext.Print("[WotL:Bootstrap.lua] Module Load Start")
    Ext.Print("===================================================================")
    for i,skill in pairs(Ext.GetStatEntries("SkillData")) do
        Ext.Print("Skill: " .. skill)
        local type = Ext.StatGetAttribute(skill, "SkillType")
        
        WotL_ChangeSkillAP(skill, type)
        WotL_ChangeSkillMemorizationRequirements(skill, type)
        WotL_ChangeSkillRange(skill, type)
        WotL_WeaponizeSkill(skill)
    end
    Ext.Print("===================================================================")
    Ext.Print("[WotL:Bootstrap.lua] Module Load Finished")
    Ext.Print("===================================================================")
end

Ext.RegisterListener("SessionLoading", WotL_GameSessionLoad)
Ext.RegisterListener("ModuleLoading", WotL_ModuleLoad)

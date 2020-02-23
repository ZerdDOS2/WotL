-- Lib
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_Helpers.lua")

-- Listeners (Core overrides)
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_CustomHitChance.lua")
-- Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_StatusEnterChance.lua")

-- Module Load Functions
-- Common
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModuleCommon.lua")
-- Character
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModuleCharacterArmor.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModuleCharacterTalent.lua")
-- Potions
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModulePotionArmor.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModulePotionMovement.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModulePotionPreset.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModulePotionResistance.lua")
-- Skills
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModuleSkillAP.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModuleSkillDescription.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModuleSkillMemorization.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModuleSkillPreset.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModuleSkillRange.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModuleSkillWeaponize.lua")
-- Status
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModuleStatusArmor.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModuleStatusSavingThrow.lua")
-- Weapons
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModuleWeaponAP.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModuleWeaponPreset.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModuleWeaponRange.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ModuleWeaponRequirements.lua")

-- In-game scripts
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_Abilities.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_ArmorSpeciality.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_Attributes.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_Backstab.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_DamageManager.lua")
Ext.Require("Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66","WotL_Resistances.lua")

local WotL_GameSessionLoad = function ()
    -- Ext.StatusGetEnterChance = WotL_CustomStatusGetEnterChance
    Ext.GetHitChance = WotL_CustomGetHitChance
    Ext.EnableStatOverride("HitChance")
end

local WotL_ModuleLoad = function ()
    Ext.Print("===================================================================")
    Ext.Print("[WotL:Bootstrap.lua] Module Load Start")
    Ext.Print("===================================================================")

    for _, character in pairs(Ext.GetStatEntries("Character")) do
        WotL_ModulePrint("Character: " .. character, "Character")

        WotL_ChangeCharacterArmor(character)
        -- Currently refunds talents given upon preset change on CC
        -- WotL_ChangeInnateTalents(character)
    end

    WotL_PreparePotionPresets()
    for _, potion in pairs(Ext.GetStatEntries("Potion")) do
        WotL_ModulePrint("Potion: " .. potion, "Potion")

        WotL_ChangePotionArmor(potion)
        WotL_ChangePotionMovement(potion)
        WotL_ChangePotionResistance(potion)
        WotL_ChangePotionPreset(potion)
        -- WotL_MapPotionResistance(potion)
    end
    -- tprint(WotL_PotionResistanceTable)

    WotL_PrepareSkillPresets()
    for _, skill in pairs(Ext.GetStatEntries("SkillData")) do
        WotL_ModulePrint("Skill: " .. skill, "Skill")
        local type = Ext.StatGetAttribute(skill, "SkillType")
        
        WotL_ChangeSkillAP(skill, type)
        -- Change skill damage from physical armor (Reactive Armor and Bouncing Shield)
        WotL_ChangeSkillDescription(skill)
        WotL_ChangeSkillMemorizationRequirements(skill, type)
        WotL_ChangeSkillRange(skill, type)
        WotL_WeaponizeSkill(skill)
        WotL_ChangeSkillPreset(skill)
    end
    
    for _, status in pairs(Ext.GetStatEntries("StatusData")) do
        WotL_ModulePrint("Status" .. status, "Status")

        WotL_ChangeStatusArmor(status)
        WotL_RemoveStatusSavingThrow(status)
    end

    -- WotL_WeaponPresetDefault = {}
    -- for weapon, properties in pairs(WotL_WeaponPresets) do
    --     for attribute, _ in pairs(properties) do
    --         local value = Ext.StatGetAttribute(weapon, attribute)
    --         if WotL_WeaponPresetDefault[weapon] ~= nil then
    --             table.insert(WotL_WeaponPresetDefault[weapon], {[attribute] = value})
    --         else
    --             WotL_WeaponPresetDefault[weapon] = {[attribute] = value}
    --         end
    --     end
    -- end
    for _, weapon in pairs(Ext.GetStatEntries("Weapon")) do
        WotL_ModulePrint("Weapon: " .. weapon, "Weapon")
        
        -- WotL_ChangeWeaponPreset(weapon)
        WotL_ChangeWeaponAP(weapon)
        WotL_ChangeWeaponRange(weapon)
        WotL_RemoveWeaponRequirements(weapon)
    end
    
    Ext.Print("===================================================================")
    Ext.Print("[WotL:Bootstrap.lua] Module Load Finished")
    Ext.Print("===================================================================")
end

Ext.RegisterListener("SessionLoading", WotL_GameSessionLoad)
Ext.RegisterListener("ModuleLoading", WotL_ModuleLoad)

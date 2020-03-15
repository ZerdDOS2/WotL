-- Doubles the skill AP cost, up to 6.
-- Also increases the minimum AP cost for Mobility skills to 4.
local function WotL_ChangeSkillAP(skill, type)
    local AP = Ext.StatGetAttribute(skill, "ActionPoints")
    if AP ~= nil and AP ~= 0 then
        local new = math.min(2*AP, 6)
        if ENUM_WotL_MobilitySkillTypes[type] then
            new = math.max(new, 4)
        end
        WotL_ModulePrint("AP: " .. tostring(AP) .. " -> " .. tostring(new), "Skill")
        Ext.StatSetAttribute(skill, "ActionPoints", new)
    end
end

-- Changes the scaling of skill damages from physical armor to magic armor.
-- It also applies a scaling factor, since there's no SourceShieldMagicArmor
-- damage type.
local function WotL_ChangeSkillDamage(skill)
    local source = Ext.StatGetAttribute(skill, "Damage")
    for type, list in pairs(ENUM_WotL_ArmorDamageSourceTypes) do
        if source == type then
            local damage = Ext.StatGetAttribute(skill, "Damage Multiplier")
            for replace, multiplier in pairs(list) do
                local new = math.ceil(damage * multiplier)
                WotL_ModulePrint("Skill: " .. tostring(skill), "Skill")
                WotL_ModulePrint("Source: " .. tostring(source) .. " -> " .. tostring(replace), "Skill")
                WotL_ModulePrint("Damage: " .. tostring(damage) .. " -> " .. tostring(new), "Skill")
                Ext.StatSetAttribute(skill, "Damage", replace)
                Ext.StatSetAttribute(skill, "Damage Multiplier", new)
                ENUM_WotL_MissingSkills[skill] = true
                break
            end
            break
        end
    end
end

-- Replaces the description parameters from armor to magic armor. The actual potion
-- or status changes happens on the appropriate modules.
local function WotL_ChangeSkillDescription(skill)
    local params = Ext.StatGetAttribute(skill, "StatsDescriptionParams")
    local new, count = string.gsub(params, ":Armor", ":MagicArmor")
    if count > 0 then
        WotL_ModulePrint("Description Parameters: " .. params .. " -> " .. new, "Skill")
        Ext.StatSetAttribute(skill, "StatsDescriptionParams", new)
    end
end

-- TODO: Change the book usage requirements alongside the skills. Might have to save the skills
-- here with their new requirements somewhere for later usage

-- Doubles the Memorization Requirements of Mobility skills, with a maximum of 5.
local function WotL_ChangeSkillMemorizationRequirements(skill, type)
    local memRequirements = Ext.StatGetAttribute(skill, "MemorizationRequirements")
    if ENUM_WotL_MobilitySkillTypes[type] then
        for _, r in pairs(memRequirements) do
            if not r["Not"] then
                r["Param"] = math.min(2*r["Param"], 5)
            end
        end
        WotL_ModuleTPrint(memRequirements, "Skill")
        Ext.StatSetAttribute(skill, "MemorizationRequirements", memRequirements)
    end
end

-- Decreases the skill range, only if it's between 5 and 25 m.
local function WotL_ChangeSkillRange(skill, type)
    for attribute, typeList in pairs(ENUM_WotL_SkillRangeAttributes) do
        if typeList[type] then
            local range = Ext.StatGetAttribute(skill, attribute)
            if range > 5 and range < 25 then
                local new = math.ceil(WotL_Truncate(WotL_NormalizeRange(range), 1))
                WotL_ModulePrint("Range (" .. attribute .. "): " .. tostring(range) .. " -> " .. tostring(new), "Skill")
                Ext.StatSetAttribute(skill, attribute, new)
            end
        end
    end
end

-- Makes the skill scale on weapon damage, except explicitly declared missable skills
-- that don't need to scale from weapon damage, such as armor scaling skills and
-- grenades. Those won't have the % indication, but are still allowed to miss
local function WotL_WeaponizeSkill(skill)
    if ENUM_WotL_MissingSkills[skill] then
        return
    end
    Ext.StatSetAttribute(skill, "UseWeaponDamage", "Yes")
end

-------------------------------------------- PRESETS --------------------------------------------

local WotL_SkillsLookFor = {}
local WotL_SkillsProperties = {}
-- Saves the stats and properties that will suffer preset changes.
local function WotL_PrepareSkillPresets()
    for skill, list in pairs(ENUM_WotL_SkillPresets) do
        WotL_SkillsLookFor[skill] = true
        for attribute, _ in pairs(list) do
            WotL_SkillsProperties[attribute] = true
        end
    end
end

local WotL_DefaultSkillProperties = {}
-- Applies the preset changes, based on the stats and properties saved of the root parent.
-- If the root parent matches the defined stat, the current stat suffer the preset change
-- if the property value matches the default value for the root parent stat.
local function WotL_ChangeSkillPreset(skill)
    if WotL_SkillsLookFor[skill] then
        WotL_DefaultSkillProperties[skill] = {}
        for attribute, _ in pairs(WotL_SkillsProperties) do
            WotL_DefaultSkillProperties[skill][attribute] = Ext.StatGetAttribute(skill, attribute)
        end
    end

    for stat, list in pairs(ENUM_WotL_SkillPresets) do
        local parent = WotL_GetRootParent(skill)
        if parent == stat then
            for attribute, value in pairs(list) do
                local curr = Ext.StatGetAttribute(skill, attribute)
                if curr == WotL_DefaultSkillProperties[parent][attribute] then
                    WotL_ModulePrint("------ PRESET APPLIED ------", "Skill")
                    WotL_ModulePrint(tostring(attribute) .. ": " .. tostring(curr) .. " -> " .. tostring(value), "Skill")
                    Ext.StatSetAttribute(skill, attribute, value)
                end
            end
            break
        end
    end
end

---------------------------------------- MODULE FUNCTION ----------------------------------------

function WotL_ModuleSkill()
    WotL_PrepareSkillPresets()
    for _, skill in pairs(Ext.GetStatEntries("SkillData")) do
        WotL_ModulePrint("Skill: " .. skill, "Skill")
        local type = Ext.StatGetAttribute(skill, "SkillType")
        
        WotL_ChangeSkillAP(skill, type)
        -- The skill damage change has to come before WeaponizeSkill, so the
        -- ENUM_WotL_MissingSkills are completely populated beforehand
        WotL_ChangeSkillDamage(skill)
        WotL_ChangeSkillDescription(skill)
        WotL_ChangeSkillMemorizationRequirements(skill, type)
        WotL_ChangeSkillRange(skill, type)
        WotL_WeaponizeSkill(skill)
        WotL_ChangeSkillPreset(skill)
    end
end

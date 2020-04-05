DamageTypeToDeathTypeMap = {
    Physical = "Physical",
    Piercing = "Piercing",
    Fire = "Incinerate",
    Air = "Electrocution",
    Water = "FrozenShatter",
    Earth = "PetrifiedShatter",
    Poison = "Acid"
}

function DamageTypeToDeathType(damageType)
    local deathType = DamageTypeToDeathTypeMap[damageType]
    if deathType ~= nil then
        return deathType
    else
        return "Sentinel"
    end
end

function IsRangedWeapon(item)
    local type = item.WeaponType
    return type == "Bow" or type == "Crossbow" or type == "Wand" or type == "Rifle"
end

function ScaledDamageFromPrimaryAttribute(primaryAttr)
    return (primaryAttr - Ext.ExtraData.AttributeBaseValue) * Ext.ExtraData.DamageBoostFromAttribute
end

function GetPrimaryAttributeAmount(skill, character)
    if skill.UseWeaponDamage == "Yes" and character.MainWeapon ~= nil then
        local main = character.MainWeapon
        local offHand = character.OffHandWeapon
        if offHand ~= nil and IsRangedWeapon(main) == IsRangedWeapon(offHand) then
            return (GetItemRequirementAttribute(character, main) + GetItemRequirementAttribute(character, offHand)) * 0.5
        else
            return GetItemRequirementAttribute(character, main)
        end
    end

    local ability = skill.Ability
    if ability == "Warrior" or ability == "Polymorph" then
        return character.Strength
    elseif ability == "Ranger" or ability == "Rogue" then
        return character.Finesse
    else
        return character.Intelligence
    end
end

function GetSkillAttributeDamageScale(skill, attacker)
    if attacker == nil or skill.UseWeaponDamage == "Yes" or skill.Ability == 0 then
        return 1.0
    else
        local primaryAttr = GetPrimaryAttributeAmount(skill, attacker)
        return 1.0 + ScaledDamageFromPrimaryAttribute(primaryAttr)
    end
end

function GetDamageMultipliers(skill, attacker, stealthed, attackerPos, targetPos)
    local stealthDamageMultiplier = 1.0
    if stealthed then
        local globalBonus = Ext.ExtraData['Sneak Damage Multiplier']
        local skillBonus = skill['Stealth Damage Multiplier'] * 0.01
        if skillBonus > 0 then
            skillBonus = skillBonus - 1.0
        end
        local talentBonus = 0.0
        if attacker.TALENT_SurpriseAttack then
            talentBonus = Ext.ExtraData.TalentSneakingDamageBonus * 0.01
        end
        stealthDamageMultiplier = globalBonus + skillBonus + talentBonus
    end

    local targetDistance = 1.0
    if attackerPos ~= nil and targetPos ~= nil then
        targetDistance = math.sqrt((attackerPos[1] - targetPos[1])^2 + (attackerPos[3] - targetPos[3])^2)
    end
    local distanceDamageMultiplier = 1.0
    if targetDistance > 1.0 then
        distanceDamageMultiplier = Ext.Round(targetDistance) * skill['Distance Damage Multiplier'] * 0.01 + 1
    end

    local damageMultiplier = skill['Damage Multiplier'] * 0.01
    return stealthDamageMultiplier * distanceDamageMultiplier * damageMultiplier
end

function GetVitalityBoostByLevel(level)
    local extra = Ext.ExtraData
    local expGrowth = extra.VitalityExponentialGrowth
    local growth = expGrowth ^ (level - 1)

    if level >= extra.FirstVitalityLeapLevel then
        growth = growth * extra.FirstVitalityLeapGrowth / expGrowth
    end

    if level >= extra.SecondVitalityLeapLevel then
        growth = growth * extra.SecondVitalityLeapGrowth / expGrowth
    end

    if level >= extra.ThirdVitalityLeapLevel then
        growth = growth * extra.ThirdVitalityLeapGrowth / expGrowth
    end

    if level >= extra.FourthVitalityLeapLevel then
        growth = growth * extra.FourthVitalityLeapGrowth / expGrowth
    end

    local vit = level * extra.VitalityLinearGrowth + extra.VitalityStartingAmount * growth
    return Ext.Round(vit / 5.0) * 5.0
end

function GetLevelScaledDamage(level)
    local vitalityBoost = GetVitalityBoostByLevel(level)
    return vitalityBoost / (((level - 1) * Ext.ExtraData.VitalityToDamageRatioGrowth) + Ext.ExtraData.VitalityToDamageRatio)
end

function GetAverageLevelDamage(level)
    local scaled = GetLevelScaledDamage(level)
    return ((level * Ext.ExtraData.ExpectedDamageBoostFromAttributePerLevel) + 1.0) * scaled
        * ((level * Ext.ExtraData.ExpectedDamageBoostFromSkillAbilityPerLevel) + 1.0)
end

function GetLevelScaledWeaponDamage(level)
    local scaledDmg = GetLevelScaledDamage(level)
    return ((level * Ext.ExtraData.ExpectedDamageBoostFromWeaponAbilityPerLevel) + 1.0) * scaledDmg
end

function GetLevelScaledMonsterWeaponDamage(level)
    local weaponDmg = GetLevelScaledWeaponDamage(level)
    return ((level * Ext.ExtraData.MonsterDamageBoostPerLevel) + 1.0) * weaponDmg
end

DamageBoostTable = {
    Physical = function (character)
        return character.WarriorLore * Ext.ExtraData.SkillAbilityPhysicalDamageBoostPerPoint
    end,
    Fire = function (character)
        return character.FireSpecialist * Ext.ExtraData.SkillAbilityFireDamageBoostPerPoint
    end,
    Air = function (character)
        return character.AirSpecialist * Ext.ExtraData.SkillAbilityAirDamageBoostPerPoint
    end,
    Water = function (character)
        return character.WaterSpecialist * Ext.ExtraData.SkillAbilityWaterDamageBoostPerPoint
    end,
    Earth = function (character)
        return character.EarthSpecialist * Ext.ExtraData.SkillAbilityPoisonAndEarthDamageBoostPerPoint
    end,
    Poison = function (character)
        return character.EarthSpecialist * Ext.ExtraData.SkillAbilityPoisonAndEarthDamageBoostPerPoint
    end
}

function GetDamageBoostByType(character, damageType)
    local boostFunc = DamageBoostTable[damageType]
    if boostFunc ~= nil then
        return boostFunc(character) / 100.0
    else
        return 0.0
    end
end

function ApplyDamageBoosts(character, damageList)
    for i, damage in pairs(damageList:ToTable()) do
        local boost = GetDamageBoostByType(character, damage.DamageType)
        if boost > 0.0 then
            damageList:Add(damage.DamageType, Ext.Round(damage.Amount * boost))
        end
    end
end

local DamageSourceCalcTable = {
    BaseLevelDamage = function (attacker, target, level)
        return Ext.Round(GetLevelScaledDamage(level))
    end,
    AverageLevelDamge = function (attacker, target, level)
        return Ext.Round(GetAverageLevelDamage(level))
    end,
    MonsterWeaponDamage = function (attacker, target, level)
        return Ext.Round(GetLevelScaledMonsterWeaponDamage(level))
    end,
    SourceMaximumVitality = function (attacker, target, level)
        return attacker.MaxVitality
    end,
    SourceMaximumPhysicalArmor = function (attacker, target, level)
        return attacker.MaxArmor
    end,
    SourceMaximumMagicArmor = function (attacker, target, level)
        return attacker.MaxMagicArmor
    end,
    SourceCurrentVitality = function (attacker, target, level)
        return attacker.CurrentVitality
    end,
    SourceCurrentPhysicalArmor = function (attacker, target, level)
        return attacker.CurrentArmor
    end,
    SourceCurrentMagicArmor = function (attacker, target, level)
        return attacker.CurrentMagicArmor
    end,
    SourceShieldPhysicalArmor = function (attacker, target, level)
        error("SourceShieldPhysicalArmor NOT IMPLEMENTED YET")
    end,
    TargetMaximumVitality = function (attacker, target, level)
        return target.MaxVitality
    end,
    TargetMaximumPhysicalArmor = function (attacker, target, level)
        return target.MaxArmor
    end,
    TargetMaximumMagicArmor = function (attacker, target, level)
        return target.MaxMagicArmor
    end,
    TargetCurrentVitality = function (attacker, target, level)
        return target.CurrentVitality
    end,
    TargetCurrentPhysicalArmor = function (attacker, target, level)
        return target.CurrentArmor
    end,
    TargetCurrentMagicArmor = function (attacker, target, level)
        return target.CurrentMagicArmor
    end
}

function CalculateBaseDamage(skillDamageType, attacker, target, level)
    return DamageSourceCalcTable[skillDamageType](attacker, target, level)
end

function GetDamageListDeathType(damageList)
    local biggestDamage = -1
    local deathType

    for i, damage in pairs(damageList:ToTable()) do
        if damage.Amount > biggestDamage then
            deathType = DamageTypeToDeathType(damage.DamageType)
            biggestDamage = damage.Amount
        end
    end

    return deathType
end

function GetWeaponAbility(character, weapon)
    if weapon == nil then
        return nil
    end

    local offHandWeapon = character.OffHandWeapon
    if offHandWeapon ~= nil and IsRangedWeapon(weapon) and IsRangedWeapon(offHandWeapon) then
        return "DualWielding"
    end

    local weaponType = weapon.WeaponType
    if weaponType == "Bow" or weaponType == "Crossbow" or weaponType == "Rifle" then
        return "Ranged"
    end

    if weapon.IsTwoHanded then
        return "TwoHanded"
    end

    return "SingleHanded"
end

function ComputeWeaponCombatAbilityBoost(character, weapon)
    local abilityType = GetWeaponAbility(character, weapon)

    if abilityType == "SingleHanded" or abilityType == "TwoHanded" or abilityType == "Ranged" or abilityType == "DualWielding" then
        local abilityLevel = character[abilityType]
        return abilityLevel * Ext.ExtraData.CombatAbilityDamageBonus
    else
        return 0
    end
end

function GetWeaponScalingRequirement(weapon)
    local requirementName
    local largestRequirement = -1

    for i, requirement in pairs(weapon.Requirements) do
        local reqName = requirement.Name
        if not requirement.Not and requirement.Param > largestRequirement and
            (reqName == "Strength" or reqName == "Finesse" or reqName == "Constitution" or
            reqName == "Memory" or reqName == "Wits") then
            requirementName = reqName
            largestRequirement = requirement.Param
        end
    end

    return requirementName
end

function GetItemRequirementAttribute(character, weapon)
    local attribute = GetWeaponScalingRequirement(weapon)
    if attribute ~= nil then
        return character[attribute]
    else
        return 0
    end
end

function ComputeWeaponRequirementScaledDamage(character, weapon)
    local scalingReq = GetWeaponScalingRequirement(weapon)
    if scalingReq ~= nil then
        return ScaledDamageFromPrimaryAttribute(character[scalingReq]) * 100.0
    else
        return 0
    end
end

function ComputeBaseWeaponDamage(weapon)
    local damages = {}
    local stats = weapon.DynamicStats
    local baseStat = stats[1]
    local baseDmgFromBase = baseStat.DamageFromBase * 0.01
    local baseMinDamage = baseStat.MinDamage
    local baseMaxDamage = baseStat.MaxDamage
    local damageBoost = 0

    for i, stat in pairs(stats) do
        if stat.StatsType == "Weapon" and stat.DamageType ~= "None" then
            local dmgType = stat.DamageType
            local dmgFromBase = stat.DamageFromBase * 0.01
            local minDamage = stat.MinDamage
            local maxDamage = stat.MaxDamage

            if dmgFromBase ~= 0 then
                if stat == baseStat then
                    if baseMinDamage ~= 0 then
                        minDamage = math.max(dmgFromBase * baseMinDamage, 1)
                    end
                    if baseMaxDamage ~= 0 then
                        maxDamage = math.max(dmgFromBase * baseMaxDamage, 1.0)
                    end
                else
                    minDamage = math.max(baseDmgFromBase * dmgFromBase * baseMinDamage, 1.0)
                    maxDamage = math.max(baseDmgFromBase * dmgFromBase * baseMaxDamage, 1.0)
                end
            end

            if minDamage > 0 then
                maxDamage = math.max(maxDamage, minDamage + 1.0)
            end

            damageBoost = damageBoost + stat.DamageBoost

            if damages[dmgType] == nil then
                damages[dmgType] = {
                    Min = minDamage,
                    Max = maxDamage
                }
            else
                local damage = damages[dmgType]
                damage.Min = damage.Min + minDamage
                damage.Max = damage.Max + maxDamage
            end
        end
    end

    return damages, damageBoost
end

-- from CDivinityStats_Character::CalculateWeaponDamageInner and CDivinityStats_Item::ComputeScaledDamage
function CalculateWeaponScaledDamage(character, weapon, damageList, noRandomization)
    local damages, damageBoost = ComputeBaseWeaponDamage(weapon)

    local abilityBoosts = character.DamageBoost 
        + ComputeWeaponCombatAbilityBoost(character, weapon)
        + ComputeWeaponRequirementScaledDamage(character, weapon)
    abilityBoosts = math.max(abilityBoosts + 100.0, 0.0) / 100.0

    local boost = 1.0 + damageBoost * 0.01

    for damageType, damage in pairs(damages) do
        local min = math.ceil(damage.Min * boost * abilityBoosts)
        local max = math.ceil(damage.Max * boost * abilityBoosts)

        local randRange = 1
        if max - min >= 1 then
            randRange = max - min
        end

        local finalAmount
        if noRandomization then
            finalAmount = min + math.floor(randRange / 2)
        else
            finalAmount = min + Ext.Random(0, randRange)
        end

        damageList:Add(damageType, finalAmount)
    end
end

function CalculateWeaponDamage(attacker, weapon, noRandomization, isOffHand)
    local damageList = Ext.NewDamageList()

    CalculateWeaponScaledDamage(attacker, weapon, damageList, noRandomization)

    local offHand = attacker.OffHandWeapon
    if weapon ~= offHand and false then -- Temporarily off
        local bonusWeapons = attacker.BonusWeapons -- FIXME - enumerate BonusWeapons /multiple/ from character stats!
        for i, bonusWeapon in pairs(bonusWeapons) do
            -- FIXME Create item from bonus weapon stat and apply attack as item???
            error("BonusWeapons not implemented")
            local bonusWeaponStats = CreateBonusWeapon(bonusWeapon)
            CalculateWeaponScaledDamage(attacker, bonusWeaponStats, damageList, noRandomization)
        end
    end

    if isOffHand then
        damageList:Multiply(Ext.ExtraData.DualWieldingDamagePenalty)
    end

    return damageList
end

-- Returns the non-weapon skill multiplier based on the character's weapon
function GetNonWeaponSkillMultiplier(skill, weapon)
    if skill.UseWeaponDamage == "Yes" then
        return 1.0
    end

    -- Reduces the damage of non-weapon skills while not wielding a staff or a wand
    if weapon.WeaponType ~= "Staff" and weapon.WeaponType ~= "Wand" then
        return Ext.ExtraData.WotL_NonWeaponSkillsDamagePenalty
    end

    -- Increases the damage of non-weapon skills while wielding a staff or a wand
    return Ext.ExtraData.WotL_NonWeaponSkillsDamageBonus
end

function ShouldUseWeaponDamage(skill, attacker, isFromItem)
    -- Weapon skills use weapon damage
    if skill.UseWeaponDamage == "Yes" then
        return true
    end

    -- Skills from grenades and items don't use weapon damage
    if isFromItem then
        return false
    end

    -- Non-players and summons won't scale normal skills from weapons
    if not attacker.IsPlayer or attacker.Character:GetStatus("SUMMONING_ABILITY") ~= nil then
        return false
    end

    -- Only those damage scalings are being converted to scale from weapon
    if skill.Damage == "BaseLevelDamage" or skill.Damage == "AverageLevelDamge" then
        return true
    end

    -- All other damage scalings keep their scaling
    return false
end

function GetSkillDamage(skill, attacker, isFromItem, stealthed, attackerPos, targetPos, level, noRandomization)
    if attacker ~= nil and level < 0 then
        level = attacker.Level
    end

    local damageMultiplier = skill['Damage Multiplier'] * 0.01
    if damageMultiplier <= 0 then
        return
    end

    local damageMultipliers = GetDamageMultipliers(skill, attacker, stealthed, attackerPos, targetPos)
    local skillDamageType = nil

    if level == 0 then
        level = skill.OverrideSkillLevel
        if level == 0 then
            level = skill.Level
        end
    end

    local damageList = Ext.NewDamageList()

    if ShouldUseWeaponDamage(skill, attacker, isFromItem) then
        local damageType = skill.DamageType
        if damageType == "None" or damageType == "Sentinel" then
            damageType = nil
        end

        local weapon = attacker.MainWeapon
        local offHand = attacker.OffHandWeapon

        if weapon ~= nil then
            local mainDmgs = CalculateWeaponDamage(attacker, weapon, noRandomization, false)
            local weaponMultiplier = GetNonWeaponSkillMultiplier(skill, weapon)
            mainDmgs:Multiply(damageMultipliers * weaponMultiplier)
            if damageType ~= nil then
                mainDmgs:ConvertDamageType(damageType)
                skillDamageType = damageType
            end
            damageList:Merge(mainDmgs)
        end

        if offHand ~= nil and IsRangedWeapon(weapon) == IsRangedWeapon(offHand) then
            local offHandDmgs = CalculateWeaponDamage(attacker, offHand, noRandomization, true)
            local weaponMultiplier = GetNonWeaponSkillMultiplier(skill, weapon)
            offHandDmgs:Multiply(damageMultipliers * weaponMultiplier)
            if damageType ~= nil then
                offHandDmgs:ConvertDamageType(damageType)
            end
            damageList:Merge(offHandDmgs)
        end

        damageList:AggregateSameTypeDamages()
    else
        local damageType = skill.DamageType

        local baseDamage = CalculateBaseDamage(skill.Damage, attacker, 0, level)
        local damageRange = skill['Damage Range']
        local randomMultiplier
        if noRandomization then
            randomMultiplier = 1.0
        else
            randomMultiplier = 1.0 + (Ext.Random(0, damageRange) - damageRange/2) * 0.01
        end

        -- FIXME damage types???
        local attrDamageScale
        local skillDamage = skill.Damage
        if skillDamage == "BaseLevelDamage" or skillDamage == "AverageLevelDamge" then
            attrDamageScale = GetSkillAttributeDamageScale(skill, attacker)
        else
            attrDamageScale = 1.0
        end

        local damageBoost
        if attacker ~= nil then
            damageBoost = attacker.DamageBoost / 100.0 + 1.0
        else
            damageBoost = 1.0
        end
		
        local finalDamage = baseDamage * randomMultiplier * attrDamageScale * damageMultipliers
        finalDamage = math.max(Ext.Round(finalDamage), 1)
        finalDamage = math.ceil(finalDamage * damageBoost)
        damageList:Add(damageType, finalDamage)
    end

    if attacker ~= nil then
        ApplyDamageBoosts(attacker, damageList)
    end

    local deathType = skill.DeathType
    if deathType == "None" then
        if skill.UseWeaponDamage == "Yes" then
            deathType = GetDamageListDeathType(damageList)
        else
            if skillDamageType == nil then
                skillDamageType = skill.DamageType
            end

            deathType = DamageTypeToDeathType(skillDamageType)
        end
    end
    return damageList, deathType
end

Ext.RegisterListener("GetSkillDamage", GetSkillDamage)

-- ----------------------------------- TOOLTIP ----------------------------------------------------

local function CalculateWeaponDamageRange(character, weapon)
    local damages, damageBoost = ComputeBaseWeaponDamage(weapon)

    local abilityBoosts = character.DamageBoost
        + ComputeWeaponCombatAbilityBoost(character, weapon)
        + ComputeWeaponRequirementScaledDamage(character, weapon)
    abilityBoosts = math.max(abilityBoosts + 100.0, 0.0) / 100.0

    local boost = 1.0 + damageBoost * 0.01

    local ranges = {}
    for damageType, damage in pairs(damages) do
        local min = math.ceil(damage.Min * boost * abilityBoosts)
        local max = math.ceil(damage.Max * boost * abilityBoosts)

        if min > max then
            max = min
        end

        ranges[damageType] = {min, max}
    end

    return ranges
end

local function GetSkillDamageRange(character, skill, isFromItem)
    local damageMultiplier = GetDamageMultipliers(skill, character, character.NotSneaking, nil, nil) -- FIXME: character.NotSneaking is inverted

    if ShouldUseWeaponDamage(skill, character, isFromItem) then
        local mainWeapon = character.MainWeapon
        local mainDamageRange = CalculateWeaponDamageRange(character, mainWeapon)
        local mainWeaponMultiplier = GetNonWeaponSkillMultiplier(skill, mainWeapon)
        for damageType, range in pairs(mainDamageRange) do
            mainDamageRange[damageType][1] = mainDamageRange[damageType][1] * mainWeaponMultiplier
            mainDamageRange[damageType][2] = mainDamageRange[damageType][2] * mainWeaponMultiplier
        end

        local offHandWeapon = character.OffHandWeapon
        if offHandWeapon ~= nil and IsRangedWeapon(mainWeapon) == IsRangedWeapon(offHandWeapon) then
            local offHandDamageRange = CalculateWeaponDamageRange(character, offHandWeapon)
            local offHandWeaponMultiplier = GetNonWeaponSkillMultiplier(skill, offHandWeapon)

            local dualWieldPenalty = Ext.ExtraData.DualWieldingDamagePenalty
            for damageType, range in pairs(offHandDamageRange) do
                local min = range[1] * dualWieldPenalty * offHandWeaponMultiplier
                local max = range[2] * dualWieldPenalty * offHandWeaponMultiplier
                if mainDamageRange[damageType] ~= nil then
                    mainDamageRange[damageType][1] = mainDamageRange[damageType][1] + min
                    mainDamageRange[damageType][2] = mainDamageRange[damageType][2] + max
                else
                    mainDamageRange[damageType] = {min, max}
                end
            end
        end

        local damageType = skill.DamageType
        if damageType ~= "None" and damageType ~= "Sentinel" then
            local min, max = 0, 0
            for _, range in pairs(mainDamageRange) do
                min = min + range[1]
                max = max + range[2]
            end
    
            mainDamageRange = {}
            mainDamageRange[damageType] = {min, max}
        end

        for damageType, range in pairs(mainDamageRange) do
            local min = Ext.Round(range[1] * damageMultiplier)
            local max = Ext.Round(range[2] * damageMultiplier)
            local boost = GetDamageBoostByType(character, damageType)
            range[1] = min + math.ceil(min * boost)
            range[2] = max + math.ceil(max * boost)
        end

        return mainDamageRange
    else
        local damageType = skill.DamageType
        if damageMultiplier <= 0 then
            return {}
        end

        local level = character.Level
        if (level < 0 or skill.OverrideSkillLevel == "Yes") and skill.Level > 0 then
            level = skill.Level
        end

        local skillDamageType = skill.Damage
        local attrDamageScale
        if skillDamageType == "BaseLevelDamage" or skillDamageType == "AverageLevelDamge" then
            attrDamageScale = GetSkillAttributeDamageScale(skill, character)
        else
            attrDamageScale = 1.0
        end

        local baseDamage = CalculateBaseDamage(skill.Damage, character, 0, level) * attrDamageScale * damageMultiplier
        local damageRange = skill['Damage Range'] * baseDamage * 0.005

        local damageType = skill.DamageType
        local damageTypeBoost = 1.0 + GetDamageBoostByType(character, damageType)
        local damageBoost = 1.0 + (character.DamageBoost / 100.0)
        local damageRanges = {}
        damageRanges[damageType] = {
            math.ceil(math.ceil(Ext.Round(baseDamage - damageRange) * damageBoost) * damageTypeBoost),
            math.ceil(math.ceil(Ext.Round(baseDamage + damageRange) * damageBoost) * damageTypeBoost)
        }
        return damageRanges
    end
end

local DamageColorTable = {
    Physical = "#A8A8A8",
    Corrosive = "#454545",
    Magic = "#7F00FF",
    Fire = "#FE6E27",
    Water = "#4197E2",
    Earth = "#7F3D00",
    Poison = "#65C900",
    Air = "#7D71D9",
    Shadow = "#797980",
    Piercing = "#C80030",
    Chaos = "#C80030",
}

local function getDamageColor(dmgType)
    if DamageColorTable[dmgType] then
        return DamageColorTable[dmgType]
    end

    return "#A8A8A8"
end

local function getDescriptionParam(skill, character, isFromItem, param)
    if param ~= "Damage" then
        return
    end

    local damageRanges = GetSkillDamageRange(character, skill, isFromItem)
    local aux = {}
    for dmgType, range in pairs(damageRanges) do
        table.insert(aux, {dmgType, range})
    end
    table.sort(aux, function(i, j) return i[2][2] > j[2][2] end)

    local damageList = {}
    for _, range in pairs(aux) do
        local dmgType = range[1]
        dmgStr = "<font color='" .. getDamageColor(dmgType) .."'>" .. tostring(math.floor(range[2][1])) .. "-" .. tostring(math.floor(range[2][2]))
        if dmgType == "Magic" then
            dmgStr = dmgStr .. " armour"
        elseif dmgType ~= "Chaos" then
            dmgStr = dmgStr .. " " .. string.lower(dmgType) .." damage"
        end
        dmgStr = dmgStr .. "</font>"
        table.insert(damageList, dmgStr)
    end

    return table.concat(damageList, " + ")
end

if Ext.IsClient() then
    Ext.RegisterListener("SkillGetDescriptionParam", getDescriptionParam)
end

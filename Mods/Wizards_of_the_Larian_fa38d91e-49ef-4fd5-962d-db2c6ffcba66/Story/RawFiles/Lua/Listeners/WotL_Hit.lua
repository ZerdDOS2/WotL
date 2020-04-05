-- ComputeCharacterHit and GetHitChance Listeners Functions

-- Replaces the vanilla multiplicative hit chance with
-- an aditive function. Also makes the minimum 5% and the
-- maximum 95%
local function WotL_CalculateHitChance(attacker, target)
    local dodge = target.Dodge
    local accuracy = attacker.Accuracy
    local cthb = attacker.ChanceToHitBoost

    local hitChance = accuracy + cthb - dodge
    hitChance = math.max(hitChance, 5)
    hitChance = math.min(hitChance, 95)

    return hitChance
end

Ext.RegisterListener("GetHitChance", WotL_CalculateHitChance)

HitFlag = {
    Hit = 1,
    Blocked = 2,
    Dodged = 4,
    Missed = 8,
    CriticalHit = 0x10,
    Backstab = 0x20,
    FromSetHP = 0x40,
    DontCreateBloodSurface = 0x80,
    Reflection = 0x200,
    NoDamageOnOwner = 0x400,
    FromShacklesOfPain = 0x800,
    DamagedMagicArmor = 0x1000,
    DamagedPhysicalArmor = 0x2000,
    DamagedVitality = 0x4000,
    Flanking = 0x8000,
    PropagatedFromOwner = 0x10000,
    Surface = 0x20000,
    DoT = 0x40000,
    ProcWindWalker = 0x80000,
    CounterAttack = 0x100000,
    Poisoned = 0x200000,
    Burning = 0x400000,
    Bleeding = 0x800000,
    NoEvents = 0x80000000
}

function ApplyDamageSkillAbilityBonuses(damageList, attacker)
    if attacker == nil then
        return
    end

    local magicArmorDamage = 0
    local armorDamage = 0

    for i,damage in pairs(damageList:ToTable()) do
        local type = damage.DamageType
        if type == "Magic" or type == "Fire" or type == "Air" or type == "Water" or type == "Earth" or type == "Physical" or type == "Corrosive" or type == "Sulfuric" then
            magicArmorDamage = magicArmorDamage + damage.Amount
        end

        if type == "Physical" or type == "Corrosive" or type == "Sulfuric" then
            armorDamage = armorDamage + damage.Amount
        end
    end

    if magicArmorDamage > 0 then
        local airSpecialist = attacker.AirSpecialist
        if airSpecialist > 0 then
            local magicBonus = airSpecialist * Ext.ExtraData.SkillAbilityDamageToMagicArmorPerPoint
            if magicBonus > 0 then
                magicArmorDamage = math.ceil((magicArmorDamage * magicBonus) / 100.0)
                damageList:Add("Magic", magicArmorDamage)
            end
        end
    end

    if armorDamage > 0 then
        local armorBonus = attacker.WarriorLore * Ext.ExtraData.SkillAbilityDamageToPhysicalArmorPerPoint
        if armorBonus > 0 then
            armorDamage = math.ceil((armorDamage * armorBonus) / 100.0)
            damageList:Add("Corrosive", armorDamage)
        end
    end
end

function GetResistance(character, type)
    if type == "None" or type == "Chaos" then
        return 0
    end

    return character[type .. "Resistance"]
end

function ApplyHitResistances(character, damageList)
    for i,damage in pairs(damageList:ToTable()) do
        local resistance = GetResistance(character, damage.DamageType)
        damageList:Add(damage.DamageType, math.floor(damage.Amount * -resistance / 100.0))
    end
end

function ApplyDamageCharacterBonuses(character, attacker, damageList)
    damageList:AggregateSameTypeDamages()
    ApplyHitResistances(character, damageList)

    ApplyDamageSkillAbilityBonuses(damageList, attacker)
end


function GetAbilityCriticalHitMultiplier(character, ability)
    if ability == "TwoHanded" then
        return Ext.Round(character.TwoHanded * Ext.ExtraData.CombatAbilityCritMultiplierBonus)
    end

    if ability == "RogueLore" then
        return Ext.Round(character.RogueLore * Ext.ExtraData.SkillAbilityCritMultiplierPerPoint)
    end

    return 0
end


function GetCriticalHitMultiplier(weapon, character)
    local criticalMultiplier = 0
    if weapon.ItemType == "Weapon" then
        for i,stat in pairs(weapon.DynamicStats) do
            criticalMultiplier = criticalMultiplier + stat.CriticalDamage
        end 
    end

    -- Removed the check for weapon and abilities, giving a fixed bonus based on TwoHanded
    criticalMultiplier = criticalMultiplier + Ext.Round(character.TwoHanded * Ext.ExtraData.CombatAbilityCritMultiplierBonus)

    if character ~= nil then
        if character.TALENT_Human_Inventive then
            criticalMultiplier = criticalMultiplier + Ext.ExtraData.TalentHumanCriticalMultiplier
        end
    end
  
    return criticalMultiplier * 0.01
end


function ApplyCriticalHit(hit, attacker)
    local mainWeapon = attacker.MainWeapon
    if mainWeapon ~= nil then
        hit.EffectFlags = hit.EffectFlags | HitFlag.CriticalHit;
        hit.DamageMultiplier = hit.DamageMultiplier + (GetCriticalHitMultiplier(mainWeapon, attacker) - 1.0)
    end
end


function ShouldApplyCriticalHit(hit, attacker, hitType, criticalRoll)
    if criticalRoll ~= "Roll" then
        return criticalRoll == "Critical"
    end

    if attacker.TALENT_Haymaker then
        return false
    end

    if hitType == "DoT" or hitType == "Surface" then
        return false
    end

    -- Magic hitType rolls critical as usual. Backstabs no longer are considered critical hits
    -- and Savage Sortilege isn't required. Free Talent Slot!
    return math.random(0, 99) < attacker.CriticalChance
end


function ConditionalApplyCriticalHitMultiplier(hit, target, attacker, hitType, criticalRoll)
    if ShouldApplyCriticalHit(hit, attacker, hitType, criticalRoll) then
        ApplyCriticalHit(hit, attacker)
    end
end

function ConditionalApplyBackstabMultiplier(hit, attacker)
    if (hit.EffectFlags & HitFlag.Backstab) ~= 0 then
        hit.DamageMultiplier = hit.DamageMultiplier * Ext.ExtraData.WotL_BackstabMultiplier
    end
end

-- Modified so all damage procs lifesteal, not only vitality damage
function ApplyLifeSteal(hit, target, attacker, hitType)
    if attacker == nil or hitType == "DoT" or hitType == "Surface" then
        return
    end
    
    local lifesteal = hit.TotalDamageDone

    if (hit.EffectFlags & (HitFlag.FromShacklesOfPain|HitFlag.NoDamageOnOwner|HitFlag.Reflection)) ~= 0 then
        local modifier = Ext.ExtraData.LifestealFromReflectionModifier
        lifesteal = math.floor(lifesteal * modifier)
    end

    if lifesteal > target.CurrentVitality then
        lifesteal = target.CurrentVitality
    end

    if lifesteal > 0 then
        hit.LifeSteal = math.max(math.ceil(lifesteal * attacker.LifeSteal / 100), 0)
    end
end


local function ApplyDamagesToHitInfo(damageList, hit)
    local totalDamage = 0
    for i,damage in pairs(damageList:ToTable()) do
        totalDamage = totalDamage + damage.Amount
        if damage.DamageType == "Chaos" then
            hit.DamageList:Add(hit.DamageType, damage.Amount)
        -- Converting physical damage to earth damage
        elseif damage.DamageType == "Physical" or damage.DamageType == "Sulfur" then
            hit.DamageList:Add("Earth", damage.Amount)
        -- Converting corrosive damage to magic damage
        elseif damage.DamageType == "Corrosive" then
            hit.DamageList:Add("Magic", damage.Amount)
        else
            hit.DamageList:Add(damage.DamageType, damage.Amount)
        end
    end

    hit.TotalDamageDone = hit.TotalDamageDone + totalDamage
end

local function ComputeArmorDamage(damageList, armor)
    local absorption = 0

    local corrosive = damageList:GetByType("Corrosive")
    if corrosive > 0 then
        local damageAmount = math.min(armor, corrosive)
        armor = armor - damageAmount
        absorption = absorption + damageAmount
    end

    for i,damage in pairs(damageList:ToTable()) do
        local type = damage.DamageType
        if type == "Physical" or type == "Sulfur" then
            local damageAmount = math.min(armor, damage.Amount)
            armor = armor - damageAmount
            absorption = absorption + damageAmount
        end
    end

    return absorption
end


local function ComputeMagicArmorDamage(damageList, magicArmor)
    local absorption = 0

    local magic = damageList:GetByType("Magic")
    if magic > 0 then
        local damageAmount = math.min(magicArmor, magic)
        magicArmor = magicArmor - damageAmount
        absorption = absorption + damageAmount
    end

    for i,damage in pairs(damageList:ToTable()) do
        local type = damage.DamageType
        if type == "Fire" or type == "Water" or type == "Air" or type == "Earth" or type == "Poison" then
            local damageAmount = math.min(magicArmor, damage.Amount)
            magicArmor = magicArmor - damageAmount
            absorption = absorption + damageAmount
        end
    end

    return absorption
end

function DoHit(hit, damageList, statusBonusDmgTypes, hitType, target, attacker, missed)
    damageList:AggregateSameTypeDamages()
    damageList:Multiply(hit.DamageMultiplier)

    local totalDamage = 0
    for i,damage in pairs(damageList:ToTable()) do
        totalDamage = totalDamage + damage.Amount
    end

    if totalDamage < 0 then
        damageList:Clear()
    end

    ApplyDamageCharacterBonuses(target, attacker, damageList)
    damageList:AggregateSameTypeDamages()

    for i,damageType in pairs(statusBonusDmgTypes) do
        damageList.Add(damageType, math.ceil(totalDamage * 0.1))
    end

    ApplyDamagesToHitInfo(damageList, hit)
    if hit.TotalDamageDone > 0 and missed then
        hit.TotalDamageDone = 0
        hit.DamageList = Ext.NewDamageList()
        return
    end

    hit.EffectFlags = hit.EffectFlags | HitFlag.Hit
    hit.ArmorAbsorption = hit.ArmorAbsorption + ComputeArmorDamage(damageList, target.CurrentArmor)
    hit.ArmorAbsorption = hit.ArmorAbsorption + ComputeMagicArmorDamage(damageList, target.CurrentMagicArmor)

    if hit.TotalDamageDone > 0 then
        ApplyLifeSteal(hit, target, attacker, hitType)
    else
        hit.EffectFlags = hit.EffectFlags | HitFlag.DontCreateBloodSurface
    end

    if hitType == "Surface" then
        hit.EffectFlags = hit.EffectFlags | HitFlag.Surface
    end

    if hitType == "DoT" then
        hit.EffectFlags = hit.EffectFlags | HitFlag.DoT
    end
end


function GetAttackerDamageMultiplier(attacker, target, highGround)
    if target == nil then
        return 0.0
    end

    if highGround == "HighGround" then
        local rangerLoreBonus = attacker.RangerLore * Ext.ExtraData.SkillAbilityHighGroundBonusPerPoint * 0.01
        return math.max(rangerLoreBonus + Ext.ExtraData.HighGroundBaseDamageBonus, 0.0)
    elseif highGround == "LowGround" then
        return Ext.ExtraData.LowGroundBaseDamagePenalty
    else
        return 0.0
    end
end


function DamageItemDurability(character, item)
    local degradeSpeed = 0
    for i,stats in pairs(item.DynamicStats) do
        degradeSpeed = degradeSpeed + stats.DurabilityDegradeSpeed
    end

    if degradeSpeed > 0 then
        local durability = math.max(0, item.Durability)
        item.Durability = durability
        item.ShouldSyncStats = 1

        if durability == 0 then
            -- FIXME not implemented yet
            -- Ext.ReevaluateItems(character)
        end
    end
end


function ConditionalDamageItemDurability(character, item)
    if not character.InParty or not item.LoseDurabilityOnCharacterHit or item.Unbreakable or not IsRangedWeapon(item) then
        return
    end

    local chance = 100
    if character.TALENT_Durability then
        chance = 50
    end

    if math.random(0, 99) < chance then
        DamageItemDurability(character, item)
    end
end

function IsInFlankingPosition(target, attacker)
    local tPos = target.Position
    local aPos = attacker.Position
    local rot = target.Rotation

    local dx, dy, dz = tPos[1] - aPos[1], tPos[2] - aPos[2], tPos[3] - aPos[3]
    local distanceSq = 1.0 / math.sqrt(dx^2 + dy^2 + dz^2)
    local nx, ny, nz = dx * distanceSq, dy * distanceSq, dz * distanceSq

    local ang = -rot[6] * nx - rot[7] * ny - rot[8] * nz
    return ang > math.cos(0.52359879)
end

function CanBackstab(target, attacker)
    local targetPos = target.Position
    local attackerPos = attacker.Position

    local atkDir = {}
    for i=1,3 do
        atkDir[i] = attackerPos[i] - targetPos[i]
    end

    local atkAngle = math.deg(math.atan(atkDir[3], atkDir[1]))
    if atkAngle < 0 then
        atkAngle = 360 + atkAngle
    end

    local targetRot = target.Rotation
    angle = math.deg(math.atan(-targetRot[1], targetRot[3]))
    if angle < 0 then
        angle = 360 + angle
    end

    relAngle = atkAngle - angle
    if relAngle < 0 then
        relAngle = 360 + relAngle
    end

    if relAngle >= 150 and relAngle <= 210 then
        return true
    end

    return false
end

function ComputeCharacterHit(target, attacker, weapon, damageList, hitType, noHitRoll, forceReduceDurability, hit, alwaysBackstab, highGroundFlag, criticalRoll)
    hit.DamageMultiplier = 1.0
    hit.DamageList = Ext.NewDamageList()
    local statusBonusDmgTypes = {}
    
    if attacker == nil then
        DoHit(hit, damageList, statusBonusDmgTypes, hitType, target, attacker, false)
        return hit
    end

    -- Pyrokinetic extra damage to Surfaces and DoTs
    if hitType == "Surface" or hitType == "DoT" then
        hit.DamageMultiplier = 1.0 + attacker.FireSpecialist * Ext.ExtraData.WotL_PyrokineticExtraDamage * 0.01
    end

    -- Removed hitType == "Magic" so skills go through the same process as weapon attacks
    -- Also removed the call to ConditionalApplyCriticalHitMultiplier, since it'll never apply for
    -- those hitTypes
    if hitType == "Surface" or hitType == "DoT" or hitType == "Reflected" then
        DoHit(hit, damageList, statusBonusDmgTypes, hitType, target, attacker, false)
        return hit
    end

    -- Moved the HighGround multiplier under the static damage effects, so they aren't affected by HighGround
    hit.DamageMultiplier = 1.0 + GetAttackerDamageMultiplier(attacker, target, highGroundFlag)

    local backstabbed = (hit.EffectFlags & HitFlag.Backstab) ~= 0
    if alwaysBackstab or (weapon ~= nil and weapon.WeaponType == "Knife" and CanBackstab(target, attacker)) then
        hit.EffectFlags = hit.EffectFlags | HitFlag.Backstab
        backstabbed = true
    end

    if hitType == "Melee" then
        if IsInFlankingPosition(target, attacker) then
            hit.EffectFlags = hit.EffectFlags | HitFlag.Flanking
        end
    
        -- Apply Sadist talent
        if attacker.TALENT_Sadist then
            if (hit.EffectFlags & HitFlag.Poisoned) ~= 0 then
                table.insert(statusBonusDmgTypes, "Poison")
            end
            if (hit.EffectFlags & HitFlag.Burning) ~= 0 then
                table.insert(statusBonusDmgTypes, "Fire")
            end
            if (hit.EffectFlags & HitFlag.Bleeding) ~= 0 then
                table.insert(statusBonusDmgTypes, "Physical")
            end
        end
    end

    if attacker.TALENT_Damage then
        hit.DamageMultiplier = hit.DamageMultiplier + 0.1
    end

    local hitBlocked = false

    -- Makes source skills missable, because they usually pass noHitRoll as true
    -- Need to check if there's any side effect to this
    
    -- Turns out that there's a side effect: healings that became damage due to
    -- decaying or undead also pass noHitRoll as true, and there's currently no
    -- way to distinguish them from any normal hit

    -- if not noHitRoll then
    local hitChance = WotL_CalculateHitChance(attacker, target)
    local hitRoll = math.random(0, 99)
    if hitRoll >= hitChance then
        if target.TALENT_RangerLoreEvasionBonus and hitRoll < hitChance + 10 then
            hit.EffectFlags = hit.EffectFlags | HitFlag.Dodged
        else
            hit.EffectFlags = hit.EffectFlags | HitFlag.Missed
        end
        hitBlocked = true
    else
        local blockChance = target.BlockChance + Ext.Round(target.Perseverance * Ext.ExtraData.WotL_BlockMasterBonus)
        if not backstabbed and blockChance > 0 and math.random(0, 99) < blockChance then
            hit.EffectFlags = hit.EffectFlags | HitFlag.Blocked;
            hitBlocked = true
        end
    end
    -- end

    if weapon ~= nil and weapon.Name ~= "DefaultWeapon" and hitType ~= "Magic" and forceReduceDurability and (hit.EffectFlags & (HitFlag.Missed|HitFlag.Dodged)) == 0 then
        ConditionalDamageItemDurability(attacker, weapon)
    end

    -- hitBlocked is passed as a flag to DoHit. This way, DoHit can get a guaranteed
    -- hit if it's an attack that ends up healing (TotalDamage < 0)
    -- if not hitBlocked then

    -- Doesn't use criticalRoll to make backstabs roll the crit chance again
    ConditionalApplyCriticalHitMultiplier(hit, target, attacker, hitType, "Roll")
    ConditionalApplyBackstabMultiplier(hit, attacker)
    DoHit(hit, damageList, statusBonusDmgTypes, hitType, target, attacker, hitBlocked)
    
    -- end

    return hit
end

if Ext.IsServer() then
    Ext.RegisterListener("ComputeCharacterHit", ComputeCharacterHit)
end

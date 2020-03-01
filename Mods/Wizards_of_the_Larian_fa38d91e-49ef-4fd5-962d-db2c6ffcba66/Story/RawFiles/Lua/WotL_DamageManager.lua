-- Transforms all Physical damage to Earth and Corrosive to Magic
function WotL_DamageConverter(handle)
    local physical = NRD_HitGetDamage(handle, "Physical")
    if physical ~= 0 then
        NRD_HitClearDamage(handle, "Physical")
        NRD_HitAddDamage(handle, "Earth", physical)
    end

    local corrosive = NRD_HitGetDamage(handle, "Corrosive")
    if corrosive ~= 0 then
        NRD_HitClearDamage(handle, "Corrosive")
        NRD_HitAddDamage(handle, "Magic", corrosive)
    end
end

-- When the target has no armor, half of the Magic Armor Damage is dealt
-- to HP using Shadow damage
function WotL_ArmorDamageHandler(target, handle)
    local damage = NRD_HitStatusGetDamage(target, handle, "Magic")
    if damage > 0 then
        local armor = NRD_CharacterGetStatInt(target, "CurrentMagicArmor")
        local hpDamage = math.ceil((damage - armor)/2)
        if hpDamage > 0 then
            NRD_HitStatusAddDamage(target, handle, "Shadow", hpDamage)
        end
    end
end

function WotL_StatusTesting(target, status, handle, source)
    Ext.Print("------------ STATUS " .. tostring(status) .. " ------------")

    local v1 = NRD_StatusGetString(target, handle, "StatusId")
    Ext.Print("StatusId: " .. tostring(v1))

    v1 = NRD_StatusGetGuidString(target, handle, "TargetHandle")
    Ext.Print("TargetHandle: " .. tostring(v1))

    v1 = NRD_StatusGetGuidString(target, handle, "StatusSourceHandle")
    Ext.Print("StatusSourceHandle: " .. tostring(v1))

    v1 = NRD_StatusGetReal(target, handle, "StartTimer")
    Ext.Print("StartTimer: " .. tostring(v1))

    v1 = NRD_StatusGetReal(target, handle, "LifeTime")
    Ext.Print("LifeTime: " .. tostring(v1))

    v1 = NRD_StatusGetReal(target, handle, "CurrentLifeTime")
    Ext.Print("CurrentLifeTime: " .. tostring(v1))

    v1 = NRD_StatusGetReal(target, handle, "TurnTimer")
    Ext.Print("TurnTimer: " .. tostring(v1))

    v1 = NRD_StatusGetReal(target, handle, "Strength")
    Ext.Print("Strength: " .. tostring(v1))

    v1 = NRD_StatusGetReal(target, handle, "StatsMultiplier")
    Ext.Print("StatsMultiplier: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "CanEnterChance")
    Ext.Print("CanEnterChance: " .. tostring(v1))

    v1 = NRD_StatusGetString(target, handle, "DamageSourceType")
    Ext.Print("DamageSourceType: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "KeepAlive")
    Ext.Print("KeepAlive: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "IsOnSourceSurface")
    Ext.Print("IsOnSourceSurface: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "IsFromItem")
    Ext.Print("IsFromItem: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "Channeled")
    Ext.Print("Channeled: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "IsLifeTimeSet")
    Ext.Print("IsLifeTimeSet: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "InitiateCombat")
    Ext.Print("InitiateCombat: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "Influence")
    Ext.Print("Influence: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "BringIntoCombat")
    Ext.Print("BringIntoCombat: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "IsHostileAct")
    Ext.Print("IsHostileAct: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "IsInvulnerable")
    Ext.Print("IsInvulnerable: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "IsResistingDeath")
    Ext.Print("IsResistingDeath: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "ForceStatus")
    Ext.Print("ForceStatus: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "ForceFailStatus")
    Ext.Print("ForceFailStatus: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "RequestDelete")
    Ext.Print("RequestDelete: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "RequestDeleteAtTurnEnd")
    Ext.Print("RequestDeleteAtTurnEnd: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "Started")
    Ext.Print("Started: " .. tostring(v1))

    Ext.Print("------------ STATUS HIT ATTRIBUTES ------------")

    v1 = NRD_StatusGetString(target, handle, "SkillId")
    Ext.Print("SkillId: " .. tostring(v1))

    v1 = NRD_StatusGetGuidString(target, handle, "HitByHandle")
    Ext.Print("HitByHandle: " .. tostring(v1))

    v1 = NRD_StatusGetGuidString(target, handle, "HitWithHandle")
    Ext.Print("HitWithHandle: " .. tostring(v1))

    v1 = NRD_StatusGetGuidString(target, handle, "WeaponHandle")
    Ext.Print("WeaponHandle: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "HitReason")
    Ext.Print("HitReason: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "Interruption")
    Ext.Print("Interruption: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "AllowInterruptAction")
    Ext.Print("AllowInterruptAction: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "ForceInterrupt")
    Ext.Print("ForceInterrupt: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "DecDelayDeathCount")
    Ext.Print("DecDelayDeathCount: " .. tostring(v1))

    Ext.Print("------------ HIT ATTRIBUTES ------------")

    v1 = NRD_StatusGetInt(target, handle, "Equipment")
    Ext.Print("Equipment: " .. tostring(v1))

    v1 = NRD_StatusGetString(target, handle, "DeathType")
    Ext.Print("DeathType: " .. tostring(v1))

    v1 = NRD_StatusGetString(target, handle, "DamageType")
    Ext.Print("DamageType: " .. tostring(v1))

    v1 = NRD_StatusGetString(target, handle, "AttackDirection")
    Ext.Print("AttackDirection: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "ArmorAbsorption")
    Ext.Print("ArmorAbsorption: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "LifeSteal")
    Ext.Print("LifeSteal: " .. tostring(v1))
    
    v1 = NRD_StatusGetInt(target, handle, "HitWithWeapon")
    Ext.Print("HitWithWeapon: " .. tostring(v1))
    
    v1 = NRD_StatusGetInt(target, handle, "Hit")
    Ext.Print("Hit: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "Blocked")
    Ext.Print("Blocked: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "Dodged")
    Ext.Print("Dodged: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "Missed")
    Ext.Print("Missed: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "CriticalHit")
    Ext.Print("CriticalHit: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "AlwaysBackstab")
    Ext.Print("AlwaysBackstab: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "FromSetHP")
    Ext.Print("FromSetHP: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "DontCreateBloodSurface")
    Ext.Print("DontCreateBloodSurface: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "Reflection")
    Ext.Print("Reflection: " .. tostring(v1))

    v1 = NRD_StatusGetInt(target, handle, "NoDamageOnOwner")
    Ext.Print("NoDamageOnOwner: " .. tostring(v1))

    Ext.Print("------------ END ------------")
end
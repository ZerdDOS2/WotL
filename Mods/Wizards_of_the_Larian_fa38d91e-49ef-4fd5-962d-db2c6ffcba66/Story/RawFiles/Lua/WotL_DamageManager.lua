-- Transforms all Physical damage to Earth and Corrosive to Magic
local function DamageConverter(handle)
    local physical = NRD_HitGetDamage(handle, "Physical")
    if physical ~= nil and physical ~= 0 then
        NRD_HitClearDamage(handle, "Physical")
        NRD_HitAddDamage(handle, "Earth", physical)
    end

    local corrosive = NRD_HitGetDamage(handle, "Corrosive")
    if corrosive ~= nil and corrosive ~= 0 then
        NRD_HitClearDamage(handle, "Corrosive")
        NRD_HitAddDamage(handle, "Magic", corrosive)
    end
end
Ext.NewCall(DamageConverter, "WotL_DamageConverter", "(INTEGER64)_Handle")

-- When the target has no armor, half of the Magic Armor Damage is dealt
-- to HP using Shadow damage
local function ArmorDamageHandler(target, handle)
    local damage = NRD_HitStatusGetDamage(target, handle, "Magic")
    if damage ~= nil and damage > 0 then
        local armor = NRD_CharacterGetStatInt(target, "CurrentMagicArmor")
        local hpDamage = math.ceil((damage - armor)/2)
        if hpDamage > 0 then
            NRD_HitStatusAddDamage(target, handle, "Shadow", hpDamage)
        end
    end
end
Ext.NewCall(ArmorDamageHandler, "WotL_ArmorDamageHandler", "(CHARACTERGUID)_Target, (INTEGER64)_Handle")

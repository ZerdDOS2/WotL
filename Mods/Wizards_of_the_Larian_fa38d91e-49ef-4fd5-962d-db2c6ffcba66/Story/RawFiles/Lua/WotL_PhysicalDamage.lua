-- This transforms all physical damage to earth damage for two reasons.
-- One is for compatibility sake, and second is to avoid earth particle
-- effects on weapons.
function WotL_PhysicalDamage(handle)
    local damage = NRD_HitGetDamage(handle, "Physical")
    NRD_HitClearDamage(handle, "Physical")
    NRD_HitAddDamage(handle, "Earth", damage)
end

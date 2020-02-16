-- ENUM_WotL_MagicArtifactAbilities = Set {
--     "Air",
--     "Death",
--     "Earth",
--     "Fire",
--     "Water",
-- }

-- MARequirement = {["Requirement"] = "Tag", ["Not"] = false, ["Param"] = "WotL_MagicArtifactUser"}

-- Makes all skills scale on weapon damage
function WotL_WeaponizeSkill(skill)
    -- local ability = Ext.StatGetAttribute(skill, "Ability")
    -- local damage = Ext.StatGetAttribute(skill, "Damage Multiplier")
    -- local enemy = bool(Ext.StatGetAttribute(skill, "IsEnemySkill"))
    -- local requirements = Ext.StatGetAttribute(skill, "Requirements")
    -- Ext.Print("Old damage: " .. tostring(damage))
    -- Ext.Print("Ability: " .. tostring(ability))
    -- if damage ~= 0 and ENUM_WotL_MagicArtifactAbilities[ability] then
        Ext.StatSetAttribute(skill, "UseWeaponDamage", 1)
        -- local new = math.ceil(damage * 1.2)
        -- Ext.StatSetAttribute(skill, "Damage Multiplier", new)
        -- Ext.Print("New damage: " .. tostring(new))
        
        -- if not enemy then
        --     local block = false
        --     if #requirements > 0 then
        --         for _, r in pairs(requirements) do
        --             if r["Requirement"] == MARequirement["Requirement"] and r["Not"] == MARequirement["Not"] and r["Param"] == MARequirement["Param"] then
        --                 block = true
        --                 break
        --             end
        --         end
        --     end

        --     if not block then
        --         table.insert(requirements, MARequirement)
        --         Ext.StatSetAttribute(skill, "Requirements", requirements)
        --     end
        -- end
    -- end
end

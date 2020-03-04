function WotL_CustomGetHitChance(attacker, target)
    local dodge = target.Dodge
    local accuracy = attacker.Accuracy
    local cthb = attacker.ChanceToHitBoost

    local hitChance = accuracy + cthb - dodge
    hitChance = math.max(hitChance, 5)
    hitChance = math.min(hitChance, 95)

    return hitChance
end

function CustomGetHitChance_WotL(attacker, target)
    local dodge = target.Dodge
    local accuracy = attacker.Accuracy

    local hitChance = accuracy - dodge
    hitChance = math.max(hitChance, 5)
    hitChance = math.min(hitChance, 95)

    return hitChance
end

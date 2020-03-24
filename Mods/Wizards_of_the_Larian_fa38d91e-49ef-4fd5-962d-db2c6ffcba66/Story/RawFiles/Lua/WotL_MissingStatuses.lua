local function CheckMissingStatus(target, status, handle, source)
    if not WotL_Bool(NRD_StatExists(status)) then
        return
    end

    -- Helper status from the game to apply all healing
    -- I want to prevent the initial applial, not the helper
    if status == "HEAL" then
        return
    end

    -- Ignores statuses that don't heal vitality
    local healStat = NRD_StatGetString(status, "HealStat")
    if healStat ~= "Vitality" then
        return
    end

    -- If you're healing an ally, I assume you know what you're doing
    -- This allows for Decaying-cleanses to work 100% of the time,
    -- but there might be some cases where the dodging an allied healing
    -- would be helpful. Will keep an eye on this feature
    if WotL_Bool(CharacterIsAlly(target, source)) then
        return
    end
    
    local isDecaying = WotL_Bool(HasActiveStatus(target, "DECAYING_TOUCH"))
    local isZombie = WotL_Bool(CharacterHasTalent(target, "Zombie"))
    local isNecromantic = WotL_Bool(NRD_StatGetString(status, "Necromantic"))

    -- Zombies and Decaying characters should be able to dodge healing, except for
    -- Necromantic healing, which heals Zombies (but still damages Decaying characters)
    if (not isZombie and not isDecaying) or (isNecromantic and not isDecaying) then
        return
    end

    -- Makes sure that skils that apply multiple healing statuses
    -- uses the same roll (Eg.: Odinblade's reworked Restoration)
    local roll = WotL_GetRecentRoll(target, source)
    if roll == -1 then
        roll = WotL_RollHitChance(target, source)
        WotL_SaveRecentRoll(target, source, roll)
    end

    if not WotL_Bool(roll) then
        NRD_StatusPreventApply(target, handle, 1)

        -- Mocks a fake hit just to have the missing animation
        WotL_MockFakeHit(target, source)
    end
end
Ext.NewCall(CheckMissingStatus, "WotL_CheckMissingStatus", "(CHARACTERGUID)_Target, (STRING)_Status, (INTEGER64)_Handle, (CHARACTERGUID)_Source")

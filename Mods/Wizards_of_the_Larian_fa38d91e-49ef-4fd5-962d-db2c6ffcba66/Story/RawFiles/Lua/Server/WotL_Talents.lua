-- ------------------------------------------ INNATE TALENTS ------------------------------------------
-- Adds the 2 innate talents to any overhead item equipped
local function AddInnateTalentsToItem(item, char)
    local stat = NRD_ItemGetStatsId(item)
    if stat == nil then
        return
    end

    if not WotL_Bool(NRD_StatExists(stat)) then
        return
    end

    if NRD_StatGetString(stat, "Slot") ~= "Overhead" then
        return
    end

    -- Checks if the overhead item already has the talent boosts
    local needsClone = false
    for _, talent in pairs (ENUM_WotL_InnateTalents) do
        if not WotL_Bool(NRD_ItemGetPermanentBoostTalent(item, talent)) then
            NRD_ItemSetPermanentBoostTalent(item, talent, 1)
            NRD_CharacterSetPermanentBoostTalent(char, talent, 1)
            needsClone = true
        end
    end

    if not needsClone then
        return
    end

    -- Clones the item and re-equips it
    CharacterAddAttribute(char, "Dummy", 0)
    NRD_ItemCloneBegin(item)
    ItemDestroy(item)
    local new = NRD_ItemClone()
    CharacterEquipItem(char, new)
end
Ext.NewCall(AddInnateTalentsToItem, "WotL_AddInnateTalentsToItem", "(ITEMGUID)_Item, (CHARACTERGUID)_Char")

-- ------------------------------------------ GENEROUS HOST ------------------------------------------
local function GenerousHost(char)
    -- Vanilla's Torturer became Generous Host
    local hasTalent = WotL_Bool(CharacterHasTalent(char, "Torturer"))
    local status = "WotL_GenerousHost"
    local hasStatus = WotL_Bool(HasActiveStatus(char, status))

    -- Manage status that increases Max Summons application and removal
    if hasTalent and not hasStatus then
        ApplyStatus(char, status, -1.0, 1)
    elseif not hasTalent and hasStatus then
        RemoveStatus(char, status)
    end

    if not hasTalent then
        return
    end

    -- Counts the number of summons currently active (WotL_Summon.txt)
    local summons = Osi.DB_WotL_SummonsCount:Get(char, nil)
    local count = 0
    for _ in pairs(summons) do
        count = count + 1
    end

    local maxSummons = NRD_CharacterGetStatInt(char, "BaseMaxSummons")
    status = "WotL_GenerousHost_Debuff"
    hasStatus = WotL_Bool(HasActiveStatus(char, status))

    -- Applies the Debuff it the summoner has its limit of summons at once
    -- and removes otherwise
    if count >= maxSummons and not hasStatus then
        ApplyStatus(char, status, -1.0, 1)
    elseif count < maxSummons and hasStatus then
        RemoveStatus(char, status)
    end
end
Ext.NewCall(GenerousHost, "WotL_Talent_GenerousHost", "(CHARACTERGUID)_Char")

-- ------------------------------------------ LONE WOLF ------------------------------------------
WotL_LoneWolf_PartySizeThreshold = 2
local function LoneWolf(char)
    if not WotL_Bool(CharacterIsPlayer(char)) then
        return
    end

    local count = WotL_GetPlayerPartyCount(char)
    if count == 0 then
        return
    end

    if count <= WotL_LoneWolf_PartySizeThreshold then
        if not WotL_Bool(HasAppliedStatus(char, "WotL_LW_Base")) then
            ApplyStatus(char, "WotL_LW_Base", -1.0, 1)
        end
    else
        if WotL_Bool(HasAppliedStatus(char, "WotL_LW_Base")) then
            RemoveStatus(char, "WotL_LW_Base")
        end
    end

    for attribute, _ in pairs(ENUM_WotL_AttributesNames) do
        local value = CharacterGetBaseAttribute(char, attribute)
        local boost = NRD_CharacterGetPermanentBoostInt(char, attribute)
        local final = 0
        if count <= WotL_LoneWolf_PartySizeThreshold then
            final = (value - 10) - boost
        end
        if final ~= boost then
            NRD_CharacterSetPermanentBoostInt(char, attribute, final)
            CharacterAddAttribute(char, "WotL_Dummy", 0)
        end
    end
end
Ext.NewCall(LoneWolf, "WotL_Talent_LoneWolf", "(CHARACTERGUID)_Char")

-- ------------------------------------------ SENTINEL ------------------------------------------
local function Sentinel(target, source, handle)
    -- Vanilla's Savage Sortilege became Sentinel
    local hasTalent = WotL_Bool(CharacterHasTalent(source, "ViolentMagic"))
    if not hasTalent then
        return
    end

    -- Both the target and the source gets an engine-applied status called
    -- AOO (Attack Of Opportunity) when the AOO happens
    local hasStatus = WotL_Bool(HasActiveStatus(target, "AOO"))
    if not hasStatus then
        return
    end

    hasStatus = WotL_Bool(HasActiveStatus(source, "AOO"))
    if not hasStatus then
        return
    end

    -- Extra safety check
    if not WotL_Bool(WotL_IsCurrentTurn(target)) then
        return
    end

    -- More safety checks
    local damageSourceType = NRD_StatusGetString(target, handle, "DamageSourceType")
    local hit = NRD_StatusGetInt(target, handle, "Hit")
    local hitReason = NRD_StatusGetInt(target, handle, "HitReason")
    local hitWithWeapon = NRD_StatusGetInt(target, handle, "HitWithWeapon")

    if damageSourceType ~= "Attack" or hit ~= 1 or hitReason ~= 0 or hitWithWeapon ~= 1 then
        return
    end

    -- Increase damage on the AOO
    for _, type in pairs(ENUM_WotL_AllDamageTypes) do
        local damage = NRD_HitStatusGetDamage(target, handle, type)
        if damage ~= 0 then
            local increase = math.ceil(damage * Ext.ExtraData.WotL_SentinelDamageIncrease * 0.01)
            NRD_HitStatusAddDamage(target, handle, type, increase)
        end
    end

    -- If the source still has armor, it applies a 99% slow for the current turn
    local hasArmor = WotL_Bool(CharacterGetMagicArmorPercentage(source))
    if not hasArmor then
        return
    end

    -- Check WotL_TurnManager.txt and WotL_StatusRequestDelete.lua
    ApplyStatus(target, "WotL_Sentinel_Debuff", WotL_StatusRemovalAtTurnEndCustomNumber, 0, source)
end
Ext.NewCall(Sentinel, "WotL_Talent_Sentinel", "(CHARACTERGUID)_Target, (CHARACTERGUID)_Source, (INTEGER64)_Handle")

-- ------------------------------------------ WHAT A RUSH ------------------------------------------
-- The threshold in ExtraData was set to 0, because the AP gain is hardcoded. This way, all the AP
-- bonus is set by the status WotL_WhatARush, so the bonuses aren't displayed twice on the tooltip
WotL_WhatARush_Threshold = 50
local function WhatARush(char, percentage)
    local isLow = percentage < WotL_WhatARush_Threshold
    local status = "WotL_WhatARush"
    local hasStatus = WotL_Bool(HasActiveStatus(char, status))

    -- Manage status that increases AP Maximum, Recovery and Start; I added AP Start, unlike vanilla
    -- I'm interested if this will make the talent any better by allowing players to enter a combat
    -- low on HP on purpose
    if isLow and not hasStatus then
        ApplyStatus(char, status, -1.0, 1)
    elseif not isLow and hasStatus then
        RemoveStatus(char, status)
    end
end
Ext.NewCall(WhatARush, "WotL_Talent_WhatARush", "(CHARACTERGUID)_Char, (INTEGER)_Percentage")

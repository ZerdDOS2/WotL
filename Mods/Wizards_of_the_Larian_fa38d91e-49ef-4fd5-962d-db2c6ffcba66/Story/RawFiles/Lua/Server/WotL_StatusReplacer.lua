-- ENUM for both WotL_StatusReplacer and WotL_StatusStacker
ENUM_WotL_StatusReplaces = {
    ["KNOCKED_DOWN"] = {
        "CRIPPLED",
        "OdinCORE_LOSTFOOTING",
    },
}

-- WotL_StatusReplacer replaces the key status with the first status
-- on the ENUM_WotL_StatusReplaces and removes the stacking statuses
local function StatusReplacer(target, status, handle, source)
    if ENUM_WotL_StatusReplaces[status] == nil then
        return
    end

    -- Force statuses are applied, regardless of the replacer
    -- Helps avoid bugs with story scripted events
    if WotL_Bool(NRD_StatusGetInt(target, handle, "ForceStatus")) then
        return
    end

    -- Usually, if a status' source is not a character, I don't
    -- want to fiddle with it, since, most of the times, it's
    -- not combat-related
    if not WotL_Bool(ObjectIsCharacter(source)) then
        return
    end
    
    -- Surface statuses (looking at ice's KD) won't be replaced
    local sourceType = NRD_StatusGetString(target, handle, "DamageSourceType")
    if sourceType == "SurfaceMove" or sourceType == "SurfaceCreate" or sourceType == "SurfaceStatus" then
        return
    end

    -- If it doesn't pass the random roll, it's instantly prevented
    local canEnterChance = NRD_StatusGetInt(target, handle, "CanEnterChance")
    if not WotL_Bool(WotL_RollRandomChance(canEnterChance)) then
        NRD_StatusPreventApply(target, handle, 1)
        return
    end

    -- Marks which stackable statuses the character has currently applied
    local removals = {}
    for _, remove in pairs(ENUM_WotL_StatusReplaces[status]) do
        if WotL_Bool(HasActiveStatus(target, remove)) then
            table.insert(removals, remove)
        end
    end

    -- Removes the stackable statuses ...
    local hasStack = false
    for _, remove in pairs(removals) do
        hasStack = true
        RemoveStatus(target, remove)
    end

    -- ... and allows the main status to be applied
    if hasStack then
        return
    end

    -- If it didn't have any stackable status, prevents the main status
    -- application and applies the first on the ENUM list
    NRD_StatusPreventApply(target, handle, 1)
    local lifeTime = NRD_StatusGetReal(target, handle, "LifeTime")
    ApplyStatus(target, ENUM_WotL_StatusReplaces[status][1], lifeTime, 0, source)
end
Ext.NewCall(StatusReplacer, "WotL_StatusReplacer", "(CHARACTERGUID)_Target, (STRING)_Status, (INTEGER64)_Handle, (CHARACTERGUID)_Source")

-- WotL_StatusStacker provides the status interaction between any
-- status on the ENUM_WotL_StatusReplaces to apply the key status
local function StatusStacker(target, status, handle, source)
    -- Looks for the result of the stacking status
    local result = false
    for key, table in pairs(ENUM_WotL_StatusReplaces) do
        for _, elem in pairs (table) do
            if status == elem then
                result = key
                break
            end
        end
    end

    -- If it isn't a stackable status, simply return
    if not result then
        return
    end

    -- Checks if the target already has the result of the stacking
    -- statuses
    local hasResult = WotL_Bool(HasActiveStatus(target, result))

    -- If the target already has the result, the stacking statuses
    -- are blocked from applying
    if hasResult then
        NRD_StatusPreventApply(target, handle, 1)
        return
    end

    -- Checks if the target has one of the stackable statuses
    -- including the status itself
    local hasStack = false
    for _, stack in pairs(ENUM_WotL_StatusReplaces[result]) do
        if WotL_Bool(HasActiveStatus(target, stack)) then
            hasStack = true
            break
        end
    end

    -- If it doesn't have the stacking status, the applial should
    -- proceed normally
    if not hasStack then
        return
    end

    -- If it doesn't pass the random roll, it's instantly prevented
    local canEnterChance = NRD_StatusGetInt(target, handle, "CanEnterChance")
    if not WotL_Bool(WotL_RollRandomChance(canEnterChance)) then
        NRD_StatusPreventApply(target, handle, 1)
        return
    end
    
    -- Replaces the status with it's stacking result
    NRD_StatusPreventApply(target, handle, 1)
    ApplyStatus(target, result, 6.0, 0, source)
end
Ext.NewCall(StatusStacker, "WotL_StatusStacker", "(CHARACTERGUID)_Target, (STRING)_Status, (INTEGER64)_Handle, (CHARACTERGUID)_Source")

-- WotL_Adrenaline replaces ADRENALINE with WotL_Adrenaline, and only
-- apply it for 1 turn. Needed a special function and couldn't use
-- WotL_StatusReplacer because vanilla's adrenaline is applied for
-- -1 turns, and I only need to apply it for one
WotL_AdrenalineReplacer_Status = "WotL_Adrenaline"
local function AdrenalineReplacer(target, handle)
    NRD_StatusPreventApply(target, handle, 1)
    ApplyStatus(target, WotL_AdrenalineReplacer_Status, 6.0, 0, target)
end
Ext.NewCall(AdrenalineReplacer, "WotL_AdrenalineReplacer", "(CHARACTERGUID)_Target, (INTEGER64)_Handle")

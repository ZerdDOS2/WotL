-- Rolls a random chance of source hitting target
-- Returns true for a hit and false for a miss
local function RollHitChance(target, source)
    local dodge = NRD_CharacterGetComputedStat(target, "Dodge", 0)
    local accuracy = NRD_CharacterGetComputedStat(source, "Accuracy", 0)
    local cthb = NRD_CharacterGetComputedStat(source, "ChanceToHitBoost", 0)

    local hitChance = accuracy + cthb - dodge
    hitChance = math.max(hitChance, 5)
    hitChance = math.min(hitChance, 95)

    return WotL_RollRandomChance(hitChance)
end
Ext.NewQuery(RollHitChance, "WotL_RollHitChance", "[in](CHARACTERGUID)_Target, [in](CHARACTERGUID)_Source, [out](INTEGER)_Hit")

-- Rolls a random number and return 
-- if the chance succeeded or not
local function RollRandomChance(chance)
    local roll = math.random(1, 100)
    if roll > chance then
        return 0
    end
    return 1
end
Ext.NewQuery(RollRandomChance, "WotL_RollRandomChance", "[in](INTEGER)_Chance, [out](INTEGER)_Hit")

-- Clears old entries from the recent roll DB and add a new
-- entry, which will be cleared shortly after
local function SaveRecentRoll(target, source, result)
    Osi.DB_RandomRollRecentResult:Delete(target, source, nil)
    Osi.DB_RandomRollRecentResult(target, source, result)
    Osi.ProcObjectTimer(source, "WotL_ClearRandomRollRecentResultTimer", 100)
end
Ext.NewCall(SaveRecentRoll, "WotL_SaveRecentRoll", "(CHARACTERGUID)_Target, (CHARACTERGUID)_Source, (INTEGER)_Result")

-- Gets a recent roll made. Returns 1 for a hit, 0 for a miss and
-- -1 if there isn't any recent roll
local function GetRecentRoll(target, source)
    local result = Osi.DB_RandomRollRecentResult:Get(target, source, nil)
    if next(result) == nil then
        return -1
    end
    return result[1][3]
end
Ext.NewQuery(GetRecentRoll, "WotL_GetRecentRoll", "[in](CHARACTERGUID)_Target, [in](CHARACTERGUID)_Source, [out](INTEGER)_Result")

-- Uses the combat turn order functions to check if it's the
-- char's turn. Return false if it's not the char's turn or
-- if char is not in combat
local function IsCurrentTurn(char)
    local combatID = CombatGetIDForCharacter(char)
    if combatID == nil or combatID == 0 then
        return 0
    end

    local combat = Ext.GetCombat(combatID)
    local order = combat:GetCurrentTurnOrder()
    if order == nil then
        return 0
    end

    local charID = GetUUID(char)
    if charID == order[1].Character.MyGuid then
        return 1
    end
    return 0
end
Ext.NewQuery(IsCurrentTurn, "WotL_IsCurrentTurn", "[in](CHARACTERGUID)_Char, [out](INTEGER)_IsTurn")

-- Uses the built-in behavior GetInnerDistance query on a gamescript
-- and returns the float distance
local function GetInnerDistance(source, target)
    CharacterCharacterSetEvent(source, target, "WotL_GetInnerDistance")
    local distance = GetVarFloat(source, "WotL_InnerDistance")
    return distance
end
Ext.NewQuery(GetInnerDistance, "WotL_GetInnerDistance", "[in](CHARACTERGUID)_Source, [in](CHARACTERGUID)_Target, [out](REAL)_Distance")

-- Prepares a 0 damage hit just to provide the "Miss!"" overhead text and
-- the dodge animation
local function MockFakeHit(target, source)
    local simulate = NRD_HitPrepare(target, source)
    NRD_HitSetInt(simulate, "Hit", 0)
    NRD_HitSetInt(simulate, "Missed", 1)
    NRD_HitSetInt(simulate, "NoEvents", 1)
    NRD_HitExecute(simulate)
end
Ext.NewCall(MockFakeHit, "WotL_MockFakeHit", "(CHARACTERGUID)_Target, (CHARACTERGUID)_Source")

-- Counts the number of players contained in DB_IsPlayer that is on the same
-- party as the Character passed, including the Character itself. Returns 0
-- if the Character parameter isn't part of the DB_IsPlayer
local function GetPlayerPartyCount(char)
    local count = 0
    local isPlayer = false

    local players = Osi.DB_IsPlayer:Get(nil)
    for _, player in pairs(players) do
        if WotL_Bool(CharacterIsInPartyWith(char, player[1])) then
            count = count + 1
        end
        if GetUUID(player[1]) == GetUUID(char) then
            isPlayer = true
        end
    end

    if isPlayer then
        return count
    end
    return 0
end
Ext.NewQuery(GetPlayerPartyCount, "WotL_GetPlayerPartyCount", "[in](CHARACTERGUID)_Char, [out](INTEGER)_Count")

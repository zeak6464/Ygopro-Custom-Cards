-- Bear-Trap Fang Dragon (Size 1)
local s,id=GetID()
function s.initial_effect(c)
    -- Mark as Dragon World monster (archetype set in database)
    -- Size 1 monster (Level 4 = Size 1 in BuddyFight)
    
    -- Set BuddyFight Counterattack ability
    c.has_counterattack = true

    -- Call cost for normal summoning
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SUMMON_COST)
    e0:SetCost(s.callcost)
    e0:SetOperation(s.callop)
    c:RegisterEffect(e0)

    -- ATK boost when defending
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetCondition(s.atkcon)
    e2:SetValue(500)
    c:RegisterEffect(e2)
end

function s.callcost(e,c,tp)
    return Duel.CheckLPCost(tp,0) and BuddyfightDuel.CanCastSpell(tp,1)
end

function s.callop(e,tp,eg,ep,ev,re,r,rp)
    BuddyfightDuel.PayGauge(tp,1)
    Duel.Hint(HINT_MESSAGE,tp,"Paid 1 gauge to call Bear-Trap Fang Dragon (Size 1) - Counterattack!")
end

function s.atkcon(e)
    local at=Duel.GetAttacker()
    return at and at:IsControler(1-e:GetHandlerPlayer()) and Duel.GetAttackTarget()==e:GetHandler()
end 
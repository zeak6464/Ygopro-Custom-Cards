-- Extreme Sword Dragon (Size 2)
local s,id=GetID()
function s.initial_effect(c)
    -- Mark as Dragon World monster
    c:SetArchetype(0x5000)
    
    -- Set monster size (Size 2)
    c.buddyfight_size = 2

    -- Call cost for normal summoning
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SUMMON_COST)
    e0:SetCost(s.callcost)
    e0:SetOperation(s.callop)
    c:RegisterEffect(e0)

    -- Double Attack (can attack twice per turn)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EXTRA_ATTACK)
    e1:SetValue(1)
    c:RegisterEffect(e1)

    -- Gain ATK when attacking
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetCondition(s.atkcon)
    e2:SetValue(500)
    c:RegisterEffect(e2)
end

function s.callcost(e,c,tp)
    return Duel.CheckLPCost(tp,0) and BuddyfightDuel.CanCastSpell(tp,2)
end

function s.callop(e,tp,eg,ep,ev,re,r,rp)
    BuddyfightDuel.PayGauge(tp,2)
    Duel.Hint(HINT_MESSAGE,tp,"Paid 2 gauge to call Extreme Sword Dragon (Size 2) - Double Attack!")
end

function s.atkcon(e)
    return e:GetHandler():IsAttackPos() and Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
end 
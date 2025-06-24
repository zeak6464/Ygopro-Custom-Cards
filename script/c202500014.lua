-- Bear-Trap Fang Dragon (Size 1) - Using Built-in Systems
local s,id=GetID()
function s.initial_effect(c)
    -- Mark as Dragon World monster (archetype set in database)
    -- Size 1 monster (Level 4 = Size 1 in BuddyFight)

    -- Call cost for normal summoning
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SUMMON_COST)
    e0:SetCost(s.callcost)
    e0:SetOperation(s.callop)
    c:RegisterEffect(e0)

    -- Counterattack ability: When destroyed by battle, destroy the attacking monster
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_DESTROYED)
    e1:SetCondition(s.countercon)
    e1:SetTarget(s.countertg)
    e1:SetOperation(s.counterop)
    c:RegisterEffect(e1)
end

function s.callcost(e,c,tp)
    return Duel.CheckLPCost(tp,0) and BuddyfightDuel.CanCastSpellNew(tp,1)
end

function s.callop(e,tp,eg,ep,ev,re,r,rp)
    BuddyfightDuel.PayGaugeNew(tp,1)
    Duel.Hint(HINT_MESSAGE,tp,"Paid 1 gauge to call Bear-Trap Fang Dragon (Size 1) - Counterattack!")
end

function s.countercon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    return c==d and a and a:IsRelateToBattle()
end

function s.countertg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local a=Duel.GetAttacker()
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,a,1,0,0)
end

function s.counterop(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    if a and a:IsRelateToBattle() then
        Duel.Destroy(a,REASON_EFFECT)
        Duel.Hint(HINT_MESSAGE,tp,"Bear-Trap Fang Dragon's counterattack destroys the attacker!")
    end
end 
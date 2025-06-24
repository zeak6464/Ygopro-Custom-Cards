-- Drum Bunker Dragon "2018" - Buddy Monster (Size 2)
local s,id=GetID()
function s.initial_effect(c)
    -- Mark as Buddy Monster (archetype set in database)
    -- Size 2 monster (Level 6 = Size 2 in BuddyFight)

    -- Call cost for normal summoning
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SUMMON_COST)
    e0:SetCost(s.callcost)
    e0:SetOperation(s.callop)
    c:RegisterEffect(e0)

    -- Buddy Call is handled by Dragon World Flag

    -- Soulguard (negate direct attack by destroying self)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(s.soulguard_con)
    e2:SetOperation(s.soulguard_op)
    c:RegisterEffect(e2)

    -- When this card is in center, opponent cannot attack directly
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,LOCATION_MZONE)
    e3:SetCondition(s.centercon)
    c:RegisterEffect(e3)
end

function s.callcost(e,c,tp)
    return Duel.CheckLPCost(tp,0) and BuddyfightDuel.CanCastSpell(tp,1)
end

function s.callop(e,tp,eg,ep,ev,re,r,rp)
    BuddyfightDuel.PayGauge(tp,1)
    Duel.Hint(HINT_MESSAGE,tp,"Paid 1 gauge to call Drum Bunker Dragon (Size 2)")
end

-- Buddy Call functions removed - handled by Dragon World Flag

function s.centercon(e)
    local c=e:GetHandler()
    return c:GetSequence()==1 -- Zone 1 is center
end

function s.soulguard_con(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttacker()
    return at:GetControler()~=tp and at:IsAttackingDirectly()
end

function s.soulguard_op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.SelectYesNo(tp,"Use Soulguard to nullify direct attack?") then
        if Duel.Destroy(c,REASON_EFFECT)~=0 then
            Duel.NegateAttack()
            Duel.Hint(HINT_MESSAGE,tp,"Soulguard activated! Attack nullified!")
        end
    end
end

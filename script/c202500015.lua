-- Systemic Dagger Dragon (Size 1)
local s,id=GetID()
function s.initial_effect(c)
    -- Mark as Dragon World monster (archetype set in database)
    
    -- Set monster size (Size 1)
    c.buddyfight_size = 1

    -- Call cost for normal summoning
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SUMMON_COST)
    e0:SetCost(s.callcost)
    e0:SetOperation(s.callop)
    c:RegisterEffect(e0)

    -- Move (can change battle position once per turn)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_POSITION)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(s.postg)
    e1:SetOperation(s.posop)
    c:RegisterEffect(e1)

    -- Quick attack (can attack the turn it's summoned)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_IGNORE_SUMMONING_CONDITION)
    e2:SetCondition(s.atkcon)
    c:RegisterEffect(e2)
end

function s.callcost(e,c,tp)
    return Duel.CheckLPCost(tp,0) and BuddyfightDuel.CanCastSpell(tp,1)
end

function s.callop(e,tp,eg,ep,ev,re,r,rp)
    BuddyfightDuel.PayGauge(tp,1)
    Duel.Hint(HINT_MESSAGE,tp,"Paid 1 gauge to call Systemic Dagger Dragon (Size 1) - Move!")
end

function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsCanChangePosition() end
    Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end

function s.posop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_DEFENSE)
        Duel.Hint(HINT_MESSAGE,tp,"Systemic Dagger Dragon uses Move!")
    end
end

function s.atkcon(e)
    return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end 
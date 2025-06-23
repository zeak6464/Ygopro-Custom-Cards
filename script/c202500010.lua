-- Gigant Sword Dragon (Size 2)
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

    -- When summoned, can destroy 1 opponent monster
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(s.destg)
    e1:SetOperation(s.desop)
    c:RegisterEffect(e1)
end

function s.callcost(e,c,tp)
    return Duel.CheckLPCost(tp,0) and BuddyfightDuel.CanCastSpell(tp,2)
end

function s.callop(e,tp,eg,ep,ev,re,r,rp)
    BuddyfightDuel.PayGauge(tp,2)
    Duel.Hint(HINT_MESSAGE,tp,"Paid 2 gauge to call Gigant Sword Dragon (Size 2)")
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
    if #g>0 then
        Duel.Destroy(g,REASON_EFFECT)
        Duel.Hint(HINT_MESSAGE,tp,"Gigant Sword Dragon destroys enemy monster!")
    end
end 
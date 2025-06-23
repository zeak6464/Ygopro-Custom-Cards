-- Reckless Angerrrr!! (Impact)
local s,id=GetID()
function s.initial_effect(c)
    -- Mark as Impact Card (archetype 0x3000)
    c:SetArchetype(0x3000)
    
    -- Impact can only be cast during Final Phase with gauge cost
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e1:SetCondition(s.condition)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    -- Must be Final Phase (End Phase) and Impact not used this turn
    return Duel.GetCurrentPhase()==PHASE_END 
           and BuddyfightDuel.CanCastImpact(tp,3)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return BuddyfightDuel.CanCastImpact(tp,3) end
    BuddyfightDuel.PayGauge(tp,3)
    if Buddyfight and Buddyfight[tp] then
        Buddyfight[tp].impact_used = true
    end
    Duel.Hint(HINT_MESSAGE,tp,"Reckless Angerrrr!!: Paid 3 gauge for Impact (Final Phase only)")
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,#g*1000) -- 1000 LP = 1 Life per monster
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    -- Destroy all opponent monsters
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    local ct=Duel.Destroy(g,REASON_EFFECT)
    if ct>0 then
        -- Deal 1 Life damage for each destroyed monster (1000 LP = 1 Life)
        local damage = ct * 1000
        Duel.Damage(1-tp,damage,REASON_EFFECT)
        Duel.Hint(HINT_MESSAGE,tp,"Reckless Angerrrr!! Impact! Destroyed "..ct.." monsters and dealt "..ct.." Life damage!")
    end
end 
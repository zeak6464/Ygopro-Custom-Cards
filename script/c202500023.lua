-- Dragon Bomber Impact (Using Built-in Phase Restrictions)
local s,id=GetID()
function s.initial_effect(c)
    -- Mark as BuddyFight Impact (archetype set in database)
    
    -- Can only be activated during End Phase
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_END_PHASE)
    e1:SetCondition(s.condition)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    -- Must be End Phase and Impact not used this turn
    return Duel.GetCurrentPhase()==PHASE_END and BuddyfightDuel.CanCastImpactNew(tp,3)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return BuddyfightDuel.CanCastSpellNew(tp,3) end
    BuddyfightDuel.PayGaugeNew(tp,3)
    BuddyfightDuel.UseImpact(tp)
    Duel.Hint(HINT_MESSAGE,tp,"Dragon Bomber Impact activated! Paid 3 gauge")
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsMonster,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsMonster,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(3)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,3)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    -- Destroy all opponent monsters
    local g=Duel.GetMatchingGroup(Card.IsMonster,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        local ct=Duel.Destroy(g,REASON_EFFECT)
        Duel.Hint(HINT_MESSAGE,tp,"Dragon Bomber Impact destroys "..ct.." monsters!")
        
        -- Deal 3 damage using new life system
        if ct>0 then
            local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
            BuddyfightDuel.DealDamage(p,3)
            Duel.Hint(HINT_MESSAGE,tp,"Dragon Bomber Impact deals 3 Life damage!")
        end
    else
        -- If no monsters to destroy, still deal damage
        local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
        BuddyfightDuel.DealDamage(p,3)
        Duel.Hint(HINT_MESSAGE,tp,"Dragon Bomber Impact deals 3 Life damage!")
    end
end 
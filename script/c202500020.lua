-- Dragon Burst (Using Built-in Gauge System)
local s,id=GetID()
function s.initial_effect(c)
    -- Mark as BuddyFight Spell (archetype set in database)
    
    -- Spell activation
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return BuddyfightDuel.CanCastSpellNew(tp,2) end
    BuddyfightDuel.PayGaugeNew(tp,2)
    Duel.Hint(HINT_MESSAGE,tp,"Dragon Burst activated! Paid 2 gauge")
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsMonster,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsMonster,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        if Duel.Destroy(tc,REASON_EFFECT)~=0 then
            Duel.Hint(HINT_MESSAGE,tp,"Dragon Burst destroys target monster!")
            
            -- Deal 2 damage using new life system
            local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
            BuddyfightDuel.DealDamage(p,d)
            Duel.Hint(HINT_MESSAGE,tp,"Dragon Burst deals 2 Life damage!")
        end
    end
end 
-- Dragonic Shoot
local s,id=GetID()
function s.initial_effect(c)
    -- Mark as BuddyFight Spell (archetype set in database)
    
    -- Counter spell - destroy monster with 3000 or less power, no gauge cost
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function s.filter(c)
    return c:IsMonster() and c:GetAttack()<=3000
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    if #g>0 then
        Duel.Destroy(g,REASON_EFFECT)
        Duel.Hint(HINT_MESSAGE,tp,"Dragonic Shoot: Destroys enemy monster!")
    end
end 
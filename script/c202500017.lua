-- Dragonic Heal
local s,id=GetID()
function s.initial_effect(c)
    -- Mark as BuddyFight Spell (archetype set in database)
    
    -- Simple healing spell with no gauge cost
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    -- Gain 2 life (2000 LP = 2 Life in BuddyFight)
    Duel.Recover(tp,2000,REASON_EFFECT)
    Duel.Hint(HINT_MESSAGE,tp,"Dragonic Heal: Gain 2 life!")
end 
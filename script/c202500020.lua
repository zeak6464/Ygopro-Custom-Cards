-- Green Dragon Shield
local s,id=GetID()
function s.initial_effect(c)
    -- Mark as BuddyFight Spell (archetype 0x2000)  
    c:SetArchetype(0x2000)
    
    -- Counter spell - can only be cast during opponent's attack when center is empty
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(s.condition)
    e1:SetCost(s.cost)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttacker()
    -- Must be opponent's attack AND no monsters in your center (zone 1)
    return at and at:IsControler(1-tp) 
           and Duel.CheckLocation(tp,LOCATION_MZONE,1) -- Center zone is empty
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end -- No gauge cost according to official effect
    Duel.Hint(HINT_MESSAGE,tp,"Green Dragon Shield: Center empty condition met")
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    -- Nullify the attack
    if Duel.NegateAttack() then
        -- Gain 1 life
        Duel.Recover(tp,1000,REASON_EFFECT)
        Duel.Hint(HINT_MESSAGE,tp,"Green Dragon Shield: Attack nullified! Gain 1 life (center was empty)")
    end
end 
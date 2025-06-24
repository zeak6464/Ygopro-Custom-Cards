-- Dragonblade, Dragofearless (3000/2/0) - Basic Item
local s,id=GetID()
function s.initial_effect(c)
    -- Mark as BuddyFight Item (archetype set in database)
    
    -- Set item stats: 3000 power, 2 critical, 0 defense
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SET_BASE_ATTACK)
    e0:SetValue(3000)
    c:RegisterEffect(e0)
    local e0b=Effect.CreateEffect(c)
    e0b:SetType(EFFECT_TYPE_SINGLE)
    e0b:SetCode(EFFECT_SET_BASE_DEFENSE)
    e0b:SetValue(0)
    c:RegisterEffect(e0b)
    
    -- Basic equip to player (no equip cost - vanilla item)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.eqtg)
    e1:SetOperation(s.eqop)
    c:RegisterEffect(e1)

    -- Item can attack with proper BuddyFight resolution
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(s.atkcon)
    e2:SetTarget(s.atktg)
    e2:SetOperation(s.atkop)
    c:RegisterEffect(e2)
end

function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end

function s.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if BuddyfightDuel.EquipItem(tp,c) then
        Duel.Hint(HINT_MESSAGE,tp,"Dragonblade, Dragofearless equipped! (3000 Power / 2 Critical)")
    end
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return BuddyfightDuel.CanItemAttack(tp)
end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        -- Can attack directly if center is open, or attack monsters
        return BuddyfightDuel.CanAttackDirectly(tp) or 
               Duel.IsExistingMatchingCard(Card.IsMonster,tp,0,LOCATION_MZONE,1,nil)
    end
    local b1=BuddyfightDuel.CanAttackDirectly(tp)
    local b2=Duel.IsExistingMatchingCard(Card.IsMonster,tp,0,LOCATION_MZONE,1,nil)
    if b1 and b2 then
        local op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
        e:SetLabel(op)
    elseif b1 then
        e:SetLabel(0)
    else
        e:SetLabel(1)
    end
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local op=e:GetLabel()
    
    if op==0 then
        -- Direct attack
        BuddyfightDuel.ResolveAttack(c, nil, 3000, 2, 0)
    else
        -- Attack monster
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
        local g=Duel.SelectMatchingCard(tp,Card.IsMonster,tp,0,LOCATION_MZONE,1,1,nil)
        if #g>0 then
            local target=g:GetFirst()
            BuddyfightDuel.ResolveAttack(c, target, 3000, 2, 0)
        end
    end
end 
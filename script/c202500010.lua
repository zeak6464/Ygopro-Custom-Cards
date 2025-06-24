-- Drum the Dragon Buddy (Using Built-in Systems)
local s,id=GetID()
function s.initial_effect(c)
    -- Archetype is set in database (Dragon World)
    
    -- Buddy Call is handled by Dragon World Flag
    
    -- Penetrate ability
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e2)
    
    -- When destroys monster by battle, deal damage
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_DAMAGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLE_DESTROYING)
    e3:SetCondition(s.damcon)
    e3:SetTarget(s.damtg)
    e3:SetOperation(s.damop)
    c:RegisterEffect(e3)
    
    -- Dragon World flag bonus
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetCondition(s.atkcon)
    e4:SetValue(500)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e5)
end

-- Buddy Call functions removed - handled by Dragon World Flag

function s.damcon(e,tp,eg,ep,ev,re,r,rp)
    return aux.dsercon(e,tp,eg,ep,ev,re,r,rp) and e:GetHandler():IsRelateToBattle()
end

function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1)
end

function s.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    BuddyfightDuel.DealDamage(p,d)
    Duel.Hint(HINT_MESSAGE,tp,"Drum's penetrate deals 1 Life damage!")
end

function s.atkcon(e)
    return Duel.IsExistingMatchingCard(s.flagfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end

function s.flagfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x7000) -- BuddyFight Flag archetype
end 
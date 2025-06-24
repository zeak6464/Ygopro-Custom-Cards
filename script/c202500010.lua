-- Drum the Dragon Buddy (Using Built-in Systems)
local s,id=GetID()
function s.initial_effect(c)
    -- Archetype is set in database (Dragon World)
    
    -- Special Summon as Buddy Call
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.spcon)
    e1:SetCost(s.spcost)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    
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

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    -- Can only Buddy Call if not already called
    return Buddyfight and Buddyfight[tp] and not Buddyfight[tp].buddy_called
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return BuddyfightDuel.CanCastSpellNew(tp,2) end
    BuddyfightDuel.PayGaugeNew(tp,2)
    Duel.Hint(HINT_MESSAGE,tp,"Buddy Call! Paid 2 gauge")
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        -- Mark buddy as called
        if Buddyfight and Buddyfight[tp] then
            Buddyfight[tp].buddy_called = true
        end
        
        -- Buddy Gift: +1 Life using new system
        BuddyfightDuel.HealLife(tp,1)
        Duel.Hint(HINT_MESSAGE,tp,"Buddy Call successful! Drum enters as Buddy, +1 Life (Buddy Gift)")
    end
end

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
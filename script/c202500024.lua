-- Dragon World Flag (Using Built-in Gauge System)
local s,id=GetID()
function s.initial_effect(c)
    -- Mark as BuddyFight Flag (archetype set in database)
    
    -- Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    
    -- ATK/DEF boost to Dragon World monsters
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(s.atkfilter)
    e2:SetValue(500)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)
    
    -- Allow direct attack when opponent has no Size 2+ monsters
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_DIRECT_ATTACK)
    e4:SetRange(LOCATION_FZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(s.atkfilter)
    e4:SetCondition(s.dircon)
    c:RegisterEffect(e4)
    
    -- When Dragon World monster destroys opponent monster, draw 1
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,0))
    e5:SetCategory(CATEGORY_DRAW)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_BATTLE_DESTROYING)
    e5:SetRange(LOCATION_FZONE)
    e5:SetCondition(s.drcon)
    e5:SetTarget(s.drtg)
    e5:SetOperation(s.drop)
    c:RegisterEffect(e5)
    
    -- Gauge cost search ability
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,1))
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_FZONE)
    e6:SetCountLimit(1)
    e6:SetCost(s.srcost)
    e6:SetTarget(s.srtg)
    e6:SetOperation(s.srop)
    c:RegisterEffect(e6)
end

function s.atkfilter(e,c)
    return c:IsSetCard(0x5000) -- Dragon World archetype
end

function s.dircon(e)
    -- Can direct attack if opponent has no Size 2+ monsters (Level 6+)
    return not Duel.IsExistingMatchingCard(Card.IsLevelAbove,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil,6)
end

function s.drcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return tc and tc:IsControler(tp) and tc:IsSetCard(0x5000) and tc:IsRelateToBattle()
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
    Duel.Hint(HINT_MESSAGE,tp,"Dragon World monster destroys enemy! Draw 1 card")
end

function s.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return BuddyfightDuel.CanCastSpellNew(tp,1) end
    BuddyfightDuel.PayGaugeNew(tp,1)
    Duel.Hint(HINT_MESSAGE,tp,"Dragon World Flag: Paid 1 gauge to search")
end

function s.srfilter(c)
    return c:IsSetCard(0x5000) and c:IsAbleToHand() -- Dragon World cards
end

function s.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.srfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.srop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.srfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        Duel.ShuffleDeck(tp)
        Duel.Hint(HINT_MESSAGE,tp,"Dragon World Flag: Searched Dragon World card!")
    end
end 
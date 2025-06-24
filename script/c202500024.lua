-- Dragon World (Flag)
local s,id=GetID()
function s.initial_effect(c)
    -- Mark as Dragon World flag card (archetype 0x1001 for flags, plus 0x5000 for Dragon World)
    c:SetArchetype(0x1001) -- Flag archetype
    aux.AddSetcodesRule(c,true,0x5000) -- Also treated as Dragon World
    
    -- Mark as Flag
    c.buddyfight_flag = true
    
    -- Must be activated in Field Zone
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_REMAIN_FIELD)
    c:RegisterEffect(e0)
    
    -- Flag benefits for Dragon World monsters
    -- Dragon World monsters gain 500 ATK/DEF
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_FZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(s.atktg)
    e1:SetValue(500)
    c:RegisterEffect(e1)
    
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e2)
    
    -- Dragon World monsters can attack directly if opponent has no size 2+ monsters
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DIRECT_ATTACK)
    e3:SetRange(LOCATION_FZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(s.dirtg)
    e3:SetCondition(s.dircon)
    c:RegisterEffect(e3)
    
    -- When a Dragon World monster destroys an opponent's monster by battle,
    -- you can draw 1 card
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_BATTLE_DESTROYING)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCondition(s.drawcon)
    e4:SetTarget(s.drawtg)
    e4:SetOperation(s.drawop)
    c:RegisterEffect(e4)
    
    -- Once per turn: You can pay 1 gauge to search for a Dragon World monster
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,1))
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_FZONE)
    e5:SetCountLimit(1)
    e5:SetCost(s.searchcost)
    e5:SetTarget(s.searchtg)
    e5:SetOperation(s.searchop)
    c:RegisterEffect(e5)
end

function s.atktg(e,c)
    return c:IsSetCard(0x5000) -- Dragon World monsters
end

function s.dirtg(e,c)
    return c:IsSetCard(0x5000) -- Dragon World monsters
end

function s.dircon(e)
    local tp=e:GetHandlerPlayer()
    -- Check if opponent has no size 2+ monsters
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    for tc in aux.Next(g) do
        if tc:GetSize() >= 2 then
            return false
        end
    end
    return true
end

function s.drawcon(e,tp,eg,ep,ev,re,r,rp)
    local rc=eg:GetFirst()
    return rc:IsControler(tp) and rc:IsSetCard(0x5000) -- Dragon World monster destroyed opponent's monster
end

function s.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.drawop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Draw(p,d,REASON_EFFECT)>0 then
        Duel.Hint(HINT_MESSAGE,tp,"Dragon World's fury grants knowledge!")
    end
end

function s.searchcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return BuddyfightDuel.CanCastSpell(tp,1) end
    BuddyfightDuel.PayGauge(tp,1)
    Duel.Hint(HINT_MESSAGE,tp,"Paid 1 gauge to search Dragon World")
end

function s.searchfilter(c)
    return c:IsSetCard(0x5000) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.searchtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.searchfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.searchop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.searchfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        Duel.ShuffleDeck(tp)
        Duel.Hint(HINT_MESSAGE,tp,"Dragon World summons its ally!")
    end
end 
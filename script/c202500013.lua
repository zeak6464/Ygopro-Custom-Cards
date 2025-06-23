-- Thousand Rapier Dragon (Size 1)
local s,id=GetID()
function s.initial_effect(c)
    -- Mark as Dragon World monster
    c:SetArchetype(0x5000)
    
    -- Set monster size (Size 1)
    c.buddyfight_size = 1
    
    -- Set BuddyFight Penetrate ability
    c.has_penetrate = true

    -- Call cost for normal summoning
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SUMMON_COST)
    e0:SetCost(s.callcost)
    e0:SetOperation(s.callop)
    c:RegisterEffect(e0)

    -- When this card inflicts battle damage, draw 1 card
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLE_DAMAGE)
    e2:SetCondition(s.drawcon)
    e2:SetTarget(s.drawtg)
    e2:SetOperation(s.drawop)
    c:RegisterEffect(e2)
end

function s.callcost(e,c,tp)
    return Duel.CheckLPCost(tp,0) and BuddyfightDuel.CanCastSpell(tp,1)
end

function s.callop(e,tp,eg,ep,ev,re,r,rp)
    BuddyfightDuel.PayGauge(tp,1)
    Duel.Hint(HINT_MESSAGE,tp,"Paid 1 gauge to call Thousand Rapier Dragon (Size 1) - Penetrate!")
end

function s.drawcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and e:GetHandler():IsRelateToBattle()
end

function s.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.drawop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
    Duel.Hint(HINT_MESSAGE,tp,"Thousand Rapier Dragon's piercing strike draws 1 card!")
end 
-- Latale Shield Dragon (Size 1)
local s,id=GetID()
function s.initial_effect(c)
    -- Mark as Dragon World monster
    c:SetArchetype(0x5000)
    
    -- Set monster size (Size 1)
    c.buddyfight_size = 1

    -- Call cost for normal summoning
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SUMMON_COST)
    e0:SetCost(s.callcost)
    e0:SetOperation(s.callop)
    c:RegisterEffect(e0)

    -- Reduce battle damage to 0 once per turn
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e1:SetValue(1)
    e1:SetCountLimit(1)
    c:RegisterEffect(e1)

    -- When this card is destroyed, can special summon another Dragon World monster
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetCondition(s.spcon)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
end

function s.callcost(e,c,tp)
    return Duel.CheckLPCost(tp,0) and BuddyfightDuel.CanCastSpell(tp,1)
end

function s.callop(e,tp,eg,ep,ev,re,r,rp)
    BuddyfightDuel.PayGauge(tp,1)
    Duel.Hint(HINT_MESSAGE,tp,"Paid 1 gauge to call Latale Shield Dragon (Size 1) - Shield!")
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_BATTLE) or e:GetHandler():IsReason(REASON_EFFECT)
end

function s.spfilter(c,e,tp)
    return c:IsSetCard(0x5000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
           and c:IsLevelBelow(4) and not c:IsCode(id)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        Duel.Hint(HINT_MESSAGE,tp,"Latale Shield Dragon's protection summons reinforcements!")
    end
end 
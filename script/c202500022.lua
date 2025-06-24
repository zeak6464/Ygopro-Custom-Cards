-- Dragonblade, Dragofearless (Equip Spell)
local s,id=GetID()
function s.initial_effect(c)
    -- Mark as BuddyFight Item (archetype set in database)
    
    -- Equip only to a monster you control
    aux.AddEquipProcedure(c)
    
    -- No gauge cost to activate (free equip)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
    e1:SetTarget(s.eqtg)
    e1:SetOperation(s.eqop)
    c:RegisterEffect(e1)
    
    -- ATK boost
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(3000)
    c:RegisterEffect(e2)
    
    -- Equip limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EQUIP_LIMIT)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetValue(s.eqlimit)
    c:RegisterEffect(e3)
end

function s.eqfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end

function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.eqfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end

function s.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,c,tc)
        Duel.Hint(HINT_MESSAGE,tp,"Dragonblade, Dragofearless equipped! (+3000 ATK, no cost)")
    end
end

function s.eqlimit(e,c)
    return c:IsControler(e:GetHandlerPlayer())
end 
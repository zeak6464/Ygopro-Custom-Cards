-- Dragonblade, Dragobrave (Equip Spell)
local s,id=GetID()
function s.initial_effect(c)
    -- Mark as BuddyFight Item (archetype set in database)
    
    -- Equip only to a monster you control
    aux.AddEquipProcedure(c)
    
    -- Gauge cost to activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
    e1:SetCost(s.eqcost)
    e1:SetTarget(s.eqtg)
    e1:SetOperation(s.eqop)
    c:RegisterEffect(e1)
    
    -- ATK boost
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(5000)
    c:RegisterEffect(e2)
    
    -- When equipped monster destroys opponent monster, inflict damage
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_DAMAGE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLE_DESTROYING)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(s.damcon)
    e3:SetTarget(s.damtg)
    e3:SetOperation(s.damop)
    c:RegisterEffect(e3)
    
    -- Equip limit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_EQUIP_LIMIT)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetValue(s.eqlimit)
    c:RegisterEffect(e4)
end

function s.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return BuddyfightDuel.CanCastSpellNew(tp,3) end
    BuddyfightDuel.PayGaugeNew(tp,3)
    Duel.Hint(HINT_MESSAGE,tp,"Paid 3 gauge to equip Dragonblade, Dragobrave")
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
        Duel.Hint(HINT_MESSAGE,tp,"Dragonblade, Dragobrave equipped! (+5000 ATK)")
    end
end

function s.eqlimit(e,c)
    return c:IsControler(e:GetHandlerPlayer())
end

function s.damcon(e,tp,eg,ep,ev,re,r,rp)
    local ec=e:GetHandler():GetEquipTarget()
    return ec and eg:IsContains(ec)
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
    Duel.Hint(HINT_MESSAGE,tp,"Dragonblade, Dragobrave deals counterattack damage!")
end 
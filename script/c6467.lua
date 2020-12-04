--オレイカルコスの結界
--The Seal of Orichalcos
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	e1:SetOperation(s.play)
	Duel.RegisterEffect(e1,0)
	--if activation negated, reset state
	local e1b=Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1b:SetCode(EVENT_CHAIN_NEGATED)
	e1b:SetCondition(s.negdcon)
	e1b:SetOperation(s.negdop)
	e1b:SetLabelObject(e1)
	Duel.RegisterEffect(e1b,0)
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.sumlimit)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetCountLimit(1)
	e4:SetValue(s.valcon)
	c:RegisterEffect(e4)
	--atk limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetCondition(s.atkcon)
	e5:SetValue(s.atlimit)
	c:RegisterEffect(e5)
	--Move monsters from s/t zone 
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCode(EVENT_COUNTER)
	e6:SetRange(LOCATION_SZONE)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetTarget(c6467.sptg)
	e6:SetOperation(c6467.spop)
	c:RegisterEffect(e6)
	--Move s/t to monster zone
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCode(EVENT_COUNTER)
	e7:SetRange(LOCATION_SZONE)
	e7:SetDescription(aux.Stringid(id,1))
	e7:SetTarget(c6467.mptg)
	e7:SetOperation(c6467.mpop)
	c:RegisterEffect(e7)
	
	--clock lizard
	aux.addContinuousLizardCheck(c,LOCATION_FZONE)
end

--Move monsters from s/t zone 
function c6467.afilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:GetSequence()<5
end

function c6467.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_SZONE and chkc:GetControler()==tp and c6467.afilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c6467.afilter,tp,LOCATION_SZONE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=Duel.SelectTarget(tp,c6467.afilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
end

function c6467.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	    Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
	 end
end

--Move s/t to monster zone
function c6467.mptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()==tp end
	if chk==0 then return Duel.IsExistingTarget(c6467.afilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end 
	local mc=Duel.SelectTarget(tp,c6467.afilter,tp,LOCATION_MZONE,0,1,1,nil)
end

function c6467.mpop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	local mc=Duel.GetFirstTarget()
	if mc:IsRelateToEffect(e) then
	    Duel.MoveToField(mc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	 end
end



--None Edited code 
function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,0,0,0)
end
function s.desfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,0,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.negdcon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject() and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.negdop(e)
	Duel.ResetFlagEffect(e:GetHandlerPlayer(),id)
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA)
end
function s.valcon(e,re,r,rp)
	return (r&REASON_EFFECT)~=0
end
function s.atkcon(e)
	return Duel.IsExistingMatchingCard(Card.IsPosition,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil,POS_FACEUP_ATTACK)
end
function s.atkfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()<atk
end
function s.atlimit(e,c)
	return c:IsFaceup() and not Duel.IsExistingMatchingCard(s.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,c,c:GetAttack())
end

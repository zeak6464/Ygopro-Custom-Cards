--オレイカルコスの結界
--The Seal of Orichalcos
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--Cannot be destroyed by effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	
	--ATK boost for all monsters
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE+LOCATION_SZONE,0)
	e3:SetTarget(s.atktg)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	
	--Cannot attack S/T monsters if there are monsters in Monster Zone
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,LOCATION_SZONE)
	e4:SetValue(s.atlimit)
	c:RegisterEffect(e4)
	
	--Move monsters from s/t zone 
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
	
	--Move s/t to monster zone
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetTarget(s.mptg)
	e6:SetOperation(s.mpop)
	c:RegisterEffect(e6)
end

--ATK boost for monsters in both Monster Zone and S/T Zone
function s.atktg(e,c)
	return c:IsType(TYPE_MONSTER)
end

--Attack limitation for S/T monsters
function s.atlimit(e,c,tp,tc)
	return tc:IsLocation(LOCATION_SZONE) and tc:IsType(TYPE_MONSTER) 
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_MONSTER)
end

--Move monsters from s/t zone 
function s.afilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:GetSequence()<5
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_SZONE and chkc:GetControler()==tp and s.afilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.afilter,tp,LOCATION_SZONE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=Duel.SelectTarget(tp,s.afilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
	end
end

--Move s/t to monster zone
function s.mptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()==tp end
	if chk==0 then return Duel.IsExistingTarget(s.afilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end 
	local mc=Duel.SelectTarget(tp,s.afilter,tp,LOCATION_MZONE,0,1,1,nil)
end

function s.mpop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	local mc=Duel.GetFirstTarget()
	if mc:IsRelateToEffect(e) then
		Duel.MoveToField(mc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

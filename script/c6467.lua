--オレイカルコスの結界
--The Seal of Orichalcos
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.actcost)
	c:RegisterEffect(e1)
	
	--Cannot be destroyed by effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	
	--ATK boost for monsters
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	
	--Place monster in S/T zone
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(s.pltg)
	e4:SetOperation(s.plop)
	c:RegisterEffect(e4)
	
	--[ANIME] Lose the duel when destroyed
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(s.losecon)
	e5:SetOperation(s.loseop)
	c:RegisterEffect(e5)
	
	--[ANIME] Cannot use Extra Deck
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(1,0)
	e6:SetTarget(s.splimit)
	c:RegisterEffect(e6)
	
	--[ANIME] Only DARK monsters can attack
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_ATTACK)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetTarget(s.attlimit)
	c:RegisterEffect(e7)
	
	--[ANIME] Direct attack protection
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTargetRange(0,LOCATION_MZONE)
	e8:SetCondition(s.protcon)
	c:RegisterEffect(e8)
	
	--Enable monster effects in S/T zone
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_ACTIVATE_COST)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetRange(LOCATION_FZONE)
	e9:SetTargetRange(1,0)
	e9:SetTarget(s.actarget)
	c:RegisterEffect(e9)
	
	--Treat as monsters for effects
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_CHANGE_TYPE)
	e10:SetRange(LOCATION_FZONE)
	e10:SetTargetRange(LOCATION_SZONE,0)
	e10:SetTarget(s.tgtg)
	e10:SetValue(TYPE_MONSTER+TYPE_EFFECT)
	c:RegisterEffect(e10)
	
	--Keep monster properties in S/T zone
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_REMAIN_FIELD)
	e11:SetRange(LOCATION_FZONE)
	e11:SetTargetRange(LOCATION_SZONE,0)
	e11:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	c:RegisterEffect(e11)
	
	--Move between zones
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(id,3))
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_FZONE)
	e12:SetTarget(s.movetg)
	e12:SetOperation(s.moveop)
	c:RegisterEffect(e12)
end

-- Activation cost - anime version required sacrifice
function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	-- Announce its dramatic activation
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(id,4)) -- "The Seal of Orichalcos has been activated!"
end

-- Lose duel condition/operation
function s.losecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_FZONE) 
		and rp~=tp and (r&REASON_EFFECT)~=0
end

function s.loseop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(1-tp,WIN_REASON_SEAL_OF_ORICHALCOS)
end

-- Extra deck restriction
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end

-- Only DARK monsters can attack
function s.attlimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end

-- Protection when no monsters
function s.protcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end

function s.plfilter(c)
	if c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_MONSTER) then
		if c:GetLevel()>=5 and c:GetLevel()<=6 then
			return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)>0
		elseif c:GetLevel()>=7 then
			return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)>1
		else
			return true
		end
	end
	return false
end

function s.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.plfilter,tp,LOCATION_HAND,0,1,nil) end
end

function s.plop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.plfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local tribcount=0
		if tc:GetLevel()>=5 and tc:GetLevel()<=6 then tribcount=1
		elseif tc:GetLevel()>=7 then tribcount=2 end
		
		if tribcount>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local rg=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_MZONE,0,tribcount,tribcount,nil)
			if #rg<tribcount then return end
			Duel.Release(rg,REASON_COST)
		end
		
		--Ask player for position
		local pos=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
		if pos==0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
		end
	end
end

function s.actarget(e,te,tp)
	if te:GetHandler():IsLocation(LOCATION_SZONE) then
		local tc=te:GetHandler()
		if tc:IsType(TYPE_MONSTER) then
			return true
		end
	end
	return false
end

function s.tgtg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end

function s.movefilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_SZONE))
end

function s.movetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.movefilter,tp,LOCATION_MZONE+LOCATION_SZONE,0,1,nil) end
end

function s.moveop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	
	--Select the monster to move
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,s.movefilter,tp,LOCATION_MZONE+LOCATION_SZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	
	if tc:IsLocation(LOCATION_MZONE) then
		--Moving from Monster Zone to S/T Zone
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,tc:GetPosition(),true)
		else
			--No empty S/T Zone, allow swapping
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
			local g2=Duel.SelectMatchingCard(tp,s.movefilter,tp,LOCATION_SZONE,0,1,1,nil)
			local tc2=g2:GetFirst()
			if tc2 then
				local pos1=tc:GetPosition()
				local pos2=tc2:GetPosition()
				
				--Remove both temporarily
				local rg=Group.FromCards(tc,tc2)
				Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
				
				--Return them in swapped positions
				Duel.ReturnToField(tc2)
				Duel.MoveToField(tc2,tp,tp,LOCATION_MZONE,pos2,true)
				Duel.ReturnToField(tc)
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,pos1,true)
			end
		end
	else
		--Moving from S/T Zone to Monster Zone
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,tc:GetPosition(),true)
		else
			--No empty Monster Zone, allow swapping
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
			local g2=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_MZONE,0,1,1,nil,TYPE_MONSTER)
			local tc2=g2:GetFirst()
			if tc2 then
				local pos1=tc:GetPosition()
				local pos2=tc2:GetPosition()
				
				--Remove both temporarily
				local rg=Group.FromCards(tc,tc2)
				Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
				
				--Return them in swapped positions
				Duel.ReturnToField(tc2)
				Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,pos2,true)
				Duel.ReturnToField(tc)
				Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,pos1,true)
			end
		end
	end
end

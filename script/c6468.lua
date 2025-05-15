--Future Card Buddy Fight
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--Initialize Buddy Fight
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(s.initop)
	c:RegisterEffect(e2)
	
	--Gauge system (banish top card of deck)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(s.gaugeop)
	c:RegisterEffect(e3)
	
	--Buddy Call (once per duel)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_MAIN1)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.buddycond)
	e4:SetOperation(s.buddyop)
	c:RegisterEffect(e4)
	
	--Flag effects (draw based on monsters)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_DRAW)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetOperation(s.flagop)
	c:RegisterEffect(e5)
	
	--Item equip (equip spell to player)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PHASE+PHASE_MAIN1)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(s.itemtg)
	e6:SetOperation(s.itemop)
	c:RegisterEffect(e6)
	
	--Impact Call (powerful effect when life is low)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,3))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(s.impactcond)
	e7:SetOperation(s.impactop)
	c:RegisterEffect(e7)
	
	--Initialize global variables
	if not s.global_check then
		s.global_check=true
		s.buddy_monster={}
		s.item_equip={}
		s.gauge_count={}
		s.buddy_called={}
		s.center_pos={}
	end
end

--Initialize Buddy Fight
function s.initop(e,tp,eg,ep,ev,re,r,rp)
	if not s.buddy_monster[tp] then
		s.buddy_monster[tp]=nil
		s.item_equip[tp]=nil
		s.gauge_count[tp]=0
		s.buddy_called[tp]=false
		s.center_pos[tp]=2 --Middle monster zone
		
		--Set Life Points to 10
		Duel.SetLP(tp,10)
		Duel.SetLP(1-tp,10)
		
		Debug.ShowHint("Future Card Buddy Fight rules activated!")
		Debug.ShowHint("- Life Points are now 10")
		Debug.ShowHint("- Buddy Call once per duel")
		Debug.ShowHint("- Gauge (banished cards) used as resources")
		Debug.ShowHint("- Spells can be equipped as Items")
		Debug.ShowHint("- Impact Call when Life Points are at 4 or less")
	end
end

--Gauge System
function s.gaugeop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.GetDecktopGroup(tp,1)
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
			s.gauge_count[tp]=s.gauge_count[tp]+1
			Debug.ShowHint("Gauge increased! Current gauge: "..s.gauge_count[tp])
		end
	end
end

--Buddy Call Condition
function s.buddycond(e,tp,eg,ep,ev,re,r,rp)
	return not s.buddy_called[tp] and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,TYPE_MONSTER)
end

--Buddy Call Operation
function s.buddyop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,TYPE_MONSTER)
		if #g>0 then
			local tc=g:GetFirst()
			s.buddy_monster[tp]=tc
			s.buddy_called[tp]=true
			
			--Recover 1 life point for Buddy Call
			Duel.Recover(tp,1,REASON_EFFECT)
			
			--Special Summon to center (middle) monster zone
			local seq=s.center_pos[tp]
			if Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true,1<<seq) then
				--Buddy monster gains effects
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(1000)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				
				--Cannot be destroyed by battle once per turn
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e2:SetRange(LOCATION_MZONE)
				e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
				e2:SetCountLimit(1)
				e2:SetValue(s.valcon)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				
				Debug.ShowHint("BUDDY CALL! "..tc:GetName().." is now your Buddy Monster!")
			end
		end
	end
end

--Flag effects (simulate different worlds)
function s.flagop(e,tp,eg,ep,ev,re,r,rp)
	--Count monsters by attribute to determine "world"
	local dragon_count=Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,ATTRIBUTE_FIRE)
	local danger_count=Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,ATTRIBUTE_DARK)
	local magic_count=Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,ATTRIBUTE_LIGHT)
	
	--Bonus draws based on "world"
	if dragon_count>=3 and Duel.SelectYesNo(tp,aux.Stringid(id,6)) then
		Duel.Draw(tp,1,REASON_EFFECT)
		Debug.ShowHint("Dragon World bonus activated!")
	end
	if danger_count>=3 and Duel.SelectYesNo(tp,aux.Stringid(id,7)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
			s.gauge_count[tp]=s.gauge_count[tp]+1
			Debug.ShowHint("Danger World bonus activated! Gauge increased!")
		end
	end
	if magic_count>=3 and Duel.SelectYesNo(tp,aux.Stringid(id,8)) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetValue(500)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Debug.ShowHint("Magic World bonus activated! Monsters gain 500 ATK!")
	end
end

--Item equip target
function s.itemtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,nil,TYPE_SPELL) and not s.item_equip[tp] end
	return Duel.SelectYesNo(tp,aux.Stringid(id,9))
end

--Item equip operation
function s.itemop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,nil,TYPE_SPELL)
	if #g>0 then
		local tc=g:GetFirst()
		s.item_equip[tp]=tc
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		
		--Grant effect based on spell type
		if tc:IsType(TYPE_EQUIP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetValue(800)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
			Debug.ShowHint("Weapon Item equipped! All monsters gain 800 ATK!")
		elseif tc:IsType(TYPE_QUICKPLAY) then
			--Allow direct attack for one monster
			if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,10)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
				local sg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
				if #sg>0 then
					local sc=sg:GetFirst()
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DIRECT_ATTACK)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					sc:RegisterEffect(e1)
					Debug.ShowHint("Quick-Attack Item equipped! "..sc:GetName().." can attack directly!")
				end
			end
		else
			--Recover 2 life points
			Duel.Recover(tp,2,REASON_EFFECT)
			Debug.ShowHint("Defensive Item equipped! Recovered 2 Life Points!")
		end
	end
end

--Impact Call condition
function s.impactcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=4 and s.gauge_count[tp]>=3 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
end

--Impact Call operation
function s.impactop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(id,11)) then
		--Use 3 gauge
		s.gauge_count[tp]=s.gauge_count[tp]-3
		
		--Impact effect - massive damage
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local atk=0
		for tc in aux.Next(g) do
			atk=atk+tc:GetAttack()
		end
		Duel.Damage(1-tp,math.floor(atk/2),REASON_EFFECT)
		Debug.ShowHint("FINAL PHASE - IMPACT CALL! Dealt "..math.floor(atk/2).." damage!")
		
		--Strong visual effect
		Duel.Hint(HINT_CARD,0,id)
	end
end

function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE)~=0
end

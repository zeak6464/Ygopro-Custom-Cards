--Pegasus Ultimate Challenge Duel (Simplified Version)
local s,id=GetID()
function s.initial_effect(c)
	--Apply Pegasus Challenge
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	-- Create a continuous effect that applies a rule every standby phase
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetOperation(s.pegasusrule)
	e1:SetReset(RESET_PHASE+PHASE_END,99)
	Duel.RegisterEffect(e1,tp)
	
	-- Variable to track which rule to apply next
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,0)
end

function s.pegasusrule(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rule_index = c:GetFlagEffectLabel(id) or 0
	rule_index = (rule_index + 1) % 5
	c:SetFlagEffectLabel(id, rule_index)
	
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_MESSAGE,tp,HINTMSG_ANNOUNCE)
	
	if rule_index==1 then
		Duel.Hint(HINT_MESSAGE,tp,HINTMSG_CONFIRM)
		Duel.Hint(HINT_MESSAGE,1-tp,HINTMSG_CONFIRM)
		-- Simple rule 1: Each player draws 1 card
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.Draw(1-tp,1,REASON_EFFECT)
	elseif rule_index==2 then
		Duel.Hint(HINT_MESSAGE,tp,HINTMSG_DESTROY)
		Duel.Hint(HINT_MESSAGE,1-tp,HINTMSG_DESTROY)
		-- Simple rule 2: Destroy all monsters
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_MONSTER)
		Duel.Destroy(g,REASON_EFFECT)
	elseif rule_index==3 then
		Duel.Hint(HINT_MESSAGE,tp,HINTMSG_REMOVE)
		Duel.Hint(HINT_MESSAGE,1-tp,HINTMSG_REMOVE)
		-- Simple rule 3: Remove all cards in graveyards
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	elseif rule_index==4 then
		Duel.Hint(HINT_MESSAGE,tp,HINTMSG_DAMAGE)
		Duel.Hint(HINT_MESSAGE,1-tp,HINTMSG_DAMAGE)
		-- Simple rule 4: 500 damage to both players
		Duel.Damage(tp,500,REASON_EFFECT)
		Duel.Damage(1-tp,500,REASON_EFFECT)
	else
		Duel.Hint(HINT_MESSAGE,tp,HINTMSG_RECOVER)
		Duel.Hint(HINT_MESSAGE,1-tp,HINTMSG_RECOVER)
		-- Simple rule 0: 500 LP gain to both players
		Duel.Recover(tp,500,REASON_EFFECT)
		Duel.Recover(1-tp,500,REASON_EFFECT)
	end
end

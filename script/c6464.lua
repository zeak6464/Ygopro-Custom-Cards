--Command Duel
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableExtraRules(c,s,s.init)
end
function s.init(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1)
	e1:SetOperation(s.play)
	Duel.RegisterEffect(e1,0)
end
function s.play(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,6464)
	local dice=Duel.GetRandomNumber(1,5)
	if dice==1 then
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	elseif dice==2 then
		Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	elseif dice==3 then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif dice==4 then
		Duel.Draw(1-tp,1,REASON_EFFECT)
	elseif dice==5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
	else
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end

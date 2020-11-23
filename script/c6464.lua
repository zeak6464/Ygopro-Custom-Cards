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
	local dice=Duel.GetRandomNumber(1,6)
	print(type(dice))
	if dice==1 then
		Duel.DiscardHand(p,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		print(type("1"))
	elseif dice==2 then
		Duel.DiscardHand(p,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		print(type("2"))
	elseif dice==3 then
		Duel.Draw(p,1,REASON_EFFECT)
		print(type("3"))
	elseif dice==4 then
		Duel.Draw(p,1,REASON_EFFECT)
		print(type("4"))
	elseif dice==5 then
		print(type("5"))
		local g=Duel.SelectMatchingCard(p,aux.TRUE,p,0,LOCATION_MZONE,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
	else
	    print(type("6"))
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end

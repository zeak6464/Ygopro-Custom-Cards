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
	local dice=Duel.GetRandomNumber(1,7)
	if dice==1 then
	    Debug.ShowHint("Swap Life Points with your opponent.")
		local lp1=Duel.GetLP(tp)
		local lp2=Duel.GetLP(1-tp)
		Duel.SetLP(tp,lp2)
		Duel.SetLP(1-tp,lp1)
	elseif dice==2 then
	    Debug.ShowHint("Discard your hand and then draw that many cards.")
	 local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	 local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	 local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	    Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	    Duel.BreakEffect()
	    Duel.Draw(tp,h1,REASON_EFFECT)
	    Duel.Draw(1-tp,h2,REASON_EFFECT)
	elseif dice==3 then
		Debug.ShowHint("Remove all cards from both players graveyards from play.")
	 local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
	    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	elseif dice==4 then
	    Debug.ShowHint("Destory all monsters on the field.")
	 local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	    Duel.Destroy(sg,REASON_EFFECT)
	elseif dice==5 then
	    Debug.ShowHint("Destroy all Spell and Trap Cards on the field.")
	 local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	    Duel.Destroy(sg,REASON_EFFECT)
	elseif dice==6 then
	    Debug.ShowHint("Make All Players Life Points 50% of what they are now.")
		local lp1=Duel.GetLP(tp)
		local lp2=Duel.GetLP(1-tp)
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
		Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
	else --7
	    Debug.ShowHint("Destory all monsters & spells & traps on the field.")
	 local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	    Duel.Destroy(sg,REASON_EFFECT)
	 local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	    Duel.Destroy(sg,REASON_EFFECT)
	end
end

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
	if dice==1 then
	 local g=Duel.GetDecktopGroup(tp,1)
	 local tc=g:GetFirst()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	 local res=Duel.SelectOption(tp,70,71,72)
	Duel.ConfirmDecktop(tp,1)
	if (res==0 and tc:IsType(TYPE_MONSTER))
		or (res==1 and tc:IsType(TYPE_SPELL))
		or (res==2 and tc:IsType(TYPE_TRAP)) then
		local lp1=Duel.GetLP(tp)
		local lp2=Duel.GetLP(1-tp)
		Duel.SetLP(tp,lp2)
		Duel.SetLP(1-tp,lp1)
	end
	Duel.ShuffleDeck(tp)
		Debug.ShowHint("Swap Life Points with your opponent.")
	elseif dice==2 then
	 local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	 local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	 local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	    Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	    Duel.BreakEffect()
	    Duel.Draw(tp,h1,REASON_EFFECT)
	    Duel.Draw(1-tp,h2,REASON_EFFECT)
		Debug.ShowHint("Discard your hand and then draw that many cards.")
	elseif dice==3 then
	 local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
	    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Debug.ShowHint("Remove all monsters from both players graveyards from play.")
	elseif dice==4 then
	 local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	    Duel.Destroy(sg,REASON_EFFECT)
		Debug.ShowHint("Destory all monsters on the field.")
	elseif dice==5 then
	 local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
		Debug.ShowHint("Destroy all Spell and Trap Cards on the field.")
	else --6
	 local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	    Duel.Destroy(sg,REASON_EFFECT)
	 local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	    Duel.Destroy(sg,REASON_EFFECT)
		Debug.ShowHint("Destory all monsters & spells & traps on the field.")
	end
end

--Pegasus Ultimate Challenge Duel
local s,id=GetID()
--function s.initial_effect(c)
--	aux.EnableExtraRules(c,s,s.init)
--end
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
		Debug.ShowHint("A rule has been annouced!")
	local dice=Duel.GetRandomNumber(1,9)
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
	 local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	elseif dice==4 then
	    Debug.ShowHint("Destory all monsters on the field.")
	 local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	    Duel.Destroy(sg,REASON_EFFECT)
	elseif dice==5 then
	    Debug.ShowHint("Destroy all Spell and Trap Cards on the field.")
	 local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	    Duel.Destroy(sg,REASON_EFFECT)
	elseif dice==6 then
	    Debug.ShowHint("Make All Players Life Points 50% of what they are now.")
		local lp1=Duel.GetLP(tp)
		local lp2=Duel.GetLP(1-tp)
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
		Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
	elseif dice==7 then
	    Debug.ShowHint("Draw a card and take 1000 points of damage.")
	    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
        Duel.Draw(p,d,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Recover(p,-1000,REASON_EFFECT)
	elseif dice==8 then
		 if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 or Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then
        Debug.ShowHint("Sorry you and your opponent need at least 1 card in hand inorder to send a card from each players hand to the graveyard.")
		 return end
		Debug.ShowHint("Send 1 card to the graveyard from your oppeonts hand.")
	    local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	    local g2=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	    Duel.ConfirmCards(tp,g1)
	    Duel.ConfirmCards(1-tp,g2)
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	    local sg1=g1:Select(tp,1,1,nil)
	    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
	    local sg2=g2:Select(1-tp,1,1,nil)
	    sg1:Merge(sg2)
	    Duel.SendtoGrave(sg1,REASON_EFFECT+REASON_DISCARD)
	    Duel.ShuffleHand(tp)
	    Duel.ShuffleHand(1-tp)
	    Duel.BreakEffect()
	    Duel.Draw(tp,1,REASON_EFFECT)
	    Duel.Draw(1-tp,1,REASON_EFFECT)	
	else --9
	    Debug.ShowHint("Destory all monsters & Spells & Traps on the field.")
	 local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	    Duel.Destroy(sg,REASON_EFFECT)
	 local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	    Duel.Destroy(sg,REASON_EFFECT)
	end
end

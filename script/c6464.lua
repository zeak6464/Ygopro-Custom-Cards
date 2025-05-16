--Pegasus Ultimate Challenge Duel
local s,id=GetID()
--function s.initial_effect(c)
--	aux.EnableExtraRules(c,s,s.init)
--end
--function s.init(c)
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	Debug.ShowHint("Greetings Duelists!")
	e1:SetOperation(s.operation)
	Duel.RegisterEffect(e1,0)
end


function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	
	local announce={
		"Ooh, a rule change!",
		"Let's make this more interesting!",
		"I have a special surprise for you!",
		"This should spice things up!",
		"Kaiba-boy would hate this one!"
	}
	local idx=Duel.GetRandomNumber(1,#announce)
	
	Debug.ShowHint(announce[idx])
	
	--Get a random rule, but not the same as last time
	local dice=0
	repeat
		dice=Duel.GetRandomNumber(1,40)
	until dice~=s.last_rule
	
	s.last_rule=dice
	
	if dice==1 then
		Debug.ShowHint("All players reveal the top card of their deck. You may play that card immediately, starting with the turn player.")
		for p=tp,1-tp do
			if Duel.GetFieldGroupCount(p,LOCATION_DECK,0)>0 then
				local tc=Duel.GetDecktopGroup(p,1):GetFirst()
				Duel.ConfirmCards(1-p,tc)
				if Duel.SelectYesNo(p,aux.Stringid(id,0)) then
					if tc:IsType(TYPE_MONSTER) then
						Duel.SpecialSummon(tc,0,p,p,false,false,POS_FACEUP)
					elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then
						Duel.SSet(p,tc)
					end
				end
			end
		end
	elseif dice==2 then
		Debug.ShowHint("Both players play with their hands revealed.")
		Duel.ConfirmCards(tp,Duel.GetFieldGroup(tp,0,LOCATION_HAND))
		Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(1-tp,0,LOCATION_HAND))
		--This effect is temporary in EDOPro since we can't make it permanent
	elseif dice==3 then
		Debug.ShowHint("Destroy all monsters with five or more stars.")
		local g=Duel.GetMatchingGroup(function(c) return c:GetLevel()>=5 end,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif dice==4 then
		Debug.ShowHint("Everyone discard a random card from their hand.")
		if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
			local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0):RandomSelect(tp,1)
			Duel.SendtoGrave(g1,REASON_DISCARD+REASON_EFFECT)
		end
		if Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 then
			local g2=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):RandomSelect(1-tp,1)
			Duel.SendtoGrave(g2,REASON_DISCARD+REASON_EFFECT)
		end
	elseif dice==5 then
		Debug.ShowHint("Everyone stop and introduce yourself to the person sitting on your right.")
		Debug.ShowHint("Since this is EDOPro, just take a moment to appreciate your opponent's username!")
	elseif dice==6 then
		Debug.ShowHint("Lose 500 LP for each Spell and Trap Card you control.")
		local ct1=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)
		local ct2=Duel.GetMatchingGroupCount(Card.IsType,1-tp,LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)
		Duel.Damage(tp,ct1*500,REASON_EFFECT)
		Duel.Damage(1-tp,ct2*500,REASON_EFFECT)
	elseif dice==7 then
		Debug.ShowHint("Shuffle your hand into your deck and then draw that many cards.")
		local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		local h2=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
		local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		local g2=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Draw(tp,h1,REASON_EFFECT)
		Duel.Draw(1-tp,h2,REASON_EFFECT)
	elseif dice==8 then
		Debug.ShowHint("Swap LP with your opponent.")
		local lp1=Duel.GetLP(tp)
		local lp2=Duel.GetLP(1-tp)
		Duel.SetLP(tp,lp2)
		Duel.SetLP(1-tp,lp1)
	elseif dice==9 then
		Debug.ShowHint("Destroy all monsters with 1500 or less ATK.")
		local g=Duel.GetMatchingGroup(function(c) return c:GetAttack()<=1500 end,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif dice==10 then
		Debug.ShowHint("If you had a card destroyed this turn, you may destroy one of your opponent's cards.")
		local b1=Duel.GetFlagEffect(tp,id)>0
		local b2=Duel.GetFlagEffect(1-tp,id)>0
		if b1 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.Destroy(g,REASON_EFFECT)
		end
		if b2 and Duel.IsExistingMatchingCard(aux.TRUE,1-tp,0,LOCATION_ONFIELD,1,nil) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif dice==11 then
		Debug.ShowHint("Players cannot activate Spell Cards. (They could activate their effects.)")
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,1)
		e1:SetValue(s.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	elseif dice==12 then
		Debug.ShowHint("Remove all cards in all graveyard from the game.")
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	elseif dice==13 then
		Debug.ShowHint("Switch the ATK and DEF of all monsters on the field.")
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SWAP_AD)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e1)
		end
	elseif dice==14 then
		Debug.ShowHint("Turn your deck over and then draw from the new top of the deck.")
		Debug.ShowHint("In EDOPro, we'll simulate this by drawing from the bottom of your deck.")
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 then
			Duel.Draw(1-tp,1,REASON_EFFECT)
		end
	elseif dice==15 then
		Debug.ShowHint("You cannot attack unless you say \"Yu-Gi-Oh!\"")
		Debug.ShowHint("In EDOPro, we'll simulate this by limiting attacks for one turn.")
		--Limit attacks for one turn
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	elseif dice==16 then
		Debug.ShowHint("All monsters become Normal Monsters with no effects.")
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e2)
		end
	elseif dice==17 then
		Debug.ShowHint("Destroy all cards on the field.")
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		Duel.Destroy(g,REASON_EFFECT)
	elseif dice==18 then
		Debug.ShowHint("Destroy all monsters.")
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif dice==19 then
		Debug.ShowHint("Destroy all Spell and Trap Cards.")
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif dice==20 then
		Debug.ShowHint("Destroy all face-up Xyz Monsters.")
		local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsType(TYPE_XYZ) end,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif dice==21 then
	    Debug.ShowHint("Discard your hand and then draw that many cards.")
	 local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		local h2=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	 local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	    Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	    Duel.BreakEffect()
	    Duel.Draw(tp,h1,REASON_EFFECT)
	    Duel.Draw(1-tp,h2,REASON_EFFECT)
	elseif dice==22 then
		Debug.ShowHint("Everyone draw the bottom card of their Deck.")
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.GetDecktopGroup(tp,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)):Select(tp,1,1,nil)
			Duel.SendtoHand(g,tp,REASON_EFFECT)
		end
		if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
			local g=Duel.GetDecktopGroup(1-tp,Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)):Select(1-tp,1,1,nil)
			Duel.SendtoHand(g,1-tp,REASON_EFFECT)
		end
	elseif dice==23 then
		Debug.ShowHint("If you have less LP than your opponent, Special Summon one monster from your hand to the field, ignore all Summoning conditions.")
		if Duel.GetLP(tp)<Duel.GetLP(1-tp) then
			local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_MONSTER)
			if #g>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,true,true,POS_FACEUP)
			end
		end
		if Duel.GetLP(1-tp)<Duel.GetLP(tp) then
			local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_HAND,0,nil,TYPE_MONSTER)
			if #g>0 then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
				local sg=g:Select(1-tp,1,1,nil)
				Duel.SpecialSummon(sg,0,1-tp,1-tp,true,true,POS_FACEUP)
			end
		end
	elseif dice==24 then
		Debug.ShowHint("Players cannot activate Trap Cards. (They could activate their effects.)")
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,1)
		e1:SetValue(s.aclimit2)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	elseif dice==25 then
		Debug.ShowHint("Shuffle your Graveyard into your Deck and then put the top 15 cards of your Deck into the Graveyard.")
		local g1=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
		local g2=Duel.GetFieldGroup(1-tp,LOCATION_GRAVE,0)
		Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.DiscardDeck(tp,math.min(15,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)),REASON_EFFECT)
		Duel.DiscardDeck(1-tp,math.min(15,Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)),REASON_EFFECT)
	elseif dice==26 then
		Debug.ShowHint("You must sing your Battle Phase.")
		Debug.ShowHint("In EDOPro, feel free to sing along to your favorite Yu-Gi-Oh theme song!")
	elseif dice==27 then
		Debug.ShowHint("Destroy all Continuous Spell and Trap Cards.")
		local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and (c:IsType(TYPE_CONTINUOUS)) end,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif dice==28 then
		Debug.ShowHint("Destroy all monsters with 1500 or more ATK.")
		local g=Duel.GetMatchingGroup(function(c) return c:GetAttack()>=1500 end,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif dice==29 then
		Debug.ShowHint("Destroy all monsters with 4 or less Levels.")
		local g=Duel.GetMatchingGroup(function(c) return c:GetLevel()<=4 and c:GetLevel()>0 end,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif dice==30 then
		Debug.ShowHint("No monsters can be face-down, flip all face-down monsters to face up and their flip effects are negated.")
		local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.ChangePosition(g,POS_FACEUP_ATTACK)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e1)
		end
	elseif dice==31 then
		Debug.ShowHint("Shuffle your Side Deck and then draw from that instead of your Main Deck.")
		Debug.ShowHint("In EDOPro, we can't access the Side Deck, so let's draw from our Main Deck instead!")
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.Draw(1-tp,1,REASON_EFFECT)
	elseif dice==32 then
		Debug.ShowHint("Swap monsters with your opponent. All of them.")
		local g1=Duel.GetMatchingGroup(Card.IsAbleToChangeControler,tp,LOCATION_MZONE,0,nil)
		local g2=Duel.GetMatchingGroup(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,nil)
		if #g1>0 or #g2>0 then
			Duel.SwapControl(g1,g2)
		end
	elseif dice==33 then
		Debug.ShowHint("Turn all monsters face-down.")
		local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	elseif dice==34 then
		Debug.ShowHint("You can only activate cards on your turn.")
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,1)
		e1:SetValue(s.aclimit3)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	elseif dice==35 then
		Debug.ShowHint("You can only play monsters with an ATK of 1600 or higher.")
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetTarget(s.sumlimit)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
		Duel.RegisterEffect(e3,tp)
	elseif dice==36 then
		Debug.ShowHint("Choose a monster, a spell, and a trap card from your Graveyard and set them all onto your field.")
		for p=tp,1-tp do
			local g1=Duel.GetMatchingGroup(Card.IsType,p,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
			local g2=Duel.GetMatchingGroup(Card.IsType,p,LOCATION_GRAVE,0,nil,TYPE_SPELL)
			local g3=Duel.GetMatchingGroup(Card.IsType,p,LOCATION_GRAVE,0,nil,TYPE_TRAP)
			if #g1>0 and #g2>0 and #g3>0 and Duel.GetLocationCount(p,LOCATION_SZONE)>=3 then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SET)
				local sg1=g1:Select(p,1,1,nil)
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SET)
				local sg2=g2:Select(p,1,1,nil)
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SET)
				local sg3=g3:Select(p,1,1,nil)
				local sg=sg1+sg2+sg3
				Duel.SSet(p,sg)
			end
		end
	elseif dice==37 then
		Debug.ShowHint("Each duelist must search his or her deck for any card, add it to their hand, and shuffle their deck afterward.")
		for p=tp,1-tp do
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(p,aux.TRUE,p,LOCATION_DECK,0,1,1,nil)
			if #g>0 then
				Duel.SendtoHand(g,p,REASON_EFFECT)
				Duel.ConfirmCards(1-p,g)
				Duel.ShuffleDeck(p)
			end
		end
	elseif dice==38 then
		Debug.ShowHint("Choose a card in your opponent's graveyard and set it to your side of the field.")
		for p=tp,1-tp do
			local g=Duel.GetMatchingGroup(Card.IsType,p,0,LOCATION_GRAVE,nil,TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
			if #g>0 and Duel.GetLocationCount(p,LOCATION_SZONE)>0 then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SET)
				local sg=g:Select(p,1,1,nil)
				Duel.SSet(p,sg)
			end
		end
	elseif dice==39 then
		Debug.ShowHint("Each duelist may draw up to two cards, but loses 1000 Life Points for each card he or she chooses to draw.")
		for p=tp,1-tp do
			local opt=Duel.SelectOption(p,aux.Stringid(id,1),aux.Stringid(id,2),aux.Stringid(id,3))
			if opt>=1 then
				Duel.Draw(p,1,REASON_EFFECT)
				Duel.Damage(p,1000,REASON_EFFECT)
			end
			if opt==2 then
				Duel.Draw(p,1,REASON_EFFECT)
				Duel.Damage(p,1000,REASON_EFFECT)
			end
		end
	else --40
	    Debug.ShowHint("Make All Players Life Points 50% of what they are now.")
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
		Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
	end
	
	--Flip skill back to indicate it can be used again
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(0<<32))
end

-- Helper functions for the various effect limitations
function s.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end

function s.aclimit2(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end

function s.aclimit3(e,re,tp)
	return Duel.GetTurnPlayer()~=tp
end

function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsAttackBelow(1599)
end

function s.halfval(e,c)
	return math.floor(c:GetBaseAttack()/2)
end

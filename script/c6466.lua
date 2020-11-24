--Red-Eyes Dark Dragoon Challenge Duel
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableExtraRules(c,s,s.init)
end
function s.init(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1)
	e1:SetOperation(s.play)
	Duel.RegisterEffect(e1,0)
end
function s.play(e,tp,eg,ep,ev,re,r,rp)
	    Duel.Hint(HINT_CARD,0,6465)
	   	Debug.ShowHint("Red-Eyes Dark Dragoon has entered the duel.")
		local token=Duel.CreateToken(tp,37818794)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end

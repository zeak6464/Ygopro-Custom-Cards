--Red-Eyes Dark Dragoon Challenge Duel
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	e1:SetOperation(s.play)
	Duel.RegisterEffect(e1,0)
end
function s.play(e,tp,eg,ep,ev,re,r,rp)
	    Duel.Hint(HINT_CARD,0,6466)
		Debug.ShowHint("This should be played in AI Mode with You going 1st.")
	   	Debug.ShowHint("Red-Eyes Dark Dragoon has entered the duel.")
		local token=Duel.CreateToken(1-tp,37818794)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end

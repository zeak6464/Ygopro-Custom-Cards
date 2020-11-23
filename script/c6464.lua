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
	Duel.Hint(HINT_CARD,0,id)
	local ac
	local te
	local code
	local tc
	local p=Duel.GetTurnPlayer()
	while not te do
		ac=Duel.GetRandomNumber(1,#s.command)
		code=s.command[ac]
		tc=Duel.CreateToken(p,code)
		te=tc:GetActivateEffect()
	end
	if Duel.GetLocationCount(p,LOCATION_SZONE)<=0 then return end
	local tg=te:GetTarget()
	local co=te:GetCost()
	local op=te:GetOperation()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	Duel.ClearTargetCard()
	if not tc:IsType(TYPE_FIELD) then
		local of=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
		if of then Duel.Destroy(of,REASON_RULE) end
		of=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
	end
	Duel.MoveToField(tc,p,p,LOCATION_FZONE,POS_FACEUP,true)
	Duel.Hint(HINT_CARD,0,tc:GetCode())
	tc:CreateEffectRelation(te)
	if tc:IsType(TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
		tc:CancelToGrave(false)
	end
	if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
	if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
	Duel.BreakEffect()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g then
		local etc=g:GetFirst()
		while etc do
			etc:CreateEffectRelation(te)
			etc=g:GetNext()
		end
	end
	if op then op(te,tp,eg,ep,ev,re,r,rp) end
	tc:ReleaseEffectRelation(te)
	if etc then	
		etc=g:GetFirst()
		while etc do
			etc:ReleaseEffectRelation(te)
			etc=g:GetNext()
		end
	end
	Duel.SendtoDeck(tc,nil,-2,REASON_RULE)
end
s.command = {
	53129443,05556668,11110587,12580477,18144506,19613556,31036355,33782437,
	37812118,38723936,43434803,54693926,70368879,72892473,7550286,81439173,
	82257940,83764718,100000070,100000083,100000225,511001136,511001176,
	511001281,511001357,511001408,511001460,511001480,511001651,511001758,
	511001939,511002004,511002048,511002114,511002295,511002387,511002531,
	511002537,511002766,511002797,511002923,511002977,511004003,511009397,
	511247020,511777003,513000055,513000080,810000021,810000082,810000088,
	08842266,18027138,24224830,52817046,511000091,51100373,511000540,
	511000541,511001383,511001898,511001901,511016008,511600004,513000011,
	08868767,10045474,12607053,15800838,17484499,17688543,29843091,
	37576645,42776960,49587034,56119752,64697231,71587526,83555666,
	83778600,89462956,94192409,511000312,511000913,511001201,511001499,
	51103026,511003076,810000006,511001122,10000040
	}

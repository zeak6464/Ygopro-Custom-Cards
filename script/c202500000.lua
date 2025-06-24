--BuddyFight Duel Functions
local id=202500000

if not BuddyfightDuel then

	-- Helper Functions for Card Types
	function Card.IsFlagCard(c)
		return c:IsType(TYPE_SPELL+TYPE_FIELD) and c:IsSetCard(0x1001) -- Flag archetype
	end

	function Card.IsBuddyMonster(c)
		return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1000) -- Buddy archetype
	end

	function Card.IsItemCard(c)
		return c:IsType(TYPE_SPELL) and c:IsSetCard(0x2000) -- Item archetype (was Equipment)
	end

	function Card.IsImpactCard(c)
		return c:IsType(TYPE_SPELL) and c:IsSetCard(0x3000) -- Impact archetype
	end

	function Card.IsImpactMonster(c)
		return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3000) -- Impact Monster archetype
	end

	function Card.IsCounterCard(c)
		return c:IsType(TYPE_TRAP) and c:IsSetCard(0x4000) -- Counter archetype
	end

	function Card.IsBuddyfightCard(c)
		return c:IsSetCard(0x1000) or c:IsSetCard(0x1001) or c:IsSetCard(0x2000) or 
			   c:IsSetCard(0x3000) or c:IsSetCard(0x4000) -- Any BuddyFight card
	end

	-- Get monster size (uses YGO Level system - Level = Size directly!)
	function Card.GetSize(c)
		-- Level 1 = Size 1, Level 2 = Size 2, Level 3 = Size 3, etc.
		-- Non-monsters default to Size 1
		if c:IsType(TYPE_MONSTER) then
			return c:GetLevel()
		else
			return 1
		end
	end

	-- Zone constants for BuddyFight (Left, Center, Right)
	BUDDYFIGHT_LEFT = 0x01    -- Zone 0
	BUDDYFIGHT_CENTER = 0x02  -- Zone 1  
	BUDDYFIGHT_RIGHT = 0x04   -- Zone 2

	-- BuddyFight Phases (use built-in YGO phases)
	PHASE_BUDDYFIGHT_START = PHASE_DRAW
	PHASE_BUDDYFIGHT_MAIN = PHASE_MAIN1
	PHASE_BUDDYFIGHT_ATTACK = PHASE_BATTLE
	PHASE_BUDDYFIGHT_FINAL = PHASE_END

	-- Gauge Counter Type
	COUNTER_GAUGE = 0x1001

	BuddyfightDuel={}

	function BuddyfightDuel.Start()
		-- Main initialization effect
		local e1=Effect.GlobalEffect()
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_NO_TURN_RESET)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetCountLimit(1)
		e1:SetOperation(BuddyfightDuel.initop)
		Duel.RegisterEffect(e1,0)

		-- BuddyFight Setup (6 cards + 2 gauge)
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PREDRAW)
		e2:SetCountLimit(1)
		e2:SetOperation(BuddyfightDuel.setupop)
		Duel.RegisterEffect(e2,0)

		-- Custom turn structure
		BuddyfightDuel.RegisterCustomPhases()

		-- Zone Restrictions
		BuddyfightDuel.RegisterZoneEffects()

		-- Size System
		BuddyfightDuel.RegisterSizeSystem()

		-- Charge & Draw System (Start Phase only)
		BuddyfightDuel.RegisterChargeSystem()

		-- Direct Attack System
		BuddyfightDuel.RegisterDirectAttackSystem()

		-- Buddy Call System
		BuddyfightDuel.RegisterBuddySystem()

		-- Item System (replaces Equipment)
		BuddyfightDuel.RegisterItemSystem()

		-- Flag System
		BuddyfightDuel.RegisterFlagSystem()

		-- Impact System (Final Phase only)
		BuddyfightDuel.RegisterImpactSystem()

		-- Counter System
		BuddyfightDuel.RegisterCounterSystem()

		-- Drop Zone System
		BuddyfightDuel.RegisterDropZoneSystem()

		-- Status Display System
		BuddyfightDuel.RegisterStatusDisplay()

		-- Monster Battle System (override YGO battle mechanics)
		BuddyfightDuel.RegisterMonsterBattleSystem()
	end

	function BuddyfightDuel.initop(e,tp,eg,ep,ev,re,r,rp)
		-- Initialize global BuddyFight data (simplified)
		Buddyfight = {}
		Buddyfight[0]={buddy_called=false, flag_set=false, impact_used=false, total_size=0}
		Buddyfight[1]={buddy_called=false, flag_set=false, impact_used=false, total_size=0}
		
		-- Create gauge counter tokens for both players
		BuddyfightDuel.SetupGaugeSystem(0)
		BuddyfightDuel.SetupGaugeSystem(1)
		
		Debug.Message("BuddyFight Duel System Activated!")
	end

	function BuddyfightDuel.setupop(e,tp,eg,ep,ev,re,r,rp)
		-- Ensure Buddyfight table exists
		if not Buddyfight then
			Buddyfight = {}
		end
		
		-- BuddyFight setup: 10 Life (use LP directly!)
		Duel.SetLP(0,10)
		Duel.SetLP(1,10)
		
		-- Draw to 6 cards total (since we start with 5, draw 1 more)
		Duel.Draw(0,1,REASON_RULE)
		Duel.Draw(1,1,REASON_RULE)
		
		-- Auto-activate Dragon World Field Spell for both players
		BuddyfightDuel.SetupFieldSpells()
		
		-- Place Buddy Monster as Spell Card in Spell Zone for both players
		BuddyfightDuel.SetupBuddyCards()
		
		-- Use Debug.Message for string messages
		Debug.Message("BuddyFight Setup Complete: 10 Life, 6 cards, 2 gauge, Buddy ready")
	end

	function BuddyfightDuel.RegisterCustomPhases()
		-- Override draw count to 1 per turn
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetValue(1)
		Duel.RegisterEffect(e1,0)
	end

	function BuddyfightDuel.RegisterZoneEffects()
		-- Restrict Monster Zones to Left/Center/Right only (zones 0,1,2)
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_FORCE_MZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetValue(0x07) -- Zones 0,1,2 (binary: 111)
		Duel.RegisterEffect(e1,0)

		-- Limit Spell/Trap to 1 zone (BuddyFight has 1 spell zone)
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_MAX_SZONE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,1)
		e2:SetValue(1) -- Only 1 spell zone
		Duel.RegisterEffect(e2,0)

		-- Show zone names when summoning
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_SUMMON_SUCCESS)
		e3:SetOperation(BuddyfightDuel.zoneannounce)
		Duel.RegisterEffect(e3,0)
	end

	function BuddyfightDuel.RegisterSizeSystem()
		-- Check size when summoning monsters
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetOperation(BuddyfightDuel.sizecheck)
		Duel.RegisterEffect(e1,0)

		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetOperation(BuddyfightDuel.sizecheck)
		Duel.RegisterEffect(e2,0)

		-- Remove monsters when they leave field
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetOperation(BuddyfightDuel.sizeleave)
		Duel.RegisterEffect(e3,0)
	end

	function BuddyfightDuel.RegisterChargeSystem()
		-- Charge & Draw rule (Start Phase only)
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e1:SetOperation(BuddyfightDuel.chargeop)
		Duel.RegisterEffect(e1,0)
	end

	function BuddyfightDuel.RegisterDirectAttackSystem()
		-- Direct Attack when Center is Open
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetCondition(BuddyfightDuel.directatkcon)
		Duel.RegisterEffect(e1,0)
	end

	function BuddyfightDuel.RegisterBuddySystem()
		-- Buddy Call tracking
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetOperation(BuddyfightDuel.buddytrackop)
		Duel.RegisterEffect(e1,0)
	end

	function BuddyfightDuel.RegisterItemSystem()
		-- Item card handling (replaces equipment)
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetOperation(BuddyfightDuel.itemop)
		Duel.RegisterEffect(e1,0)
	end

	function BuddyfightDuel.RegisterFlagSystem()
		-- Flag card can only be set once per duel
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SSET)
		e1:SetOperation(BuddyfightDuel.flagop)
		Duel.RegisterEffect(e1,0)
	end

	function BuddyfightDuel.RegisterImpactSystem()
		-- Impact cards can ONLY be cast during Final Phase (End Phase in YGO)
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetValue(BuddyfightDuel.impactlimit)
		Duel.RegisterEffect(e1,0)

		-- Impact Monster summoning conditions
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetOperation(BuddyfightDuel.impactmonstertrack)
		Duel.RegisterEffect(e2,0)

		-- Reset Impact usage per turn
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e3:SetOperation(BuddyfightDuel.impactreset)
		Duel.RegisterEffect(e3,0)
	end

	function BuddyfightDuel.RegisterCounterSystem()
		-- Counter cards can be activated from hand during opponent's turn
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTargetRange(0xff,0xff)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsCounterCard))
		e1:SetCondition(BuddyfightDuel.counterhandcon)
		Duel.RegisterEffect(e1,0)

		-- Counter activation timing
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ATTACK_ANNOUNCE)
		e2:SetOperation(BuddyfightDuel.counterattackop)
		Duel.RegisterEffect(e2,0)
	end

	function BuddyfightDuel.RegisterDropZoneSystem()
		-- Map Drop Zone to Graveyard conceptually
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TO_GRAVE)
		e1:SetOperation(BuddyfightDuel.dropzoneop)
		Duel.RegisterEffect(e1,0)
	end

	function BuddyfightDuel.RegisterStatusDisplay()
		-- Gauge and status display
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e1:SetOperation(BuddyfightDuel.statusdisplay)
		Duel.RegisterEffect(e1,0)
	end

	function BuddyfightDuel.RegisterMonsterBattleSystem()
		-- Override battle damage calculation to use BuddyFight rules
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
		e1:SetOperation(BuddyfightDuel.battleoverride)
		Duel.RegisterEffect(e1,0)

		-- Handle battle destruction with BuddyFight rules
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLE_DESTROYING)
		e2:SetOperation(BuddyfightDuel.battledestroyop)
		Duel.RegisterEffect(e2,0)
	end

	-- Operation Functions
	function BuddyfightDuel.zoneannounce(e,tp,eg,ep,ev,re,r,rp)
		local tc=eg:GetFirst()
		while tc do
			local zone=tc:GetSequence()
			local zone_name=BuddyfightDuel.GetZoneName(zone)
			local size=tc:GetSize()
			local card_name=tc:GetCode() or "Unknown"
			if tc:IsImpactMonster() then
				Debug.Message("Impact Monster "..tostring(card_name).." (Size "..size..") summoned to "..zone_name.." zone!")
			else
				Debug.Message("Monster "..tostring(card_name).." (Size "..size..") summoned to "..zone_name.." zone!")
			end
			tc=eg:GetNext()
		end
	end

	function BuddyfightDuel.sizecheck(e,tp,eg,ep,ev,re,r,rp)
		local tc=eg:GetFirst()
		while tc do
			if tc:IsMonster() and Buddyfight and Buddyfight[tc:GetControler()] then
				local tp=tc:GetControler()
				local size=tc:GetSize()
				Buddyfight[tp].total_size = Buddyfight[tp].total_size + size
				
				-- Check if total size exceeds 3
				if Buddyfight[tp].total_size > 3 then
					Debug.Message("Total size exceeds 3! Choose monsters to send to drop zone.")
					BuddyfightDuel.HandleSizeOverflow(tp)
				end
			end
			tc=eg:GetNext()
		end
	end

	function BuddyfightDuel.sizeleave(e,tp,eg,ep,ev,re,r,rp)
		local tc=eg:GetFirst()
		while tc do
			if tc:IsMonster() and tc:GetPreviousLocation()==LOCATION_MZONE and Buddyfight and Buddyfight[tc:GetPreviousControler()] then
				local tp=tc:GetPreviousControler()
				local size=tc:GetSize()
				Buddyfight[tp].total_size = math.max(0, Buddyfight[tp].total_size - size)
			end
			tc=eg:GetNext()
		end
	end

	function BuddyfightDuel.HandleSizeOverflow(tp)
		while Buddyfight[tp].total_size > 3 do
			local g=Duel.GetMatchingGroup(Card.IsMonster,tp,LOCATION_MZONE,0,nil)
			if #g==0 then break end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			if tc then
				local size=tc:GetSize()
				local card_name=tc:GetCode() or "Unknown"
				Buddyfight[tp].total_size = Buddyfight[tp].total_size - size
				Duel.SendtoGrave(tc,REASON_RULE)
				Debug.Message("Sent "..tostring(card_name).." (Size "..size..") to drop zone due to size limit")
			end
		end
	end

	function BuddyfightDuel.chargeop(e,tp,eg,ep,ev,re,r,rp)
		-- Charge & Draw can only be done during Start Phase (Draw Phase)
		for p=0,1 do
			if Buddyfight and Buddyfight[p] and Duel.SelectYesNo(p,"Charge 1 card to draw 1? (Start Phase only)") then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
				local g=Duel.SelectMatchingCard(p,nil,p,LOCATION_HAND,0,1,1,nil)
				if #g>0 then
					Duel.SendtoGrave(g,REASON_EFFECT)
					Buddyfight[p].gauge = Buddyfight[p].gauge + 1
					Duel.Draw(p,1,REASON_EFFECT)
					Debug.Message("Charged +1 Gauge! (Start Phase)")
				end
			end
		end
	end

	function BuddyfightDuel.directatkcon(e)
		local c=e:GetHandler()
		local tp=c:GetControler()
		return BuddyfightDuel.CanAttackDirectly(tp)
	end

	function BuddyfightDuel.buddytrackop(e,tp,eg,ep,ev,re,r,rp)
		-- Track buddy monsters for system
		local tc=eg:GetFirst()
		while tc do
			if tc:IsBuddyMonster() and Buddyfight and Buddyfight[tc:GetControler()] then
				local tp=tc:GetControler()
				if not Buddyfight[tp].buddy_called then
					Buddyfight[tp].buddy_monster = tc
				end
			end
			tc=eg:GetNext()
		end
	end

	function BuddyfightDuel.itemop(e,tp,eg,ep,ev,re,r,rp)
		local rc=re:GetHandler()
		if rc and rc:IsItemCard() and re:IsActiveType(TYPE_SPELL) and Buddyfight then
			local tp=rc:GetControler()
			if Buddyfight[tp] then
				-- Only 1 item can be equipped at a time
				if Buddyfight[tp].item_equipped then
					Duel.SendtoGrave(Buddyfight[tp].item_equipped,REASON_RULE)
					Debug.Message("Previous item sent to drop zone")
				end
				Buddyfight[tp].item_equipped = rc
				Debug.Message("Item equipped to fighter!")
			end
		end
	end

	function BuddyfightDuel.flagop(e,tp,eg,ep,ev,re,r,rp)
		local tc=eg:GetFirst()
		if tc and tc:IsFlagCard() and Buddyfight then
			local tp=tc:GetControler()
			if Buddyfight[tp] then
				if Buddyfight[tp].flag_set then
					Debug.Message("Flag already set this duel!")
					Duel.SendtoHand(tc,nil,REASON_RULE)
				else
					Buddyfight[tp].flag_set = true
					Debug.Message("Flag set!")
				end
			end
		end
	end

	function BuddyfightDuel.impactlimit(e,re,tp)
		-- Impact cards can ONLY be activated during End Phase (Final Phase)
		return re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsImpactCard() 
			   and Duel.GetCurrentPhase()~=PHASE_END
	end

	function BuddyfightDuel.impactmonstertrack(e,tp,eg,ep,ev,re,r,rp)
		local tc=eg:GetFirst()
		while tc do
			if tc:IsImpactMonster() and Buddyfight and Buddyfight[tc:GetControler()] then
				local tp=tc:GetControler()
				Buddyfight[tp].impact_used = true
				Debug.Message("Impact Monster summoned! (Final Phase only)")
			end
			tc=eg:GetNext()
		end
	end

	function BuddyfightDuel.impactreset(e,tp,eg,ep,ev,re,r,rp)
		for p=0,1 do
			if Buddyfight and Buddyfight[p] then
				Buddyfight[p].impact_used = false
			end
		end
	end

	function BuddyfightDuel.counterhandcon(e)
		local tp=e:GetHandlerPlayer()
		return Duel.GetTurnPlayer()~=tp -- Only during opponent's turn
	end

	function BuddyfightDuel.counterattackop(e,tp,eg,ep,ev,re,r,rp)
		local at=Duel.GetAttacker()
		if at and Buddyfight then
			local opp=1-at:GetControler()
			if Buddyfight[opp] and Duel.IsExistingMatchingCard(Card.IsCounterCard,opp,LOCATION_HAND,0,1,nil) then
				Buddyfight[opp].counter_ready = true
				Debug.Message("Counter opportunity available!")
			end
		end
	end

	function BuddyfightDuel.dropzoneop(e,tp,eg,ep,ev,re,r,rp)
		for tc in aux.Next(eg) do
			if tc:IsMonster() or tc:IsSpell() or tc:IsTrap() then
				Debug.Message("Card sent to Drop Zone")
			end
		end
	end

	function BuddyfightDuel.statusdisplay(e,tp,eg,ep,ev,re,r,rp)
		for p=0,1 do
			if Buddyfight and Buddyfight[p] then
				local gauge = BuddyfightDuel.GetGauge(p)
				local buddy_status = Buddyfight[p].buddy_called and "Called (Monster Zone)" or "Ready (Buddy Zone)"
				local item_status = Buddyfight[p].item_equipped and "Equipped" or "None"
				local impact_status = Buddyfight[p].impact_used and "Used" or "Ready"
				local counter_status = Buddyfight[p].counter_ready and "Ready" or "Not Ready"
				local total_size = Buddyfight[p].total_size or 0
				Debug.Message("Player "..tostring(p).." | Gauge: "..tostring(gauge).." | Size: "..tostring(total_size).."/3 | Buddy: "..buddy_status.." | Item: "..item_status.." | Impact: "..impact_status.." | Counter: "..counter_status)
			end
		end
	end

	function BuddyfightDuel.battleoverride(e,tp,eg,ep,ev,re,r,rp)
		local a=Duel.GetAttacker()
		local d=Duel.GetAttackTarget()
		
		if a and d and a:IsMonster() and d:IsMonster() then
			-- Use BuddyFight battle rules instead of YGO
			local attacker_power = a:GetAttack()
			local attacker_critical = 1 -- Default critical, cards can override
			local attacker_defense = a:GetDefense()
			
			-- Prevent normal YGO damage calculation
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
			a:RegisterEffect(e1)
			local e2=e1:Clone()
			d:RegisterEffect(e2)
			
			-- Apply BuddyFight resolution
			BuddyfightDuel.ResolveAttack(a, d, attacker_power, attacker_critical, attacker_defense)
		elseif a and not d then
			-- Direct attack - handle with BuddyFight rules
			local attacker_critical = 1 -- Default critical
			local damage = attacker_critical * 1000
			Duel.ChangeBattleDamage(1-a:GetControler(), damage)
			Debug.Message("Direct attack! Dealt "..attacker_critical.." damage")
		end
	end

	function BuddyfightDuel.battledestroyop(e,tp,eg,ep,ev,re,r,rp)
		-- Handle Penetrate in battle destruction (simplified)
		local tc=eg:GetFirst()
		while tc do
			-- This function is kept simple to avoid errors
			-- Penetrate is handled in the main ResolveAttack function
			tc=eg:GetNext()
		end
	end

	-- Helper Functions
	function BuddyfightDuel.IsCenterOccupied(tp)
		return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 and 
			   Duel.IsExistingMatchingCard(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_FACEUP) and
			   Duel.CheckLocation(tp,LOCATION_MZONE,1)==false -- Zone 1 is center
	end

	function BuddyfightDuel.CanAttackDirectly(tp)
		return not BuddyfightDuel.IsCenterOccupied(1-tp)
	end

	function BuddyfightDuel.GetZoneName(zone)
		if zone == 0 then return "Left"
		elseif zone == 1 then return "Center" 
		elseif zone == 2 then return "Right"
		else return "Invalid Zone"
		end
	end

	function BuddyfightDuel.BuddyCall(tp, c)
		if Buddyfight and Buddyfight[tp] and not Buddyfight[tp].buddy_called and Buddyfight[tp].gauge >= 2 then
			Buddyfight[tp].buddy_called = true
			Buddyfight[tp].buddy_monster = c
			Buddyfight[tp].gauge = Buddyfight[tp].gauge - 2
			Duel.Recover(tp,1000,REASON_EFFECT) -- Buddy Gift: +1 Life (1000 LP)
			Debug.Message("Buddy Call! +1 Life (Buddy Gift), -2 Gauge")
			return true
		else
			Debug.Message("Cannot Buddy Call: Already called or insufficient gauge.")
			return false
		end
	end

	function BuddyfightDuel.PayGauge(tp, cost)
		-- Redirect to new gauge system
		return BuddyfightDuel.PayGaugeNew(tp, cost)
	end

	function BuddyfightDuel.CanCastSpell(tp, cost)
		-- Redirect to new gauge system
		return BuddyfightDuel.CanCastSpellNew(tp, cost)
	end

	function BuddyfightDuel.CanCastImpact(tp, cost)
		-- Impact cards can only be used during Final Phase (End Phase) and once per turn
		return Buddyfight and Buddyfight[tp] and Buddyfight[tp].gauge >= cost and not Buddyfight[tp].impact_used
			   and Duel.GetCurrentPhase()==PHASE_END
	end

	function BuddyfightDuel.IsBuddyMonster(tp, c)
		return Buddyfight and Buddyfight[tp] and Buddyfight[tp].buddy_monster == c
	end

	function BuddyfightDuel.CanUseCounter(tp)
		return Buddyfight and Buddyfight[tp] and Buddyfight[tp].counter_ready
	end

	-- Link Attack System (multiple monsters attack together)
	function BuddyfightDuel.CanLinkAttack(tp)
		-- Check if player has 2+ monsters that can link attack
		local g=Duel.GetMatchingGroup(Card.IsMonster,tp,LOCATION_MZONE,0,nil)
		return #g >= 2 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
	end

	function BuddyfightDuel.PerformLinkAttack(tp, monsters, target)
		local combined_power = 0
		local combined_critical = 0
		local min_defense = 9999
		
		-- Calculate combined stats
		for tc in aux.Next(monsters) do
			combined_power = combined_power + tc:GetAttack()
			combined_critical = combined_critical + (tc.buddyfight_critical or 1)
			local def = tc:GetDefense()
			if def < min_defense then
				min_defense = def
			end
		end
		
		-- Use lowest defense for counterattack purposes
		local link_attacker = monsters:GetFirst() -- Representative attacker
		
		if target then
			-- Attack target monster
			BuddyfightDuel.ResolveAttack(link_attacker, target, combined_power, combined_critical, min_defense)
		else
			-- Direct attack
			BuddyfightDuel.ResolveAttack(link_attacker, nil, combined_power, combined_critical, min_defense)
		end
		
		Debug.Message("Link Attack! Combined Power: "..combined_power..", Combined Critical: "..combined_critical)
	end

	-- Constants
	COVER_BUDDYFIGHT=302

	-- BuddyFight Attack Resolution System
	function BuddyfightDuel.ResolveAttack(attacker, target, attacker_power, attacker_critical, attacker_defense)
		local tp = attacker:GetControler()
		local opp = 1-tp
		
		if target and target:IsMonster() then
			-- 3.1.1: Attack hits monster - compare power vs defense
			local target_defense = target:GetDefense()
			if attacker_power >= target_defense then
				Debug.Message("Attack hits! "..attacker_power.." power >= "..target_defense.." defense")
				Duel.Destroy(target,REASON_BATTLE)
				
				-- 3.2.1: Check for Penetrate ability
				if BuddyfightDuel.HasPenetrate(attacker) and target:GetSequence() == 1 then -- Center zone
					local penetrate_damage = attacker_critical * 1000 -- Convert to LP
					Duel.Damage(opp,penetrate_damage,REASON_BATTLE)
					Debug.Message("Penetrate! Dealt "..attacker_critical.." damage to opponent")
				end
				
				-- 3.2.2: Check for Counterattack ability
				if BuddyfightDuel.HasCounterattack(target) then
					local target_power = target:GetAttack()
					if target_power >= attacker_defense then
						Debug.Message("Counterattack! "..target_power.." power >= "..attacker_defense.." defense")
						Duel.Destroy(attacker,REASON_BATTLE)
					end
				end
				
				return true
			else
				Debug.Message("Attack fails! "..attacker_power.." power < "..target_defense.." defense")
				return false
			end
		else
			-- 3.1.2: Attack hits fighter directly - deal critical damage
			local damage = attacker_critical * 1000 -- Convert to LP (1000 LP = 1 Life)
			Duel.Damage(opp,damage,REASON_BATTLE)
			Debug.Message("Direct attack! Dealt "..attacker_critical.." damage (critical)")
			return true
		end
	end

	function BuddyfightDuel.HasPenetrate(c)
		-- Check if card has Penetrate ability (placeholder - would be set by individual cards)
		return c.has_penetrate or false
	end

	function BuddyfightDuel.HasCounterattack(c)
		-- Check if card has Counterattack ability (placeholder - would be set by individual cards)
		return c.has_counterattack or false
	end

	function BuddyfightDuel.CanItemAttack(tp)
		-- Items can attack if equipped and it's the Main Phase
		return Buddyfight and Buddyfight[tp] and Buddyfight[tp].item_equipped
			   and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
	end

	function BuddyfightDuel.CanEquipItem(tp, gauge_cost)
		-- Check if player can equip an item (has enough gauge)
		return Buddyfight and Buddyfight[tp] and Buddyfight[tp].gauge >= gauge_cost
	end

	function BuddyfightDuel.EquipItem(tp, item)
		if not Buddyfight or not Buddyfight[tp] then return false end
		
		-- Only 1 item can be equipped at a time
		if Buddyfight[tp].item_equipped then
			Duel.SendtoGrave(Buddyfight[tp].item_equipped,REASON_RULE)
			Debug.Message("Previous item sent to drop zone")
		end
		
		Buddyfight[tp].item_equipped = item
		return true
	end

	-- ===== NEW BUILT-IN SYSTEM FUNCTIONS =====

	-- Field Spell Setup
	function BuddyfightDuel.SetupFieldSpells()
		-- Create and activate Dragon World Field Spell for both players
		for tp=0,1 do
			-- Ensure player data exists
			if not Buddyfight[tp] then
				Buddyfight[tp] = {}
			end
			
			local field_card = Duel.CreateToken(tp, 202500024)
			if field_card then
				Duel.MoveToField(field_card, tp, tp, LOCATION_FZONE, POS_FACEUP, true)
				field_card:AddCounter(COUNTER_GAUGE, 2) -- Start with 2 gauge
				Buddyfight[tp].field_spell = field_card
				Debug.Message("Player "..tostring(tp).." Dragon World Field activated with 2 gauge")
			end
		end
	end

	-- Buddy Card Setup
	function BuddyfightDuel.SetupBuddyCards()
		-- Let each player choose their Buddy from deck
		for tp=0,1 do
			BuddyfightDuel.SelectBuddyFromDeck(tp)
		end
	end

	-- Select Buddy from Deck
	function BuddyfightDuel.SelectBuddyFromDeck(tp)
		-- Ensure player data exists
		if not Buddyfight[tp] then
			Buddyfight[tp] = {}
		end
		
		-- Search deck for Buddy monsters (Dragon World monsters with "Buddy" in name or specific Buddy monsters)
		local g=Duel.GetMatchingGroup(BuddyfightDuel.BuddyFilter,tp,LOCATION_DECK,0,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT) -- Use standard hint
			local tc=g:Select(tp,1,1,nil):GetFirst()
			if tc then
				-- Remove from deck and shuffle
				Duel.ShuffleDeck(tp)
				
				-- Place in Spell Zone as face-up Spell Card (Buddy Zone)
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				
				-- Mark as Buddy Card in Buddy Zone
				tc.is_buddy_zone = true
				
				-- Change type to Spell while in Buddy Zone
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetValue(TYPE_SPELL)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				tc:RegisterEffect(e1)
				
				Buddyfight[tp].buddy_card = tc
				Debug.Message("Player "..tostring(tp).." selected "..tostring(tc:GetCode()).." as Buddy")
			end
		else
			-- Fallback: Create default Drum Bunker Dragon
			local buddy_card = Duel.CreateToken(tp, 202500002)
			if buddy_card then
				Duel.MoveToField(buddy_card, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
				buddy_card.is_buddy_zone = true
				local e1=Effect.CreateEffect(buddy_card)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetValue(TYPE_SPELL)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				buddy_card:RegisterEffect(e1)
				Buddyfight[tp].buddy_card = buddy_card
				Debug.Message("Player "..tostring(tp).." no Buddy found in deck, using default Drum Bunker Dragon")
			end
		end
	end

	-- Filter for Buddy monsters
	function BuddyfightDuel.BuddyFilter(c)
		-- Check if it's a Dragon World monster that can be a Buddy
		local code = c:GetCode()
		-- Drum Bunker Dragon and other designated Buddy monsters
		return code == 202500002 or code == 202500010 or code == 202500011 or code == 202500012
			or (c:IsSetCard(0x5000) and c:IsType(TYPE_MONSTER) and c:GetLevel() >= 4)
	end

	-- Gauge System using Field Spell Counters
	function BuddyfightDuel.SetupGaugeSystem(tp)
		-- Gauge is now tracked on the Field Spell
		Debug.Message("Player "..tostring(tp).." gauge system ready (Field Spell)")
	end

	function BuddyfightDuel.GetGauge(tp)
		-- Get current gauge from Field Spell
		if Buddyfight[tp] and Buddyfight[tp].field_spell then
			return Buddyfight[tp].field_spell:GetCounter(COUNTER_GAUGE)
		end
		-- Fallback to variable if Field Spell not available
		if Buddyfight[tp] and Buddyfight[tp].gauge then
			return Buddyfight[tp].gauge
		end
		return 0
	end

	function BuddyfightDuel.PayGaugeNew(tp, cost)
		-- Pay gauge from Field Spell
		if BuddyfightDuel.GetGauge(tp) >= cost then
			if Buddyfight[tp].field_spell then
				Buddyfight[tp].field_spell:RemoveCounter(COUNTER_GAUGE, cost)
				local remaining = Buddyfight[tp].field_spell:GetCounter(COUNTER_GAUGE)
				Debug.Message("Player "..tostring(tp).." paid "..tostring(cost).." gauge (remaining: "..tostring(remaining)..")")
			elseif Buddyfight[tp].gauge then
				-- Fallback
				Buddyfight[tp].gauge = Buddyfight[tp].gauge - cost
				Debug.Message("Player "..tostring(tp).." paid "..tostring(cost).." gauge (fallback: "..tostring(Buddyfight[tp].gauge)..")")
			end
			return true
		end
		Debug.Message("Player "..tostring(tp).." insufficient gauge (has: "..tostring(BuddyfightDuel.GetGauge(tp))..", needs: "..tostring(cost)..")")
		return false
	end

	function BuddyfightDuel.AddGauge(tp, amount)
		-- Add gauge to Field Spell
		if Buddyfight[tp] and Buddyfight[tp].field_spell then
			Buddyfight[tp].field_spell:AddCounter(COUNTER_GAUGE, amount)
			local total = Buddyfight[tp].field_spell:GetCounter(COUNTER_GAUGE)
			Debug.Message("Player "..tp.." gained "..amount.." gauge (total: "..total..")")
		elseif Buddyfight[tp] and Buddyfight[tp].gauge then
			-- Fallback
			Buddyfight[tp].gauge = Buddyfight[tp].gauge + amount
			Debug.Message("Player "..tp.." gained "..amount.." gauge (fallback: "..Buddyfight[tp].gauge..")")
		end
	end

	function BuddyfightDuel.CanCastSpellNew(tp, cost)
		-- Check if player can cast spell (using new gauge system)
		return BuddyfightDuel.GetGauge(tp) >= cost
	end

	-- Life System using Direct LP
	function BuddyfightDuel.DealDamage(tp, damage)
		-- Deal damage directly in Life points
		Duel.Damage(tp, damage, REASON_EFFECT)
		Debug.Message("Player "..tp.." takes "..damage.." Life damage")
	end

	function BuddyfightDuel.HealLife(tp, amount)
		-- Heal life directly in LP
		Duel.Recover(tp, amount, REASON_EFFECT)
		Debug.Message("Player "..tp.." recovers "..amount.." Life")
	end

	function BuddyfightDuel.GetLife(tp)
		-- Get current life (LP)
		return Duel.GetLP(tp)
	end

	-- Impact System using Built-in Phase Restrictions
	function BuddyfightDuel.CanCastImpactNew(tp, cost)
		-- Impact can only be cast during End Phase
		return Duel.GetCurrentPhase() == PHASE_END 
			   and BuddyfightDuel.CanCastSpellNew(tp, cost)
			   and not Buddyfight[tp].impact_used
	end

	function BuddyfightDuel.UseImpact(tp)
		-- Mark impact as used this turn
		Buddyfight[tp].impact_used = true
	end

	-- Equipment System using Built-in Equip Spells  
	function BuddyfightDuel.EquipToMonster(equip_card, target_monster, tp)
		-- Use built-in equip system
		if Duel.Equip(tp, equip_card, target_monster) then
			Debug.Message("Equipped "..equip_card:GetCode().." to monster")
			return true
		end
		return false
	end

	-- Buddy Call using Built-in Special Summon
	function BuddyfightDuel.BuddyCallNew(tp)
		-- Check conditions
		if Buddyfight[tp].buddy_called then
			Debug.Message("Buddy already called this duel")
			return false
		end
		
		if not Buddyfight[tp].buddy_card then
			Debug.Message("No Buddy card available")
			return false
		end
		
		if not BuddyfightDuel.CanCastSpellNew(tp, 2) then
			Debug.Message("Insufficient gauge for Buddy Call")
			return false
		end
		
		-- Pay cost and move Buddy from Spell Zone to Monster Zone
		if BuddyfightDuel.PayGaugeNew(tp, 2) then
			local buddy = Buddyfight[tp].buddy_card
			
			-- Remove Spell type effect
			buddy:ResetEffect()
			
			-- Move to Monster Zone
			Duel.MoveToField(buddy, tp, tp, LOCATION_MZONE, POS_FACEUP_ATTACK, true)
			
			-- Mark as called
			Buddyfight[tp].buddy_called = true
			buddy.is_buddy_zone = false
			
			-- Buddy Gift: +1 Life
			BuddyfightDuel.HealLife(tp, 1)
			Debug.Message("Buddy Call successful! Drum moved to Monster Zone, +1 Life (Buddy Gift)")
			return true
		end
		
		return false
	end

end
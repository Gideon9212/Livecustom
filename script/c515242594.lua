--Blue Striker: Moon Burst of OrgXIII
function c515242594.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x666),2)
	c:EnableReviveLimit()
	--multi attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c515242594.atkval)
	c:RegisterEffect(e1)
	--chain attack
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCountLimit(1,515242589)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c515242594.atcon)
	e2:SetTarget(c515242594.attg)
	e2:SetOperation(c515242594.atop)
	c:RegisterEffect(e2)
end
function c515242594.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c==Duel.GetAttacker() and c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) 
		and bc:IsType(TYPE_MONSTER)
end
function c515242594.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.GetAttackTarget():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp) end
	Duel.GetAttackTarget():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,Duel.GetAttackTarget(),1,0,0)
end
function c515242594.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	if not bc:IsRelateToEffect(e) and bc:IsLocation(LOCATION_GRAVE) then return end
	if Duel.SpecialSummonStep(bc,0,tp,1-tp,false,false,POS_FACEUP_ATTACK) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-1000)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			bc:RegisterEffect(e1)
			Duel.SpecialSummonComplete()
			if c:IsFaceup() and c:IsRelateToEffect(e) then
				if bc and bc:IsFaceup() and c:IsFaceup() and c:IsRelateToEffect(e) then
					local e2=Effect.CreateEffect(c)
					e2:SetLabelObject(bc)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
					e2:SetCondition(c515242594.con)
					e2:SetValue(1)
					e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
					c:RegisterEffect(e2)
					local e3=Effect.CreateEffect(c)
					e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e3:SetType(EFFECT_TYPE_FIELD)
					e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
					e3:SetRange(LOCATION_MZONE)
					e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
					e3:SetCondition(c515242594.con)
					e3:SetTarget(c515242594.attacktarget)
					e3:SetLabelObject(bc)
					e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
					e3:SetValue(1)
					c:RegisterEffect(e3)
					bc:RegisterFlagEffect(515242594,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
				end
			end
	end
end
function c515242594.attacktarget(e,c)
	local a=Duel.GetAttacker()
	local ec=e:GetHandler()
	local l=e:GetLabelObject()
	if not a or a~=ec then return false end
	return c~=l
end
function c515242594.actlimit(e,c)
	return not c==e:GetLabelObject()
end
function c515242594.con(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	return bc:GetFlagEffect(515242594)>0
end
function c515242594.atkval(e,c)
	return c:GetLinkedGroupCount()-1   
end




















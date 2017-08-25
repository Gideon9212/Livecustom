--Cloudian - Fog King
function c515777007.initial_effect(c)
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--self destruction if in DEF
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c515777007.sdcon)
	c:RegisterEffect(e2)
	--counters (Normal Summon)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(515777007,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetOperation(c515777007.addc)
	c:RegisterEffect(e3)
	--counters (Special Summon)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--ATK bonus
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(c515777007.atkval)
	c:RegisterEffect(e5)
	--spsummon from hand or graveyard
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c515777007.specsummtg)
	e6:SetOperation(c515777007.specsummoperat)
	c:RegisterEffect(e6)
	--spreading counters
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(515777007,1))
	e7:SetCategory(CATEGORY_COUNTER)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetCondition(c515777007.condition2)
	e7:SetOperation(c515777007.operation2)
	c:RegisterEffect(e7)
end
	
	----SELF DESTRUCTION FILTER
function c515777007.sdcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end
	  ----COUNTERS FILTER
function c515777007.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x18)
end
	   ----COUNTERS OPERATION
function c515777007.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local ct=Duel.GetMatchingGroupCount(c515777007.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		e:GetHandler():AddCounter(COUNTER_NEED_ENABLE+0x1019,ct)
	end
end
	----CHANGING ATK
function c515777007.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x1019)*200
end
	----SPECIAL SUMMON Filter
function c515777007.spsummfilter(c,e,tp)
	return c:IsSetCard(0x18) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
	----SPECIAL SUMMON TARGET
function c515777007.specsummtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c515777007.spsummfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
	   ---- SPECIAL SUMMON OPERATION
function c515777007.specsummoperat(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c515777007.spsummfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
	--Spreading Counters Condition
function c515777007.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetCounter(0x1019)
	e:SetLabel(ct)
	return e:GetHandler():IsReason(REASON_DESTROY) and ct>0
end
	--Spreading Counters Operation
function c515777007.operation2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(515777007,1))
		local sg=g:Select(tp,1,1,nil)
		sg:GetFirst():AddCounter(0x1019,1)
	end
end








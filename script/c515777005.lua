--Cloudian - Altus
function c515777005.initial_effect(c)
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c515777005.sdcon)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(515777005,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetOperation(c515777005.addc)
	c:RegisterEffect(e3)
	--hand destruction
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(515777005,1))
	e4:SetCategory(CATEGORY_HANDES)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c515777005.hdcost)
	e4:SetTarget(c515777005.hdtg)
	e4:SetOperation(c515777005.hdop)
	c:RegisterEffect(e4)
	--counters (spec. summon)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
  
	--spreading counters
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(222000001,2))
	e6:SetCategory(CATEGORY_COUNTER)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c515777005.condition2)
	e6:SetOperation(c515777005.operation2)
	c:RegisterEffect(e6)
end
function c515777005.sdcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end
function c515777005.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x18)
end
function c515777005.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local ct=Duel.GetMatchingGroupCount(c515777005.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		e:GetHandler():AddCounter(COUNTER_NEED_ENABLE+0x1019,ct)
	end
end
function c515777005.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1019,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1019,3,REASON_COST)
end
function c515777005.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c515777005.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
end
function c515777005.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetCounter(0x1019)
	e:SetLabel(ct)
	return e:GetHandler():IsReason(REASON_DESTROY) and ct>0
end
function c515777005.operation2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(222000001,2))
		local sg=g:Select(tp,1,1,nil)
		sg:GetFirst():AddCounter(0x1019,1)
	end
end
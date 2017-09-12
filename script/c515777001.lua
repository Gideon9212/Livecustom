--Cloudian Storm Dragon
function c515777001.initial_effect(c)
--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
--selfdes if in DEF
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c515777001.sdcon)
	c:RegisterEffect(e2)
--to add counters
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(515777001,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetOperation(c515777001.addcounter)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
--banish from graveyard
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(515777001,1))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCost(c515777001.cost)
	e5:SetTarget(c515777001.target)
	e5:SetOperation(c515777001.operat)
	c:RegisterEffect(e5)
--spreading counters
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(515777001,2))
	e6:SetCategory(CATEGORY_COUNTER)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c515777001.condition2)
	e6:SetOperation(c515777001.operation2)
	c:RegisterEffect(e6)
	end
	------------------selfdes if in DEF-----------------------
	function c515777001.sdcon(e)
		return e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)	
	end
	-----------------to add counters--------------------------
	function c515777001.cfilter(c)
		return c:IsFaceup() and c:IsSetCard(0x18)
	end

	function c515777001.addcounter(e,tp,eg,ep,ev,re,r,rp)
		if e:GetHandler():IsRelateToEffect(e) then
			local ct=Duel.GetMatchingGroupCount(c515777001.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
			e:GetHandler():AddCounter(COUNTER_NEED_ENABLE+0x1019,ct)end
	end
	-----------------banish from graveyard------------------
	function c515777001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1019,4,REASON_COST) end
		Duel.RemoveCounter(tp,1,1,0x1019,4,REASON_COST)
	end
	function c515777001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:GetControler()~=tp and chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToRemove() end
		if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	end
	function c515777001.operat(e,tp,eg,ep,ev,re,r,rp,chk)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
	end
---------------------spreading counters---------------------
function c515777001.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetCounter(0x1019)
	e:SetLabel(ct)
	return e:GetHandler():IsReason(REASON_DESTROY) and ct>0
end
function c515777001.operation2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(515777001,2))
		local sg=g:Select(tp,1,1,nil)
		sg:GetFirst():AddCounter(0x1019,1)
	end
end
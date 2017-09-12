--Cloudian Turbulence
function c515777002.initial_effect(c)
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
	e2:SetCondition(c515777002.sdcon)
	c:RegisterEffect(e2)
--to add counters
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(515777002,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetOperation(c515777002.addcounter)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
--Recover banished
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(515777002,1))
	e5:SetCategory((CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c515777002.tohandcost)
	e5:SetTarget(c515777002.tohandtarget)
	e5:SetOperation(c515777002.tohandoperation)
	c:RegisterEffect(e5)
 --special summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_HAND)
	e6:SetCondition(c515777002.specsummcondit)
	c:RegisterEffect(e6)
end
	--spreading counters
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(222000001,2))
	e7:SetCategory(CATEGORY_COUNTER)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetCondition(c222000005.condition2)
	e7:SetOperation(c222000005.operation2)
	c:RegisterEffect(e7)
-----------------------Related to self-destruction
function c515777002.sdcon(e)
		return e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)	
end
function c515777002.cfilter(c)
		return c:IsFaceup() and c:IsSetCard(0x18)
end
------------------------Related to counters generation
function c515777002.addcounter(e,tp,eg,ep,ev,re,r,rp)
		if e:GetHandler():IsRelateToEffect(e) then
			local ct=Duel.GetMatchingGroupCount(c515777002.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
			e:GetHandler():AddCounter(COUNTER_NEED_ENABLE+0x1019,ct)end
end
--------------------------Related to Special summon itself
function c515777002.specsummfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x18)
end
function c515777002.specsummcondit(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c515777002.specsummfilter,tp,LOCATION_MZONE,0,2,nil)
end
----------------------------Related to recovery
function c515777002.tohandcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1019,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1019,3,REASON_COST)
end
function c515777002.tohandtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and chkc:IsAbleToHand()end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function c515777002.tohandoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
---------------------------Related do counters distribution
function c222000005.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetCounter(0x1019)
	e:SetLabel(ct)
	return e:GetHandler():IsReason(REASON_DESTROY) and ct>0
end
function c222000005.operation2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(222000001,2))
		local sg=g:Select(tp,1,1,nil)
		sg:GetFirst():AddCounter(0x1019,1)
	end
end

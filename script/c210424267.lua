--Moon Burst's Reaction
function c210424267.initial_effect(c)
		--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x666))
	e2:SetValue(c210424267.efilter)
	c:RegisterEffect(e2)
		--move card to scale
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c210424267.pencon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c210424267.pentg)
	e3:SetOperation(c210424267.activate)
	c:RegisterEffect(e3)
end
function c210424267.efilter(e,te)
    return not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
        and te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function c210424267.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x666) and not c:IsForbidden()
end
function c210424267.pencon(e,tp,eg,ep,ev,re,r,rp,chk)
return Duel.IsExistingMatchingCard(c210424267.filter,tp,LOCATION_DECK+LOCATION_DECK,0,1,nil) end
function c210424267.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c210424267.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c210424267.filter,tp,LOCATION_DECK,0,nil)
	local ct=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ct=ct+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ct=ct+1 end
	if ct>0 and g:GetCount()>0  then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:Select(tp,1,ct,nil)
		local sc=sg:GetFirst()
		while sc do
			Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			sc=sg:GetNext()
		end
		end
		end
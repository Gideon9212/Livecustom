--Moon Burst's Reaction
function c210424267.initial_effect(c)
		--indes
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c210424267.indtg)
	e1:SetOperation(c210424267.indop)
	c:RegisterEffect(e1)
			--indes
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c210424267.indtg)
	e2:SetOperation(c210424267.indop)
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
function c210424267.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x666) and not c:IsForbidden()
end
function c210424267.pencon(e,tp,eg,ep,ev,re,r,rp,chk)
return Duel.IsExistingMatchingCard(c210424267.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
function c210424267.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c210424267.activate(e,tp,eg,ep,ev,re,r,rp)
if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c210424267.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	local ct=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) or 
	Duel.CheckLocation(tp,LOCATION_PZONE,1) then ct=ct+1 end
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
function c210424267.indfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER)
end
function c210424267.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c210424267.indfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c210424267.indfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetFlagEffect(210424267)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c210424267.indfilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:GetHandler():RegisterFlagEffect(210424267,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c210424267.indop(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCountLimit(1)
		e1:SetValue(c210424267.valcon)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c210424267.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
--Moon Burst: The Precocious
function c210424263.initial_effect(c)
		--pendulum summon
	aux.EnablePendulumAttribute(c)
		--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,210424270)
	e1:SetTarget(c210424263.atktg)
	e1:SetOperation(c210424263.atkop)
	c:RegisterEffect(e1)
			--swap
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4066,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,210424271)
	e2:SetCondition(c210424263.swapcon)
	e2:SetTarget(c210424263.swaptg)
	e2:SetOperation(c210424263.swapop)
	c:RegisterEffect(e2)
				--extra swing
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4066,4))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,210424271)
	e3:SetCondition(c210424263.swapcon)
	e3:SetTarget(c210424263.xswingtg)
	e3:SetOperation(c210424263.xswingop)
	c:RegisterEffect(e3)
	end
function c210424263.thfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsType(TYPE_PENDULUM)
end
	function c210424263.xswingtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c210424263.thfilter(chkc) end
	if chk==0 then return  Duel.IsExistingTarget(c210424263.thfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c210424263.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	
end
function c210424263.xswingop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
function c210424263.spfilter(c,e,tp)
return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x666)
end
function c210424263.swapcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c210424263.swaptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c210424263.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c210424263.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c210424263.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c210424263.swapop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if not Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c210424263.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsType(TYPE_PENDULUM)
end
function c210424263.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c210424263.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c210424263.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c210424263.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,g,1,0,0)
end
function c210424263.atkop(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetValue(tc:GetAttack()*2)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e3:SetValue(tc:GetDefense()*.5)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end
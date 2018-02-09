--Moon Burst: Spell Eater
function c210424257.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--bounce 1 pony you control, destroy 1 spell/trap opp controls
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,210424258)
	e1:SetTarget(c210424257.target)
	e1:SetOperation(c210424257.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCondition(c210424257.battlecon)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetCondition(c210424257.pendcon)
	c:RegisterEffect(e3)
		--swap
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4066,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_BECOME_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,210424259)
	e4:SetCondition(c210424257.swapcon)
	e4:SetTarget(c210424257.swaptg)
	e4:SetOperation(c210424257.swapop)
	c:RegisterEffect(e4)
			--change target's battle position
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(4066,2))
	e5:SetCategory(CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_BECOME_TARGET)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,210424259)
	e5:SetCondition(c210424257.swapcon)
	e5:SetTarget(c210424257.postg)
	e5:SetOperation(c210424257.posop)
	c:RegisterEffect(e5)
end
function c210424257.pendfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x666)
end
function c210424257.pendcon(e,tp,eg,ep,ev,re,r,rp)
		if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c210424257.pendfilter,1,nil,tp)
end
function c210424257.battlecon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:IsFaceup() and ec:IsControler(tp) and ec:IsSetCard(0x666)
end
function c210424257.desfilter1(c,e,sp)
	return c:IsFaceup() and c:IsSetCard(0x666)
end
function c210424257.desfilter2(c,e,sp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c210424257.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c210424257.desfilter1(chkc))
and (chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp-1) and c210424257.desfilter2(chkc)) end
	if chk==0 then return Duel.IsExistingTarget(c210424257.desfilter1,tp,LOCATION_MZONE,0,1,nil)
	and Duel.IsExistingTarget(c210424257.desfilter2,tp,0,LOCATION_SZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c210424257.desfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c210424257.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
	
local g=Duel.SelectMatchingCard(tp,c210424257.desfilter2,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.Destroy(g,REASON_EFFECT)
end
end
end
function c210424257.filter(c)
	return c:IsCanChangePosition()
end
function c210424257.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c210424257.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c210424257.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c210424257.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c210424257.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
function c210424257.spfilter(c,e,tp)
return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x666)
end
function c210424257.swapcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c210424257.swaptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c210424257.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c210424257.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c210424257.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c210424257.swapop(e,tp,eg,ep,ev,re,r,rp)
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
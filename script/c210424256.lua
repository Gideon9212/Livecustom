--Moon Burst: Wish Maker
function c210424256.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--target 1, make it immune to battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,210424256)
	e1:SetTarget(c210424256.target)
	e1:SetOperation(c210424256.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c210424256.battlecon)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(c210424256.pendcon)
	c:RegisterEffect(e3)
		--swap
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4066,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_BECOME_TARGET)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,210424257)
	e4:SetCondition(c210424256.swapcon)
	e4:SetTarget(c210424256.swaptg)
	e4:SetOperation(c210424256.swapop)
	c:RegisterEffect(e4)
		--return 2 to deck, draw 1
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(4066,1))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_BECOME_TARGET)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,210424257)
	e5:SetCondition(c210424256.swapcon)
	e5:SetTarget(c210424256.drtg)
	e5:SetOperation(c210424256.drop)
	c:RegisterEffect(e5)
end
function c210424256.pendfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x666)
end
function c210424256.pendcon(e,tp,eg,ep,ev,re,r,rp)
		if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c210424256.pendfilter,1,nil,tp)
end
function c210424256.battlecon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:IsFaceup() and ec:IsControler(tp) and ec:IsSetCard(0x666)
end
function c210424256.filter1(c,e,sp)
	return c:IsFaceup() and c:IsSetCard(0x666)
end
function c210424256.indfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER)
end
function c210424256.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c210424256.indfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c210424256.indfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetFlagEffect(210424256)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c210424256.indfilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:GetHandler():RegisterFlagEffect(210424256,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c210424256.activate(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCountLimit(1)
		e1:SetValue(c210424256.valcon)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c210424256.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
--return 2 to deck, draw 1
function c210424256.filter(c)
	return c:IsSetCard(0x666) and c:IsAbleToDeck() and c:IsType(TYPE_PENDULUM)
end
function c210424256.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c210424256.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and e:GetHandler():GetFlagEffect(210424256)==0
		and Duel.IsExistingTarget(c210424256.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,2,nil) end
	e:GetHandler():RegisterFlagEffect(210424256,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c210424256.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c210424256.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=2 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	if ct==2 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--swap
function c210424256.spfilter(c,e,tp)
return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x666)
end
function c210424256.swapcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c210424256.swaptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c210424256.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c210424256.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c210424256.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c210424256.swapop(e,tp,eg,ep,ev,re,r,rp)
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
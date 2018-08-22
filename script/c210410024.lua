--created & coded by Lyris, art by DrakeTurtle from DeviantArt
--復剣主ダルク
function c240100256.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c240100256.val)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c240100256.target)
	e3:SetOperation(c240100256.operation)
	c:RegisterEffect(e3)
end
function c240100256.val(e,c)
	return Duel.GetMatchingGroupCount(c240100256.rfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,LOCATION_GRAVE,nil)*100
end
function c240100256.rfilter(c)
	return c:IsSetCard(0xbb2) and c:IsType(TYPE_MONSTER)
end
function c240100256.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xbb2) and c:IsAbleToGrave() and not c:IsCode(240100256)
end
function c240100256.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xbb2) and c:IsAbleToHand() and not c:IsCode(240100256)
end
function c240100256.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()~=0 then
			return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c240100256.thfilter(chkc)
		else return false end
	end
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,240100256)
	e:SetLabel(ct)
	if ct==1 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
		e:SetProperty(0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c240100256.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
end
function c240100256.cfilter(c)
	return c:IsSetCard(0xbb2) and c:IsType(TYPE_MONSTER)
end
function c240100256.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct==1 then
		if Duel.GetMatchingGroupCount(c240100256.cfilter,tp,LOCATION_GRAVE,0,e:GetHandler())==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c240100256.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	else
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end

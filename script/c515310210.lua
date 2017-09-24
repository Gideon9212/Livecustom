--Tinsight Salvage
--AlphaKretin
function c515310210.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c515310210.cost)
	e1:SetTarget(c515310210.target)
	e1:SetOperation(c515310210.operation)
	c:RegisterEffect(e1)
end
function c515310210.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf35) and c:IsAbleToDeckAsCost()
end
function c515310210.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c515310210.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,c515310210.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
end
function c515310210.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf35) and c:IsAbleToHand()
end
function c515310210.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c515310210.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c515310210.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectTarget(tp,c515310210.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c515310210.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.Draw(tp,1,REASON_EFFECT)
end

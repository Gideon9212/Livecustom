 --Lunar Cycles
function c515242572.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,515242572)
	e1:SetTarget(c515242572.target)
	e1:SetOperation(c515242572.activate)
	c:RegisterEffect(e1)
end
function c515242572.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666)
end
function c515242572.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_HAND) and chkc:IsControler(tp) and c515242572.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingTarget(c515242572.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(515242572,0))
	local g=Duel.SelectTarget(tp,c515242572.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c515242572.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN,nil,nil)
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end

--Blue Striker: Tiny Pony, the Wise
function c515242591.initial_effect(c)
		--link summon
aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x666),2)
	c:EnableReviveLimit()
			--search if deal damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(515242591,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCountLimit(1,515242587)
	e1:SetCondition(c515242591.atkcon)
	e1:SetTarget(c515242591.sptg)
	e1:SetOperation(c515242591.spop)
	c:RegisterEffect(e1)
			--search if deal damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(515242591,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCountLimit(1,515242588)
	e2:SetCondition(c515242591.atkcon2)
	e2:SetTarget(c515242591.sptg2)
	e2:SetOperation(c515242591.spop2)
	c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5152425912,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c515242591.thtg)
	e3:SetOperation(c515242591.thop)
	c:RegisterEffect(e3)
end
function c515242591.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroupCount()>=1
end
function c515242591.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_HINTMSG_TOGRAVE,g,1,0,0)
end
function c515242591.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.SendtoGrave(tc,nil,2,REASON_EFFECT)
	end
end
function c515242591.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroupCount()==2
end
function c515242591.filter2(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x666)
end
function c515242591.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingMatchingCard(c515242591.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_GRAVE)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_HINTMSG_ATOEXTRA,g,1,0,0)
end
function c515242591.spop2(e,tp,eg,ep,ev,re,r,rp)
local hg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOEXTRA)
	local g=Duel.SelectMatchingCard(tp,c515242591.filter2,tp,LOCATION_GRAVE,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c515242591.thfilter(c)
	return c:IsType(TYPE_SPELL)  and c:IsAbleToHand()
end
function c515242591.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c515242591.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c515242591.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c515242591.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--Battle in the Storm
function c210424266.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c210424266.target)
	e1:SetOperation(c210424266.activate)
	c:RegisterEffect(e1)
--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_PZONE,0)
	e2:SetTarget(c210424266.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
-- Send 2 ponies from extra to grave, kill 1	
		local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c210424266.descost)
	e4:SetTarget(c210424266.destarget)
	e4:SetOperation(c210424266.desop)
	c:RegisterEffect(e4)
end
function c210424266.desfilter(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_PENDULUM) and c:IsAbleToGraveAsCost() and c:IsFaceup()
end
function c210424266.descost(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(c210424266.desfilter,tp,LOCATION_EXTRA,0,2,nil) end
local g=Duel.SelectMatchingCard(tp,c210424266.desfilter,tp,LOCATION_EXTRA,0,2,2,nil)
Duel.SendtoGrave(g,REASON_COST)
end
function c210424266.destarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDestroy,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDestroy,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c210424266.desop(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c210424266.tgtg(e,c)
	return c:IsSetCard(0x666)
end
function c210424266.sfilter(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c210424266.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210424266.sfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c210424266.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c210424266.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
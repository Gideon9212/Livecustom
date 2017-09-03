--Night Guardian's Sword
function c515242575.initial_effect(c)

--Activate
--[[	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(515242575,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,515242575+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c515242575.activate)
	c:RegisterEffect(e1)]]--
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(515242575,1))
	e2:SetCountLimit(1,515242574)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c515242575.discon)
--	e2:SetTarget(c515242575.distg)
	e2:SetOperation(c515242575.disop)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,515242574)
	e5:SetCost(c515242575.thcost)
	e5:SetTarget(c515242575.thtg)
	e5:SetOperation(c515242575.thop)
	c:RegisterEffect(e5)
	

end


--Activation code
function c515242575.thfilter(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c515242575.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c515242575.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(515242575,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

function c515242575.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c515242575.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c515242575.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c515242575.thop(e,tp,eg,ep,ev,re,r,rp,chk)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c515242575.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--negate code
function c515242575.discon(e,tp,eg,ep,ev,re,r,rp)
    -- if c==nil then return true end
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c515242575.thfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
    local ct=g:GetClassCount(Card.GetCode)
        return ct>1
end
function c515242575.disfilter(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_PZONE) and c:IsFaceup()) and c:IsAbleToDeckAsCost()
end
function c515242575.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c515242575.thfilter,tp,LOCATION_EXTRA,0,nil)
	local rg=Group.CreateGroup()
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TRIBUTE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			rg:AddCard(tc)
			g:Remove(Card.IsCode,nil,tc:GetCode())
	
	Duel.SendtoDeck(tc,nil,2,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	end
	end
end
function c515242575.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c515242575.thfilter,tp,LOCATION_GRAVE,0,nil)
	local rg=Group.CreateGroup()
	for i=1,2 do
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			rg:AddCard(tc)
			g:Remove(Card.IsCode,nil,tc:GetCode())
			Duel.SendtoDeck(tc,nil,2,REASON_COST)
		end
	end

	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)

		Duel.NegateActivation(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end



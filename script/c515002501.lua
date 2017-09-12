--Dark Magic Screen
--scripted by Larry126
function c515002501.initial_effect(c)
	c:SetUniqueOnField(1,0,515002501)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,515002501)
	e1:SetOperation(c515002501.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetCondition(c515002501.indcon)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_CONTINUOUS))
	e2:SetValue(c515002501.indval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	c:RegisterEffect(e3)
end
c515002501.card_code_list={46986414,515002501}
function c515002501.cfilter(c)
	return c:IsFaceup() and c:IsCode(46986414)
end
function c515002501.indcon(e)
	return Duel.IsExistingMatchingCard(c515002501.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c515002501.indval(e,re,tp)
	return e:GetHandler():GetControler()~=tp
end
function c515002501.filter(c)
	return (c:IsCode(46986414) or aux.IsCodeListed(c,46986414) or
		(c:IsSetCard(0xa1) and c:IsType(TYPE_SPELL)))
		and c:IsAbleToHand() and not c:IsCode(515002501)
end
function c515002501.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c515002501.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(515002501,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
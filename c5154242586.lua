--Blue Striker: Little Monster Moon Burst
function c5154242586.initial_effect(c)
		--pendulum summon
	aux.EnablePendulumAttribute(c)
		local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5154242586,2))
	e3:SetCountLimit(1,51542425863)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(c5154242586.descon1)
	e3:SetTarget(c5154242586.destg1)
	e3:SetOperation(c5154242586.desop1)
	c:RegisterEffect(e3)
		-- Once per turn: You can shuffle 1 "Blue Striker" monster you control into the Deck; 
	-- Special Summon 1 "Blue Striker" monster with a different name from your Deck.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c5154242586.tg)
	e2:SetOperation(c5154242586.op)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)

		--If dies, move card from grave to extra
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(5154242586,2))
	e5:SetCountLimit(1,51542425861)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetTarget(c5154242586.target)
	e5:SetOperation(c5154242586.operation)
	c:RegisterEffect(e5)
end
--If deal damage,kill a thing
function c5154242586.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c5154242586.filter2(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_PENDULUM) 
end
function c5154242586.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5154242586.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_GRAVE)
end
function c5154242586.operation(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOEXTRA)
	local g=Duel.SelectMatchingCard(tp,c5154242586.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


--Effect 1 (Search) Code
function c5154242586.descon1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c5154242586.filter(c)
	return c:IsCode(5154242564) and c:IsAbleToHand()
end
function c5154242586.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c5154242586.filter,tp,0x51,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x51)
end
function c5154242586.desop1(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c5154242586.filter,tp,0x51,0,1,1,nil):GetFirst()
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c5154242586.filter1(c,e,tp)
	local code=c:GetCode()
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsAbleToDeckAsCost()
		and Duel.IsExistingMatchingCard(c5154242586.filterz,tp,LOCATION_DECK,0,1,nil,code,e,tp)
end
function c5154242586.filterz(c,code,e,tp)
	return c:IsSetCard(0x666) and c:GetCode()~=code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c5154242586.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c5154242586.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	local rg=Duel.SelectMatchingCard(tp,c5154242586.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetCode())
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c5154242586.op(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c5154242586.filterz,tp,LOCATION_DECK,0,1,1,nil,code,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

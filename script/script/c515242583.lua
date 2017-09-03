--Blue Striker: Disruptive Pony Moon Burst
function c515242583.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Steal monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(515242583,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,515242579)
	e1:SetTarget(c515242583.target)
	e1:SetOperation(c515242583.activate)
	c:RegisterEffect(e1)
		-- Once per turn: You can shuffle 1 "Blue Striker" monster you control into the Deck; 
	-- Special Summon 1 "Blue Striker" monster with a different name from your Deck.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c515242583.tg)
	e2:SetOperation(c515242583.op)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
-- Search Tiny Pony
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4066,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(c515242583.descon1)
	e3:SetTarget(c515242583.destg1)
	e3:SetOperation(c515242583.desop1)
	c:RegisterEffect(e3)
end
--OPT, send a Striker you control to the deck, If you do, sp summon a different one from the deck.
function c515242583.filter1(c,e,tp)
	local code=c:GetCode()
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsAbleToDeckOrExtraAsCost()
		and Duel.IsExistingMatchingCard(c515242583.filter2,tp,LOCATION_DECK,0,1,nil,code,e,tp)
end
function c515242583.filter2(c,code,e,tp)
	return c:IsSetCard(0x666) and c:GetCode()~=code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c515242583.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c515242583.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	
	Duel.SetOperationInfo(0,CATEGORY_TODECK,rg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	
end
function c515242583.op(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) or not Duel.IsExistingMatchingCard(c515242583.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) then return end
    local rg=Duel.SelectMatchingCard(tp,c515242583.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    local code=rg:GetFirst():GetCode()
    Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c515242583.filter2,tp,LOCATION_DECK,0,1,1,nil,code,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

function c515242583.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c515242583.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp,PHASE_END,1)~=0 then
		local e1=Effect.CreateEffect(c)
		local reset=RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetReset(reset)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		e2:SetReset(reset)
		e2:SetValue(1)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_ATTACK)
		e3:SetReset(reset)
		tc:RegisterEffect(e3)
	end
end








--Effect 1 (Search) Code
function c515242583.descon1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c515242583.filter(c)
	return c:IsCode(515242564) and c:IsAbleToHand()
end
function c515242583.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c515242583.filter,tp,0x51,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x51)
end
function c515242583.desop1(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c515242583.filter,tp,0x51,0,1,1,nil):GetFirst()
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
		end
		end
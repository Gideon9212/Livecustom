--Blue Striker: Explorer Pony Moon Burst
function c515242584.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--==Pendulum Effect==--
		-- Once per turn: You can shuffle 1 "Blue Striker" monster you control into the Deck; 
	-- Special Summon 1 "Blue Striker" monster with a different name from your Deck.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c515242584.tg)
	e1:SetOperation(c515242584.op)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--==Monster Effects==--
	--Trade
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(515242584,1))
	e2:SetCountLimit(1,515242580)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetTarget(c515242584.sptg)
	e2:SetOperation(c515242584.spop)
	c:RegisterEffect(e2)
	--To Hand 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4066,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(c515242584.thcost)
	e3:SetTarget(c515242584.thtg2)
	e3:SetOperation(c515242584.thop2)
	c:RegisterEffect(e3)

end

--OPT, send a Striker you control to the deck, If you do, sp summon a different one from the deck.
function c515242584.filter1(c,e,tp)
	local code=c:GetCode()
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsAbleToDeckOrExtraAsCost()
		and Duel.IsExistingMatchingCard(c515242584.filter2,tp,LOCATION_DECK,0,1,nil,code,e,tp)
end
function c515242584.filter2(c,code,e,tp)
	return c:IsSetCard(0x666) and c:GetCode()~=code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c515242584.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c515242584.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	
	Duel.SetOperationInfo(0,CATEGORY_TODECK,rg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	
end
function c515242584.op(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) or not Duel.IsExistingMatchingCard(c515242584.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) then return end
    local rg=Duel.SelectMatchingCard(tp,c515242584.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    local code=rg:GetFirst():GetCode()
    Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c515242584.filter2,tp,LOCATION_DECK,0,1,1,nil,code,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
--Trade Pends

function c515242584.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck() and c:IsSetCard(0x666)
		and Duel.IsExistingMatchingCard(c515242584.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,c,e,tp)
end
function c515242584.spfilter(c,e,tp)
	return c:IsFaceup() and not c:IsType(TYPE_LINK) and c:IsSetCard(0x666) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c515242584.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c515242584.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c515242584.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c515242584.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
    end
end


--To Hand 2
function c515242584.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c515242584.sfilter(c)
	return c:IsCode(515242564) and c:IsAbleToHand()
end
function c515242584.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c515242584.sfilter,tp,0x51,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x51)
end
function c515242584.thop2(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c515242584.sfilter,tp,0x51,0,1,1,nil):GetFirst()
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end

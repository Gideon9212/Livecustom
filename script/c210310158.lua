--Borrelbarron Dragon
--AlphaKretin
function c210310158.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c210310158.mfilter,2)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,210310158)
	e1:SetTarget(c210310158.thtg)
	e1:SetOperation(c210310158.thop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,210311158)
	e2:SetCondition(c210310158.spcon)
	e2:SetTarget(c210310158.sptg)
	e2:SetOperation(c210310158.spop)
	c:RegisterEffect(e2)
end
function c210310158.mfilter(c,lc,sumtype,tp)
	return c:IsRace(RACE_DRAGON,lc,sumtype,tp) and c:IsAttribute(ATTRIBUTE_DARK,lc,sumtype,tp)
end
function c210310158.thfilter(c,code)
	return c:IsAbleToHand() and c:IsSetCard(0x102) and not c:IsCode(code)
end
function c210310158.thtgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x102) and Duel.IsExistingMatchingCard(c210310158.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c210310158.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c210310158.thtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c210310158.thtgfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c210310158.thtgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetChainLimit(c210310158.chlimit)
end
function c210310158.chlimit(e,ep,tp)
	return tp==ep
end
function c210310158.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,c210310158.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c210310158.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x102) and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonEffect() and c:GetReasonEffect():GetHandler()~=c))
end
function c210310158.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c210310158.cfilter,1,nil)
end
function c210310158.spfilter(c,e,tp)
	return c:IsSetCard(0x102) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c210310158.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c210310158.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c210310158.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c210310158.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--created & coded by Lyris, art by Animekidky of DeviantArt
--復剣主ティべリウス
function c240100192.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c240100192.val)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetTarget(c240100192.target)
	e3:SetOperation(c240100192.operation)
	c:RegisterEffect(e3)
end
function c240100192.val(e,c)
	return Duel.GetMatchingGroupCount(c240100192.rfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,LOCATION_GRAVE,nil)*100
end
function c240100192.rfilter(c)
	return c:IsSetCard(0xbb2) and c:IsType(TYPE_MONSTER)
end
function c240100192.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c240100192.spfilter(c)
	return c:IsSetCard(0xbb2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c240100192.cfilter(c)
	return c:IsSetCard(0xbb2) and c:IsType(TYPE_MONSTER)
end
function c240100192.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(c240100192.cfilter,tp,LOCATION_GRAVE,0,e:GetHandler())==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c240100192.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--Blue Striker: Moon Burst the Wish Maker
function c515242590.initial_effect(c)
	--link summon
aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x666),2)
	c:EnableReviveLimit()
	--add link summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetDescription(aux.Stringid(4066,3))
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c515242590.sprcon)
	e0:SetOperation(c515242590.sprop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--send 1 to grave, kill another
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(515242590,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,515242586)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c515242590.descost)
	e1:SetTarget(c515242590.destg1)
	e1:SetOperation(c515242590.desop1)
	c:RegisterEffect(e1)
--banish this card, return TP to the deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(515242590,2))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,515242586)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c515242590.tdcost)
	e2:SetTarget(c515242590.tdtg)
	e2:SetOperation(c515242590.tdop)
	c:RegisterEffect(e2)

end

function c515242590.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),515242590) 
		and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c515242590.tdfilter(c)
	return c:IsCode(515242564) and c:IsAbleToDeck()
end
function c515242590.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c515242590.tdfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c515242590.tdfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c515242590.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c515242590.tdfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end

















function c515242590.cfilter(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER)
end
function c515242590.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c515242590.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c515242590.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c515242590.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsController(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c515242590.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end


function c515242590.sprfilter1(c,tp)
    local lv=c:GetLevel()
    return lv>0 and c:IsSetCard(0x666) and not c:IsCode(515242564) and c:IsFaceup() and c:IsAbleToGraveAsCost()
        and Duel.IsExistingMatchingCard(c515242590.sprfilter2,tp,LOCATION_EXTRA,0,1,nil,lv)
        and Duel.IsExistingMatchingCard(c515242590.sprfilter3,tp,LOCATION_EXTRA,0,1,nil,tp)
end
function c515242590.sprfilter2(c,lv)
    return c:IsFaceup() and c:IsSetCard(0x666) and not c:IsCode(515242564) and c:IsAbleToGraveAsCost()
end
function c515242590.sprfilter3(c,lv)
    return c:IsFaceup() and c:IsCode(515242564) and c:IsAbleToGraveAsCost()
end
function c515242590.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
	 return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
	and Duel.IsExistingMatchingCard(c515242590.sprfilter2,tp,LOCATION_EXTRA,0,1,nil,tp)
	and Duel.IsExistingMatchingCard(c515242590.sprfilter3,tp,LOCATION_EXTRA,0,1,nil,tp)
end

function c515242590.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local g1=Duel.SelectMatchingCard(tp,c515242590.sprfilter2,tp,LOCATION_EXTRA,0,1,1,nil,tp)
    Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	 local g3=Duel.SelectMatchingCard(tp,c515242590.sprfilter3,tp,LOCATION_EXTRA,0,1,1,nil,tp)
    Duel.SendtoGrave(g3,REASON_MATERIAL+REASON_LINK)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
end
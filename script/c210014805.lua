--
--designed and scripted by Larry126
function c210014805.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c210014805.cost)
	e1:SetTarget(c210014805.target)
	e1:SetOperation(c210014805.activate)
	c:RegisterEffect(e1)
end
c210014805.listed_names={0x9b,210014805}
function c210014805.costfilter(c)
	return c:IsDiscardable() and
		(c:IsCode(9113513,11493868,
		44256816,63804637) or
		aux.IsCodeListed(c,0x9b) or
		(c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9b)))
end
function c210014805.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210014805.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c210014805.costfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c210014805.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c210014805.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
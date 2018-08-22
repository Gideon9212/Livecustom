--created & coded by Lyris, art from "Celestial Rage"
--剣主のアドバンテージ
function c240100371.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,240100371+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c240100371.cost)
	e1:SetTarget(c240100371.target)
	e1:SetOperation(c240100371.activate)
	c:RegisterEffect(e1)
end
function c240100371.cfilter(c)
	return c:IsSetCard(0xbb2) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c240100371.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c240100371.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c240100371.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c240100371.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) and not Duel.IsPlayerCanDraw(tp,2) then return false end
		return Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c240100371.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER),Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) and 2 or 1
	Duel.Draw(p,d,REASON_EFFECT)
end

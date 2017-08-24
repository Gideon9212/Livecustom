--Elemelon Melobliteration
--AlphaKretin
function c515310013.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,515310013+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c515310013.condition)
	e1:SetTarget(c515310013.target)
	e1:SetOperation(c515310013.activate)
	c:RegisterEffect(e1)
end
function c515310013.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf31)
end
function c515310013.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c515310013.cfilter,tp,LOCATION_MZONE,0,nil)
	local rc=re:GetHandler()
	local boo=false
	for tc in aux.Next(g) do
		local cg=tc:GetColumnGroup()
		if cg:IsContains(rc) then boo=true end
	end
	return boo and Duel.IsChainNegatable(ev) and rp~=tp
end
function c515310013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c515310013.count(g)
	local att=0
	for tc in aux.Next(g) do
		if tc and tc:IsFaceup() then att=bit.bor(att,tc:GetAttribute()) end
	end
	local ct=0
	while att~=0 do
		if bit.band(att,0x1)~=0 then ct=ct+1 end
		att=bit.rshift(att,1)
	end
	return ct
end
function c515310013.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c515310013.cfilter,tp,LOCATION_MZONE,0,nil)
	g:KeepAlive()
	local ct=c515310013.count(g)
	if Duel.NegateActivation(ev) and Duel.SelectYesNo(tp,aux.Stringid(515310013,0)) and ct>0 then
		local tg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
		Duel.Destroy(tg,REASON_EFFECT)
	end
end

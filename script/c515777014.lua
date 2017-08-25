--Cloudian's Supression 
function c515777014.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Disables monster effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c515777014.targfilter)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--Negates targeting
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(515777014,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c515777014.discon)
	e3:SetCost(c515777014.discost)
	e3:SetTarget(c515777014.distg)
	e3:SetOperation(c515777014.disop)
	c:RegisterEffect(e3)
end

function c515777014.targfilter(e,c)
	return c:GetCounter(0x1019)>3
end
--Condition
function c515777014.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:GetCount()==1 and Duel.IsChainDisablable(ev)
end
--Cost
function c515777014.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1019,5,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1019,5,REASON_COST)
end

function c515777014.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c515777014.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if Duel.NegateEffect(ev) and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(515777014,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tg=g:Select(tp,1,1,nil)
		Duel.HintSelection(tg)
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
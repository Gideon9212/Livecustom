--Survivor - Jellyfish
function c515401005.initial_effect(c)
	--Damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(114932,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,515401005)
	e1:SetCondition(c515401005.condition)
	e1:SetTarget(c515401005.target)
	e1:SetOperation(c515401005.operation)
	c:RegisterEffect(e1)	
end
function c515401005.hsfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf18) and c:IsLevelAbove(6)
end
function c515401005.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c515401005.hsfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c515401005.filter(c)
	return c:IsSetCard(0xf18) and c:IsType(TYPE_MONSTER)
end
function c515401005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c515401005.filter,e:GetHandler():GetControler(),LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*100)
end
function c515401005.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c515401005.filter,e:GetHandler():GetControler(),LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	Duel.Damage(p,ct*100,REASON_EFFECT)
end


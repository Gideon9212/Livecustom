--Lunar Guardian's Blessing
function c515242570.initial_effect(c)
    c:EnableCounterPermit(0x99)
	c:SetCounterLimit(0x99,12)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4066,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,515242570)
	e1:SetOperation(c515242570.activate)
	c:RegisterEffect(e1)
    --add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c515242570.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_SZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c515242570.acop)
	c:RegisterEffect(e4)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x666))
	e5:SetValue(c515242570.atkval)
	c:RegisterEffect(e5)
	--Destroy replace
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetCategory(CATEGORY_COUNTER)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTarget(c515242570.desreptg)
	e6:SetOperation(c515242570.desrepop)
	c:RegisterEffect(e6)
end
--Activation code
function c515242570.thfilter(c)
	return c:IsSetCard(0x666) and c:IsLevelBelow(13) and c:IsAbleToHand()
end
function c515242570.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c515242570.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(4066,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c515242570.atkval(e,c)
	return e:GetHandler():GetCounter(0x99)*50
end
function c515242570.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_SPELL) and re:GetType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(0x666) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x99,1)
	end
end
function c515242570.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666) or c:IsSetCard(0x666) and c:IsType(TYPE_SPELL)
end
function c515242570.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c515242570.ctfilter,1,nil) then
		e:GetHandler():AddCounter(0x99,1)
	end
end
function c515242570.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():GetCounter(0x99)>=4 end
	return true
end
function c515242570.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x99,4,REASON_EFFECT)
end

--Moon's Clouds to Hide
function c210242573.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4066,2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,210242572)
	e1:SetOperation(c210242573.activate)
	c:RegisterEffect(e1)
	--Can't target scales
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetCondition(c210242573.tgcon)
	e2:SetTarget(c210242573.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
		--burn
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c210242573.burncon)
	e3:SetTarget(c210242573.burntg)
	e3:SetOperation(c210242573.burnop)
	c:RegisterEffect(e3)
	--Pend
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(210242573,1))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(c210242573.pendcon)
	e5:SetTarget(c210242573.pendtg)
	e5:SetOperation(c210242573.pendop)
	c:RegisterEffect(e5)
	--No Desu ne
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCondition(c210242573.desrepcon)
	e6:SetValue(1)
	c:RegisterEffect(e6)
end
function c210242573.codefilter(c)
	return c:IsSetCard(0x666) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
--Can't Target scales code
function c210242573.tgcon(e)
	local tp=e:GetHandler():GetControler()
	local g=Duel.GetMatchingGroup(c210242573.codefilter,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)>=0
end
function c210242573.tgtg(e,c)
    	return (c:IsSetCard(0x666)) and (c:GetSequence()==0 or c:GetSequence()==4)
end
--Activation code
function c210242573.thfilter(c)
	return c:IsSetCard(0x666) and c:GetLevel()==4 and c:IsAbleToHand()
end

function c210242573.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c210242573.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(4066,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
function c210242573.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
--burn
function c210242573.burncon(e,tp,eg,ep,ev,re,r,rp)
		local tc=eg:GetFirst()
	return ep~=tp and tc:IsControler(tp) and tc:IsSetCard(0x666)
end
function c210242573.burntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end
function c210242573.burnop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c210242573.pendfilter(c,tp)
	if bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM then
		return c:GetSummonPlayer()==tp and c:IsSetCard(0x666)
	else return end
end
function c210242573.pendcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c210242573.codefilter,tp,LOCATION_MZONE,0,nil)
	return eg:IsExists(c210242573.pendfilter,eg:GetCount(),nil,tp) and g:GetClassCount(Card.GetCode)>=5
end
function c210242573.pendtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and Card.IsAbleToDeck(chkc) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c210242573.pendop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c210242573.desrepcon(e)
	local tp=e:GetHandler():GetControler()
	local g=Duel.GetMatchingGroup(c210242573.codefilter,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)>=3
end

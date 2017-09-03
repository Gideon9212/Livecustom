--Moon's Clouds to Hide
function c515242573.initial_effect(c)

--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4066,2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,515242572)
	e1:SetOperation(c515242573.activate)
	c:RegisterEffect(e1)
--Can't target scales
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetCondition(c515242573.tgcon)
	e2:SetTarget(c515242573.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
--SP battle protection
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c515242573.standcon)
	e3:SetTarget(c515242573.standtg)
	e3:SetCountLimit(1)
	e3:SetOperation(c515242573.standop)
	c:RegisterEffect(e3)
--Shuffle
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCost(c515242573.shfcost)
	e4:SetTarget(c515242573.shftg)
	e4:SetCountLimit(1)
	e4:SetOperation(c515242573.shfop)
	c:RegisterEffect(e4)
--Pend
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(515242573,1))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(c515242573.pendcon)
	e5:SetTarget(c515242573.pendtg)
	e5:SetOperation(c515242573.pendop)
	c:RegisterEffect(e5)
--No Desu
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCondition(c515242573.desrepcon)
	e6:SetValue(1)
	c:RegisterEffect(e6)
end
function c515242573.codefilter(c)
	return c:IsSetCard(0x666) and c:IsFaceup()
end

--Can't Target scales code
function c515242573.tgcon(e)
	local tp=e:GetHandler():GetControler()
	local g=Duel.GetMatchingGroup(c515242573.codefilter,tp,LOCATION_EXTRA,0,nil)
	return g:GetClassCount(Card.GetCode)>=1
end
function c515242573.tgtg(e,c)
    return (c:IsSetCard(0x666))
        and (c:GetSequence()==0 or c:GetSequence()==4)
end
--Activation code
function c515242573.thfilter(c)
	return c:IsSetCard(0x666) and c:IsLevelBelow(4) and c:IsAbleToHand()
end

function c515242573.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c515242573.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(4066,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetFirst():GetCode()==515242564 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.Recover(tp,500,REASON_EFFECT)
		else
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end


function c515242573.standcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c515242573.codefilter,tp,LOCATION_EXTRA,0,nil)
	return g:GetClassCount(Card.GetCode)>=2
end
function c515242573.standfilter(c)
	return c:IsSetCard(0x666) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c515242573.standtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c515242573.standfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c515242573.standfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c515242573.standop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(c515242573.valcon)
		tc:RegisterEffect(e1)
	end
end
function c515242573.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end

function c515242573.shfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c515242573.codefilter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=3 end
end
function c515242573.shffilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x666) and c:IsFaceup() and c:IsAbleToDeck()
end
function c515242573.shftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,nil)
		and Duel.IsExistingMatchingCard(c515242573.shffilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c515242573.shfop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c515242573.shffilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,99,nil)
	local ct=sg:GetCount()
	if not (Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)>0) then return end
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	if Duel.Draw(tp,ct,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetValue(0)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
	end
end

function c515242573.pendfilter(c,tp)
	if bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM then
		return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA) and c:IsSetCard(0x666)
	else return end
end
function c515242573.pendcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c515242573.codefilter,tp,LOCATION_EXTRA,0,nil)
	return eg:IsExists(c515242573.pendfilter,eg:GetCount(),nil,tp) and g:GetClassCount(Card.GetCode)>=4
end
function c515242573.pendtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and Card.IsAbleToDeck(chkc) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c515242573.pendop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end

function c515242573.desrepcon(e)
	local tp=e:GetHandler():GetControler()
	local g=Duel.GetMatchingGroup(c515242573.codefilter,tp,LOCATION_EXTRA,0,nil)
	return g:GetClassCount(Card.GetCode)>=5
end

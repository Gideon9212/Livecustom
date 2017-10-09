--プレデター・ガーデン
--Predapatio
--Created and scripted by Eerie Code
function c210220075.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--stats down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c210220075.atktg)
	e2:SetValue(c210220075.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,210220075)
	e4:SetCost(c210220075.thcost)
	e4:SetTarget(c210220075.thtg)
	e4:SetOperation(c210220075.thop)
	c:RegisterEffect(e4)
	--counter
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,210220075+1000)
	e5:SetCondition(c210220075.ctcon)
	e5:SetTarget(c210220075.cttg)
	e5:SetOperation(c210220075.ctop)
	c:RegisterEffect(e5)
end
function c210220075.atktg(e,c)
	return c:GetCounter(0x1041)>0
end
function c210220075.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x1041)*200
end
function c210220075.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1041,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1041,2,REASON_COST)
end
function c210220075.thfilter(c)
	return c:IsSetCard(0xf3) and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and not c:IsCode(210220075) and c:IsAbleToHand()
end
function c210220075.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210220075.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c210220075.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c210220075.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c210220075.ctcfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x10f3) and c:IsControler(tp)
end
function c210220075.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(c210220075.ctcfilter,nil,tp)==1
end
function c210220075.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,nil,0x1041,1) end
end
function c210220075.ctop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ec=eg:Filter(c210220075.ctcfilter,nil,tp):GetFirst()
	local ct=1
	if ec and ec:IsPreviousLocation(LOCATION_GRAVE) then
		ct=2
	end
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,1,nil,0x1041,1):GetFirst()
		if tc:AddCounter(0x1041,1) and tc:GetLevel()>1 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetCondition(c210220075.lvcon)
			e1:SetValue(1)
			tc:RegisterEffect(e1)
		end
	end
end
function c210220075.lvcon(e)
	return e:GetHandler():GetCounter(0x1041)>0
end

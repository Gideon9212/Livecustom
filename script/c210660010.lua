--Wicked Altar
--concept by Gideon
--scripted by Larry126
function c210660010.initial_effect(c)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(210660010)
	e0:SetValue(SUMMON_TYPE_NORMAL)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c210660010.reg)
	e1:SetCondition(c210660010.accon)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80921533,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c210660010.target)
	e2:SetOperation(c210660010.operation)
	e2:SetLabelObject(e0)
	c:RegisterEffect(e2)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1315120,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c210660010.thcon)
	e2:SetCost(c210660010.thcost)
	e2:SetTarget(c210660010.thtg)
	e2:SetOperation(c210660010.thop)
	c:RegisterEffect(e2)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
end
function c210660010.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(210660010,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c210660010.accon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c210660010.filter(c,se)
	if not c:IsSummonableCard() or not c:IsRace(RACE_FIEND) then return false end
	local mi,ma=c:GetTributeRequirement()
	return mi>0 and (c:IsSummonable(false,se) or c:IsMSetable(false,se))
end
function c210660010.get_targets(se,tp)
	local g=Duel.GetMatchingGroup(c210660010.filter,tp,LOCATION_HAND,0,nil,se)
	local minct=5
	local maxct=0
	local tc=g:GetFirst()
	while tc do
		local mi,ma=tc:GetTributeRequirement()
		if mi>0 and mi<minct then minct=mi end
		if ma>maxct then maxct=ma end
		tc=g:GetNext()
	end
	return minct,maxct
end
function c210660010.cfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c210660010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local se=e:GetLabelObject()
	if chk==0 then
		local mi,ma=c210660010.get_targets(se,tp)
		if mi==5 then return false end
		return Duel.IsExistingMatchingCard(c210660010.cfilter,tp,LOCATION_EXTRA,0,mi,nil)
	end
	local mi,ma=c210660010.get_targets(se,tp)
	local rg=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if mi==ma then rg=Duel.SelectMatchingCard(tp,c210660010.cfilter,tp,LOCATION_EXTRA,0,mi,mi,nil)
	elseif ma>=3 and Duel.IsExistingMatchingCard(c210660010.cfilter,tp,LOCATION_EXTRA,0,3,nil) then
		rg=Duel.SelectMatchingCard(tp,c210660010.cfilter,tp,LOCATION_EXTRA,0,1,3,nil)
	else rg=Duel.SelectMatchingCard(tp,c210660010.cfilter,tp,LOCATION_EXTRA,0,1,1,nil) end
	local rc=Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
	e:SetLabel(rc)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c210660010.sfilter(c,se,ct)
	if not c:IsSummonableCard() then return false end
	local mi,ma=c:GetTributeRequirement()
	return (mi==ct or ma==ct) and (c:IsSummonable(false,se) or c:IsMSetable(false,se))
end
function c210660010.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ct=e:GetLabel()
	local se=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c210660010.sfilter,tp,LOCATION_HAND,0,1,1,nil,se,ct)
	local tc=g:GetFirst()
	if tc then
		local s1=tc:IsSummonable(false,se)
		local s2=tc:IsMSetable(false,se)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,false,se)
		else
			Duel.MSet(tp,tc,false,se)
		end
	end
end
function c210660010.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
		and e:GetHandler():GetFlagEffect(210660010)==0
end
function c210660010.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c210660010.thfilter(c)
	return ((c:IsSetCard(0xf66) and c:IsType(TYPE_MONSTER)) or c:IsCode(21208154,57793869,62180201)) and c:IsAbleToHand()
end
function c210660010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210660010.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c210660010.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c210660010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		g:GetFirst():RegisterEffect(e1)
	end
end
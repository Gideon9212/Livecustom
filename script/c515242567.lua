--Blue Striker Beast: Tiny Pony Moon Burst
function c515242567.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c515242567.efilter)
	e1:SetValue(300)
	c:RegisterEffect(e1)
	--Def 
	local e2=e1:Clone()
 	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--Pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PIERCE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(c515242567.target)
	c:RegisterEffect(e3)
	--battle dam 0
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(515242564,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1,515242564)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c515242567.spcon)
	e5:SetTarget(c515242567.sptg)
	e5:SetOperation(c515242567.spop)
	c:RegisterEffect(e5)
	--death into scale
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(515242564,3))
	e6:SetCountLimit(1,515242565)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c515242567.pencon)
	e6:SetTarget(c515242567.pentg)
	e6:SetOperation(c515242567.penop)
	c:RegisterEffect(e6)
    --S/T Search
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,515242566)
	e7:SetCost(c515242567.cost)
	e7:SetTarget(c515242567.tribute)
	e7:SetOperation(c515242567.activate)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_TOGRAVE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_BATTLE_DESTROYED)
	e8:SetRange(LOCATION_PZONE)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCountLimit(1,515242564)
	e8:SetCondition(c515242567.spcon2)
	e8:SetTarget(c515242567.sptg2)
	e8:SetOperation(c515242567.spop2)
	c:RegisterEffect(e8)

end
function c515242567.cfilter3(c,tp)
	return c:IsSetCard(0x666) and c:GetPreviousControler()==tp
end
function c515242567.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c515242567.cfilter3,1,nil,tp)
end
function c515242567.filter4(c)
	 return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER)
		
end
function c515242567.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.NecroValleyFilter(c515242567.filter4),tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(c515242567.filter4),tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_HINTMSG_TOGRAVE,g,1,0,0)
end
function c515242567.spop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end






function c515242567.cfilter2(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and c:IsSetCard(0x666) and c:GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c515242567.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c515242567.cfilter2,1,nil,tp)
end
function c515242567.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_HINTMSG_REMOVE,g,1,0,0)
end
function c515242567.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.Remove(tc,nil,2,REASON_EFFECT)
	end
end


function c515242567.cfilter(c)
	 return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and c:IsFaceup() 
		
end
function c515242567.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c515242567.cfilter,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,c515242567.cfilter,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end

function c515242567.tribute(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c515242567.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c515242567.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c515242567.filter),tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end








function c515242567.target(e,c)
	return c:IsSetCard(0x666) 
end
function c515242567.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c515242567.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c515242567.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c515242567.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c515242567.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end




function c515242567.efilter(e,c)
 return c:IsSetCard(0x666)
end
function c515242567.condition(e,tp,eg,ep,ev,re,r,rp)
 return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c515242567.target2(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end




function c515242567.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c515242567.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c515242567.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end



function c515242567.filter(c)
	 return c:IsSetCard(0x666) and c:IsType(TYPE_SPELL+TYPE_TRAP)
		
end



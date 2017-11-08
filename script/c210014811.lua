--Straussa the Melodious Maestra
function c210014811.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_LIGHT),1,1,aux.NonTuner(Card.IsSetCard,0x9b),1,99)
	c:EnableReviveLimit()
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c210014811.aclimit)
	e1:SetCondition(c210014811.actcon)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c210014811.actcon)
	e2:SetOperation(c210014811.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e3)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(45014450,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,2100148110)
	e4:SetCondition(c210014811.pencon)
	e4:SetTarget(c210014811.pentg)
	e4:SetOperation(c210014811.penop)
	c:RegisterEffect(e4)
	--Special Summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(90036274,0))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1,210014811)
	e5:SetTarget(c210014811.thtg)
	e5:SetOperation(c210014811.thop)
	c:RegisterEffect(e5)
end
c210014811.listed_names={0x9b,210014811}
function c210014811.thfilter(c)
	return c:IsSetCard(0x9b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c210014811.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c210014811.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,tp,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c210014811.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c210014811.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
----------------------------------------------------
function c210014811.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c210014811.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NOT(Card.IsForbidden),tp,LOCATION_PZONE,0,1,nil) end
end
function c210014811.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINT_CARD)
	local g=Duel.SelectMatchingCard(tp,aux.NOT(Card.IsForbidden),tp,LOCATION_PZONE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoExtraP(g,tp,REASON_EFFECT)>0 then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
---------------------------------------------------
function c210014811.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c210014811.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x9b) and c:IsControler(tp)
end
function c210014811.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and c210014811.cfilter(a,tp)) or (d and c210014811.cfilter(d,tp))
end
function c210014811.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	if not tc then return end
	local ac=Duel.GetAttacker()
	if tc:IsControler(tp) then 
		ac=tc
		tc=Duel.GetAttacker()
	end
	if not ac:IsSetCard(0x9b) then return end
	ac:CreateRelation(tc,RESET_EVENT+0x1fe0000)
	local e1=Effect.CreateEffect(ac)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetCondition(c210014811.discon2)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(ac)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetCondition(c210014811.discon2)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e2)
end
function c210014811.discon2(e)
	return e:GetOwner():IsRelateToCard(e:GetHandler())
end
--Odd-Eyes Illusory Magician
local ScaleLocation,leftScale,rightScale=LOCATION_SZONE,6,7
if Duel.GetMasterRule and Duel.GetMasterRule()>=4 
then ScaleLocation,leftScale,rightScale=LOCATION_PZONE,0,1 
end
function c515958933.initial_effect(c)
	--pendulum treat
	aux.EnablePendulumAttribute(c)
	--Treat
	if not c515958933.global_check then
        c515958933.global_check=true
        local e0=Effect.GlobalEffect()
        e0:SetType(EFFECT_TYPE_FIELD)
        e0:SetCode(EFFECT_ADD_CODE)
        e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e0:SetTarget(function(e,c) return getmetatable(c)==c515958933 end)
        e0:SetTargetRange(0xff,0xff)
        e0:SetValue(82044279)
        Duel.RegisterEffect(e0,0)
    end
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c515958933.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--Level Up/Down by 1
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(1995)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c515958933.lvtg)
	e5:SetOperation(c515958933.lvop)
	c:RegisterEffect(e5)
	--tuner
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(1062)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1)
	e6:SetTarget(c515958933.tntg)
	e6:SetOperation(c515958933.tnop)
	c:RegisterEffect(e6)
	--return 1 pendulum back
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(505)
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCountLimit(1,515958933)
	e7:SetTarget(c515958933.target)
	e7:SetOperation(c515958933.activate)
	c:RegisterEffect(e7)
end	
--Set to scale when destroyed
function c515958933.pensetcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c515958933.pensettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,ScaleLocation,leftScale) or Duel.CheckLocation(tp,ScaleLocation,rightScale) end
end
function c515958933.pensetop(e,tp,eg,ep,ev,re,r,rp) 
	if not Duel.CheckLocation(tp,ScaleLocation,leftScale) and not Duel.CheckLocation(tp,ScaleLocation,rightScale) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,ScaleLocation,POS_FACEUP,true)
	end
end
--Atk/Def up
function c515958933.atkval(e,c,tp) 
	local tp=c:GetControler()
	local loc=LOCATION_SZONE
    local l,r=6,7
	if Duel.GetMasterRule and Duel.GetMasterRule()>=4 then loc,l,r=LOCATION_PZONE,0,1 end
    local psL=Duel.GetFieldCard(tp,loc,l)
    local psR=Duel.GetFieldCard(tp,loc,r)
    if psL then psL=psL:GetLeftScale(psL) else psL=0 end
    if psR then psR=psR:GetLeftScale(psR) else psR=0 end
    return (psL+psR)*150
end
--Level Up/Down by 1
function c515958933.lvfilter(c)
    return c:IsFaceup()        
end
function c515958933.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,550)
	local g=Duel.SelectTarget(tp,c515958933.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_,g,g:GetCount(),0,0)
	local op=Duel.SelectOption(tp,aux.Stringid(25484449,2),aux.Stringid(25484449,3))
	e:SetLabel(op)
	
end
function c515958933.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and  tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else
			e1:SetValue(-1)
		end
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
--Tuner treat
function c515958933.tnfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER)
end
function c515958933.tntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c515958933.tnfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c515958933.tnfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c515958933.tnfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c515958933.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(2)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
--return 1 pendulum back
function c515958933.tgfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c515958933.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD) and chkc:IsControler(tp) and c515958933.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c515958933.tgfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c515958933.tgfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c515958933.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
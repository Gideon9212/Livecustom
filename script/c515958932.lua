--Odd-Eyes Slayer Magician
function c515958932.initial_effect(c)
	--pendulum treat
	aux.EnablePendulumAttribute(c)
	--Treat
	if not c515958932.global_check then
        c515958932.global_check=true
        local e0=Effect.GlobalEffect()
        e0:SetType(EFFECT_TYPE_FIELD)
        e0:SetCode(EFFECT_ADD_CODE)
        e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e0:SetTarget(function(e,c) return getmetatable(c)==c515958932 end)
        e0:SetTargetRange(0xff,0xff)
        e0:SetValue(16178681)
        Duel.RegisterEffect(e0,0)
    end
	--Pendulum summon from faceup extra deck ignoring conditions
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c515958932.sumop)
	c:RegisterEffect(e3)
	--Unnafected
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c515958932.unval)
	c:RegisterEffect(e4)
	--Return itself +2
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c515958932.penconn2)
	e5:SetTarget(c515958932.pentgg2)
	e5:SetOperation(c515958932.penopp2)
	c:RegisterEffect(e5)
	
end	
--Return to Hand(switch)
function c515958932.penconn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c515958932.penf1,tp,LOCATION_ONFIELD,0,1,nil)
end
function c515958932.penff1(c)
	return c:IsOnField()
end
function c515958932.pensettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c515958932.pentgg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local self=e:GetHandler():GetFieldID()
	if chk==0 then return Duel.IsExistingTarget(c515958932.penff2,tp,LOCATION_HAND,0,1,nil,self) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,c515958932.penff1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c515958932.penopp(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
	local c=e:GetHandler()
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return Duel.SendtoGrave(c,tp,REASON_EFFECT) end
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
--Negate extra deck Pendulum summons
function c515958932.pensumfilter(c,e,tp)
	return c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:GetSummonLocation()==LOCATION_EXTRA and (not e or c:IsRelateToEffect(e)) 
end
function c515958932.pensumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c515958932.pensumfilter,1,nil,nil,tp)
end
function c515958932.pensumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetCard(eg)
end
function c515958932.pensumop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c515958932.pensumfilter,nil,e,tp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
--Additional Pendulum summon from faceup extra deck ignoring conditions type 
function c515958932.penfilter(c,e,tp,lscale,rscale)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return ((c:IsLocation(LOCATION_HAND)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,true,false))
        or (c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,true,true)))--- 
        and lv>lscale and lv<rscale
        and not c:IsForbidden()  
end
function c515958932.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,515958932)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c515958932.regop)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,515958932,RESET_PHASE+PHASE_END,0,1)
end
function c515958932.regop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	if tc and tc:GetFlagEffect(29432357)==0 then
		tc:RegisterFlagEffect(29432357,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(65)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC_G)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetRange(LOCATION_PZONE)
		e1:SetCountLimit(1)
		e1:SetLabelObject(e)
		e1:SetCondition(c515958932.sumpencon)
		e1:SetOperation(c515958932.sumpenop)
		e1:SetValue(SUMMON_TYPE_PENDULUM)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
	end
end
function c515958932.sumpencon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	if c:GetSequence()~=6 then return false end
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if rpz==nil then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	if og then
		return og:IsExists(c515958932.penfilter,1,nil,e,tp,lscale,rscale)
	else
		return Duel.IsExistingMatchingCard(c515958932.penfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale)
	end
end
function c515958932.sumpenop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local tg=nil
	if og then
		tg=og:Filter(tp,c515958932.penfilter,nil,e,tp,lscale,rscale)
	else
		tg=Duel.GetMatchingGroup(c515958932.penfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp,lscale,rscale)
	end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and (ect<=0 or ect>ft) then ect=nil end
	if ect==nil or tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=ect then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=tg:Select(tp,1,ft,nil)
		sg:Merge(g)
	else
		repeat
			local ct=math.min(ft,ect)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=tg:Select(tp,1,ct,nil)
			tg:Sub(g)
			sg:Merge(g)
			ft=ft-g:GetCount()
			ect=ect-g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
		until ft==0 or ect==0 or not Duel.SelectYesNo(tp,210)
		local hg=tg:Filter(Card.IsLocation,nil,LOCATION_HAND)
		if ft>0 and ect==0 and hg:GetCount()>0 and Duel.SelectYesNo(tp,210) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=hg:Select(tp,1,ft,nil)
			sg:Merge(g)
		end
	end
	Duel.HintSelection(Group.FromCards(c))
	Duel.HintSelection(Group.FromCards(rpz))
	local se=e:GetLabelObject()
	se:Reset()
	e:Reset()
	--Negate extra deck pen summons
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCondition(c515958932.pensumcon)
	e1:SetTarget(c515958932.pensumtg)
	e1:SetOperation(c515958932.pensumop)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
--Unaffected
function c515958932.unval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--Mon zone desdroy
function c515958932.penconn2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c515958932.penf22,tp,LOCATION_ONFIELD,0,2,nil)
end
function c515958932.penff12(c,self)
   if c:GetFieldID()~=self then return c:IsOnField() end
   return false
end
function c515958932.penff22(c,self)
    return c:GetFieldID()==self
end
function c515958932.penff23(c)
    return c:IsOnField()
end
function c515958932.pentgg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local self=e:GetHandler():GetFieldID()
	if chk==0 then return Duel.IsExistingTarget(c515958932.penff22,tp,LOCATION_MZONE,0,1,nil,self) 
	and Duel.IsExistingTarget(c515958932.penff23,tp,LOCATION_ONFIELD,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,c515958932.penff22,tp,LOCATION_MZONE,0,1,1,nil,self)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,c515958932.penff12,tp,LOCATION_ONFIELD,0,2,2,nil,self)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c515958932.penopp2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
end
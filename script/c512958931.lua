--Odd-Eyes Blood Magician
function c512958931.initial_effect(c)
	--pendulum treat
	aux.EnablePendulumAttribute(c)
	--Treat
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetRange(0xff)
	e0:SetValue(41209827)
	c:RegisterEffect(e0)
	--Destruction hand and scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1124)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c512958931.penconn)
	e1:SetTarget(c512958931.pentgg)
	e1:SetOperation(c512958931.penopp)
	c:RegisterEffect(e1)
	--Set to scale when destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1160)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c512958931.pensetcon)
	e2:SetTarget(c512958931.pensettg)
	e2:SetOperation(c512958931.pensetop)
	c:RegisterEffect(e2)	
	--Disable extra deck
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c512958931.pensumcon)
	e4:SetTarget(c512958931.pensumtg)
	e4:SetOperation(c512958931.pensumop)
	c:RegisterEffect(e4)
	--atkup 2xDEF
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_SET_ATTACK_FINAL)
	e5:SetCondition(c512958931.atkcon)
	e5:SetValue(c512958931.atkval)
	c:RegisterEffect(e5)
	--Fusion
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(1056)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c512958931.target)
	e6:SetOperation(c512958931.activate)
	c:RegisterEffect(e6)
	--destroy scale & search
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(1124)
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_PZONE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1,512958931)
	e7:SetTarget(c512958931.destg)
	e7:SetOperation(c512958931.desop)
	c:RegisterEffect(e7)
end	
--destroy scale & search
function c512958931.desfilter(c)
	if Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7) then
	return c:IsType(TYPE_PENDULUM) end
end
function c512958931.thfilter(c)
	return c:IsSetCard(0x99) and c:IsAbleToHand()
end
function c512958931.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c512958931.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c512958931.desfilter,tp,LOCATION_SZONE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c512958931.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c512958931.desfilter,tp,LOCATION_SZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c512958931.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c512958931.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
	
--Destruction hand and scale
function c512958931.penconn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c512958931.penf1,tp,LOCATION_ONFIELD,0,1,nil)
end
function c512958931.penff1(c)
	return c:IsOnField()
end
function c512958931.penff2(c)
    if c:IsCode(c,512958931) then 
    return c end
end
function c512958931.pentgg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c512958931.penff2,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c512958931.penff2,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c512958931.penff1,tp,LOCATION_ONFIELD,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c512958931.penopp(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--Set to scale when destroyed
function c512958931.pensetcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c512958931.pensettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c512958931.pensetop(e,tp,eg,ep,ev,re,r,rp) 
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
--Special summons
function c512958931.filter(c,e,tp)
	if Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7) then 
		psL=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
		psR=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
		psL=psL:GetLeftScale(psL)
		psR=psR:GetRightScale(psR)
		lv=c:GetLevel()
		if psL>psR then psL,psR=psR,psL end
		if lv>psL and lv<psR then 	
		return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,true,false) end
	end
	--Debug.Message((psL:GetLeftScale(psL)+psR:GetRightScale(psR))/2)
	return false
end
function c512958931.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
 		and Duel.IsExistingMatchingCard(c512958931.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c512958931.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c512958931.filter,tp,LOCATION_EXTRA,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,SUMMON_TYPE_PENDULUM,tp,tp,true,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
		Duel.Damage(tp,ct,REASON_EFFECT)
	end
end
--Negate extra deck summons
function c512958931.pensumfilter(c,e,tp)
	return c:IsControler(tp) and c:GetSummonLocation()==LOCATION_EXTRA and (not e or c:IsRelateToEffect(e)) 
end
function c512958931.pensumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c512958931.pensumfilter,1,nil,nil,1-tp)
end
function c512958931.pensumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetCard(eg)
end
function c512958931.pensumop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c512958931.pensumfilter,nil,e,tp)
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
--atkup 2xDEF
function c512958931.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local bc=e:GetHandler():GetBattleTarget()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and bc
end
function c512958931.atkval(e,c)
	return e:GetHandler():GetDefense()*2
end
--Fusion
function c512958931.filter0(c,e)
	return (c:IsOnField() or c:IsLocation(LOCATION_HAND)) and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c512958931.filter1(c,e)
	return (c:IsOnField() or c:IsLocation(LOCATION_HAND)) and not c:IsImmuneToEffect(e)
end
function c512958931.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c512958931.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		if Duel.GetFieldCard(tp,LOCATION_SZONE,6) or Duel.GetFieldCard(tp,LOCATION_SZONE,7) then
			mg1:Merge(Duel.GetMatchingGroup(c512958931.filter0,tp,LOCATION_SZONE+LOCATION_HAND,0,nil,e))
		end
		local res=Duel.IsExistingMatchingCard(c512958931.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c512958931.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c512958931.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c512958931.filter1,nil,e)
	if Duel.GetFieldCard(tp,LOCATION_SZONE,6) or Duel.GetFieldCard(tp,LOCATION_SZONE,7) then
		mg1:Merge(Duel.GetMatchingGroup(c512958931.filter0,tp,LOCATION_SZONE+LOCATION_HAND,0,nil,e))
	end
	local sg1=Duel.GetMatchingGroup(c512958931.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c512958931.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
--Odd-Eyes Blood Magician
local ScaleLocation,leftScale,rightScale=LOCATION_PZONE,0,1 --ScaleLocation,leftScale,rightScale=LOCATION_SZONE,6,7
function c515958931.initial_effect(c)

	--pendulum treat
	aux.EnablePendulumAttribute(c)
	--Treat
	if not c515958931.global_check then
        c515958931.global_check=true
        local e0=Effect.GlobalEffect()
        e0:SetType(EFFECT_TYPE_FIELD)
        e0:SetCode(EFFECT_ADD_CODE)
        e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e0:SetTarget(function(e,c) return getmetatable(c)==c515958931 end)
        e0:SetTargetRange(0xff,0xff)
        e0:SetValue(41209827)
        Duel.RegisterEffect(e0,0)
    end
	--Copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43387895,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	e3:SetCountLimit(1)
	e3:SetCondition(c515958931.copycond)
	e3:SetTarget(c515958931.copytg)
	e3:SetOperation(c515958931.copyop)
	c:RegisterEffect(e3)
	--atkup 2xDEF
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_SET_ATTACK_FINAL)
	e5:SetCondition(c515958931.atkcon)
	e5:SetValue(c515958931.atkval)
	c:RegisterEffect(e5)
	--Fusion
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(1056)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1)
	if Duel.GetMasterRule and Duel.GetMasterRule()>=4 then
		e6:SetTarget(c515958931.target)
		e6:SetOperation(c515958931.activate)
	else
		e6:SetTarget(c515958931.target2)
		e6:SetOperation(c515958931.activate2)
	end
	c:RegisterEffect(e6)
	--destroy scale & search
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(1124)
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_PZONE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1,515958931)
	e7:SetTarget(c515958931.destg)
	e7:SetOperation(c515958931.desop)
	c:RegisterEffect(e7)
end	
--destroy scale & search
function c515958931.desfilter(c,lsc,rsc)
	if Duel.GetMasterRule and Duel.GetMasterRule()<4 then
		return c:IsType(TYPE_PENDULUM) and (c:GetCode()==lsc:GetCode() or c:GetCode()==rsc:GetCode())
	else
		return c:IsType(TYPE_PENDULUM)
	end
end
function c515958931.thfilter(c)
	return c:IsSetCard(0x99) and c:IsAbleToHand()
end
function c515958931.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if Duel.GetMasterRule and Duel.GetMasterRule()<4 then
		local lsc=Duel.GetFieldCard(tp,ScaleLocation,leftScale)
		local rsc=Duel.GetFieldCard(tp,ScaleLocation,rightScale)
		local f=Group.FromCards(lsc,rsc):Filter(aux.TRUE,nil)
		if f:GetCount()==2 then
			if chkc then 
				return chkc:IsOnField()	and chkc:IsControler(tp) and c515958931.desfilter(chkc) and chkc~=e:GetHandler()  
			end
			if chk==0 then 
				return Duel.IsExistingTarget(c515958931.desfilter,tp,ScaleLocation,0,1,e:GetHandler(),lsc,rsc) 
				and Duel.IsExistingMatchingCard(c515958931.thfilter,tp,LOCATION_DECK,0,1,nil) 
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectTarget(tp,c515958931.desfilter,tp,ScaleLocation,0,1,1,e:GetHandler(),lsc,rsc)
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
		end
	else
		if chkc then 
			return chkc:IsOnField()	and chkc:IsControler(tp) and c515958931.desfilter(chkc) and chkc~=e:GetHandler()  
		end
		if chk==0 then 
			return Duel.IsExistingTarget(c515958931.desfilter,tp,ScaleLocation,0,1,e:GetHandler()) 
			and Duel.IsExistingMatchingCard(c515958931.thfilter,tp,LOCATION_DECK,0,1,nil) 
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,c515958931.desfilter,tp,ScaleLocation,0,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
	end
end
function c515958931.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c515958931.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
--copy
function c515958931.copycond(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetTurnPlayer()~=tp 
end
function c515958931.copyfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TOKEN) and c:IsFaceup()
end
function c515958931.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c515958931.copyfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c515958931.copyfilter,tp,0,LOCATION_MZONE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c515958931.copyfilter,tp,0,LOCATION_MZONE,1,1,c)
end
function c515958931.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local code=tc:GetOriginalCodeRule()
		if not tc:IsType(TYPE_TRAPMONSTER) then
			local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		end
	end
	local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(43387895,0))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetCountLimit(1)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetLabel(cid)
			e1:SetCondition(c515958931.copycond2)
			e1:SetOperation(c515958931.rstop)
			c:RegisterEffect(e1)
end
function c515958931.copycond2(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetTurnPlayer()==tp 
end
function c515958931.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
--atkup 2xDEF
function c515958931.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local bc=e:GetHandler():GetBattleTarget()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and bc
end
function c515958931.atkval(e,c)
	return e:GetHandler():GetDefense()*2
end
--Fusion 
function c515958931.filter0(c,e)
	return (c:IsOnField() or c:IsLocation(LOCATION_HAND)) 
	and c:IsCanBeFusionMaterial() 
	and not c:IsImmuneToEffect(e) 
	and (c:IsSetCard(0x99) or c:IsSetCard(0x98) or c:IsSetCard(0xf8) or c:IsSetCard(0x9f)) 
end
function c515958931.filter1(c,e)
	return (c:IsOnField() or c:IsLocation(LOCATION_HAND)) and (c:IsSetCard(0x99) or c:IsSetCard(0x98) or c:IsSetCard(0xf8) or c:IsSetCard(0x9f)) 
end
function c515958931.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) 
	and (not f or f(c)) 
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) 
	and c:CheckFusionMaterial(m,nil,chkf)
end
---Fusion mr3
function c515958931.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		if Duel.GetFieldCard(tp,ScaleLocation,leftScale) or Duel.GetFieldCard(tp,ScaleLocation,rightScale) then
			mg1:Merge(Duel.GetMatchingGroup(c515958931.filter0,tp,ScaleLocation+LOCATION_HAND,0,nil,e))
		end
		local res=Duel.IsExistingMatchingCard(c515958931.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c515958931.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c515958931.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c515958931.filter1,nil,e)
	if Duel.GetFieldCard(tp,ScaleLocation,leftScale) or Duel.GetFieldCard(tp,ScaleLocation,rightScale) then
		mg1:Merge(Duel.GetMatchingGroup(c515958931.filter0,tp,ScaleLocation+LOCATION_HAND,0,nil,e))
	end
	local sg1=Duel.GetMatchingGroup(c515958931.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c515958931.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
---Fusion mr4
function c515958931.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		if Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>=1 then
			mg1:Merge(Duel.GetMatchingGroup(c515958931.filter0,tp,LOCATION_PZONE+LOCATION_HAND,0,nil,e))
		end
		local res=Duel.IsExistingMatchingCard(c515958931.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c515958931.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c515958931.activate2(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c515958931.filter1,nil,e)
	if Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>=1 then
		mg1:Merge(Duel.GetMatchingGroup(c515958931.filter0,tp,LOCATION_PZONE+LOCATION_HAND,0,nil,e))
	end
	local sg1=Duel.GetMatchingGroup(c515958931.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c515958931.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
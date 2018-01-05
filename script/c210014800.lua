--Melodious Fusion
--designed and scripted by Larry126
function c210014800.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,210014800)
	e1:SetTarget(c210014800.target)
	e1:SetOperation(c210014800.activate)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(1264319,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,2100148000)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c210014800.thcost)
	e2:SetTarget(c210014800.thtg)
	e2:SetOperation(c210014800.thop)
	c:RegisterEffect(e2)
	if not AshBlossomTable then AshBlossomTable={} end
	table.insert(AshBlossomTable,e1)
end
c210014800.listed_names={0x9b,0x109b}
function c210014800.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c210014800.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c210014800.filter2(c,e,tp,m,f,chkf,agc)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x9b) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,agc,chkf)
end
function c210014800.agfilter(c,e,tp,m,m2,f,chkf)
	if c:IsFacedown() or not c:IsSetCard(0x109b) or not m:IsContains(c) then return false end
	local g=m:Clone()
	g:Merge(m2)
	g:RemoveCard(c)
	return Duel.IsExistingMatchingCard(c210014800.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,g,f,chkf,c)
end
function c210014800.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c210014800.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf,nil)
		if res then return true end
		local mg2=Duel.GetMatchingGroup(c210014800.filter0,tp,LOCATION_DECK,0,nil)
		res=Duel.IsExistingMatchingCard(c210014800.agfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,mg,mg2,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c210014800.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf,nil)
			end
		end
		return res
	end
end
function c210014800.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c210014800.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c210014800.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf,nil)
	local mg2=Duel.GetMatchingGroup(c210014800.filter0,tp,LOCATION_DECK,0,nil)
	local sg2=Duel.GetMatchingGroup(c210014800.agfilter,tp,LOCATION_MZONE,0,nil,e,tp,mg1,mg2,nil,chkf)
	local mg3=nil
	local sg3=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg3=Duel.GetMatchingGroup(c210014800.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg2:GetCount()>0 and (sg1:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(31444249,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local agc=sg2:Select(tp,1,1,nil):GetFirst()
		mg1:Merge(mg2)
		mg1:RemoveCard(agc)
		local sg0=Duel.GetMatchingGroup(c210014800.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf,agc)
		local sg=sg0:Clone()
		if sg3 then sg:Merge(sg3) end
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg0:IsContains(tc) and (sg3==nil or not sg3:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,agc,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,agc,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	else
		local sg=sg1:Clone()
		if sg3 then sg:Merge(sg3) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg3==nil or not sg3:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c210014800.thfilter(c)
	return c:IsSetCard(0x9b) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c210014800.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210014800.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c210014800.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c210014800.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c210014800.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
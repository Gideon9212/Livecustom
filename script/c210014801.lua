--Haydn the Melodious Maestra
--designed and scripted by Larry126
function c210014801.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c210014801.splimit)
	c:RegisterEffect(e1)
	--fusion
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c210014801.sptg)
	e2:SetOperation(c210014801.spop)
	c:RegisterEffect(e2)
	--add
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(41546,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c210014801.thtg)
	e3:SetOperation(c210014801.thop)
	c:RegisterEffect(e3)
	--Pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(c210014801.pcon)
	e4:SetTarget(c210014801.ptg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c210014801.damcon)
	e5:SetOperation(c210014801.damop)
	c:RegisterEffect(e5)
end
c210014801.listed_names={0x9b}
function c210014801.pcon(e,c)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c210014801.ptg(e,c)
	return c:IsSetCard(0x9b) 
end
function c210014801.damcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep~=tp and tc:IsSetCard(0x9b) and tc:GetBattleTarget()~=nil
		and tc:GetBattleTarget():IsDefensePos()
		and e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c210014801.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
-------------------------------------------------------------
function c210014801.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9b) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c210014801.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210014801.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c210014801.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c210014801.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
-------------------------------------------------------------
function c210014801.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0x9b) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
-------------------------------------------------------------
function c210014801.filter0(c)
	return c:IsAbleToRemove()
end
function c210014801.filter1(c,e)
	return not c:IsImmuneToEffect(e) and c:IsAbleToRemove()
end
function c210014801.filter2(c,e,tp,m,f)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x9b) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,tp)
end
function c210014801.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c210014801.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetFusionMaterial(tp):Filter(c210014801.filter0,nil)
		if not Duel.IsPlayerAffectedByEffect(tp,69832741) then
			local mg2=Duel.GetMatchingGroup(c210014801.filter3,tp,LOCATION_GRAVE,0,nil)
			mg1:Merge(mg2)
		end
		local res=Duel.IsExistingMatchingCard(c210014801.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c210014801.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c210014801.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local mg1=Duel.GetFusionMaterial(tp):Filter(c210014801.filter1,nil,e)
	if not Duel.IsPlayerAffectedByEffect(tp,69832741) then
		local mg2=Duel.GetMatchingGroup(c210014801.filter3,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
	end
	local sg1=Duel.GetMatchingGroup(c210014801.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c210014801.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,tp)
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,tp)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end

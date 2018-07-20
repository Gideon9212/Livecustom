--Shapesnatch the Morinphen Rider
function c210001520.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,55784832,4035199)
	--atk gain
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c210001520.av)
	c:RegisterEffect(e1)
	--immuny to other monster effect
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c210001520.iev)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c210001520.sst)
	e3:SetOperation(c210001520.sso)
	c:RegisterEffect(e3)
end
function c210001520.avfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsLevelAbove(5) and c:IsDefenseBelow(2000) and c:IsAttackBelow(2000)
end
function c210001520.av(e,c)
	return 1000*Duel.GetMatchingGroupCount(c210001520.avfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
end
function c210001520.iev(e,te)
	return e:GetHandler()~=te:GetHandler()
end
function c210001520.ssfilter(c,e,tp)
	return c210001520.avfilter(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c210001520.sst(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c210001520.ssfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c210001520.ssfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c210001520.ssfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,nil,nil)
end
function c210001520.sso(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0
		and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() then
		local att,level=tc:GetAttribute(),tc:GetLevel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(att)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(level)
		c:RegisterEffect(e2)
	end
end

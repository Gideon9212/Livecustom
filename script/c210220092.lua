--幻影破れたバナー
--Phantom Knights' Torn Banner
--Created and scripted by Eerie Code
function c210220092.initial_effect(c)
	--Activate effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,210220092)
	e1:SetTarget(c210220092.tdtg)
	e1:SetOperation(c210220092.tdop)
	c:RegisterEffect(e1)
	--Phantom Xyz
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,210220092+1000)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c210220092.sptg)
	e2:SetOperation(c210220092.spop)
	c:RegisterEffect(e2)
end
function c210220092.tdfil(c)
	return c:IsFaceup() and c:IsSetCard(0xdb) and not c:IsCode(210220092) and c:IsAbleToDeck()
end
function c210220092.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c210220092.tdfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c210220092.tdfil,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c210220092.tdfil,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c210220092.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c210220092.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10db) and not c:IsType(TYPE_TOKEN)
end
function c210220092.xyzfilter(c,e,tp,mg)
	return c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and mg:FilterCount(c.xyz_filter,nil,c,SUMMON_TYPE_XYZ,tp)>=c.minxyzct
end
function c210220092.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c210220092.mfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c210220092.xyzfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c210220092.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c210220092.mfilter,tp,LOCATION_MZONE,0,nil)
	local xyzg=Duel.GetMatchingGroup(c210220092.xyzfilter,tp,LOCATION_GRAVE,0,nil,e,tp,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=g:FilterSelect(tp,xyz.xyz_filter,xyz.minxyzct,xyz.maxxyzct,nil,xyz,SUMMON_TYPE_XYZ,tp)
		Duel.Overlay(xyz,sg)
		Duel.SpecialSummonStep(xyz,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_EXTRA)
		xyz:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
		xyz:CompleteProcedure()
	end
end

--Karma-Soul Magician
--designed by ShadicDDragno
--scripted by Larry126
function c210125498.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c210125498.matfilter,1,1)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,210125498)
	e3:SetCondition(c210125498.spcon)
	e3:SetTarget(c210125498.sptg)
	e3:SetOperation(c210125498.spop)
	c:RegisterEffect(e3)
end
function c210125498.matfilter(c,lc,sumtype,tp)
	return c:IsType(TYPE_PENDULUM,lc,sumtype,tp) and c:IsSetCard(0x98)
end
function c210125498.spcfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsPreviousSetCard(0x98)
		and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP)
		and c:IsPreviousLocation(LOCATION_MZONE+LOCATION_PZONE)
end
function c210125498.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c210125498.spcfilter,1,nil,tp)
end
function c210125498.spfilter(c,e,tp,zone)
	return c:IsType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and c:IsSetCard(0x98)
end
function c210125498.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone()
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if chk==0 then 
		return loc~=0 and zone~=0 and Duel.IsExistingMatchingCard(c210125498.spfilter,tp,loc,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function c210125498.spop(e,tp,eg,ep,ev,re,r,rp)
	local loc=0
	local zone=e:GetHandler():GetLinkedZone()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 or zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c210125498.spfilter),tp,loc,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
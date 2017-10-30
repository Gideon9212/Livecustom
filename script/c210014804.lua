--Allegro the Melodious Diva
--designed by Sanct and Larry126
--scripted by Larry126
function c210014804.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(48686504,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,210014804)
	e1:SetCost(c210014804.cost)
	e1:SetTarget(c210014804.target)
	e1:SetOperation(c210014804.operation)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(210014804,ACTIVITY_SPSUMMON,c210014804.counterfilter)
end
c210014804.listed_names={0x9b,0x109b,210014804}
function c210014804.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c210014804.costfilter(c,ft,tp)
	return c:IsFaceup() and c:IsSetCard(0x9b)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5))
end
function c210014804.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c210014804.costfilter,1,nil,ft,tp)
		and Duel.GetCustomActivityCount(210014804,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c210014804.splimit)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.SelectReleaseGroup(tp,c210014804.costfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c210014804.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetAttribute()~=ATTRIBUTE_LIGHT
end
function c210014804.filter(c,e,tp)
	return c:IsSetCard(0x109b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c210014804.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210014804.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c210014804.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c210014804.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--Harmony the Melodious Diva
--designed and scripted by Larry126
function c210014815.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1152)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c210014815.spcon)
	c:RegisterEffect(e1)
	--synchro
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82224646,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c210014815.sccon)
	e2:SetTarget(c210014815.sctg)
	e2:SetOperation(c210014815.scop)
	c:RegisterEffect(e2)
	if not c210014815.global_check then
		c210014815.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetLabel(210014815)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
	end
end
c210014815.listed_names={0x9b,210014815}
function c210014815.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>=2
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c210014815.scfilter1(c,tp,mc)
	return Duel.IsExistingMatchingCard(c210014815.scfilter2,tp,LOCATION_PZONE,0,1,nil,mc,c)
end
function c210014815.scfilter2(c,mc,sc)
	local mg=Group.FromCards(c,mc)
	return c:IsCanBeSynchroMaterial(sc) and sc:IsSynchroSummonable(nil,mg)
end
function c210014815.sccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(210014815)~=0
end
function c210014815.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,c)>0
		and Duel.IsExistingMatchingCard(c210014815.scfilter1,tp,LOCATION_EXTRA,0,1,nil,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c210014815.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCountFromEx(tp,tp,c)<=0 then return end
	local g=Duel.GetMatchingGroup(c210014815.scfilter1,tp,LOCATION_EXTRA,0,nil,tp,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local mg=Duel.GetMatchingGroup(c210014815.scfilter2,tp,LOCATION_PZONE,0,nil,c,sc)
		mg:AddCard(c)
		Duel.SynchroSummon(tp,sc,nil,mg)
	end
end
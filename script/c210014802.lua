--Diva the Melodious Songstress
--designed and scripted by Larry126
function c210014802.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,210014802)
	e1:SetCost(c210014802.spcost)
	e1:SetTarget(c210014802.sptg)
	e1:SetOperation(c210014802.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40318957,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,2100148020)
	e2:SetTarget(c210014802.thtg)
	e2:SetOperation(c210014802.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
c210014802.listed_names={0x9b,210014802}
function c210014802.thfilter(c)
	return (c:IsCode(9113513,11493868,44256816,63804637) or aux.IsCodeListed(c,0x9b))
		and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c210014802.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210014802.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c210014802.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c210014802.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
-----------------------------------------------------------------
function c210014802.filter(c,e,tp)
	return c:IsSetCard(0x9b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c210014802.cfilter(c,e,tp)
	return c:IsDiscardable() and Duel.IsExistingMatchingCard(c210014802.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,c,e,tp)
end
function c210014802.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210014802.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.DiscardHand(tp,c210014802.cfilter,1,1,REASON_COST+REASON_DISCARD,nil,e,tp)
end
function c210014802.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c210014802.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c210014802.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local fid=c:GetFieldID()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(210014802,RESET_EVENT+0x1fe0000,0,1,fid)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabel(fid)
		e2:SetLabelObject(tc)
		e2:SetCondition(c210014802.descon)
		e2:SetOperation(c210014802.desop)
		Duel.RegisterEffect(e2,tp)
	end
	Duel.SpecialSummonComplete()
end
function c210014802.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(210014802)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c210014802.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
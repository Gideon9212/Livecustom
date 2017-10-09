--ＨｐＳＲトリック・ダイス
--Hyper-Speedroid Trick Dice
--Created and scripted by Eerie Code
function c210220043.initial_effect(c)
	c:SetSPSummonOnce(210220043)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,1,1,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--Level Change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(210220043,0))
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c210220043.lvtg)
	e1:SetOperation(c210220043.lvop)
	c:RegisterEffect(e1)
	--synchro effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(210220043,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c210220043.sccon)
	e2:SetTarget(c210220043.sctarg)
	e2:SetOperation(c210220043.scop)
	c:RegisterEffect(e2)
end
function c210220043.lvfil(c,ss)
	return c:IsSetCard(0x2016) and c:IsLevelAbove(1) and (ss or c:IsAbleToRemove())
end
function c210220043.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ss=c:IsSummonType(SUMMON_TYPE_SYNCHRO)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c210220043.lvfil(chkc,ss) end
	if chk==0 then return Duel.IsExistingTarget(c210220043.lbfil,tp,LOCATION_GRAVE,0,1,nil,ss) end
	if not ss then
		e:SetCategory(CATEGORY_REMOVE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectTarget(tp,c210220043.lvfil,tp,LOCATION_GRAVE,0,1,1,nil,ss)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	else
		e:SetCategory(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,c210220043.lvfil,tp,LOCATION_GRAVE,0,1,1,nil,ss)
	end
	local op=0
	if c:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(1006081,1))
	else op=Duel.SelectOption(tp,aux.Stringid(1006081,1),aux.Stringid(1006081,2)) end
	e:SetLabel(op)
end
function c210220043.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local lv=tc:GetLevel()
	if c:IsSummonType(SUMMON_TYPE_SYNCHRO) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	if e:GetLabel()==0 then
		e1:SetValue(lv)
	else e1:SetValue(-lv) end
	c:RegisterEffect(e1)
end
function c210220043.sccon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c210220043.sctarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c210220043.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c)
	end
end

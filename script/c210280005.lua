--スポーア・ステム
--Spore Stem
--concept by Gh8stree
--script by pyrQ (with some help polishing from andré)
function c210280005.initial_effect(c)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(210280005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(2,210280005)
	e1:SetCost(c210280005.cost)
	e1:SetTarget(c210280005.target)
	e1:SetOperation(c210280005.operation)
	c:RegisterEffect(e1)
end
function c210280005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,210280005)<=1 end
    Duel.RegisterFlagEffect(tp,210280005,PHASE_END,0,2)
end
function c210280005.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c210280005.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,210280006,0,0x4011,0,0,3,RACE_PLANT,ATTRIBUTE_WIND,POS_FACEUP_DEFENSE) then return end
	local token=Duel.CreateToken(tp,210280006)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	Duel.BreakEffect()
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
end
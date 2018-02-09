--Beethoven the Melodious Maestra
--designed and scripted by Larry126
function c210014803.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMixN(c,true,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0x9b),2)
	--shuffle
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26593852,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c210014803.target)
	e1:SetOperation(c210014803.operation)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c210014803.aclimit)
	e2:SetCondition(c210014803.actcon)
	c:RegisterEffect(e2)
end
c210014803.listed_names={0x9b}
c210014803.material_setcode={0x9b}
function c210014803.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsSummonType(SUMMON_TYPE_SPECIAL) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
end
function c210014803.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.SendtoDeck(tc,nil,REASON_EFFECT) end
end
----------------------------------------------------
function c210014803.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c210014803.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x9b) and c:IsControler(tp)
end
function c210014803.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and c210014803.cfilter(a,tp)) or (d and c210014803.cfilter(d,tp))
end
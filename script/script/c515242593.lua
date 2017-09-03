--Blue Striker: Tiny Pony, the Powerful
function c515242593.initial_effect(c)
		--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x666),2)
	c:EnableReviveLimit()
	--link summon
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetDescription(aux.Stringid(4066,3))
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetCondition(c515242593.sprcon)
    e0:SetOperation(c515242593.sprop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(515242593,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c515242593.destg)
	e1:SetOperation(c515242593.desop)
	c:RegisterEffect(e1)
end
function c515242593.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() and not tc:IsType(TYPE_LINK) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c515242593.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.Destroy(tc,REASON_EFFECT) end
end







function c515242593.sprfilter1(c,tp)
    local lv=c:GetLevel()
    return lv>0 and c:IsSetCard(0x666) and not c:IsCode(515242564) and c:IsFaceup() and c:IsAbleToGraveAsCost()
        and Duel.IsExistingMatchingCard(c515242593.sprfilter2,tp,LOCATION_EXTRA,0,2,nil,lv)
        and Duel.IsExistingMatchingCard(c515242593.sprfilter3,tp,LOCATION_EXTRA,0,1,nil,tp)
end
function c515242593.sprfilter2(c,lv)
    return c:IsFaceup() and c:IsSetCard(0x666) and not c:IsCode(515242564) and c:GetLevel()==lv and c:IsAbleToGraveAsCost()
end
function c515242593.sprfilter3(c,lv)
    return c:IsFaceup() and c:IsCode(515242564) and c:IsAbleToGraveAsCost()
end
function c515242593.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
	 return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
	and Duel.IsExistingMatchingCard(c515242593.sprfilter1,tp,LOCATION_EXTRA,0,1,nil,tp)
end

function c515242593.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g1=Duel.SelectMatchingCard(tp,c515242593.sprfilter1,tp,LOCATION_EXTRA,0,1,1,nil,tp)
    Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g2=Duel.SelectMatchingCard(tp,c515242593.sprfilter2,tp,LOCATION_EXTRA,0,1,1,nil,g1:GetFirst():GetLevel())
    Duel.SendtoGrave(g2,REASON_MATERIAL+REASON_LINK)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g3=Duel.SelectMatchingCard(tp,c515242593.sprfilter3,tp,LOCATION_EXTRA,0,1,1,nil,tp)
    Duel.SendtoGrave(g3,REASON_MATERIAL+REASON_LINK)
end

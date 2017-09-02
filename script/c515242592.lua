--Blue Striker: Moon Burst Conflicting Thoughts
function c515242592.initial_effect(c)
		--link summon
aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x666),2)
	c:EnableReviveLimit()
	--link summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetDescription(aux.Stringid(4066,3))
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c515242592.lkcon)
	e0:SetOperation(c515242592.lkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)

		--cannot be target/battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c515242592.tgtg)
	e3:SetValue(c515242592.indval)

	c:RegisterEffect(e3)
end
function c515242592.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c515242592.indval(e,c)
	return not c:IsType(TYPE_LINK)
end


function c515242592.lkfilter1(c,lc,tp)
	return c:IsFaceup() and c:IsCode(515242564) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c515242592.lkfilter2,tp,LOCATION_EXTRA,0,1,nil,c,tp) 
end
function c515242592.lkfilter2(c,lc,tp)
	return c:IsFaceup() and c:IsSetCard(0x666) and not c:IsCode(515242564) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c515242592.lkfilter3,tp,LOCATION_EXTRA,0,1,c,lc,c,tp)
end
function c515242592.lkfilter3(c,lc,mc,tp)
	local mg=Group.FromCards(c,mc)
	return c:IsFaceup() and c:IsSetCard(0x666) and not c:IsCode(515242564) and c:IsAbleToGraveAsCost() 
		and c:IsAttribute(mc:GetAttribute()) and Duel.GetLocationCountFromEx(tp,tp,mg,lc)>0
end
function c515242592.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c515242592.lkfilter1,tp,LOCATION_EXTRA,0,1,nil,c,tp) 
end
function c515242592.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c515242592.lkfilter1,tp,LOCATION_EXTRA,0,1,1,nil,c,tp)
	local g2=Duel.SelectMatchingCard(tp,c515242592.lkfilter2,tp,LOCATION_EXTRA,0,1,1,nil,c,tp)
	local g3=Duel.SelectMatchingCard(tp,c515242592.lkfilter3,tp,LOCATION_EXTRA,0,1,1,g2:GetFirst(),c,g2:GetFirst(),tp)
	g1:Merge(g2)
	g1:Merge(g3)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
end
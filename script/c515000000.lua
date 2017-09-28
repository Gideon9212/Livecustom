--Neo Five-Souls Kuriboh
function c515000000.initial_effect(c)
	c:EnableReviveLimit()
	--fusion prochedure
	aux.AddFusionProcMixRep(c,false,false,c515000000.matfilter,5,7)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--indes battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c515000000.indval)
	c:RegisterEffect(e2)
	--destroy everything
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c515000000.dcon)
	e3:SetTarget(c515000000.dtg)
	e3:SetOperation(c515000000.dop)
	c:RegisterEffect(e3)
end
function c515000000.matfilter(c,fc,sumtype,sp,sub,mg,sg)
	return c:IsFusionSetCard(0xa4) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode())) and (not mg or mg:GetClassCount(Card.GetFusionCode)>4)
end
function c515000000.indval(e,c)
	return not c:IsSetCard(0xa4)
end
function c515000000.dcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c515000000.desfilter(c)
	return not (c:IsSetCard(0xa4) and c:IsFaceup())
end
function c515000000.damfilter(c,e)
	return c:IsDestructable(e) and c:IsAbleToGrave()
end
function c515000000.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(c515000000.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	local dg=sg:Filter(c515000000.damfilter,nil,e)
	if dg:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,PLAYER_ALL,dg:GetCount()*500)
		e:SetCategory(bit.bor(e:GetCategory(),CATEGORY_DAMAGE))
	end
end
function c515000000.dop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c515000000.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
		local dam=g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)*500
		if dam>0 then
			Duel.BreakEffect()
			Duel.Damage(tp,dam,REASON_EFFECT)
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end

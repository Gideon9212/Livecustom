--超量機獣シルバーリンクス
--Super Quantal Mech Beast Silverlynx
--Scripted by Eerie Code
function c120401046.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xdc),2)
	--alternate summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(120401046,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c120401046.lkcon)
	e0:SetOperation(c120401046.lkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120401046,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c120401046.accon)
	e1:SetTarget(c120401046.actg)
	e1:SetOperation(c120401046.acop)
	c:RegisterEffect(e1)
	--attack permission
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(120401046)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c120401046.aptg)
	c:RegisterEffect(e2)
	if not c120401046.global_flag then
		c120401046.global_flag=true
		c11646785.atcon=c120401046.atcon
		c57031794.atcon=c120401046.atcon
		c85252081.atcon=c120401046.atcon
	end
end
function c120401046.fdfilter(c)
	return c:IsFaceup() and c:IsCode(10424147)
end
function c120401046.wlfilter(c,tp,sc)
	return c:IsFaceup() and c:IsCode(120401047) and c:IsAbleToGraveAsCost()
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c),sc)>0
end
function c120401046.lkcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c120401046.fdfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c120401046.wlfilter,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function c120401046.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c120401046.wlfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c120401046.aptg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c120401046.atcon(e)
	local c=e:GetHandler()
	return c:GetOverlayCount()==0 and not c:IsHasEffect(120401046)
end
function c120401046.accon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedZone()
	local at=Duel.GetAttacker()
	return at:IsCode(84025439) and lg:IsContains(at)
end
function c120401046.acfilter(c,tp)
	return c:IsCode(47819246) and c:GetActivateEffect():IsActivatable(tp,true)
end
function c120401046.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c120401046.acfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c120401046.acop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sc=Duel.SelectMatchingCard(tp,c120401046.acfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if sc then
		Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=sc:GetActivateEffect()
		local tep=sc:GetControler()
		local cost=te:GetCost()
		local tg=te:GetTarget()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		if tg then tg(te,tep,eg,ep,ev,re,r,rp,1) end
	end
end

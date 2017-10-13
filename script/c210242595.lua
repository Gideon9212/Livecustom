--Blue Striker: Tiny Pony, the Courageous
function c210242595.initial_effect(c)
    	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x666),3)
	c:EnableReviveLimit()
	--add link summon
    	local e0=Effect.CreateEffect(c)
    	e0:SetType(EFFECT_TYPE_FIELD)
    	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetDescription(aux.Stringid(4066,3))
    	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    	e0:SetRange(LOCATION_EXTRA)
    	e0:SetCondition(c210242595.sprcon)
    	e0:SetOperation(c210242595.sprop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--anti back row
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(210242595,2))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1)
	e1:SetCondition(c210242595.descon)
	e1:SetTarget(c210242595.destg2)
	e1:SetOperation(c210242595.desop2)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c210242595.aclimit)
	e2:SetCondition(c210242595.actcon)
	c:RegisterEffect(e2)
end
c210242595.pendulum_level=4
function c210242595.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c210242595.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c210242595.descon(e)
	return e:GetHandler():GetLinkedGroupCount()>=1
end
function c210242595.filter3(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c210242595.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c210242595.filter3(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c210242595.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c210242595.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c210242595.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c210242595.sprfilter1(c,tp)
    	local lv=c:GetLevel()
    	return lv>0 and c:IsSetCard(0x666) and c:IsFaceup() and c:IsAbleToGraveAsCost()
    		and Duel.IsExistingMatchingCard(c210242595.sprfilter2,tp,LOCATION_EXTRA,0,2,nil,lv)
        	and Duel.IsExistingMatchingCard(c210242595.sprfilter3,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c210242595.sprfilter2(c,lv)
    	return c:IsFaceup() and c:IsSetCard(0x666) and c:GetLevel()==lv and c:IsAbleToGraveAsCost()
end
function c210242595.sprfilter3(c,lv)
    	return c:IsFaceup() and c:IsCode(210242564)
end
function c210242595.sprcon(e,c)
    	if c==nil then return true end
    	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
	and Duel.IsExistingMatchingCard(c210242595.sprfilter1,tp,LOCATION_EXTRA,0,1,nil,tp)
end
function c210242595.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c210242595.sprfilter1,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c210242595.sprfilter2,tp,LOCATION_EXTRA,0,2,2,nil,g1:GetFirst():GetLevel())
	Duel.SendtoGrave(g2,REASON_MATERIAL+REASON_LINK)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g3=Duel.SelectMatchingCard(tp,c210242595.sprfilter3,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SendtoGrave(g3,REASON_MATERIAL+REASON_LINK)
end

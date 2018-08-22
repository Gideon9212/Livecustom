--created & coded by Lyris, art at http://1.bp.blogspot.com/_jynCnIdwsk4/TEfeWui5DkI/AAAAAAAACPE/F_CPSgOiC2g/s1600/sinhasan-battishi-story-katha-nice-793791.jpg
--剣主三タン
function c240100254.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c240100254.val)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c240100254.efcon)
	e2:SetOperation(c240100254.efop)
	c:RegisterEffect(e2)
end
function c240100254.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbb2)
end
function c240100254.val(e,c)
	return Duel.GetMatchingGroupCount(c240100254.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*200
end
function c240100254.filter(c)
	return c:IsAttackPos() and c:IsCanChangePosition()
end
function c240100254.efcon(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAttackPos() and chkc:IsCanChangePosition() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c240100254.filter,tp,0,LOCATION_MZONE,1,1,nil,POS_ATTACK)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c240100254.efop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,0,0)
	end
end

--The Grand Unison!
--designed and scripted by Larry126
function c210014814.initial_effect(c)
	c:SetUniqueOnField(1,0,210014814)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c210014814.tg)
	e2:SetValue(c210014814.val)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c210014814.destg)
	e3:SetOperation(c210014814.desop)
	c:RegisterEffect(e3)
end
c210014814.listed_names={0x9b,210014814}
function c210014814.tg(e,c)
	return c:IsSetCard(0x9b)
end
function c210014814.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x9b) or c:IsCode(9113513,11493868,44256816,63804637) or aux.IsCodeListed(c,0x9b))
end
function c210014814.val(e,c)
	return Duel.GetMatchingGroupCount(c210014814.filter,c:GetControler(),LOCATION_ONFIELD,0,e:GetHandler())*100
end
---------------------------------------------------------------
function c210014814.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9b) and c:IsType(TYPE_MONSTER)
end
function c210014814.desfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c210014814.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c210014814.desfilter2(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c210014814.desfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(c210014814.desfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local ct=Duel.GetMatchingGroupCount(c210014814.desfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c210014814.desfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c210014814.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
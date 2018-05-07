--覇王のペンデュラムグラフ
--Supreme Pendulumgraph
--Created and scripted by Eerie Code
function c210220091.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTarget(c210220091.distarget)
	c:RegisterEffect(e2)
	--inactivatable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(c210220091.effectfilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetValue(c210220091.effectfilter)
	c:RegisterEffect(e4)
	--link
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_BECOME_LINKED_ZONE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCondition(c210220091.con)
	e5:SetValue(c210220091.lzval)
	c:RegisterEffect(e5)
	--splimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(1,0)
	e6:SetTarget(c210220091.splimit)
	c:RegisterEffect(e6)
end
function c210220091.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local tc=te:GetHandler()
	return p==tp and te:IsActiveType(TYPE_MONSTER) 
		and (tc:IsSetCard(0x20f8) or (tc:IsType(TYPE_PENDULUM) and tc:IsSetCard(0xf8))) 
		and bit.band(loc,LOCATION_MZONE)~=0
end
function c210220091.distarget(e,c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x20f8) or (c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xf8)))
end
function c210220091.zfilter(c)
	return c:IsFaceup() and c:IsCode(13331639)
end
function c210220091.con(e)
	return Duel.IsExistingMatchingCard(c210220091.zfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c210220091.lzfilter(c)
	return c210220091.zfilter(c) and c:GetSequence()<5
end
function c210220091.lzval(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c210220091.lzfilter,tp,LOCATION_ONFIELD,0,nil)
	local zone=0
	for tc in aux.Next(g) do
		local seq=tc:GetSequence()
		zone=bit.bor(zone,math.pow(2,seq))
		if seq>0 then zone=bit.bor(zone,math.pow(2,seq+1)) end
		if seq<4 then zone=bit.bor(zone,math.pow(2,seq-1)) end
	end
	return zone
end
function c210220091.splimit(e,c)
	return not (c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK))
end

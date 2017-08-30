--MoonBurst of XIII
function c5154242577.initial_effect(c)
--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x666),3,true)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c5154242577.spcon)
	e1:SetOperation(c5154242577.spop)
	c:RegisterEffect(e1)
		--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5154242577,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c5154242577.atcon)
	e2:SetOperation(c5154242577.atop)
	c:RegisterEffect(e2)
--unbanish cards from scale
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(5154242577,3))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_PZONE)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCountLimit(2,5154242577)
    e4:SetTarget(c5154242577.target)
    e4:SetOperation(c5154242577.operation)
    c:RegisterEffect(e4)

end

function c5154242577.cefilter(c)
    return c:IsSetCard(0x666) and c:IsType(TYPE_PENDULUM)
end

function c5154242577.target(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(c5154242577.spfilter,tp,LOCATION_REMOVED,0,1,nil) end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
Duel.SelectTarget(tp,c5154242577.spfilter,tp,LOCATION_REMOVED,0,1,1,nil) 
end

function c5154242577.operation(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetFirstTarget()
if tc and tc:IsRelateToEffect(e)  then
Duel.SendtoExtraP(tc,nil,REASON_EFFECT)
end
end

c5154242577.pendulum_level=6
function c5154242577.spfilter1(c,tp)
    return c:IsSetCard(0x666) and c:IsCanBeFusionMaterial() and c:IsReleasable()
       -- and Duel.IsExistingMatchingCard(c5154242577.spfilter2,tp,LOCATION_MZONE,0,2,c)
end
function c5154242577.spfilter2(c)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsReleasable()
end
function c5154242577.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsFaceup()
end
function c5154242577.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
		local c=e:GetHandler()
	return not c:IsFaceup() and
	Duel.GetLocationCount(tp,LOCATION_MZONE)<3
        and Duel.IsExistingMatchingCard(c5154242577.spfilter1,tp,LOCATION_MZONE,0,3,nil,tp)
end
function c5154242577.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c5154242577.spfilter1,tp,LOCATION_MZONE,0,3,3,nil,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
 --[[  local g2=Duel.SelectMatchingCard(tp,c5154242577.spfilter2,tp,LOCATION_MZONE,0,2,2,g:GetFirst())
    g:Merge(g2) ]]--
    local cg=g:Filter(Card.IsFacedown,nil)
    if cg:GetCount()>0 then
        Duel.ConfirmCards(1-tp,cg)
    end
    Duel.Release(g,nil,2,REASON_COST) --release?
end

function c5154242577.filter(c,rc)
	return c:IsReason(REASON_BATTLE) and c:IsLocation(LOCATION_GRAVE) and c:GetReasonCard()==rc
end
function c5154242577.atcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c5154242577.filter,1,nil,e:GetHandler())
end
function c5154242577.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(500)
		e2:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e2)
	end
end

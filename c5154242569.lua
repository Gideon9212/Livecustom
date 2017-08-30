--MoonBurst:The Awakened

function c5154242569.initial_effect(c)
c:SetUniqueOnField(1,0,5154242569)
			--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,5154242569+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c5154242569.spcon)
--	e1:SetOperation(c5154242569.spop)
	c:RegisterEffect(e1)
--end battle phase
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5154242569,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,51542425691+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c5154242569.condition)
	e2:SetCost(c5154242569.cost)
	e2:SetOperation(c5154242569.operation)
	c:RegisterEffect(e2)
	--cannot attack announce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c5154242569.antarget)
	c:RegisterEffect(e3)
--cannot negate summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e4)

		--Unaffected by Opponent Card Effects
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetValue(c5154242569.unval)
	c:RegisterEffect(e6)
	--Pierce
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e7)

end
function c5154242569.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c5154242569.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c5154242569.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end


function c5154242569.antarget(e,c)
	return c~=e:GetHandler()
end
function c5154242569.unval(e,te)
	return te:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
	
	--Sp summon rule
function c5154242569.spfilter(c)
	return c:IsFusionSetCard(0x666) and c:IsCanBeFusionMaterial() and c:IsFaceup()
end

function c5154242569.spcon(e,c)
	if c==nil then return true end
	
	local g=Duel.GetMatchingGroup(c5154242569.spfilter,c:GetControler(),LOCATION_EXTRA,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=8 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
end
function c5154242569.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c5154242569.spfilter,tp,LOCATION_EXTRA,0,nil)
	local rg=Group.CreateGroup()
	for i=1,8 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TRIBUTE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			rg:AddCard(tc)
			g:Remove(Card.IsCode,nil,tc:GetCode())
		end
	end
	--Duel.Release(rg,REASON_COST)
end
	
	
function c5154242569.matcheck(e,c)
	local ct=c:GetMaterial()
	if ct:GetCount()==1 then
	--Nuke on summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5154242569,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c5154242569.target)
	e1:SetOperation(c5154242569.operation)
	c:RegisterEffect(e1)
	end
	--Nuke on summon
	if ct:GetCount()==8 then
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5154242569,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c5154242569.target)
	e1:SetOperation(c5154242569.operation)
	c:RegisterEffect(e1)
	end
	--Can't negate nuke
	if ct:GetCount()==3 then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c5154242569.target)
	e1:SetOperation(c5154242569.operation)
	c:RegisterEffect(e1)
	end
	end

	
	

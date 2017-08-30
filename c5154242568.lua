--Blue Striker: Moon Burst the Forgotten Child
function c5154242568.initial_effect(c)
	 --pendulum summon
 aux.EnablePendulumAttribute(c)
		--search if deal damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5154242568,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCountLimit(1,5154242568)
	e1:SetCondition(c5154242568.condition)
	e1:SetTarget(c5154242568.target)
	e1:SetOperation(c5154242568.operation)
	c:RegisterEffect(e1)
		-- Once per turn: You can shuffle 1 "Blue Striker" monster you control into the Deck; 
	-- Special Summon 1 "Blue Striker" monster with a different name from your Deck.
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(c5154242568.tg)
	e3:SetOperation(c5154242568.op)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
	
	--Search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(5154242568,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(c5154242568.descon1)
	e4:SetTarget(c5154242568.destg1)
	e4:SetOperation(c5154242568.desop1)
	c:RegisterEffect(e4)
end
--OPT, send a Striker you control to the deck, sp summon a different one frmo the deck.
function c5154242568.filter1(c,e,tp)
	local code=c:GetCode()
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsAbleToDeckAsCost()
		and Duel.IsExistingMatchingCard(c5154242568.filter2,tp,LOCATION_DECK,0,1,nil,code,e,tp)
end
function c5154242568.filter2(c,code,e,tp)
	return c:IsSetCard(0x666) and c:GetCode()~=code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c5154242568.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c5154242568.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	local rg=Duel.SelectMatchingCard(tp,c5154242568.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetCode())
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c5154242568.op(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c5154242568.filter2,tp,LOCATION_DECK,0,1,1,nil,code,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--search tiny pony
function c5154242568.descon1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c5154242568.filter(c)
	return c:IsCode(5154242564) and c:IsAbleToHand()
end
function c5154242568.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c5154242568.filter,tp,0x51,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x51)
end
function c5154242568.desop1(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c5154242568.filter,tp,0x51,0,1,1,nil):GetFirst()
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end

--search if deal damage
function c5154242568.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c5154242568.filter3(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_PENDULUM) and c:IsLevelBelow(4) and not c:IsLevelBelow(3)
end
function c5154242568.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1 end
end
function c5154242568.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
    Duel.ConfirmDecktop(tp,1)
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    if tc:IsSetCard(0x666) then
    	Duel.SendtoHand(tc,nil,REASON_EFFECT)
    	Duel.ConfirmCards(1-tp,tc)
    else
    	Duel.SendtoGrave(tc,REASON_EFFECT)
    end
end

	
	
	
	
	
	
	
	
	
	
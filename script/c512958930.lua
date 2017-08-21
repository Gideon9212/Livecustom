--Odd-Eyes Exceed Magician

function c512958930.initial_effect(c)
	--rule
	loc=LOCATION_SZONE
    l,r=6,7
	if Duel.GetMasterRule and Duel.GetMasterRule()>=4 then loc,l,r=LOCATION_PZONE,0,1 end
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	if not c512958930.global_check then
        c512958930.global_check=true
        local e2=Effect.GlobalEffect()
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetCode(EFFECT_CHANGE_CODE)
        e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e2:SetTarget(function(e,c) return getmetatable(c)==c512958930 end)
        e2:SetTargetRange(LOCATION_OVERLAY,LOCATION_OVERLAY)
        e2:SetValue(16195942)
        Duel.RegisterEffect(e2,0)
    end
	--Treat
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetRange(0xff)
	e0:SetValue(16195942)
	c:RegisterEffect(e0)
	--Destruction hand and scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1124)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c512958930.penconn)
	e1:SetTarget(c512958930.pentgg)
	e1:SetOperation(c512958930.penopp)
	c:RegisterEffect(e1)
	--Set to scale when destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1160)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c512958930.pensetcon)
	e2:SetTarget(c512958930.pensettg)
	e2:SetOperation(c512958930.pensetop)
	c:RegisterEffect(e2)
	--Xyz to lvl7
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(58988903,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c512958930.xyztg)
	e3:SetOperation(c512958930.xyzop)
	c:RegisterEffect(e3)
	--Scale 13
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(56675280,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c512958930.sctg)
	e4:SetOperation(c512958930.scop)
	c:RegisterEffect(e4)
	--Gy to material
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(79094383,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,79094383)
	e5:SetTarget(c512958930.mattg)
	e5:SetOperation(c512958930.matop)
	c:RegisterEffect(e5)
	--Rank-up
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(64414267,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(c512958930.spxyztg)
	e6:SetOperation(c512958930.spxyzop)
	c:RegisterEffect(e6)
	
end
--Destruction hand and scale
function c512958930.penconn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c512958930.penf1,tp,LOCATION_ONFIELD,0,1,nil)
end
function c512958930.penff1(c)
	return c:IsOnField()
end
function c512958930.penff2(c)
    if c:IsCode(c,512958930) then 
    return c end
end
function c512958930.pentgg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c512958930.penff2,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c512958930.penff1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c512958930.penff2,tp,LOCATION_HAND,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c512958930.penopp(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--Set to scale when destroyed
function c512958930.pensetcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c512958930.pensettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c512958930.pensetop(e,tp,eg,ep,ev,re,r,rp) 
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
--Xyz to lvl7
function c512958930.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c512958930.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c512958930.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c512958930.xyzfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c512958930.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c512958930.xyzop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_XYZ_LEVEL)
		e1:SetValue(c512958930.xyzlv)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_RANK)
		e2:SetValue(7)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c512958930.xyzlv(e,c,rc)
	return c:GetRank()
end
--Scale 13
function c512958930.scfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()
end
function c512958930.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c512958930.scfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_EXTRA)
	return e:GetHandler():GetLeftScale()~=13 
end
function c512958930.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c512958930.scfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		if not c:IsRelateToEffect(e) or c:GetLeftScale()==13 then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(13)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+RESET_OPPO_TURN+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e2)
	end
end
--Xyz UP materials
function c512958930.filter2(c,e,tp,mc,rk)
	return c:GetRank()==rk and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c512958930.spxyzfilter(c,e,tp,mc)
    --Debug.Message(mc:GetLevel(mc))
	return mc:IsCanBeXyzMaterial(c)	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) 
end
function c512958930.spxyzfilter2(c,e,tp,mc)
	local rk=mc:GetLevel(mc)
	return mc:IsCanBeXyzMaterial(c)	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:GetRank(c)==rk
end
function c512958930.spxyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0 
	and Duel.IsExistingMatchingCard(c512958930.spxyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c512958930.spxyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp,tp,c)>0 then
		if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c512958930.spxyzfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
			local sc=g:GetFirst()
			if sc then
				local mg=c:GetOverlayGroup()
				if mg:GetCount()~=0 then
					Duel.Overlay(sc,mg)
				end
				sc:SetMaterial(Group.FromCards(c))
				Duel.Overlay(sc,Group.FromCards(c))
				Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
				sc:CompleteProcedure()
			end
		end
	end
end
function c512958930.spxyzlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
--Gy to material
function c512958930.matfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c512958930.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c512958930.matfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c512958930.matfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c512958930.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c512958930.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end

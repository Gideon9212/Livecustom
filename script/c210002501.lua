--Dark Magic Aurora
--designed and scripted by Larry126
function c210002501.initial_effect(c)
    c:SetUniqueOnField(1,0,210002501)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,210002501)
    e1:SetOperation(c210002501.activate)
    c:RegisterEffect(e1)
    --disable
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c210002501.negcon)
    e2:SetOperation(c210002501.negop)
    c:RegisterEffect(e2)
    --atk boost
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c210002501.atktg)
    e3:SetValue(c210002501.atkval)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e4)
end
c210002501.listed_names={46986414,210002501}
function c210002501.filter(c)
    return (c:IsCode(46986414) or 
        (aux.IsCodeListed(c,46986414) and c:IsType(TYPE_SPELL+TYPE_TRAP))
        or (c:IsSetCard(0xa1) and c:IsType(TYPE_SPELL)))
        and c:IsAbleToHand() and not c:IsCode(210002501)
end
function c210002501.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c210002501.filter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function c210002501.cfilter(c)
    return c:IsFaceup() and c:IsCode(46986414)
end
function c210002501.tfilter(c,tp)
    return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and aux.IsCodeListed(c,46986414)
        and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
end
function c210002501.negcon(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)    
    return e:GetHandler():GetFlagEffect(210002501)==0
        and Duel.IsExistingMatchingCard(c210002501.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
        and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
        and g and g:IsExists(c210002501.tfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c210002501.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
        e:GetHandler():RegisterFlagEffect(210002501,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
        Duel.NegateEffect(ev)
    end
end
function c210002501.atktg(e,c)
    return c:IsFaceup() and (c:IsSetCard(0x10a2) or (c:IsRace(RACE_SPELLCASTER) and (c:IsLevelAbove(6) or c:IsRankAbove(6))))
end
function c210002501.atkval(e,c)
    return Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_SZONE,0,nil)*100
end

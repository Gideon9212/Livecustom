{\rtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 Courier New;}{\f1\froman\fprq1\fcharset128 MS PGothic;}{\f2\fnil\fcharset161{\*\fname Courier New;}Courier New Greek;}}
{\*\generator Msftedit 5.41.21.2509;}\viewkind4\uc1\pard\lang1033\f0\fs20 --\f1\'82\'63\'81\'7c\'82\'67\'82\'64\'82\'71\'82\'6e \'83\'75\'83\'89\'83\'62\'83\'66\'83\'42\'83\'7d\'83\'8a\'81\'5b\lang1032\f2\par
--Destiny HERO - B.L.O.O.D.Y. Mary\par
--concept by Xeno\par
--script by pyrQ\par
function c210280001.initial_effect(c)\par
\tab --\lang1033\f0 F\lang1032\f2 usion \lang1033\f0 M\lang1032\f2 aterial\par
\tab c:EnableReviveLimit()\par
\tab aux.AddFusionProcMix(c,true,true,c210280001.mfilter1,c210280001.mfilter2)\par
\tab --Sp\lang1033\f0 S\lang1032\f2 ummon condition\par
\tab local e1=Effect.CreateEffect(c)\par
\tab e1:SetType(EFFECT_TYPE_SINGLE)\par
\tab e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)\par
\tab e1:SetCode(EFFECT_SPSUMMON_CONDITION)\par
\tab e1:SetValue(c210280001.splimit)\par
\tab c:RegisterEffect(e1)\par
\tab --Negate\par
\tab local e2=Effect.CreateEffect(c)\par
\tab e2:SetDescription(aux.Stringid(210280001,0))\par
\tab e2:SetCategory(CATEGORY_DISABLE)\par
\tab e2:SetType(EFFECT_TYPE_QUICK_O)\par
\tab e2:SetCode(EVENT_FREE_CHAIN)\par
\tab e2:SetProperty(EFFECT_FLAG_CARD_TARGET)\par
\tab e2:SetRange(LOCATION_MZONE)\par
\tab e2:SetHintTiming(0,0x1c0)\par
\tab e2:SetCountLimit(1)\par
\tab e2:SetTarget(c210280001.target)\par
\tab e2:SetOperation(c210280001.operation)\par
\tab c:RegisterEffect(e2)\par
\tab --Halve LP\par
\tab local e3=Effect.CreateEffect(c)\par
\tab e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)\par
\tab e3:SetCode(EVENT_ATTACK_ANNOUNCE)\par
\tab e3:SetOperation(c210280001.hvop)\par
\tab c:RegisterEffect(e3)\par
\tab --Special Summon\par
\tab local e4=Effect.CreateEffect(c)\par
\tab e4:SetDescription(aux.Stringid(210280001,1))\par
\tab e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)\par
\tab e4:SetCategory(CATEGORY_SPECIAL_SUMMON)\par
\tab e4:SetCode(EVENT_PHASE+PHASE_STANDBY)\par
\tab e4:SetRange(LOCATION_GRAVE)\par
\tab e4:SetCountLimit(1)\par
\tab e4:SetCondition(c210280001.spcon)\par
\tab e4:SetCost(c210280001.spcost)\par
\tab e4:SetTarget(c210280001.sptg)\par
\tab e4:SetOperation(c210280001.spop)\par
\tab c:RegisterEffect(e4)\par
end\par
c210280001.material_setcode=\{0x8,0xc008\}\par
function c210280001.mfilter1(c)\par
\tab return c:IsFusionSetCard(0xc008) and c:GetLevel()==8\par
end\par
function c210280001.mfilter2(c,fc,sumtype,tp)\par
\tab return c:IsType(TYPE_FUSION,fc,sumtype,tp) and c:IsFusionSetCard(0xc008)\par
end\par
function c210280001.splimit(e,se,sp,st)\par
\tab return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)\par
end\par
function c210280001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)\par
\tab if chkc then return chkc:IsOnField() and aux.disfilter1(chkc) end\par
\tab if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end\par
\tab Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)\par
\tab local g=Duel.SelectTarget(tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)\par
\tab Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)\par
end\par
function c210280001.operation(e,tp,eg,ep,ev,re,r,rp)\par
\tab local c=e:GetHandler()\par
\tab local tc=Duel.GetFirstTarget()\par
\tab if tc and ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then\par
\tab\tab Duel.NegateRelatedChain(tc,RESET_TURN_SET)\par
\tab\tab local e1=Effect.CreateEffect(c)\par
\tab\tab e1:SetType(EFFECT_TYPE_SINGLE)\par
\tab\tab e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)\par
\tab\tab e1:SetCode(EFFECT_DISABLE)\par
\tab\tab e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)\par
\tab\tab tc:RegisterEffect(e1)\par
\tab\tab local e2=Effect.CreateEffect(c)\par
\tab\tab e2:SetType(EFFECT_TYPE_SINGLE)\par
\tab\tab e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)\par
\tab\tab e2:SetCode(EFFECT_DISABLE_EFFECT)\par
\tab\tab e2:SetValue(RESET_TURN_SET)\par
\tab\tab e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)\par
\tab\tab tc:RegisterEffect(e2)\par
\tab\tab if tc:IsType(TYPE_TRAPMONSTER) then\par
\tab\tab\tab local e3=Effect.CreateEffect(c)\par
\tab\tab\tab e3:SetType(EFFECT_TYPE_SINGLE)\par
\tab\tab\tab e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)\par
\tab\tab\tab e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)\par
\tab\tab\tab e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)\par
\tab\tab\tab tc:RegisterEffect(e3)\par
\tab\tab end\par
\tab end\par
end\par
function c210280001.hvop(e,tp,eg,ep,ev,re,r,rp)\par
\tab Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))\par
end\par
function c210280001.spcon(e,tp,eg,ep,ev,re,r,rp)\par
\tab return Duel.GetTurnPlayer()==tp\par
end\par
function c210280001.spfilter(c,tp)\par
\tab return c:IsSetCard(0xc008) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true) \par
\tab\tab and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or (c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5))\par
end\par
function c210280001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)\par
\tab if chk==0 then return Duel.IsExistingMatchingCard(c210280001.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp) end\par
\tab Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)\par
\tab local g=Duel.SelectMatchingCard(tp,c210280001.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,e:GetHandler(),tp)\par
\tab Duel.Remove(g,POS_FACEUP,REASON_COST)\par
end\par
function c210280001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)\par
\tab if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end\par
\tab Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)\par
end\par
function c210280001.spop(e,tp,eg,ep,ev,re,r,rp)\par
\tab if e:GetHandler():IsRelateToEffect(e) then\par
\tab\tab Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)\par
\tab end\par
end\par
}
 
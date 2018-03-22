-- Foreboding Amassment
local function GetID(n)
  n=n or 2
  local t={}
  debug.getinfo(n,'S').source:gsub(".",function (v) table.insert(t,v) end)
  local r=""
  for i = (#t-4),1,-1 do
    if t[i]~='c' then
      r=t[i]..r
    else
      break
    end
  end
  return tonumber(r)
end

local id=GetID()
local ref=_G['c'..id]

local s=0x18
function ref.initial_effect(c)
  if not ref['data'] then
    ref['data']={}
    ref['data'][0]={}
    ref['data'][1]={}
  end
  -- Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCost(ref.s)
  e1:SetTarget(ref.t)
  e1:SetOperation(ref.o)
  c:RegisterEffect(e1)
end

-- Activate
function ref.s(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
  end
  local c=e:GetHandler()
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
  e1:SetReset(RESET_PHASE+PHASE_END)
  e1:SetTargetRange(1,0)
  Duel.RegisterEffect(e1,tp)
end

function ref.rf(c)
  local isWind=c:IsAttribute(ATTRIBUTE_WIND)
  local isWater=c:IsAttribute(ATTRIBUTE_WATER)
  local canReturn=c:IsAbleToDeck()

  return (isWind or isWater) and canReturn
end

function ref.f(c)
  local hasSet=c:IsSetCard(s)
  local isMonster=c:IsType(TYPE_MONSTER)
  local canAdd=c:IsAbleToHand()

  return hasSet and isMonster and canAdd
end

function ref.t(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    local canReturn=Duel.IsExistingMatchingCard(ref.rf,tp,LOCATION_HAND,0,1,nil)
    local canAdd=Duel.IsExistingMatchingCard(ref.f,tp,LOCATION_DECK,0,1,nil)

    return canReturn and canAdd
  end
  Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function ref.o(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local g=nil
  local n=nil
  if not ref.t(e,tp,eg,ep,ev,re,r,rp,0) then goto normal_summon end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  g=Duel.SelectMatchingCard(tp,ref.rf,tp,LOCATION_HAND,0,1,1,nil)
  if g:GetCount()<=0 then goto normal_summon end
  n=Duel.SendtoDeck(g,tp,0,REASON_EFFECT)
  if n<=0 then Duel.ShuffleDeck(tp) goto normal_summon end
  Duel.BreakEffect()
  g=Duel.SelectMatchingCard(tp,ref.f,tp,LOCATION_DECK,0,1,2,nil)
  if g:GetCount()<=0 then goto normal_summon end
  Duel.SendtoHand(g,tp,REASON_EFFECT)
  g=Duel.GetOperatedGroup()
  g=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
  Duel.ConfirmCards(1-tp,g)
  -- Additional Summon
::normal_summon::
  local ct=Duel.GetTurnCount()
  if Duel.GetTurnPlayer()~=tp then ct=ct-1 end
  local t=ref['data'][tp][ct] or 1
  t=t+1
  ref['data'][tp][ct]=t

  local reset={RESET_PHASE+PHASE_END+RESET_SELF_TURN,Duel.GetTurnPlayer()==tp and 2 or 1}
  local rs=function () return table.unpack(reset) end
  local lbl=(ct+(Duel.GetTurnPlayer()==tp and 2 or 1))
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetTargetRange(1,0)
  e1:SetLabel(ct)
  e1:SetReset(rs())
  e1:SetCondition(ref.nc)
  e1:SetValue(t)
  Duel.RegisterEffect(e1,tp)

  -- Restriction
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_CANNOT_SUMMON)
  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e2:SetTargetRange(1,0)
  e2:SetLabel(lbl)
  e2:SetReset(rs())
  e2:SetCondition(ref.rc)
  e2:SetTarget(aux.NOT(aux.TargetBoolFunction(Card.IsSetCard,s)))
  Duel.RegisterEffect(e2,tp)

  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_CANNOT_MSET)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e3:SetTargetRange(1,0)
  e3:SetLabel(lbl)
  e3:SetReset(rs())
  e3:SetCondition(aux.NOT(ref.nc))
  e3:SetTarget(aux.TRUE)
  Duel.RegisterEffect(e3,tp)
end

-- Additional Summon
function ref.nc(e)
  local ct=e:GetLabel()
  return Duel.GetTurnCount()~=ct
end

-- Restriction
function ref.rc(e)
  local ct=e:GetLabel()
  return ct==Duel.GetTurnCount()
end

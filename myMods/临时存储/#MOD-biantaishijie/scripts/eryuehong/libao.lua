
local _G = GLOBAL
local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH

local monster_cd = 120
local SpawnPrefab = GLOBAL.SpawnPrefab
local AllPlayers = GLOBAL.AllPlayers
local TheNet = GLOBAL.TheNet
local Vector3 = GLOBAL.Vector3
local PI = GLOBAL.PI
local next = GLOBAL.next
local lmb = "●"
local buff = "●BUFF●"

--chance:加权概率 base:基础值
local reward = {
  {prefab="dragonfruit",name="火龙果",chance=1.0,base=1},
  {prefab="berries",name="浆果",chance=1.0,base=1},
  {prefab="cactus_meat",name="仙人掌肉",chance=1.0,base=1},
  {prefab="mandrake",name="曼德拉草",chance=1.0,base=1},
  {prefab="goatmilk",name="电羊奶",chance=1.0,base=1},
  {prefab="meat",name="肉",chance=1.0,base=1},
  {prefab="humanmeat",name="人肉",chance=1.0,base=1},
  {prefab="fish",name="鱼",chance=1.0,base=1},
  {prefab="meat_dried",name="肉干",chance=1.0,base=1},
  {prefab="honeyham",name="蜜汁火腿",chance=1.0,base=1},
  {prefab="butterfly",name="蝴蝶",chance=1.0,base=1},
  {prefab="bee",name="蜜蜂",chance=1.0,base=1},
  {prefab="log",name="木材",chance=1.0,base=1},
  {prefab="twigs",name="树枝",chance=1.0,base=1},
  {prefab="cutgrass",name="割草",chance=1.0,base=1},
  {prefab="poop",name="便便",chance=1.0,base=1},
  {prefab="pigskin",name="猪皮",chance=1.0,base=1},
  {prefab="beefalowool",name="牛毛",chance=1.0,base=1},
  {prefab="manrabbit_tail",name="兔毛",chance=1.0,base=1},
  {prefab="livinglog",name="有生命的木材",chance=1.0,base=1},
  {prefab="papyrus",name="莎草纸",chance=1.0,base=1},
  {prefab="silk",name="蜘蛛网",chance=1.0,base=1},
  {prefab="gears",name="齿轮",chance=1.0,base=1},
  {prefab="marble",name="大理石",chance=1.0,base=1},
  {prefab="flint",name="燧石",chance=1.0,base=1},
  {prefab="nitre",name="硝石",chance=1.0,base=1},
  {prefab="rocks",name="岩石",chance=1.0,base=1},
  {prefab="goldnugget",name="金块",chance=1.0,base=1},
  {prefab="dug_sapling",name="树苗",chance=1.0,base=1},
  {prefab="dug_grass",name="长草簇",chance=1.0,base=1},
  {prefab="dug_berrybush",name="浆果灌木丛",chance=1.0,base=1},
  {prefab="nightmarefuel",name="噩梦燃料",chance=1.0,base=1},
  {prefab="redgem",name="红宝石",chance=1.0,base=1},
  {prefab="bluegem",name="蓝宝石",chance=1.0,base=1},
  {prefab="purplegem",name="紫宝石",chance=1.0,base=1},
  {prefab="orangegem",name="橙宝石",chance=1.0,base=1},
  {prefab="yellowgem",name="黄宝石",chance=1.0,base=1},
  {prefab="greengem",name="绿宝石",chance=1.0,base=1},
  {prefab="thulecite",name="铥矿石",chance=1.0,base=1},
  {prefab="thulecite_pieces",name="铥矿石碎片",chance=1.0,base=1},
}

--placed:是否放置在地面(建筑类和不可直接给予物品为true)
local reward_rare = {
  {prefab="krampus_sack",name="坎普斯背包",chance=1.0,base=1,placed=true},
  {prefab="pighouse",name="猪舍",chance=1.0,base=1,placed=true},
  {prefab="lureplant",name="肉球茎",chance=1.0,base=1,placed=true},
  {prefab="ancient_altar",name="远古遗迹",chance=1.0,base=1,placed=true},
  {prefab="dragon_scales",name="鳞片",chance=1.0,base=1,placed=false},
  {prefab="bearger_fur",name="厚皮毛",chance=1.0,base=1,placed=false},
  {prefab="minotaurhorn",name="守卫者的角",chance=1.0,base=1,placed=false},
  {prefab="deerclops_eyeball",name="巨鹿眼球",chance=1.0,base=1,placed=false},
  {prefab="multitool_axe_pickaxe",name="摘/斧头",chance=1.0,base=1,placed=false},
  {prefab="panflute",name="排箫",chance=1.0,base=1,placed=false},
  {prefab="greenamulet",name="建造护符",chance=1.0,base=1,placed=false},
  {prefab="rainhat",name="雨帽",chance=1.0,base=1,placed=false},
  {prefab="raincoat",name="雨衣",chance=1.0,base=1,placed=false},
  {prefab="walrushat",name="贝雷帽",chance=1.0,base=1,placed=false},
  {prefab="nightstick",name="晨星",chance=1.0,base=1,placed=false},
  {prefab="staff_tornado",name="旋风",chance=1.0,base=1,placed=false},
  {prefab="yellowstaff",name="星星呼唤者权杖",chance=1.0,base=1,placed=false},
  {prefab="ruinshat",name="铥矿石皇冠",chance=1.0,base=1,placed=false},
  {prefab="armorruins",name="铥矿甲胃",chance=1.0,base=1,placed=false},
  {prefab="armordragonfly",name="鳞甲",chance=1.0,base=1,placed=false},
  {prefab="eyebrellahat",name="眼球伞",chance=1.0,base=1,placed=false},
  {prefab="beargervest",name="熊皮背心",chance=1.0,base=1,placed=false},
}

local monster = {
  {prefab="moose",name="鹿角鸭",chance=1.0,base=0.3},
  {prefab="dragonfly",name="蜻蜓",chance=1.0,base=0.06},
  {prefab="bearger",name="比尔格",chance=1.0,base=0.3},
  {prefab="deerclops",name="独眼巨鹿",chance=1.0,base=0.3},
  {prefab="spat",name="钢羊",chance=1.0,base=0.2},
  {prefab="ghost",name="鬼魂",chance=1.0,base=3},
  {prefab="tallbird",name="高脚鸟",chance=1.0,base=1.5},
  {prefab="pigguard",name="猪人守卫",chance=1.0,base=3},
  {prefab="spiderqueen",name="蜘蛛女王",chance=1.0,base=0.8},
  {prefab="leif",name="树精守卫",chance=1.0,base=1},
  {prefab="beefalo",name="皮弗娄牛",chance=1.0,base=1.5},
  {prefab="lightninggoat",name="电羊",chance=1.0,base=1.5},
  {prefab="koalefant_summer",name="蓝象",chance=1.0,base=1.5},
  {prefab="koalefant_winter",name="蓝色象鼻怪",chance=1.0,base=1.5},
  {prefab="rook",name="机械战车",chance=1.0,base=0.8},
  {prefab="minotaur",name="远古守护者",chance=1.0,base=0.5},
  {prefab="worm",name="深渊蠕虫",chance=1.0,base=1},
  {prefab="monkey",name="暴躁猴",chance=1.0,base=2},
}

local function IsRandom(n)
  if math.random() < n then return true end
end

local function WeightedWeight(tables)
  local sum = 0
  for k,v in pairs(tables) do
    sum = sum + v.chance
  end
  local rnd = math.random()*sum
  for k,v in pairs(tables) do
    rnd = rnd - v.chance
    if rnd < 0 then
      return k
    end
  end
end

local function RandomPosition(x, y, z)
  local num = math.random(4)
  return x+num-1,y-num+2,z+num+1
end

local function IsDeath(inst)
  if inst and inst:HasTag("player") and inst:HasTag("playerghost") then
    return true
  end
end

local function Remove(inst)
  inst.updatetime = inst.updatetime-1
  if inst.updatetime <= 0 then
    inst:PushEvent("Removed")
    inst.updatetask:Cancel()
  end
end

local function Spawn(inst, res, count)
  local item = nil
  for i=1,count do
    item = SpawnPrefab(res.prefab)
    if item == nil then
      print("#------------------在线礼包出错："..res.name..res.prefab.."不存在------------------")
      return
    end
    if res.placed then
      item.Transform:SetPosition(RandomPosition(inst.Transform:GetWorldPosition()))
    else
      inst.components.inventory:GiveItem(item)
    end
  end
end

--以下几个怪物函数来自 小红猪 的怪物入侵 , (＞﹏＜)
--获取怪物要放置的位置
local function GetSpawnPoint(target)
  local pt = Vector3(target.Transform:GetWorldPosition())
  local theta = math.random() * 2 * PI
  local radius = math.random(8, 15)
  local result_offset = GLOBAL.FindValidPositionByFan(theta, radius, 20, function(offset)
    local pos = pt + offset
    local ents = GLOBAL.TheSim:FindEntities(pos.x, pos.y, pos.z, 1)
    return next(ents) == nil
  end)
  if result_offset ~= nil then
    local pos = pt + result_offset
    return pos
  end
end

--尝试放置怪物
local function TrySpawn(player, monster)
  local b = nil
  if player then
    local player_pt = Vector3(player.Transform:GetWorldPosition())
    local pt = GetSpawnPoint(player)
    if pt ~= nil then
      local tile = GLOBAL.TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
      local canspawn = tile ~= GLOBAL.GROUND.IMPASSABLE and tile ~= GLOBAL.GROUND.INVALID and tile ~= 255
      if canspawn then
        b = SpawnPrefab(monster)
        if b then
          b.Transform:SetPosition(pt:Get())
          if player_pt then
            b:FacePoint(player_pt)
          end
        end
        return b
      else
        b = TrySpawn(player, monster)
      end
    end
  end
  return b
end

--放置怪物
local function SpawnMonster(inst, mon, lv)
  local mob = TrySpawn(inst,mon.prefab)
  if mob == nil then
    print("#------------------在线礼包出错："..mon.name..mon.prefab.."不存在------------------")
    return
  end
  --设置生命值
  if lv <= 100 then
    mob.components.health:SetCurrentHealth(mob.components.health.maxhealth*lv*0.01)
  else
    mob.components.health:SetMaxHealth(mob.components.health.maxhealth*lv*0.01)
  end
  --戴帽子
  if mob.prefab == "pigman" or mob.prefab == "pigguard" or mob.prefab == "bunnyman" or mob.prefab == "merm" or mob.prefab == "monkey" then
    mob.AnimState:OverrideSymbol("swap_hat", "hat_walrus", "swap_hat")
    mob.AnimState:Show("HAT")
    mob.AnimState:Show("HAT_HAIR")
    mob.AnimState:Hide("HAIR_NOHAT")
    mob.AnimState:Hide("HAIR")
  end
  --设置光环
  local currentscale = mob.Transform:GetScale()
  local fx = SpawnPrefab("stafflight")
  fx.entity:SetParent(mob.entity)
  fx.Transform:SetPosition(0.2, 0.2, 0)
  fx.Transform:SetScale(currentscale*1.6,currentscale*1.6,currentscale*1.6)
  --设置击杀掉落
  if mob.components.lootdropper then
    if mob.components.lootdropper.loot then
      mob.components.lootdropper:SetLoot(nil)
    elseif mob.components.lootdropper.chanceloottable then
      mob.components.lootdropper:SetChanceLootTable(nil)
    end
    for i,v in pairs(reward_rare) do
      if not v.placed then
        mob.components.lootdropper:AddChanceLoot(v.prefab,v.base*0.08)
      end
    end
    local prefab = reward[WeightedWeight(reward)].prefab
    local num = math.random(8)+4
    for i=1,num do
      mob.components.lootdropper:AddChanceLoot(prefab,1)
    end
  end
  --锁定目标
  mob.components.combat:SuggestTarget(inst)
  --怪物定时自动删除
  --存档重启后怪物不会删除,不想改了@_@,本宝宝很懒的
  mob.updatetime = monster_cd
  mob.updatetask = mob:DoPeriodicTask(1, Remove)

  mob:ListenForEvent("Removed",function()
    SpawnPrefab("collapse_big").Transform:SetPosition(mob.Transform:GetWorldPosition())
    mob:Remove()
    --判断召唤者是否在本服务器
    if inst and inst.Transform:GetWorldPosition() and not IsDeath(inst) then
      inst.components.hunger:DoDelta(5-inst.components.hunger.current,1,true)
      inst.components.sanity:DoDelta(5-inst.components.sanity.current,1)
      inst.components.health:DoDelta(10-inst.components.health.currenthealth)
      SpawnPrefab("lightning").Transform:SetPosition(inst.Transform:GetWorldPosition())
      TheNet:Announce(inst:GetDisplayName().." 放跑了 "..lmb..mon.name..lmb.." , 惨遭天罚！")
    end
  end)

  --死亡
  mob:ListenForEvent("death", function()
    mob:DoTaskInTime(0.5, function(mob)
      if mob.components.talker then mob.components.talker:Say("你等着, 我还会回来的!") end
    end)
    if inst and inst.Transform:GetWorldPosition() and not IsDeath(inst) then
      inst.components.hunger:DoDelta(inst.components.hunger.max,1,true)
      inst.components.sanity:DoDelta(inst.components.sanity.max,1)
      inst.components.health:DoDelta(inst.components.health.maxhealth)
      TheNet:Announce(inst:GetDisplayName().." 击败了 "..lmb..mon.name..lmb.." 获得 : MAX.状态")
    end
  end)
  --怪物出场
  local x, y, z = mob.Transform:GetWorldPosition()
  SpawnPrefab("collapse_big").Transform:SetPosition(x, y, z)

  mob:DoTaskInTime(1, function(mob)
    if mob.components.talker then mob.components.talker:Say(inst:GetDisplayName().." , 本宝宝要宰了你!") end
  end)
end

local function GiveMonster(inst)
  local weight = WeightedWeight(monster)
  local day = inst.components.age:GetDisplayAgeInDays()
  local lv = math.ceil(monster[weight].base*(day*0.3+#AllPlayers*0.2+math.random(20)))
  lv = lv > 300 and 300 or lv
  local wait = math.random(TUNING.TOTAL_DAY_TIME)
  local tip = wait>20 and wait-20 or 1
  local rewardday = GLOBAL.TheWorld.state.cycles
  inst:DoTaskInTime(tip, function(inst)
    if rewardday == GLOBAL.TheWorld.state.cycles then
      local message = "[ 警告 ]"..inst:GetDisplayName().." : 一只"..lmb..monster[weight].name..lmb.." 即将前来复仇 ."
      TheNet:Announce(message)
      if inst.components.talker then inst.components.talker:Say("我感受到了恐惧的气息!") end
    end
  end)
  inst:DoTaskInTime(wait, function(inst)
    if not IsDeath(v) and rewardday == GLOBAL.TheWorld.state.cycles then
      SpawnMonster(inst,monster[weight],lv)
      local message = "[ 120秒限时击杀 ]"..inst:GetDisplayName().." : 击败 Lv."..lv..lmb..monster[weight].name..lmb.." 将获得丰厚奖励 ."
      TheNet:Announce(message)
      if inst.components.talker then inst.components.talker:Say("天啦噜, 好可怕的怪物!") end
    end
  end)
end

local function GiveBuff(inst)
  local weight = math.ceil(math.random()*7)
  local number = math.ceil(math.random(20)+5)
  local wait = math.random(TUNING.TOTAL_DAY_TIME*0.5)
  local rewardday = GLOBAL.TheWorld.state.cycles
  inst:DoTaskInTime(wait, function()
    if not IsDeath(v) and rewardday == GLOBAL.TheWorld.state.cycles then
      if weight == 1 then
        number = math.ceil(number * 1.2)
        inst.components.hunger:SetMax(inst.components.hunger.max+number)
        local message = inst:GetDisplayName().." 获得 "..buff.." : Lv."..number.." 饥饿"
        TheNet:Announce(message)
        if inst.components.talker then inst.components.talker:Say("我觉得当一个吃货蛮好的.") end
      elseif weight == 2 then
        number = math.ceil(number * 1.3)
        inst.components.sanity:SetMax(inst.components.sanity.max+number)
        local message = inst:GetDisplayName().."获得"..buff.." : Lv."..number.." 理智"
        TheNet:Announce(message)
        if inst.components.talker then inst.components.talker:Say("让我来解开宇宙的奥秘吧.") end
      elseif weight == 3 then
        number = math.ceil(number * 0.8)
        inst.components.health:SetMaxHealth(inst.components.health.maxhealth+number)
        local message = inst:GetDisplayName().."获得"..buff.." : Lv."..number.." 生命"
        TheNet:Announce(message)
        if inst.components.talker then inst.components.talker:Say("啊,多么伟大的生命.") end
      elseif weight == 4 then
        inst.components.hunger:DoDelta(inst.components.hunger.max,1,true)
        local message = inst:GetDisplayName().."获得"..buff.." : MAX.饥饿"
        TheNet:Announce(message)
        if inst.components.talker then inst.components.talker:Say("饥饿恢复了.") end
      elseif weight == 5 then
        inst.components.sanity:DoDelta(inst.components.sanity.max,1)
        local message = inst:GetDisplayName().."获得"..buff.." : MAX.理智"
        TheNet:Announce(message)
        if inst.components.talker then inst.components.talker:Say("理智恢复了.") end
      elseif weight == 6 then
        inst.components.health:DoDelta(inst.components.health.maxhealth)
        local message = inst:GetDisplayName().."获得"..buff.." : MAX.生命"
        TheNet:Announce(message)
        if inst.components.talker then inst.components.talker:Say("生命恢复了.") end
      elseif weight == 7 then
        number = math.ceil(number * 2.5)
        if inst.initstate == nil then
          inst.initstate = {}
        end
        inst.initstate["absorb"] = inst.components.health.absorb
        inst.initstate["maxtemp"] = inst.components.temperature.maxtemp
        inst.initstate["mintemp"] = inst.components.temperature.mintemp
        --护盾吸收
        inst.components.health.absorb = 0.8
        --恒温
        inst.components.temperature.maxtemp=40
        inst.components.temperature.mintemp=20
        inst:AddTag("forcefield")
        local fx = SpawnPrefab("forcefieldfx")
        fx.entity:SetParent(inst.entity)
        fx.Transform:SetPosition(0, 0.2, 0)
        local fx_hitanim = function()
          fx.AnimState:PlayAnimation("hit")
          fx.AnimState:PushAnimation("idle_loop")
        end
        fx:ListenForEvent("blocked", fx_hitanim, inst)
        inst.active = true
        inst:DoTaskInTime(number, function()
          fx:RemoveEventCallback("blocked", fx_hitanim, inst)
          fx.kill_fx(fx)
          if inst:IsValid() then
            --恢复正常状态
            inst.components.health.absorb = inst.initstate["absorb"]
            inst.components.temperature.maxtemp=inst.initstate["maxtemp"]
            inst.components.temperature.mintemp=inst.initstate["mintemp"]
            inst:RemoveTag("forcefield")
            inst:DoTaskInTime(1, function() inst.active = nil end)
          end
        end)
        local message = inst:GetDisplayName().."获得"..buff.." : Lv."..number.." 守护"
        TheNet:Announce(message)
        if inst.components.talker then inst.components.talker:Say("神之光环,冲啊.") end
      end
    end
  end)
end

local playerjointime = 0

AddComponentPostInit("playerspawner", function(OnPlayerSpawn, inst)
  inst:ListenForEvent("ms_playerspawn", function(inst, player)
    playerjointime=GLOBAL.GetTimeReal()
  end)

  inst:ListenForEvent("cycleschanged", function(inst, data)
    --避免cycleschanged误判
    if #AllPlayers == 0 or #AllPlayers == 1 and GLOBAL.GetTimeReal()-playerjointime <= 2000 then
      return
    end
    -- print("#------------------在线礼包------------------")
    local weight = WeightedWeight(reward)
    local isreward = false
    local monster_num = 0
    for k,v in ipairs(AllPlayers) do
      if v and v.components and not IsDeath(v) then
        local day = v.components.age:GetDisplayAgeInDays()
        if day <8 then
          local number = math.ceil(reward[weight].base*day*0.5)
          number = number > 10 and 10 or number
          Spawn(v,reward[weight],number)
          v:DoTaskInTime(0.5, function(v)
            local message = "获得 "..lmb.."在线礼包"..lmb.." : "..reward[weight].name.." * "..number
            if v.components.talker then v.components.talker:Say(message) end
          end)
          isreward = true
        elseif day % 10 == 0 then
          local weight_ = WeightedWeight(reward)
          local number = math.ceil((math.random()+0.1)*2*day*reward[weight].base)
          local rewardday = GLOBAL.TheWorld.state.cycles
          v:DoTaskInTime(1, function(v)
            Spawn(v,reward[weight_],number)
            local message = " 获得"..lmb..day.."天大礼包"..lmb.." : "..reward[weight_].name.." * "..number
            if v.components.talker then v.components.talker:Say(message) end
            TheNet:Announce(v:GetDisplayName()..message)
          end)
        elseif monster_cd ~=0 and monster_num <= 2 and day > 10 and IsRandom(day*0.01) then
          monster_num=monster_num+1
          GiveMonster(v)
        elseif day > 12 and IsRandom(day*0.015) then
          local weight_ = WeightedWeight(reward_rare)
          local wait = math.random(TUNING.TOTAL_DAY_TIME)
          local rewardday = GLOBAL.TheWorld.state.cycles
          v:DoTaskInTime(wait, function(v)
            if not IsDeath(v) and rewardday == GLOBAL.TheWorld.state.cycles then
              Spawn(v,reward_rare[weight_],1)
              local message = " 获得"..lmb.."神器礼包"..lmb.." : "..reward_rare[weight_].name.." * 1"
              if v.components.talker then v.components.talker:Say(message) end
              TheNet:Announce(v:GetDisplayName()..message)
            end
          end)
        elseif  IsRandom(day*0.03) then
          GiveBuff(v)
        else
          local number = math.ceil(reward[weight].base*day*0.6)
          number = number > 15 and 15 or number
          Spawn(v,reward[weight],number)
          v:DoTaskInTime(0.5, function(v)
            local message = "获得 "..lmb.."在线礼包"..lmb.." : "..reward[weight].name.." * "..number
            if v.components.talker then v.components.talker:Say(message) end
          end)
          isreward = true
        end
      end
    end
    if isreward then
      worldname = "地面"
      if GLOBAL.TheWorld.worldprefab == "cave" then worldname = "洞穴" end
      TheNet:Announce(worldname.."：幸运饥友获得 "..lmb.."在线礼包"..lmb.." : "..reward[weight].name)
    end
  end)
end)

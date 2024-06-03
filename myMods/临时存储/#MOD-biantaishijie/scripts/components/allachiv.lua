local allachiv = Class(function(self, inst)
    self.inst = inst
    self.intogame = false
    self.firsteat = false
    self.supereat = false
    self.eatamount = 0
    self.danding = false
    self.eatmonsterlasagna = 0
    self.messiah = false
    self.respawnamount = 0
    self.walktime = 0
    self.stoptime = 0
    self.walkalot = false
    self.stopalot = false
    self.tooyoung = false
    self.evil = false
    self.evilamount = 0
    self.snake = false
    self.deathalot = false
    self.deathamouth = 0
    self.nosanity = false
    self.nosanitytime = 0
    self.sick = false
    self.coldblood = false
    self.snakeamount = 0
    self.burn = false
    self.freeze = false
    self.goodman = false
    self.brother = false
    self.friendpig = 0
    self.friendbunny = 0
    self.fishmaster = false
    self.fishamount = 0
    self.pickmaster = false
    self.pickamount = 0
    self.chopmaster = false
    self.chopamount = 0
    self.noob = false
    self.cookmaster = false
    self.cookamount = 0
    self.longage = false
    self.luck = false
    self.black = false
    self.buildmaster = false
    self.buildamount = 0
    self.tank = false
    self.angry = false
    self.attackeddamage = 0
    self.onhitdamage = 0
    self.icebody = false
    self.firebody = false
    self.icetime = 0
    self.firetime = 0
    self.rigid = false
    self.ancient = false
    self.queen = false
    self.bosswinter = false
    self.bossspring = false
    self.bossdragonfly = false
    self.bossautumn = false
    self.king = false
    self.all = false

    self.hungermax = 0
    self.healthmax = 0
    self.speedcheck = 0
    self.hungerrate = 0
    self.sanitymax = 0
    self.hoti = -1
    self.coldi = -1
    self.fishtimemin = 4
    self.fishtimemax = 40
    self.absorb = 3.1415
    self.damagemul = 3.1415
    self.maxMoistureRate = 3.1415
end)

--载入
function allachiv:OnSave()
    local data = {
        intogame = self.intogame,
        firsteat = self.firsteat,
        supereat = self.supereat,
        eatamount = self.eatamount,
        danding = self.danding,
        eatmonsterlasagna = self.eatmonsterlasagna,
        messiah = self.messiah,
        respawnamount = self.respawnamount,
        walktime = self.walktime,
        stoptime = self.stoptime,
        walkalot = self.walkalot,
        stopalot = self.stopalot,
        tooyoung = self.tooyoung,
        evil = self.evil,
        evilamount = self.evilamount,
        snake = self.snake,
        deathalot = self.deathalot,
        deathamouth = self.deathamouth,
        nosanity = self.nosanity,
        nosanitytime = self.nosanitytime,
        sick = self.sick,
        coldblood = self.coldblood,
        snakeamount = self.snakeamount,
        burn = self.burn,
        freeze = self.freeze,
        goodman = self.goodman,
        brother = self.brother,
        friendpig = self.friendpig,
        friendbunny = self.friendbunny,
        fishmaster = self.fishmaster,
        fishamount = self.fishamount,
        pickmaster = self.pickmaster,
        pickamount = self.pickamount,
        chopmaster = self.chopmaster,
        chopamount = self.chopamount,
        noob = self.noob,
        cookmaster = self.cookmaster,
        cookamount = self.cookamount,
        longage = self.longage,
        luck = self.luck,
        black = self.black,
        buildmaster = self.buildmaster,
        buildamount = self.buildamount,
        tank = self.tank,
        angry = self.angry,
        attackeddamage = self.attackeddamage,
        onhitdamage = self.onhitdamage,
        icebody = self.icebody,
        firebody = self.firebody,
        icetime = self.icetime,
        firetime = self.firetime,
        rigid = self.rigid,
        ancient = self.ancient,
        queen = self.queen,
        bosswinter = self.bosswinter,
        bossspring = self.bossspring,
        bossdragonfly = self.bossdragonfly,
        bossautumn = self.bossautumn,
        king = self.king,
        all = self.all,
    }
    return data
end

--保存
function allachiv:OnLoad(data)
    self.intogame = data.intogame or false
    self.firsteat = data.firsteat or false
    self.supereat = data.supereat or false
    self.eatamount = data.eatamount or 0
    self.danding = data.danding or false
    self.eatmonsterlasagna = data.eatmonsterlasagna or 0
    self.messiah = data.messiah or false
    self.respawnamount = data.respawnamount or 0
    self.walktime = data.walktime or 0
    self.stoptime = data.stoptime or 0
    self.walkalot = data.walkalot or false
    self.stopalot = data.stopalot or false
    self.tooyoung = data.tooyoung or false
    self.evil = data.evil or false
    self.evilamount = data.evilamount or 0
    self.snake = data.snake or false
    self.deathalot = data.deathalot or false
    self.deathamouth = data.deathamouth or 0
    self.nosanity = data.nosanity or false
    self.nosanitytime = data.nosanitytime or 0
    self.sick = data.sick or false
    self.coldblood = data.coldblood or false
    self.snakeamount = data.snakeamount or 0
    self.burn = data.burn or false
    self.freeze = data.freeze or false
    self.goodman = data.goodman or false
    self.brother = data.brother or false
    self.friendpig = data.friendpig or 0
    self.friendbunny = data.friendbunny or 0
    self.fishmaster = data.fishmaster or false
    self.fishamount = data.fishamount or 0
    self.pickmaster = data.pickmaster or false
    self.pickamount = data.pickamount or 0
    self.chopmaster = data.chopmaster or false
    self.chopamount = data.chopamount or 0
    self.noob = data.noob or false
    self.cookmaster = data.cookmaster or false
    self.cookamount = data.cookamount or 0
    self.longage = data.longage or false
    self.luck = data.luck or false
    self.black = data.black or false
    self.buildmaster = data.buildmaster or false
    self.buildamount = data.buildamount or 0
    self.tank = data.tank or false
    self.angry = data.angry or false
    self.attackeddamage = data.attackeddamage or 0
    self.onhitdamage = data.onhitdamage or 0
    self.icebody = data.icebody or false
    self.firebody = data.firebody or false
    self.icetime = data.icetime or 0
    self.firetime = data.firetime or 0
    self.rigid = data.rigid or false
    self.ancient = data.ancient or false
    self.queen = data.queen or false
    self.bosswinter = data.bosswinter or false
    self.bossspring = data.bossspring or false
    self.bossdragonfly = data.bossdragonfly or false
    self.bossautumn = data.bossautumn or false
    self.king = data.king or false
    self.all = data.all or false
end

--通用效果器
function allachiv:seffc(inst, tag)
    -----SpawnPrefab("seffc").entity:SetParent(self.inst.entity)
    local str0 = STRINGS.ALLACHIVCURRENCY
    local strname = STRINGS.ALLACHIVNAME
    local strinfo = STRINGS.ALLACHIVINFO
    local strcoin = STRINGS.ALLACHIVCOIN
    TheNet:Announce(inst:GetDisplayName().."   "..strinfo[tag]..str0[3]..str0[1]..strname[tag]..str0[2])
    inst.components.talker:Say(str0[1]..strname[tag]..str0[2].."\n".."("..strinfo[tag]..")")
    inst:DoTaskInTime(2.5, function()
        inst.components.talker:Say(str0[1]..strname[tag]..str0[2].."\n"..strcoin[tag])
    end)
end

--新的开始
function allachiv:intogamefn(inst)
    inst:DoTaskInTime(60, function()
        if self.intogame ~= true then
            self.intogame = true
            self:seffc(inst, "intogame")

            inst:DoTaskInTime(2.5, function()
                local item2 = SpawnPrefab("torch")
                inst.components.inventory:GiveItem(item2, nil, inst:GetPosition())
                local item4 = SpawnPrefab("armorwood")
                inst.components.inventory:GiveItem(item4, nil, inst:GetPosition())
                local item1 = SpawnPrefab("lucky_goldnugget")
                item1.components.stackable:SetStackSize(10)
                inst.components.inventory:GiveItem(item1, nil, inst:GetPosition())
            end)
        end
    end)
end

--吃东西
function allachiv:eatfn(inst)
    inst:DoTaskInTime(1, function()
        local oldeatfn = inst.components.eater.oneatfn
        function inst.components.eater.oneatfn(inst, food)
            --第一口饭
            if self.firsteat ~= true then
                self.firsteat = true
                self:seffc(inst, "firsteat")
                local hunger_percent = inst.components.hunger:GetPercent()
                inst.components.hunger:SetMax(inst.components.hunger.max + allachiv_coindata["firsteat"])
                inst.components.hunger:SetPercent(hunger_percent)
                self.hungermax = inst.components.hunger.max
            end

            --美食家
            if self.supereat ~= true then
                self.eatamount = self.eatamount + 1
                if self.eatamount >= allachiv_eventdata["supereat"] then
                    self.supereat = true
                    self:seffc(inst, "supereat")
                    local hunger_percent = inst.components.hunger:GetPercent()
                    inst.components.hunger:SetMax(inst.components.hunger.max + allachiv_coindata["supereat"])
                    inst.components.hunger:SetPercent(hunger_percent)
                    self.hungermax = inst.components.hunger.max
                end
            end

            --我的内心毫无波动
            if self.danding ~= true and food.prefab == "monsterlasagna" then
                self.eatmonsterlasagna = self.eatmonsterlasagna + 1
                if self.eatmonsterlasagna >= allachiv_eventdata["danding"] then
                    self.danding = true
                    self:seffc(inst, "danding")
                    local health_percent = inst.components.health:GetPercent()
                    inst.components.health:SetMaxHealth(inst.components.health.maxhealth + allachiv_coindata["danding"])
                    inst.components.health:SetPercent(health_percent)
                    self.healthmax = inst.components.health.maxhealth
                end
            end
            if oldeatfn ~= nil then
                oldeatfn(inst, food)
            end
        end
    end)
end

--行走
function allachiv:onwalkfn(inst)
    inst:DoPeriodicTask(1, function()
        if inst:HasTag("playerghost") then return end
        if inst.components.locomotor.wantstomoveforward then
            --生命在于运动
            if self.walkalot ~= true then
                self.walktime = self.walktime + 1
                if self.walktime >= allachiv_eventdata["walkalot"] then
                    self.walkalot = true
                    self:seffc(inst, "walkalot")
                    inst.components.locomotor.externalspeedmultiplier = inst.components.locomotor.externalspeedmultiplier + allachiv_coindata["walkalot"]
                    self.speedcheck = inst.components.locomotor.externalspeedmultiplier
                end
            end
        else
            --我只是懒
            if self.stopalot ~= true then
                self.stoptime = self.stoptime + 1
                if self.stoptime >= allachiv_eventdata["stopalot"] then
                    self.stopalot = true
                    self:seffc(inst, "stopalot")
                    inst.components.hunger.hungerrate = inst.components.hunger.hungerrate * (1 - allachiv_coindata["stopalot"])
                    self.hungerrate = inst.components.hunger.hungerrate
                end
            end
        end
    end)
end

--萌新微光
function allachiv:nooblight(inst)
    if self.noob == true then
        inst._nooblight = SpawnPrefab("minerhatlight")
        inst._nooblight.Light:SetRadius(.6)
        inst._nooblight.Light:SetFalloff(1)
        inst._nooblight.Light:SetIntensity(.5)
        inst._nooblight.Light:SetColour(75/255, 75/255, 75/255)
        inst._nooblight.entity:SetParent(inst.entity)
    end
end

--非酋免疫
function allachiv:toblack(inst)
    --免疫潮湿和闪电
    if self.black == true then
        inst.components.moisture.maxMoistureRate = 0
        self.maxMoistureRate = inst.components.moisture.maxMoistureRate
        inst:RemoveTag("lightningtarget")
    end
end

--被击杀
function allachiv:onkilled(inst)
    inst:ListenForEvent("death", function(inst, data)
        local attacker = inst.components.combat.lastattacker
        --你对力量一无所知
        if attacker and attacker.prefab and attacker:IsValid() and self.tooyoung ~= true then
            if attacker.prefab == "flint"
            or attacker.prefab == "rocks"
            or attacker.prefab == "redgem"
            or attacker.prefab == "bluegem"
            or attacker.prefab == "goldnugget"
            or attacker.prefab == "nitre"
            or attacker.prefab == "marble" then
                inst:DoTaskInTime(2, function()
                    self.tooyoung = true
                    self:seffc(inst, "tooyoung")
                    inst.components.locomotor.externalspeedmultiplier = inst.components.locomotor.externalspeedmultiplier + allachiv_coindata["tooyoung"]
                    self.speedcheck = inst.components.locomotor.externalspeedmultiplier
                end)
            end
        end
        --超鬼
        if self.deathalot ~= true then
            self.deathamouth = self.deathamouth + 1
            if self.deathamouth >= allachiv_eventdata["deathalot"] then
                inst:DoTaskInTime(2, function()
                    self.deathalot = true
                    self:seffc(inst, "deathalot")
                    self:healthregen(inst)
                end)
            end
        end
        --死于黑暗
        if data and data.cause and data.cause == "NIL" and self.noob ~= true then
            inst:DoTaskInTime(2, function()
                self.noob = true
                self:seffc(inst, "noob")
                self:nooblight(inst)
            end)
        end
        --死于闪电
        if data and data.cause and data.cause == "lightning" and self.black ~= true then
            inst:DoTaskInTime(2, function()
                self.black = true
                self:seffc(inst, "black")
                self:toblack(inst)
            end)
        end
    end)
end

--自动回血
function allachiv:healthregen(inst)
    if self.deathalot == true then
        inst:DoPeriodicTask(2, function()
            if inst
            and inst.components.health
            and inst.components.health.currenthealth < inst.components.health.maxhealth
            and inst.components.health.currenthealth > 0
            then
                inst.components.health:DoDelta(allachiv_coindata["deathalot"])
            end
        end)
    end
end

--自动回脑
function allachiv:sanityregen(inst)
    if self.nosanity == true then
        inst:DoPeriodicTask(5, function()
            if inst
            and inst.components.sanity
            and inst.components.sanity.current < inst.components.sanity.max
            and inst.components.health
            and inst.components.health.currenthealth > 0
            then
                inst.components.sanity:DoDelta(allachiv_coindata["nosanity"])
            end
        end)
    end
end

--人工智障
function allachiv:sanitycheck(inst)
    if self.nosanity ~= true then
        inst:DoPeriodicTask(1, function()
            if inst.components.sanity.current < 1 and self.nosanity ~= true and inst.components.health.currenthealth > 0 then
                self.nosanitytime = self.nosanitytime + 1
                if self.nosanitytime >= allachiv_eventdata["nosanity"] then
                    self.nosanity = true
                    self:seffc(inst, "nosanity")
                    self:sanityregen(inst)
                end
            end
        end)
    end
end

--击杀单位
function allachiv:onkilledother(inst)
    inst:ListenForEvent("killed", function(inst, data)
        local victim = data.victim
        --击杀格罗姆
        if victim and victim.prefab == "glommer" and self.sick ~= true then
            self.sick = true
            self:seffc(inst, "sick")
            local sanity_percent = inst.components.sanity:GetPercent()
            inst.components.sanity:SetMax(inst.components.sanity.max + allachiv_coindata["sick"])
            inst.components.sanity:SetPercent(sanity_percent)
            self.sanitymax = inst.components.sanity.max
        end
        --击杀小切
        if victim and victim.prefab == "chester" and self.coldblood ~= true then
            self.coldblood = true
            self:seffc(inst, "coldblood")
            local sanity_percent = inst.components.sanity:GetPercent()
            inst.components.sanity:SetMax(inst.components.sanity.max + allachiv_coindata["coldblood"])
            inst.components.sanity:SetPercent(sanity_percent)
            self.sanitymax = inst.components.sanity.max
        end
        --击杀触手
        if victim and victim.prefab == "tentacle" and self.snake ~= true then
            self.snakeamount = self.snakeamount + 1
            if self.snakeamount >= allachiv_eventdata["snake"] then
                self.snake = true
                self:seffc(inst, "snake")
                inst.components.locomotor.externalspeedmultiplier = inst.components.locomotor.externalspeedmultiplier + allachiv_coindata["snake"]
                self.speedcheck = inst.components.locomotor.externalspeedmultiplier
            end
        end
        --击杀小偷掉落小偷包
        if victim and victim.prefab == "krampus" and self.luck ~= true then
            local pos = Vector3(victim.Transform:GetWorldPosition())
            inst:DoTaskInTime(.1, function()
                local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 3)
                for k,v in pairs(ents) do
                    if v.prefab == "krampus_sack" and v.components.inventoryitem.owner == nil then
                        self.luck = true
                    end
                end
                if self.luck == true then
                    self:seffc(inst, "luck")
                end
            end)
        end
        --双倍掉落
        if self.luck and victim.components.lootdropper then
            if victim.components.freezable or victim:HasTag("monster") then
                victim.components.lootdropper:DropLoot()
            end
        end
        --击杀暗黑毒蕈
        if victim and victim.prefab == "toadstool_dark" and self.rigid ~= true then
            self.rigid = true
            self:seffc(inst, "rigid")
            inst.components.health.absorb = inst.components.health.absorb + allachiv_coindata["rigid"]
            self.absorb = inst.components.health.absorb
        end
        --击杀远古骨魔
        if victim and victim.prefab == "stalker_atrium" and self.ancient ~= true then
            self.ancient = true
            self:seffc(inst, "ancient")
            inst.components.combat.damagemultiplier = inst.components.combat.damagemultiplier + allachiv_coindata["ancient"]
            self.damagemul = inst.components.combat.damagemultiplier
        end
        --击杀女王蜂
        if victim and victim.prefab == "beequeen" and self.queen ~= true then
            self.queen = true
            self:seffc(inst, "queen")
        end
        --击杀四季boss
        if self.king ~= true then
            if victim and victim.prefab == "deerclops" and self.bosswinter ~= true then
                self.bosswinter = true
            end
            if victim and victim.prefab == "moose" and self.bossspring ~= true then
                self.bossspring = true
            end
            if victim and victim.prefab == "dragonfly" and self.dragonfly ~= true then
                self.dragonfly = true
            end
            if victim and victim.prefab == "bearger" and self.bossautumn ~= true then
                self.bossautumn = true
            end
            if self.bosswinter and self.bossspring and self.dragonfly and self.bossautumn then
                self.king = true
                self:seffc(inst, "king")
                self:achiveking(inst)
                inst:DoTaskInTime(2.5, function()
                    local item1 = SpawnPrefab("redmooneye")
                    inst.components.inventory:GiveItem(item1, nil, inst:GetPosition())
                    local item2 = SpawnPrefab("bluemooneye")
                    inst.components.inventory:GiveItem(item2, nil, inst:GetPosition())
                end)
            end
        end
    end)
end

--着火冰冻
function allachiv:burnorfreeze(inst)
    inst:ListenForEvent("onignite", function(inst)
        if self.burn ~= true then
            self.burn = true
            self:seffc(inst, "burn")
            inst.components.temperature.inherentsummerinsulation = inst.components.temperature.inherentsummerinsulation + allachiv_coindata["burn"]
            self.hoti = inst.components.temperature.inherentsummerinsulation
        end
    end)
    inst:ListenForEvent("freeze", function(inst)
        if self.freeze ~= true then
            self.freeze = true
            self:seffc(inst, "freeze")
            inst.components.temperature.inherentinsulation = inst.components.temperature.inherentinsulation + allachiv_coindata["freeze"]
            self.coldi = inst.components.temperature.inherentinsulation
        end
    end)
end

--自动交朋友
function allachiv:autofriend(inst)
    if self.goodman then
        inst:DoPeriodicTask(1, function()
            local pos = Vector3(inst.Transform:GetWorldPosition())
            local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 6)
            for k,v in pairs(ents) do
                if v.prefab and v.prefab == "pigman"
                and v.components.follower.leader == nil
                and not v:HasTag("werepig")
                and not v:HasTag("guard") then
                    if v.components.combat:TargetIs(inst) then
                        v.components.combat:SetTarget(nil)
                    end
                    inst.components.leader:AddFollower(v)
                end
            end
        end)
    end

    if self.brother then
        inst:DoPeriodicTask(1, function()
            local pos = Vector3(inst.Transform:GetWorldPosition())
            local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 6)
            for k,v in pairs(ents) do
                if v.prefab and v.prefab == "bunnyman" and v.components.follower.leader == nil then
                    if v.components.combat:TargetIs(inst) then
                        v.components.combat:SetTarget(nil)
                    end
                    inst.components.leader:AddFollower(v)
                end
            end
        end)
    end
end

--交朋友
function allachiv:makefriend(inst)
    function inst.components.leader:AddFollower(follower)
        if self.followers[follower] == nil and follower.components.follower ~= nil then
            local achiv = inst.components.allachiv
            if follower.prefab == "pigman" and achiv.goodman ~= true then
                achiv.friendpig = achiv.friendpig + 1
                if achiv.friendpig >= allachiv_eventdata["goodman"] then
                    achiv.goodman = true
                    achiv:seffc(inst, "goodman")
                    achiv:autofriend(inst)
                end
            end
            if follower.prefab == "bunnyman" and achiv.brother ~= true then
                achiv.friendbunny = achiv.friendbunny + 1
                if achiv.friendbunny >= allachiv_eventdata["brother"] then
                    achiv.brother = true
                    achiv:seffc(inst, "brother")
                    achiv:autofriend(inst)
                end
            end
            if follower.prefab == "mandrake_active" and achiv.evil ~= true and not TheWorld.components.worldstate.data.isday then
                achiv.evilamount = achiv.evilamount + 1
                if achiv.evilamount >= allachiv_eventdata["evil"] then
                    achiv.evil = true
                    achiv:seffc(inst, "evil")
                    inst.components.locomotor.externalspeedmultiplier = inst.components.locomotor.externalspeedmultiplier + allachiv_coindata["evil"]
                    self.speedcheck = inst.components.locomotor.externalspeedmultiplier
                end
            end

            self.followers[follower] = true
            self.numfollowers = self.numfollowers + 1
            follower.components.follower:SetLeader(self.inst)
            follower:PushEvent("startfollowing", { leader = self.inst })

            if not follower.components.follower.keepdeadleader then
                self.inst:ListenForEvent("death", self._onfollowerdied, follower)
            end

            self.inst:ListenForEvent("onremove", self._onfollowerremoved, follower)

            if self.inst:HasTag("player") and follower.prefab ~= nil then
                ProfileStatsAdd("befriend_"..follower.prefab)
            end
        end
    end
end

--修改鱼竿和判断是否装备绿护符
function allachiv:fastfishing(inst)
    inst:ListenForEvent("equip", function(inst, data)
        if data.item.components.fishingrod and self.fishmaster then
            self.fishtimemin = data.item.components.fishingrod.minwaittime
            self.fishtimemax = data.item.components.fishingrod.maxwaittime
            data.item.components.fishingrod:SetWaitTimes(1, 1)
        end
        if data.item.prefab == "greenamulet" and self.buildmaster then
            inst.components.builder.ingredientmod = .5
        end
    end)
    inst:ListenForEvent("unequip", function(inst, data)
       -- if data.item.components.fishingrod and self.fishmaster then
            --data.item.components.fishingrod:SetWaitTimes(self.fishtimemin, self.fishtimemax)
      --  end
       -- if data.item.prefab == "greenamulet" and self.buildmaster then
           -- inst.components.builder.ingredientmod = .5
      --  end
    end)
end

--钓鱼达人
function allachiv:onhook(inst)
    inst:ListenForEvent("fishingstrain", function()
        if self.fishmaster ~= true then
            self.fishamount = self.fishamount + 1
            if self.fishamount >= allachiv_eventdata["fishmaster"] then
                self.fishmaster = true
                self:seffc(inst, "fishmaster")
                local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                if item and item.prefab == "fishingrod" then
                    self.fishtimemin = item.components.fishingrod.minwaittime
                    self.fishtimemax = item.components.fishingrod.maxwaittime
                    item.components.fishingrod:SetWaitTimes(1, 1)
                end
            end
        end
    end)
end

--捡垃圾
function allachiv:onpick(inst)
    inst:ListenForEvent("picksomething", function(inst, data)
        if data.object and data.object.components.pickable then
            --拾荒者
            if self.pickmaster ~= true then
                self.pickamount = self.pickamount + 1
                if self.pickamount >= allachiv_eventdata["pickmaster"] then
                    self.pickmaster = true
                    self:seffc(inst, "pickmaster")
                end
            end
            if self.pickmaster then
                if data.object.components.pickable.product ~= nil then
                    local item = SpawnPrefab(data.object.components.pickable.product)
                    if item.components.stackable then
                        item.components.stackable:SetStackSize(data.object.components.pickable.numtoharvest)
                    end
                    inst.components.inventory:GiveItem(item, nil, data.object:GetPosition())
                end
            end
        end
    end)
end

--超级砍树
function allachiv:chopper(inst)
    inst:ListenForEvent("finishedwork", function(inst, data)
        if data.target and data.target:HasTag("tree") then
            if self.chopmaster ~= true then
                self.chopamount = self.chopamount + 1
                if self.chopamount >= allachiv_eventdata["chopmaster"] then
                    self.chopmaster = true
                    self:seffc(inst, "chopmaster")
                end
            end
        end
    end)
    inst:ListenForEvent("working", function(inst, data)
        if data.target and data.target:HasTag("tree") and self.chopmaster then
            local workable = data.target.components.workable
            if workable.workleft >= 1 then
                if workable.onfinish then
                    workable.workleft = 0
                end
            end
        end
    end)
end

--秒煮
function allachiv:cook(inst)
    local COOK = ACTIONS.COOK
    local old_cook_fn = COOK.fn
    COOK.fn = function(act, ...)
        local result = old_cook_fn(act)
        local stewer = act.target.components.stewer
        local allachiv = act.doer.components.allachiv
        if result and stewer ~= nil then
            if allachiv.cookmaster ~= true then
                allachiv.cookamount = allachiv.cookamount + 1
                if allachiv.cookamount >= allachiv_eventdata["cookmaster"] then
                    allachiv.cookmaster = true
                    allachiv:seffc(inst, "cookmaster")
                end
            else
                local fn = stewer.task.fn
                stewer.task:Cancel()
                fn(act.target, stewer)
            end
        end
    end
end

--救活
--[[function allachiv:respawn(inst)
    inst:ListenForEvent("respawnfromghost", function(inst, data)
        if data.user and data.user.components.allachiv then
            local allachiv = data.user.components.allachiv
            if allachiv.messiah ~= true then
                allachiv.respawnamount = allachiv.respawnamount + 1
                if allachiv.respawnamount >= allachiv_eventdata["messiah"] then
                    allachiv.messiah = true
                    allachiv:seffc(data.user, "messiah")
                    local health_percent = data.user.components.health:GetPercent()
                    data.user.components.health:SetMaxHealth(data.user.components.health.maxhealth + allachiv_coindata["messiah"])
                    data.user.components.health:SetPercent(health_percent)
                    allachiv.healthmax = data.user.components.health.maxhealth
                end
            end
        end
    end)
end]]

--身上反鲜
function allachiv:refresh(inst)
    if self.longage == true then
        inst:DoPeriodicTask(1, function()
            --物品栏反鲜
            for k,v in pairs(inst.components.inventory.itemslots) do
                if v and v.components.perishable then
                    v.components.perishable:ReducePercent(-.02)
                end
            end
            --装备栏反鲜
            for k,v in pairs(inst.components.inventory.equipslots) do
                if v and v.components.perishable then
                    v.components.perishable:ReducePercent(-.02)
                end
            end
            --背包反鲜
            for k,v in pairs(inst.components.inventory.opencontainers) do
                if k and k:HasTag("backpack") and k.components.container then
                    for i,j in pairs(k.components.container.slots) do
                        if j and j.components.perishable then
                            j.components.perishable:ReducePercent(-.02)
                        end
                    end
                end
            end
            
        end)
    end
end

--光阴似箭
function allachiv:ontimepass(inst)
    inst:DoPeriodicTask(5, function(inst)
        if self.longage ~= true then
            local age = math.ceil(inst.components.age:GetAge() / TUNING.TOTAL_DAY_TIME)
            if age >= allachiv_eventdata["longage"] then
                self.longage = true
                self:seffc(inst, "longage")
                self:refresh(inst)
            end
        end
    end)
end

--巧夺天工
function allachiv:onbuild(inst)
    inst:ListenForEvent("consumeingredients", function(inst)
        if self.buildmaster ~= true then
            self.buildamount = self.buildamount + 1
            if self.buildamount >= allachiv_eventdata["buildmaster"] then
                self.buildmaster = true
                self:seffc(inst, "buildmaster")
                inst.components.builder.ingredientmod = inst.components.builder.ingredientmod / 2
            end
        end
    end)
end

--人形坦克
function allachiv:onattacked(inst)
    inst:ListenForEvent("attacked", function(inst, data)
        if self.tank ~= true then
            if data.damage then
                self.attackeddamage = self.attackeddamage + data.damage
            end
            if self.attackeddamage >= allachiv_eventdata["tank"] then
                self.tank = true
                self:seffc(inst, "tank")
                inst.components.health.absorb = inst.components.health.absorb + allachiv_coindata["tank"]
                self.absorb = inst.components.health.absorb
            end
        end
    end)
end

--超凶&暴击奖励
function allachiv:hitother(inst)
    inst:ListenForEvent("onhitother", function(inst, data)
        if self.angry ~= true then
            if data.damage then
                self.onhitdamage = self.onhitdamage + data.damage
            end
            if self.onhitdamage >= allachiv_eventdata["angry"] then
                self.angry = true
                self:seffc(inst, "angry")
                inst.components.combat.damagemultiplier = inst.components.combat.damagemultiplier + allachiv_coindata["angry"]
                self.damagemul = inst.components.combat.damagemultiplier
            end
        end
        if self.queen == true then
            local chance = allachiv_coindata["queen"]
            local damage = data.damage
            local target = data.target
            if target and math.random(1,100) <= chance and not target:HasTag("wall") then
                target.components.combat:GetAttacked(inst, damage)
                local snap = SpawnPrefab("impact")
                snap.Transform:SetScale(3, 3, 3)
                snap.Transform:SetPosition(target.Transform:GetWorldPosition())
                if target.SoundEmitter ~= nil then
                    target.SoundEmitter:PlaySound("dontstarve/common/whip_large")
                end
            end
        end
    end)
end

--冰霜/熔岩体质奖励
function allachiv:temperaturecoin(inst)
    if self.icebody == true then
        inst.components.temperature.mintemp = 5
    end
    if self.firebody == true then
        inst.components.temperature.maxtemp = 65
    end
end

--冰霜/熔岩体质
function allachiv:ontemperature(inst)
    if self.icebody ~= true then
        inst:DoPeriodicTask(1, function()
            if inst.components.temperature.current <= 0
            and self.icebody ~= true
            and inst.components.health.currenthealth > 0 then
                self.icetime = self.icetime + 1
                if self.icetime >= allachiv_eventdata["icebody"] then
                    self.icebody = true
                    self:seffc(inst, "icebody")
                    self:temperaturecoin(inst)
                end
            end
        end)
    end
    if self.firebody ~= true then
        inst:DoPeriodicTask(1, function()
            if inst.components.temperature.current >= 70
            and self.firebody ~= true
            and inst.components.health.currenthealth > 0 then
                self.firetime = self.firetime + 1
                if self.firetime >= allachiv_eventdata["firebody"] then
                    self.firebody = true
                    self:seffc(inst, "firebody")
                    self:temperaturecoin(inst)
                end
            end
        end)
    end
end

--无名王者
function allachiv:achiveking(inst)
    if self.king then
        inst:AddTag("achiveking")
    end
end

--预运行
function allachiv:Init(inst)
    inst:DoTaskInTime(.1, function()
    self:intogamefn(inst)
    self:eatfn(inst)
    self:onwalkfn(inst)
    self:onkilled(inst)
    self:healthregen(inst)
    self:sanityregen(inst)
    self:onkilledother(inst)
    self:burnorfreeze(inst)
    self:makefriend(inst)
    self:autofriend(inst)
    self:onhook(inst)
    self:fastfishing(inst)
    self:onpick(inst)
    self:chopper(inst)
    self:nooblight(inst)
    self:cook(inst)
   --- self:respawn(inst)
    self:ontimepass(inst)
    self:refresh(inst)
    self:onbuild(inst)
    self:onattacked(inst)
    self:hitother(inst)
    self:sanitycheck(inst)
    self:toblack(inst)
    self:ontemperature(inst)
    self:temperaturecoin(inst)
    self:achiveking(inst)
    end)

    inst.components.combat.damagemultiplier = inst.components.combat.damagemultiplier or 1

    inst:DoPeriodicTask(0, function() self:onupdate(inst) end)
end

--检测是否完成所有成就
function allachiv:allget(inst)
    if self.all ~= true then
        inst:DoPeriodicTask(1, function()
            if self.all ~= true then
                if self.intogame
                and self.firsteat
                and self.supereat
                and self.danding
                and self.messiah
                and self.walkalot
                and self.stopalot
                and self.tooyoung
                and self.evil
                and self.snake
                and self.deathalot
                and self.nosanity
                and self.sick
                and self.coldblood
                and self.burn
                and self.freeze
                and self.goodman
                and self.brother
                and self.fishmaster
                and self.pickmaster
                and self.chopmaster
                and self.noob
                and self.cookmaster
                and self.longage
                and self.luck
                and self.black
                and self.buildmaster
                and self.tank
                and self.angry
                and self.icebody
                and self.firebody
                and self.rigid
                and self.ancient
                and self.queen
                and self.king
                then
                    self.all = true
                    inst:DoTaskInTime(2, function()
                        self:seffc(inst, "all")
                    end)
                end
            end
        end)
    end
end

--检测非由本mod改变的数据并实时更新，同时负责载入时将奖励生效
function allachiv:onupdate(inst)
    --饥饿上限
    if self.hungermax ~= inst.components.hunger.max then
        local coin1 = 0
        local coin2 = 0
        if self.firsteat then coin1 = allachiv_coindata["firsteat"] end
        if self.supereat then coin2 = allachiv_coindata["supereat"] end
        local hunger_percent = inst.components.hunger:GetPercent()
        inst.components.hunger:SetMax(inst.components.hunger.max + coin1 + coin2)
        inst.components.hunger:SetPercent(hunger_percent)
        self.hungermax = inst.components.hunger.max
    end
    --脑残上限
    if self.sanitymax ~= inst.components.sanity.max then
        local coin1 = 0
        local coin2 = 0
        if self.sick then coin1 = allachiv_coindata["sick"] end
        if self.coldblood then coin2 = allachiv_coindata["coldblood"] end
        local sanity_percent = inst.components.sanity:GetPercent()
        inst.components.sanity:SetMax(inst.components.sanity.max + coin1 + coin2)
        inst.components.sanity:SetPercent(sanity_percent)
        self.sanitymax = inst.components.sanity.max
    end
    --血量上限
    if self.healthmax ~= inst.components.health.maxhealth then
        local coin1 = 0
        local coin2 = 0
        if self.danding then coin1 = allachiv_coindata["danding"] end
        if self.messiah then coin2 = allachiv_coindata["messiah"] end
        local health_percent = inst.components.health:GetPercent()
        inst.components.health:SetMaxHealth(inst.components.health.maxhealth + coin1 + coin2)
        inst.components.health:SetPercent(health_percent)
        self.healthmax = inst.components.health.maxhealth
    end
    --延缓饥饿
    if self.hungerrate ~= inst.components.hunger.hungerrate then
        local coin = 0
        if self.stopalot then coin = allachiv_coindata["stopalot"] end
        inst.components.hunger.hungerrate = inst.components.hunger.hungerrate * (1 - coin)
        self.hungerrate = inst.components.hunger.hungerrate
    end
    --移动速度
    if self.speedcheck ~= inst.components.locomotor.externalspeedmultiplier then
        local coin1 = 0
        local coin2 = 0
        local coin3 = 0
        local coin4 = 0
        if self.tooyoung then coin1= allachiv_coindata["tooyoung"] end
        if self.evil then coin2 = allachiv_coindata["evil"] end
        if self.walkalot then coin3 = allachiv_coindata["walkalot"] end
        if self.snake then coin4 = allachiv_coindata["snake"] end
        inst.components.locomotor.externalspeedmultiplier = inst.components.locomotor.externalspeedmultiplier + coin1 + coin2 + coin3 + coin4
        self.speedcheck = inst.components.locomotor.externalspeedmultiplier
    end
    --防寒
    if self.coldi ~= inst.components.temperature.inherentinsulation then
        local coin = 0
        if self.freeze then coin = allachiv_coindata["freeze"] end
        inst.components.temperature.inherentinsulation = inst.components.temperature.inherentinsulation + coin
        self.coidi = inst.components.temperature.inherentinsulation
    end
    --隔热
    if self.hoti ~= inst.components.temperature.inherentsummerinsulation then
        local coin = 0
        if self.burn then coin = allachiv_coindata["burn"] end
        inst.components.temperature.inherentsummerinsulation = inst.components.temperature.inherentsummerinsulation + coin
        self.hoti = inst.components.temperature.inherentsummerinsulation
    end
    --防御力
    if self.absorb ~= inst.components.health.absorb then
        local coin1 = 0
        local coin2 = 0
        if self.tank then coin1 = allachiv_coindata["tank"] end
        if self.rigid then coin2 = allachiv_coindata["rigid"] end
        inst.components.health.absorb = inst.components.health.absorb + coin1 + coin2
        self.absorb = inst.components.health.absorb
    end
    --攻击力
    if self.damagemul ~= inst.components.combat.damagemultiplier then
        local coin1 = 0
        local coin2 = 0
        if self.angry then coin1 = allachiv_coindata["angry"] end
        if self.ancient then coin2 = allachiv_coindata["ancient"] end
        inst.components.combat.damagemultiplier = inst.components.combat.damagemultiplier + coin1 + coin2
        self.damagemul = inst.components.combat.damagemultiplier
    end
    --防水
    if self.maxMoistureRate ~= inst.components.moisture.maxMoistureRate then
        if self.black then
            inst.components.moisture.maxMoistureRate = 0
        end
    end
end

return allachiv
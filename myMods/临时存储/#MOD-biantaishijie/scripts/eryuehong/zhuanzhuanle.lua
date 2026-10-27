
local TheSim             = GLOBAL.TheSim
local TheShard           = GLOBAL.TheShard
local TheNet             = GLOBAL.TheNet
local TUNING             = GLOBAL.TUNING
local EQUIPSLOTS         = GLOBAL.EQUIPSLOTS
local Sleep              = GLOBAL.Sleep
local SpawnPrefab        = GLOBAL.SpawnPrefab
local Vector3            = GLOBAL.Vector3
local SetSharedLootTable = GLOBAL.SetSharedLootTable
local AllPlayers         = GLOBAL.AllPlayers

local PI                 = GLOBAL.PI


------------------------修改无法燃烧
AddComponentPostInit("burnable", function(Burnable,inst)
	Burnable.YuanshiIgniteFn = Burnable.Ignite
	function Burnable:Ignite(immediate, source)
		if self.inst and not self.inst.wufaranshao then
			return Burnable:YuanshiIgniteFn(immediate, source)
		end
	end
end)




--------------------------------------------修改 获取有效陆地
GLOBAL.huoquyouxiaoludi = function(pt,jiaodu,banjing)
    if pt and jiaodu and banjing then
        local banjing2 = banjing*0.1
        local banjing3 = 1
        local pt2 = nil
        for k=1,10 do
            local x = math.cos(2*PI*jiaodu)*banjing2 + pt.x
            local z = math.sin(2*PI*jiaodu)*banjing2 + pt.z
            local a = SpawnPrefab("log")
            a.Transform:SetPosition(x,0,z) 
            if a:IsOnValidGround() then
                banjing2 = banjing2 + banjing*0.1
                banjing3 = banjing3 + 1
                pt2 = Vector3(a.Transform:GetWorldPosition())
                a:Remove()
            else
                a:Remove()
            end
        end
        if banjing3 > 5 and pt2 then
            return pt2
        end
    end
end

GLOBAL.huoquyouxiaoludi2 = function(pt,jiaodu,banjing)
    if pt and jiaodu and banjing then
        local pt2 = nil
        local x = math.cos(2*PI*jiaodu)*banjing*math.random() + pt.x
        local z = math.sin(2*PI*jiaodu)*banjing*math.random() + pt.z
        local a = SpawnPrefab("log")
        a.Transform:SetPosition(x,0,z) 
        if a:IsOnValidGround() then
            pt2 = Vector3(a.Transform:GetWorldPosition())
            a:Remove()
        else
            a:Remove()
        end
        if pt2 then
            return pt2
        end
    end
end
--------------------------------------------修改 获取有效陆地

--------------------------------------------------修改 给黄金效果
GLOBAL.geihuangjinxiaoguo = function(player,shuliang)
    if TUNING.ZHUWANG and TUNING.ZHUWANG:IsValid() and TUNING.ZHUWANG.shangdianjilu22 then
        TUNING.ZHUWANG.shangdianjilu22 = TUNING.ZHUWANG.shangdianjilu22 - shuliang
    end
    player:StartThread(function()
        for k = 1,shuliang do
            if player:IsValid() then
                player.components.inventory:GiveItem(SpawnPrefab("lucky_goldnugget")) 
            end
            Sleep(0.1)
        end
    end)
end
--------------------------------------------------修改 给黄金效果

--------------------------------------------------修改 单色球彩票中奖
GLOBAL.danseqiucaipiaozhongjiang = function(player)
    local jiangjin = 500
    if TUNING.ZHUWANG and TUNING.ZHUWANG:IsValid() then
        jiangjin = jiangjin + math.floor(math.max((TUNING.ZHUWANG.shangdianjilu22) * 0.1,0))
    end
    player.zuiduohuangjin = (player.zuiduohuangjin or 0) + jiangjin
    player.components.talker:Say("您的银行到账 "..jiangjin)
    TheNet:Announce("恭喜玩家"..player.name.."中得 彩票 奖金为金元宝"..jiangjin.."个 羡慕嫉妒恨吧")

    if TUNING.ZHUWANG and TUNING.ZHUWANG:IsValid() then table.insert(TUNING.ZHUWANG.shangdianjilu,player.userid.." 中奖 ".."".." 的 ".."".." 价值 "..jiangjin) end--记录
    if TUNING.ZHUWANG and TUNING.ZHUWANG:IsValid() then table.insert(TUNING.ZHUWANG.shangdianjilu3,(player.name or "").." 中彩票 "..jiangjin.."两黄金") end--大奖获得者
end
--------------------------------------------------修改 单色球彩票中奖

--------------------------------------------------修改 计算含金量
GLOBAL.jisuanhanjinliang = function(player)
    local pack = player.components.inventory:GetEquippedItem(EQUIPSLOTS.BACK) or nil
    local pack2 = player.components.inventory:GetEquippedItem(EQUIPSLOTS.NECK) or nil
    local hanjinliang = 0
    for k,v in pairs(player.components.inventory.itemslots) do
        if v and v.prefab == "lucky_goldnugget" then
            hanjinliang = hanjinliang + v.components.stackable:StackSize()
        end
    end
    if pack and pack.components.container then
        for k,v in pairs(pack.components.container.slots) do
            if v and v.prefab == "lucky_goldnugget" then
                hanjinliang = hanjinliang + v.components.stackable:StackSize()
            end
        end
    end
    
    if pack2 and pack2.components.container then
        for k,v in pairs(pack2.components.container.slots) do
            if v and v.prefab == "lucky_goldnugget" then
                hanjinliang = hanjinliang + v.components.stackable:StackSize()
            end
        end
    end
    return hanjinliang
end
--------------------------------------------------修改 计算含金量

--------------------------------------------------修改 扣金
GLOBAL.koujinkuai = function(player,jinkuaishu)
    local pack = player.components.inventory:GetEquippedItem(EQUIPSLOTS.BACK) or nil
    local pack2 = player.components.inventory:GetEquippedItem(EQUIPSLOTS.NECK) or nil
    for k,v in pairs(player.components.inventory.itemslots) do
        if v and v.prefab == "lucky_goldnugget" then
            if jinkuaishu > v.components.stackable:StackSize() then
                jinkuaishu = jinkuaishu - v.components.stackable:StackSize()
                v:Remove()
            else
                v.components.stackable:Get(jinkuaishu):Remove()
                return
            end
        end
    end
    if pack and pack.components.container then
        for k,v in pairs(pack.components.container.slots) do
            if v and v.prefab == "lucky_goldnugget" then
                if jinkuaishu > v.components.stackable:StackSize() then
                    jinkuaishu = jinkuaishu - v.components.stackable:StackSize()
                    v:Remove()
                else
                    v.components.stackable:Get(jinkuaishu):Remove()
                    return
                end
            end
        end
    end
    if pack2 and pack2.components.container then
        for k,v in pairs(pack2.components.container.slots) do
            if v and v.prefab == "lucky_goldnugget" then
                if jinkuaishu > v.components.stackable:StackSize() then
                    jinkuaishu = jinkuaishu - v.components.stackable:StackSize()
                    v:Remove()
                else
                    v.components.stackable:Get(jinkuaishu):Remove()
                    return
                end
            end
        end
    end
end
--------------------------------------------------修改 扣金

-------------------------------------------------------修改 生成特殊怪
GLOBAL.shengchengteshuguaiwu = function(guai)
    if guai then
            local teshu2 = nil
            local teshu3 = nil
            local teshu4 = nil
            if guai.teshu == nil then
                guai.teshu = {}
                teshu2 = 0
                
                --------------------------------统一掉落 怪随时间增强
                local ndaa = (TUNING.EMOZHIMEN.tongyidiaoluoshijian or 0) / 480 * 0.0117
                guai.shanghaijianmian = (guai.shanghaijianmian or 0) + ndaa
                guai.huoyandikang = (guai.huoyandikang or 0) + ndaa
                guai.bingdongdikang = (guai.bingdongdikang or 0) + ndaa
                guai.shandiandikang = (guai.shandiandikang or 0) + ndaa
                guai.liuxuedikang = (guai.liuxuedikang or 0) + ndaa
                guai.kongshoushanghai = (guai.kongshoushanghai or 0) + ndaa
                guai.shanbi = (guai.shanbi or 0) + ndaa
                teshu3 = math.max(ndaa / 3,1)
                teshu4 = math.max(ndaa / 7.5,1)
                --------------------------------统一掉落 怪随时间增强
    
                if math.random() < teshu3*(guai.qingxianghuan or 0) then guai.teshu[#guai.teshu+1] = "幻影攻击" teshu2 = teshu2 + 1 end--huan
                if math.random() < teshu3*(guai.qingxiangteqiang or 0) then guai.teshu[#guai.teshu+1] = "特别强壮" teshu2 = teshu2 + 2 end--teqiang
                if math.random() < teshu3*(guai.qingxiangtekuai or 0) then guai.teshu[#guai.teshu+1] = "特别快速" teshu2 = teshu2 + 2 end--tekuai
                if math.random() < teshu3*(guai.qingxianghuo or 0) then guai.teshu[#guai.teshu+1] = "火焰强化" teshu2 = teshu2 + 2 end--huo
                if math.random() < teshu3*(guai.qingxiangbing or 0) then guai.teshu[#guai.teshu+1] = "冰冻强化" teshu2 = teshu2 + 2 end--bing
                if math.random() < teshu3*(guai.qingxiangshan or 0) then guai.teshu[#guai.teshu+1] = "闪电强化" teshu2 = teshu2 + 2 end--shan
                if math.random() < teshu3*(guai.qingxiangyou or 0) then guai.teshu[#guai.teshu+1] = "幽灵一击" teshu2 = teshu2 + 3 end--you
                if math.random() < teshu3*(guai.qingxiangpi or 0) then guai.teshu[#guai.teshu+1] = "皮肤硬化" teshu2 = teshu2 + 3 end--pi
                if math.random() < teshu3*(guai.qingxiangyuan or 0) then guai.teshu[#guai.teshu+1] = "元素抵抗" teshu2 = teshu2 + 3 end--yuan
                if ndaa > 15 and math.random() < teshu3*(guai.qingxianghuowu or 0) then guai.teshu[#guai.teshu+1] = "火焰无效" teshu2 = teshu2 + 3 end--huowu
                if ndaa > 15 and math.random() < teshu3*(guai.qingxiangbingwu or 0) then guai.teshu[#guai.teshu+1] = "冰冻无效" teshu2 = teshu2 + 3 end--bingwu
                if ndaa > 15 and math.random() < teshu3*(guai.qingxiangshanwu or 0) then guai.teshu[#guai.teshu+1] = "闪电无效" teshu2 = teshu2 + 3 end--shanwu
                if ndaa > 15 and math.random() < teshu3*(guai.qingxiangshiwu or 0) then guai.teshu[#guai.teshu+1] = "实体无效" teshu2 = teshu2 + 4 end--shiwu
                if math.random() < teshu3*(guai.qingxiangchuan or 0) then guai.teshu[#guai.teshu+1] = "传送" teshu2 = teshu2 + 3 end--chuan
                if math.random() < teshu4*(guai.qingxiangshi or 0) then guai.teshu[#guai.teshu+1] = "史诗级" teshu2 = teshu2 + 15 end--shi
                
                if math.random() < teshu3*(guai.qingxianglingqibing or 0) then guai.teshu[#guai.teshu+1] = "灵气冰冻" teshu2 = teshu2 + 4 end
                if math.random() < teshu3*(guai.qingxianglingqikuang or 0) then guai.teshu[#guai.teshu+1] = "灵气狂热" teshu2 = teshu2 + 5 end
            else
                teshu2 = guai.teshu2 or 0
            end
            
            guai.tongyidiaoluobeilv = (guai.tongyidiaoluobeilv or 1) + teshu2 * 0.25

            local abcd = 0
            for k,v in pairs(guai.teshu) do
                if guai.teshu[k] == "史诗级" then abcd = 1 end
            end
            local name = ""
            if abcd == 0 then
                for k,v in pairs(guai.teshu) do
                    name = string.format("%s%s%s",name," ",guai.teshu[k])
                    if guai.teshu[k] == "幻影攻击" then 
                        guai.zhinenggongji = 1
                        if guai.chongwuxitongshoumai then guai.chongwuxitongshoumai = guai.chongwuxitongshoumai * 0.7 end--宠物系统
                        guai.nnfen = (guai.nnfen or 0) + 0.3
                    end
                    if guai.teshu[k] == "特别强壮" then 
                        guai.kongshoushanghai = (guai.kongshoushanghai or 0) * 1.5
                        if guai.components.health then guai.components.health:SetMaxHealth(guai.components.health.maxhealth*1.5) end
                        if guai.components.health then guai.components.health:SetPercent(1) end
                        if guai.chongwuxitongshoumai then guai.chongwuxitongshoumai = guai.chongwuxitongshoumai * 0.5 end--宠物系统
                        guai.nnfen = (guai.nnfen or 0) + 0.5
                    end
                    if guai.teshu[k] == "特别快速" then 
                        if guai.components.combat then guai.components.combat:SetAttackPeriod((guai.components.combat.min_attack_period or 0)*0.5) end
                        if guai.components.locomotor then guai.components.locomotor.runspeed = guai.components.locomotor.runspeed * 1.5 end
                        if guai.components.locomotor then guai.components.locomotor.walkspeed = guai.components.locomotor.walkspeed * 1.5 end
                        if guai.chongwuxitongshoumai then guai.chongwuxitongshoumai = guai.chongwuxitongshoumai * 0.5 end--宠物系统
                        guai.nnfen = (guai.nnfen or 0) + 0.5
                    end
                    if guai.teshu[k] == "火焰强化" then 
                        guai.huoyangongji = (guai.huoyangongji or 0) + 25
                        if guai.chongwuxitongshoumai then guai.chongwuxitongshoumai = guai.chongwuxitongshoumai * 0.5 end--宠物系统
                        guai.nnfen = (guai.nnfen or 0) + 0.5
                    end
                    if guai.teshu[k] == "冰冻强化" then 
                        guai.bingdonggongji = (guai.bingdonggongji or 0) + 25
                        if guai.chongwuxitongshoumai then guai.chongwuxitongshoumai = guai.chongwuxitongshoumai * 0.5 end--宠物系统
                        guai.nnfen = (guai.nnfen or 0) + 0.5
                    end
                    if guai.teshu[k] == "闪电强化" then 
                        guai.shandiangongji = (guai.shandiangongji or 0) + 25
                        if guai.chongwuxitongshoumai then guai.chongwuxitongshoumai = guai.chongwuxitongshoumai * 0.5 end--宠物系统
                        guai.nnfen = (guai.nnfen or 0) + 0.5
                    end
                    if guai.teshu[k] == "幽灵一击" then 
                        guai.huoyangongji = (guai.huoyangongji or 0) + 10
                        guai.bingdonggongji = (guai.bingdonggongji or 0) + 10
                        guai.shandiangongji = (guai.shandiangongji or 0) + 10
                        guai.baoji = (guai.baoji or 0) + 10
                        guai.zhongji = (guai.zhongji or 0) + 10
                        guai.liuxuegongji = (guai.liuxuegongji or 0) + 10
                        if guai.chongwuxitongshoumai then guai.chongwuxitongshoumai = guai.chongwuxitongshoumai * 0.3 end--宠物系统
                        guai.nnfen = (guai.nnfen or 0) + 0.7
                    end
                    if guai.teshu[k] == "皮肤硬化" then 
                        guai.shanghaijianmian = (guai.shanghaijianmian or 0) + 40
                        guai.shanghaijianmianx = (guai.shanghaijianmianx or 0) + 20
                        if guai.chongwuxitongshoumai then guai.chongwuxitongshoumai = guai.chongwuxitongshoumai * 0.3 end--宠物系统
                        guai.nnfen = (guai.nnfen or 0) + 0.7
                    end
                    if guai.teshu[k] == "元素抵抗" then 
                        guai.huoyandikang = (guai.huoyandikang or 0) + 50
                        guai.bingdongdikang = (guai.bingdongdikang or 0) + 50
                        guai.shandiandikang = (guai.shandiandikang or 0) + 50
                        if guai.chongwuxitongshoumai then guai.chongwuxitongshoumai = guai.chongwuxitongshoumai * 0.3 end--宠物系统
                        guai.nnfen = (guai.nnfen or 0) + 0.3
                    end
                    if guai.teshu[k] == "火焰无效" then 
                        guai.huoyandikang = 100
                        if guai.chongwuxitongshoumai then guai.chongwuxitongshoumai = guai.chongwuxitongshoumai * 0.3 end--宠物系统
                        guai.nnfen = (guai.nnfen or 0) + 0.3
                    end
                    if guai.teshu[k] == "冰冻无效" then 
                        guai.bingdongdikang = 100
                        if guai.chongwuxitongshoumai then guai.chongwuxitongshoumai = guai.chongwuxitongshoumai * 0.3 end--宠物系统
                        guai.nnfen = (guai.nnfen or 0) + 0.3
                    end
                    if guai.teshu[k] == "闪电无效" then 
                        guai.shandiandikang = 100
                        if guai.chongwuxitongshoumai then guai.chongwuxitongshoumai = guai.chongwuxitongshoumai * 0.3 end--宠物系统
                        guai.nnfen = (guai.nnfen or 0) + 0.3
                    end
                    if guai.teshu[k] == "传送" then 
                        guai.chuansong = 1 
                        if guai.chongwuxitongshoumai then guai.chongwuxitongshoumai = guai.chongwuxitongshoumai * 0.3 end--宠物系统
                        guai.nnfen = (guai.nnfen or 0) + 0.3
                    end 
                    if guai.teshu[k] == "实体无效" then 
                        guai.shanghaijianmian = 100
                        guai.shanghaijianmianx = 100
                        if guai.chongwuxitongshoumai then guai.chongwuxitongshoumai = guai.chongwuxitongshoumai * 0.1 end--宠物系统
                        guai.nnfen = (guai.nnfen or 0) + 0.5
                    end
                    if guai.teshu[k] == "灵气冰冻" then 
                        ------------------------------修改 光环系统
                        guai.guanghuanqiesite11 = {}
                        guai:DoPeriodicTask(2.01, function()
                            if not guai.components.health:IsDead() then
                                local p1x, p1y, p1z = guai.Transform:GetWorldPosition()
                                for k,v in pairs(guai.guanghuanqiesite11) do
                                    if v:IsValid() then
                                        local p2x, p2y, p2z = v.Transform:GetWorldPosition()
                                        local cc = math.sqrt((p1x-p2x)*(p1x-p2x)+(p1z-p2z)*(p1z-p2z))
                                        if cc > 15 then 
                                            table.remove(guai.guanghuanqiesite11,k) 
                                            v.guanghuanqiesite12 = 0
                                            v.guanghuanqiesite13 = 0
                                            v.AnimState:SetMultColour(1,1,1, 1)
                                            GLOBAL.shuxingshengxiao(v)
                                        end
                                    else
                                        table.remove(guai.guanghuanqiesite11,k)
                                    end
                                end
                                local ents = TheSim:FindEntities(p1x, p1y, p1z, 15, { "player1" })
                                for k,v in pairs(ents) do
                                    if not table.contains(guai.guanghuanqiesite11,v) then 
                                        table.insert(guai.guanghuanqiesite11,v) 
                                        v.guanghuanqiesite12 = -40
                                        v.guanghuanqiesite13 = -20
                                        v.AnimState:SetMultColour(0,1,1, 1)
                                        GLOBAL.shuxingshengxiao(v)
                                    end
                                end
                            else
                                for k,v in pairs(guai.guanghuanqiesite11) do
                                    if v:IsValid() then
                                        v.guanghuanqiesite12 = 0
                                        v.guanghuanqiesite13 = 0
                                        v.AnimState:SetMultColour(1,1,1, 1)
                                        GLOBAL.shuxingshengxiao(v)
                                    end
                                end
                            end
                        end)
                        ----------------------------修改 
                        if guai.chongwuxitongshoumai then guai.chongwuxitongshoumai = guai.chongwuxitongshoumai * 0.1 end--宠物系统
                        guai.nnfen = (guai.nnfen or 0) + 0.5
                    end
                    if guai.teshu[k] == "灵气狂热" then 
                        ------------------------------修改 光环系统
                        guai:DoPeriodicTask(2.01, function()
                            if not guai.components.health:IsDead() then
                                if guai:HasTag("tentacle_pillar") then
                                    local p1x, p1y, p1z = guai.Transform:GetWorldPosition()
                                    local ents = TheSim:FindEntities(p1x, p1y, p1z, 8, { "tentacle" })
                                    for k,v in pairs(ents) do
                                        if v.kuangre == nil then 
                                            v.kuangre = 1
                                            v.AnimState:SetMultColour(1,0,0, 1)
                                            v:DoTaskInTime(1.01, function()
                                                v.Ckongshoushanghai = (v.Ckongshoushanghai or 0) * 1.5
                                                v.components.combat:SetAttackPeriod(v.components.combat.min_attack_period/1.5)
                                            end)
                                        end
                                    end
                                elseif guai:HasTag("warg") then
                                    local p1x, p1y, p1z = guai.Transform:GetWorldPosition()
                                    local ents = TheSim:FindEntities(p1x, p1y, p1z, 15, { "hound" })
                                    for k,v in pairs(ents) do
                                        if v.kuangre == nil then 
                                            v.kuangre = 1
                                            v.AnimState:SetMultColour(1,0,0, 1)
                                            v:DoTaskInTime(1.01, function()
                                                v.Ckongshoushanghai = (v.Ckongshoushanghai or 0) * 1.5
                                                v.components.combat:SetAttackPeriod(v.components.combat.min_attack_period/1.5)
                                                v.components.locomotor.runspeed = v.components.locomotor.runspeed * 1.25
                                            end)
                                        end
                                    end
                                end
                            end
                        end)
                        ----------------------------修改 
                        guai.nnfen = (guai.nnfen or 0) + 0.5
                    end
                end
                name = string.format("%s%s%s",name," ",guai.xiangziname or "")
                guai.components.named:SetName(name)
            end
            if abcd == 1 then
                for k,v in pairs(guai.teshu) do
                    if guai.teshu[k] == "史诗级" then 
                        --------------需要判断怪物类型
                        guai.xingyun = -100
                        if guai.chongwuxitongshoumai then guai.chongwuxitongshoumai = guai.chongwuxitongshoumai * 0 end--宠物系统
                        if not guai:HasTag("boss") then guai:AddTag("boss") end
                        if guai.prefab == "bearger" then
                            guai.kongshoushanghai = (guai.kongshoushanghai or 0) * 2
                            if guai.components.health then guai.components.health:SetMaxHealth(guai.components.health.maxhealth*3) end
                            if guai.components.health then guai.components.health:SetPercent(1) end
                            if guai.components.combat then guai.components.combat:SetAttackPeriod((guai.components.combat.min_attack_period or 0)*0.85) end
                            if guai.components.locomotor then guai.components.locomotor.runspeed = guai.components.locomotor.runspeed * 1.15 end
                            if guai.components.locomotor then guai.components.locomotor.walkspeed = guai.components.locomotor.walkspeed * 1.15 end
                            guai.baoji = (guai.baoji or 0) + 15
                            guai.shanghaijianmianx = (guai.shanghaijianmianx or 0) + 5
                            guai.bingdongdikang = (guai.bingdongdikang or 0) + 15
                            guai.shengminghuifu = (guai.shengminghuifu or 0) * 2
                            guai.tongyidiaoluocishu = math.floor((guai.tongyidiaoluocishu or 0) * 1.25)
                            name = "泰迪熊"
                            guai.Transform:SetScale(1.3, 1.3, 1.3)
                        elseif guai.prefab == "warg" then
                            guai.kongshoushanghai = (guai.kongshoushanghai or 0) * 2
                            if guai.components.health then guai.components.health:SetMaxHealth(guai.components.health.maxhealth*3) end
                            if guai.components.health then guai.components.health:SetPercent(1) end
                            if guai.components.combat then guai.components.combat:SetAttackPeriod((guai.components.combat.min_attack_period or 0)*0.7) end
                            if guai.components.locomotor then guai.components.locomotor.runspeed = guai.components.locomotor.runspeed * 1.3 end
                            if guai.components.locomotor then guai.components.locomotor.walkspeed = guai.components.locomotor.walkspeed * 1.3 end
                            guai.baoji = (guai.baoji or 0) + 15
                            guai.shanghaijianmian = (guai.shanghaijianmian or 0) + 15
                            guai.bingdongdikang = (guai.bingdongdikang or 0) + 15
                            guai.shengminghuifu = (guai.shengminghuifu or 0) * 2
                            guai.tongyidiaoluocishu = math.floor((guai.tongyidiaoluocishu or 0) * 1.25)
                            name = "碎骨者"
                            guai.Transform:SetScale(1.3, 1.3, 1.3)
                        elseif guai.prefab == "walrus" then
                            guai.kongshoushanghai = (guai.kongshoushanghai or 0) * 1.2
                            if guai.components.health then guai.components.health:SetMaxHealth(guai.components.health.maxhealth*3) end
                            if guai.components.health then guai.components.health:SetPercent(1) end
                            if guai.components.combat then guai.components.combat:SetAttackPeriod((guai.components.combat.min_attack_period or 0)*0.8) end
                            if guai.components.locomotor then guai.components.locomotor.runspeed = guai.components.locomotor.runspeed * 1.2 end
                            if guai.components.locomotor then guai.components.locomotor.walkspeed = guai.components.locomotor.walkspeed * 1.2 end
                            guai.baoji = 20
                            guai.bingdonggongji = (guai.bingdonggongji or 0) + 20
                            guai.shanghaijianmian = (guai.shanghaijianmian or 0) + 20
                            guai.shandiandikang = (guai.shandiandikang or 0) + 20
                            guai.bingdongdikang = (guai.bingdongdikang or 0) + 60
                            guai.shengminghuifu = (guai.shengminghuifu or 0) * 2
                            guai.tongyidiaoluocishu = math.floor((guai.tongyidiaoluocishu or 0) * 1.25)
                            name = "毕须博须"
                            guai.Transform:SetScale(1.6, 1.6, 1.6)
                        elseif guai.prefab == "spiderqueen" then
                            guai.kongshoushanghai = (guai.kongshoushanghai or 0) * 2
                            if guai.components.health then guai.components.health:SetMaxHealth(guai.components.health.maxhealth*3) end
                            if guai.components.health then guai.components.health:SetPercent(1) end
                            if guai.components.combat then guai.components.combat:SetAttackPeriod((guai.components.combat.min_attack_period or 0)*0.85) end
                            if guai.components.locomotor then guai.components.locomotor.runspeed = guai.components.locomotor.runspeed * 1.15 end
                            if guai.components.locomotor then guai.components.locomotor.walkspeed = guai.components.locomotor.walkspeed * 1.15 end
                            guai.baoji = (guai.baoji or 0) + 25
                            guai.liuxuegongji = (guai.liuxuegongji or 0) + 25
                            guai.shengmingtouqu = (guai.shengmingtouqu or 0) + 25
                            guai.shanghaijianmian = (guai.shanghaijianmian or 0) + 15
                            guai.bingdongdikang = (guai.bingdongdikang or 0) + 30
                            guai.shengminghuifu = (guai.shengminghuifu or 0) * 2
                            guai.tongyidiaoluocishu = math.floor((guai.tongyidiaoluocishu or 0) * 1.25)
                            name = "血腥女王"
                            guai.Transform:SetScale(1.3, 1.3, 1.3)
                        elseif guai.prefab == "spat" then
                            guai.kongshoushanghai = (guai.kongshoushanghai or 0) * 1.5
                            if guai.components.health then guai.components.health:SetMaxHealth(guai.components.health.maxhealth*3) end
                            if guai.components.health then guai.components.health:SetPercent(1) end
                            if guai.components.combat then guai.components.combat:SetAttackPeriod((guai.components.combat.min_attack_period or 0)*0.8) end
                            if guai.components.locomotor then guai.components.locomotor.runspeed = guai.components.locomotor.runspeed * 1.2 end
                            if guai.components.locomotor then guai.components.locomotor.walkspeed = guai.components.locomotor.walkspeed * 1.2 end
                            guai.shanghaijianmian = (guai.shanghaijianmian or 0) + 25
                            guai.huoyandikang = (guai.bingdongdikang or 0) + 20
                            guai.bingdongdikang = (guai.bingdongdikang or 0) + 20
                            guai.shengminghuifu = (guai.shengminghuifu or 0) * 2
                            guai.tongyidiaoluocishu = math.floor((guai.tongyidiaoluocishu or 0) * 1.25)
                            name = "懒羊羊"
                            guai.Transform:SetScale(1.3, 1.3, 1.3)
                        elseif guai.prefab == "pigman" or guai.prefab == "pigguard" then
                            guai.kongshoushanghai = (guai.kongshoushanghai or 0) * 2
                            if guai.components.health then guai.components.health:SetMaxHealth(guai.components.health.maxhealth*3) end
                            if guai.components.health then guai.components.health:SetPercent(1) end
                            if guai.components.combat then guai.components.combat:SetAttackPeriod((guai.components.combat.min_attack_period or 0)*0.6) end
                            if guai.components.locomotor then guai.components.locomotor.runspeed = guai.components.locomotor.runspeed * 1.4 end
                            if guai.components.locomotor then guai.components.locomotor.walkspeed = guai.components.locomotor.walkspeed * 1.4 end
                            guai.shanghaijianmian = (guai.shanghaijianmian or 0) + 10
                            guai.shanghaijianmianx = (guai.shanghaijianmianx or 0) + 5
                            guai.huoyandikang = (guai.huoyandikang or 0) + 15
                            guai.bingdongdikang = (guai.bingdongdikang or 0) + 15
                            guai.shandiandikang = (guai.shandiandikang or 0) + 15
                            guai.shengminghuifu = (guai.shengminghuifu or 0) * 2
                            guai.tongyidiaoluocishu = math.floor((guai.tongyidiaoluocishu or 0) * 1.25)
                            name = "拉卡尼休"
                            guai.Transform:SetScale(1.6, 1.6, 1.6)
                        elseif guai.prefab == "minotaur" then
                            guai.kongshoushanghai = (guai.kongshoushanghai or 0) * 1.5
                            if guai.components.health then guai.components.health:SetMaxHealth(guai.components.health.maxhealth*3) end
                            if guai.components.health then guai.components.health:SetPercent(1) end
                            if guai.components.combat then guai.components.combat:SetAttackPeriod((guai.components.combat.min_attack_period or 0)*0.85) end
                            if guai.components.locomotor then guai.components.locomotor.runspeed = guai.components.locomotor.runspeed * 1.15 end
                            if guai.components.locomotor then guai.components.locomotor.walkspeed = guai.components.locomotor.walkspeed * 1.15 end
                            guai.baoji = (guai.baoji or 0) + 15
                            guai.shanghaijianmian = (guai.shanghaijianmian or 0) + 10
                            guai.shanghaijianmianx = (guai.shanghaijianmianx or 0) + 10
                            guai.bingdongdikang = (guai.bingdongdikang or 0) + 30
                            guai.shengminghuifu = (guai.shengminghuifu or 0) * 2
                            guai.tongyidiaoluocishu = math.floor((guai.tongyidiaoluocishu or 0) * 1.25)
                            name = "黑暗碾压者"
                            guai.Transform:SetScale(1.4, 1.4, 1.4)
                        elseif guai.prefab == "leif" then
                            guai.kongshoushanghai = (guai.kongshoushanghai or 0) * 2
                            if guai.components.health then guai.components.health:SetMaxHealth(guai.components.health.maxhealth*3) end
                            if guai.components.health then guai.components.health:SetPercent(1) end
                            guai.shanghaijianmian = (guai.shanghaijianmian or 0) + 20
                            guai.shanghaijianmianx = (guai.shanghaijianmianx or 0) + 10
                            guai.shengminghuifu = (guai.shengminghuifu or 0) + 1000
                            guai.bingdonggongji = (guai.bingdonggongji or 0) + (guai.kongshoushanghai or 0) * 0.2
                            guai.shandiangongji = (guai.shandiangongji or 0) + (guai.kongshoushanghai or 0) * 0.2
                            guai.baoji = (guai.baoji or 0) + 15
                            guai.zhongji = (guai.zhongji or 0) + 15
                            guai.liuxuegongji = (guai.liuxuegongji or 0) + 15
                            guai.shengminghuifu = (guai.shengminghuifu or 0) * 2
                            guai.tongyidiaoluocishu = math.floor((guai.tongyidiaoluocishu or 0) * 1.25)
                            name = "橡木拳头"
                            guai.Transform:SetScale(1.5, 1.5, 1.5)
                        elseif guai.prefab == "hound" or guai.prefab == "firehound" or guai.prefab == "icehound" then
                            guai.kongshoushanghai = (guai.kongshoushanghai or 0) * 3
                            if guai.components.health then guai.components.health:SetMaxHealth(guai.components.health.maxhealth*3) end
                            if guai.components.health then guai.components.health:SetPercent(1) end
                            if guai.components.combat then guai.components.combat:SetAttackPeriod((guai.components.combat.min_attack_period or 0)*0.6) end
                            if guai.components.locomotor then guai.components.locomotor.runspeed = guai.components.locomotor.runspeed * 1.4 end
                            if guai.components.locomotor then guai.components.locomotor.walkspeed = guai.components.locomotor.walkspeed * 1.4 end
                            guai.baoji = (guai.baoji or 0) + 25
                            guai.liuxuegongji = (guai.liuxuegongji or 0) + 15
                            guai.bingdongdikang = (guai.bingdongdikang or 0) + 20
                            guai.shengminghuifu = (guai.shengminghuifu or 0) * 2
                            guai.tongyidiaoluocishu = math.floor((guai.tongyidiaoluocishu or 0) * 1.25)
                            name = "牙皮"
                            guai.Transform:SetScale(1.3, 1.3, 1.3)
                        elseif guai.prefab == "ghost" then
                            if guai.components.health then guai.components.health:SetMaxHealth(guai.components.health.maxhealth*3) end
                            if guai.components.health then guai.components.health:SetPercent(1) end
                            if guai.components.combat then guai.components.combat:SetAttackPeriod((guai.components.combat.min_attack_period or 0)*0.8) end
                            if guai.components.locomotor then guai.components.locomotor.runspeed = guai.components.locomotor.runspeed * 1.2 end
                            if guai.components.locomotor then guai.components.locomotor.walkspeed = guai.components.locomotor.walkspeed * 1.2 end
                            guai.zhenshishanghai = (guai.zhenshishanghai or 0) + 10
                            guai.shanghaijianmian = (guai.shanghaijianmian or 0) + 25
                            guai.huoyandikang = (guai.huoyandikang or 0) + 95
                            guai.shandiandikang = (guai.shandiandikang or 0) + 95
                            guai.bingdongdikang = (guai.bingdongdikang or 0) + 95
                            guai.shengminghuifu = (guai.shengminghuifu or 0) * 2
                            guai.tongyidiaoluocishu = math.floor((guai.tongyidiaoluocishu or 0) * 1.25)
                            name = "游荡者"
                            guai.Transform:SetScale(1.3, 1.3, 1.3)
                        elseif guai.prefab == "dragonfly" then
                            guai.kongshoushanghai = (guai.kongshoushanghai or 0) * 2
                            if guai.components.health then guai.components.health:SetMaxHealth(guai.components.health.maxhealth*3) end
                            if guai.components.health then guai.components.health:SetPercent(1) end
                            if guai.components.combat then guai.components.combat:SetAttackPeriod((guai.components.combat.min_attack_period or 0)*0.6) end
                            if guai.components.locomotor then guai.components.locomotor.runspeed = guai.components.locomotor.runspeed * 1.4 end
                            if guai.components.locomotor then guai.components.locomotor.walkspeed = guai.components.locomotor.walkspeed * 1.4 end
                            guai.baoji = (guai.baoji or 0) + 15
                            guai.huoyangongji = (guai.huoyangongji or 0) + 40
                            guai.shanghaijianmian = (guai.shanghaijianmian or 0) + 20
                            guai.huoyandikang = (guai.huoyandikang or 0) + 0
                            guai.shengminghuifu = (guai.shengminghuifu or 0) * 2
                            guai.tongyidiaoluocishu = math.floor((guai.tongyidiaoluocishu or 0) * 1.25)
                            name = "暴躁外皮"
                            guai.Transform:SetScale(1.5, 1.5, 1.5)
                        elseif guai.prefab == "deerclops" then
                            guai.kongshoushanghai = (guai.kongshoushanghai or 0) * 2
                            if guai.components.health then guai.components.health:SetMaxHealth(guai.components.health.maxhealth*3) end
                            if guai.components.health then guai.components.health:SetPercent(1) end
                            if guai.components.combat then guai.components.combat:SetAttackPeriod((guai.components.combat.min_attack_period or 0)*0.7) end
                            if guai.components.locomotor then guai.components.locomotor.runspeed = guai.components.locomotor.runspeed * 1.3 end
                            if guai.components.locomotor then guai.components.locomotor.walkspeed = guai.components.locomotor.walkspeed * 1.3 end
                            guai.bingdonggongji = (guai.bingdonggongji or 0) + 40
                            guai.shanghaijianmian = (guai.shanghaijianmian or 0) + 15
                            guai.bingdongdikang = (guai.bingdongdikang or 0) + 50
                            guai.shengminghuifu = (guai.shengminghuifu or 0) * 2
                            guai.tongyidiaoluocishu = math.floor((guai.tongyidiaoluocishu or 0) * 1.25)
                            name = "罗达门特"
                            guai.Transform:SetScale(1.9, 1.9, 1.9)
                        end
                    end
                    --------------------
                end
                name = string.format("%s%s%s",name," ",guai.xiangziname or "")
                guai.components.named:SetName(name)
            end
    end
end
 




GLOBAL.ACTIONS.PICKUP.fn = function(act)
    -------------------------------------修改 商店系统
    --shangdianzhanshi == 0             商店物品
    --shangdianzhanshi == 1             转转乐
    --shangdianzhanshi == 4             个人商店
    --shangdianzhanshi == 6             死亡之塔
    --shangdianzhanshi == 7             老虎机
    ------------------------------------修改 掉落物品一定时间无法拾取
    if act.target and act.target.siwangdiaoluoshiqu and act.target.siwangdiaoluoshiqu ~= act.doer.userid then return true end
    ------------------------------------修改 掉落物品一定时间无法拾取
    if act.target and act.target.shangdianzhanshi and act.doer and act.doer:HasTag("player") then

        ---------------------------------死亡之塔
        if act.target.shangdianzhanshi == 6 then
            local ents = TheSim:FindEntities(TUNING.SIWANGZHITAx, 0, TUNING.SIWANGZHITAz, 15.9)
            local playershu = 0
            for k,v in pairs(ents) do
                if v:HasTag("player") then
                    playershu = playershu + 1
                end
            end
            if playershu >= 2 then act.doer.components.talker:Say("挑战人数超过限制") return end
            if act.target.shangdianjiage and GLOBAL.jisuanhanjinliang(act.doer) >= act.target.shangdianjiage then
                GLOBAL.koujinkuai(act.doer,act.target.shangdianjiage)
                act.doer.Transform:SetPosition(TUNING.SIWANGZHITAx,0,TUNING.SIWANGZHITAz)
                act.doer.siwangzhita = 0
                TheNet:Announce((act.doer.name or "有人").."开始挑战万妖塔")
            end
        end
        
         ---------------------------------个人商店
        if act.target.shangdianzhanshi == 4 then
            if act.target.shangdiansuoyouzhe and (act.target.shangdiansuoyouzhe.shangdiansuoyouzheid or "") == act.doer.userid then
                act.target.shangdianzhanshi = nil
                act.target.shangdianjiage = nil
                act.target.shangdiansuoyouzhe.shangdianwupin = nil
                act.target.shangdiansuoyouzhe = nil
                act.target.AnimState:SetMultColour(1,1,1, 1)
                if act.target.components.equippable and act.target.components.named then 
                    act.target.components.named:SetName(act.target.name)
                end
                act.doer.components.inventory:GiveItem(act.target) 
            elseif act.target.shangdianjiage and (GLOBAL.jisuanhanjinliang(act.doer) >= act.target.shangdianjiage or (act.doer.zuiduohuangjin or 0) >= act.target.shangdianjiage) then
                if act.target.shangdianjiage >= 64*500 and (act.doer.zuiduohuangjin or 0) >= act.target.shangdianjiage then 
                    act.doer.zuiduohuangjin = act.doer.zuiduohuangjin - act.target.shangdianjiage 
                    act.doer.components.talker:Say("已从您的银行自动扣除 "..(act.target.shangdianjiage or 0).."，余额："..(act.doer.zuiduohuangjin or 0))
                else GLOBAL.koujinkuai(act.doer,act.target.shangdianjiage) end
                act.target.shangdiansuoyouzhe.huangjin = (act.target.shangdiansuoyouzhe.huangjin or 0) + act.target.shangdianjiage
                if TUNING.ZHUWANG then table.insert(TUNING.ZHUWANG.shangdianjilu,act.doer.userid.." 购买 "..act.doer.userid.." 的 "..(act.target.name or act.target.name or "").." 价值 "..act.target.shangdianjiage) end--记录
                act.target.shangdianzhanshi = nil
                act.target.shangdianjiage = nil
                act.target.shangdiansuoyouzhe.shangdianwupin = nil
                act.target.shangdiansuoyouzhe = nil
                act.target.AnimState:SetMultColour(1,1,1, 1)
                if act.target.components.equippable and act.target.components.named then 
                    act.target.components.named:SetName(act.target.name)
                end
                act.doer.components.inventory:GiveItem(act.target) 
            else
                act.doer:DoTaskInTime(0.5, function()
                    act.doer.components.talker:Say("需要金元宝"..(act.target.shangdianjiage or 0)) 
                end)
            end
        end
        ---------------------------------个人商店

        ---------------------------------猪王商店
        ---------------------------------比大小
        ---------------------------------老虎机
        if act.target.shangdianzhanshi == 7 then
       
            if act.target.zhuanzhuanle.laohujizhuangtai ~= 2 and act.target.laohuji and act.target.shangdianjiage and (GLOBAL.jisuanhanjinliang(act.doer) >= act.target.shangdianjiage or table.contains(act.doer.teshuchenghao,"嗜赌如命") and act.doer.components.health.currenthealth>act.doer.components.health.maxhealth*1/3) then
                if not table.contains(act.doer.teshuchenghao,"嗜赌如命") or GLOBAL.jisuanhanjinliang(act.doer) >= act.target.shangdianjiage or act.doer.components.health.currenthealth <= act.doer.components.health.maxhealth*1/3 then 
                    GLOBAL.koujinkuai(act.doer,act.target.shangdianjiage) 
                else 
                    local wodexue = (math.random()>.5 and "它抽走了我的血！") or "啊！还是挺疼的！"
                    act.doer.components.talker:Say(wodexue)
                    GLOBAL.shidurumingkouxue(act.doer,act.target.shangdianjiage*4) 
                end
                table.insert(act.target.laohuji2,act.doer)
                act.target.zhuanzhuanle.laohujizhuangtai = 1
                act.doer.components.sanity:DoDelta(0.2)
                act.doer.components.talker:Say("成功下注<"..(act.target:GetDisplayName() or "")..">") 
                
                
                
                return true
            end
            

            
            if act.target.zhuanzhuanle.laohujizhuangtai == 1 and (act.target.zhuanzhuanle2 or 0) == 1 then
                act.target.zhuanzhuanle.laohujizhuangtai = 2
                --------------------------------老虎机重复下
                act.target.zhuanzhuanle.laohujichongfuxia = {}
                for j,k in pairs(act.target.zhuanzhuanle.laohuji3) do
                    if k.laohuji2 and #k.laohuji2 > 0 then
                        for o=1,#k.laohuji2 do
                            table.insert(act.target.zhuanzhuanle.laohujichongfuxia,k)
                        end
                    end
                end
                --------------------------------老虎机重复下

                ------------------------------老虎机测试
                
                act.target.zhuanzhuanle2 = 0
                local p3x, p3y, p3z = act.target.Transform:GetWorldPosition()
                act.target.yuanshix = p3x
                act.target.yuanshiz = p3z
                act.target:StartThread(function()

                    local bb = 0
                    local cc = 0.51
                    local ll = #act.target.zhuanzhuanle.shangdianshangpin2
                    local dd = ll*4+math.floor(math.random()*ll*2-0.01+1)
                    ----------判断物品
                for q = 1,1000 do 
                    
                    local jj = dd%ll
                    if jj == 0 then jj = ll end
                    local ii = act.target.zhuanzhuanle.shangdianshangpin2[jj]
                    if ii then
                        local nn = 1
            
                            local mm = 0
                            if jj == 3 or jj == 6 or jj == 9 or jj == 12 or jj == 15 or jj == 18 or jj == 23 then
                                if math.random() > nn/2 then
                                    mm = 1
                                end
                            elseif ii == "mandrake" then
                                if math.random() > nn/20 then
                                    mm = 1
                                end
                            elseif ii == "eggplant" then
                                if math.random() > nn/15 then
                                    mm = 1
                                end
                            elseif ii == "dragonfruit" then
                                if math.random() > nn/10 then
                                    mm = 1
                                end
                            elseif ii == "durian" then
                                if math.random() > nn/8 then
                                    mm = 1
                                end
                            elseif ii == "pumpkin" then
                                if math.random() > nn/12 then
                                    mm = 1
                                end
                            elseif ii == "watermelon" then
                                if math.random() > nn/6 then
                                    mm = 1
                                end
                            elseif ii == "carrot" then
                                if math.random() > nn/8 then
                                    mm = 1
                                end
                            elseif ii == "taffy" then
                                if math.random() > nn/12 then
                                    mm = 1
                                end
                            elseif ii == "corn" then
                                if math.random() > nn/4 then
                                    mm = 1
                                end
                            elseif ii == "pomegranate" then
                                if math.random() > nn/4 then
                                    mm = 1
                                end
                            end
                            
                        if mm == 0 then
                            break
                        else
                            dd = ll*4+math.floor(math.random()*ll*2-0.01+1)
                        end
                    end
                    
                end
                    
                    if dd%24 == 22 or dd%24 == 21 then
                        
                        for o=1,12 do
                            act.target.Transform:SetPosition(act.target.yuanshix+1.5,0,act.target.yuanshiz-1.5)
                            act.doer.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_warningbell")
                            Sleep(0.05)
                            act.target.Transform:SetPosition(act.target.yuanshix-1.5,0,act.target.yuanshiz+1.5)
                            act.doer.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_warningbell")
                            Sleep(0.05)
                            act.target.Transform:SetPosition(act.target.yuanshix-1.5,0,act.target.yuanshiz-1.5)
                            act.doer.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_warningbell")
                            Sleep(0.05)
                            act.target.Transform:SetPosition(act.target.yuanshix+1.5,0,act.target.yuanshiz+1.5)
                            act.doer.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_warningbell")
                            Sleep(0.05)
                        end
                    end
                
                    ----------判断物品
                    for k = 1, dd do
                        act.doer.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_warningbell")
                        bb = bb + 1
                        if bb > ll then
                            bb = bb - ll
                        end
                        local aa = act.target.zhuanzhuanle.shangdianshangpin2[bb]
                        if aa then
                            act.target.Transform:SetPosition(act.target.zhuanzhuanle.shangdianshangpinx2[bb], 0, act.target.zhuanzhuanle.shangdianshangpinz2[bb]) 
                            if k == dd then
                                
                                
                                    local laohuji5 = {}
                                    for l,j in pairs(act.target.zhuanzhuanle.laohuji3) do
                                        if j.prefab == act.target.zhuanzhuanle.laohuji3[bb].prefab then
                                            for a,b in pairs(j.laohuji2) do
                                                if b:IsValid() then
                                                
                                                    local laohujii = j.laohuji
                                                    if bb == 3 or bb == 6 or bb == 9 or bb == 12 or bb == 15 or bb == 18 or bb == 23 then
                                                        laohujii = 2
                                                    end
                                                
                                                
                                                    b.laohuji4 = (b.laohuji4 or 0) + laohujii
                                                    if not table.contains(laohuji5,b) then
                                                        table.insert(laohuji5,b)
                                                    end
                                                    if table.contains(b.teshuchenghao,"水果达人") then
                                                            if bb ~= 4 and bb ~= 16 and bb ~= 3 and bb ~= 6 and bb ~= 9 and bb ~= 12 and bb ~= 15 and bb ~= 18 and bb ~= 23 and math.random() < 0.25 then
                                                                local shuiguo = SpawnPrefab(act.target.zhuanzhuanle.shangdianshangpin2[bb])
                                                                if shuiguo then
                                                                    b.components.inventory:GiveItem(shuiguo)
                                                                end
                                                            end
                                                        end
                                                end
                                            end
                                        end
                                    end
                                    
                                    
                                    for a,b in pairs(laohuji5) do
                                        if b:IsValid() then
                                            TheNet:Announce((b.xiangziname or "").."在<大乐透>中获得<"..(b.laohuji4)..">金元宝".."")
                                            if b.laohuji4 > 200 then b.laohuji4 = 200 end
                                            GLOBAL.geihuangjinxiaoguo(b,b.laohuji4)
                                            b.laohuji4 = 0
                                        end
                                    end
                                
                                
                                
                                            
                                
                        
                            
                            end
                        end
                        if k < 4 then
                            cc = cc - 0.1
                        elseif k < 9 then
                            cc = cc - 0.04
                        elseif dd - k < 3 then
                            cc = cc + 0.1
                        elseif dd - k < 7 then
                            cc = cc + 0.05
                        elseif dd - k < 25 then
                            cc = cc + 0.01
                        end
                        Sleep(cc)
                    end
                    
                    
                    if bb == 4 or bb == 16 then
                        
                        for o=1,8 do
                            act.target.Transform:SetPosition(act.target.yuanshix+1.5,0,act.target.yuanshiz-1.5)
                            act.doer.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_warningbell")
                            Sleep(0.05)
                            act.target.Transform:SetPosition(act.target.yuanshix-1.5,0,act.target.yuanshiz+1.5)
                            act.doer.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_warningbell")
                            Sleep(0.05)
                        end
                        local cc = 0.01
                        local dd = ll*0+math.floor(math.random()*ll*2-0.01+1)
                        ----------判断物品
                        for q = 1,1000 do 
                            
                            local jj = dd%ll
                            if jj == 0 then jj = ll end
                            local ii = act.target.zhuanzhuanle.shangdianshangpin2[jj]
                            if ii then
                                local nn = 1
            
                            local mm = 0
                            if jj == 3 or jj == 6 or jj == 9 or jj == 12 or jj == 15 or jj == 18 or jj == 23 then
                                if math.random() > nn/2 then
                                    mm = 1
                                end
                            elseif ii == "mandrake" then
                                if math.random() > nn/20 then
                                    mm = 1
                                end
                            elseif ii == "eggplant" then
                                if math.random() > nn/15 then
                                    mm = 1
                                end
                            elseif ii == "dragonfruit" then
                                if math.random() > nn/10 then
                                    mm = 1
                                end
                            elseif ii == "durian" then
                                if math.random() > nn/8 then
                                    mm = 1
                                end
                            elseif ii == "pumpkin" then
                                if math.random() > nn/12 then
                                    mm = 1
                                end
                            elseif ii == "watermelon" then
                                if math.random() > nn/6 then
                                    mm = 1
                                end
                            elseif ii == "carrot" then
                                if math.random() > nn/8 then
                                    mm = 1
                                end
                            elseif ii == "taffy" then
                                if math.random() > nn/12 then
                                    mm = 1
                                end
                            elseif ii == "corn" then
                                if math.random() > nn/4 then
                                    mm = 1
                                end
                            elseif ii == "pomegranate" then
                                if math.random() > nn/4 then
                                    mm = 1
                                end
                            end
                                    
                                if mm == 0 then
                                    break
                                else
                                    dd = ll*0+math.floor(math.random()*ll*2-0.01+1)
                                end
                            end
                            
                        end
                        ----------判断物品
                        for k = 1, dd do
                            act.doer.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_warningbell")
                            bb = bb + 1
                            if bb > ll then
                                bb = bb - ll
                            end
                            local aa = act.target.zhuanzhuanle.shangdianshangpin2[bb]
                            if aa then
                                act.target.Transform:SetPosition(act.target.zhuanzhuanle.shangdianshangpinx2[bb], 0, act.target.zhuanzhuanle.shangdianshangpinz2[bb]) 
                                if k == dd then
                                        local laohuji5 = {}
                                        for l,j in pairs(act.target.zhuanzhuanle.laohuji3) do
                                            if j.prefab == act.target.zhuanzhuanle.laohuji3[bb].prefab then
                                                for a,b in pairs(j.laohuji2) do
                                                    if b:IsValid() then
                                                        local laohujii = j.laohuji
                                                        if bb == 3 or bb == 6 or bb == 9 or bb == 12 or bb == 15 or bb == 18 or bb == 23 then
                                                            laohujii = 2
                                                        end
                                                        b.laohuji4 = (b.laohuji4 or 0) + laohujii
                                                        if not table.contains(laohuji5,b) then
                                                            table.insert(laohuji5,b)
                                                        end
                                                        if table.contains(b.teshuchenghao,"水果达人") then
                                                            if bb ~= 4 and bb ~= 16 and bb ~= 3 and bb ~= 6 and bb ~= 9 and bb ~= 12 and bb ~= 15 and bb ~= 18 and bb ~= 23 and math.random() < 0.25 then
                                                                local shuiguo = SpawnPrefab(act.target.zhuanzhuanle.shangdianshangpin2[bb])
                                                                if shuiguo then
                                                                    b.components.inventory:GiveItem(shuiguo)
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                        for a,b in pairs(laohuji5) do
                                            if b:IsValid() then
                                                TheNet:Announce((b.xiangziname or "").."在<大乐透>中获得<"..(b.laohuji4)..">金元宝".." 最大200")
                                                if b.laohuji4 > 200 then b.laohuji4 = 200 end
                                                GLOBAL.geihuangjinxiaoguo(b,b.laohuji4)
                                                if not table.contains(b.teshuchenghao,"水果达人") then
                                                b.chenghaoshuiguodaren = (b.chenghaoshuiguodaren or 0) + b.laohuji4
                                                if b.chenghaoshuiguodaren > 12000 then
                                                    table.insert(b.teshuchenghao,"水果达人")
                                                    TheNet:Announce((b.xiangziname or "").."完成成就<".."水果达人>")
                                                end
												end
                                                b.laohuji4 = 0
                                            end
                                        end
                                end
                            end
                            if k < 4 then
                                
                            elseif k < 9 then
                                
                            elseif dd - k < 3 then
                                
                            elseif dd - k < 7 then
                                
                            elseif dd - k < 25 then
                                
                            end
                            Sleep(cc)
                        end
                        Sleep(1)
                        if math.random() <= 1 then
                            for o=1,8 do
                                act.target.Transform:SetPosition(act.target.yuanshix+1.5,0,act.target.yuanshiz-1.5)
                                act.doer.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_warningbell")
                                Sleep(0.05)
                                act.target.Transform:SetPosition(act.target.yuanshix-1.5,0,act.target.yuanshiz+1.5)
                                act.doer.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_warningbell")
                                Sleep(0.05)
                            end
                            local cc = 0.01
                            local dd = ll*0+math.floor(math.random()*ll*2-0.01+1)
                            ----------判断物品
                            for q = 1,1000 do 
                                
                                local jj = dd%ll
                                if jj == 0 then jj = ll end
                                local ii = act.target.zhuanzhuanle.shangdianshangpin2[jj]
                                if ii then
                                    local nn = 1
            
                            local mm = 0
                            if jj == 3 or jj == 6 or jj == 9 or jj == 12 or jj == 15 or jj == 18 or jj == 23 then
                                if math.random() > nn/2 then
                                    mm = 1
                                end
                            elseif ii == "mandrake" then
                                if math.random() > nn/20 then
                                    mm = 1
                                end
                            elseif ii == "eggplant" then
                                if math.random() > nn/15 then
                                    mm = 1
                                end
                            elseif ii == "dragonfruit" then
                                if math.random() > nn/10 then
                                    mm = 1
                                end
                            elseif ii == "durian" then
                                if math.random() > nn/8 then
                                    mm = 1
                                end
                            elseif ii == "pumpkin" then
                                if math.random() > nn/12 then
                                    mm = 1
                                end
                            elseif ii == "watermelon" then
                                if math.random() > nn/6 then
                                    mm = 1
                                end
                            elseif ii == "carrot" then
                                if math.random() > nn/8 then
                                    mm = 1
                                end
                            elseif ii == "taffy" then
                                if math.random() > nn/12 then
                                    mm = 1
                                end
                            elseif ii == "corn" then
                                if math.random() > nn/4 then
                                    mm = 1
                                end
                            elseif ii == "pomegranate" then
                                if math.random() > nn/4 then
                                    mm = 1
                                end
                            end
                                        
                                    if mm == 0 then
                                        break
                                    else
                                        dd = ll*0+math.floor(math.random()*ll*2-0.01+1)
                                    end
                                end
                                
                            end
                            ----------判断物品
                            for k = 1, dd do
                                act.doer.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_warningbell")
                                bb = bb + 1
                                if bb > ll then
                                    bb = bb - ll
                                end
                                local aa = act.target.zhuanzhuanle.shangdianshangpin2[bb]
                                if aa then
                                    act.target.Transform:SetPosition(act.target.zhuanzhuanle.shangdianshangpinx2[bb], 0, act.target.zhuanzhuanle.shangdianshangpinz2[bb]) 
                                    if k == dd then
                                            local laohuji5 = {}
                                            for l,j in pairs(act.target.zhuanzhuanle.laohuji3) do
                                                if j.prefab == act.target.zhuanzhuanle.laohuji3[bb].prefab then
                                                    for a,b in pairs(j.laohuji2) do
                                                        if b:IsValid() then
                                                            local laohujii = j.laohuji
                                                            if bb == 3 or bb == 6 or bb == 9 or bb == 12 or bb == 15 or bb == 18 or bb == 23 then
                                                                laohujii = 2
                                                            end
                                                            b.laohuji4 = (b.laohuji4 or 0) + laohujii
                                                            if not table.contains(laohuji5,b) then
                                                                table.insert(laohuji5,b)
                                                            end
                                                            if table.contains(b.teshuchenghao,"水果达人") then
                                                            if bb ~= 4 and bb ~= 16 and bb ~= 3 and bb ~= 6 and bb ~= 9 and bb ~= 12 and bb ~= 15 and bb ~= 18 and bb ~= 23 and math.random() < 0.25 then
                                                                local shuiguo = SpawnPrefab(act.target.zhuanzhuanle.shangdianshangpin2[bb])
                                                                if shuiguo then
                                                                    b.components.inventory:GiveItem(shuiguo)
                                                                end
                                                            end
                                                        end
                                                        end
                                                    end
                                                end
                                            end
                                            for a,b in pairs(laohuji5) do
                                                if b:IsValid() then
                                                    TheNet:Announce((b.xiangziname or "").."在<水果机>中获得<"..(b.laohuji4)..">黄金".." 最大200")
                                                    if b.laohuji4 > 200 then b.laohuji4 = 200 end
                                                    GLOBAL.geihuangjinxiaoguo(b,b.laohuji4)
                                                    if not table.contains(b.teshuchenghao,"水果达人") then
                                                b.chenghaoshuiguodaren = (b.chenghaoshuiguodaren or 0) + b.laohuji4
                                                if b.chenghaoshuiguodaren > 12000 then
                                                    table.insert(b.teshuchenghao,"水果达人")
                                                    TheNet:Announce((b.xiangziname or "").."完成成就<".."水果达人>")
                                                end
                                            end
                                                    b.laohuji4 = 0
                                                end
                                            end
                                    end
                                end
                                if k < 4 then
                                    
                                elseif k < 9 then
                                    
                                elseif dd - k < 3 then
                                    
                                elseif dd - k < 7 then
                                    
                                elseif dd - k < 25 then
                                    
                                end
                                Sleep(cc)
                            end
                            Sleep(2)
                        else
                            Sleep(2)
                        end
                    else
                        Sleep(2)
                    end
                    
                    if act.target.zhuanzhuanle then
                        local p1x, p1y, p1z = act.target.zhuanzhuanle.Transform:GetWorldPosition()
                        act.target.Transform:SetPosition(act.target.yuanshix or (p1x+1), 0, act.target.yuanshiz or (p1z+1)) 
                        act.target.zhuanzhuanle2 = 1
                        act.target.zhuanzhuanle.laohujizhuangtai = 0
                        for l , j in pairs(act.target.zhuanzhuanle.laohuji3) do
                            j.laohuji2 = {}
                        end
                    end
                end)
            else
                act.doer.components.talker:Say("请先下注或金元宝不足") 
            end
        end
        ---------------------------------老虎机
        ---------------------------------转转乐
        if act.target.shangdianzhanshi == 1 then
            if (act.target.zhuanzhuanle2 or 0) == 1 and act.target.shangdianjiage and (GLOBAL.jisuanhanjinliang(act.doer) >= act.target.shangdianjiage or table.contains(act.doer.teshuchenghao,"嗜赌如命") and act.doer.components.health.currenthealth>act.doer.components.health.maxhealth*1/3) then
                if not table.contains(act.doer.teshuchenghao,"嗜赌如命") or GLOBAL.jisuanhanjinliang(act.doer) >= act.target.shangdianjiage or act.doer.components.health.currenthealth <= act.doer.components.health.maxhealth*1/3 then 
                    GLOBAL.koujinkuai(act.doer,act.target.shangdianjiage) 
                else 
                    local wodexue = (math.random()>.5 and "它抽走了我的血！") or "啊！还是挺疼的！"
                    act.doer.components.talker:Say(wodexue)
                    GLOBAL.shidurumingkouxue(act.doer,act.target.shangdianjiage*4) 
                end
                if TUNING.ZHUWANG then TUNING.ZHUWANG.shangdianjilu22 = TUNING.ZHUWANG.shangdianjilu22 + act.target.shangdianjiage end
                -- act.doer.components.sanity:DoDelta(2)
                act.target.zhuanzhuanle2 = 0
                local p3x, p3y, p3z = act.target.Transform:GetWorldPosition()
                act.target.yuanshix = p3x
                act.target.yuanshiz = p3z
                act.target:StartThread(function()
                    local bb = 0
                    local cc = 0.51
                    local ll = #act.target.zhuanzhuanle.shangdianshangpin
                    local dd = ll*4+math.floor(math.random()*ll*2-0.01+1)
                    ----------判断物品
                    local jj = dd%ll
                    if jj == 0 then jj = ll end
                    local ii = act.target.zhuanzhuanle.shangdianshangpin[jj]
                    if ii then
                        local nn = 2.25
        
                        local mm = 0
                        if ii == "armormarble" then
                            if math.random() > nn/75 then
                                mm = 1
                            end
                        elseif ii == "multitool_axe_pickaxe" then
                            if math.random() > nn/250 then
                                mm = 1
                            end
                        elseif ii == "armorpotion" then
                            if math.random() > nn/2.5 then
                                mm = 1
                            end
                        elseif ii == "healthpotion" then
                            if math.random() > nn/2.5 then
                                mm = 1
                            end
                        elseif ii == "powerpotion" then
                            if math.random() > nn/5 then
                                mm = 1
                            end
                        elseif ii == "staff_tornado" then
                            if math.random() > nn/150 then
                                mm = 1
                            end
                        elseif ii == "backpack" then
                            if math.random() > nn/50 then
                                mm = 1
                            end
                        elseif ii == "nightmare_timepiece" and (jj == 1 or jj == 4 or jj == 15) then
                            if math.random() > nn/50 then
                                mm = 1
                            end
                        elseif ii == "nightmare_timepiece" and jj == 6 then
                            if math.random() > nn/5 then
                                mm = 1
                            end
                        elseif ii == "nightmare_timepiece" and jj == 12 then
                            if math.random() > nn/25 then
                                mm = 1
                            end
                        ----------------------------------赌博
                        elseif ii == "lucky_goldnugget" then
                            if act.target.zhuanzhuanle.shangdianshangpindubo and act.target.zhuanzhuanle.shangdianshangpindubo[jj] then
                                if math.random() > nn/(act.target.zhuanzhuanle.shangdianshangpindubo[jj]/2) then
                                    mm = 1
                                end
                            end
                        ----------------------------------赌博
                        end
                        if mm == 1 then
                            local pp = 1/6
                            local oo = math.random()
                            if oo < pp*1 then
                                mm = 3
                            elseif oo < pp*2 then
                                mm = 10
                            elseif oo < pp*3 then
                                mm = 13
                            elseif oo < pp*4 then
                                mm = 19
                            elseif oo < pp*5 then
                                mm = 20
                            elseif oo <= 1 then
                                mm = 21
                            end
                            dd = dd - jj + mm
                        end
                    end
                    ----------判断物品
                    for k = 1, dd do
                        act.doer.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_warningbell")
                        bb = bb + 1
                        if bb > ll then
                            bb = bb - ll
                        end
                        local aa = act.target.zhuanzhuanle.shangdianshangpin[bb]
                        if aa then
                            act.target.Transform:SetPosition(act.target.zhuanzhuanle.shangdianshangpinx[bb], 0, act.target.zhuanzhuanle.shangdianshangpinz[bb]) 
                            if k == dd and act.doer:IsValid() then
                                if aa == "lucky_goldnugget" and act.target.zhuanzhuanle.shangdianshangpindubo[bb] then
                                    GLOBAL.geihuangjinxiaoguo(act.doer,act.target.zhuanzhuanle.shangdianshangpindubo[bb])
                                    if bb > 0 then
                                        
                                        TheNet:Announce((act.doer.xiangziname or "").."在<转转乐>中获得<"..(act.target.zhuanzhuanle.shangdianshangpindubo[bb])..">金元宝")
                                        
                                    end
                                else
                                    local ff = SpawnPrefab(aa)
                                    
                            
                                    
                                    if ff then
                                        ff.siwangzhita = 0
                                        act.doer.components.inventory:GiveItem(ff) 
                                        if bb > 0 then
                                            if TUNING.ZHUWANG then 
                                                local aaaa = 0
                                                if ff.prefab == "waffles" then
                                                    aaaa = 8
                                                elseif ff.prefab == "armorpotion" then
                                                    aaaa = 3.3
                                                elseif ff.prefab == "healthpotion" then
                                                    aaaa = 3.3
                                                elseif ff.prefab == "powerpotion" then
                                                    aaaa = 6.6
                                                elseif ff.prefab == "armormarble" then
                                                    aaaa = 100
                                                elseif ff.prefab == "armorwood" then
                                                    aaaa = 6
                                                elseif ff.prefab == "multitool_axe_pickaxe" then
                                                    aaaa = 333
                                                elseif ff.prefab == "diviningrod" then
                                                    aaaa = 40
                                                elseif ff.prefab == "spear" then
                                                    aaaa = 6
                                                elseif ff.prefab == "tentaclespike" then
                                                    aaaa = 40
                                                elseif ff.prefab == "staff_tornado" then
                                                    aaaa = 200
                                                elseif ff.prefab == "armorruins" then
                                                    aaaa = 600
                                                elseif ff.prefab == "walrus_tusk" then
                                                    aaaa = 180
                                                elseif ff.prefab == "krampus_sack" then
                                                    aaaa = 600
                                                elseif ff.prefab == "boomerang" then
                                                    aaaa = 12
                                                elseif ff.prefab == "backpack" then
                                                    aaaa = 66
                                                elseif ff.prefab == "nightmare_timepiece" and (bb == 1 or bb == 4 or bb == 15) then
                                                    aaaa = 66
                                                elseif ff.prefab == "nightmare_timepiece" and bb == 6 then
                                                    aaaa = 6.6
                                                elseif ff.prefab == "nightmare_timepiece" and bb == 12 then
                                                    aaaa = 33
                                                end 
                                                TUNING.ZHUWANG.shangdianjilu22 = TUNING.ZHUWANG.shangdianjilu22 - aaaa
                                                
                                            end
                                            local zhuanzhuanletishi = ""
                                            if bb == 1 then
                                            elseif bb == 2 then
                                                zhuanzhuanletishi = "步行手杖"
                                            elseif bb == 4 then
                                            elseif bb == 5 then
                                                zhuanzhuanletishi = "旋风"
                                            elseif bb == 6 then
                                                zhuanzhuanletishi = "长矛"      ------------这里
                                            elseif bb == 7 then
                                                zhuanzhuanletishi = "远古武器"
                                            elseif bb == 8 then
                                                zhuanzhuanletishi = "坎普斯背包"
                                            elseif bb == 9 then
                                                zhuanzhuanletishi = "远古盔甲"
                                            elseif bb == 11 then
                                                zhuanzhuanletishi = "黄金1个"
                                            elseif bb == 12 then
                                            elseif bb == 14 then
                                                zhuanzhuanletishi = "远古斧镐"
                                            elseif bb == 15 then
                                            elseif bb == 16 then
                                                zhuanzhuanletishi = "铥矿1个"
                                            elseif bb == 17 then
                                                zhuanzhuanletishi = "黄金1个"
                                            elseif bb == 18 then
                                                zhuanzhuanletishi = "黄金1个"
                                            elseif bb == 22 then
                                                zhuanzhuanletishi = "黄金1个"
                                            elseif bb == 23 then
                                                zhuanzhuanletishi = "黄金1个"
                                            elseif bb == 24 then
                                                zhuanzhuanletishi = "远古头盔"
                                            end
                                            if zhuanzhuanletishi ~= "" then
                                                TheNet:Announce((act.doer.name).."在<转转乐>中获得<"..zhuanzhuanletishi..">")
                                            end
                                        end
                                        if ff.prefab == "nightmare_timepiece" then
                                            ff:Remove()
                                            if bb == 1 then
                                            elseif bb == 15 then                                                
                                            elseif bb == 4 then
                                            elseif bb == 6 then
                                            elseif bb == 12 then
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if k < 4 then
                            cc = cc - 0.1
                        elseif k < 9 then
                            cc = cc - 0.04
                        elseif dd - k < 3 then
                            cc = cc + 0.1
                        elseif dd - k < 7 then
                            cc = cc + 0.05
                        elseif dd - k < 25 then
                            cc = cc + 0.01
                        end
                        Sleep(cc)
                    end
                    Sleep(1)
                    if act.target.zhuanzhuanle then
                        local p1x, p1y, p1z = act.target.zhuanzhuanle.Transform:GetWorldPosition()
                        act.target.Transform:SetPosition(act.target.yuanshix or (p1x+1), 0, act.target.yuanshiz or (p1z+1)) 
                        act.target.zhuanzhuanle2 = 1
                    end
                end)
            else
                act.doer:DoTaskInTime(0.5, function()
                    act.doer.components.talker:Say("需要金元宝"..(act.target.shangdianjiage or 0)) 
                end)
            end
        end
       
        return true
    end
    -------------------------------------修改
    if act.doer.components.inventory ~= nil and
        act.target ~= nil and
        act.target.components.inventoryitem ~= nil and
        (act.target.components.inventoryitem.canbepickedup or
        (act.target.components.inventoryitem.canbepickedupalive and not act.doer:HasTag("player"))) and
        not (act.target:IsInLimbo() or
            (act.target.components.burnable ~= nil and act.target.components.burnable:IsBurning()) or
            (act.target.components.projectile ~= nil and act.target.components.projectile:IsThrown())) then

        act.doer:PushEvent("onpickupitem", { item = act.target })
        if not act.target.components.inventoryitem.cangoincontainer and act.target.components.equippable and act.doer.components.inventory:GetEquippedItem(act.target.components.equippable.equipslot) then
            local item = act.doer.components.inventory:GetEquippedItem(act.target.components.equippable.equipslot)
            if item.components.inventoryitem and item.components.inventoryitem.cangoincontainer then
                act.doer.components.inventory:GiveItem(act.doer.components.inventory:Unequip(act.target.components.equippable.equipslot))
            else
                act.doer.components.inventory:DropItem(act.doer.components.inventory:GetEquippedItem(act.target.components.equippable.equipslot))
            end
            act.doer.components.inventory:Equip(act.target)
            return true
        end

        if act.doer:HasTag("player") and act.target.components.equippable and not act.doer.components.inventory:GetEquippedItem(act.target.components.equippable.equipslot) then
            act.doer.components.inventory:Equip(act.target)
        else
            act.doer.components.inventory:GiveItem(act.target, nil, act.target:GetPosition())
        end
        return true
    end
end


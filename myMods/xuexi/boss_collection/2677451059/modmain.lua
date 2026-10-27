--[[
	BUG反馈Q群 917979244
]]
local TheNet = GLOBAL.TheNet

--------------------------------------------------
bosshealth = GetModConfigData("bosshealth")
bosshealth2 = bosshealth  
bossdefaultdamage = GetModConfigData("bossdefaultdamage")
bossdefaultdamage2 = bossdefaultdamage
bossattackrange = GetModConfigData("bossattackrange")
bossattackrange2 = bossattackrange
drop = GetModConfigData("drop")
drop2 = drop
absorptionAmountswitch = GetModConfigData("absorptionAmountswitch")
absorptionAmount = GetModConfigData("absorptionAmount")
absorptionAmount2 = absorptionAmount
KillAnnounce = GetModConfigData("KillAnnounce")
growup = GetModConfigData("growup")
growuphealth = GetModConfigData("growuphealth")
growuphealth2 = growuphealth

growup2 = GetModConfigData("growup2")
growuptime=GetModConfigData("growuptime")
growuptime2=growuptime
growuphealthtwo = GetModConfigData("growuphealthtwo")
growuphealthtwo2 = growuphealthtwo
bossSetScale =  GetModConfigData("bossSetScale")
bossSetScale2 = bossSetScale
--------------------------------------生物血量变化------------

--[[boss级生物（deerclops巨鹿,beequeen蜂后,moose鸭子,minotaur远古守护者,spiderqueen蜘蛛女王,warg狗王,dragonfly龙蝇,antlion蚁师beequeen蜂后klaus克劳斯stalker远古狩猎者
malbatross 邪天翁 stalker_forest 复活的骨架
]]

local boss = {
	"deerclops","bearger","moose","minotaur","spiderqueen","warg","dragonfly","antlion","beequeen","klaus","stalker",    --没有防御这里
	"malbatross","stalker_forest"
}
-- 因为蚁师不能直接写防御,懒得找原文件....... 直接取消他的防御状态了
local boss2 = {
	"deerclops","bearger","moose","minotaur","spiderqueen","warg","dragonfly","beequeen","klaus","stalker"
}

local function bossAmount(inst,data)
	if absorptionAmountswitch == true then --开关在modinfo里
		inst.components.health:SetAbsorptionAmount(absorptionAmount2) --防御
	end
end	
local function bosshealth(inst, data)
local day = GLOBAL.TheWorld.state.cycles	--声明
	if inst.components.health then ---- 如果目标拥有血量组件 则   --这里算一种保护吧,反正能写就写吧
	    if bosshealth2 == 66666 then --这里主要是为了设置血量为1才加上去的 如果modinfo里没有填healthmin那么可以去掉 下3行		
		inst.components.health.currenthealth = 1 --当前血量
        inst.components.health.maxhealth =   1 --最大血量
		elseif	growup == true then	 --这里是天数的开关
		inst.components.health.maxhealth = inst.components.health.currenthealth * bosshealth2 + day * growuphealth2 
		inst.components.health.currenthealth = inst.components.health.currenthealth * bosshealth2  + day * growuphealth2 
		else
		inst.components.health.maxhealth = inst.components.health.currenthealth * bosshealth2  --最大血量 这里需要注意一下 必须是先最大血量再当前血量 不然的话怪物会出现(当前血量/最大血量)(4000/50000)这种情况
	    inst.components.health.currenthealth = inst.components.health.currenthealth * bosshealth2 --当前血量
		end
	end	
	if inst.components.combat then ---- 如果目标拥有攻击组件
	    inst.components.combat.defaultdamage = inst.components.combat.defaultdamage * bossdefaultdamage2 --bossdefaultdamage2 倍攻击 bossdefaultdamage2的值在modinfo里设置也可以直接把bossdefaultdamage2改成数值
		inst.components.combat.attackrange=inst.components.combat.attackrange * bossattackrange2 --攻击范围
		inst.components.combat.hitrange=inst.components.combat.hitrange * bossattackrange2 --aoe范围 其实我自己也不清楚反正是这么理解的
	end
	if inst.Transform then 
	   inst.Transform:SetScale(bossSetScale2, bossSetScale2,bossSetScale2) --设置大小
	end
	if growup2 == true then --开关在modinfo里
		if IsServer  and inst.components.health.currenthealth > 0 then  -- 血量保护
 		inst.components.health:StartRegen(growuphealthtwo2, growuptime2)  --自动回血 inst.components.health:StartRegen(x, y) X是一次回几点 Y是几秒回一次
		end
	end
	inst:ListenForEvent("death", function() --死亡后触发
	while drop2 >= 1 do --循环 drop2 大于等于 1 运行下边
	drop2 = drop2 - 1 	
	inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))  --额外掉落1倍
	--TheNet:Announce("〖循环数 〗为【"..a.."】")
	end
	if  drop2 < 1 then --上边把drop2循环到小于1了
	    if math.random() < drop2 then
		    inst.components.lootdropper:DropLoot(GLOBAL.Vector3(inst.Transform:GetWorldPosition()))		
	    end
	end	
	drop2 = drop  --恢复drop2的值  使上边再循环 不写这个的话drop就永远小于1了
	end)
-------------击杀公告	
	local function siwangongao(inst, data)
        TheNet:Announce("〖 "..inst:GetDisplayName().." 〗被【 "..data.attacker:GetDisplayName().." 】击杀")
    end
    local function siwang(inst)
        inst:ListenForEvent("attacked", siwangongao)
    end
	if KillAnnounce == true then 
    inst:ListenForEvent("death", siwang)
	end	
end

for k,v in pairs(boss) do
	AddPrefabPostInit(v, bosshealth)
end
for k,v in pairs(boss2) do
	AddPrefabPostInit(v, bossAmount)
end
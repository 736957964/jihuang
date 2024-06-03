local SpawnPrefab = GLOBAL.SpawnPrefab
if GLOBAL.TheNet and GLOBAL.TheNet:GetIsServer() then
	
	--出怪列表
	local re = {
	{prefab="walrus",name="海象",p1=4,p2=5,n1=1,n2=2},
	{prefab="krampus",name="小偷",p1=4,p2=5,n1=1,n2=2},
	{prefab="rook",name="战车",p1=4,p2=5,n1=1,n2=2},
	{prefab="spat",name="鋼羊",p1=4,p2=5,n1=1,n2=2},
	{prefab="deerclops",name="巨鹿",p1=6,p2=7,n1=1,n2=1},
	{prefab="bearger",name="比尔格熊",p1=6,p2=7,n1=1,n2=1},
	{prefab="moose",name="巨鹿",p1=6,p2=7,n1=1,n2=1},
	{prefab="dragonfly",name="蜻蜓",p1=6,p2=7,n1=1,n2=1},
	{prefab="toadstool",name="蛤蟆",p1=8,p2=9,n1=1,n2=1},
	
	}
	--奖励列表
	local rewards = {
	{prefab="bluegem",name="蓝宝石",n=1},
	{prefab="greengem",name="绿宝石",n=1},
	{prefab="orangegem",name="橙宝石",n=1},
	{prefab="purplegem",name="紫宝石",n=1},
	{prefab="redgem",name="红宝石",n=1},
	{prefab="bonestew",name="肉汤",n=1},
	{prefab="butter",name="黄油",n=1},
	{prefab="butterflymuffin",name="奶油松饼",n=1},
	{prefab="cookedmandrake",name="熟曼特拉草",n=1},
	{prefab="cookedmeat",name="大熟肉",n=1},
	{prefab="cookedmonstermeat",name="熟怪物肉",n=1},
	{prefab="cookedsmallmeat",name="小熟肉",n=1},
	{prefab="dragonpie",name="龙馅饼",n=1},
	{prefab="eggplant",name="茄子",n=1},
	{prefab="eggplant_cooked",name="熟茄子",n=1},
	{prefab="eggplant_seeds",name="茄子种子",n=1},
	{prefab="fish",name="鱼",n=1},
	{prefab="fish_cooked",name="熟鱼",n=1},
	{prefab="fishsticks",name="鱼肉条",n=1},
	{prefab="fishtacos",name="玉米饼包炸鱼",n=1},
	{prefab="frogglebunwich",name="青蛙圆面包三明治",n=1},
	{prefab="fruitmedley",name="水果拼盘",n=1},
	{prefab="honeyham",name="蜜汁火腿",n=1},
	{prefab="honeynuggets",name="甜蜜金砖",n=1},
	{prefab="jammypreserves",name="果酱蜜饯",n=1},
	{prefab="kabobs",name="肉串",n=1},
	{prefab="mandrake",name="曼德拉草",n=1},
	{prefab="mandrakesoup",name="曼德拉草汤",n=1},
	{prefab="meat_dried",name="大干肉",n=1},




	}
	
	local function ItemDropAll(player)
		if player and player.components and player.components.inventory then
			for z = 1,1 do
				for k = 1, player.components.inventory.maxslots do
					local v = player.components.inventory.itemslots[k]
					if v ~= nil then player.components.inventory:DropItem(v) end
				end
			end
		end
	end
	
	local function WeightedChoice(weights)
		local sum = 0
		for k,v in pairs(weights) do
			sum = sum + 1
		end
		local rnd = math.random()*sum
		for k,v in pairs(weights) do
			rnd = rnd - 1
			if rnd < 0 then
				return k
			end
		end
	end
	local function Give(inst, res, count)
		for i=1,count do
			local item = GLOBAL.DebugSpawn(res.prefab)
			if res.b then
				local x, y, z = inst.Transform:GetWorldPosition()
				item.Transform:SetPosition(x, y, z)
			else
				inst.components.inventory:GiveItem(item)
			end
		end
	end
	
	local function wql(inst,q1,q2,gw,zs)
		local x, y, z = inst.Transform:GetWorldPosition()
		for a = x-q1,x+q1,1 do
			--SpawnPrefab("wall_stone").Transform:SetPosition(a, y, z + q1)
			--SpawnPrefab("wall_stone").Transform:SetPosition(a, y, z - q1)
		end
		for b = z-q1,z+q1,1 do
			--SpawnPrefab("wall_stone").Transform:SetPosition(x - q1, y, b)
			--SpawnPrefab("wall_stone").Transform:SetPosition(x + q1, y, b)
		end
		for a = x-q2,x+q2,1 do
			--SpawnPrefab("wall_stone").Transform:SetPosition(a, y, z + q2)
			--SpawnPrefab("wall_stone").Transform:SetPosition(a, y, z - q2)
		end
		for b = z-q2,z+q2,1 do
			--SpawnPrefab("wall_stone").Transform:SetPosition(x - q2, y, b)
			--SpawnPrefab("wall_stone").Transform:SetPosition(x + q2, y, b)
		end
		if gw ~= "" then
			for i = 1,zs,1 do
				SpawnPrefab(gw).Transform:SetPosition(x, y, z)
			end
		end
	end
	
	
	--按脏话类型分成4等，1、2层墙；2、4层墙；3、4层墙，全掉落；4、6层墙、全掉落。
	local zh = {
	{str="TMD",lev = 1},
	{str="CNMD",lev = 4},
	{str="TMD",lev = 1},
	{str="NTMN",lev = 1},
	{str="他妈的",lev = 1},
	{str="他妈地",lev = 1},
	{str="他妈滴",lev = 1},
	{str="他妈嘀",lev = 1},
	{str="你麻痹",lev = 4},
	{str="草你吗",lev = 1},
	{str="操你妈",lev = 1},
	{str="傻逼",lev = 1},
	{str="吃大姨妈",lev = 1},
	{str="你那鸟样",lev = 1},
	{str="你他妈",lev = 1},
	{str="你个婊子",lev = 1},
	{str="c你妈",lev = 1},
	{str="炒shi给你吃",lev = 1},
	{str="你妈生你",lev = 1},
	{str="吃了鸡巴还不刷牙",lev = 1},
	{str="麻了个痹",lev = 1},
	{str="麻了个逼",lev = 1},
	{str="麻了个B",lev = 1},
	{str="你妈逼",lev = 2},
	{str="血逼",lev = 1},
	{str="烂逼",lev = 1},
	{str="蝴蝶逼",lev = 1},
	{str="馒头逼",lev = 1},
	{str="一线天臭逼",lev = 3},
	{str="就你这怂比",lev = 2},
	{str="内裤跪舔",lev = 6},
	{str="婊子养的",lev = 2},
	{str="操你",lev = 1},
	{str="狗逼",lev = 1},
	{str="杂种",lev = 3},
	{str="我操的你",lev = 1},
	{str="我操你",lev = 2},
	{str="贱逼",lev = 2},
	{str="傻子",lev = 1},
	{str="贱货",lev = 2},
	{str="你垃圾",lev = 1},
	{str="你个垃圾",lev = 1},
	{str="你个死垃圾",lev = 1},
	{str="你妈生你无屁眼",lev = 4},
	{str="白痴",lev = 1},
	{str="滚你妈",lev = 1},
	{str="你妹",lev = 2},
	{str="儿子",lev = 1},
	{str="老子",lev = 1},
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	---------------Main Function
	local net_say = GLOBAL.Networking_Say
	GLOBAL.Networking_Say = function (guid, userid, name, prefab, message, colour, whisper, ...)
		net_say(guid, userid, name, prefab, message, colour, whisper, ...)
		
		--------不需要的话注释这段
		local sum = 0
		for k,v in pairs(zh) do
			sum = sum + 1
		end
		for i = 1,sum do
			if string.match(message,zh[i].str) == zh[i].str then
				for k,v in ipairs(GLOBAL.AllPlayers) do
					if v ~= nil and v.userid == userid then
						if zh[i].lev == 1 then
						    ItemDropAll(v)
							--wql(v,1,2,"",0)
						elseif zh[i].lev == 2 then
						    ItemDropAll(v)
							--wql(v,1,2,"",0)
							--wql(v,3,4,"",0)
						elseif zh[i].lev == 3 then
							ItemDropAll(v)
							--wql(v,1,2,"",0)
							--wql(v,3,4,"",0)
						elseif zh[i].lev == 4 then
							ItemDropAll(v)
							--wql(v,1,2,"",0)
							--wql(v,3,4,"",0)
							--wql(v,5,6,"",0)
						end
					end
				end
			end
		end
		--------不需要的话注释这段
		
		if string.sub(message,1,10)=="#挑战" then
			---------Find the player
			for k,v in ipairs(GLOBAL.AllPlayers) do
				if v ~= nil and v.userid == userid then
					if not v:HasTag("cjl") and not v:HasTag("playerghost")then
						local gl = math.random()
						if gl < 0.6 then
							local no = WeightedChoice(re)
							local sl = 1
							wql(v,re[no].p1,re[no].p2,re[no].prefab,sl)
							local message = "你抽到挑战怪物,你的对手是 "..re[no].name.."一只"
							if v.components.talker then
								v.components.talker:Say(message)
							end
						elseif gl < 0.3 then   
							local no = WeightedChoice(rewards)
							local n = math.floor((2+math.random()*3)*rewards[no].n)+1
							Give(v,rewards[no],n)
							local message = "你通过挑战获得 "..rewards[no].name.." * "..n
							if v.components.talker then
								v.components.talker:Say(message)
							end
						end
						if not v:HasTag("cjl") then
							v:AddTag("cjl")
							v:DoTaskInTime(480, function ()  
								v:RemoveTag("cjl")
							end
							)
						end
					else
						local message = "挑战正在冷却中。一天一次哦"
						if v.components.talker then
							v.components.talker:Say(message)
						end
					end
				end
			end
		end
	end
end



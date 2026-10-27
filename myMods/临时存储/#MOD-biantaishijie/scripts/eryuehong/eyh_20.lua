

------季节随机长度
local require = GLOBAL.require
        

function DisableMovementPrediction(wrld, player)       ----------------------降低饥荒延迟。
    if player == GLOBAL.ThePlayer then
        player:EnableMovementPrediction(false)
    end
end
	
function WaitPlayerActivated(wrld)
	 wrld:ListenForEvent("playeractivated", DisableMovementPrediction)
end

AddPrefabPostInit("world", WaitPlayerActivated)




----大箱子自动消失
AddPrefabPostInit("minotaurchest",function(inst)
	inst:DoPeriodicTask(60,function()
		if inst.components.container then
			local was_open = inst.components.container:IsOpen()
			if not inst:IsAsleep() then
				if not was_open then
				inst.components.container:Close()
			    inst.components.container:DropEverything()
				inst:Remove()
				end
			end
		end
	end)
end)
AddPlayerPostInit(function(inst)
	if inst.components.health and inst.components.health.currenthealth==0  then
	inst.components.health:DoDelta(0)
	inst.components.health:Kill()
	end
	if inst.digtime==nil and inst.components.age then
		inst.digtime=inst.components.age:GetAge()+240
	end
end)


local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    if inst.doortask ~= nil then
        inst.doortask:Cancel()
        inst.doortask = nil
    end
    if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
        inst.components.spawner:ReleaseChild()
    end
    inst.components.lootdropper:DropLoot()
    local fx = GLOBAL.SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
	if inst.prefab=="pighouse" and worker and worker.pighouse then
		worker.pighouse=worker.pighouse-1
		if worker.components.talker then
			worker.components.talker:Say("猪人房数目:"..worker.pighouse)
		end
	end
	if inst.prefab=="rabbithouse" and worker and worker.rabbithouse then
		worker.rabbithouse=worker.rabbithouse-1
		if worker.components.talker then
			worker.components.talker:Say("兔人房数目:"..worker.rabbithouse)
		end
	end
end
AddPrefabPostInit("pighouse",function(inst)
	---inst.components.workable:SetOnFinishCallback(onhammered)    ------这里是让执行这个代码。暂时不用了
end)
AddPrefabPostInit("rabbithouse",function(inst)
	---inst.components.workable:SetOnFinishCallback(onhammered)
end)
local _G = GLOBAL
local TheSim = _G.TheSim
local TheNet = _G.TheNet
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

-- 防止玩家拆毁 烧毁的蜗牛巢/猴子窝 c_spawn("slurtlehole")       ----暂时不用这些
--[[if IsServer then
	local old_ATTACK = _G.ACTIONS.ATTACK.fn
	local old_LIGHT =_G.ACTIONS.LIGHT.fn
	local old_HAMMER = _G.ACTIONS.HAMMER.fn
	_G.ACTIONS.HAMMER.fn = function(act)
		if  act.target  and act.target.prefab ~= "monkeybarrel" then
		return old_HAMMER(act)
		end	

		if  act.target  and (act.target.prefab == "monkeybarrel") 
		and not ( act.doer.Network and act.doer.Network:IsServerAdmin())then
		if act.doer ~= nil and act.doer.components.talker then
		   act.doer.components.talker:Say("不能砸")
		end
		return false
		end

	end
	_G.ACTIONS.HAMMER.fn = function(act)
		if  act.target  and act.target.prefab ~= "ancient_altar" then
		return old_HAMMER(act)
		end	

		if  act.target  and (act.target.prefab == "ancient_altar") 
		and not ( act.doer.Network and act.doer.Network:IsServerAdmin())then
		if act.doer ~= nil and act.doer.components.talker then
		   act.doer.components.talker:Say("不能砸")
		end
		return false
		end

	end
	_G.ACTIONS.ATTACK.fn = function(act)
		if  act.target  and act.target.prefab ~= "slurtlehole"  then
		return old_ATTACK(act)
		end	

		if  act.target  and (act.target.prefab == "slurtlehole" ) 
		and not ( act.doer.Network and act.doer.Network:IsServerAdmin())then
		if act.doer ~= nil and act.doer.components.talker then
		   act.doer.components.talker:Say("不能打")
		end
		return false
		end

	end
	_G.ACTIONS.ATTACK.fn = function(act)
		if  act.target  and act.target.prefab ~= "wall_ruins"  then
		return old_ATTACK(act)
		end	
		if  act.target  and (act.target.prefab == "wall_ruins" ) 
		and not ( act.doer.Network and act.doer.Network:IsServerAdmin())then
		if act.doer ~= nil and act.doer.components.talker then
		   act.doer.components.talker:Say("不能打")
		end
		return false
		end

	end
	
	_G.ACTIONS.LIGHT.fn = function(act)
		if  act.target  and act.target.prefab ~= "slurtlehole" and act.target.prefab ~= "monkeybarrel" then
		return old_LIGHT(act)
		end	
		if  act.target  and (act.target.prefab == "slurtlehole" or act.target.prefab == "monkeybarrel")  
			and not ( act.doer.Network and act.doer.Network:IsServerAdmin())then
		   if act.doer ~= nil and act.doer.components.talker then
		   act.doer.components.talker:Say("不能烧")
		   end
		return false
		end
	end
	local old_BUILD = _G.ACTIONS.BUILD.fn
	_G.ACTIONS.BUILD.fn = function(act)
		if _G.TheWorld.ismastersim == false then return old_BUILD(act) end
		if act.recipe  and act.recipe ~= "pighouse" and act.recipe ~= "rabbithouse" then 
			return old_BUILD(act)
		end
		if act.recipe  and act.recipe == "pighouse" then 
			act.doer.pighouse=act.doer.pighouse+1
			--print("猪人房数目:"..act.doer.pighouse)
			if act.doer.pighouse> 5 then
				if act.doer ~= nil and act.doer.components.talker  then
					act.doer:DoTaskInTime(0.05,function()
						act.doer.components.talker:Say("猪人房已到达上限")
					end)
				end
				
				return false
			end
			if act.doer ~= nil and act.doer.components.talker  then
				act.doer:DoTaskInTime(0.05,function()
					act.doer.components.talker:Say("猪人房数目:"..act.doer.pighouse)
				end)
			end
			return old_BUILD(act)
		end	
		if act.recipe  and act.recipe == "rabbithouse" then 
			act.doer.rabbithouse=act.doer.rabbithouse+1
			--print("猪人房数目:"..act.doer.rabbithouse)
			if act.doer.rabbithouse> 5 then
				if act.doer ~= nil and act.doer.components.talker  then
					act.doer:DoTaskInTime(0.05,function()
						act.doer.components.talker:Say("兔人房已到达上限")
					end)
				end
				
				return false
			end
			if act.doer ~= nil and act.doer.components.talker  then
				act.doer:DoTaskInTime( 0.05,function()
					act.doer.components.talker:Say("兔人房数目:"..act.doer.rabbithouse)
				end)
			end
			return old_BUILD(act)
		end	
	end
	local old_DIG = _G.ACTIONS.DIG.fn 
	_G.ACTIONS.DIG.fn = function(act)
		if act.target and (act.target.prefab=="grass" or act.target.prefab=="sapling" or act.target.prefab=="berrybush" or 
			act.target.prefab=="berrybush2" or act.target.prefab=="berrybush_juicy")  then

			if act.target.ownerlist== nil and act.doer.components.age and act.doer.digtime and act.doer.dignum and (act.doer.components.age:GetAge()<=act.doer.digtime or act.doer.dignum>=30) then
				if act.doer.dignum<=30 then
					if act.doer ~= nil and act.doer.components.talker   then
						act.doer:DoTaskInTime(0.01,function()
							act.doer.components.talker:Say("还需要"..math.floor(act.doer.digtime-act.doer.components.age:GetAge()).."秒可以挖作物")
						end)
					end
				else
					if act.doer ~= nil and act.doer.components.talker   then
							act.doer:DoTaskInTime(0.01,function()
							act.doer.components.talker:Say("作物已达到移植上限!")
						end)
					end
				end
				return false
			elseif act.target.ownerlist== nil and act.doer.components.age and act.doer.digtime and act.doer.dignum and act.doer.components.age:GetAge()>act.doer.digtime and act.doer.dignum<30 then
				act.doer.digtime=480+act.doer.digtime
				act.doer.dignum=act.doer.dignum+1
				if act.doer ~= nil and act.doer.components.talker  then
					act.doer:DoTaskInTime(0.01,function()
						act.doer.components.talker:Say("已挖作物数量:"..act.doer.dignum.."/30")
					--act.doer.components.talker:Say(""..math.floor(act.doer.components.age:GetAge()).."\n"..math.floor(act.doer.digtime))
					end)
				end
			
				return old_DIG(act)
			end
			return old_DIG(act)
		end
		return old_DIG(act)
	end
end]]

----门口100码清理草、树枝等
local function OnClearMap()--c_spawn("grass")
  local ents = TheSim:FindEntities(0,0,0,1000,nil,{"INLIMBO"})
  for _,v in pairs(ents) do
  if table.contains({"multiplayer_portal"},v.prefab) then
      local x,y,z = v.Transform:GetWorldPosition()
      local ToRemove = TheSim:FindEntities(x,y,z,100,nil)
      for _,s in pairs(ToRemove) do
        if table.contains({"grass","berrybush","berrybush2","treasurechest","berrybush_juicy","sapling","evergreen","evergreen_sparse"},s.prefab)  then
          s:Remove()
        end
      end
    end
  end
end
   local _ClearPrefabs = {["houndstooth"]=40,["shadowheart"]=5,["nightsword"]=5,["armor_sanity"]=5,["spiderhat"]=5,["spoiled_food"]=15,["poop"]=10,}
local function OnClearMap2(inst)
	local delnum = 0
	local ents = TheSim:FindEntities(0,0,0,10000,nil,{"INLIMBO"})
	for _,v in pairs(ents) do
    local num = v.components.stackable and v.components.stackable:StackSize() or 0
		if v.prefab and _ClearPrefabs[v.prefab] and num <= _ClearPrefabs[v.prefab] or v:HasTag("stump") then
			v:Remove()
			delnum = delnum + 1
		end
	end
end

AddPrefabPostInit("world",function(inst)
inst:DoPeriodicTask(480,OnClearMap)
inst:DoPeriodicTask(480,OnClearMap2)
end)


if GLOBAL.TheNet and GLOBAL.TheNet:GetIsServer() then
function GetPlayerById(id)
	for k,v in ipairs(GLOBAL.AllPlayers) do
		if v ~= nil and v.userid and v.userid == id then
			return v
		end
	end
	return nil
end
local OldNetworking_Say = GLOBAL.Networking_Say

GLOBAL.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper)
    OldNetworking_Say(guid, userid, name, prefab, message, colour, whisper)
	local talker = GetPlayerById(userid)
	local shardId = GLOBAL.TheShard:GetShardId()
    if whisper then
        if string.sub(message,1,8) == "#等级" then
           --- talker.components.talker:Say("抗寒等级 : "..(talker.level2).."\r耐热等级 : ".. (talker.level3).. "\r群攻等级 : ".. (talker.level4).. "\n移速等级 : ".. (talker.level5).."\n伤害等级 : ".. (talker.level6).. "\n夜视等级 : ".. (talker.level7).. "")
		end
    end
	
	
	if whisper then
        if string.sub(message,1,8) == "#世界" then
            talker.components.talker:Say("您当前在世界  " .. shardId)
		end
    end
	
	if whisper then
        if string.sub(message,1,8) == "#战力" then
            ---talker.components.talker:Say("当前战力 ："..(talker.exp).."")
		end
    end
	
	if whisper then
        if string.sub(message,1,8) == "#属性" then
            ---talker.components.talker:Say("暴击几率 : "..(talker.SHUXING.BaoJi_jilv).."\r重击几率 : ".. (talker.SHUXING.ZhongJi).. "\r抵御抗性 : ".. (talker.SHUXING.DiKang).. "\n闪避几率 : ".. (talker.SHUXING.ShanBi).."\n恢复倍比 : ".. (talker.SHUXING.HuiFu).. "\n修炼经验 : ".. (talker.SHUXING.JingYan).. "")
		end
    end
	
	if whisper then
        if string.sub(message,1,8) == "#帮助" then
            talker.components.talker:Say("按U输入#等级 查看当前等级\r按U输入#世界 查看当前世界\r按U输入#战力 查看当前战力\r按U输入#属性 查看人物属性")
		end
    end	
	
	if string.sub(message,1,3)=="#cp" then  
			for k,v in ipairs(GLOBAL.AllPlayers) do
				if v ~= nil and v.userid == userid then
					if GLOBAL.jisuanhanjinliang(v) >= 1 and #v.danseqiuhaoma < 10 then
						GLOBAL.koujinkuai(v,1)
						if GLOBAL.TUNING.ZHUWANG then GLOBAL.TUNING.ZHUWANG.shangdianjilu11 = GLOBAL.TUNING.ZHUWANG.shangdianjilu22 + 2 end
						table.insert(v.danseqiuhaoma,string.sub(message,4,5))
						v:DoTaskInTime(0.5, function(v)
							v.components.talker:Say("购买彩票"..(string.sub(message,4,5)).."请等待开奖",2.5)
						end)
					else
						v:DoTaskInTime(0.5, function(v)
							v.components.talker:Say("购买彩票需要金元宝1个",2.5)
						end)
					end
				
				end
			end
	end
	
	
	
	
	
end
end

-----------------------种植免施肥-------------------------------

local function change_transplantfn_no_fertilize (inst)
  if inst.components.pickable ~= nil then
    inst.components.pickable.ontransplantfn = function (inst2)
      inst2.components.pickable:MakeEmpty()
      inst2.components.pickable.transplanted = false
    end
  end
end
AddPrefabPostInitAny (change_transplantfn_no_fertilize)





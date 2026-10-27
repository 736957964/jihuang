
local _G = GLOBAL
local TheSim = _G.TheSim
local TheNet = _G.TheNet
local require=_G.require
local tonumber=_G.tonumber
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

AddPlayerPostInit(function(inst)
	inst:AddComponent("pvpgroup")
end)
AddPrefabPostInit("world",function(inst)
	inst:ListenForEvent("ms_playerjoined", function(self, player)
		inst:DoTaskInTime(2,function()
			if player.components.pvpgroup and player.components.pvpgroup.touxianname~= "" then
				player.components.pvpgroup.touxianname  = nil 
				player.components.pvpgroup.touxiancol   = nil 
			end
		end)
	end)
end)

if TheNet and TheNet:GetIsServer() then
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
	if talker then
    if whisper then
        if string.sub(message,1,2) == "##" and talker.components.pvpgroup.touxian==0 then
			if tonumber(string.sub(message,3,3)) and tonumber(string.sub(message,3,3))<=7 then
				talker.components.pvpgroup:settouxian(tonumber(string.sub(message,3,3)),string.sub(message,4))
				talker.components.talker:Say('玩家'..talker.name.."加入了 【"..string.sub(message,4)..'】阵营')
                ---TheNet:Announce('玩家'..talker.name.."创建了 【"..string.sub(message,4)..'】')
				---TheNet:Announce("恭喜玩家"..talker.name.."创建了阵营，请牢记名称")	
			end
		end
		
		
    end	
	
	
	
	
end
end
end

if IsServer then
	local old_ATTACK = _G.ACTIONS.ATTACK.fn
	_G.ACTIONS.ATTACK.fn = function(act)
		if  act.target  and (not act.target:HasTag("player") or act.target.components.pvpgroup.touxianname~= act.doer.components.pvpgroup.touxianname)  then
		return old_ATTACK(act)
		end	

		if  act.target  and  act.target.components.pvpgroup and act.doer.components.pvpgroup and act.target.components.pvpgroup.touxianname== act.doer.components.pvpgroup.touxianname
		and not ( act.doer.Network and act.doer.Network:IsServerAdmin())then
		if act.doer ~= nil and act.doer.components.talker then
		   act.doer.components.talker:Say("阵营名称相同不可攻击")
		end
		return false
		end
	end	
end

AddPrefabPostInit("world",function(inst)
	if inst.playerscore==nil then
		inst.playerscore={}
	end
	inst:ListenForEvent("ms_playerjoined", function(inst, player)
		if GLOBAL.TheWorld.playerscore[player.userid] == nil then
			GLOBAL.TheWorld.playerscore[player.userid] = 0
		end
	end)
	
		
	local OldOnSave=inst.OnSave
	inst.OnSave = function(inst,data)
		if OldOnSave~=nil then
			OldOnSave(inst,data)
		end
		if inst.playerscore ~= nil then
			data.playerscore = inst.playerscore
			end
		end
	local OldOnLoad=inst.OnLoad
	inst.OnLoad = function(inst,data)
		if OldOnLoad~=nil then
			OldOnLoad(inst,data)
		end
		if data.playerscore ~= nil then
			inst.playerscore = data.playerscore
		end
	end
end)







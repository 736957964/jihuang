--眼球塔血量和攻击
TUNING.EYETURRET_HEALTH = 20000  --血量

--龙蝇
TUNING.DRAGONFLY_FREEZE_THRESHOLD = 50--耐冻
TUNING.DRAGONFLY_ENRAGED_FREEZE_THRESHOLD = 100
TUNING.DRAGONFLY_ATTACK_PERIOD = 2.5--攻击频率
TUNING.DRAGONFLY_SPEED = 8--速度
TUNING.DRAGONFLY_FIRE_ATTACK_PERIOD = 1
TUNING.DRAGONFLY_FIRE_SPEED = 12
TUNING.DRAGONFLY_HEALTH = 27500 * 1.5
TUNING.DRAGONFLY_STUN = 2500
TUNING.DRAGONFLY_STUN_RESIST = 500
TUNING.DRAGONFLY_STUN_COOLDOWN = 480
TUNING.DRAGONFLY_STUN_DURATION = 3


if GetModConfigData("atsave") then
--玩家进入世界自动存档
--方案1（世界存档）
	AddComponentPostInit("playerspawner", function(OnPlayerSpawn, inst)
		inst:ListenForEvent("ms_playerjoined", function(inst, player)
			inst:PushEvent("ms_save")
		end)
	end)
end


--玩家进入世界(自动跳转81~88)
if GetModConfigData("teleport") then
AddComponentPostInit("playerspawner", function(OnPlayerSpawn, inst)
	inst:ListenForEvent("ms_playerjoined", function(inst, player)
		if not player.Network:IsServerAdmin() then
			if player.components.talker then
				player:DoTaskInTime(3,function()
					player.components.talker:Say("5秒你将遣返回中转站，请系好安全带...")
				end)
			end
			inst:DoTaskInTime(5,function()
				if inst:IsValid() then
				inst:PushEvent(
					"ms_playerdespawnandmigrate",
				{ player = player, worldid = "82" }--worldid(中转站id)
				)
				end
			end)
		end
	end)
end)
end

--[[
--清除圣诞树
AddPrefabPostInit("winter_treestand",function(inst)
	inst:Remove()
end)
AddPrefabPostInit("winter_tree",function(inst)
	inst:Remove()
end)
--]]




----犬牙陷阱自动重置
local function TrapComponentPostInit(self)
	function self:Explode(target)
		self:StopTesting()
		self.target = target
		self.issprung = true
		self.inactive = false
		if self.onexplode then
			self.onexplode(self.inst, target)
		end
		
		self.inst:DoPeriodicTask(2, function()
			if ( self.issprung ) then
				self:Reset()
			end
		end)
	end	
end
AddComponentPostInit("mine", TrapComponentPostInit)


--填海造陆
local function sea_GetPlayerById(id)
	for i,v in pairs(GLOBAL.AllPlayers) do
		if v.userid == id then
			return v
		end
	end
	return false
end

local DeleteNetworking_Say = GLOBAL.Networking_Say
GLOBAL.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper)
if string.sub(message,1,1) == "#" then
	if string.sub(message,1,4) == "#sea" and #message >= 5 then
		local player = sea_GetPlayerById(userid)
		if type(player) == "table" and player then
		if player.Network:IsServerAdmin() then
		local num = GLOBAL.tonumber(string.sub(message,5,#message))
		num = math.ceil(math.abs(num))
		if num > 50 then
			num = 50
		end
		local TheWorld = GLOBAL.TheWorld
		for i = -num,num do
			for j = -num,num do
				local a,b,c = player.Transform:GetWorldPosition();
				local x, y = TheWorld.Map:GetTileCoordsAtPoint(a, b, c);
				local oldType = TheWorld.Map:GetTileAtPoint(a, b, c);
				TheWorld.Map:SetTile(x+i, y+j, 1);
				TheWorld.Map:RebuildLayer(oldType, x+i, y+j);
				TheWorld.Map:RebuildLayer(1, x+i, y+j);
				TheWorld.minimap.MiniMap:RebuildLayer(oldType, x+i, y+j);
				TheWorld.minimap.MiniMap:RebuildLayer(1, x+i, y+j);
			end
		end
		end
		end
	elseif string.sub(message,1,5) == "#land" and #message >= 6 then
		local player = sea_GetPlayerById(userid)
		if type(player) == "table" and player then
		if player.Network:IsServerAdmin() then
		local num = GLOBAL.tonumber(string.sub(message,6,#message))
		num = math.ceil(math.abs(num))
		if num > 50 then
			num = 50
		end
		local TheWorld = GLOBAL.TheWorld
		for i = -num,num do
			for j = -num,num do
				local a,b,c = player.Transform:GetWorldPosition();
				local x, y = TheWorld.Map:GetTileCoordsAtPoint(a, b, c);
				local oldType = TheWorld.Map:GetTileAtPoint(a, b, c);
				TheWorld.Map:SetTile(x+i, y+j, 4);
				TheWorld.Map:RebuildLayer(oldType, x+i, y+j);
				TheWorld.Map:RebuildLayer(4, x+i, y+j);
				TheWorld.minimap.MiniMap:RebuildLayer(oldType, x+i, y+j);
				TheWorld.minimap.MiniMap:RebuildLayer(4, x+i, y+j);
			end
		end
		end
		end
	end
end
return DeleteNetworking_Say(guid, userid, name, prefab, message, colour, whisper) 
end
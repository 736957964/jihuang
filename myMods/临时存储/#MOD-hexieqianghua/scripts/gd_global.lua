local _G = GLOBAL
local TheSim = _G.TheSim
local TheNet = _G.TheNet
local TheShard = _G.TheShard
local TheInput = _G.TheInput
local getmetatable = _G.getmetatable

local FRAMES = _G.FRAMES
local SpawnPrefab = _G.SpawnPrefab
local FindValidPositionByFan = _G.FindValidPositionByFan
local PI = _G.PI
local GROUND = _G.GROUND
-- local GROUND_FLOORING = _G.GROUND_FLOORING

-- 设置物品名称
function SetItemAppendName(inst, appendName)
	if inst ~= nil and inst:IsValid() then
		if inst.components.named == nil then
			inst:AddComponent("named")
			inst.oldName = inst.name
		end

		if appendName ~= nil then
			if inst.oldName == nil then
				inst.oldName = inst.name
			end
			inst.components.named:SetName((inst.oldName or inst.name or "") .. "\n" .. appendName)
		else
			inst.components.named:SetName(nil)
		end
	end
end

-- 说话
function PlayerSay(player, msg, delay, duration, noanim, force, nobroadcast, colour)
	if player ~= nil and player.components.talker then
		player:DoTaskInTime(delay or 0.01, function ()
			player.components.talker:Say(msg, duration or 2.5, noanim, force, nobroadcast, colour)
		end)
	end
end

-- 带颜色渲染的话
function PlayerColorSay(player, msg, colour, delay, duration)
	PlayerSay(player, msg, delay, duration, nil, nil, nil, colour)
end

--通过id获取当前世界玩家
function GetTheWorldPlayerById(id)
	for _,p in pairs(_G.AllPlayers) do
		if p.userid == id then 
			return p
		end
	end

	return nil
end

-- 将坐标点对象拆分成x y z返回
function GetSplitPosition(pos)
	return pos.x, pos.y, pos.z
end

-- 放置物体到指定位置
function ItemSetPosition(doer, x, y, z, isDoerNotSetPos, isAnim)
	if not isDoerNotSetPos then
		if doer.Physics ~= nil then
			doer.Physics:Teleport(x, y, z)
		else
			doer.Transform:SetPosition(x, y, z)
		end
	end

	if doer.components.leader ~= nil then
		for follower, v in pairs(doer.components.leader.followers) do
			if isAnim == false then
				ItemSetPosition(follower, x, y, z, false)
			else
				ItemAnimSetPosition(follower, x, y, z, false, false)
			end
		end
	end
end

-- 放置物体到指定位置(动画)
function ItemAnimSetPosition(doer, x, y, z, isDoerNotSetPos, isEndAnim)
	if not isDoerNotSetPos then
		local doX, doY, doZ = doer.Transform:GetWorldPosition()
		if doX ~= nil then
			local start_fx = SpawnPrefab("spawn_fx_medium")
			if start_fx ~= nil then
				start_fx.Transform:SetPosition(doX, doY, doZ)
			end
		end
		if doX ~= nil and doer.components.colourtweener then
			local colour_r, colour_g, colour_b, alpha = doer.AnimState:GetMultColour()
			doer.components.colourtweener:StartTween({ 0, 0, 0, 1 }, 19 * FRAMES, function()
				if isEndAnim then
					local end_fx = SpawnPrefab("spawn_fx_medium")
					if end_fx ~= nil then
						end_fx.Transform:SetPosition(x, y, z)
					end
				end
				doer.AnimState:SetMultColour(colour_r, colour_g, colour_b, alpha)
				ItemSetPosition(doer, x, y, z, isDoerNotSetPos, true)
			end)
		else
			if isEndAnim then
				local end_fx = SpawnPrefab("spawn_fx_medium")
				if end_fx ~= nil then
					end_fx.Transform:SetPosition(x, y, z)
				end
			end
			ItemSetPosition(doer, x, y, z, isDoerNotSetPos, true)
		end
	else
		ItemSetPosition(doer, x, y, z, isDoerNotSetPos, true)
	end
end

-- 获取物体周围一个随机范围内有效的地形
function GetFanValidPoint(position, minRadiu, maxRadiu, attempts)
	local theta = math.random() * 2 * PI
	local radius = math.random(minRadiu or 8, maxRadiu or 15)
	local attempts = attempts or 30
	local result_offset = FindValidPositionByFan(theta, radius, attempts, function(offset)
		local run_point = position+offset
		local tile = _G.TheWorld.Map:GetTileAtPoint(run_point.x, run_point.y, run_point.z)
		if tile == GROUND.IMPASSABLE or tile == GROUND.INVALID or tile >= GROUND.UNDERGROUND then
			return false
		end
		return true
	end)
	if result_offset ~= nil then
		local pos = position + result_offset
		return pos
	end
end

-- 移除指定文件监听方法并返回原始Fn
function RemoveEventCallbackEx(inst, event, filepath)
	local old_event_key, old_event = nil, nil

	-- 移除指定监听方法
	if inst.event_listeners ~= nil and inst.event_listeners[event] ~= nil and inst.event_listeners[event][inst] ~= nil then
		--print("find event begin")
		for i, fn in ipairs(inst.event_listeners[event][inst]) do
			local info = _G.debug.getinfo(fn,"LnS")
			if string.find(info.source, filepath) then
				old_event_key = i
				old_event = fn
				break
				--print(string.format("      %s = function - %s", i, info.source..":"..tostring(info.linedefined)))
			end
			
		end
		--print("find event end")
	end

	-- 移除指定监听方法
	if inst.event_listeners ~= nil and inst.event_listeners[event] ~= nil and inst.event_listeners[event][inst] ~= nil then
		-- inst.event_listening[event][inst] = nil
		-- inst.event_listeners[event][inst] = nil
		-- inst.event_listening[event][inst][old_event_key] = OnEvent
		-- inst.event_listeners[event][inst][old_event_key] = OnEvent
		inst:RemoveEventCallback(event, old_event)
	end

	return old_event
end

function strFindInTable(str, T)
  for k,v in ipairs(T) do
  	if string.find(str, v) then
		return true
	end
  end
  return false
end

function FindTableValueIndex(tb, value)
	for k,v in ipairs(tb) do
		if v == value then 
			return n
		end
	end
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
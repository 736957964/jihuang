local ex_fns = require "prefabs/player_common_extensions"

local FlyConfig = {
	configs = {},

	AddData = function(self, data)
		-- id链接
		table.insert(self.configs, data)
		data.id = #self.configs
		-- 缺省值
		data.owner_prefab = data.owner_prefab
		data.height = data.height or 2
		data.shadow_size = data.shadow_size or {2.6,1.2}
		data.speed = data.speed or 6
		-- prefab 
		self.configs[data.owner_prefab] = data
	end,

	GetDataById = function(self, id)
		return self.configs[id]
	end,

	GetDataByPrefab = function(self, pf)
		return self.configs[pf] or self.configs["common"]
	end,
}

-- 云玩家: 腾云丹 
FlyConfig:AddData{
	owner_prefab = "common",
	speed = 9/6,
	--sanity_penalty = 0.25,
	build = "mk_cloudfx2",
}

-- 孙悟空: 筋斗云
FlyConfig:AddData{
	owner_prefab = "monkey_king",
	speed = 12/6,-- basic: 1.1x
	build = "mk_cloudfx0",
	skinbuild = { monkey_king_ear = "mk_cloudfx_ear"},
	tail = {
		changealpha = true,
		changescale = true,
		fadetime = 0.7,
	},
}

-- 哪吒: 风火轮
FlyConfig:AddData{
	owner_prefab = "neza",
	speed = 10/6,
	fx = {
		prefab = "myth_flyerfx_wheel",
	},
	ridefn = function(cmp, player, val)
		local health = player.components.health
		if health then
			if val then 
				if player.components.debuffable ~= nil and player.components.debuffable:IsEnabled() and
               	 	not (player.components.health ~= nil and player.components.health:IsDead()) and
                	not player:HasTag("playerghost") then
					player.components.debuffable:AddDebuff("myth_flyerfx_wheel_buff", "myth_flyerfx_wheel_buff")
					end
				if player.flyerfx_wheel_fx == nil then
					player.flyerfx_wheel_fx = SpawnPrefab("flyerfx_wheel_fx")
					player.flyerfx_wheel_fx.entity:SetParent(player.entity)
				end
			else
				if player.components.debuffable then
					player.components.debuffable:RemoveDebuff("myth_flyerfx_wheel_buff")
				end
				if player.flyerfx_wheel_fx ~= nil then
					player.flyerfx_wheel_fx:Remove()
					player.flyerfx_wheel_fx  = nil
				end				
			end
		end
	end,
}

-- 白骨夫人: 阴风 
FlyConfig:AddData{
	owner_prefab = "white_bone",
	speed = 11/6,
	build = "mk_cloudfx3",
	tail = {
		changealpha = true,
		changescale = false,
		fadetime = 0.4,
		scale = 1.3,
		num = 2,
		-- pos_fn = "wb",
		base_alpha = 32/255,
	},
	is_invisible = true,
	base_alpha = 0.3,
	scale = 1.3,
}

-- 八戒: 棉花云
FlyConfig:AddData{
	owner_prefab = "pigsy",
	speed = 9/6,
	build = "mk_cloudfx2",
	scale = 1.65,
	animspeed = 0.8,
	radius = 1, -- 半径更大

	ridefn = function(cmp, player, val)
		if player.components.hunger then
			if val then
				player.components.hunger.burnratemodifiers:SetModifier(cmp, 0.8)
			else
				player.components.hunger.burnratemodifiers:RemoveModifier(cmp)
			end
		end
	end,
}

local function lantern_onremovefx(fx)
    fx._owner._flyfx = nil
end

--霜月云
local yutu_skinfx = {
	myth_yutu_apricot = "apricot_flower_fx_held",
}

local yutu_lightcorour = {
	myth_yutu_apricot = {247 / 255, 164 / 255, 158/255 , 1},
}

FlyConfig:AddData{
	owner_prefab = "myth_yutu",
	speed = 10/6,
	build = "mk_cloudfx4",
	scale = 0.9,
	--animspeed = 0.8,
	--radius = 1, -- 半径更大

	ridefn = function(cmp, player, val)
		local health = player.components.health
		if health then
			if val then
				player:DoTaskInTime(0,function()
					local build = player.AnimState:GetBuild()
					if not player._flyfx then
						player._flyfx = SpawnPrefab(yutu_skinfx[build] or "lantern_winter_fx_held")
						player._flyfx.entity:AddFollower()
						player._flyfx._owner = player
						player._flyfx.entity:SetParent(player.entity)
						player._flyfx.Follower:FollowSymbol(player.GUID, "leg",  0, 65,  0)
						player:ListenForEvent("onremove", lantern_onremovefx, player._flyfx)
					end
					if player.flyerfx_yutu_fx == nil then
						player.flyerfx_yutu_fx= SpawnPrefab("flyerfx_yutu_fx")
						player.flyerfx_yutu_fx.entity:SetParent(player.entity)
						if yutu_lightcorour[build] then
							player.flyerfx_yutu_fx.Light:SetColour(unpack(yutu_lightcorour[build]))
						end
					end
				end)
				player.components.health:StartRegen(1, 3)
			else
				if player._flyfx then
					player._flyfx:Remove()
				end
				if player.flyerfx_yutu_fx ~= nil then
					player.flyerfx_yutu_fx:Remove()
					player.flyerfx_yutu_fx  = nil
				end	
				player.components.health:StopRegen()
			end
		end
	end,
}
	
--黑白无常！

local function UpdateInvisible(inst,phase)
	if phase == "day" then
		inst:RemoveTag("NOHIGHLIGHT")
		inst:RemoveTag("NOTARGET")
		inst:RemoveTag("INVISIBLE")
	else
		inst:AddTag("NOHIGHLIGHT")
		inst:AddTag("NOTARGET")
		inst:AddTag("INVISIBLE")
	end
end

FlyConfig:AddData{
	owner_prefab = "yama_commissioners",
	speed = 10/6,
	height = 0.5,
	build = "mk_cloudfx_blue",
	base_alpha = 0.4,
	is_invisible = true,
	invisible_percent = 0.2,

	ridefn = function(cmp, player, val)
		if val then
			if player.Spawn_Circle_Fires then
				player:DoTaskInTime(0,player.Spawn_Circle_Fires)
			end
			if player._commissioner_balck:value() then
				player:DoTaskInTime(0,function()
					if cmp.fx and cmp.fx:IsValid() then
						for k in pairs(cmp.fx.fx)do
							if k:IsValid() then
								k.AnimState:SetBuild("mk_cloudfx_purple")
							end
						end
					end
				end)
			end
			if TheWorld.ismastersim then
				if player.flyerfx_wheel_fx == nil then
					player.flyerfx_wheel_fx = SpawnPrefab("flyerfx_yama_fx")
					player.flyerfx_wheel_fx.entity:SetParent(player.entity)
					if player._commissioner_balck ~= nil and player._commissioner_balck:value() then
						player.flyerfx_wheel_fx.Light:SetColour(210 / 255, 59 / 255, 221 / 255)
					end
				end
				player:WatchWorldState("phase", UpdateInvisible)
				UpdateInvisible(player, TheWorld.state.phase)
			end
		else
			if player.Kill_Flyerfx then
				player:Kill_Flyerfx()
			end
			if player.flyerfx_wheel_fx ~= nil then
				player.flyerfx_wheel_fx:Remove()
				player.flyerfx_wheel_fx  = nil
			end	
			if TheWorld.ismastersim then
				player:StopWatchingWorldState("phase", UpdateInvisible)
			end
		end
	end
}

local function OnAttacked(inst,data)
	--self.inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/shocked")
	if data.attacker ~= nil and data.attacker.components.combat ~= nil  and 
        not (data.attacker.components.health ~= nil and data.attacker.components.health:IsDead()) and
        (data.weapon == nil or ((data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil) and data.weapon.components.projectile == nil)) and
        data.attacker.components.burnable ~= nil and
        not data.redirected and
        not data.attacker:HasTag("thorny") then
        if  math.random() < 0.2 then
			if not data.attacker.components.debuffable then 
				data.attacker:AddComponent("debuffable")
			end
			data.attacker.components.debuffable:AddDebuff("yj_spear_elec_shockbuff","yj_spear_elec_shockbuff")
		end

        data.attacker.components.combat:GetAttacked(inst, 10, nil, "electric")
    end
end

-- 杨戬: 天雷云
FlyConfig:AddData{
	owner_prefab = "yangjian",
	speed = 10/6,
	build = "mk_cloudfx1",
	animspeed = 2,
	tail = {
		changealpha = false,
		changescale = true,
		fadetime = 0.4,
	},
	extra_fx = {
		prefab = "myth_flyerfx_cloud_thunder", 
		interval = function() return GetRandomMinMax(3,5) end,
		offset = Vector3(0,-1,0),
	},
	ridefn = function(cmp, player, val)
		if val then
			player:ListenForEvent("blocked", OnAttacked)
			player:ListenForEvent("attacked", OnAttacked)
		else
			player:RemoveEventCallback("blocked", OnAttacked)
			player:RemoveEventCallback("attacked", OnAttacked)
		end
	end,
}
-- ???: 霜月云
FlyConfig:AddData{
	owner_prefab = "???",
	speed = 9/6,
}

-- 尾巴默认和主体一致
for i,v in ipairs(FlyConfig.configs)do
	if v.tail then
		v.tail.build = v.tail.build or v.build
	end
end

local function DefaultEmitPosFn(rot) -- 默认的圆环发散器
	local offsangle = math.random() * 2 * PI
    local offsradius = math.random() * .2
    return math.cos(offsangle) * offsradius, math.sin(offsangle) * offsradius
end

local function WhiteBoneEmitPosFn(rot) -- 白骨的神奇发散器
	local offsangle = ((math.random() < 0.5 and 90 or -90)+ rot)* DEGREES
	local offsradius = math.random() * .5
	return math.cos(offsangle) * offsradius, -math.sin(offsangle) * offsradius
end

FlyConfig:GetDataByPrefab("white_bone").tail.pos_fn = WhiteBoneEmitPosFn

local Tail = Class(function(self)
	self.enabled = false
	self.tails = {}
	self.config = {}

	self.Emit = function(self)
		local tail = SpawnPrefab(self.config.prefab or "myth_flyerfx_cloud_tail") --default 
		tail:config(self.config)
		tail:init() -- 大小/动画/透明度均已在prefab内部实现, 这里只需要控制速度
		self.tails[tail] = true
		return tail
	end

	self.GetEmitOffset = function(self, ...)
		if self.config.pos_fn then
			return self.config.pos_fn(...)
		else
			return DefaultEmitPosFn(...)
		end
	end
end)

------动作部分
local IsFlying = function(inst) return inst and inst.components.mk_flyer and inst.components.mk_flyer:IsFlying()end
local banactions ={
	[ACTIONS.PICKUP]= true, --拾取
	[ACTIONS.PICK]= true, --采集
	[ACTIONS.SLEEPIN]= true, --睡觉
	[ACTIONS.MYTH_ENTER_HOUSE]= true,--小房子
	[ACTIONS.MOUNT]= true,--骑牛
	[ACTIONS.MIGRATE]= true,
	[ACTIONS.HAUNT]= true,
	[ACTIONS.JUMPIN]= true,		
}

local function changephysics(inst, data)
	if inst.Physics then
		if inst.Physics:GetCollisionMask() ~= 32 then
			RemovePhysicsColliders(inst)
		end
	end
end


if ACTIONS.HUA_ENTER_HOUSE ~= nil then
	banactions[ACTIONS.HUA_ENTER_HOUSE] = true
end
if ACTIONS.PIGSY_TILL ~= nil then
	banactions[ACTIONS.PIGSY_TILL] = true
end
if ACTIONS.MT_TILL ~= nil then
	banactions[ACTIONS.MT_TILL] = true
end

local TARGET_EXCLUDE_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO" }
local PICKUP_TARGET_EXCLUDE_TAGS = { "catchable", "mineactive", "intense" }
local HAUNT_TARGET_EXCLUDE_TAGS = { "haunted", "catchable" }
for i, v in ipairs(TARGET_EXCLUDE_TAGS) do
    table.insert(PICKUP_TARGET_EXCLUDE_TAGS, v)
    table.insert(HAUNT_TARGET_EXCLUDE_TAGS, v)
end
local CATCHABLE_TAGS = { "catchable" }
local PINNED_TAGS = { "pinned" }
local CORPSE_TAGS = { "corpse" }
local function ValidateCorpseReviver(target, inst)
    return target.components.revivablecorpse:CanBeRevivedBy(inst)
end
local function ValidateBugNet(target)
    return not target.replica.health:IsDead()
end
local function GetPickupAction(self, target, tool)
    if target:HasTag("smolder") then
        return ACTIONS.SMOTHER
    elseif tool ~= nil then
        for k, v in pairs(TOOLACTIONS) do
            if target:HasTag(k.."_workable") then
                if tool:HasTag(k.."_tool") then
                    return ACTIONS[k]
                end
                break
            end
        end
    end
    if target:HasTag("quagmireharvestabletree") and not target:HasTag("fire") then
        return ACTIONS.HARVEST_TREE
    elseif target:HasTag("trapsprung") then
        return ACTIONS.CHECKTRAP
    elseif target:HasTag("minesprung") and not target:HasTag("mine_not_reusable") then
        return ACTIONS.RESETMINE
    elseif target:HasTag("inactive") then
        return (not target:HasTag("wall") or self.inst:IsNear(target, 2.5)) and ACTIONS.ACTIVATE or nil

    elseif target.replica.inventoryitem ~= nil and
	target.replica.inventoryitem:CanBePickedUp() and
	not (target:HasTag("heavy") or target:HasTag("fire") or target:HasTag("catchable")) and
	not target:HasTag("spider") then
		return (self:HasItemSlots() or target.replica.equippable ~= nil) and ACTIONS.PICKUP or nil
	elseif target:HasTag("pickable") and not target:HasTag("fire") then
		return ACTIONS.PICK
	elseif target:HasTag("harvestable") then
		return ACTIONS.HARVEST
	elseif target:HasTag("readyforharvest") or
		(target:HasTag("notreadyforharvest") and target:HasTag("withered")) then
		return ACTIONS.HARVEST
	elseif target:HasTag("tapped_harvestable") and not target:HasTag("fire") then
		return ACTIONS.HARVEST
	elseif target:HasTag("tendable_farmplant") and not self.inst:HasTag("mime") and not target:HasTag("fire") then
		return ACTIONS.INTERACT_WITH
	elseif target:HasTag("dried") and not target:HasTag("burnt") then
		return ACTIONS.HARVEST
	elseif target:HasTag("donecooking") and not target:HasTag("burnt") then
		return ACTIONS.HARVEST

    elseif tool ~= nil and tool:HasTag("unsaddler") and target:HasTag("saddled") and (not target.replica.health or not target.replica.health:IsDead()) then
        return ACTIONS.UNSADDLE
    elseif tool ~= nil and tool:HasTag("brush") and target:HasTag("brushable") and (not target.replica.health or not target.replica.health:IsDead()) then
        return ACTIONS.BRUSH
    elseif self.inst.components.revivablecorpse ~= nil and target:HasTag("corpse") and ValidateCorpseReviver(target, self.inst) then
        return ACTIONS.REVIVE_CORPSE
    end
end

local function ActionButton(inst, force_target)
	local self = inst.components.playercontroller
    if not self:IsDoingOrWorking() then
        local force_target_distsq = force_target ~= nil and self.inst:GetDistanceSqToInst(force_target) or nil
        
		if self.inst:HasTag("playerghost") then
            return
        end

        local tool = self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

        --捕虫网
        if tool ~= nil and tool:HasTag(ACTIONS.NET.id.."_tool") then
            if force_target == nil then
                local target = FindEntity(self.inst, 5, ValidateBugNet, { "_health", ACTIONS.NET.id.."_workable" }, TARGET_EXCLUDE_TAGS)
                if CanEntitySeeTarget(self.inst, target) then
                    return BufferedAction(self.inst, target, ACTIONS.NET, tool)
                end
            elseif force_target_distsq <= 25 and
                force_target.replica.health ~= nil and
                ValidateBugNet(force_target) and
                force_target:HasTag(ACTIONS.NET.id.."_workable") then
                return BufferedAction(self.inst, force_target, ACTIONS.NET, tool)
            end
        end

        --接东西
        if self.inst:HasTag("cancatch") then
            if force_target == nil then
                local target = FindEntity(self.inst, 10, nil, CATCHABLE_TAGS, TARGET_EXCLUDE_TAGS)
                if CanEntitySeeTarget(self.inst, target) then
                    return BufferedAction(self.inst, target, ACTIONS.CATCH)
                end
            elseif force_target_distsq <= 100 and
                force_target:HasTag("catchable") then
                return BufferedAction(self.inst, force_target, ACTIONS.CATCH)
            end
        end

        --unstick
        if force_target == nil then
            local target = FindEntity(self.inst, self.directwalking and 3 or 6, nil, PINNED_TAGS, TARGET_EXCLUDE_TAGS)
            if CanEntitySeeTarget(self.inst, target) then
                return BufferedAction(self.inst, target, ACTIONS.UNPIN)
            end
        elseif force_target_distsq <= (self.directwalking and 9 or 36) and
            force_target:HasTag("pinned") then
            return BufferedAction(self.inst, force_target, ACTIONS.UNPIN)
        end

        --revive (only need to do this if i am also revivable)
        if self.inst.components.revivablecorpse ~= nil then
            if force_target == nil then
                local target = FindEntity(self.inst, 3, ValidateCorpseReviver, CORPSE_TAGS, TARGET_EXCLUDE_TAGS)
                if CanEntitySeeTarget(self.inst, target) then
                    return BufferedAction(self.inst, target, ACTIONS.REVIVE_CORPSE)
                end
            elseif force_target_distsq <= 9
                and force_target:HasTag("corpse")
                and ValidateCorpseReviver(force_target, self.inst) then
                return BufferedAction(self.inst, force_target, ACTIONS.REVIVE_CORPSE)
            end
        end

        --misc: pickup, tool work, smother
        if force_target == nil then
			print("是我啊宝贝",self.inst.prefab == "yama_commissioners")
            local pickup_tags = self.inst.prefab == "yama_commissioners"
			and
			{
                "_inventoryitem",
                "pickable",
                "donecooking",
                "readyforharvest",
                "notreadyforharvest",
                "harvestable",
                "trapsprung",
                "minesprung",
                "dried",
                "inactive",
                "smolder",
                "saddled",
                "brushable",
                "tapped_harvestable",
                "tendable_farmplant",
            }
			or 
            {
                "smolder",
                "saddled",
                "brushable",
            }
            if tool ~= nil then
                for k, v in pairs(TOOLACTIONS) do
                    if tool:HasTag(k.."_tool") then
                        table.insert(pickup_tags, k.."_workable")
                    end
                end
            end
            if self.inst.components.revivablecorpse ~= nil then
                table.insert(pickup_tags, "corpse")
            end
            local x, y, z = self.inst.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x, y, z, self.directwalking and 3 or 6, nil, PICKUP_TARGET_EXCLUDE_TAGS, pickup_tags)
            for i, v in ipairs(ents) do
                if v ~= self.inst and v.entity:IsVisible() and CanEntitySeeTarget(self.inst, v) then
                    local action = GetPickupAction(self, v, tool)
                    if action ~= nil then
                        return BufferedAction(self.inst, v, action, action ~= ACTIONS.SMOTHER and tool or nil)
                    end
                end
            end
        elseif force_target_distsq <= (self.directwalking and 9 or 36) then
            local action = GetPickupAction(self, force_target, tool)
            if action ~= nil then
                return BufferedAction(self.inst, force_target, action, action ~= ACTIONS.SMOTHER and tool or nil)
            end
        end
    end
end

local specialbanactions = {
	white_bone = {
		[ACTIONS.ATTACK] = false,
	},
	yama_commissioners = {
		[ACTIONS.ATTACK] = false,
		[ACTIONS.PICKUP]= true,
		[ACTIONS.PICK]= true,
	}
}

local function FlyActionFilter(inst, action)
	if  specialbanactions[inst.prefab] and specialbanactions[inst.prefab][action] ~= nil then
		return specialbanactions[inst.prefab][action]
	end
    return not banactions[action]
end
--------------------================================================
local Flyer = Class(function(self, inst)
    self.inst = inst
   	self.fx = nil
   	self.tail = Tail()
   	self.extra_fx_task = nil -- 目前只有杨戬用得上
	
	self._isflying = net_bool(inst.GUID, "myth_flyer._isflying", "myth_flyer._isflying")
	self._isflying:set(false)

	self._percent = net_float(inst.GUID, "myth_flyer._percent")
	self._percent:set(0)
	self.runspeed = 9
	
	inst:ListenForEvent("myth_flyer._isflying", function()
		local p = self._isflying:value()
		if not TheWorld.ismastersim then
			if p ~= (self.fx and self.fx:IsValid()) then
				self:SetFlying(p, TheSim:GetTick() <= 1+4) -- 5帧内的起飞视为读档
			end	
		end
	end)
	
	self.height_target = 0
	-- self.percent = 0
	-- self.isfloat = false
end)

local function OnBlocked(owner, data)
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_scalemail")
end

function Flyer:GetPercent()
	return self._percent:value()
end

function Flyer:UpdateHeight() -- 锁定玩家y高度, 仅主机和预估客机生效
	if self.inst.components.locomotor then 
		self.inst.components.locomotor.mythVar_height_override = self:GetFlyTargetHeight()
		local inst = self.inst
		local a,b,c = inst.Physics:GetMotorVel()
		local y = inst:GetPosition().y
		inst.Physics:SetMotorVel(a, (self.height_target - y)*32, c)
	else
		self:GetFlyTargetHeight()
	end
end

function Flyer:UpdatePlayerTween() -- 玩家透明度
	if TheNet:IsDedicated() or not self.inst.entity:IsVisible() then
		return
	end
	if self.current_data and self.current_data.is_invisible then
		local a =  math.max(self.current_data.invisible_percent or 0, 1 - self:GetPercent() )

		self.inst.AnimState:SetMultColour(a,a,a,a)
		--ThePlayer.AnimState:SetMultColour(0.5,0.5,0.5,0.5)
	end
end

function Flyer:UpdateTail()
	if TheNet:IsDedicated() or not self.inst.entity:IsVisible() then
		return
	end
	if not self.tail.enabled then
		return
	end
	local x,y,z = self.inst.Transform:GetWorldPosition()
	for k in pairs(self.tail.tails)do
		if k:IsAsleep() then
			k:Remove()
		end
		if k:IsValid() then
			k:ForceFacePoint(x,0,z)
		else
			self.tail.tails[k] = nil
		end
	end
	if not self.last_x then 
		self.last_x = x
		self.last_z = z
	else
		local distsq = (x-self.last_x)*(x-self.last_x) + (z-self.last_z)*(z-self.last_z)
		self.last_x = x 
		self.last_z = z
		if distsq > 0.01 then 
			for i = 1, self.tail.config.num or 1 do
				local tail = self.tail:Emit()
				local xoff, zoff = self.tail:GetEmitOffset(self.inst.Transform:GetRotation())
				tail:setheight(self.height_target)
				tail.Transform:SetPosition(x+xoff, 0, z+zoff)
				tail.Physics:SetMotorVel(.6 + math.random() * .4, 0, 0)
			end
		end
	end
end

function Flyer:OnUpdate(dt) -- 主客机通用
	if self.fx and self.fx:IsValid()then
		self:UpdateHeight()
		self:UpdatePlayerTween()
		self:UpdateTail()
	else
		self.fx = nil
		self.inst:StopUpdatingComponent(self)
	end
end
local function GetHopDistance(inst, speed_mult)
	return speed_mult < 0.8 and TUNING.WILSON_HOP_DISTANCE_SHORT
			or speed_mult >= 1.2 and TUNING.WILSON_HOP_DISTANCE_FAR
			or TUNING.WILSON_HOP_DISTANCE
end


function Flyer:SetFlying(val, onload) -- 主客机: 芜湖, 起飞
    local inst = self.inst
    -- 目前, 云的品种是和预制物名绑定的;
    -- 如果以后要改, 记得先把羽中打一顿!
    -- 然后给组件加一个net_int, 来传递云的品种的id
    local data = FlyConfig:GetDataByPrefab(inst.prefab)
	data.owner = self.inst
	if data.tail then
		data.tail.owner = self.inst
	end
    self.current_data = data
	
	if self.current_data.speed ~= nil then
		self.runspeed = self.current_data.speed*6
	end

    if TheWorld.ismastersim then
    	self._isflying:set(val)
    else
    	self._isflying:set_local(val)
    end

	if val then
		self.inst:StartUpdatingComponent(self)
		if onload then
			self._percent:set_local(1) -- 不进行过渡
		end
		
		if inst.components.playercontroller ~= nil then
			inst.components.playercontroller.actionbuttonoverride = ActionButton
		end		
		if inst.components.playeractionpicker ~= nil then
			inst.components.playeractionpicker:PushActionFilter(FlyActionFilter, 555)
		end
		if data.ridefn then
			data.ridefn(self, self.inst, true)
		end
		inst:ListenForEvent("newstate", changephysics)
		if data.is_invisible and not (data.invisible_percent) then -- 隐身
			print("我不需要")
			inst:AddTag("NOHIGHLIGHT")
			inst:AddTag("NOTARGET")
			inst:AddTag("INVISIBLE")
		end
		if data.sanity_penalty then -- 理智上限惩罚
			if inst.components.sanity then
				inst.components.sanity:AddSanityPenalty("myth_flyer.sanity", data.sanity_penalty)
			end
		end
		if inst.Physics then
			RemovePhysicsColliders(inst)
		end
		if inst.components.locomotor then
			inst.components.locomotor:SetSlowMultiplier(0.6)
			inst.components.locomotor.pathcaps = { player = true, ignorecreep = true ,allowocean = true}
			inst.components.locomotor.fasteronroad = false
			inst.components.locomotor:SetTriggersCreep(false)
			inst.components.locomotor:SetAllowPlatformHopping(false)
		end
		if inst.components.drownable then
			inst.components.drownable.enabled = false
		end
		self:SpawnFx()
		-- For tail
		if data.tail then
			self.tail.enabled = true
			self.tail.config = data.tail
		end
		-- For extra fx 
		if data.extra_fx then
			self:SpawnExtraFx(data.extra_fx)
		end
	else
		if inst.components.playercontroller ~= nil then
			inst.components.playercontroller.actionbuttonoverride = nil
		end		
		if inst.components.playeractionpicker ~= nil then
			inst.components.playeractionpicker:PopActionFilter(FlyActionFilter)
		end
		if data.ridefn then
			data.ridefn(self, self.inst, false)
		end
		inst:RemoveEventCallback("newstate", changephysics)
		if data.is_invisible then
			inst:RemoveTag("NOHIGHLIGHT")
			inst:RemoveTag("NOTARGET")
			inst:RemoveTag("INVISIBLE")
		end
		if data.sanity_penalty then
			if inst.components.sanity then
				inst.components.sanity:RemoveSanityPenalty("myth_flyer.sanity")
			end
		end
		if inst.Physics then
			ChangeToCharacterPhysics(inst)
		end
		if inst.components.locomotor then
			inst.components.locomotor:SetSlowMultiplier(0.6)
			inst.components.locomotor.pathcaps = { player = true, ignorecreep = true }
			inst.components.locomotor.fasteronroad = true
			inst.components.locomotor:SetTriggersCreep(not inst:HasTag("spiderwhisperer"))
			inst.components.locomotor:SetAllowPlatformHopping(true)
			inst.components.locomotor.hop_distance_fn = GetHopDistance
		end
		if inst.components.drownable then
			inst.components.drownable.enabled = true
		end
		self:DespawnFx()
		self:DespawnExtraFx()
		self.tail.enabled = false
	end
end

function Flyer:IsFlying()
	return self._isflying:value()
end

function Flyer:SpawnFx()
	self:DespawnFx()
	local data = self.current_data
	if data.fx == nil then -- 使用默认的七彩祥云
		local fx = SpawnPrefab('myth_flyerfx_cloud')
		fx:config(data)
		fx:init()
		self.inst:AddChild(fx)
		self.fx = fx
		if  GetTime() - self.inst.spawntime < 1 then
			self.inst:DoTaskInTime(0.3,function()
				if fx and fx:IsValid() then
					fx:tryskinconfig()
				end
			end)
		end
	else 					-- 使用定制特效
		self.fx = self.inst:SpawnChild(data.fx.prefab)
		if self.fx.configwheel ~= nil then
			self.fx:configwheel(data)
		end
	end
end

function Flyer:DespawnFx()
	if self.fx and self.fx:IsValid() then
		self.fx:Despawn()
	end
end

function Flyer:SpawnExtraFx(data)
	if self.extra_fx_task then
		self.extra_fx_task:Cancel()
	end
	self.extra_fx_task_fn = function()
		if self.fx and self.fx:IsValid() then
			local ent = self.fx:SpawnChild(data.prefab)
			if data.offset then
				ent.Transform:SetPosition(data.offset:Get())
			end
		end
		self.extra_fx_task = self.inst:DoTaskInTime(data.interval(), self.extra_fx_task_fn)
	end

	self.extra_fx_task_fn()
end

function Flyer:DespawnExtraFx()
	if self.extra_fx_task then
		self.extra_fx_task:Cancel()
	end
	self.extra_fx_task_fn = function() end
end

function Flyer:GetFlyTargetHeight() -- 主客机通用: 获取飞行高度
	if not self.current_data then
		return 0
	end
	self.height_target = self.current_data.height * self:GetPercent()
	return self.height_target
end


function Flyer:OnRemoveEntity()
   	self:DespawnFx()
   	self:DespawnExtraFx()
end

function Flyer:OnSave()
	return {isflying = self:IsFlying()}
end

function Flyer:OnLoad(data)
	if data.isflying then
		self:SetFlying(true, true)
	end
end
Flyer.OnRemoveFromEntity = Flyer.OnRemoveEntity

return Flyer
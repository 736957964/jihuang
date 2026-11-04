# 饥荒一线工坊深度研读 Skill：主客双端复制组件（Replicable Component）与全服拓扑网络架构

- **工坊 ID**：1530801499 (`Fast Travel GUI`)
- **领域分类**：网络复制组件规范（AddReplicableComponent）、全服拓扑自维护池（Global Topology Registry）、危险状态逃逸防御、距离-季节动态开销模型
- **研读基准**：Steam 创意工坊在线原版源码

在开发需要跨端同步状态（如自定义交互信标、传送门、载具停靠点）的复杂网络 MOD 时：
1. **主客双端复制体系**：通过 `AddReplicableComponent("mycomponent")`，让客机自动装配 `mycomponent_replica`；
2. **拓扑注册中心**：用模块全局表 `ALL_NODES` 维护实体拓扑，实体生成时入网，被拆除时退网；
3. **服务端权威安全防护**：ModRPC 接收客户端请求时，必须由 MasterSim 重新执行近距离及战斗脱战断言。

```lua
-- ==============================================================================
-- ==============================================================================

local ALL_NODES = {}

local NetworkNode = Class(function(self, inst)
    self.inst = inst
    self.node_name = "Default Node"
    self.is_active = true

    table.insert(ALL_NODES, self)
end)
function NetworkNode:OnRemoveFromEntity()
    for i, v in ipairs(ALL_NODES) do
        if v == self then
            table.remove(ALL_NODES, i)
            break
        end
    end
end
function NetworkNode:CanTravelNow(player)
    if not player or not player:IsValid() then return false end

    if player.components.burnable and player.components.burnable:IsBurning() then
        return false, "BURNING"
    end

    local danger = GLOBAL.FindEntity(player, 12, function(target)
        return target.components.combat and target.components.combat.target == player
    end, { "_combat" }, { "INLIMBO", "player" })

    if danger ~= nil then
        return false, "IN_COMBAT"
    end

    return true
end

function NetworkNode:GetValidDestinations(player)
    local results = {}
    for _, node in ipairs(ALL_NODES) do
        if node ~= self and node.is_active and node.inst:IsValid() then
            table.insert(results, node.inst)
        end
    end
    return results
end

return NetworkNode

-- ==============================================================================
-- ==============================================================================

AddReplicableComponent("network_node")

AddPrefabPostInit("homesign", function(inst)
    inst:AddTag("_network_node")
    if GLOBAL.TheWorld.ismastersim then
        inst:RemoveTag("_network_node")
        inst:AddComponent("network_node")
    end
end)

AddModRPCHandler("NetworkNodeMod", "TeleportTo", function(player, src_inst, target_inst)
    if not player or not player:IsValid() or not src_inst or not target_inst then return end

    if player:GetDistanceSqToInst(src_inst) > 16 then return end

    local node = src_inst.components.network_node
    if not node then return end

    local can_travel, reason = node:CanTravelNow(player)
    if not can_travel then
        if player.components.talker then
            player.components.talker:Say("I can't teleport right now! (" .. reason .. ")")
        end
        return
    end

    if player.Physics then
        player.Physics:Teleport(target_inst.Transform:GetWorldPosition())
    else
        player.Transform:SetPosition(target_inst.Transform:GetWorldPosition())
    end
end)
```

1. **`OnRemoveFromEntity` 注销守卫不可或缺**：
   - 只要实体被玩家砸毁、被火烧毁、或被大脚踩烂，若没有在 `OnRemoveFromEntity` 中从全局表中将其引用清除，Lua 的 GC（垃圾回收器）就永远无法释放该实体，造成极其严重的堆内存泄漏。
2. **`Physics:Teleport` 与坐标直接赋值的分流**：
   - 传送具有物理刚体（Physics）的角色或生物时，必须调用 `inst.Physics:Teleport(x, y, z)`，严禁直接调用 `Transform:SetPosition`。直接改坐标会导致物理碰撞体残留在原地，引发隐形碰撞空气墙 bug。

## 五、进阶拓扑演进与变体分支

### 变体演进：Circular Placement (圆形摆放辅助) (Mod 2914336761)
- **变体场景与切面**：收录来自工坊 Mod 2914336761 (`Circular Placement (圆形摆放辅助)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller
AddComponentPostInit('playercontroller', function(PlayerController, inst)
    if inst ~= ThePlayer then
        return
    end

    local oldOnControl = PlayerController.OnControl
    PlayerController.OnControl = function(self, control, down)
        if CPMA.DATA.LESS_PREVIEW and not (controls and controls.CPMAPanel and controls.CPMAPanel.IsShow) then
        else
            if IsDefaultScreen() and down and oldIsKeyDown(TheInput, GLOBAL['KEY_' .. CPMA.DATA.CP_AUTO_BUTTON]) and GLOBAL.CIRCLE_HELPER and GLOBAL.CIRCLE_HELPER:IsValid() then
                if control == CONTROL_PRIMARY or control == CONTROL_SECONDARY and (not CPMA.DATA.LESS_PREVIEW or (controls.CPMAPanel and controls.CPMAPanel.IsShow)) then
                    return
                end
            end
        end
        local mouse_control = mouse_controls[control]
        if down and auto_thread and IsDefaultScreen() and (interrupt_controls[control] or mouse_control ~= nil and not TheInput:GetHUDEntityUnderMouse()) then
            kill_auto_thread()
        end
        return oldOnControl(self, control, down)
    end

    local oldOnUpdate = PlayerController.OnUpdate
    PlayerController.OnUpdate = function(self, ...)
        if IsDefaultScreen() then
            OnUpdateAnchorPos()
            OnCenterUpdate()
        end
        return oldOnUpdate(self, ...)
    end
end)
```

### 变体演进：快捷宣告(NoMu) (Mod 2784715091)
- **变体场景与切面**：收录来自工坊 Mod 2784715091 (`快捷宣告(NoMu)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller
AddComponentPostInit("playercontroller", function(self)
    local old_OnControl = self.OnControl

    function self:OnControl(control, down, ...)
        if GLOBAL.NOMU_QA.DATA.BLOCK_ACTION
            and (control == GLOBAL.CONTROL_PRIMARY or control == GLOBAL.CONTROL_SECONDARY) then
            if IsDefaultScreen() and GLOBAL.QA_UTILS.IsAltPressed() and GLOBAL.QA_UTILS.IsShiftPressed() then
                return true
            end
        end

        if old_OnControl then
            return old_OnControl(self, control, down, ...)
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:clock
AddComponentPostInit('clock', function(clock)
    local SW = TheWorld:HasTag("island") or TheWorld:HasTag("volcano")
    local HAM = TheWorld:HasTag("porkland")
    local oldGetDebugString = SW and clock.GetDebugString_tropical or HAM and clock.GetDebugString_plateau or clock.GetDebugString
    local oldDump = SW and clock.Dump_tropical or HAM and clock.Dump_plateau or clock.Dump

    local value
    value = Upvaluehelper.GetUpvalue(oldGetDebugString, '_phase')
    local _phase
    clock._phase = value
    _phase = value

    local _remainingtimeinphase
    value = Upvaluehelper.GetUpvalue(oldGetDebugString, '_remainingtimeinphase')
    clock._remainingtimeinphase = value
    _remainingtimeinphase = value

    local _segs = Upvaluehelper.GetUpvalue(oldDump, '_segs')
    local _totaltimeinphase = Upvaluehelper.GetUpvalue(oldDump,'_totaltimeinphase')

    if _totaltimeinphase and _remainingtimeinphase and _segs and _phase then
        clock.CalcRemainTimeOfDay = function()
            local time_of_day = _totaltimeinphase:value() - _remainingtimeinphase:value()
            for i = 1, _phase:value() - 1 do
                time_of_day = time_of_day + _segs[i]:value() * TUNING.SEG_TIME
            end
            return TUNING.TOTAL_DAY_TIME - time_of_day
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:nightmareclock
AddComponentPostInit('nightmareclock', function(clock)
    local oldOnUpdate = clock.OnUpdate
    local name, value

    local _remainingtimeinphase
    name, value = debug.getupvalue(oldOnUpdate, 1)
    if name == '_remainingtimeinphase' then
        _remainingtimeinphase = value
    end

    local _phase
    name, value = debug.getupvalue(oldOnUpdate, 4)
    if name == '_phase' then
        _phase = value
    end

    local PHASE_NAMES
    name, value = debug.getupvalue(oldOnUpdate, 5)
    if name == 'PHASE_NAMES' then
        PHASE_NAMES = value
    end

    local _totaltimeinphase
    name, value = debug.getupvalue(oldOnUpdate, 7)
    if name == '_totaltimeinphase' then
        _totaltimeinphase = value
    end

    if _remainingtimeinphase and _phase and _totaltimeinphase and PHASE_NAMES then
        function TheWorld:GetNightmareData()
            return {
                phase = PHASE_NAMES[_phase:value()],
                remain = _remainingtimeinphase:value(),
                total = _totaltimeinphase:value()
            }
        end
    end
end)
```

### 变体演进：兔尾艾冰 (Mod 3402670530)
- **变体场景与切面**：收录来自工坊 Mod 3402670530 (`兔尾艾冰`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:skinner
AddComponentPostInit("skinner",function(self)
        local oldfn = self.SetSkinName
        if oldfn then
            function self.SetSkinName(s,skinname,...)
                local old = s.skin_name
                local new = skinname
                if characterskins[old] and characterskins[old].clear_fn then
                    characterskins[old].clear_fn(s.inst,old)
                end
                if characterskins[new] and characterskins[new].init_fn then
                    characterskins[new].init_fn(s.inst,new)
                end
                oldfn(s,skinname,...)
            end
        end
end)
```

### 变体演进：Paranoia [BETA] (Mod 3596740317)
- **变体场景与切面**：收录来自工坊 Mod 3596740317 (`Paranoia [BETA]`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player_classified
AddPrefabPostInit("player_classified", function(inst)
    if not _G.TheNet:IsDedicated() then
        inst:DoStaticTaskInTime(0, RegisterNetListeners)
    end
end)
```

### 变体演进：Auto Stack and Pick Up (Mod 1803285852)
- **变体场景与切面**：收录来自工坊 Mod 1803285852 (`Auto Stack and Pick Up`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:stackable
AddComponentPostInit("stackable", function(comp)
	local shouldStack = autoStackEnabled
	local shouldAutoPickup = autoPickupEnabled
	
	if _G.POPULATING then
		shouldStack = (shouldStack and stackDuringPopulation)
		shouldAutoPickup = false
	end
	
	local compInst = comp.inst
	
	if not ShouldIgnoreEntity(compInst) then
		local oldOnDestack = comp.inst.components.stackable.ondestack
		comp.inst.components.stackable.ondestack = function(inst)
			if inst.wasjustcreatedfrombeingdestacked == nil then
				inst.wasjustcreatedfrombeingdestacked = true
			end
			if oldOnDestack ~= nil then
				oldOnDestack(inst)
			end
		end
	end
	
	compInst:DoTaskInTime(0.1, function(inst)
		if inst == nil then
			return
		end
	
		if ShouldIgnoreEntity(inst) then
			return
		end
		
		if inst.wasjustcreatedfrombeingdestacked then
			shouldAutoPickup = false
			if not manualDropAutoStackEnabled then
				shouldStack = false
			end
			inst.wasjustcreatedfrombeingdestacked = false
		end
		
		if shouldStack and not autoStackTwiggyTreeTwigs and inst.prefab == "twigs" then
			local x,y,z = inst.Transform:GetWorldPosition()
			local ents = _G.TheSim:FindEntities(x,y,z, 8, { "tree" }, { "FX", "NOCLICK", "DECOR","INLIMBO" })
			for i,ent in ipairs(ents) do
				if ent.build == "twiggy" then
					shouldStack = false
					break
				end
			end
		end
		
		
		
		if shouldStack and inst:HasTag("no_autostack_w") then
			shouldStack = false
		end
		
		if shouldAutoPickup and inst:HasTag("no_autopickup") then
			shouldAutoPickup = false
		end
		
		
		
		if (shouldAutoPickup or shouldStack) and not IsAutoPickupOrStackingBlockedByContext(inst) then
			if inst.parent == nil or (not inst.parent:HasTag("player") and not inst.parent.components.container) then
				if (inst.Physics and not inst.Physics:IsActive())
				or (inst.components.inventoryitem and not inst.components.inventoryitem.canbepickedup)
				or inst.updatetask ~= nil
				then
					inst.AutoPickUpOrAutoStackTaskTries = 0
					inst.AutoPickUpOrAutoStackTask = inst:DoPeriodicTask(0.5, function(inst)
						inst.AutoPickUpOrAutoStackTaskTries = inst.AutoPickUpOrAutoStackTaskTries + 1
						if inst == nil then
							return
						end
						local x, y, z = inst:GetPosition():Get()
						if inst:IsValid() and (not inst.Physics or inst.Physics:IsActive())
						and inst.components.inventoryitem and inst.components.inventoryitem.canbepickedup
						and inst.updatetask == nil
						and not (x == 0 and y == 0 and z == 0) then
							if inst.AutoPickUpOrAutoStackTask ~= nil then
								inst.AutoPickUpOrAutoStackTask:Cancel()
								inst.AutoPickUpOrAutoStackTask = nil
							end
							DoAutoPickUpOrAutoStack(inst, shouldAutoPickup, shouldStack)
						end
						if inst.AutoPickUpOrAutoStackTask ~= nil and inst.AutoPickUpOrAutoStackTaskTries >= 20 then
							inst.AutoPickUpOrAutoStackTask:Cancel()
							inst.AutoPickUpOrAutoStackTask = nil
						end
					end, 0.5)
				else
					DoAutoPickUpOrAutoStack(inst, shouldAutoPickup, shouldStack)
				end
			else
			end
		end
		
		if manualDropAutoStackEnabled and inst:IsValid() and not inst:HasTag("no_autostack_m") and not denyManualStack[inst.prefab] then
			inst:ListenForEvent("ondropped", function(inst)
				inst:DoTaskInTime(0, function(inst)
					AutoStack(inst, manualDropStackRange, manualStackMakeNewStackMainStack)
				end)
			end)
		end
	end)
end)
```



### 变体演进：CaveOnGround (Atualizado) (Mod 2283416213)
- **变体场景与切面**：收录来自工坊 Mod 2283416213 (`CaveOnGround (Atualizado)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2283416213)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:forest
AddPrefabPostInit("forest", fn)
end

AddToadStoolOnForest()

local function AddArchiveManager()

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:fossil_stalker
AddPrefabPostInit("fossil_stalker", function(inst)
        local function ItemTradeTest(inst, item, giver)
            if item == nil or item.prefab ~= "shadowheart" or giver == nil or giver.components.areaaware == nil then
                return false
            elseif inst.form ~= 1 then
                return false, "WRONGSHADOWFORM"
            elseif giver.components.areaaware:CurrentlyInTag("Atrium") and (G.FindEntity(inst, ATRIUM_RANGE, ActiveStargate, {"stargate"}) == nil or G.GetClosestInstWithTag("stalker", inst, 40) ~= nil) then
                return false, "CANTSHADOWREVIVE"
            end
            return true
        end
        
        local function OnAccept(inst, giver, item)
            if item.prefab == "shadowheart" then
                local stalker
                local stargate = G.FindEntity(inst, ATRIUM_RANGE, ActiveStargate, {"stargate"})
                if stargate ~= nil then
                    stalker = G.SpawnPrefab("stalker_atrium")
                    stalker.components.entitytracker:TrackEntity("stargate", stargate)
                    stargate:TrackStalker(stalker)
                else
                    stalker = G.SpawnPrefab("stalker")
                end
                local x, y, z = inst.Transform:GetWorldPosition()
                local rot = inst.Transform:GetRotation()
                inst:Remove()
                
                stalker.Transform:SetPosition(x, y, z)
                stalker.Transform:SetRotation(rot)
                stalker.sg:GoToState("resurrect")
                
                giver.components.sanity:DoDelta(TUNING.REVIVE_SHADOW_SANITY_PENALTY)
            end
        end
        inst.components.trader.onaccept = OnAccept
        inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
    end)
end
end

```



### 变体演进：农作物+ (Mod 2795218025)
- **变体场景与切面**：收录来自工坊 Mod 2795218025 (`农作物+`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2795218025)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:petals
AddPrefabPostInit("petals",function(inst)
		local function Seed_GetDisplayName(inst)
			local registry_key = inst.weed_def.product
			local plantregistryinfo = inst.weed_def.plantregistryinfo
			return (GLOBAL.ThePlantRegistry:KnowsSeed(registry_key, plantregistryinfo) and GLOBAL.ThePlantRegistry:KnowsPlantName(registry_key, plantregistryinfo)) and GLOBAL.STRINGS.NAMES["KNOWN_"..string.upper(inst.ming)]
					or nil
		end
		local function can_plant_seed(inst, pt, mouseover, deployer)
			local x, z = pt.x, pt.z
			return GLOBAL.TheWorld.Map:CanTillSoilAtPoint(x, 0, z, true)
		end
		local suiji = math.random()
		local yecaoming = suiji < 0.40 and "weed_forgetmelots" or suiji < 0.60 and "weed_tillweed" or suiji < 0.80 and "weed_firenettle" or suiji < 1 and "weed_ivy" or "weed_forgetmelots"		
		inst.ming = yecaoming
		inst.product = string.sub(inst.ming, 6)
		if inst.product == "firenettle" then inst.product = inst.product .. "s"
		elseif inst.product == "ivy" then inst.product = nil end
		inst:AddTag("deployedplant")
		inst:AddTag("deployedfarmplant")
		inst.overridedeployplacername = "seeds_placer"
		--inst.shuxu = inst.ming == "weed_forgetmelots" and 1 or inst.ming == "weed_tillweed" and 2 or inst.ming == "weed_firenettle" and 3 or inst.ming == "weed_ivy" and 4 or 1
		inst.weed_def = WEED_DEFS[inst.ming]
		--print("name:"..inst.ming.."        yecaoming:"..yecaoming.. "         product:"..inst.product)
		inst._custom_candeploy_fn = can_plant_seed
		inst.displaynamefn = Seed_GetDisplayName
	end)
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:farm_plant_
for _,v in pairs(farm_plant_ming) do AddPrefabPostInit("farm_plant_"..v,nzwshouhuo) end 
end
if zujian_juxinghua then AddComponentPostInit("growable",function(self) if not self.inst:HasTag("nzw_juxing") then self.inst.force_oversized = true end end) end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:pickable
AddComponentPostInit("pickable",function(self) local self1 = self.inst.components.growable
		if (self.inst:HasTag("farm_plant") or self.inst.plant_def) and self1 then
		if zujian_wufulan then self.inst:DoTaskInTime(0.1, function() if self1.stage == 5 and not self.inst:HasTag("nzw_wufulan") then self1:StopGrowing() end end) end
		if zujian_juxingshu and not self.inst:HasTag("nzw_juxingshu") or zujian_guocaishu and not self.inst:HasTag("nzw_guocaishu") or zujian_zhongzishu and not self.inst:HasTag("nzw_zhongzishu") then self.inst:DoTaskInTime(0.3, function() if self.inst.components.lootdropper and self.inst.plant_def then self.inst.components.lootdropper.lootsetupfn = nongzuowufn end end) end
		if zujian_kuaizhai then self.inst:DoTaskInTime(0.1, function() if not self.inst:HasTag("nzw_kuaizhai") then self.quickpick = true end end) end end
	end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:weed_forgetmelots
AddPrefabPostInit("weed_forgetmelots",ycshouhuo) 
end
if biwangwo1 or yecao_kuaisu then AddComponentPostInit("pickable",function(self) self.inst:DoTaskInTime(1, function() if self.inst:HasTag("yc_bww") and self.inst.components.growable and self.inst.components.growable.stage + 1 == #self.inst.components.growable.stages then if biwangwo1 then self.inst.components.growable:StopGrowing() end if yecao_kuaisu then self.quickpick = true end end end) end)

```





### 变体演进：Birdcage(Time Based) (Mod 375618000)
- **变体场景与切面**：收录来自工坊 Mod 375618000 (`Birdcage(Time Based)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 375618000)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:birdcage
AddPrefabPostInit("birdcage", birdcagePrefabPostInit)

function featherPrefabPostInit(inst)
	if not inst:HasTag("feather") then
		inst:AddTag("feather")
	end
end

```



### 变体演进：Throwable Weapons (Mod 896539374)
- **变体场景与切面**：收录来自工坊 Mod 896539374 (`Throwable Weapons`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 896539374)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:aoespell
--[[AddComponentPostInit("aoespell",function(self) --add support to the component for multiple spells
	self.spells = {1=self.spellfn} --need to cover the case where there is no spellfn already
	self.index=1
	
	function self:CycleSpell()
		self.index+=1
		if #self.spells<self.index then
			self.index=1
		end
		self.SetSpellFn(self.spells[self.index])
	end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:aoetargeting
--[[AddComponentPostInit("aoetargeting",function(self)
	self.spells={1={
	{
		ease=self.reticule.ease,
		smoothing=self.reticule.smoothing,
		targetfn=self.reticule.targetfn,
		reticuleprefab=self.reticule.prefab,
		validcolour=self.reticule.validcolour,
		invalidcolour=self.reticule.invalidcolour,
		mouseenabled=self.reticule.mouseenabled,
		twinstickmode=self.reticule.twinstickmode,
		pingprefab=self.reticule.pingprefab,
		targetprefab=self.targetprefab,
		alwaysvalid=self.alwaysvalid,
		allowwater=self.allowwater,
		allowriding=self.allowriding,
		deployradius=self.deployradius,
		range=self.range,
		shouldrepeatcastfn=self.shouldrepeatcastfn,
	}
	self.index=1
	
	function self:AddSpell(data)
		self.reticule=
		{
			ease=data.ease or false,
			smoothing=data.smoothing or 6.66,
			reticuleprefab=data.reticuleprefab or "reticule",
			validcolour=data.validcolour or { 204 / 255, 131 / 255, 57 / 255, 1 },
			invalidcolour=,
			mouseenabled=,
			twinstickmode=,
		}
	end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:wathgrithr
AddPrefabPostInit("wathgrithr", function(inst)
	inst:AddTag("ThrownSpears")
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:woodie
AddPrefabPostInit("woodie", function(inst)
	inst:AddTag("ThrownAxes")
	inst:AddTag("AlwaysReturn")
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:winona
AddPrefabPostInit("winona", function(inst)
	inst:AddTag("ThrownTools")
end)

```



### 变体演进：Refresh Food - Ice Box (Mod 1914860022)
- **变体场景与切面**：收录来自工坊 Mod 1914860022 (`Refresh Food - Ice Box`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 1914860022)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:krampus_sack
AddPrefabPostInit("krampus_sack",function(inst)
	    inst:AddTag("fridge")
	    inst:AddTag("nocool")
	end)

```


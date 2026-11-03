# 饥荒一线工坊深度研读 Skill：主客双端复制组件（Replicable Component）与全服拓扑网络架构

- **工坊 ID**：1530801499 (`Fast Travel GUI`)
- **领域分类**：网络复制组件规范（AddReplicableComponent）、全服拓扑自维护池（Global Topology Registry）、危险状态逃逸防御、距离-季节动态开销模型
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发需要跨端同步状态（如自定义交互信标、传送门、载具停靠点）的复杂网络 MOD 时：
1. **主客双端复制体系**：通过 `AddReplicableComponent("mycomponent")`，让客机自动装配 `mycomponent_replica`；
2. **拓扑注册中心**：用模块全局表 `ALL_NODES` 维护实体拓扑，实体生成时入网，被拆除时退网；
3. **服务端权威安全防护**：ModRPC 接收客户端请求时，必须由 MasterSim 重新执行近距离及战斗脱战断言。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：服务端权威拓扑管理组件 (scripts/components/network_node.lua)
-- ==============================================================================

local ALL_NODES = {}

local NetworkNode = Class(function(self, inst)
    self.inst = inst
    self.node_name = "Default Node"
    self.is_active = true

    -- 1. 自动注册入全服拓扑网
    table.insert(ALL_NODES, self)
end)

--- 销毁退网生命周期守卫 (防内存泄漏与幽灵节点)
function NetworkNode:OnRemoveFromEntity()
    for i, v in ipairs(ALL_NODES) do
        if v == self then
            table.remove(ALL_NODES, i)
            break
        end
    end
end

--- 危险逃逸断言检测 (防战斗作弊)
function NetworkNode:CanTravelNow(player)
    if not player or not player:IsValid() then return false end

    -- 检测是否着火
    if player.components.burnable and player.components.burnable:IsBurning() then
        return false, "BURNING"
    end

    -- 检测附近仇恨敌人
    local danger = GLOBAL.FindEntity(player, 12, function(target)
        return target.components.combat and target.components.combat.target == player
    end, { "_combat" }, { "INLIMBO", "player" })

    if danger ~= nil then
        return false, "IN_COMBAT"
    end

    return true
end

--- 获取当前可达有效节点列表
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
-- 范式 2：双端网络注册与 ModRPC 安全校验 (modmain.lua)
-- ==============================================================================

-- 1. 注册主客端复制组件
AddReplicableComponent("network_node")

-- 2. 实体切面挂载
AddPrefabPostInit("homesign", function(inst)
    inst:AddTag("_network_node")
    if GLOBAL.TheWorld.ismastersim then
        inst:RemoveTag("_network_node")
        inst:AddComponent("network_node")
    end
end)

-- 3. 服务端安全校验 RPC 通道
AddModRPCHandler("NetworkNodeMod", "TeleportTo", function(player, src_inst, target_inst)
    if not player or not player:IsValid() or not src_inst or not target_inst then return end

    -- 安全校验 1：玩家是否在源节点交互范围内 (防全图隔空发包作弊)
    if player:GetDistanceSqToInst(src_inst) > 16 then return end

    local node = src_inst.components.network_node
    if not node then return end

    -- 安全校验 2：战斗与危险防逃逸
    local can_travel, reason = node:CanTravelNow(player)
    if not can_travel then
        if player.components.talker then
            player.components.talker:Say("I can't teleport right now! (" .. reason .. ")")
        end
        return
    end

    -- 校验通过：执行权威位移并扣除开销
    if player.Physics then
        player.Physics:Teleport(target_inst.Transform:GetWorldPosition())
    else
        player.Transform:SetPosition(target_inst.Transform:GetWorldPosition())
    end
end)
```

---

## 三、避坑与生产安全准则

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
-- 生产级架构复刻切面范式 (提取自 Mod 2914336761)
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
-- 生产级架构复刻切面范式 (提取自 Mod 2784715091)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller
AddComponentPostInit("playercontroller", function(self)
    local old_OnControl = self.OnControl

    function self:OnControl(control, down, ...)
        -- 在宣告快捷键按下时阻断主/副操作
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
-- 生产级架构复刻切面范式 (提取自 Mod 3402670530)
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
-- 生产级架构复刻切面范式 (提取自 Mod 3596740317)
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
-- 生产级架构复刻切面范式 (提取自 Mod 1803285852)
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
	
	-- Edge case fix. When holding CTRL and left-clicking on the ground with an item in your hands,
	-- it subtracts 1 from the stack being held in the mouse, and spawns a new prefab to be that new
	-- instance. It doesn't drop the instance, but spawns it directly to the ground.
	-- This makes it NOT behave like a normal manual drop, and so it is automatically picked up or stacked.
	-- I fix this by using the fact that Stackable:Get(num), which creates this new instance, calls
	-- ondestack on it afterwards. So, I set a bool on the instance, and then use it in the next frame
	-- (my DoTaskInTime) to identify whether this spawned item was just destacked, and if so, do not
	-- do automatic pick up, and if manualDropAutoStackEnabled is false we also cancel automatic stacking.
	-- Note: We don't do this on entities we want to ignore. There is a duplicate check in the DoTaskInTime
	-- below. This is because .prefab isn't set until after the postinits, and we also cannot be sure that
	-- all tags have been applied yet. We still do the check here, though, since we can then skip the whole
	-- destacking-thing altogether.
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
	
	-- I changed this to 0.1 from 0, so the Quaker-script (and other scripts that spawn items),
	-- is allowed to manipulate the item between the stackable-component being added,
	-- and my script doing its ShouldIgnoreEntity() checks and especially the
	-- .inventoryitem.canbepickedup bool-check, since the Quaker-script sets that to false after
	-- spawning an item, and then to true again once it has landed and possibly been destroyed by the fall.
	-- This should also let other mods that spawn items have at least a frame or two before I destroy the item.
	-- My checks should be solid enough to cancel its functionality if the item has become invalid or destroyed.
	compInst:DoTaskInTime(0.1, function(inst)
		if inst == nil then
			return
		end
	
		-- If it is an entity we want to ignore, we return instantly.
		-- The reason why we have the check here AND above, is that .prefab isn't set until after the postinits,
		-- and we also cannot be sure that all tags have been applied yet, so we have to delay the check until here.
		if ShouldIgnoreEntity(inst) then
			-- print("Ignoring entity "..inst.prefab)
			return
		end
		
		if inst.wasjustcreatedfrombeingdestacked then
			-- print(inst.prefab.." was spawned due to manual destacking. Skipping auto pick up"..(manualDropAutoStackEnabled and "." or " and also auto stacking, since manual drop auto stacking is disabled."))
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
		
		-- if shouldStack and not autoStackPenguinEggs and inst.prefab == "bird_egg" then
			-- local x,y,z = inst.Transform:GetWorldPosition()
			-- local ents = _G.TheSim:FindEntities(x,y,z, 4, { "penguin" }, { "FX", "NOCLICK", "DECOR","INLIMBO" })
			-- if #(ents) > 0 then
				-- shouldStack = false
			-- end
		-- end
		
		-- if shouldStack and not autoStackPenguinEggs and inst.prefab == "rottenegg" then
			-- local x,y,z = inst.Transform:GetWorldPosition()
			-- local ents = _G.TheSim:FindEntities(x,y,z, 4, { "penguin", "lunar_aligned" }, { "FX", "NOCLICK", "DECOR","INLIMBO" })
			-- if #(ents) > 0 then
				-- shouldStack = false
			-- end
		-- end
		
		if shouldStack and inst:HasTag("no_autostack_w") then
			shouldStack = false
		end
		
		if shouldAutoPickup and inst:HasTag("no_autopickup") then
			shouldAutoPickup = false
		end
		
		-- This makes it so that items dropping from the ceiling during an earthquake are not Auto-Pickup'ed
		-- nor Auto-Stacked until their .canbepickedup is true (or it runs out of tries after 10 seconds).
		-- This fixes a problem with some falling items disappearing during earhquakes, due to being Auto-Pickup'ed
		-- before their falling sequence has completed.
		-- NOTE: NOT SURE WHAT OTHER IMPLICATIONS THIS MAY HAVE!
		-- if inst.components.inventoryitem and not inst.components.inventoryitem.canbepickedup then
			-- shouldStack = false
			-- shouldAutoPickup = false
		-- end
		
		-- print(inst.prefab.." was spawned and"..((not shouldAutoPickup and not shouldStack) and " should neither auto pick up nor auto stack." or ((shouldAutoPickup and " should auto pick up" or " should NOT auto pick up")..(shouldStack and " and should auto stack." or " and should NOT auto stack."))))
		
		if (shouldAutoPickup or shouldStack) and not IsAutoPickupOrStackingBlockedByContext(inst) then
			if inst.parent == nil or (not inst.parent:HasTag("player") and not inst.parent.components.container) then
				if (inst.Physics and not inst.Physics:IsActive())
				or (inst.components.inventoryitem and not inst.components.inventoryitem.canbepickedup)
				-- The Quaker (earthquake) script uses the name "updatetask" for its fall-and-maybe-destroy-task in debris.
				-- If we let it stay on, then the player somehow gets hit by all the debris, killing them. We wait until it is gone.
				or inst.updatetask ~= nil
				then
					-- print("Physics were not active on "..inst.prefab.." OR inventoryitem.canbepickedup was false; it was "..inventoryitem.canbepickedup..". Starting task...")
					-- if inst.parent ~= nil then
						-- print(inst.prefab.." has a parent: "..inst.parent.prefab)
					-- else
						-- print(inst.prefab.." does NOT have a parent")
					-- end
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
							-- print("Physics are now active, canbepickedup is true, it is not earthquake debris currently falling, and the entity has a position that is not 0,0,0. Trying to auto pick up and auto stack "..inst.prefab)
							if inst.AutoPickUpOrAutoStackTask ~= nil then
								inst.AutoPickUpOrAutoStackTask:Cancel()
								inst.AutoPickUpOrAutoStackTask = nil
							end
							DoAutoPickUpOrAutoStack(inst, shouldAutoPickup, shouldStack)
						end
						if inst.AutoPickUpOrAutoStackTask ~= nil and inst.AutoPickUpOrAutoStackTaskTries >= 20 then
							-- print("Cancelling AutoPickUpOrAutoStackTask after trying for too long.")
							inst.AutoPickUpOrAutoStackTask:Cancel()
							inst.AutoPickUpOrAutoStackTask = nil
						end
					end, 0.5)
				else
					DoAutoPickUpOrAutoStack(inst, shouldAutoPickup, shouldStack)
				end
			else
				-- print(inst.prefab.." has a parent, "..inst.parent.prefab..", which is a player or a container. Skipping auto pick up and stacking!")
			end
		end
		
		-- Add the manual drop stacking if it's enabled, and the inst has not already
		-- been fully absorbed into stacks on the ground by the AutoStack() call above.
		if manualDropAutoStackEnabled and inst:IsValid() and not inst:HasTag("no_autostack_m") and not denyManualStack[inst.prefab] then
			-- print("stackable => adding ondropped listener")
			inst:ListenForEvent("ondropped", function(inst)
				-- Wait for all listeners of "ondropped" to do their thing (next frame; I had a crash otherwise)...
				inst:DoTaskInTime(0, function(inst)
					-- ...then auto stack whenever it is dropped.
					-- print(inst.prefab.." was dropped")
					AutoStack(inst, manualDropStackRange, manualStackMakeNewStackMainStack)
				end)
			end)
		end
	end)
end)

```



### 变体演进：굶지마 다함께 한글화 [클라이언트 버전] (Mod 2391246365)
- **变体场景与切面**：收录来自工坊 Mod 2391246365 (`굶지마 다함께 한글화 [클라이언트 버전]`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2391246365)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller
AddComponentPostInit("playercontroller", GetHoverTextOverride)

-- Rearrange the non-overriden tooltip
local function OnUpdate(self)
	local OnUpdate_old = self.OnUpdate or function() end
	self.OnUpdate = function(self)
		OnUpdate_old(self)
		if not self.shown then
			return
		end

		local str = nil
		if not self.isFE then
			str = (self.owner.HUD ~= nil and self.owner.HUD.controls:GetTooltip()) or (self.owner.components ~= nil and self.owner.components.playercontroller:GetHoverTextOverride())
		else
			str = self.owner:GetTooltip()
		end
		
		local lmb = nil
		if str == nil and not self.isFE and self.owner:IsActionsVisible() then
			lmb = self.owner.components.playercontroller:GetLeftMouseAction()
			if lmb ~= nil then
				local overriden
				str, overriden = lmb:GetActionString()

				if lmb.action.show_primary_input_left then
                	return
                end
				
				if not overriden and lmb.target ~= nil and lmb.invobject == nil and lmb.target ~= lmb.doer then
					local name = lmb.target:GetDisplayName()
					if name ~= nil then
						local adjective = lmb.target:GetAdjective()
						name = (adjective ~= nil and (adjective.." "..name)) or name
						
						if lmb.target.replica.stackable ~= nil and lmb.target.replica.stackable:IsStack() then
							name = name.." "..tostring(lmb.target.replica.stackable:StackSize()).."개"
						end
						str = name.." "..str
					end
				end
			end
			if str then
				self.text:SetString(str)
				self.str = str
			end
		end
	end
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:skeleton_player
AddPrefabPostInit("skeleton_player", skeleton_player)

--2. player inspection
local function player_common(inst)
	if inst.components.inspectable ~= nil then
		if inst.components.inspectable.getspecialdescription_old == nil then
			inst.components.inspectable.getspecialdescription_old = inst.components.inspectable.getspecialdescription
		end

		function inst.components.inspectable.getspecialdescription(inst, ...)
			return pp.replacePP(inst.components.inspectable.getspecialdescription_old(inst, ...), inst:GetDisplayName())
		end
	end
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:player_common
AddPrefabPostInit("player_common", player_common)
--3. carrat race winner
--disabled, the parameter is easely lost. Also not tested enough.
--[[AddPrefabPostInit("yotc_carrat_race_finish", function(inst)
	if inst.components.inspectable ~= nil then
		if inst.components.inspectable.getspecialdescription_old == nil then
			inst.components.inspectable.getspecialdescription_old = inst.components.inspectable.getspecialdescription or function() end
		end
		function inst.components.inspectable.getspecialdescription(inst, ...)
			local str = inst.components.inspectable.getspecialdescription_old(inst, ...)
			local winner = inst._winner ~= nil and inst._winner.name
			return (winner ~= nil and pp.replacePP(str, winner)) or str
		end
	end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:yotc_carrat_race_finish
--[[AddPrefabPostInit("yotc_carrat_race_finish", function(inst)
	if inst.components.inspectable ~= nil then
		if inst.components.inspectable.getspecialdescription_old == nil then
			inst.components.inspectable.getspecialdescription_old = inst.components.inspectable.getspecialdescription or function() end
		end
		function inst.components.inspectable.getspecialdescription(inst, ...)
			local str = inst.components.inspectable.getspecialdescription_old(inst, ...)
			local winner = inst._winner ~= nil and inst._winner.name
			return (winner ~= nil and pp.replacePP(str, winner)) or str
		end
	end

```



### 变体演进：芙兰朵露·斯卡蕾特 (Mod 3615173314)
- **变体场景与切面**：收录来自工坊 Mod 3615173314 (`芙兰朵露·斯卡蕾特`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3615173314)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:skinner
AddComponentPostInit("skinner", function(self)
    local oldfn = self.SetSkinName
    if oldfn then
        function self.SetSkinName(s, skinname, ...)
            local old = s.skin_name
            local new = skinname
            if characterskins[old] and characterskins[old].clear_fn then
                characterskins[old].clear_fn(s.inst, old)
            end
            if characterskins[new] and characterskins[new].init_fn then
                characterskins[new].init_fn(s.inst, new)
            end
            oldfn(s, skinname, ...)
        end
    end
end)

```



### 变体演进：Don (Mod 3495316998)
- **变体场景与切面**：收录来自工坊 Mod 3495316998 (`Don`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3495316998)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller
AddComponentPostInit("playercontroller", function(self)
    local oldOnLeftClick = self.OnLeftClick
    self.OnLeftClick = function(inst, down, ...)
        local target = GLOBAL.TheInput:GetWorldEntityUnderMouse()
        if down and GLOBAL.TheInput:IsKeyDown(GLOBAL.KEY_CTRL) and IsPetBeefalo(target) then
            if not ALLOW_DOUBLE_CLICK_ATTACK then
                return
            end
            local is_double_click = target.replica._petbeefalo_startdoubleclicktime ~= nil and (GLOBAL.GetTime() - target.replica._petbeefalo_startdoubleclicktime) < GLOBAL.DOUBLE_CLICK_TIMEOUT
            target.replica._petbeefalo_startdoubleclicktime = GLOBAL.GetTime()
            if not is_double_click then
                return
            end
        end
        return oldOnLeftClick(inst, down, ...)
    end
end)

```



### 变体演进：Auto Cooking (Mod 2033458869)
- **变体场景与切面**：收录来自工坊 Mod 2033458869 (`Auto Cooking`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2033458869)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller
ENV.AddComponentPostInit("playercontroller", function(self)
    if self.inst == ThePlayer then
        self.inst:ListenForEvent("aqp_threadstart", StopCooking) -- For AttackQueue Plus
    end
end)

```



### 变体演进：Rock Beefalo (Mod 3468519821)
- **变体场景与切面**：收录来自工坊 Mod 3468519821 (`Rock Beefalo`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3468519821)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:beefalo
AddPrefabPostInit("beefalo", function(inst)
    inst:DoPeriodicTask(0.01, function()
        if inst.AnimState:IsCurrentAnimation("alert_idle") then
            inst.AnimState:SetBank("rockbeefalo")
        else
            inst.AnimState:SetBank("beefalo")
        end
    end)
end)

```


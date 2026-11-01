# 饥荒一线工坊深度研读 Skill：全局 TUNING 梯队注入与 AddPrefabPostInitAny 智能逼近
```
- **工坊 ID**：374550642 (`Increased Stack size`)
- **领域分类**：全局 TUNING 宏变量重写、`AddPrefabPostInitAny` 全局实体切面优化、非标离散数值区间逼近算法
- **研读基准**：Steam 创意工坊在线原版源码
```
---
```
## 一、核心实现原理与架构全貌
```
在饥荒模组开发中，很多全局性调整（如调整全服腐烂速度、全服堆叠上限、全服移动速度倍率）有两种流派：
1. **轻量流派（推荐首选）**：改写官方 `GLOBAL.TUNING` 表中的宏常量；
2. **强制穿透流派（防御第三方硬编码）**：借助 `AddPrefabPostInitAny` 拦截所有实例化实体并强行修正组件。
```
`Increased Stack Size` 提供了这两种流派融合的最佳实践。
```
---
```
## 二、标准化生产级代码范式 (可直接移植)
```
```lua
-- ==============================================================================
-- 范式 1：全局 TUNING 五级梯队宏覆盖 (modmain.lua)
-- ==============================================================================
```
local TUNING = GLOBAL.TUNING
```
-- 1. 覆写官方标准梯队 (侵入性最低，零运行时开销)
TUNING.STACK_SIZE_LARGEITEM = 40  -- 原版 10 (如大肉、原木)
TUNING.STACK_SIZE_MEDITEM   = 80  -- 原版 20 (如草、枝条、石头)
TUNING.STACK_SIZE_SMALLITEM = 99  -- 原版 40 (如浆果、花瓣)
TUNING.STACK_SIZE_TINYITEM  = 120 -- 原版 60 (如蜜蜂、蚊子)
TUNING.STACK_SIZE_PELLET    = 250 -- 原版 120 (如种子、火药)
```
-- ==============================================================================
-- 范式 2：针对硬编码第三方 Prefab 的智能区间逼近器 (scripts/tools/stack_approximator.lua)
-- ==============================================================================
```
local TARGET_TIERS = { 40, 80, 99, 120, 250 }
```
-- 离散区间逼近：将非标数值（如 50）智能平滑映射到最接近的高阶档位
local function ApproximateTier(val)
    if not val or type(val) ~= "number" then return TARGET_TIERS[2] end
    for _, tier in ipairs(TARGET_TIERS) do
        if val <= tier then
            return tier
        end
    end
    return TARGET_TIERS[#TARGET_TIERS]
end
```
-- 全局实体切面拦截 (高性能短路设计)
AddPrefabPostInitAny(function(inst)
    -- 仅服务端执行，客机依赖网络同步
    if not GLOBAL.TheWorld.ismastersim then return end
```
    local stackable = inst.components.stackable
    -- 核心性能守门员：90% 的实体没有 stackable，立即短路返回
    if stackable == nil then return end
```
    local current = stackable.maxsize
    local target = ApproximateTier(current)
```
    if target and target ~= current then
        stackable.maxsize = target
    end
end)
```
```
---
```
## 三、避坑与生产安全准则
```
1. **`AddPrefabPostInitAny` 性能陷阱**：
   - 绝不要在 `AddPrefabPostInitAny` 回调内执行 `TheSim:FindEntities`、字符串拼接、复杂正则表达式或大表遍历。实体生成每秒可能触发数十次，必须通过首行的 `if inst.components.xxx == nil then return end` 毫秒级退出。
2. **`replica` 客户端显示对齐**：
   - 饥荒的 `stackable` 组件在主客机同步时，`replica.stackable:MaxSize()` 会自动拉取服务端的最新容量。无需在客户端手动再去 Hook `replica`，避免引发客户端本地与网络包的状态竞争（Race Condition）。
```
```
## 五、进阶拓扑演进与变体分支
```
```
```
### 变体演进：Houndius Shootius protects Chester (and beefalo) (Mod 3476470130)
- **变体场景与切面**：收录来自工坊 Mod 3476470130 (`Houndius Shootius protects Chester (and beefalo)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3476470130)
-- ============================================================================
local GLOBAL = GLOBAL
-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function(inst)
    local RETARGET_MUST_TAGS = { "_combat" }
    local RETARGET_CANT_TAGS = { "INLIMBO", "player", "eyeturret", "engineering" }
    local function retargetfn(inst)
        local target = inst.components.combat.target
        if target ~= nil and
            target:IsValid() and
            inst:IsNear(target, TUNING.EYETURRET_RANGE + 3) then
            --keep current target
            return
        end
        local playertargets = {}
        for i, v in ipairs(GLOBAL.AllPlayers) do
            if v.components.combat.target ~= nil then
                playertargets[v.components.combat.target] = true
            end
        end
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, TUNING.EYETURRET_RANGE + 3, RETARGET_MUST_TAGS, RETARGET_CANT_TAGS)
        for i, v in ipairs(ents) do
            if v ~= inst and
                v ~= target and
                v.entity:IsVisible() and
                inst.components.combat:CanTarget(v) and
                (   playertargets[v] or
                    v.components.combat:TargetIs(inst) or --anything targetting the turret
                    (v.components.combat.target ~= nil and v.components.combat.target:HasTag("player")) or --anything targetting players
                    (v.components.combat.target ~= nil and v.components.combat.target:HasTag("companion")) or --anything targetting chester etc
                    (v.components.combat.target ~= nil and v.components.combat.target:HasTag("beefalo") and v.components.domesticatable and v.components.domesticatable.domestication > 0) --anything targetting beefalo that are at least partially tamed
                ) then
                    return v
            end
        end
        return nil
    end
    UpvalueHacker.SetUpvalue(GLOBAL.Prefabs.eyeturret.fn, retargetfn, "retargetfn")
end)

```

### 变体演进：45 Inventory Slots with Equip Inventory (Mod 2802552738)
- **变体场景与切面**：收录来自工坊 Mod 2802552738 (`45 Inventory Slots with Equip Inventory`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2802552738)
-- ============================================================================
local GLOBAL = GLOBAL
-- 切面钩子：AddPrefabPostInit:inventory_classified
    end
    AddPrefabPostInit("inventory_classified", addItemSlotNetvarsInInventory)
    local HUD_ATLAS = "images/hud.xml"
    local W = 64
    local SEP = 7
    local YSEP = 8
    local INTERSEP = 15
    local inv_CTorBase = inv._ctor or function() return true end
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:backpack
AddPrefabPostInit("backpack",
function(inst)
    if ENABLEBACKPACK == true then
        if inst.components.inventoryitem then
            inst.components.inventoryitem.cangoincontainer = true
        end
    else
        if inst.components.inventoryitem then
            inst.components.inventoryitem.cangoincontainer = false
        end
    end
end )

```

### 变体演进：装备大师 (Mod 3123028409)
- **变体场景与切面**：收录来自工坊 Mod 3123028409 (`装备大师`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3123028409)
-- ============================================================================
local GLOBAL = GLOBAL
-- 切面钩子：AddComponentPostInit:playercontroller
end
AddComponentPostInit("playercontroller", function(self, inst)
	if inst ~= ThePlayer then return end
	local player = inst
	local function Doeat(food)
		if ThePlayer.components.playercontroller:CanLocomote()
			and not ThePlayer.components.playercontroller.ismastersim then
			local buffaction = BufferedAction(ThePlayer, food, ACTIONS.EAT)
			ThePlayer.components.playercontroller:RemoteControllerUseItemOnSelfFromInvTile(buffaction,
				food)
		else
			SendRPCToServer(RPC.ControllerUseItemOnSelfFromInvTile, ACTIONS.EAT.code, food)
		end
	end
	local function checkandeat()
		if MOD_util:GetMOption("equipmaster_closeeat", closeeat) then return end --关闭了自动吃
		local hunger = ThePlayer and ThePlayer.replica and ThePlayer.replica.hunger and
			ThePlayer.replica.hunger:GetCurrent()
		if hunger and hunger <= 1 then
			if BestEquiments['auto_eat'].item and PLAYER_util:IsHoldingItem(BestEquiments['auto_eat'].item, true) then
				Doeat(BestEquiments['auto_eat'].item)
			else
				if BestEquiments['walk_hands'] then
					updateequip({ eat = true }) --强制更新食物
				end
				Doeat(BestEquiments['auto_eat'].item)
			end
		end
	end
	player:ListenForEvent("healthdelta", checkandeat)
	player:ListenForEvent('hungerdelta', checkandeat)
	player:DoTaskInTime(0, function()
		if player ~= ThePlayer then return end
		--监听走a里面推送的事件
		ThePlayer:ListenForEvent("EquipItem", function(inst, data)
			if not closeequip and MOD_util:GetMOption("equipmaster_hitrun", true) then
				if type(data.target) == "table" and dontneed[data.target.prefab] then
				else
					if string.find(data.type, 'fight') then
						if not MOD_util:GetMOption("equipmaster_closefight", closefight) then
							EquipMaster:equipbystring(data.type, data.target)
						end
					elseif string.find(data.type, 'walk') then
						if not MOD_util:GetMOption("equipmaster_closewalk", closewalk) then
							EquipMaster:equipbystring(data.type, data.target)
						end
					else
						EquipMaster:equipbystring(data.type, data.target)
					end
				end
			end
		end)
		--
		local oldsay = ThePlayer.components.talker.Say
		function ThePlayer.components.talker:Say(...)
			local args = { ... }
			if args[1] == GetString(ThePlayer, "ANNOUNCE_ENTER_DARK") then
				if not MOD_util:GetMOption("equipmaster_closelight", closelight) and BestEquiments['auto_light'].item then
					equipitem(BestEquiments['auto_light'].item, 'auto_light')
				end
			end
			return oldsay(self, ...)
		end
		for k, v in pairs(EQUIPSLOTS) do
			BestEquiments['walk_' .. v] = {}
			BestEquiments['fight_' .. v] = {}
			--print('mmdx_walk_' .. v)
		end
		-- print('updateequip_1')
		updateequip() --进游戏先加载一边
		player:ListenForEvent("itemget",
			function(self, data)
				local item = data and data.item
				if item and (item:HasTag("_equippable") or item:HasTag("fresh")) and isbetteritem(item) then
					--print("updateequip()")
					if TheNet:GetIsServer() then
						player:DoTaskInTime(0, updateequip)
					else
						updateequip()
					end
				end
			end)
	end)
end)
local function checkplayerindark() --1.4258233308792
	if ThePlayer.LightWatcher:GetTimeInDark() > 0 and
		not ThePlayer.components.playervision:HasNightVision() and ThePlayer.prefab ~= 'wathom' then
		return true
	else
	end
end
local creaturedata = {}
local function istargetcanburn(target)
	return target:HasTag("canlight")
end
local equiptask
function EquipMaster:equipbystring(str, target) --target可能是nil
	if str == 'walk' and (string.find(ThePlayer.entity:GetDebugString(), 'channelcast_')
			or ThePlayer.replica.inventory:IsHeavyLifting()) then
		return
	end
	for k, v in pairs(BestEquiments) do
		if str == k then
			equipitem(BestEquiments[k].item, k)
			break
		elseif string.find(k, str) then
			if willow_fire_attack and target and k == 'fight_hands' and ThePlayer.prefab == 'willow' and not target:HasTag('fire')
				and istargetcanburn(target) and BestEquiments['firer'].item then --willow点火
				equipitem(BestEquiments['firer'].item, 'firer')
			else
				equipitem(BestEquiments[k].item, k)
			end
		end
	end
	if not MOD_util:GetMOption("equipmaster_closelight", closelight) and str == 'walk' and BestEquiments['auto_light'].item then --WORLD_util:IsDarkNight()
		if equiptask then equiptask:Cancel() end
		if checkplayerindark() then
			equipitem(BestEquiments['auto_light'].item, 'auto_light')
		end
		equiptask = ThePlayer and ThePlayer:DoTaskInTime(5 * FRAMES, function()
			if checkplayerindark() then
				equipitem(BestEquiments['auto_light'].item, 'auto_light')
			end
		end)
	end
end
local MOD_CTRL_LEFT = function(act)
	local set = INV_util:GetActiveItem()
	if set and set:HasTag("_equippable") then
		if haveknoweddata[set.prefab] then
			if not BestEquiments['fight_' .. haveknoweddata[set.prefab].equipslot] then return end
			local old = BestEquiments['fight_' .. haveknoweddata[set.prefab].equipslot].item
			if old and old.prefab == set.prefab then
				BestEquiments['fight_' .. haveknoweddata[set.prefab].equipslot] = {}
				ThePlayer.components.talker:Say('装备大师:' .. '战斗装备移除' .. set.name)
				return
			end
			BestEquiments['fight_' .. haveknoweddata[set.prefab].equipslot].item = set
			BestEquiments['fight_' .. haveknoweddata[set.prefab].equipslot].wasplayerset = true
			ThePlayer.components.talker:Say('装备大师:' .. '设置' .. set.name .. '为战斗装备')
		end
	else
		closefight = not closefight
		ThePlayer.components.talker:Say(not closefight and '开启切武器' or '关闭切武器')
		MOD_util:ChangeMOption("equipmaster_closefight", closefight)
	end
end
local MOD_CTRL_RIGHT = function(act)
	local set = INV_util:GetActiveItem()
	if set and set:HasTag("_equippable") then
		if haveknoweddata[set.prefab] then
			if not BestEquiments['walk_' .. haveknoweddata[set.prefab].equipslot] then return end
			local old = BestEquiments['walk_' .. haveknoweddata[set.prefab].equipslot].item
			if old and old.prefab == set.prefab then
				BestEquiments['walk_' .. haveknoweddata[set.prefab].equipslot] = {}
				ThePlayer.components.talker:Say('装备大师:' .. '行走装备移除' .. set.name)
				return
			end
			BestEquiments['walk_' .. haveknoweddata[set.prefab].equipslot].item = set
			BestEquiments['walk_' .. haveknoweddata[set.prefab].equipslot].wasplayerset = true
			ThePlayer.components.talker:Say('装备大师:' .. '设置' .. set.name .. '为行走装备')
		end
	else
		closewalk = not closewalk
		ThePlayer.components.talker:Say(not closewalk and '开启切行走' or '关闭切行走')
		MOD_util:ChangeMOption("equipmaster_closewalk", closewalk)
	end
end
local MOD_ALT_LEFT = function(act)
	local set = INV_util:GetActiveItem()
	if set then
		BestEquiments['auto_light'].item = set
		BestEquiments['auto_light'].dontlosewhenlost = true
		ThePlayer.components.talker:Say('装备大师:' .. '设置' .. set.name .. '为夜晚光源')
	else
		closelight = not closelight
		ThePlayer.components.talker:Say(not closelight and '开启切光源' or '关闭切光源')
		MOD_util:ChangeMOption("equipmaster_closelight", closelight)
	end
end
local MOD_ALT_RIGHT = function(act)
	local set = INV_util:GetActiveItem()
	if set then --你敢设置我就相信这是可以吃的
		BestEquiments['auto_eat'].item = set
		BestEquiments['auto_eat'].dontlosewhenlost = true
		ThePlayer.components.talker:Say('装备大师:' .. '设置' .. set.name .. '为吃饭食物')
	else
		closeeat = not closeeat
		ThePlayer.components.talker:Say(not closeeat and '开启自动吃饭' or '关闭自动吃饭')
		MOD_util:ChangeMOption("equipmaster_closeeat", closeeat)
	end
end
--GLOBAL.STRINGS.RMB
local function showtoggle()
	if TheInput:GetWorldEntityUnderMouse() == ThePlayer then
		if TheInput:IsControlPressed(CONTROL_FORCE_STACK) then
			return 1
		elseif TheInput:IsControlPressed(CONTROL_FORCE_INSPECT) then
			return 2
			--[[ elseif TheInput:IsControlPressed(CONTROL_FORCE_TRADE) then
            return 3 ]]
		end
	end
end
local actionselect = {
	[1] = { lmb = MOD_CTRL_LEFT, rmb = MOD_CTRL_RIGHT },
	[2] = { lmb = MOD_ALT_LEFT, rmb = MOD_ALT_RIGHT },
}
AddComponentPostInit("playercontroller", function(self, inst)
	if inst ~= ThePlayer then return end
	local OldOnControl = self.OnControl --这里是人物按的时候实现功能
	self.OnControl = function(self, control, down)
		local mod = showtoggle()
		if down and mod then
			if control == CONTROL_PRIMARY then
				actionselect[mod].lmb()
				--return
			elseif control == CONTROL_SECONDARY then
				actionselect[mod].rmb()
				--return
			end
		end
		return OldOnControl(self, control, down)
	end
	local closetask
	local oldUse = self.RemoteUseItemFromInvTile --这里是人物使用东西暂时关闭一秒装备自动切
	function self:RemoteUseItemFromInvTile(buffaction, item)
		if buffaction and buffaction.action and buffaction.action.id == 'EQUIP' and MOD_util:GetMOption("equipmaster_ppriority", true) then
			if haveknoweddata[item.prefab] and haveknoweddata[item.prefab].equipslot == 'hands' then
				if closetask then closetask:Cancel() end
				closeequip = true
				closetask = inst:DoTaskInTime(1, function()
					closeequip = false
				end)
			end
		end
		return oldUse(self, buffaction, item)
	end
	--行走
	local olddirecttwalk = self.RemoteDirectWalking
	function self:RemoteDirectWalking(x, z)
		if not closeequip and not MOD_util:GetMOption("equipmaster_closewalk", closewalk) and (self.remote_vector.x ~= x or self.remote_vector.z ~= z or self.remote_vector.y ~= 1) then
			local str = ThePlayer.entity:GetDebugString()
			if EQUIP_util:IsEquipped(BestEquiments['auto_light'].item) then
				if not str:find('run_loop') then
					EquipMaster:equipbystring('walk')
				end
			else
				EquipMaster:equipbystring('walk')
			end
		end
		return olddirecttwalk(self, x, z)
	end
	--开延迟行走
	local oldRemotePredictWalking = self.RemotePredictWalking
	function self:RemotePredictWalking(x, z, isstart)
		local y = self.directwalking and 3 or 4
		if self.remote_vector.x ~= x or self.remote_vector.z ~= z or (self.remote_vector.y ~= y and self.remote_vector.y ~= 0) then
			if not closeequip and not MOD_util:GetMOption("equipmaster_closewalk", closewalk) and isstart and self.directwalking then
				EquipMaster:equipbystring('walk')
			end
		end
		return oldRemotePredictWalking(self, x, z, isstart)
	end
	--攻击
	local oldget = self.GetAttackTarget
	function self:GetAttackTarget(force_attack, force_target, isretarget, use_remote_predict)
		local resulttarget = oldget(self, force_attack, force_target, isretarget, use_remote_predict)
		if not closeequip and not MOD_util:GetMOption("equipmaster_closefight", closefight) and resulttarget then
			if type(resulttarget) == "table" and dontneed[resulttarget.prefab] then
			else
				EquipMaster:equipbystring('fight', resulttarget)
			end
		end
		return resulttarget
	end
end)
--自动回旋镖
AddPrefabPostInit("inventory_classified", function(inst)
	--[[ if inst:HasTag("catchable") and doer:HasTag("cancatch") then
                table.insert(actions, ACTIONS.CATCH)
            end ]]
	local function catchBoomerang(doer, ppos, boomerang)
		if INV_util:GetActiveItem() then
			SendRPCToServer(RPC.ActionButton, ACTIONS.CATCH.code, boomerang)
		else
			SendRPCToServer(RPC.RightClick, ACTIONS.CATCH.code, ppos.x, ppos.z, doer)
		end
	end
	local function checkBoomerang()
		local boomerang = ENT_util:FindEntities(ThePlayer, nil,
			4, function(ent) return ent:HasTag("catchable") end)
		return boomerang
	end
	if MOD_util:GetMOption("equipmaster_catch", true) then
		inst:DoPeriodicTask(3 * FRAMES, function()
			if ThePlayer and ThePlayer:HasTag("cancatch") then
				local ppos = ThePlayer:GetPosition()
				do
					local boomerang = checkBoomerang()
					if boomerang then
						catchBoomerang(ThePlayer, ppos, boomerang)
					end
				end
				inst:DoTaskInTime(FRAMES, function()
					local boomerang = checkBoomerang()
					if boomerang then
						catchBoomerang(ThePlayer, ppos, boomerang)
					end
				end)
				inst:DoTaskInTime(2 * FRAMES, function()
					local boomerang = checkBoomerang()
					if boomerang then
						catchBoomerang(ThePlayer, ppos, boomerang)
					end
				end)
			end
		end)
	end
end)
--------------------模组设置界面-------------------
if MOD_util:CanAddSetting() then
	local pagename = "装备大师"
	local pageorder = 1
	local buttonname = pagename
	local pagetitle = pagename .. "设置"
	local enabledisableoption = { { text = "禁用", data = false }, { text = "启用", data = true } }
	local function MakeOption(key, describe, default, options)
		if default == nil then default = true end
		return {
			description = describe,
			key = key,
			default = default,
			options = options or enabledisableoption,
		}
	end
	MOD_util:CreatePage(pagename, {
		title = pagetitle,
		buttondata = { name = buttonname },
		order = pageorder,
		all_options = {
			MakeOption("equipmaster_closewalk", "切换行走道具", closewalk,
				{ { text = "开启", data = false }, { text = "关闭", data = true } }),
			MakeOption("equipmaster_closefight", "切换战斗道具", closefight,
				{ { text = "开启", data = false }, { text = "关闭", data = true } }),
			MakeOption("equipmaster_closeeat", "自动吃饭", closeeat,
				{ { text = "开启", data = false }, { text = "关闭", data = true } }),
			MakeOption("equipmaster_closelight", "自动切光源", closelight,
				{ { text = "开启", data = false }, { text = "关闭", data = true } }),
			MakeOption("equipmaster_ppriority", "玩家使用装备关闭一秒功能", true),
			MakeOption("equipmaster_hitrun", "是否走a模组联动", true),
			MakeOption("equipmaster_catch", "自动接回旋镖(开关需要重启)", true),
		}
	})
end
do --外部接口(供自动战斗 boss_dealer 等外部模组使用)
	--kind: "walk" / "fight"；当前是否会响应 EquipItem 事件去切换这一类装备
	function GLOBAL.EquipMaster_IsEnabled(kind)
		if closeequip or not MOD_util:GetMOption("equipmaster_hitrun", true) then
			return false
		end
		if kind == "walk" then
			return not MOD_util:GetMOption("equipmaster_closewalk", closewalk)
		elseif kind == "fight" then
			return not MOD_util:GetMOption("equipmaster_closefight", closefight)
		end
		return true
	end
	--当前记录的最佳装备(只读)，key 如 "walk_hands" / "fight_hands"
	function GLOBAL.EquipMaster_GetBest(key)
		local data = BestEquiments[key]
		return data ~= nil and data.item or nil
	end
end
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:inventory_classified
--自动回旋镖
AddPrefabPostInit("inventory_classified", function(inst)
	--[[ if inst:HasTag("catchable") and doer:HasTag("cancatch") then
                table.insert(actions, ACTIONS.CATCH)
            end ]]
	local function catchBoomerang(doer, ppos, boomerang)
		if INV_util:GetActiveItem() then
			SendRPCToServer(RPC.ActionButton, ACTIONS.CATCH.code, boomerang)
		else
			SendRPCToServer(RPC.RightClick, ACTIONS.CATCH.code, ppos.x, ppos.z, doer)
		end
	end
	local function checkBoomerang()
		local boomerang = ENT_util:FindEntities(ThePlayer, nil,
			4, function(ent) return ent:HasTag("catchable") end)
		return boomerang
	end
	if MOD_util:GetMOption("equipmaster_catch", true) then
		inst:DoPeriodicTask(3 * FRAMES, function()
			if ThePlayer and ThePlayer:HasTag("cancatch") then
				local ppos = ThePlayer:GetPosition()
				do
					local boomerang = checkBoomerang()
					if boomerang then
						catchBoomerang(ThePlayer, ppos, boomerang)
					end
				end
				inst:DoTaskInTime(FRAMES, function()
					local boomerang = checkBoomerang()
					if boomerang then
						catchBoomerang(ThePlayer, ppos, boomerang)
					end
				end)
				inst:DoTaskInTime(2 * FRAMES, function()
					local boomerang = checkBoomerang()
					if boomerang then
						catchBoomerang(ThePlayer, ppos, boomerang)
					end
				end)
			end
		end)
	end
end)

```

### 变体演进：Backpack Amulet Drop (Mod 2844520721)
- **变体场景与切面**：收录来自工坊 Mod 2844520721 (`Backpack Amulet Drop`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2844520721)
-- ============================================================================
local GLOBAL = GLOBAL
-- 切面钩子：AddPrefabPostInit:amulet
AddPrefabPostInit("amulet", newtag)
AddPrefabPostInit("backpack", onhauntfn)
AddPrefabPostInit("krampus_sack", onhauntfn)
AddPrefabPostInit("piggyback", onhauntfn)
AddPrefabPostInit("treasurechest", onhauntfn)
AddPrefabPostInit("dragonflychest", onhauntfn)
AddPrefabPostInit("hutch", onhauntfn)
AddPrefabPostInit("chester", onhauntfn)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:backpack
AddPrefabPostInit("amulet", newtag)
AddPrefabPostInit("backpack", onhauntfn)
AddPrefabPostInit("krampus_sack", onhauntfn)
AddPrefabPostInit("piggyback", onhauntfn)
AddPrefabPostInit("treasurechest", onhauntfn)
AddPrefabPostInit("dragonflychest", onhauntfn)
AddPrefabPostInit("hutch", onhauntfn)
AddPrefabPostInit("chester", onhauntfn)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:krampus_sack
AddPrefabPostInit("backpack", onhauntfn)
AddPrefabPostInit("krampus_sack", onhauntfn)
AddPrefabPostInit("piggyback", onhauntfn)
AddPrefabPostInit("treasurechest", onhauntfn)
AddPrefabPostInit("dragonflychest", onhauntfn)
AddPrefabPostInit("hutch", onhauntfn)
AddPrefabPostInit("chester", onhauntfn)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:piggyback
AddPrefabPostInit("krampus_sack", onhauntfn)
AddPrefabPostInit("piggyback", onhauntfn)
AddPrefabPostInit("treasurechest", onhauntfn)
AddPrefabPostInit("dragonflychest", onhauntfn)
AddPrefabPostInit("hutch", onhauntfn)
AddPrefabPostInit("chester", onhauntfn)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:treasurechest
AddPrefabPostInit("piggyback", onhauntfn)
AddPrefabPostInit("treasurechest", onhauntfn)
AddPrefabPostInit("dragonflychest", onhauntfn)
AddPrefabPostInit("hutch", onhauntfn)
AddPrefabPostInit("chester", onhauntfn)

```

### 变体演进：群鸟绘卷 · 春󰀜 (Mod 3161117403)
- **变体场景与切面**：收录来自工坊 Mod 3161117403 (`群鸟绘卷 · 春󰀜`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3161117403)
-- ============================================================================
local GLOBAL = GLOBAL
-- 切面钩子：AddPrefabPostInit:animal_track
AddPrefabPostInit("animal_track", function(inst)
    local next_thing
    inst:DoPeriodicTask(0.5, function()
        if not c_data.animal_track or not e_util:IsAnim("idle", inst) or not e_util:IsValid(inst) then
            return
        end
        local x, y, z = inst.entity:LocalToWorldSpace(0, 0, -40)
        next_thing = next_thing or e_util:FindEnt({
            x = x,
            y = y,
            z = z
        }, nil, 10, nil, nil, nil, nil, function(e)
            return e:HasOneOfTags({"dirtpile", "_health"})
        end)
        if e_util:IsValid(next_thing) then
            SpawnPrefab("harrow"):SetColor(save_data.color_track):GoTo(inst, next_thing)
        end
    end)
end)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:wagstaff_npc
end
AddPrefabPostInit("wagstaff_npc", function(inst)
    inst:DoTaskInTime(0.25, function(inst)
        needprefab = nil
        e_util:Hook_Say(inst, function(str_say)
            for i, prefab in ipairs(prefabs) do
                if str_say == STRINGS["WAGSTAFF_NPC_WANT_TOOL_" .. i] then
                    needprefab = prefab
                    break
                end
            end
            for i = 1, 2 do
                if str_say == STRINGS["WAGSTAFF_NPC_EXPERIMENT_DONE_" .. i] or str_say ==
                    STRINGS["WAGSTAFF_NPC_EXPERIMENT_FAIL_" .. i] then
                    done = true
                    break
                end
            end
            if needprefab then
                for i = 1, 2 do
                    if str_say == STRINGS.WAGSTAFF_NPC_YES_THIS_TOOL[i] then
                        needprefab = nil
                        break
                    end
                end
            end
        end)
    end)
end)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:smoke_plant
local data_warn = {"关闭", "全部", "仅自燃"}
AddPrefabPostInit("smoke_plant", function(inst)
    if save_data.sw == "关闭" then
        return
    end
    inst:DoTaskInTime(0.1, function(inst)
        local ent = e_util:FindEnt(inst, nil, 0.0001, nil, {'FX', 'DECOR', 'INLIMBO', 'NOCLICK', 'player'}, nil, nil,
            function(ent)
                return ent:HasTag("smolder")
            end)
        if not ent then
            return
        end
        if e_util:FindEnt(ent, "firesuppressor", TUNING.FIRE_DETECTOR_RANGE or 15, nil,
            {'FX', 'DECOR', 'INLIMBO', 'NOCLICK', 'player', 'fueldepleted'}, nil, {"idle_off"}) then
            return
        end
        local name = e_util:GetPrefabName(ent.prefab)
        if not (name and TheWorld and TheWorld.state) then
            return
        end
        local threshold = TUNING.WILDFIRE_THRESHOLD or 80
        local content = " 被引燃！"
        local iswild
        if TheWorld.state.issummer and TheWorld.state.isday and type(TheWorld.state.temperature) == "number" and
            TheWorld.state.temperature >= threshold then
            content = " 发生自燃！"
            iswild = true
        end
        if save_data.sw == "全部" or (save_data.sw == "仅自燃" and iswild) then
            u_util:Say(string_warning, name .. content, "self", "红色")
        end
    end)
end)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:oceanfish_medium_
for i = 1, 9 do
    AddPrefabPostInit("oceanfish_medium_" .. i, AddFishName)
    AddPrefabPostInit("oceanfish_small_" .. i, AddFishName)
end
local data_rgb = require("data/valuetable").RGB_datatable
local screen_data = {{
    id = "bilibili",
    prefab = "bilibili",
    type = "imgstr",
    label = "教程演示",
    hover = "点击查看视频教程或功能演示",
    fn = function()
        VisitURL("https://www.bilibili.com/video/BV16FUZBEE32/", true)
    end
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:oceanfish_small_
    AddPrefabPostInit("oceanfish_medium_" .. i, AddFishName)
    AddPrefabPostInit("oceanfish_small_" .. i, AddFishName)
end
local data_rgb = require("data/valuetable").RGB_datatable
local screen_data = {{
    id = "bilibili",
    prefab = "bilibili",
    type = "imgstr",
    label = "教程演示",
    hover = "点击查看视频教程或功能演示",
    fn = function()
        VisitURL("https://www.bilibili.com/video/BV16FUZBEE32/", true)
    end

```

### 变体演进：enable_sunkenchest (Mod 3749766414)
- **变体场景与切面**：收录来自工坊 Mod 3749766414 (`enable_sunkenchest`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3749766414)
-- ============================================================================
local GLOBAL = GLOBAL
-- 切面钩子：AddComponentPostInit:locomotor
AddComponentPostInit("locomotor", function(self)
    local old_PushAction = self.PushAction
    self.PushAction = function(self, bufferedaction, ...)
        GLOBAL.pcall(function()
            if bufferedaction ~= nil and bufferedaction.target ~= nil and bufferedaction.arrivedist == nil
                and TargetInOurOpenChest(self.inst, bufferedaction.target) then
                bufferedaction.arrivedist = ARRIVE_RANGE
                if bufferedaction.distance == nil or bufferedaction.distance < ARRIVE_RANGE then
                    bufferedaction.distance = ARRIVE_RANGE
                end
            end
        end)
        return old_PushAction(self, bufferedaction, ...)
    end
end)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:sunkenchest
AddPrefabPostInit("sunkenchest", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    if inst.components.workable ~= nil then
        inst.components.workable:SetOnFinishCallback(OnFinishOpen)
        -- Each hammer "hit" plays an anim that RESETS symbol visibility, so re-hide the
        -- chains right after — otherwise the unlocked chest flashes its chains every time
        -- you hammer it during the destroy phase.
        local base_onwork = inst.components.workable.onwork
        inst.components.workable:SetOnWorkCallback(function(inst, ...)
            if base_onwork ~= nil then
                base_onwork(inst, ...)
            end
            if inst.unlocked then
                HideChains(inst)
            end
        end)
    end
    -- When the unlocked chest is carried on the back, show OUR chain-less swap build.
    -- (AnimState symbol overrides on the owner network to clients.)
    if inst.components.equippable ~= nil then
        local base_onequip = inst.components.equippable.onequipfn
        inst.components.equippable.onequipfn = function(inst, owner)
            if base_onequip ~= nil then
                base_onequip(inst, owner)
            end
            if inst.unlocked and owner ~= nil and owner.AnimState ~= nil then
                owner.AnimState:OverrideSymbol("swap_body", UNLOCKED_SWAP_BUILD, "swap_body")
            end
        end
    end
    local base_onsave = inst.OnSave
    local base_onload = inst.OnLoad
    inst.OnSave = function(inst, data)
        if base_onsave ~= nil then
            base_onsave(inst, data)
        end
        if inst._sunkenchest_opened then
            data.sunkenchest_opened = true
        end
    end
    inst.OnLoad = function(inst, data)
        if base_onload ~= nil then
            base_onload(inst, data)
        end
        if data ~= nil and data.sunkenchest_opened then
            DoOpen(inst, true)
        end
    end
end)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:wardrobe
-- 3) Per-wardrobe setup.
AddPrefabPostInit("wardrobe", function(inst)
    -- Disable the vanilla right-click dress collector (gates on the "wardrobe" tag).
    -- Done on BOTH client and server: the client predicts actions from its local tags.
    inst:RemoveTag("wardrobe")
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    if inst.components.wardrobe ~= nil then
        inst.components.wardrobe:SetCanUseAction(false)
    end
    if inst.components.container == nil then
        inst:AddComponent("container")
    end
    inst.components.container:WidgetSetup("wardrobe")
    -- Suppress the generic HUD container open/close jingle so only the wardrobe's own
    -- door sound (played in onopenfn/onclosefn below) is heard.
    inst.components.container.skipopensnd = true
    inst.components.container.skipclosesnd = true
    inst.components.container.onopenfn = function(i)
        if not i:HasTag("burnt") then
            i.AnimState:PlayAnimation("open")
            i.SoundEmitter:PlaySound("dontstarve/common/wardrobe_open")
        end
    end
    inst.components.container.onclosefn = function(i)
        if not i:HasTag("burnt") then
            i.AnimState:PlayAnimation("closed")
            i.SoundEmitter:PlaySound("dontstarve/common/wardrobe_close")
        end
    end
    local function dropall()
        if inst.components.container ~= nil then
            inst.components.container:DropEverything()
        end
    end
    if inst.components.workable ~= nil then
        local base_finish = inst.components.workable.onfinish
        inst.components.workable:SetOnFinishCallback(function(i, worker)
            dropall()
            if base_finish ~= nil then
                base_finish(i, worker)
            end
        end)
    end
    inst:ListenForEvent("onignite", dropall)
end)

```

### 变体演进：Large Chest (HD) (Mod 2087177552)
- **变体场景与切面**：收录来自工坊 Mod 2087177552 (`Large Chest (HD)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2087177552)
-- ============================================================================
local GLOBAL = GLOBAL
-- 切面钩子：AddPrefabPostInit:reskin_tool
AddPrefabPostInit("reskin_tool", function(inst)
    if inst.components ~= nil and inst.components.spellcaster ~= nil then
        local original_CanCast = inst.components.spellcaster.can_cast_fn
        local original_Spell   = inst.components.spellcaster.spell
        local function PuffFX(tool, target, scale, offset)
            local fx_pos_x, fx_pos_y, fx_pos_z = target.Transform:GetWorldPosition()
            local fx = GLOBAL.SpawnPrefab("explode_reskin")
            fx.Transform:SetScale(scale, scale, scale)
            fx.Transform:SetPosition(fx_pos_x, fx_pos_y + (offset or 0), fx_pos_z)
        end
        local function CanCast(doer, target, pos, tool)
            if target == nil then
                return original_CanCast(doer, target, pos, tool)
            end
            if target.prefab == "largeicebox" then
                for _, name in ipairs(ICEBOX_SKINS) do
                    if GLOBAL.TheInventory:CheckClientOwnership(doer.userid, name) then
                        return true
                    end
                end
            end
            if target.prefab == "largesaltbox" then
                for _, name in ipairs(SALTBOX_SKINS) do
                    if GLOBAL.TheInventory:CheckClientOwnership(doer.userid, name) then
                        return true
                    end
                end
            end
            return original_CanCast(doer, target, pos, tool)
        end
        local function Spell(tool, target, pos, doer)
            if target == nil then
                return original_Spell(tool, target, pos, doer)
            end
            if target.prefab == "largeicebox" then
                local available_skins = {"icebox"}
                if tool._cached_reskinname["largeicebox"] == nil then
                    tool._cached_reskinname["largeicebox"] = available_skins[1]
                end
                local skin = tool._cached_reskinname["largeicebox"]
                for _, name in ipairs(ICEBOX_SKINS) do
                    if GLOBAL.TheInventory:CheckClientOwnership(tool.parent.userid, name) then
                        table.insert(available_skins, name)
                    end
                end
                local index = 1
                for i, name in ipairs(available_skins) do
                    if name == target._skin then
                        index = i
                        break
                    end
                end
                skin = available_skins[index + 1]
                if skin == nil then
                    skin = available_skins[1]
                end
                tool._cached_reskinname["largeicebox"] = skin
                target:SetSkin(skin)
                PuffFX(tool, target, 1.5, 1)
            elseif target.prefab == "largesaltbox" then
                local available_skins = {"saltbox"}
                if tool._cached_reskinname["largesaltbox"] == nil then
                    tool._cached_reskinname["largesaltbox"] = available_skins[1]
                end
                local skin = tool._cached_reskinname["largesaltbox"]
                for _, name in ipairs(SALTBOX_SKINS) do
                    if GLOBAL.TheInventory:CheckClientOwnership(tool.parent.userid, name) then
                        table.insert(available_skins, name)
                    end
                end
                local index = 1
                for i, name in ipairs(available_skins) do
                    if name == target._skin then
                        index = i
                        break
                    end
                end
                skin = available_skins[index + 1]
                if skin == nil then
                    skin = available_skins[1]
                end
                tool._cached_reskinname["largesaltbox"] = skin
                target:SetSkin(skin)
                PuffFX(tool, target, 1.5, 1)
            else
                original_Spell(tool, target, pos, doer)
            end
        end
        inst.components.spellcaster:SetSpellFn(Spell)
        inst.components.spellcaster:SetCanCastFn(CanCast)
    end
end)

```


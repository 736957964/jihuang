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

### 变体演进：lan (Mod 3052540872)
- **变体场景与切面**：收录来自工坊 Mod 3052540872 (lan) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3052540872)
-- ============================================================================
local GLOBAL = GLOBAL


 AddPrefabPostInit("skyshow",function(inst)
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(SKYSHOW.DAMAGE)
    inst.components.weapon:SetRange(SKYSHOW.RANGE,SKYSHOW.RANGE)
	if TUNING.XGDUSE > 0 then 
		inst:AddComponent("finiteuses")
		inst.components.finiteuses:SetMaxUses(TUNING.XGDUSE)
		inst.components.finiteuses:SetUses(TUNING.XGDUSE)  
		inst.components.finiteuses:SetOnFinished(inst.Remove)
		inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
		inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 1)	
		inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 1)
		inst.components.finiteuses:SetConsumption(ACTIONS.DIG, 1)
		inst.components.finiteuses:SetConsumption(ACTIONS.NET, 1)
	end
	inst:AddComponent("tool")
	if SKYSHOW.AXE ~= 0 then inst.components.tool:SetAction(ACTIONS.CHOP, SKYSHOW.AXE) end
	if SKYSHOW.DRAFT ~= 0 then inst.components.tool:SetAction(ACTIONS.MINE, SKYSHOW.DRAFT) end
	if SKYSHOW.DIG == 1 then inst.components.tool:SetAction(ACTIONS.DIG) end
	if SKYSHOW.NET == 1 then inst.components.tool:SetAction(ACTIONS.NET) end
	if SKYSHOW.HAMMER ~= 0 then inst.components.tool:SetAction(ACTIONS.HAMMER, SKYSHOW.HAMMER) end
	
    if inst.components.equippable then inst.components.equippable.walkspeedmult = SKYSHOW.WALKSPEED end
	if SKYSHOW.MAGIC == 1 then     --催眠
		local function HearPanFlute(inst, target, pos)
			local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 30)
			if TUNING.XGDUSE > 0 then inst.components.finiteuses:Use(10) end
			for k,v in pairs(ents) do
				if v.components.sleeper~= nil and not v:HasTag("player")  then
					v.components.sleeper:AddSleepiness(10, TUNING.PANFLUTE_SLEEPTIME)
				end
				if v.components.grogginess~= nil and not v:HasTag("player")  then
					v.components.grogginess:AddGrogginess(10, TUNING.PANFLUTE_SLEEPTIME)
				end    
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(HearPanFlute)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 2 then     --瞬移
		local function onblink(staff, pos, caster)
			if caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster then
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("flash!!")
				else
					caster.components.talker:Say("闪现！！")
				end
			end
		end
		inst:AddComponent("blinkstaff")
		inst.components.blinkstaff.onblinkfn = onblink
	elseif SKYSHOW.MAGIC == 3 then   --矮星
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("stafflight")
			light.Transform:SetPosition(pos:Get())
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			--local caster = staff.components.inventoryitem.owner
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Nice！This fruit knife works too well！")
				else
					caster.components.talker:Say("nice！这西瓜刀也太好使了！")
				end
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 4 then   --极光
		local function createlight(staff, target, pos)
				local light = SpawnPrefab("staffcoldlight")
				light.Transform:SetPosition(pos:Get())
				if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
				local caster = staff.components.inventoryitem.owner
				if caster ~= nil and caster.components.sanity ~= nil then
					caster.components.sanity:DoDelta(-5)
				end
				if caster then 
					if SKYSHOW.LAN == 1 then
						caster.components.talker:Say("Nice！This fruit knife works too well！")
					else
						caster.components.talker:Say("nice！这西瓜刀也太好使了！")
					end
				end
			end
			inst:AddComponent("spellcaster")
			inst.components.spellcaster:SetSpellFn(createlight)
			inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 5 then    --寒冰坑
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("deer_ice_circle")
			light.Transform:SetPosition(pos:Get())
			light:DoTaskInTime(0, light.TriggerFX)
			light:DoTaskInTime(5, light.KillFX)
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("So cold! T^T ")
				else
					caster.components.talker:Say("好冷啊！呜呜呜呜呜！")
				end
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true	
	elseif SKYSHOW.MAGIC == 6 then    --火焰坑
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("deer_fire_circle")
			light.Transform:SetPosition(pos:Get())
			light:DoTaskInTime(0, light.TriggerFX)
			light:DoTaskInTime(5, light.KillFX)
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("So hot! T^T ")
				else
					caster.components.talker:Say("好热啊！呜呜呜呜呜！")
				end
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 7 then     --旋风
		local function createlight(staff, target, pos)
			local x, y, z = pos:Get()
			local lighta = SpawnPrefab("tornado")
			lighta.Transform:SetPosition(x+1, y, z)
			local lightb = SpawnPrefab("tornado")
			lightb.Transform:SetPosition(x-1, y, z)
			local lighte = SpawnPrefab("tornado")
			lighte.Transform:SetPosition(x, y, z+1)
			local lightf = SpawnPrefab("tornado")
			lightf.Transform:SetPosition(x, y, z-1)
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Hasagay！！！")
				else
					caster.components.talker:Say("哈撒给！！！")
				end
			end
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true		
	elseif SKYSHOW.MAGIC == 8 then    --眼球塔
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("eyeturret")
			light.Transform:SetPosition(pos:Get())
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Its eye is bigger than my head? !")
				else
					caster.components.talker:Say("眼睛比我头都大？！")
				end 
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 9 then   --古代科技塔
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("ancient_altar")
			light.Transform:SetPosition(pos:Get())
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("What's this stuff? What if I want to smash it? Will I die?")
				else
					caster.components.talker:Say("这啥玩意啊？想把它砸了咋办？会死吗？")
				end
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 10 then   --铥矿
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("thulecite")
			light.Transform:SetPosition(pos:Get())
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("This? ...Then why am I going to cave exploration? Hahaha")
				else
					caster.components.talker:Say("这？...那我还去洞穴探险干啥呢？嘿嘿")
				end
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true	
	elseif SKYSHOW.MAGIC == 11 then   --流星
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("shadowmeteor")
			light.Transform:SetPosition(pos:Get())
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Wow! meteor!")
				else
					caster.components.talker:Say("哇！流星！")
				end			
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 12 then   --孢子云
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("sporecloud")
			light.Transform:SetPosition(pos:Get())
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("I must not bring food in！！")
				else
					caster.components.talker:Say("我可不能带着食物进去鸭~")
				end	
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 13 then   --沙刺
		local function createlight(staff, target, pos)
			local x, y, z = pos:Get()
			local lighta = SpawnPrefab("sandspike_tall")
			lighta.Transform:SetPosition(x+1, y, z)
			local lightb = SpawnPrefab("sandspike_tall")
			lightb.Transform:SetPosition(x-1, y, z)
			local lighte = SpawnPrefab("sandspike_tall")
			lighte.Transform:SetPosition(x, y, z+1)
			local lightf = SpawnPrefab("sandspike_tall")
			lightf.Transform:SetPosition(x, y, z-1)
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Shurima! Your emperor has returned!")
				else
					caster.components.talker:Say("我！就是沙漠皇帝阿兹尔~")
				end	
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 14 then   --爆炸蘑菇
		local function createlight(staff, target, pos)
			local x, y, z = pos:Get()
			local lighta = SpawnPrefab("mushroombomb")
			lighta.Transform:SetPosition(x+1.73, y, z-1)
			local lightb = SpawnPrefab("mushroombomb")
			lightb.Transform:SetPosition(x-1.72, y, z-1)
			local lightc = SpawnPrefab("mushroombomb")
			lightc.Transform:SetPosition(x, y, z+2)
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Captain Teemo on duty!")
				else
					caster.components.talker:Say("三个蘑菇一条命！")
				end	 
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 15 then   --爆炸蘑菇plus
		local function createlight(staff, target, pos)
			local x, y, z = pos:Get()
			local lighta = SpawnPrefab("mushroombomb_dark")
			lighta.Transform:SetPosition(x+1.73, y, z-1)
			local lightb = SpawnPrefab("mushroombomb_dark")
			lightb.Transform:SetPosition(x-1.72, y, z-1)
			local lightc = SpawnPrefab("mushroombomb_dark")
			lightc.Transform:SetPosition(x, y, z+2)
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Captain Teemo on duty!")
				else
					caster.components.talker:Say("三个蘑菇一条命！")
				end	 
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 16 then   --催眠云
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("sleepcloud")
			light.Transform:SetPosition(pos:Get())
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Sleep, sleep, my bb~")
				else
					caster.components.talker:Say("睡吧睡吧，弟弟们~")
				end	 
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 17 then   --小光源
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("yellowamuletlight")
			light.Transform:SetPosition(pos:Get())
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Light of hope！")
				else
					caster.components.talker:Say("希望之光~")
				end	 
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 18 then   --天体灵球
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("moonrockseed")
			light.Transform:SetPosition(pos:Get())
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Cute little snowball?")
				else
					caster.components.talker:Say("可爱的小雪球？")
				end	 
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 19 then   --月亮祭坛
		local function createlight(staff, target, pos)
			local x, y, z = pos:Get()
			local light = SpawnPrefab("moon_altar")
			light.Transform:SetPosition(x,y,z)
			local lighta = SpawnPrefab("moon_altar_idol")
			lighta.Transform:SetPosition(x+1,y,z)
			local lightb = SpawnPrefab("moon_altar_seed")
			lightb.Transform:SetPosition(x-1,y,z)
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("You have to assemble it yourself, the mod author is so stupid")
				else
					caster.components.talker:Say("还得自己组装，这mod作者不行啊")
				end	 
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 20 then   --风滚草
		local function createlight(staff, target, pos)
			local light = SpawnPrefab("tumbleweedspawner")
			light.Transform:SetPosition(pos:Get())
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("What the f**k! So many tumbleweeds. which one shall I chase first?")
				else
					caster.components.talker:Say("wrng！这么多我先追哪个？")
				end	 
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 21 then   --触手
		local function createlight(staff, target, pos)
			local x, y, z = pos:Get()
			local lighta = SpawnPrefab("tentacle")
			lighta.Transform:SetPosition(x+1, y, z)
			local lightb = SpawnPrefab("tentacle")
			lightb.Transform:SetPosition(x-1, y, z)
			local lightc = SpawnPrefab("tentacle")
			lightc.Transform:SetPosition(x, y, z+1)
			local lightd = SpawnPrefab("tentacle")
			lightd.Transform:SetPosition(x, y, z-1)
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			local caster = staff.components.inventoryitem.owner
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("An upgraded version of the Tentacle Book?")
				else
					caster.components.talker:Say("指哪放哪的触手书plus？！我要去打蜂后！")
				end	 
			end
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 22 then   --鸟
		local function createlight(staff, target, pos)
			local TheWorld = GLOBAL.TheWorld  
			local Sleep = GLOBAL.Sleep
			local birdspawner = TheWorld.components.birdspawner
            if birdspawner == nil then
                return false
            end
			local caster = staff.components.inventoryitem.owner
			local pt = caster:GetPosition()
			local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 10, nil, nil, { "magicalbird" })
            if #ents > 30 then
				if caster then 
					if SKYSHOW.LAN == 1 then
						caster.components.talker:Say("There are too many f**king birds. I should stop doing it.")
					else
						caster.components.talker:Say("这鸟也太几把多了！！别搞了吧！")
					end	 
				end
            else
                local num = math.random(10, 20)
                if #ents > 20 then
					if caster then 
						if SKYSHOW.LAN == 1 then
							caster.components.talker:Say("These birds are too fucking too many!！And they are all asleep？！W T F？")
						else
							caster.components.talker:Say("哇！这鸟贼几把多！还都睡着了？！这mod作者搞事情啊？")
						end	 
					end
                else
                    num = num + 10
                end
                caster:StartThread(function()
                    for k = 1, num do
                        local pos = birdspawner:GetSpawnPoint(pt)
                        if pos ~= nil then
                            local bird = birdspawner:SpawnBird(pos, true)
                            if bird ~= nil then
                               bird:AddTag("magicalbird")
                            end
                        end
                        Sleep(math.random(.2, .25))
                    end
                end)
            end
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
			end
			
			local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 30)
			for k,v in pairs(ents) do
				if v.components.sleeper~= nil and not v:HasTag("player")  then
					v.components.sleeper:AddSleepiness(10, TUNING.PANFLUTE_SLEEPTIME)
				end
				if v.components.grogginess~= nil and not v:HasTag("player")  then
					v.components.grogginess:AddGrogginess(10, TUNING.PANFLUTE_SLEEPTIME)
				end    
			end
			
			return true
		end
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(createlight)
		inst.components.spellcaster.canuseonpoint = true
	elseif SKYSHOW.MAGIC == 23 then   --催熟
		local function createlight(staff, target, pos)
		
			local function trygrowth(inst)
				if inst:IsInLimbo()
					or (inst.components.witherable ~= nil and
						inst.components.witherable:IsWithered()) then
					return
				end

				if inst.components.pickable ~= nil then
					if inst.components.pickable:CanBePicked() and inst.components.pickable.caninteractwith then
						return
					end
					inst.components.pickable:FinishGrowing()
				end

				if inst.components.crop ~= nil and (inst.components.crop.rate or 0) > 0 then
					inst.components.crop:DoGrow(1 / inst.components.crop.rate, true)
				end

				if inst.components.growable ~= nil then
					-- If we're a tree and not a stump, or we've explicitly allowed magic growth, do the growth.
					if ((inst:HasTag("tree") or inst:HasTag("winter_tree")) and not inst:HasTag("stump")) or
							inst.components.growable.magicgrowable then
						inst.components.growable:DoGrowth()
					end
				end

				if inst.components.harvestable ~= nil and inst.components.harvestable:CanBeHarvested() and inst:HasTag("mushroom_farm") then
					inst.components.harvestable:Grow()
				end
			end

			local caster = staff.components.inventoryitem.owner
			if caster then 
				if SKYSHOW.LAN == 1 then
					caster.components.talker:Say("Damn it? This is the gardening book of Wickerbottom? !")
				else
					caster.components.talker:Say("卧槽？这可是老奶奶的园艺书？！")
				end	 
			end
			local x, y, z = caster.Transform:GetWorldPosition()
            local range = 30
            local ents = TheSim:FindEntities(x, y, z, range, nil, { "pickable", "stump", "withered", "INLIMBO" })
            if #ents > 0 then
                trygrowth(table.remove(ents, math.random(#ents)))
                if #ents > 0 then
                    local timevar = 1 - 1 / (#ents + 1)
                    for i, v in ipairs(ents) do
                        v:DoTaskInTime(timevar * math.random(), trygrowth)
                    end
                end
            end
			if TUNING.XGDUSE > 0 then staff.components.finiteuses:Use(10) end
			
			if caster ~= nil and caster.components.sanity ~= nil then
				caster.components.sanity:DoDelta(-5)
`


### 变体演进：明日方舟唱片 (Mod 3379258656)
- **变体场景与切面**：收录来自工坊 Mod 3379258656 (明日方舟唱片) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3379258656)
-- ============================================================================
local GLOBAL = GLOBAL


AddPrefabPostInit("phonograph", function(inst)
    if not TheWorld.ismastersim then return inst end

    inst.TurnOffMachine = function() end --为什么科雷设计成播放64秒就停止了？

    if PHONOGRAPH_CARRY_PLAY then
        local Oldonputininventoryfn = inst.components.inventoryitem.onputininventoryfn
        inst.components.inventoryitem.onputininventoryfn = function(inst, owner, ...)
            local song = inst:GetRecordSong()
            if song
                and inst.components.machine and inst.components.machine:IsOn()
                and owner and owner.SoundEmitter
            then
                ClearPlayerTag(owner)

                owner._neon_phonograph = inst
                owner.SoundEmitter:PlaySound(song, "neon_ragtime")
                owner:ListenForEvent("itemlose", OnLosePhonograph)
            end

            return Oldonputininventoryfn and Oldonputininventoryfn(inst, owner, ...)
        end

        inst:ListenForEvent("onremove", onremove)
    end
end)
`


### 变体演进：改变玩家出生位置 (Mod 3518921307)
- **变体场景与切面**：收录来自工坊 Mod 3518921307 (改变玩家出生位置) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3518921307)
-- ============================================================================
local GLOBAL = GLOBAL


AddPrefabPostInit("multiplayer_portal_moonrock_constr",kepohuai)	
AddPrefabPostInit("multiplayer_portal_moonrock",kepohuai)	
AddPrefabPostInit("multiplayer_portal",kepohuai)	


AddPrefabPostInit("spawnpoint_master",CanDigInit)
`


### 变体演进：kramel的华语经典唱片 (Mod 3586130971)
- **变体场景与切面**：收录来自工坊 Mod 3586130971 (kramel的华语经典唱片) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3586130971)
-- ============================================================================
local GLOBAL = GLOBAL


AddPrefabPostInit("phonograph", function(inst)
    if not TheWorld.ismastersim then return inst end

    inst.TurnOffMachine = function() end --为什么科雷设计成播放64秒就停止了？

    if PHONOGRAPH_CARRY_PLAY then
        local Oldonputininventoryfn = inst.components.inventoryitem.onputininventoryfn
        inst.components.inventoryitem.onputininventoryfn = function(inst, owner, ...)
            local song = inst:GetRecordSong()
            if song
                and inst.components.machine and inst.components.machine:IsOn()
                and owner and owner.SoundEmitter
            then
                ClearPlayerTag(owner)

                owner._neon_phonograph = inst
                owner.SoundEmitter:PlaySound(song, "neon_ragtime")
                owner:ListenForEvent("itemlose", OnLosePhonograph)
            end

            return Oldonputininventoryfn and Oldonputininventoryfn(inst, owner, ...)
        end

        inst:ListenForEvent("onremove", onremove)
    end
end)
`


### 变体演进：自定义沃拓克斯 / Customize Wortox (Mod 3627955500)
- **变体场景与切面**：收录来自工坊 Mod 3627955500 (自定义沃拓克斯 / Customize Wortox) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3627955500)
-- ============================================================================
local GLOBAL = GLOBAL

    if start_souls ~= nil then
        api.AddPrefabPostInit("wortox", function(inst)
            if not G.TheWorld.ismastersim or inst.starting_inventory == nil then
                return
            end
            -- Prefab starting lists are shared, so never edit them in place.
            local items = {}
            for _, item in G.ipairs(inst.starting_inventory) do
                if item ~= "wortox_soul" then
                    items[#items + 1] = item
                end
            end
            for _ = 1, start_souls do
                items[#items + 1] = "wortox_soul"
            end
            inst.starting_inventory = items
        end)
`


### 变体演进：HOWLS唱片 (Mod 3716634921)
- **变体场景与切面**：收录来自工坊 Mod 3716634921 (HOWLS唱片) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3716634921)
-- ============================================================================
local GLOBAL = GLOBAL


AddPrefabPostInit("phonograph", function(inst)
    if not TheWorld.ismastersim then return inst end

    inst.TurnOffMachine = function() end --为什么科雷设计成播放64秒就停止了？

    if PHONOGRAPH_CARRY_PLAY then
        local Oldonputininventoryfn = inst.components.inventoryitem.onputininventoryfn
        inst.components.inventoryitem.onputininventoryfn = function(inst, owner, ...)
            local song = inst:GetRecordSong()
            if song
                and inst.components.machine and inst.components.machine:IsOn()
                and owner and owner.SoundEmitter
            then
                ClearPlayerTag(owner)

                owner._neon_phonograph = inst
                owner.SoundEmitter:PlaySound(song, "neon_ragtime")
                owner:ListenForEvent("itemlose", OnLosePhonograph)
            end

            return Oldonputininventoryfn and Oldonputininventoryfn(inst, owner, ...)
        end

        inst:ListenForEvent("onremove", onremove)
    end
end)
`


### 变体演进：大霜鲨更多交易次数 (Mod 3771598087)
- **变体场景与切面**：收录来自工坊 Mod 3771598087 (大霜鲨更多交易次数) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3771598087)
-- ============================================================================
local GLOBAL = GLOBAL

-- ==================== 大霜鲨预处理 ====================
AddPrefabPostInit("sharkboi", function(inst)
    -- 只在主机端执行（避免客户端干扰）
    if not TheWorld.ismastersim then
        return
    end

    -- 1. 覆写 MakeTrader：每次进入交易状态时按配置初始化次数
    local old_maketrader = inst.MakeTrader
    inst.MakeTrader = function(inst2, ...)
        if old_maketrader ~= nil then
            old_maketrader(inst2, ...)
        end
        SetStockForTrader(inst2, GetTargetTrades())
    end

    -- 2. 覆写 OnSave：保存当前剩余交易次数
    local old_onsave = inst.OnSave
    inst.OnSave = function(inst2, data)
        if old_onsave ~= nil then
            old_onsave(inst2, data)
        end
        if inst2.components ~= nil and inst2.components.trader ~= nil and inst2.stock ~= nil then
            data[SAVE_KEY] = inst2.stock
        end
    end

    -- 3. 覆写 OnLoad：读档时优先恢复剩余次数，没有则按配置初始化
    local old_onload = inst.OnLoad
    inst.OnLoad = function(inst2, data)
        if old_onload ~= nil then
            old_onload(inst2, data)
        end

        if inst2.components ~= nil and inst2.components.trader ~= nil then
            local saved_stock = data ~= nil and data[SAVE_KEY] or nil
            if saved_stock ~= nil and type(saved_stock) == "number" then
                -- 有存档值：恢复剩余次数
                SetStockForTrader(inst2, saved_stock)
            else
                -- 无存档值（首次生成）：按配置初始化
                SetStockForTrader(inst2, GetTargetTrades())
            end
        end
    end
end)
`


### 变体演进：Mod 3808236333 (Mod 3808236333)
- **变体场景与切面**：收录来自工坊 Mod 3808236333 (Mod 3808236333) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3808236333)
-- ============================================================================
local GLOBAL = GLOBAL

-- ========== 女王火炬初始化 ==========
AddPrefabPostInit("queen_torch", function(inst)
    if not GLOBAL.TheWorld.ismastersim then return end

    -- 初始化层数
    inst._gestalt_count = 0

    -- 引导组件
    if inst.components.channelcastable == nil then
        inst:AddComponent("channelcastable")
        inst.components.channelcastable:SetStrafing(false)
        inst.components.channelcastable:SetOnStartChannelingFn(OnStartChanneling)
        inst.components.channelcastable:SetOnStopChannelingFn(OnStopChanneling)
    end

    -- 武器攻击回调
`


### 变体演进：智能矿工帽 Smart Miner Hat (Mod 3813163216)
- **变体场景与切面**：收录来自工坊 Mod 3813163216 (智能矿工帽 Smart Miner Hat) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3813163216)
-- ============================================================================
local GLOBAL = GLOBAL


AddPrefabPostInit("minerhat", function(inst)
    -- 只在服务端（主机 / 服务器）跑；客户端不插手
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

    local equippable = inst.components.equippable
    local fueled     = inst.components.fueled
    local invitem    = inst.components.inventoryitem

    if equippable == nil or fueled == nil or invitem == nil then
        return
    end

    ------------------------------------------------------------------
`


### 变体演进：Geometric Drop (fixed) (Mod 3813858106)
- **变体场景与切面**：收录来自工坊 Mod 3813858106 (Geometric Drop (fixed)) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3813858106)
-- ============================================================================
local GLOBAL = GLOBAL


AddComponentPostInit("playercontroller", function(self)
    ThePlayer = GLOBAL.ThePlayer
    TheWorld = GLOBAL.TheWorld
    InitializePlacers()

    local PlayerControllerGetLeftMouseAction = self.GetLeftMouseAction
    local active_item, force_inspecting, mouse_target
    local drop_action = BufferedAction(ThePlayer, nil, ACTIONS.DROP)
    self.GetLeftMouseAction = function(self)
        local act = PlayerControllerGetLeftMouseAction(self)
        if force_inspecting then return act end
        if not act and active_item and mouse_target then
            act = drop_action
        end
        self.LMBaction = act
`



### 变体演进：自动化打工仔 (Mod 2896736404)
- **变体场景与切面**：收录来自工坊 Mod 2896736404 (`自动化打工仔`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2896736404)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:seeds

-- AddPrefabPostInit("seeds", function(inst)
--     if inst.components.deployable then
--         inst.components.deployable.restrictedtag = "plantqueen"
--     end
-- end)

```



### 变体演进：便携雕塑 (Mod 2795222906)
- **变体场景与切面**：收录来自工坊 Mod 2795222906 (`便携雕塑`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2795222906)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:crabking
local function xietianfn(inst) if inst.prefab == "malbatross" then if not inst.MiniMapEntity then inst.entity:AddMiniMapEntity() end inst.MiniMapEntity:SetIcon(tubiao_xietianweng1..".png") end tubiao_diaosufn(inst) if inst.prefab == "malbatross" then inst.components.maprevealer.revealperiod = 1 end end
if tubiao_diwangxie then AddPrefabPostInit("crabking",tubiao_diaosufn) end
if tubiao_shuizhongmu then AddPrefabPostInit("watertree_pillar",tubiao_diaosufn) end
if tubiao_yuangukeji then AddPrefabPostInit("ancient_altar",tubiao_diaosufn) end
if tubiao_chanchu then AddPrefabPostInit("toadstool_cap",tubiao_diaosufn) end
if tubiao_yuangudamen then AddPrefabPostInit("atrium_gate",tubiao_diaosufn) end
if tubiao_dalishi then AddPrefabPostInit("sculpture_rookbody",tubiao_diaosufn) end
if tubiao_xietianweng == 1 then AddPrefabPostInit("malbatross",xietianfn) elseif tubiao_xietianweng == 2 then for _,v in pairs(xietianweng_ming) do AddPrefabPostInit(v,xietianfn) end end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:watertree_pillar
if tubiao_diwangxie then AddPrefabPostInit("crabking",tubiao_diaosufn) end
if tubiao_shuizhongmu then AddPrefabPostInit("watertree_pillar",tubiao_diaosufn) end
if tubiao_yuangukeji then AddPrefabPostInit("ancient_altar",tubiao_diaosufn) end
if tubiao_chanchu then AddPrefabPostInit("toadstool_cap",tubiao_diaosufn) end
if tubiao_yuangudamen then AddPrefabPostInit("atrium_gate",tubiao_diaosufn) end
if tubiao_dalishi then AddPrefabPostInit("sculpture_rookbody",tubiao_diaosufn) end
if tubiao_xietianweng == 1 then AddPrefabPostInit("malbatross",xietianfn) elseif tubiao_xietianweng == 2 then for _,v in pairs(xietianweng_ming) do AddPrefabPostInit(v,xietianfn) end end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:ancient_altar
if tubiao_shuizhongmu then AddPrefabPostInit("watertree_pillar",tubiao_diaosufn) end
if tubiao_yuangukeji then AddPrefabPostInit("ancient_altar",tubiao_diaosufn) end
if tubiao_chanchu then AddPrefabPostInit("toadstool_cap",tubiao_diaosufn) end
if tubiao_yuangudamen then AddPrefabPostInit("atrium_gate",tubiao_diaosufn) end
if tubiao_dalishi then AddPrefabPostInit("sculpture_rookbody",tubiao_diaosufn) end
if tubiao_xietianweng == 1 then AddPrefabPostInit("malbatross",xietianfn) elseif tubiao_xietianweng == 2 then for _,v in pairs(xietianweng_ming) do AddPrefabPostInit(v,xietianfn) end end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:toadstool_cap
if tubiao_yuangukeji then AddPrefabPostInit("ancient_altar",tubiao_diaosufn) end
if tubiao_chanchu then AddPrefabPostInit("toadstool_cap",tubiao_diaosufn) end
if tubiao_yuangudamen then AddPrefabPostInit("atrium_gate",tubiao_diaosufn) end
if tubiao_dalishi then AddPrefabPostInit("sculpture_rookbody",tubiao_diaosufn) end
if tubiao_xietianweng == 1 then AddPrefabPostInit("malbatross",xietianfn) elseif tubiao_xietianweng == 2 then for _,v in pairs(xietianweng_ming) do AddPrefabPostInit(v,xietianfn) end end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:atrium_gate
if tubiao_chanchu then AddPrefabPostInit("toadstool_cap",tubiao_diaosufn) end
if tubiao_yuangudamen then AddPrefabPostInit("atrium_gate",tubiao_diaosufn) end
if tubiao_dalishi then AddPrefabPostInit("sculpture_rookbody",tubiao_diaosufn) end
if tubiao_xietianweng == 1 then AddPrefabPostInit("malbatross",xietianfn) elseif tubiao_xietianweng == 2 then for _,v in pairs(xietianweng_ming) do AddPrefabPostInit(v,xietianfn) end end

```



### 变体演进：mining_work (Mod 3821325695)
- **变体场景与切面**：收录来自工坊 Mod 3821325695 (`mining_work`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3821325695)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:workmultiplier

AddComponentPostInit("workmultiplier", Compatibility.WorkMultiplier)
for _, prefab in G.ipairs({ "smallminer_certificate", "mediumminer_certificate" }) do
    AddPrefabPostInit(prefab, Compatibility.MinerMedal)
end

```



### 变体演进：Jimbo Custom Rewards (Mod 3817088423)
- **变体场景与切面**：收录来自工坊 Mod 3817088423 (`Jimbo Custom Rewards`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3817088423)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:balatro_machine

AddPrefabPostInit("balatro_machine", function(inst)
    if patched then return end
    inst:DoTaskInTime(0, function()
        if patched then return end

        local handle = inst.ondoerremoved
        if not handle then return end

        local rewards = FindUpvalue(handle, "REWARDS")
        if rewards then
            patched = true
            ApplyOverrides(rewards)

            local srs, holder, idx = FindUpvalue(handle, "StartRewardsSequence")
            if srs and holder and idx then
                local original = srs
                debug.setupvalue(holder, idx, function(inst, doer, score)
                    if doer then
                        local now = GLOBAL.GetTime()
                        local last = doer._jimbo_last_win or 0
                        local streak = doer._jimbo_streak or 0

                        local is_win = score ~= nil and score >= 2 and score ~= 9

                        if not is_win then
                            if streak > 0 and doer.components.talker then
                                doer.components.talker:Say("My streäk... bröken! Nööö!..")
                            end
                            doer._jimbo_streak = 0
                        else
                            if (now - last) <= 90 then
                                streak = streak + 1
                            else
                                if streak > 0 and doer.components.talker then
                                    doer.components.talker:Say("Too slöw... My hard eärned streäks.. Gone für nöthing!")
                                end
                                streak = 1
                            end

                            doer._jimbo_streak = streak
                            doer._jimbo_last_win = now

                            if doer.components.talker then
                                doer.components.talker:Say("Win streäk: " .. streak)
                            end

                            if streak >= 3 then
                                AwardGift(doer)
                                doer._jimbo_streak = 0
                            end
                        end
                    end
                    return original(inst, doer, score)
                end)
            end
        end
    end)
end)

```



### 变体演进：Wardrobe Storage and Repair (Mod 3823804651)
- **变体场景与切面**：收录来自工坊 Mod 3823804651 (`Wardrobe Storage and Repair`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3823804651)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:wardrobe

AddPrefabPostInit("wardrobe", function(inst)
    inst:AddTag("wardrobe_restorer")

    if not GLOBAL.TheWorld.ismastersim then
        return
    end

    -- Drop the built-in wardrobe scene collector so CHANGEIN is only offered
    -- by our container collector above.
    inst:UnregisterComponentActions("wardrobe")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("wardrobe_restorer")

    local rate = GetModConfigData("recovery_rate") or 5
    inst.components.container:SetNumSlots(layout.num_slots)

    -- One repair step per day segment (16 per day) rather than every second.
    local segment = GLOBAL.TUNING.SEG_TIME or mathmod.SEGMENT_LENGTH_SECONDS
    inst:DoPeriodicTask(segment, function()
        recover_items_in(inst, rate, segment)
    end)

    inst.OnLongUpdate = function(inst_, dt)
        recover_items_in(inst_, rate, dt)
    end

    -- Same open/close feedback the wardrobe uses while changing skins.
    inst.components.container.onopenfn = function(inst_)
        if not inst_:HasTag("burnt") then
            inst_.AnimState:PlayAnimation("open")
            inst_.SoundEmitter:PlaySound("dontstarve/common/wardrobe_open")
        end
    end
    inst.components.container.onclosefn = function(inst_)
        if not inst_:HasTag("burnt") and inst_.AnimState:IsCurrentAnimation("open") then
            inst_.AnimState:PlayAnimation("cancel")
            inst_.SoundEmitter:PlaySound("dontstarve/common/wardrobe_close")
        end
    end
end)

```



### 变体演进：装备栏64格上限修复 (Mod 3823808577)
- **变体场景与切面**：收录来自工坊 Mod 3823808577 (`装备栏64格上限修复`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3823808577)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：金色的雨 (Mod 3814687245)
- **变体场景与切面**：收录来自工坊 Mod 3814687245 (`金色的雨`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3814687245)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:moisture
-- ========================================================
AddComponentPostInit("moisture", function(self)
    local old_GetMoistureRate = self.GetMoistureRate

    self.GetMoistureRate = function(self, ...)
        local rate = old_GetMoistureRate(self, ...)

        -- 只在雨天、速率为正、且不是沃特时打折
        if rate <= 0 or self.inst.prefab == "wurt" then
            return rate
        end

        -- 到这里的 rate > 0，说明原版已经判断过防雨 < 1
        return rate * 0.05
    end
end)

```



### 变体演进：月影薇洛 (Mod 3810965914)
- **变体场景与切面**：收录来自工坊 Mod 3810965914 (`月影薇洛`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3810965914)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:flamethrower_fx
if lunar_freeze then
    AddPrefabPostInit("flamethrower_fx", function(inst)
        if not TheWorld.ismastersim then return end
        if inst.components.weapon then
            inst.components.weapon:SetOnAttack(function(inst, attacker, target)
                if target ~= nil and target.components.freezable ~= nil then
                    target.components.freezable:AddColdness(lunar_freeze_coldness)
                    target.components.freezable:SpawnShatterFX()
                end
            end)
        end
    end)

```



### 变体演进：假如我晕碳 (Mod 3805564211)
- **变体场景与切面**：收录来自工坊 Mod 3805564211 (`假如我晕碳`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3805564211)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:eater

AddComponentPostInit("eater", function(self)
	self.inst:ListenForEvent("oneat", function(inst, data)
		local food = data ~= nil and data.food or nil
		if food == nil or food.components.edible == nil then
			return
		end

		local hunger = food.components.edible:GetHunger(inst)
		local grogginess = inst.components.grogginess
		if hunger <= hunger_threshold or grogginess == nil then
			return
		end

		local sleep_time = (hunger - hunger_threshold) / (5 * coma_mult)
		inst:DoTaskInTime(0, function()
			if inst:IsValid() and inst.components.grogginess ~= nil then
				local resistance = inst.components.grogginess:GetResistance()
				inst.components.grogginess:AddGrogginess(resistance, sleep_time)
			end
		end)
	end)
end)

```



### 变体演进：孙笑川阿比 (Mod 3782198237)
- **变体场景与切面**：收录来自工坊 Mod 3782198237 (`孙笑川阿比`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3782198237)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：Visible Mimicreep Items (Mod 3728174446)
- **变体场景与切面**：收录来自工坊 Mod 3728174446 (`Visible Mimicreep Items`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3728174446)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:itemmimic

AddComponentPostInit("itemmimic", function(self)
    local inst = self.inst

    inst:DoTaskInTime(0, function()
        if not inst:IsValid() then return end

        -- Mimicreep names
        local old_GetDisplayName = inst.GetDisplayName
        if old_GetDisplayName then
            inst.GetDisplayName = function(item_inst)
                return ApplyMimicPrefix(old_GetDisplayName(item_inst))
            end
        end

        -- Mimicreep shader
        inst.AnimState:SetMultColour(0, 0, 0, 0.6)
        inst.AnimState:SetAddColour(0, 0, 0, 0)

        -- Mimicreep icon
        inst.layeredinvimagefn = function(item)
            local layers = {}
            local inventoryitem = item.replica and item.replica.inventoryitem
            if inventoryitem then
                table.insert(layers, {
                    atlas = inventoryitem:GetAtlas(),
                    image = inventoryitem:GetImage(),
                })
            end
            table.insert(layers, { atlas = OVERLAY_ATLAS, image = OVERLAY_IMAGE })
            return layers
        end
        inst:PushEvent("imagechange")
    end)
end)

```



### 变体演进：字如其名的野餐篮 (Mod 3717445564)
- **变体场景与切面**：收录来自工坊 Mod 3717445564 (`字如其名的野餐篮`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3717445564)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:elixir_container

AddPrefabPostInit("elixir_container", function(inst)
    inst:AddTag("fridge")

    if not TheWorld.ismastersim then
        return
    end

    inst.cold = false
    inst.Cold = function(self)
        self.cold = true
        self:AddTag("iscold")
        if self.components.preserver == nil then
            self:AddComponent("preserver")
        end
        self.components.preserver:SetPerishRateMultiplier(TUNING.BEARGERFUR_SACK_PRESERVER_RATE or 0.5)
    end

    local old_onsave = inst.OnSave
    inst.OnSave = function(self, data)
        if old_onsave ~= nil then
            old_onsave(self, data)
        end
        data.cold = self.cold
    end

    local old_onload = inst.OnLoad
    inst.OnLoad = function(self, data)
        if old_onload ~= nil then
            old_onload(self, data)
        end
        if data ~= nil and data.cold then
            self:Cold()
        end
    end

    if inst.components.container ~= nil then
        local old_onopen = inst.components.container.onopenfn
        inst.components.container.onopenfn = function(self)
            if old_onopen ~= nil then
                old_onopen(self)
            end
            if not self:HasTag("burnt") and self.cold then
                self._frostfx = SpawnPrefab("beargerfur_sack_frost_fx")
                if self._frostfx ~= nil then
                    self._frostfx.entity:SetParent(self.entity)
                    self._frostfx.Follower:FollowSymbol(self.GUID, "ground", -25, -15, 0)
                end
            end
        end

        local old_onclose = inst.components.container.onclosefn
        inst.components.container.onclosefn = function(self)
            if old_onclose ~= nil then
                old_onclose(self)
            end
            if self._frostfx ~= nil then
                if self._frostfx:IsValid() then
                    self._frostfx:Remove()
                end
                self._frostfx = nil
            end
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:sisturn

AddPrefabPostInit("sisturn", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    if inst.components.preserver == nil then
        inst:AddComponent("preserver")
    end
    inst:DoTaskInTime(0, function()
        if inst.components.preserver ~= nil then
            inst.components.preserver.GetPerishRateMultiplier = function(self, item)
                return 0
            end
        end
    end)
end)

```



### 变体演进：万圣节部分内容禁用 (Mod 3488138790)
- **变体场景与切面**：收录来自工坊 Mod 3488138790 (`万圣节部分内容禁用`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3488138790)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:hunter
if GetModConfigData("enable2") then
    AddComponentPostInit("hunter", function(self)
        if self.OnDirtInvestigated then
            local SpawnDirt = MOD_util:GetUpvalue_deekseek(self.OnDirtInvestigated, "SpawnDirt")
            if SpawnDirt then
                local SpawnBat = MOD_util:GetUpvalue_deekseek(SpawnDirt, "SpawnBat")
                if SpawnBat then
                    MOD_util:SetUpvalue_deekseek(SpawnDirt, "SpawnBat", function()
                        --print("SpawnBat")
                    end)
                    --print("成功找到目标")
                end
            end
        end
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:mound
    end)
    AddPrefabPostInit("mound", function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        local oldonfinish = inst.components.workable.onfinish
        inst.components.workable:SetOnFinishCallback(function(...)
            if TheWorld.components.specialeventsetup ~= nil then
                TheWorld.components.specialeventsetup.halloween_bat_grave_spawn_chance = 0
            end
            oldonfinish(...)
            if TheWorld.components.specialeventsetup ~= nil then
                TheWorld.components.specialeventsetup.halloween_bat_grave_spawn_chance = 0
            end
        end)
    end)

```



### 变体演进：Announce_all (Mod 3411189852)
- **变体场景与切面**：收录来自工坊 Mod 3411189852 (`Announce_all`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3411189852)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:burnable

AddComponentPostInit("burnable", function(self)
	if not TheWorld.ismastersim then return end
    local oldStartWildfire = self.StartWildfire
    local tag_list = {"structure","farm_plant","heavy","kelp","planted","palmconetree","moon_tree"}
    --建筑.农田作物.巨大作物.海带.种植的*.棕榈树.月树
    local prefab_list = {"rock_avocado_bush","boat_cannon","oceantree","oceantree_pillar"}
    --石果.大炮.疙瘩树.高于平均的大树
    local no_ann_tag = {"farm_plant_killjoy"}
	--杂草
    local no_ann_prefab = {"marsh_bush"}
	--尖刺灌木丛
    function self:StartWildfire()
        if self.inst and all then
            local x,y,z = self.inst.Transform:GetWorldPosition()
            local player = FindClosestPlayerInRange(x, y, z,80)
            local msg = self.inst:GetBasicDisplayName().."被引燃"
            if player then
                msg = msg..","..player.name.."你可以去灭火"
            end
            TheNet:Announce(msg)
        else
            if (self.inst:HasOneOfTags(tag_list) and not self.inst:HasOneOfTags(no_ann_tag)
                or self.inst.planted
                    or self.inst.components.pickable and self.inst.components.pickable.transplanted
                        or find(self.inst.prefab,prefab_list))
                            and not find(self.inst.prefab,no_ann_prefab) then
                local x,y,z = self.inst.Transform:GetWorldPosition()
                local player = FindClosestPlayerInRange(x, y, z,80)
                local msg = self.inst:GetBasicDisplayName().."被引燃"
                if player then
                    msg = msg..","..player.name.."你可以去灭火"
                end
                TheNet:Announce(msg)
            end
        end
        return oldStartWildfire(self)
    end
end)

```



### 变体演进：欧皇模拟器补丁 (Mod 3628068817)
- **变体场景与切面**：收录来自工坊 Mod 3628068817 (`欧皇模拟器补丁`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3628068817)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:luckysimulator
-- 无视过多垃圾
AddPrefabPostInit("luckysimulator", function(inst)
inst:DoTaskInTime(2, function(inst)
inst:RemoveTag("luckysimulator")
end)
end)

```



### 变体演进：Silabell (Mod 3771867138)
- **变体场景与切面**：收录来自工坊 Mod 3771867138 (`Silabell`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3771867138)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:farmplantable

AddComponentPostInit("farmplantable", function(self)
    local old_Plant = self.Plant
    function self:Plant(target, planter)
        local success = old_Plant(self, target, planter)
        if success then
            OnPlantCare(planter)
        end
        return success
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:deployable

AddComponentPostInit("deployable", function(self)
    local old_Deploy = self.Deploy
    function self:Deploy(pt, deployer, rot)
        local is_treeseed = self.inst:HasTag("treeseed")
        local success = old_Deploy(self, pt, deployer, rot)
        if success and is_treeseed then
            OnTreePlanted(deployer)
        end
        return success
    end
end)

```



### 变体演进：食物保持新鲜 | Fresh Until Rot (Mod 3822505147)
- **变体场景与切面**：收录来自工坊 Mod 3822505147 (`食物保持新鲜 | Fresh Until Rot`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3822505147)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:hambat

AddPrefabPostInit("hambat", function(inst)
    if not G.TheWorld.ismastersim then return end
    local weapon = inst.components.weapon
    if weapon == nil then return end
    local old = weapon.SetDamage
    weapon.SetDamage = function(self, damage, ...)
        if alive(inst) and G.type(damage) == "number" then
            local percent = inst.components.perishable:GetPercent()
            local vanilla = G.Remap(T.HAMBAT_DAMAGE * percent, 0, T.HAMBAT_DAMAGE,
                T.HAMBAT_MIN_DAMAGE_MODIFIER * T.HAMBAT_DAMAGE, T.HAMBAT_DAMAGE)
            -- Leave unrelated custom damage assignments from other mods alone.
            if G.math.abs(damage - vanilla) < 0.000001 then
                damage = T.HAMBAT_DAMAGE
            end
        end
        return old(self, damage, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:oceanfishinghook
-- are retained. The actual bait percent is never replaced, even temporarily.
AddComponentPostInit("oceanfishinghook", function(self)
    local old = self._ClacCharm -- This spelling is the actual current API.
    self._ClacCharm = function(self, fish, ...)
        local result = old(self, fish, ...)
        if alive(self.inst) then
            local percent = self.inst.components.perishable:GetPercent()
            if percent > 0 then return result / percent end
        end
        return result
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:wortox_reviver
local revivercost
AddPrefabPostInit("wortox_reviver", function(inst)
    if not G.TheWorld.ismastersim then return end
    local spellcaster = inst.components.spellcaster
    if spellcaster == nil or spellcaster.spell == nil then return end
    if revivercost == nil then
        local recipe = G.AllRecipes.wortox_reviver
        local cost = 0
        if recipe ~= nil and recipe.ingredients ~= nil then
            for _, ingredient in G.ipairs(recipe.ingredients) do
                if ingredient.type == "wortox_soul" then cost = cost + ingredient.amount end
            end
        end
        revivercost = cost > 0 and cost or 10
    end
    local old = spellcaster.spell
    spellcaster:SetSpellFn(function(item, target, pos, caster, ...)
        local extra = 0
        if caster ~= nil and caster.components.inventory ~= nil and alive(item)
            and item.components.linkeditem ~= nil
            and item.components.linkeditem:GetOwnerInst() == caster then
            extra = revivercost - G.math.ceil(item.components.perishable:GetPercent() * revivercost)
        end
        local result = old(item, target, pos, caster, ...)
        if extra > 0 and caster:IsValid() then
            local prior = caster.wortox_ignoresoulcounts
            caster.wortox_ignoresoulcounts = true
            for _ = 1, extra do
                local soul = G.SpawnPrefab("wortox_soul")
                if soul ~= nil then caster.components.inventory:DropItem(soul, true, true, caster:GetPosition()) end
            end
            caster.wortox_ignoresoulcounts = prior
        end
        return result
    end)
end)

```



### 变体演进：Ukyou (Mod 3823946272)
- **变体场景与切面**：收录来自工坊 Mod 3823946272 (`Ukyou`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3823946272)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:lightning
end
AddPrefabPostInit("lightning", function(inst)
    if TheWorld.ismastersim then inst:DoTaskInTime(0,function() notify_noise(inst,140) end) end
end)
for _, prefab in ipairs({"cavein_boulder","rocks","flint","nitre","goldnugget","marble"}) do
    local is_cavein=prefab=="cavein_boulder"
    AddPrefabPostInit(prefab,function(inst)
        if not TheWorld.ismastersim then return end
        inst:ListenForEvent("startfalling",function() notify_noise(inst,35) end)
        if is_cavein then inst:DoTaskInTime(0,function() notify_noise(inst,35) end) end
    end)
end

STRINGS.NAMES.UKYOU_ANY_FEATHER = "任意羽毛"
local feather_ingredient = require("ukyou_feather_ingredient")
AddComponentPostInit("inventory", feather_ingredient.InstallInventory)
AddClassPostConstruct("components/inventory_replica", feather_ingredient.InstallHas)

-- The character selection widgets read flat tuning keys.
TUNING.UKYOU_HEALTH = TUNING.UKYOU.HEALTH
TUNING.UKYOU_HUNGER = TUNING.UKYOU.HUNGER
TUNING.UKYOU_SANITY = TUNING.UKYOU.SANITY

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:inventory
local feather_ingredient = require("ukyou_feather_ingredient")
AddComponentPostInit("inventory", feather_ingredient.InstallInventory)
AddClassPostConstruct("components/inventory_replica", feather_ingredient.InstallHas)

-- The character selection widgets read flat tuning keys.
TUNING.UKYOU_HEALTH = TUNING.UKYOU.HEALTH
TUNING.UKYOU_HUNGER = TUNING.UKYOU.HUNGER
TUNING.UKYOU_SANITY = TUNING.UKYOU.SANITY

```



### 变体演进：自定义默认视角方向 (Mod 3641970435)
- **变体场景与切面**：收录来自工坊 Mod 3641970435 (`自定义默认视角方向`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3641970435)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:cave
-- 监听 cave prefab 的初始化，判断是否在洞穴
AddPrefabPostInit("cave", function(inst)
    IS_CAVE = true
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:player_classified
-- 2. 拦截服务器下发的重置视角指令 (player_classified)
AddPrefabPostInit("player_classified", function(inst)
    inst:ListenForEvent("playercamerasnap", function(inst)
        -- 延时0秒以在游戏原生逻辑执行后覆盖它
        inst:DoTaskInTime(0, function()
            -- 检查 camerasnap 的值 (即 resetrot 参数)
            -- 只有当 resetrot 为 true 时，才强制应用设置的默认视角
            if inst._parent == ThePlayer and TheCamera and inst.camerasnap:value() then
                local target = GetHeading()
                TheCamera:SetHeadingTarget(target)
                TheCamera:Snap()
            end
        end)
    end)
end)

```



### 变体演进：modao (Mod 2925295933)
- **变体场景与切面**：收录来自工坊 Mod 2925295933 (`modao`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2925295933)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:modao

 AddPrefabPostInit("modao",function(inst)
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(60)
    inst.components.weapon:SetRange(1.1,1.1)
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(1000)
    inst.components.finiteuses:SetUses(1000)  
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst:AddComponent("tool")
	inst.components.tool:SetAction(ACTIONS.CHOP, 66)
    inst.components.tool:SetAction(ACTIONS.MINE, 2)
    inst.components.tool:SetAction(ACTIONS.DIG)
    if inst.components.equippable then inst.components.equippable.walkspeedmult =1.1 end
	local function onattack(weapon, attacker, target)
	if attacker then
	    if attacker.components.health then
		    attacker.components.health:DoDelta(1)
		end
	end
	if attacker then
	    if attacker.components.sanity then
		    attacker.components.sanity:DoDelta(0)
		end
	end
    end
    inst.components.weapon:SetOnAttack(onattack)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:goldnugget
end)
AddPrefabPostInit("goldnugget",function(inst)
	if not inst.components.tradable then
		inst:AddComponent("tradable")
    end
end)

```



### 变体演进：Yay! Rain! (Mod 1813311384)
- **变体场景与切面**：收录来自工坊 Mod 1813311384 (`Yay! Rain!`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 1813311384)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:wormwood

AddPrefabPostInit("wormwood", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return
	end

	--[[local rHealth = GetModConfigData("HEALTH_RAIN")
	local rDelay = GetModConfigData("DELAY_RAIN")
	local rWet = GetModConfigData("WET_RAIN")
	local rDay = GetModConfigData("DAY_RAIN")]]--

	inst:DoPeriodicTask(GetModConfigData("DELAY_RAIN"), function()
		if GetModConfigData("WET_RAIN") and inst.components.moisture.moisture == 0 then
			print("Not Wet")
		elseif not GetModConfigData("WET_RAIN") and not GLOBAL.TheWorld.state.israining then
			print("Not Raining")
		else

			if GetModConfigData("DAY_RAIN") and GLOBAL.TheWorld.state.phase ~= "day" then
				print("Too Dark")
			elseif inst.components.moisture.moisture > 80 then
				print("Too Wet")
			else
				inst.components.health:DoDelta(GetModConfigData("HEALTH_RAIN"))
			end
		end
	end)
end)		

```



### 变体演进：三理Mit3uri· 薇格弗德外观替换（客户端） (Mod 3824111341)
- **变体场景与切面**：收录来自工坊 Mod 3824111341 (`三理Mit3uri· 薇格弗德外观替换（客户端）`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3824111341)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:wathgrithrhat
-- It works before ThePlayer exists and without a server inventoryitem component.
AddPrefabPostInit("wathgrithrhat", function(inst)
    inst:SetClientSideInventoryImageOverride(
        ICON_FLAG,
        "wathgrithrhat.tex",
        "violet_beret.tex",
        G.resolvefilepath(ICON_ATLAS)
    )
    inst:SetClientSideInventoryImageOverrideFlag(ICON_FLAG, true)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:wathgrithr
AddMinimapAtlas(UI .. "minimap.xml")
AddPrefabPostInit("wathgrithr", function(inst)
    if inst.MiniMapEntity ~= nil then
        inst.MiniMapEntity:SetIcon("mit3uri_wathgrithr.png")
    end
end)

```



### 变体演进：自动切手杖武器 Auto Switch Cane and Weapon (Mod 2781167240)
- **变体场景与切面**：收录来自工坊 Mod 2781167240 (`自动切手杖武器 Auto Switch Cane and Weapon`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2781167240)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player_classified

AddPrefabPostInit("player_classified", function(inst)
    inst:DoTaskInTime(0.5, function(inst)
        if GLOBAL.ThePlayer then
            GLOBAL.ThePlayer:AddComponent("autoswitch")
            GLOBAL.ThePlayer.components.autoswitch:SetChipSlot(CHIP_SLOT)
            GLOBAL.ThePlayer.components.autoswitch:SetWeaponList(WEAPON_LIST)
        end
    end)
end)

```



### 变体演进：绝望守卫-Ward (Mod 3776817880)
- **变体场景与切面**：收录来自工坊 Mod 3776817880 (`绝望守卫-Ward`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3776817880)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:nightmarefuel
-- 专属消耗品回血
AddPrefabPostInit("nightmarefuel", function(inst)
    if inst.components.edible == nil then
        inst:AddComponent("edible")
    end
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 0
    inst.components.edible.sanityvalue = -30
    inst.components.edible:SetOnEatenFn(function(inst, eater)
        if eater.prefab == "ward" then
            if eater.components.health ~= nil then
                eater.components.health:DoDelta(20)
            end
            if eater.components.sanity ~= nil then
                eater.components.sanity:DoDelta(25)
            end
        end
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:horrorfuel

AddPrefabPostInit("horrorfuel", function(inst)
    if inst.components.edible == nil then
        inst:AddComponent("edible")
    end
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 0
    inst.components.edible.sanityvalue = -60
    inst.components.edible:SetOnEatenFn(function(inst, eater)
        if eater.prefab == "ward" then
            if eater.components.health ~= nil then
                eater.components.health:DoDelta(60)
            end
            if eater.components.sanity ~= nil then
                eater.components.sanity:DoDelta(50)
            end
        end
    end)
end)

```



### 变体演进：🐾 Pets Vivos / Living Pets — Mais que um pet! / More Than a Pet! (Mod 3826664484)
- **变体场景与切面**：收录来自工坊 Mod 3826664484 (`🐾 Pets Vivos / Living Pets — Mais que um pet! / More Than a Pet!`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3826664484)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:workable
-- Boss quebrando estrutura (base): avisa os pets por um evento do mundo
AddComponentPostInit("workable", function(self)
    if GLOBAL.TheWorld == nil or not GLOBAL.TheWorld.ismastersim then return end
    self.inst:ListenForEvent("workfinished", function(inst, data)
        local w = data and data.worker
        if w ~= nil and w:HasTag("epic") and inst:HasTag("structure") then
            GLOBAL.TheWorld:PushEvent("petsvivos_basehit", { inst = inst })
        end
    end)
end)

```



### 变体演进：懒人全能设施 (Mod 3830746829)
- **变体场景与切面**：收录来自工坊 Mod 3830746829 (`懒人全能设施`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3830746829)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:fueled

AddComponentPostInit("fueled", function(self)
    local inst = self.inst
    if inst == nil or inst.components.mast == nil or not IsOn("opt_deck_lamp") then
        return
    end
    -- 组件是在 prefab 函数里创建的，那时 inst.prefab 还没赋值，所以等一帧再判断 prefab 并处理
    inst:DoTaskInTime(0, function(i)
        if not i:IsValid() or not VANILLA_MAST_PREFABS[i.prefab] then
            return
        end
        local fueled = i.components.fueled
        if fueled ~= nil then
            MakeFuelPermanent(fueled)
        end
        ForceMastLamp(i)
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:floatinglantern

AddPrefabPostInit("floatinglantern", function(inst)
    if not TheWorld.ismastersim or not IsOn("opt_sky_lantern") then
        return inst
    end
    local life = 30 * (TUNING.TOTAL_DAY_TIME or 480)
    inst:DoTaskInTime(life, function(i)
        if i:IsValid() then
            i:Remove()
        end
    end)
    return inst
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:carnivaldecor_lamp

AddPrefabPostInit("carnivaldecor_lamp", function(inst)
    if inst.Light == nil or not IsOn("opt_carnival_lamp") then
        return inst
    end

    inst.Light:SetRadius(4)

    if not TheWorld.ismastersim then
        return inst
    end

    -- 正常激活；激活后取消原版的自动熄灭，并保证灯和顶上那颗小珠子一起保持点亮
    inst:DoPeriodicTask(1, function(i)
        if i.Light == nil or not i.Light:IsEnabled() then
            return
        end
        if i.turnofftask ~= nil then
            i.turnofftask:Cancel()
            i.turnofftask = nil
        end
        if i.components.activatable ~= nil then
            i.components.activatable.inactive = false
        end
        local onanim = "idle" .. (i.shape or 1) .. "_on"
        if i.AnimState ~= nil and not i.AnimState:IsCurrentAnimation(onanim) then
            i.AnimState:PlayAnimation(onanim, true)
        end
    end)

    return inst
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:pumpkin_lantern

AddPrefabPostInit("pumpkin_lantern", function(inst)
    if not IsOn("opt_pumpkin_lantern") then
        return inst
    end

    -- 半径锁在 2×2：原版每 0.1 秒用闪烁任务把半径写回 1.5，这里把那个任务停掉
    inst:DoPeriodicTask(.2, function(i)
        if i._flickertask ~= nil then
            i._flickertask:Cancel()
            i._flickertask = nil
        end
        if i.Light ~= nil then
            i.Light:SetRadius(PUMPKIN_LIGHT_RADIUS)
        end
    end)

    -- 客户端也需要这个标签，右键菜单才会出现「打蜡」
    inst:AddTag("waxable")

    if not TheWorld.ismastersim then
        return inst
    end

    local waxable = inst:AddComponent("waxable")
    waxable:SetWaxfn(function(target)
        if target._allfac_waxed then
            return false, "ALREADY_WAXED"
        end
        MakePumpkinPermanent(target)
        return true
    end)

    local old_onload = inst.OnLoad
    inst.OnLoad = function(i, data)
        if old_onload ~= nil then
            old_onload(i, data)
        end
        if i._allfac_waxed then
            MakePumpkinPermanent(i)
        end
    end

    inst.OnSave = function(i, data)
        data.allfac_waxed = i._allfac_waxed or nil
    end

    return inst
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:allfac_light

AddPrefabPostInit("allfac_light", ApplyLightSettings)

AddPrefabPostInit("firesuppressor", function(inst)
    if not TheWorld.ismastersim or not IsOn("opt_suppressor") then
        return inst
    end

    MakeFuelPermanent(inst.components.fueled)
    FillFuel(inst.components.fueled)

    local light = SpawnPrefab("allfac_light")
    if light ~= nil then
        light.entity:SetParent(inst.entity)
        light.Transform:SetPosition(0, 1, 0)
        inst._allfac_light = light
        inst:ListenForEvent("onremove", function()
            if light:IsValid() then
                light:Remove()
            end
        end)
    end

    -- 清除范围内的亮茄寄生体。
    -- Remove() 会走 prefab 内的 OnRemove -> deinfest()，被寄生的植物会恢复交互和生长；
    -- deinfest() 不会清 plant.lunarthrall_plant 这个"已被寄生"反向引用（只有死亡路径清），
    -- 这里补上，避免植物一直挂着已删除实体。
    -- 寄生体被清掉后同一株植物仍可能被再次选中，靠周期扫描持续处理。
    inst:DoPeriodicTask(SCAN_INTERVAL, function()
        local x, y, z = inst.Transform:GetWorldPosition()
        local thralls = TheSim:FindEntities(x, y, z, LIGHT_RADIUS, { THRALL_TAG })
        for _, thrall in ipairs(thralls) do
            local tracker = thrall.components.entitytracker
            local plant = tracker ~= nil and tracker:GetEntity("targetplant") or nil
            if plant ~= nil and plant.lunarthrall_plant == thrall then
                plant.lunarthrall_plant = nil
            end
            thrall:Remove()
        end
    end)
end)

```



### 变体演进：Porządne Spolszczenie - DEMO (Mod 3804527772)
- **变体场景与切面**：收录来自工坊 Mod 3804527772 (`Porządne Spolszczenie - DEMO`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3804527772)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:sapling_moon
GLOBAL.STRINGS.NAMES.TREE_ROCK = "Głazonar"
AddPrefabPostInit("sapling_moon", function(inst)
    inst:SetPrefabNameOverride("sapling_moon")
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:wx78

AddPrefabPostInit("wx78", function(inst)
    if inst.components.talker then
        inst.components.talker.mod_str_fn = PolishUpper
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:wanderingtrader

AddPrefabPostInit("wanderingtrader", function(inst)
    if inst.components.talker ~= nil then
        inst.components.talker.font = TALKINGFONT_TRADEIN
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:talker
-- Customowy kolor tekstu Wagstaffa
AddComponentPostInit("talker", function(talker)
    local inst = talker.inst

    if inst ~= nil and inst:HasTag("wagstaff_npc") then
        talker.colour = Vector3(
            224 / 255,
            173 / 255,
            103 / 255
        )
    end
end)

```



### 变体演进：不再耕地 No More Retilling (Mod 3815817262)
- **变体场景与切面**：收录来自工坊 Mod 3815817262 (`不再耕地 No More Retilling`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3815817262)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:pickable
    --    把标志打开，就能精准圈住这一次破坏。
    AddComponentPostInit("pickable", function(self)
        local old_Pick = self.Pick
        if type(old_Pick) ~= "function" then
            return
        end

        self.Pick = function(_self, picker, ...)
            if _self.inst == nil or not _self.inst:HasTag("farm_plant") then
                return old_Pick(_self, picker, ...)
            end

            RunWithFlag("keep_soil", old_Pick, _self, picker, ...)
        end
    end)

    -- 2) 铲除杂草：杂草走的是 workable 的 DIG，完成回调里同样会
    --    「生成一块土 + breaksoil」。只包装带 weed 标签的对象。
    AddComponentPostInit("workable", function(self)
        local old_set = self.SetOnFinishCallback
        if type(old_set) ~= "function" then
            return
        end

        self.SetOnFinishCallback = function(_self, fn)
            return old_set(_self, function(inst, worker, ...)
                if inst == nil or not inst:HasTag("weed") then
                    return fn(inst, worker, ...)
                end

                RunWithFlag("keep_soil", fn, inst, worker, ...)
            end)
        end
    end)

    -- 3) 土被塌陷后换一块新的。
    --    监听是在 prefab 自己的 OnBreak 之后注册的，所以跑到这里时塌陷已经
    --    发生了，我们只需把它换成一块干净的新土即可，不必去动原版的监听。
    AddPrefabPostInit("farm_soil", function(inst)
        if not GLOBAL.TheWorld.ismastersim then
            return
        end

        inst:ListenForEvent("breaksoil", function(_inst)
            if not flags.keep_soil then
                return -- 不是收获造成的，按原版处理
            end

            -- 先同步记下位置，稍后一帧再换，避开原版塌陷动画的起始帧
            local x, y, z = _inst.Transform:GetWorldPosition()

            _inst:DoTaskInTime(0, function()
                if not _inst:IsValid() then
                    return
                end

                if GLOBAL.TheWorld.Map:GetTileAtPoint(x, y, z) ~= GLOBAL.WORLD_TILES.FARMING_SOIL then
                    return -- 这里已经不是耕地了，别硬补
                end

                _inst:Remove()

                local soil = GLOBAL.SpawnPrefab("farm_soil")
                if soil ~= nil then
                    soil.Transform:SetPosition(x, y, z)
                    Log("收获后补回耕地 (" .. tostring(x) .. ", " .. tostring(z) .. ")")
                end
            end)
        end)
    end)
end

------------------------------------------------------------------------------
-- 功能二：园艺规划器不再乱挖坑
--
-- 需求澄清：这里说的「坑」指的是 farm_soil —— 也就是地上那些**可以放种子
-- 的耕地**。原版园艺规划器（farm_plow）挖地时会一边挖一边往外甩出好几块
-- 这种耕地（dirt_anim），位置是随机偏移、随机延迟的，所以东一个西一个很不
-- 整齐，还会甩到耕地外面去。
--
-- 判定方式（v1.2.0 起）：
--   原版每甩出一块耕地，都会紧接着调用 soil:SetPlowing(plow) 把这块土和
--   规划器绑起来。所以「SetPlowing 被调用了」就是最精准的特征：
--     · 玩家自己用锄头耕出来的土从来不会被调 SetPlowing → 不受影响
--     · 规划器完工后的耕地，_plow 早被清掉、存档里也不保存 → 不受影响
--   只在这一个 farm_soil 实体上包一层自己的方法，不 hook 全局函数、
--   不动 SpawnPrefab、不改 CollapseSoilAtPoint，兼容性最好。
--
-- 杂物（farm_soil_debris）由 OnTerraform 生成，本模组完全不碰 →
-- 「翻出杂物要铲」的机制完整保留。
------------------------------------------------------------------------------
if NO_PLOW_HOLES then

    AddPrefabPostInit("farm_soil", function(inst)
        if not GLOBAL.TheWorld.ismastersim then
            return
        end

        local old_SetPlowing = inst.SetPlowing
        if type(old_SetPlowing) ~= "function" then
            return
        end

        inst.SetPlowing = function(_inst, plow)
            old_SetPlowing(_inst, plow)

            if plow == nil then
                return
            end

            UnbindPlow(_inst)

            _inst:DoTaskInTime(0, function()
                if _inst:IsValid() then
                    Log("撤销规划器挖出的耕地")
                    _inst:Remove()
                end
            end)
        end
    end)
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:workable
    --    「生成一块土 + breaksoil」。只包装带 weed 标签的对象。
    AddComponentPostInit("workable", function(self)
        local old_set = self.SetOnFinishCallback
        if type(old_set) ~= "function" then
            return
        end

        self.SetOnFinishCallback = function(_self, fn)
            return old_set(_self, function(inst, worker, ...)
                if inst == nil or not inst:HasTag("weed") then
                    return fn(inst, worker, ...)
                end

                RunWithFlag("keep_soil", fn, inst, worker, ...)
            end)
        end
    end)

    -- 3) 土被塌陷后换一块新的。
    --    监听是在 prefab 自己的 OnBreak 之后注册的，所以跑到这里时塌陷已经
    --    发生了，我们只需把它换成一块干净的新土即可，不必去动原版的监听。
    AddPrefabPostInit("farm_soil", function(inst)
        if not GLOBAL.TheWorld.ismastersim then
            return
        end

        inst:ListenForEvent("breaksoil", function(_inst)
            if not flags.keep_soil then
                return -- 不是收获造成的，按原版处理
            end

            -- 先同步记下位置，稍后一帧再换，避开原版塌陷动画的起始帧
            local x, y, z = _inst.Transform:GetWorldPosition()

            _inst:DoTaskInTime(0, function()
                if not _inst:IsValid() then
                    return
                end

                if GLOBAL.TheWorld.Map:GetTileAtPoint(x, y, z) ~= GLOBAL.WORLD_TILES.FARMING_SOIL then
                    return -- 这里已经不是耕地了，别硬补
                end

                _inst:Remove()

                local soil = GLOBAL.SpawnPrefab("farm_soil")
                if soil ~= nil then
                    soil.Transform:SetPosition(x, y, z)
                    Log("收获后补回耕地 (" .. tostring(x) .. ", " .. tostring(z) .. ")")
                end
            end)
        end)
    end)
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:farm_soil
    --    发生了，我们只需把它换成一块干净的新土即可，不必去动原版的监听。
    AddPrefabPostInit("farm_soil", function(inst)
        if not GLOBAL.TheWorld.ismastersim then
            return
        end

        inst:ListenForEvent("breaksoil", function(_inst)
            if not flags.keep_soil then
                return -- 不是收获造成的，按原版处理
            end

            -- 先同步记下位置，稍后一帧再换，避开原版塌陷动画的起始帧
            local x, y, z = _inst.Transform:GetWorldPosition()

            _inst:DoTaskInTime(0, function()
                if not _inst:IsValid() then
                    return
                end

                if GLOBAL.TheWorld.Map:GetTileAtPoint(x, y, z) ~= GLOBAL.WORLD_TILES.FARMING_SOIL then
                    return -- 这里已经不是耕地了，别硬补
                end

                _inst:Remove()

                local soil = GLOBAL.SpawnPrefab("farm_soil")
                if soil ~= nil then
                    soil.Transform:SetPosition(x, y, z)
                    Log("收获后补回耕地 (" .. tostring(x) .. ", " .. tostring(z) .. ")")
                end
            end)
        end)
    end)

```



### 变体演进：D_J的女武神增强 (Mod 3830831588)
- **变体场景与切面**：收录来自工坊 Mod 3830831588 (`D_J的女武神增强`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3830831588)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:wathgrithr

AddPrefabPostInit("wathgrithr", OnWathgrithr)

```



### 变体演进：Mod 3764493468 (Mod 3764493468)
- **变体场景与切面**：收录来自工坊 Mod 3764493468 (`Mod 3764493468`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3764493468)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller

AddComponentPostInit("playercontroller", function(self)
    local GetActionButtonAction = self.GetActionButtonAction
    function self:GetActionButtonAction(...)
        EXCLUDE_FLAG = true
        local act = GetActionButtonAction(self, ...)
        EXCLUDE_FLAG = false
        return act
    end

    local OnLeftClick = self.OnLeftClick
    function self:OnLeftClick(down)
        if self.inst == ThePlayer and (RIGHT_ALT_MODE or self._pickup_filter_suppress_primary) then
            if down then
                self._pickup_filter_suppress_primary = true
                if RIGHT_ALT_MODE then
                    TogglePrefabUnderMouse()
                end
            else
                self._pickup_filter_suppress_primary = nil
            end
            return
        end
        return OnLeftClick(self, down)
    end

    local OnUpdate = self.OnUpdate
    function self:OnUpdate(...)
        local previous_highlight = self.highlight_guy
        local result = OnUpdate(self, ...)

        if RIGHT_ALT_MODE and self.inst == ThePlayer then
            if previous_highlight ~= nil
                and previous_highlight ~= self.highlight_guy
                and HIGHLIGHTED_ENTITIES[previous_highlight] then
                HighlightEntityGreen(previous_highlight)
            end
            if self.highlight_guy ~= nil and HIGHLIGHTED_ENTITIES[self.highlight_guy] then
                HighlightEntityGreen(self.highlight_guy)
            end
        end

        return result
    end
end)

```



### 变体演进：批量交易 (Mod 3506640380)
- **变体场景与切面**：收录来自工坊 Mod 3506640380 (`批量交易`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3506640380)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:antlion
GLOBAL.setfenv(1,GLOBAL)
AddPrefabPostInit("antlion", function(inst)
    inst.components.trader.acceptstacks = true
    
    local oldonacceptfn = inst.components.trader.onaccept
    inst.components.trader.onaccept = function(inst,giver,item,count)
        oldonacceptfn(inst,giver,item,count)
        if count>1 and inst.pendingrewarditem == "townportaltalisman" then
            inst.pendingrewarditem = {}
            for i = 1, count do
                inst.pendingrewarditem[i] = "townportaltalisman"
            end
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:pigking

AddPrefabPostInit("pigking",function (inst)
        

    local function ontradeforgold(inst, item, giver)
        local count = item.components.stackable~=nil and item.components.stackable:StackSize() or 1
        AwardPlayerAchievement("pigking_trader", giver)

        local x, y, z = inst.Transform:GetWorldPosition()
        y = 4.5

        local angle
        if giver ~= nil and giver:IsValid() then
            angle = 180 - giver:GetAngleToPoint(x, 0, z)
        else
            local down = TheCamera:GetDownVec()
            angle = math.atan2(down.z, down.x) / DEGREES
            giver = nil
        end

        local num_left = item.components.tradable.goldvalue*count

        while num_left > 0 do
            local nug = SpawnPrefab("goldnugget")
            nug.Transform:SetPosition(x, y, z)
            local num_to_give = math.min(num_left, TUNING.STACK_SIZE_MEDITEM)
            nug.components.stackable:SetStackSize(num_to_give)
            launchitem(nug, angle)
            num_left = num_left - num_to_give
        end

        if item.components.tradable.tradefor ~= nil then
            for _, v in pairs(item.components.tradable.tradefor) do
                local item = SpawnPrefab(v)
                if item ~= nil then
                    item.Transform:SetPosition(x, y, z)
                    launchitem(item, angle)
                end
            end
        end

        if IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) then
            -- pick out up to 3 types of candies to throw out
            local candytypes = { math.random(NUM_HALLOWEENCANDY), math.random(NUM_HALLOWEENCANDY), math.random(NUM_HALLOWEENCANDY) }
            local numcandies = (item.components.tradable.halloweencandyvalue or 1) + math.random(2) + 2

            -- only people in costumes get a good amount of candy!
            if giver ~= nil and giver.components.skinner ~= nil then
                for _, item in pairs(giver.components.skinner:GetClothing()) do
                    if DoesItemHaveTag(item, "COSTUME") or DoesItemHaveTag(item, "HALLOWED") then
                        numcandies = numcandies + math.random(4) + 2
                        break
                    end
                end
            end

            for k = 1, numcandies do
                local candy = SpawnPrefab("halloweencandy_"..GetRandomItem(candytypes))
                candy.Transform:SetPosition(x, y, z)
                launchitem(candy, angle)
            end

            if math.random() <= TUNING.HALLOWEEN_PUMPKINCARVER_PIGKING_TRADE_CHANCE then
                local pumpkincarver = SpawnPrefab("pumpkincarver"..math.random(NUM_HALLOWEEN_PUMPKINCARVERS))
                pumpkincarver.Transform:SetPosition(x, y, z)
                launchitem(pumpkincarver, angle)
            end
        end
    end


    inst.components.trader.acceptstacks = true

    debug.setupvalue(inst.components.trader.onaccept,1 ,ontradeforgold)
end)

```



### 变体演进：Stay Visible 2 (Mod 3791787028)
- **变体场景与切面**：收录来自工坊 Mod 3791787028 (`Stay Visible 2`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3791787028)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:rope_bridge_fx
-- Hide bridge ropes ---------------------------------------------------------------------------------------------
AddPrefabPostInit("rope_bridge_fx", function(inst)
	inst:DoTaskInTime(0, function(inst)
		if inst.rope1 then
			inst.rope1.AnimState:OverrideMultColour(0,0,0,bridge_rope_opacity)
		end
		if inst.rope2 then
			inst.rope2.AnimState:OverrideMultColour(0,0,0,bridge_rope_opacity)
		end
	end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:oceanvine_cocoon
-- ??????????????? why are they colored in the first place?
AddPrefabPostInit("oceanvine_cocoon", function(inst)
	inst.AnimState:SetMultColour(1,1,1,1)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:distancefade
-- This is required for the mod to work.
AddComponentPostInit("distancefade", function(self)
	--print("removing distancefade from:", self.inst)
	self.inst:DoTaskInTime(0, function(inst)
		inst:RemoveComponent("distancefade")
	end)
end)

```



### 变体演进：RoseN Server Fixes (Mod 3823476190)
- **变体场景与切面**：收录来自工坊 Mod 3823476190 (`RoseN Server Fixes`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3823476190)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:inventory

AddComponentPostInit("inventory", function(self)
    EnsureInsulation(self)
    local old_IsInsulated = self.IsInsulated
    if old_IsInsulated ~= nil then
        self.IsInsulated = function(inv, ...)
            EnsureInsulation(inv)
            return old_IsInsulated(inv, ...)
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:beef_bell

AddPrefabPostInit("beef_bell", BellPostInit)
AddPrefabPostInit("shadow_beef_bell", BellPostInit)

---------------------------------------------------------------------------
-- Konsol yardimcisi: BeefDupes()
-- Zile bagli OLMAYAN evcil beefalolari listeler (mevcut kopyalari bulmak icin).
-- To delete one: Ents[GUID]:Remove()
---------------------------------------------------------------------------
G.BeefDupes = function()
    local n = 0
    for _, v in pairs(G.Ents) do
        if v.prefab == "beefalo" and v:IsValid()
            and v.components.domesticatable ~= nil and v.components.domesticatable:IsDomesticated()
            and v.components.follower ~= nil and v.components.follower.leader == nil then
            local x, _, z = v.Transform:GetWorldPosition()
            local saddle = v.components.rideable ~= nil and v.components.rideable.saddle or nil
            print(string.format("GUID=%d  name=%s  tendency=%s  saddle=%s  pos=(%.0f, %.0f)",
                v.GUID,
                tostring(v.components.named ~= nil and v.components.named.name or "none"),
                tostring(v.tendency),
                saddle ~= nil and saddle.prefab or "none",
                x, z))
            n = n + 1
        end
    end
    print("[RoseN Fixes] domesticated beefalo without a bell: "..n)
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:shadow_beef_bell
AddPrefabPostInit("beef_bell", BellPostInit)
AddPrefabPostInit("shadow_beef_bell", BellPostInit)

---------------------------------------------------------------------------
-- Konsol yardimcisi: BeefDupes()
-- Zile bagli OLMAYAN evcil beefalolari listeler (mevcut kopyalari bulmak icin).
-- To delete one: Ents[GUID]:Remove()
---------------------------------------------------------------------------
G.BeefDupes = function()
    local n = 0
    for _, v in pairs(G.Ents) do
        if v.prefab == "beefalo" and v:IsValid()
            and v.components.domesticatable ~= nil and v.components.domesticatable:IsDomesticated()
            and v.components.follower ~= nil and v.components.follower.leader == nil then
            local x, _, z = v.Transform:GetWorldPosition()
            local saddle = v.components.rideable ~= nil and v.components.rideable.saddle or nil
            print(string.format("GUID=%d  name=%s  tendency=%s  saddle=%s  pos=(%.0f, %.0f)",
                v.GUID,
                tostring(v.components.named ~= nil and v.components.named.name or "none"),
                tostring(v.tendency),
                saddle ~= nil and saddle.prefab or "none",
                x, z))
            n = n + 1
        end
    end
    print("[RoseN Fixes] domesticated beefalo without a bell: "..n)
end

```



### 变体演进：ACE Anti-cheat Buckup (Mod 3412197227)
- **变体场景与切面**：收录来自工坊 Mod 3412197227 (`ACE Anti-cheat Buckup`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3412197227)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：STACK_INTERVAL (Mod 3811869823)
- **变体场景与切面**：收录来自工坊 Mod 3811869823 (`STACK_INTERVAL`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3811869823)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:wortox_soul
    if STACK_SOUL then
        AddPrefabPostInit("wortox_soul", function(inst)
            if inst.components.stackable then
                inst.components.stackable.maxsize = MAX_STACK_SIZE
            end
        end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:beefalo
if FIX_POOP_BUG then
    AddPrefabPostInit("beefalo", FixBeefaloPoop)
end

-- 堆叠成功时在物品位置生成烟雾特效
local function SpawnStackSmoke(inst)
    if not SMOKE_PUFF_ON_STACKING then return end

```



### 变体演进：自动切手杖武器 Auto Switch Cane and Weapon (Mod 3225478506)
- **变体场景与切面**：收录来自工坊 Mod 3225478506 (`自动切手杖武器 Auto Switch Cane and Weapon`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3225478506)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player_classified

AddPrefabPostInit("player_classified", function(inst)
    inst:DoTaskInTime(0.5, function(inst)
        if GLOBAL.ThePlayer then
            GLOBAL.ThePlayer:AddComponent("autoswitch")
            GLOBAL.ThePlayer.components.autoswitch:SetchipSlot(CHIP_SLOT)
            GLOBAL.ThePlayer.components.autoswitch:SetWeaponList(WEAPON_LIST)
            GLOBAL.ThePlayer.components.autoswitch:SetWeaponList(TOOL_LIST)
        end
    end)
end)

```



### 变体演进：Reforged Custom Achievements (Mod 3558878743)
- **变体场景与切面**：收录来自工坊 Mod 3558878743 (`Reforged Custom Achievements`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3558878743)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:achievement_tracker
-- overwrite reforged achievement detection to allow for achievements to use mutators less than their default value
AddComponentPostInit("achievement_tracker", function(self)

    if not _G.TheWorld or not _G.TheWorld.ismastersim then return end

    local old_CheckRequirementsForAchievement = self.CheckRequirementsForAchievement

    self.CheckRequirementsForAchievement = function(self, name, player)
        --local AchievementTracker = _G.TheWorld.components.achievement_tracker
        local REFORGED_DATA = _G.REFORGED_DATA
        local REFORGED_SETTINGS = _G.REFORGED_SETTINGS

        local settings_key = {difficulty = "difficulties", gametype = "gametypes", map = "maps", mode = "modes", mutators = "mutators", preset = "presets", waveset = "wavesets"}

        if debug_prints then
            print("Checking Requirements for " .. tostring(name))
        end

        local requirements = REFORGED_DATA.achievements[name].requirements
        if requirements.player_count and requirements.player_count < _G.TheWorld.components.stat_tracker:GetTotalActivePlayerCount() or #requirements.presets > 0 and not HasRequirement(requirements.presets, REFORGED_SETTINGS.gameplay.preset) or #requirements.characters > 0 and not HasRequirement(requirements.characters, player.prefab) then
            return false
        -- Check settings if no preset is required.
        elseif #requirements.presets <= 0 then

            if debug_prints then
                print("Checking Gameplay Settings...")
            end

            for setting,val in pairs(REFORGED_SETTINGS.gameplay) do
                if setting == "mutators" then
                    local ignore_mutators = type(requirements.mutators) ~= "table" and requirements.mutators ~= nil -- Setting the mutator requirements to anything but a table of mutators will set it to ignore all mutator values.
                    if not ignore_mutators then
                        for mutator,value in pairs(val) do

                            if debug_prints then
                                print("- mutator: " .. tostring(mutator))
                                print("- req: " .. tostring(requirements.mutators[mutator]) .. " (" .. tostring(type(requirements.mutators[mutator])) .. ")")
                                print("- val: " .. tostring(value) .. " (" .. tostring(type(value)) .. ")")
                            end

                            local values_match = requirements.mutators[mutator] and requirements.mutators[mutator] == value or nil
                            if debug_prints then print("- do values match?: " .. tostring(values_match)) end

                            -- ff = default 0, requires 1
                            -- Pass on [values match requirements] OR [values are higher than requirements]
                            -- SO
                            -- fail on [values do not match requirements] AND [values are lower than requirements]

                            if not values_match then -- [values do not match requirements]
                                if value == true or type(requirements.mutators[mutator]) == "boolean" then -- if there is a t/f mutator enabled or required

                                    if debug_prints then print("- - mutator is boolean. checking allowed mutators.") end

                                    if not table.contains(permitted_mutators, mutator) or value == false then --[Is a boolean and not in the allowed mutators (i.e. makes the game easier)]''
                                        if debug_prints then
                                            print("- requirement failed")
                                            print("- - " .. tostring(mutator) .. ": " .. tostring(value).." should be "..tostring(requirements.mutators[mutator]).." default is "..tostring(REFORGED_DATA.mutators[mutator].default_value))
                                        end
                                        return false
                                    else
                                        if debug_prints then print("- - mutator: " .. tostring(mutator) .. " is permitted") end
                                    end

                                elseif value ~= nil and requirements.mutators[mutator] ~= nil and requirements.mutators[mutator] > value then --[values are lower than requirements]
                                    if debug_prints then
                                        print("- requirement failed")
                                        print("- - " .. tostring(mutator) .. ": " .. tostring(value).." should be "..tostring(requirements.mutators[mutator]).." default is "..tostring(REFORGED_DATA.mutators[mutator].default_value))
                                    end
                                    return false

                                elseif requirements.mutators[mutator] == nil and value and value < REFORGED_DATA.mutators[mutator].default_value then --[no req is set and value is lower than default]
                                    if debug_prints then
                                        print("- requirement failed")
                                        print("- - " .. tostring(mutator) .. ": " .. tostring(value).." should be "..tostring(requirements.mutators[mutator]).." default is "..tostring(REFORGED_DATA.mutators[mutator].default_value))
                                    end
                                    return false
                                end
                            end
                        end
                    end
                elseif requirements[settings_key[setting]] and #requirements[settings_key[setting]] > 0 and not HasRequirement(requirements[settings_key[setting]], val) then

                    if debug_prints then
                        print("- requirement failed")
                        print("- - " .. tostring(setting) .. ": " .. tostring(val).." should be "..tostring(requirements[settings_key[setting]]))
                    end
                    return false
                end
            end
        end

        if debug_prints then
            print("[RCA] Achievements disabled because debug is enabled.")
            return false
        end

        return true
    end
end)

--------------------------------------------------------------------------
-- Achievements -- Function and Formatting
--------------------------------------------------------------------------
--[[ Achievement Requirements
local req = {
        player_count = nil,
        characters   = {},
        difficulties = {},
        gametypes    = {},
        maps         = {},
        modes        = {},
        mutators     = {},
        presets      = {},
        wavesets     = {},
    }
]]

--[[ Add Achievement Function
_G.AddAchievement(
"test",                     --is_valid_fn
IsNonSpectator,             --track_fn
nil,                        --track_fn
VictoryOnMatchComplete,     --on_match_complete_fn
nil,                        --max_progress
achievement_req,            --req
SetLevelXP(100),            --exp or 1000
5,                          --tier
achievement_icon,           --icon or {atlas = "images/reforged.xml", tex = "p_unknown.tex"}
victory_id,                 --id
"RCA"                       --mod
)
]]

--[[ stat_tracker -- _G.TheWorld.components.stat_tracker.stats
user_data = {
				user = {
					name = player.name,
					prefab = player.prefab,
					userid = player.userid,
					netid = player.netid,
					base = base,
					body = clothing.body,
					hands = clothing.hands,
					legs = clothing.legs,
					feet = clothing.feet,
					colour = player.colour,
					performance = player.performance,
					portrait = portrait,
				},
				beststat = {"none", nil},
				participation = true,
			},
]]

local server_mods = nil

if _G and _G.TheNet then
    server_mods = _G.TheNet:GetServerModNames()
end

--------------------------------------------------------------------------
-- Reforged
--------------------------------------------------------------------------

--[[--------Presets--------

    forge_season_1          - -     "Forge S01",
    forge_season_2          - -     "Forge S02",
    half_the_wrath          - -     "Half The Wrath",
    double_trouble          - -     "Double Trouble",
    triple_threat           - -     "Triple Threat",
    quintuple_struggle      - -     "Quintuple Struggle",
    tenfold_terror          - -     "Tenfold Terror",
    fast_but_weak           - -     "Fast/Weak",
    x2                      - -     "x2",
    x3                      - -     "x3",
    half                    - -     "1/2",
    mutated                 - -     "Mutated",
    double_doom             - -     "Double Doom",
    chaotic                 - -     "Chaotic",
    coffee                  - -     "Coffee'd",
    double_half             - -     "Double 1/2",
    half_double             - -     "Half x2",
    attack_of_titans        - -     "Attack of Titans",
    insanity                - -     "Insanity",
    custom                  - -     "Custom",
]]

--[[--------Wavesets--------

    classic                 - -
    boarilla                - -
    boarillas               - -
    rhinocebros             - -
    swineclops              - -
    default                 - -         <-- unused
    double_trouble_classic  - -       <-- no swine
    doubletrouble           - -      <-- unused
    half_the_wrath          - -
    sandbox                 - -
    randomized              - -
]]

--[[--------Difficulties--------

    normal                  - -
    hard                    - -
]]

--[[--------Gametypes--------

    forge                   - -
    classic_rlgl            - -
    rlgl                    - -    (rlglblol)
]]

--[[--------Modes--------

    forge                   - -     <-- unused
    forge_s01               - -
    forge_s02               - -
    reforged                - -
    forged_forge            - -
]]

--[[--------Mutators--------

    mob_damage_dealt            - -
    mob_damage_received         - -
    mob_health                  - -
    mob_speed                   - -
    mob_attack_rate             - -
    mob_size                    - -
    battlestandard_efficiency   - -
    no_sleep                    - -
    no_revives                  - -
    no_hud                      - -
    friendly_fire               - -
    unbreakable_shields         - -     <-- unused
    endless                     - -     
    mob_duplicator              - -
]]

--[[--------Maps--------
    lavaarena                   - -
    reforged_tiles_arena        - -
]]

--------------------------------------------------------------------------------------------------------------------------------

--------------------------
-- The Three Musketeers --
--------------------------

local hard_3p_req = {
    player_count    = 3,
    difficulties    = {"hard"},
    gametypes       = {"forge"},
    wavesets        = {"swineclops"},
}
local hard_3p_icon = {atlas = "images/hard_3p.xml", tex = "hard_3p.tex"}
_G.AddAchievement("hard_3p", IsNonSpectator, nil, VictoryOnMatchComplete, nil, hard_3p_req, SetLevelXP(15), 4, hard_3p_icon, player_count_id, "RCA")

---------------------
-- Disco for Three --
---------------------

local lights_3p_req = {
    player_count    = 3,
    gametypes       = {"rlgl"},
    wavesets        = {"swineclops"},
}
local lights_3p_icon = {atlas = "images/lights_3p.xml", tex = "lights_3p.tex"}
_G.AddAchievement("lights_3p", IsNonSpectator, nil, VictoryOnMatchComplete, nil, lights_3p_req, SetLevelXP(20), 5, lights_3p_icon, player_count_id, "RCA")

---------------
-- Got Lucky --
---------------

local randomized_req = {
    player_count    = 12,
    gametypes       = {"forge"},
    wavesets        = {"randomized"},
}
local randomized_icon = {atlas = "images/randomized.xml", tex = "randomized.tex"}
_G.AddAchievement("randomized", IsNonSpectator, nil, VictoryOnMatchComplete, nil, randomized_req, SetLevelXP(3), 2, randomized_icon, victory_id, "RCA")

-------------------
-- Hardly Random --
-------------------

local randomized_hard_req = {
    player_count    = 12,
    difficulties    = {"hard"},
    gametypes       = {"forge"},
    wavesets        = {"randomized"},
}
local randomized_hard_icon = {atlas = "images/randomized_hard.xml", tex = "randomized_hard.tex"}
_G.AddAchievement("randomized_hard", IsNonSpectator, nil, VictoryOnMatchComplete, nil, randomized_hard_req, SetLevelXP(6), 3, randomized_hard_icon, victory_id, "RCA")

---------------------
-- Go for the Neck --
---------------------

local AOT_hard_req = {
    player_count    = 12,
    difficulties    = {"hard"},
    gametypes       = {"forge"},
    wavesets        = {"swineclops"},
    --presets         = {"attack_of_titans"},
    mutators        = {
        mob_damage_dealt = 2,
        mob_size = 1.5,
        mob_health = 1.5,
    },
}
local AOT_hard_icon = {atlas = "images/aot.xml", tex = "aot.tex"}
_G.AddAchievement("AOT_hard", IsNonSpectator, nil, VictoryOnMatchComplete, nil, AOT_hard_req, SetLevelXP(20), 4, AOT_hard_icon, victory_id, "RCA")

---------------------
-- Just Hold F 2.0 --
---------------------

local function NoSpecialOnMatchComplete(lavaarenaevent, userid, achievement_name)
    local stat_tracker = _G.TheWorld.components.stat_tracker
    local total_alt_attacks = stat_tracker:GetStatTotal("altattacks")
    local total_spells = stat_tracker:GetStatTotal("spellscast")

    if lavaarenaevent.victory and total_alt_attacks <= 0 and total_spells <= 0 then
        local achievement_tracker = _G.TheWorld.components.achievement_tracker
        achievement_tracker:UpdateAchievementProgress(achievement_name, userid, true)
    end
end

local no_special_req = {
    player_count = 6,
    gametypes    = {"forge"},
    wavesets     = {"swineclops"},
}
local no_special_icon = {atlas = "images/RCA_placeholder.xml", tex = "RCA_placeholder.tex"}
_G.AddAchievement("no_special", IsNonSpectator, nil, NoSpecialOnMatchComplete, nil, no_special_req, SetLevelXP(12.5), 4, no_special_icon, victory_id, "RCA")

--------------------------------------------------------------
-- Invincible Fearless Sensual Mysterious Enchanting Vigor… --
--------------------------------------------------------------

local wes_req = {
    characters   = {"wes"},
    gametypes    = {"forge"},
    wavesets     = {"swineclops"},
}
local wes_icon = {atlas = "images/wes.xml", tex = "wes.tex"}
_G.AddAchievement("wes", IsNonSpectator, nil, VictoryOnMatchComplete, nil, wes_req, SetLevelXP(0.00285), 1, wes_icon, victory_id, "RCA")

----------------
-- Clone Army --
----------------

local function AllSameCharOnMatchComplete(lavaarenaevent, userid, achievement_name)

    local characters = {}

    for userid,player_info in pairs(_G.TheWorld.components.stat_tracker.stats) do
        local character = player_info.user_data.user.prefab
		characters[character] = (characters[character] or 0) + 1
    end

    local unique_character_count = 0
    for character,count in pairs(characters) do
        unique_character_count = unique_character_count + 1
	end

    if lavaarenaevent.victory and unique_character_count <= 1 then
        local achievement_tracker = _G.TheWorld.components.achievement_tracker
        achievement_tracker:UpdateAchievementProgress(achievement_name, userid, true)
    end
end

local all_same_char_req = {
    player_count = 6,
    gametypes    = {"forge"},
    wavesets     = {"swineclops"},
}
local all_same_char_icon = {atlas = "images/RCA_placeholder.xml", tex = "RCA_placeholder.tex"}
_G.AddAchievement("all_same_char", IsNonSpectator, nil, AllSameCharOnMatchComplete, nil, all_same_char_req, SetLevelXP(3), 3, all_same_char_icon, victory_id, "RCA")

-----------------------
-- I'll Do It Myself --
-----------------------

local solo_swine_req = {
    player_count = 1,
    gametypes    = {"forge"},
    wavesets     = {"swineclops"},
}
local solo_swine_icon = {atlas = "images/RCA_placeholder.xml", tex = "RCA_placeholder.tex"}
_G.AddAchievement("solo_swine", IsNonSpectator, nil, AllSameCharOnMatchComplete, nil, solo_swine_req, SetLevelXP(50), 5, solo_swine_icon, player_count_id, "RCA")

--------------------------
-- Lower Your Standards --
--------------------------

local function StandardsMatchComplete(lavaarenaevent, userid, achievement_name)
    local stat_tracker = _G.TheWorld.components.stat_tracker
    local standards = stat_tracker:GetStatTotal("standards", userid)
    local achievement_tracker = _G.TheWorld.components.achievement_tracker
    achievement_tracker:UpdateAchievementProgress(achievement_name, userid, nil, standards)
end
local standards_icon = {atlas = "images/RCA_placeholder.xml", tex = "RCA_placeholder.tex"}
_G.AddAchievement("standards", IsNonSpectator, nil, StandardsMatchComplete, 150, nil, SetLevelXP(2), 2, standards_icon, player_id, "RCA")

---------------------
-- High Pet Deaths --
---------------------

local function HighPetDeathsOnMatchComplete(lavaarenaevent, userid, achievement_name)
    if lavaarenaevent.victory then
        local stat_tracker = _G.TheWorld.components.stat_tracker
        local petdeaths = stat_tracker:GetStatTotal("petdeaths", userid)
        if petdeaths >= 50 then
            local achievement_tracker = _G.TheWorld.components.achievement_tracker
            achievement_tracker:UpdateAchievementProgress(achievement_name, userid, true)
        end
    end
end
local high_pet_deaths_icon = {atlas = "images/RCA_placeholder.xml", tex = "RCA_placeholder.tex"}
_G.AddAchievement("high_pet_deaths", IsNonSpectator, nil, HighPetDeathsOnMatchComplete, nil, nil, SetLevelXP(0.75), 2, high_pet_deaths_icon, player_id, "RCA")

---------------
-- Blowdarts --
---------------

local function BlowdartsMatchComplete(lavaarenaevent, userid, achievement_name)
    local stat_tracker = _G.TheWorld.components.stat_tracker
    local blowdarts = stat_tracker:GetStatTotal("blowdarts", userid)
    local achievement_tracker = _G.TheWorld.components.achievement_tracker
    achievement_tracker:UpdateAchievementProgress(achievement_name, userid, nil, blowdarts)
end

local blowdarts_progress_icon = {atlas = "images/dart_progress.xml", tex = "dart_progress.tex"}
_G.AddAchievement("blowdarts_progress", IsNonSpectator, nil, BlowdartsMatchComplete, 100000, nil, SetLevelXP(1.5), 2, blowdarts_progress_icon, player_id, "RCA")

------------------------
-- Jack of all Trades --
------------------------

--broken bc stuff wont save client side
local function UniqueCharacterOnMatchComplete_progress(lavaarenaevent, userid, achievement_name, max_player_count)

    local stat_tracker = _G.TheWorld.components.stat_tracker
    local player_count = stat_tracker:GetTotalActivePlayerCount()

    for setting,val in pairs(_G.REFORGED_SETTINGS.gameplay) do
        --TODO
    end

    -- must win
    if not lavaarenaevent.victory or (max_player_count and player_count > max_player_count) then return end

    --TheSim:SetPersistentString("reforged_achievements_server", json.encode(achievements), false, function() Debug:Print("Achievements Progress Saved", "log") end)
    --TheSim:SetPersistentString(filename, data, false, callback)

    --TheSim:GetPersistentString(filename, onreadtimefile)

    _G.TheSim:GetPersistentString(achievement_name, function(load_success, data)

        local characters = {}
        if load_success and data ~= nil then
            local status, prev_characters = _G.pcall( function() return _G.json.decode(data) end )
            if status and prev_characters then
                characters = prev_characters
            end
        end

        local curr_character = nil
        for id, player_info in pairs(_G.TheWorld.components.stat_tracker.stats) do
            if id == userid then
                curr_character = player_info.user_data.user.prefab
            end
        end

        if not characters[userid] then
            characters[userid] = {}
        end

        if curr_character == nil then
            print("[RCA] Achievement: "..tostring(achievement_name).." - Cannot find the player's character")
        end

        if curr_character and not table.contains(characters[userid], curr_character) then
            table.insert(characters[userid], curr_character)
            local achievement_tracker = _G.TheWorld.components.achievement_tracker
            achievement_tracker:UpdateAchievementProgress(achievement_name, userid, nil, 1)
        else
            print("[RCA] Achievement: "..tostring(achievement_name).." - Character already counted or not found")
        end

        --_G.TheSim:SetPersistentString(achievement_name, _G.json.encode(characters), false, function() print("[RCA] Achievement: "..tostring(achievement_name).." - Progress updated successfully") end)

        if not _G.TheNet:IsDedicated() then
            _G.TheSim:SetPersistentString(tostring(achievement_name).."_client", _G.json.encode(characters), false, function() print("[RCA] Achievement: "..tostring(achievement_name).." - Progress updated successfully") end)
        end

        _G.TheSim:SetPersistentString(achievement_name, _G.json.encode(characters), false, function() print("[RCA] Achievement: "..tostring(achievement_name).." - Progress updated successfully") end)

    end, false)
end

local function UniqueCharacterOnMatchComplete_progress_6p(lavaarenaevent, userid, achievement_name)
    UniqueCharacterOnMatchComplete_progress(lavaarenaevent, userid, achievement_name)
end

local diff_characters_swine_progress_req = {
    player_count = 6,
    gametypes    = {"forge"},
    wavesets     = {"swineclops"},
}
local diff_characters_swine_progress_icon = {atlas = "images/RCA_placeholder.xml", tex = "RCA_placeholder.tex"}
--_G.AddAchievement("diff_characters_swine_progress", IsNonSpectator, nil, UniqueCharacterOnMatchComplete_progress_6p, 12, diff_characters_swine_progress_req, SetLevelXP(6), 2, diff_characters_swine_progress_icon, victory_id, "RCA")

-------------------
-- Master of All --
-------------------

local function UniqueCharacterOnMatchComplete_progress_2p(lavaarenaevent, userid, achievement_name)
    UniqueCharacterOnMatchComplete_progress(lavaarenaevent, userid, achievement_name, 2)
end

local diff_characters_swine_progress_2p_req = {
    player_count = 2,
    gametypes    = {"forge"},
    wavesets     = {"swineclops"},
}
local diff_characters_swine_progress_icon = {atlas = "images/RCA_placeholder.xml", tex = "RCA_placeholder.tex"}
--_G.AddAchievement("diff_characters_swine_progress_2p", IsNonSpectator, nil, UniqueCharacterOnMatchComplete_progress_2p, 6, diff_characters_swine_progress_2p_req, SetLevelXP(30), 5, diff_characters_swine_progress_icon, victory_id, "RCA")

----------------------
-- Immovable Object --
----------------------

local highest_max_hp = {}
local function PlayerMaxHealth(inst, data)
    local user_id = _G.TheNet:GetUserID()
    if user_id == nil then return end

    --print(inst:GetDisplayName()..": My stats changed! ("..tostring(data)..")")
    local max_hp = nil
    if inst and inst.components and inst.components.health then
        max_hp = inst.components.health:GetMaxWithPenalty()
    end
    if highest_max_hp[user_id] == nil and max_hp ~= nil then
        highest_max_hp[user_id] = max_hp
    end

    --print("Prev Highest HP: "..tostring(highest_max_hp[user_id]))
    --print("Curr Max HP: "..tostring(inst.components.health:GetMaxWithPenalty()))

	if max_hp ~= nil and max_hp > highest_max_hp[user_id] then
        --print("Higher Max HP Detected - "..tostring(max_hp))
        highest_max_hp[user_id] = max_hp
	end
end

--self.inst:PushEvent("healthdelta", { oldpercent = old_percent, newpercent = self:GetPercent(), overtime = overtime, cause = cause, afflicter = afflicter, amount = amount })
-- AddPlayerPostInit(function(inst)
--     inst:ListenForEvent("healthdelta", PlayerMaxHealth, inst)
-- end)

local function MaxHPMatchComplete(lavaarenaevent, userid, achievement_name, target_max_hp)
    local max_hp = highest_max_hp[userid]
    local achievement_tracker = _G.TheWorld.components.achievement_tracker

    if max_hp and target_max_hp and max_hp >= target_max_hp then
        achievement_tracker:UpdateAchievementProgress(achievement_name, userid, nil, true)
    end
end

local function MaxHPMatchComplete_500(lavaarenaevent, userid, achievement_name)
    MaxHPMatchComplete(lavaarenaevent, userid, achievement_name, 500)
end

local hp_500_icon = {atlas = "images/RCA_placeholder.xml", tex = "RCA_placeholder.tex"}
--_G.AddAchievement("hp_500", IsNonSpectator, nil, MaxHPMatchComplete_500, nil, nil, SetLevelXP(0.25), 2, hp_500_icon, player_id, "RCA")

------------------------------------
-- And The Audience Goes Mild!!!! --
------------------------------------

local function GetPlayersClientTable() -- from reforged
    local clients = _G.TheNet:GetClientTable() or {}
    if not _G.TheNet:GetServerIsClientHosted() then
        for i, v in ipairs(clients) do
            if v.performance ~= nil then
                table.remove(clients, i) -- remove "host" object
                break
            end
        end
    end
    return clients
end


-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:roach_beetle

    -- AddPrefabPostInit("roach_beetle", function(inst)
    --     local function OnPickup()
    --             if is_starved then
    --                 is_starved = false
    --                 inst:RemoveEventCallback("onpickup", OnPickup)
    --             end
    --         end
    --     inst:ListenForEvent("onpickup", OnPickup)
    -- end)

```



### 变体演进：Magiluminescence Auto Add Nightmarefuel (Mod 3575676768)
- **变体场景与切面**：收录来自工坊 Mod 3575676768 (`Magiluminescence Auto Add Nightmarefuel`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3575676768)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:inventoryitem_classified

AddPrefabPostInit("inventoryitem_classified", function(inst)
    inst:DoTaskInTime(0, function() fn(inst) end)

end)

```



### 变体演进：my map icons(server) (Mod 2071086898)
- **变体场景与切面**：收录来自工坊 Mod 2071086898 (`my map icons(server)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2071086898)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:beefalo
--添加牛的图标
AddPrefabPostInit("beefalo", function(inst)
	inst.MiniMapEntity:SetEnabled(true)
	local oldUpdateDomestication=inst.UpdateDomestication
	inst.UpdateDomestication=function(inst)
		if oldUpdateDomestication then
			oldUpdateDomestication(inst)
		end
		inst.MiniMapEntity:SetEnabled(true)
	end
end)

```



### 变体演进：绝望石剑 (Mod 3771294586)
- **变体场景与切面**：收录来自工坊 Mod 3771294586 (`绝望石剑`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3771294586)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:dreadstone_sword

AddPrefabPostInit("dreadstone_sword", function(inst)
    if DURABILITY == 0 then
        if inst.components.finiteuses ~= nil then inst:RemoveComponent("finiteuses") end
    else
        if inst.components.finiteuses == nil then inst:AddComponent("finiteuses") end
        inst.components.finiteuses:SetMaxUses(DURABILITY)
        inst.components.finiteuses:SetUses(DURABILITY)
    end

       -- 攻击范围与位面伤害
    inst:DoTaskInTime(0.5, function()
        if inst.components.weapon ~= nil then
            if ATTACK_RANGE == "default" then
                inst.components.weapon:SetRange(1, 3)
            else
                inst.components.weapon:SetRange(0.5,1)
            end
        end
        if PLANAR_DAMAGE > 0 and inst.components.planardamage ~= nil then
            inst.components.planardamage:SetBaseDamage(PLANAR_DAMAGE)
        end
    end)

    -- 可砍树功能
    if CHOP_ENABLED then
        -- 添加工具组件
        if inst.components.tool == nil then
            inst:AddComponent("tool")
        end
        inst.components.tool:SetAction(GLOBAL.ACTIONS.CHOP, 1.5)  -- 砍树效率
        inst.components.tool:EnableToughWork(true)  -- 可以砍硬质树木
        
        -- 设置砍树耐久消耗
        if inst.components.finiteuses ~= nil then
            inst.components.finiteuses:SetConsumption(GLOBAL.ACTIONS.CHOP, 1)
        end
    end

    -- 自动恢复耐久
    if REGEN_ENABLED then
        local function DoRegen()
            if inst.components.finiteuses ~= nil and inst.components.finiteuses.current <= 0 then return end
            local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
            if owner == nil or not owner:IsValid() then return end
            local finiteuses = inst.components.finiteuses
            if finiteuses == nil or finiteuses.current >= finiteuses.total then return end
            if owner.components.sanity ~= nil and owner.components.sanity.current > 0 then
                local rate = 1 / Lerp(1 / TUNING.ARMOR_DREADSTONE_REGEN_MAXRATE, 1 / TUNING.ARMOR_DREADSTONE_REGEN_MINRATE, owner.components.sanity:GetPercent())
                finiteuses:SetUses(math.min(finiteuses.current + finiteuses.total * rate, finiteuses.total))
            end
        end

        inst:DoPeriodicTask(1, function()
            if inst.components.equippable and inst.components.equippable:IsEquipped() then
                if (GetTime() - (inst._last_attack_time or 0)) > 2 then
                    DoRegen()
                end
            end
        end)
    end

    -- 绝望石修复
    if DREADSTONE_REPAIR then
        inst:AddComponent("trader")
        inst.components.trader:SetAcceptTest(function(inst, item)
            return item.prefab == "dreadstone"
        end)
        inst.components.trader.onaccept = function(inst, giver, item)
            local current = inst.components.finiteuses.current
            local max = inst.components.finiteuses.total
            inst.components.finiteuses:SetUses(math.min(current + max * 0.5, max))
        end
    end

    -- 耐久归零删除
    inst:DoPeriodicTask(0.5, function()
        if inst.components.finiteuses ~= nil and inst.components.finiteuses.current <= 0 then
            inst:Remove()
        end
    end)

    -- 掉血速度
    inst:DoTaskInTime(0.5, function()
        if inst.components.equippable == nil then return end
        inst:ListenForEvent("equipped", function(inst, data)
            if inst._health_task ~= nil then inst._health_task:Cancel(); inst._health_task = nil end
            if BLEED_INTERVAL > 0 then
                local owner = data.owner
                inst._health_task = inst:DoPeriodicTask(BLEED_INTERVAL, function()
                    if owner:IsValid() and owner.components.health ~= nil then
                        local hp = owner.components.health:GetPercent()
                        if hp >= 0.25 then owner.components.health:DoDelta(-1) end
                    end
                end)
            end
        end)
        inst:ListenForEvent("unequipped", function(inst)
            if inst._health_task ~= nil then inst._health_task:Cancel(); inst._health_task = nil end
        end)
    end)
end)

```



### 变体演进：魔光护符耐久归零不消失 (Mod 3759813027)
- **变体场景与切面**：收录来自工坊 Mod 3759813027 (`魔光护符耐久归零不消失`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3759813027)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:yellowamulet

AddPrefabPostInit("yellowamulet", KeepYellowAmuletWhenEmpty)

```



### 变体演进：Disable/Config Weed Self Sprouting and Spreading (Mod 2464239430)
- **变体场景与切面**：收录来自工坊 Mod 2464239430 (`Disable/Config Weed Self Sprouting and Spreading`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2464239430)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:farming_manager

AddComponentPostInit("farming_manager", function(self, inst) 
	if not can_spawn then
		self:StopWatchingWorldState("season", 1)
		self._UpdateWeedSpawning = function() end
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:weed_plants
if not any_spread or not sprouted_spread or nutrient_consumption ~= GLOBAL.TUNING.FARM_PLANT_CONSUME_NUTRIENT_LOW then
	AddPrefabPostInit("weed_plants", function(inst)
		inst:ListenForEvent("on_planted", function(inst, data)
			if inst.weed_def then
				if not data.doer then
					if not sprouted_spread then
						inst.weed_def.spread = nil
					end
					if inst.weed_def.nutrient_consumption then
						inst.weed_def.nutrient_consumption = nutrient_consumption
					end
				end
				else if not any_spread then
					inst.weed_def.spread = nil
				end
			end
		end) 
	end)

```



### 变体演进：骨甲倒计时 (Mod 3502601307)
- **变体场景与切面**：收录来自工坊 Mod 3502601307 (`骨甲倒计时`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3502601307)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:armorskeleton
-- 骨甲预制体实例化后钩子
AddPrefabPostInit("armorskeleton",function(self)
    -- 输出当前骨甲预制体
    Log("骨甲预制体实例化后钩子，骨甲GUID:" .. self.GUID)
    -- 记录当前耐久度
    self.preTrackpercent = 0

    -- cd开始时间
    self.rechargeTimeStart = GetTime()
    -- cd结束时间
    self.rechargeTimeEnd = self.rechargeTimeStart

    -- 获取总cd时间
    function self:GetRechargeDuration()
        return self.rechargeTimeEnd - self.rechargeTimeStart
    end

    -- 获取剩余cd时间
    function self:GetRemainingRechargeTime()
        return self.rechargeTimeEnd - GetTime()
    end

    -- 获取cd完成百分比
    function self:GetRechargeCompletePercent()
        -- 分母为0，也返回1
        if self:GetRechargeDuration() == 0 then
            return 1
        end

        return 1 - (self:GetRemainingRechargeTime() / self:GetRechargeDuration())
    end

    -- 是否在cd中
    function self:IsRecharging()
        return GetTime() < self.rechargeTimeEnd
    end

    -- 开始cd，单位s
    function self:StartRecharge(duration)
        Log("开始cd，骨甲GUID:" .. self.GUID .. "，持续时间:" .. duration)
        self.rechargeTimeStart = GetTime()
        self.rechargeTimeEnd = self.rechargeTimeStart + duration

        self:PushEvent("set_charge_time", self:GetRechargeDuration())
        self:PushEvent("set_charge_percent", self:GetRechargeCompletePercent())
    end
    
    -- 停止cd
    function self:StopRecharge()
        self.rechargeTimeStart = GetTime()
        self.rechargeTimeEnd = self.rechargeTimeStart

        self:PushEvent("set_charge_time", self:GetRechargeDuration())
        self:PushEvent("set_charge_percent", self:GetRechargeCompletePercent())
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:inventoryitem_classified
-- 物品分类器初始化后钩子，在这个钩子里执行我理解是需要确保物品的网络数据已经同步，然后可以开始进行初始化了
AddPrefabPostInit("inventoryitem_classified", function(inst)
    inst:DoTaskInTime(0, function()
        local invitem = inst.entity:GetParent()
        if invitem and invitem.prefab == "armorskeleton" then
            -- 当前这个物品是骨甲
            Log("物品分类器骨甲钩子，骨甲GUID:" .. invitem.GUID)

            -- 初始化骨甲耐久度
            invitem.preTrackpercent = invitem.replica.inventoryitem.classified.percentused:value()
            -- 监听骨甲耐久度变化
            inst:ListenForEvent("percentuseddirty", function()
                -- 如果骨甲耐久度变少了，说明被打了，进入冷却
                if invitem.preTrackpercent > invitem.replica.inventoryitem.classified.percentused:value() then
                    Log("骨甲耐久变化，进入冷却，骨甲GUID:" .. invitem.GUID)
                    if hasSound then
                        inst:DoTaskInTime(TUNING.ARMOR_SKELETON_COOLDOWN, function() PlaySoundOnRecharge(invitem) end)
                    end

                    invitem:StartRecharge(TUNING.ARMOR_SKELETON_COOLDOWN)
                end

                -- 更新骨甲耐久度
                invitem.preTrackpercent = invitem.replica.inventoryitem.classified.percentused:value()
            end)
        end
    end)
end)

```



### 变体演进：行为排队论 (Mod 2536588263)
- **变体场景与切面**：收录来自工坊 Mod 2536588263 (`行为排队论`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2536588263)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller
local always_clear_queue = GetModConfigData("always_clear_queue")
AddComponentPostInit("playercontroller", function(self, inst)
    if inst ~= _G.ThePlayer then return end
    ThePlayer = _G.ThePlayer
    TheWorld = _G.TheWorld
    ActionQueuerInit()

    local PlayerControllerOnControl = self.OnControl
    self.OnControl = function(self, control, down)
        local mouse_control = mouse_controls[control]
        if mouse_control ~= nil then
            if down then
                if TheInput:IsAqModifierDown(action_queue_key) then
                    local target = TheInput:GetWorldEntityUnderMouse()
                    if target and target:HasTag("fishable") and not inst.replica.rider:IsRiding()
                      and inst.replica.inventory:EquipHasTag("fishingrod") then
                        ActionQueuer:StartAutoFisher(target)
                    elseif not ActionQueuer.auto_fishing then
                        ActionQueuer:OnDown(mouse_control)
                    end
                    return
                end
            else
                ActionQueuer:OnUp(mouse_control)
            end
        end
        PlayerControllerOnControl(self, control, down)
        if down and ActionQueuer.action_thread and not ActionQueuer.selection_thread and InGame()
          and (interrupt_controls[control] or mouse_control ~= nil and not TheInput:GetHUDEntityUnderMouse()) then
            ActionQueuer:ClearActionThread()
            if always_clear_queue or control == CONTROL_ACTION then
                ActionQueuer:ClearSelectedEntities()
            end
        end
    end
    local PlayerControllerIsControlPressed = self.IsControlPressed
    self.IsControlPressed = function(self, control)
        if control == CONTROL_FORCE_INSPECT and ActionQueuer.action_thread then return false end
        return PlayerControllerIsControlPressed(self, control)
    end
end)

AddClassPostConstruct("components/builder_replica", function(self)
    local BuilderReplicaMakeRecipeFromMenu = self.MakeRecipeFromMenu
    self.MakeRecipeFromMenu = function(self, recipe, skin)
        last_recipe, last_skin = recipe, skin
        if not ActionQueuer.action_thread and TheInput:IsAqModifierDown(action_queue_key)
          and not recipe.placer and self:CanBuild(recipe.name) then
            ActionQueuer:RepeatRecipe(self, recipe, skin)
        else
            BuilderReplicaMakeRecipeFromMenu(self, recipe, skin)
        end
    end
    local BuilderReplicaMakeRecipeAtPoint = self.MakeRecipeAtPoint
    self.MakeRecipeAtPoint = function(self, recipe, pt, rot, skin)
        last_recipe, last_skin = recipe, skin
        BuilderReplicaMakeRecipeAtPoint(self, recipe, pt, rot, skin)
    end
end)

AddComponentPostInit("highlight", function(self, inst)
    local HighlightHighlight = self.Highlight
    self.Highlight = function(self, ...)
        if ActionQueuer.selection_thread or ActionQueuer:IsSelectedEntity(inst) then return end
        HighlightHighlight(self, ...)
    end
    local HighlightUnHighlight = self.UnHighlight
    self.UnHighlight = function(self)
        if ActionQueuer:IsSelectedEntity(inst) then return end
        HighlightUnHighlight(self)
    end
end)
--for minimizing the memory leak in geo
--hides the geo grid during an action queue
AddComponentPostInit("placer", function(self, inst)
    local PlacerOnUpdate = self.OnUpdate
    self.OnUpdate = function(self, ...)
        self.disabled = ActionQueuer.action_thread ~= nil
        PlacerOnUpdate(self, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:highlight

AddComponentPostInit("highlight", function(self, inst)
    local HighlightHighlight = self.Highlight
    self.Highlight = function(self, ...)
        if ActionQueuer.selection_thread or ActionQueuer:IsSelectedEntity(inst) then return end
        HighlightHighlight(self, ...)
    end
    local HighlightUnHighlight = self.UnHighlight
    self.UnHighlight = function(self)
        if ActionQueuer:IsSelectedEntity(inst) then return end
        HighlightUnHighlight(self)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:placer
--hides the geo grid during an action queue
AddComponentPostInit("placer", function(self, inst)
    local PlacerOnUpdate = self.OnUpdate
    self.OnUpdate = function(self, ...)
        self.disabled = ActionQueuer.action_thread ~= nil
        PlacerOnUpdate(self, ...)
    end
end)

```



### 变体演进：Golden Hammer (Mod 3411817995)
- **变体场景与切面**：收录来自工坊 Mod 3411817995 (`Golden Hammer`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3411817995)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:goldenhammer
    
    AddPrefabPostInit("goldenhammer", function(inst)
        if not TheWorld.ismastersim then
            return
        end
    
        local _OnEquip = inst.components.equippable.onequipfn
        local _OnUnequip = inst.components.equippable.onunequipfn
    
        local function OnEquip(inst, owner)
            inst:ListenForEvent("working", Working, owner)
            _OnEquip(inst, owner)
        end
    
        local function OnUnequip(inst, owner)
            inst:RemoveEventCallback("working", Working, owner)
            _OnUnequip(inst, owner)
        end
    
        inst.components.equippable:SetOnEquip(OnEquip)
        inst.components.equippable:SetOnUnequip(OnUnequip)
    end)

```



### 变体演进：移除黑屏 / No Black Screen (Mod 3610948444)
- **变体场景与切面**：收录来自工坊 Mod 3610948444 (`移除黑屏 / No Black Screen`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3610948444)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player_classified
--https://steamcommunity.com/sharedfiles/filedetails/?id=2948704246
AddPrefabPostInit("player_classified", function(inst)
    inst:DoTaskInTime(1, function(inst)
		if inst.event_listeners and inst.event_listeners.playerfadedirty and inst.event_listeners.playerfadedirty[inst] then
			for i, _ in ipairs(inst.event_listeners.playerfadedirty[inst]) do
				inst.event_listeners.playerfadedirty[inst][i] = function(...)
					return
				end
			end
		end
		if inst.event_listening and inst.event_listening.playerfadedirty and inst.event_listening.playerfadedirty[inst] then
			for i, _ in ipairs(inst.event_listening.playerfadedirty[inst]) do
				inst.event_listening.playerfadedirty[inst][i] = function(...)
					return
				end
			end
		end
    end)
end)

```



### 变体演进：Flaire自定义补丁 (Mod 3823885103)
- **变体场景与切面**：收录来自工坊 Mod 3823885103 (`Flaire自定义补丁`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3823885103)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:flaire

AddPrefabPostInit("flaire", function(inst)
    if G.TheWorld == nil or not G.TheWorld.ismastersim then return end
    if inst._flaire_eat_patch_done then return end
    if MODE ~= "dynamic" then
        inst.OnWontEatFood = MakeRefuseFoodSay(inst, function() return THRESHOLD end)
        inst._flaire_eat_patch_done = true
        return
    end
    local attempts = 0
    local function TryPatchDynamicEat()
        if not inst:IsValid() then return end

        local eater = inst.components.eater
        if eater == nil then
            attempts = attempts + 1
            if attempts > 20 then
                T.Log("动态进食补丁失败：eater 组件未出现，回退到固定阈值")
                G.TUNING.FLAIRE_REFUSE_FOOD_HUNGER =
                    (inst.components.hunger ~= nil and inst.components.hunger.max) or HUNGER_MAX
                return
            end
            inst:DoTaskInTime(0.1, TryPatchDynamicEat)
            return
        end

        local oldPrefersToEat = eater.PrefersToEat
        eater.PrefersToEat = function(self, food, ...)
            local hunger = inst.components.hunger
            local edible = food ~= nil and food.components ~= nil and food.components.edible or nil
            if hunger == nil or edible == nil then
                if oldPrefersToEat == nil then return true end
                return oldPrefersToEat(self, food, ...)
            end

            local hungerValue = edible.hungervalue or 0
            local refuseFood = (hungerValue < 0) or ((hunger.current + hungerValue) > hunger.max)
            if refuseFood then
                inst.flaire_refuseFoodData = { food = food }
            else
                inst.flaire_refuseFoodData = nil
            end
            local base = true
            if oldPrefersToEat ~= nil then
                local res = oldPrefersToEat(self, food, ...)
                if res ~= nil then base = res end
            end
            return base and not refuseFood
        end

        inst.OnWontEatFood = MakeRefuseFoodSay(inst, function()
            return (inst.components.hunger ~= nil and inst.components.hunger.max) or HUNGER_MAX
        end)

        inst._flaire_eat_patch_done = true
        T.Log("动态进食补丁已应用（拒绝阈值跟随 hunger.max）")
    end

    TryPatchDynamicEat()
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:voidcloth_scythe
-- 镰刀就没有 flaire_spellfocus → 变剑后缺 flaire_spellfocus_sword 标签 → 不能施法。
AddPrefabPostInit("voidcloth_scythe", function(inst)
    if G.TheWorld == nil or not G.TheWorld.ismastersim then return end
    if inst.components.flaire_spellfocus == nil then
        commonFns.InitComponent(inst, "flaire_spellfocus", function(spellFocus)
            spellFocus:SetIsSword(inst.flaire_isSword == true)
        end)
    end
end)

```



### 变体演进：WX-78 Scan Meter (Mod 3793272421)
- **变体场景与切面**：收录来自工坊 Mod 3793272421 (`WX-78 Scan Meter`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3793272421)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:wx78_scanner

AddPrefabPostInit("wx78_scanner", function(inst)
	-- client_only_mod, so this only runs in a client process; on a listen-server
	-- host that process is also the client and still wants the readout.
	if _G.TheWorld ~= nil and _G.TheWorld.ismastersim and _G.TheNet:IsDedicated() then
		return
	end
	ClientScannerPostInit(inst)
end)

```



### 变体演进：Rechargeable Touch Stones (Mod 2854593752)
- **变体场景与切面**：收录来自工坊 Mod 2854593752 (`Rechargeable Touch Stones`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2854593752)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:touchstonetracker

AddComponentPostInit("touchstonetracker", function(self)
    function self:RepairTouchStone(touchstone)
        local id = touchstone and touchstone.GetTouchStoneID and touchstone:GetTouchStoneID() or 0
        if id > 0 then
            self.used[id] = nil
            if self.inst.player_classified then
                local used = {}
                for k, v in pairs(self.used) do
                    table.insert(used, k)
                end
                self.inst.player_classified:SetUsedTouchStones(used)
            end
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:resurrectionstone

AddPrefabPostInit("resurrectionstone", function(inst)
    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(accepttest)
    inst.components.trader.onaccept = onacceptitem
    inst.components.trader.acceptnontradable = true
end)

```



### 变体演进：tumbleweedspawner_visual (Mod 2982741818)
- **变体场景与切面**：收录来自工坊 Mod 2982741818 (`tumbleweedspawner_visual`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2982741818)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:tumbleweedspawner
AddPrefabPostInit("tumbleweedspawner",function(inst)
    -- 일부러 딜래이를 줘서 스포너가 배치되면 찾도록 이렇게 만듬
    inst:DoTaskInTime(1,function(inst)
        local x, _, z = inst.Transform:GetWorldPosition()
        local dummy = GLOBAL.SpawnPrefab("tumbleweed_dummy")
        dummy.Transform:SetPosition(x, 0, z)
    end)
end)

```



### 变体演进：新手新神器_礦工帽 (Mod 3116005144)
- **变体场景与切面**：收录来自工坊 Mod 3116005144 (`新手新神器_礦工帽`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3116005144)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:minerhat

AddPrefabPostInit("minerhat", minerhatfn);


-- 照明
local function minerhatlightfn(inst)
    inst.Light:SetFalloff(0.7)
    inst.Light:SetIntensity(1)
    inst.Light:SetRadius(40)
    inst.Light:SetColour(255 / 255, 255 / 255, 236 / 255)

    inst.entity:SetPristine()

    inst.persists = false
    return inst
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:minerhatlight

AddPrefabPostInit("minerhatlight", minerhatlightfn);

```



### 变体演进：Mod 3816773664 (Mod 3816773664)
- **变体场景与切面**：收录来自工坊 Mod 3816773664 (`Mod 3816773664`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3816773664)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:wx78_inventorycontainer

AddPrefabPostInit("wx78_inventorycontainer", function(inst)
    if not _G.TheWorld.ismastersim then
        return
    end

    local function RefreshBackupBodyOpenState(inst)
        if inst.components.container == nil then
            return
        end

        if GetBackupBodyOwner(inst) ~= nil then
            inst.components.container.canbeopened = true
        end
    end

    if inst.SetPowered ~= nil then
        local old_SetPowered = inst.SetPowered
        inst.SetPowered = function(inst, powered, ...)
            local results = {
                old_SetPowered(inst, powered, ...)
            }

            RefreshBackupBodyOpenState(inst)
            return _G.unpack(results)
        end
    end

    inst:ListenForEvent("onputininventory", function(inst, owner)
        if owner ~= nil and owner:HasTag("wx78_backupbody") then
            RefreshBackupBodyOpenState(inst)
        end
    end)

    inst:DoTaskInTime(0, function()
        if inst:IsValid() then
            RefreshBackupBodyOpenState(inst)
        end
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:wx78_backupbody

AddPrefabPostInit("wx78_backupbody", function(inst)
    if not _G.TheWorld.ismastersim then
        return
    end

    local workable = inst.components.workable
    if workable == nil then
        return
    end

    local old_Destroy = workable.Destroy
    workable.Destroy = function(workable, destroyer, ...)
        if destroyer ~= nil
            and destroyer.prefab == "winona_catapult_projectile"
            and destroyer:HasTag("toughworker") then
            return
        end

        return old_Destroy(workable, destroyer, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:reskin_tool

AddPrefabPostInit("reskin_tool", function(inst)
    if not _G.TheWorld.ismastersim then
        return
    end

    local spellcaster = inst.components.spellcaster
    if spellcaster == nil then
        return
    end

    local old_can_cast_fn = spellcaster.can_cast_fn
    local old_spell_fn = spellcaster.spell

    spellcaster:SetCanCastFn(function(doer, target, pos, tool)
        if target ~= nil and target.prefab == "wx78_backupbody" then
            if not CanUseBackupBodyReskin(doer, target) then
                return false
            end
            local skinner = GetBackupBodySkinner(target)
            local nextskin = GetNextBackupBodySkin(doer.userid, skinner:GetClothing().base)
            return nextskin ~= nil and nextskin ~= skinner:GetClothing().base
        end
        if old_can_cast_fn ~= nil then
            return old_can_cast_fn(doer, target, pos, tool)
        end
        return false
    end)

    spellcaster:SetSpellFn(function(tool, target, pos, doer)
        if target ~= nil and target.prefab == "wx78_backupbody" then
            if not CanUseBackupBodyReskin(doer, target) then
                return
            end
            local skinner = GetBackupBodySkinner(target)
            local current = skinner:GetClothing().base
            local nextskin = GetNextBackupBodySkin(doer.userid, current)
            if nextskin ~= nil and nextskin ~= current
                and ApplyBackupBodySkin(target, doer.userid, nextskin) then
                target._wx78_backupbody_swept = true
                target._wx78_backupbody_swept_userid = doer.userid
                local skinfx = _G.SKIN_FX_PREFAB[tool:GetSkinName()]
                local fx = _G.SpawnPrefab(skinfx ~= nil and skinfx[1] or "explode_reskin")
                if fx ~= nil then
                    fx.Transform:SetPosition(target.Transform:GetWorldPosition())
                end
            end
            return
        end
        if old_spell_fn ~= nil then
            return old_spell_fn(tool, target, pos, doer)
        end
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:socket_shadow_harvester

    AddComponentPostInit("socket_shadow_harvester", function(socket)
        if not GLOBAL.TheWorld.ismastersim or socket._wx78_extra_plants_v3 then
            return
        end
        socket._wx78_extra_plants_v3 = true

        local original = socket.TryToFindItem
        if type(original) ~= "function" then
            return
        end

        socket.TryToFindItem = function(self, ...)
            local item = original(self, ...)
            if item ~= nil then
                return item
            end

            local owner = self.inst
            if owner == nil or not owner:IsValid() or self.GetHarvestRadius == nil then
                return nil
            end

            local radius = self:GetHarvestRadius()
            if radius == nil or radius <= 0 then
                return nil
            end

            local x, y, z = owner.Transform:GetWorldPosition()
            local candidates = GLOBAL.TheSim:FindEntities(x, y, z, radius, PICKABLE_TAGS, EXCLUDE_TAGS)
            local best, bestdist = nil, nil

            for _, plant in ipairs(candidates) do
                if IsExtraHarvestTarget(plant, self) then
                    local distance = owner:GetDistanceSqToInst(plant)
                    if bestdist == nil or distance > bestdist then
                        best, bestdist = plant, distance
                    end
                end
            end

            return best
        end
    end)

end

```



### 变体演进：骑牛状态显示 (Mod 3699691567)
- **变体场景与切面**：收录来自工坊 Mod 3699691567 (`骑牛状态显示`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3699691567)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player_classified
-- 喂食重置计时器
AddPrefabPostInit("player_classified", function(pc)
    pc:DoTaskInTime(_G.FRAMES * 2, function()
        if pc._parent == _G.ThePlayer then
            pc:ListenForEvent("isperformactionsuccessdirty", function(pc)
                local player = _G.ThePlayer
                if player and player.replica.rider and player.replica.rider:IsRiding() then
                    if player.AnimState:IsCurrentAnimation("graze_loop") then
                        player:PushEvent("BeefaloFeedReset")
                    end
                end
            end)
        end
    end)
end)

```



### 变体演进：骑牛状态显示 (Mod 3766864892)
- **变体场景与切面**：收录来自工坊 Mod 3766864892 (`骑牛状态显示`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3766864892)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player_classified
-- 喂食重置计时器（延迟两帧检测动画，确保 AnimState 已更新，兼容地面/洞穴）
AddPrefabPostInit("player_classified", function(pc)
    pc:DoTaskInTime(_G.FRAMES * 2, function()
        if pc._parent ~= _G.ThePlayer then return end

        pc:ListenForEvent("isperformactionsuccessdirty", function()
            if IsModOff() then return end
            local player = _G.ThePlayer
            if not (player and player.replica.rider and player.replica.rider:IsRiding()) then return end

            -- 延迟一帧，确保 AnimState 已切换到喂食动画
            player:DoTaskInTime(0, function()
                if player.AnimState:IsCurrentAnimation("graze_loop") then
                    player:PushEvent("BeefaloFeedReset")
                end
            end)
        end)
    end)
end)

```



### 变体演进：Lightning Rod for Moonstorm (Mod 2873257326)
- **变体场景与切面**：收录来自工坊 Mod 2873257326 (`Lightning Rod for Moonstorm`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2873257326)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:moonstormmanager
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddComponentPostInit("moonstormmanager", function(self)
    local _activeplayers = UpvalueHacker.GetUpvalue(self.DoTestForLightning, "_activeplayers")
    local customcheckfn = UpvalueHacker.GetUpvalue(self.DoTestForLightning, "customcheckfn")
    local getlightningtime = UpvalueHacker.GetUpvalue(self.DoTestForLightning, "getlightningtime")

    function self.DoTestForLightning()
        local candidates = {}
        for i, v in ipairs(_activeplayers) do
            local pt = _G.Vector3(v.Transform:GetWorldPosition())
            if _G.TheWorld.net.components.moonstorms and _G.TheWorld.net.components.moonstorms:IsPointInMoonstorm(pt) then
                table.insert(candidates,v)
            end
        end

        if #candidates > 0 then
        	local candidate = candidates[math.random(1,#candidates)]
            local pt = _G.Vector3(candidate.Transform:GetWorldPosition())
            local pos = _G.FindWalkableOffset(pt, math.random()*2*_G.PI, 5 + math.random()* 10, 16, nil, nil, customcheckfn, nil, nil)

            local closest_rod = nil
            local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 40, {"lightningrod", "structure"}, { "playerghost", "INLIMBO" })
            for _, v in pairs(ents) do
                if closest_rod == nil and v.prefab == "lightning_rod" then
                    closest_rod = v
                end
            end

            if closest_rod ~= nil then
                pt = closest_rod:GetPosition()
                pos = _G.Vector3(0, 0, 0)
                closest_rod:PushEvent("lightningstrike")
            end

            if pos then
                local spark = _G.SpawnPrefab("moonstorm_lightning")
                spark.Transform:SetPosition(pt.x + pos.x,0,pt.z + pos.z)
            end
        end
        self.moonstorm_lightning_task = self.inst:DoTaskInTime(getlightningtime(), function() self:DoTestForLightning() end)
    end

    UpvalueHacker.SetUpvalue(self.DoTestForLightning, self.DoTestForLightning, "self.DoTestForLightning")
end)

```



### 变体演进：… (Mod 3662273952)
- **变体场景与切面**：收录来自工坊 Mod 3662273952 (`…`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3662273952)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player_classified
-- 在玩家实体移除时保存数据（断开连接、退出游戏等场景）
AddPrefabPostInit("player_classified", function(inst)
    inst:ListenForEvent("onremove", function()
        GLOBAL.SaveMusicPlayerSettings()
        GLOBAL.SaveMusicFavorites()
    end)
end)

```



### 变体演进：Ice Flingomatic Overhaul (Mod 3795134964)
- **变体场景与切面**：收录来自工坊 Mod 3795134964 (`Ice Flingomatic Overhaul`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3795134964)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:firesuppressor_placer

AddPrefabPostInit(
    "firesuppressor_placer",

    function(inst)

        if inst.AnimState ~= nil then

            inst.AnimState:SetScale(
                RANGE_VISUAL_MULTIPLIER,
                RANGE_VISUAL_MULTIPLIER
            )

        end

    end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:firesuppressor

AddPrefabPostInit(
    "firesuppressor",

    function(inst)

        if GLOBAL.TheNet:IsDedicated() then
            return
        end


        inst:DoTaskInTime(
            0,

            function()

                local deployhelper =
                    inst.components.deployhelper


                if deployhelper == nil then
                    return
                end


                deployhelper.onenablehelper =
                    function(flingo, enabled)


                        --------------------------------------------------
                        -- SHOW RANGE
                        --------------------------------------------------

                        if enabled then

                            if flingo.helper ~= nil then
                                return
                            end


                            local helper =
                                CreateEntity()


                            helper.entity:SetCanSleep(false)
                            helper.persists = false

                            helper.entity:AddTransform()
                            helper.entity:AddAnimState()


                            helper:AddTag("CLASSIFIED")
                            helper:AddTag("NOCLICK")
                            helper:AddTag("placer")


                            helper.Transform:SetScale(
                                VANILLA_HELPER_TRANSFORM_SCALE,
                                VANILLA_HELPER_TRANSFORM_SCALE,
                                VANILLA_HELPER_TRANSFORM_SCALE
                            )


                            helper.AnimState:SetBank(
                                "firefighter_placement"
                            )

                            helper.AnimState:SetBuild(
                                "firefighter_placement"
                            )

                            helper.AnimState:PlayAnimation(
                                "idle"
                            )


                            helper.AnimState:SetScale(
                                RANGE_VISUAL_MULTIPLIER,
                                RANGE_VISUAL_MULTIPLIER
                            )


                            helper.AnimState:SetLightOverride(1)


                            helper.AnimState:SetOrientation(
                                GLOBAL.ANIM_ORIENTATION.OnGround
                            )


                            helper.AnimState:SetLayer(
                                GLOBAL.LAYER_BACKGROUND
                            )


                            helper.AnimState:SetSortOrder(1)


                            helper.AnimState:SetAddColour(
                                0,
                                0.2,
                                0.5,
                                0
                            )


                            helper.entity:SetParent(
                                flingo.entity
                            )


                            flingo.helper =
                                helper


                        --------------------------------------------------
                        -- HIDE RANGE
                        --------------------------------------------------

                        elseif flingo.helper ~= nil then

                            flingo.helper:Remove()

                            flingo.helper =
                                nil

                        end

                    end

            end
        )

    end
)


--------------------------------------------------
-- MARKER RANGE CHECK
--------------------------------------------------

local function IsMarkerInRange(
    inst,
    marker,
    range
)

    if marker == nil
        or not marker:IsValid()
        or not marker:HasTag(MARKER_TAG) then

        return false

    end


    local x, y, z =
        inst.Transform:GetWorldPosition()


    local mx, my, mz =
        marker.Transform:GetWorldPosition()


    local dx =
        mx - x

    local dz =
        mz - z


    return
        (dx * dx + dz * dz)
        <=
        (range * range)

end


--------------------------------------------------
-- FIND / MAINTAIN MARKER LOCK
--------------------------------------------------

local function FindNearestMarker(inst)

    local detector =
        inst.components.firedetector


    if detector == nil
        or detector.range == nil then

        return nil

    end


    local range =
        detector.range


    --------------------------------------------------
    -- KEEP CURRENT MARKER LOCK
    --------------------------------------------------

    if IsMarkerInRange(
        inst,
        inst._flingomatic_marker_target,
        range
    ) then

        return
            inst._flingomatic_marker_target

    end


    --------------------------------------------------
    -- CURRENT MARKER INVALID / OUT OF RANGE
    --------------------------------------------------

    inst._flingomatic_marker_target =
        nil


    --------------------------------------------------
    -- FIND MARKERS IN RANGE
    --------------------------------------------------

    local x, y, z =
        inst.Transform:GetWorldPosition()


    local markers =
        TheSim:FindEntities(
            x,
            y,
            z,
            range,
            {
                MARKER_TAG
            }
        )


    local nearest =
        nil

    local nearest_distsq =
        nil


    --------------------------------------------------
    -- SELECT NEAREST MARKER
    --------------------------------------------------

    for _, marker in ipairs(markers) do

        if marker ~= nil
            and marker:IsValid() then


            local mx, my, mz =
                marker.Transform:GetWorldPosition()


            local dx =
                mx - x

            local dz =
                mz - z


            local distsq =
                dx * dx +
                dz * dz


            if nearest == nil
                or distsq < nearest_distsq then


                nearest =
                    marker

                nearest_distsq =
                    distsq

            end

        end

    end


    --------------------------------------------------
    -- SAVE NEW MARKER LOCK
    --------------------------------------------------

    if nearest ~= nil then

        inst._flingomatic_marker_target =
            nearest

    end


    return nearest

end


--------------------------------------------------
-- TARGET MARKER
--------------------------------------------------

local function TargetMarker(
    inst,
    marker
)

    if marker == nil
        or not marker:IsValid()
        or inst.sg == nil
        or not inst.sg:HasStateTag("idle") then

        return false

    end


    inst:PushEvent(
        "putoutfire",
        {
            firePos =
                marker:GetPosition()
        }
    )


    return true

end


--------------------------------------------------
-- PROJECTILE DISTANCE
--------------------------------------------------

local function GetHorizontalDistance(
    x,
    z,
    targetpos
)

    local dx =
        targetpos.x - x

    local dz =
        targetpos.z - z


    return math.sqrt(
        dx * dx +
        dz * dz
    )

end


--------------------------------------------------
-- MAKE SURE PROJECTILE CAN REACH TARGET
--------------------------------------------------

local function SetReachableSpeed(
    cp,
    base_speed,
    distance
)

    local required_speed =
        cp:CalculateMinimumSpeedForDistance(
            distance
        )


    if required_speed ~= nil then

        required_speed =
            required_speed *
            PROJECTILE_SPEED_SAFETY


        cp:SetHorizontalSpeed(
            math.max(
                base_speed,
                required_speed
            )
        )

    else

        cp:SetHorizontalSpeed(
            base_speed
        )

    end

end


--------------------------------------------------
-- FLINGOMATIC MODIFICATIONS
--------------------------------------------------

AddPrefabPostInit(
    "firesuppressor",

    function(inst)

        if not GLOBAL.TheWorld.ismastersim then
            return
        end


        inst:DoTaskInTime(
            0,

            function()


                --------------------------------------------------
                -- RANGE
                --------------------------------------------------

                local detector =
                    inst.components.firedetector


                if detector ~= nil then

                    detector.range =
                        FLINGOMATIC_RANGE

                end


                --------------------------------------------------
                -- INFINITE FUEL
                --------------------------------------------------

                if INFINITE_FUEL then

                    local fueled =
                        inst.components.fueled


                    if fueled ~= nil then

                        fueled:SetPercent(1)

                        fueled:StopConsuming()


                        fueled.StartConsuming =
                            function(self)

                                self:SetPercent(1)

                                self:StopConsuming()

                            end

                    end

                end


                --------------------------------------------------
                -- MARKER TARGETING
                --------------------------------------------------

                if detector ~= nil then


                    local old_onfindfire =
                        detector.onfindfire


                    local old_detect_fire =
                        detector.DetectFire


                    detector:SetOnFindFireFn(

                        function(
                            flingo,
                            normal_target_position
                        )


                            local marker =
                                FindNearestMarker(
                                    flingo
                                )


                            if marker ~= nil then

                                if old_onfindfire ~= nil then

                                    old_onfindfire(
                                        flingo,
                                        marker:GetPosition()
                                    )

                                end


                                return

                            end


                            if old_onfindfire ~= nil then

                                old_onfindfire(
                                    flingo,
                                    normal_target_position
                                )

                            end

                        end
                    )


                    --------------------------------------------------
                    -- DETECT MARKERS EVEN WITHOUT FIRE
                    --------------------------------------------------

                    detector.DetectFire =
                        function(self)


                            local marker =
                                FindNearestMarker(
                                    self.inst
                                )


                            if marker ~= nil then

                                if self.onfindfire ~= nil then

                                    self.onfindfire(
                                        self.inst,
                                        marker:GetPosition()
                                    )

                                end


                                return

                            end


                            old_detect_fire(
                                self
                            )

                        end


                    --------------------------------------------------
                    -- PERIODIC MARKER TARGETING
                    --------------------------------------------------

                    inst._flingomatic_marker_task =
                        inst:DoPeriodicTask(

                            MARKER_CHECK_PERIOD,

                            function(flingo)


                                if flingo.components.machine ~= nil
                                    and
                                    not flingo.components.machine:IsOn() then

                                    return

                                end


                                local marker =
                                    FindNearestMarker(
                                        flingo
                                    )


```



### 变体演进：Berg Cub (Mod 1577400707)
- **变体场景与切面**：收录来自工坊 Mod 1577400707 (`Berg Cub`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 1577400707)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:bearger
-- BEARGER LOOT
AddPrefabPostInit("bearger", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst.components.lootdropper:AddChanceLoot("backcub", dropChance)
	end
end)

```



### 变体演进：打击特效 (Mod 3815976284)
- **变体场景与切面**：收录来自工坊 Mod 3815976284 (`打击特效`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3815976284)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller
-- ===========================================================================
AddComponentPostInit("playercontroller", function(playercontroller)
    -- 鼠标点击路径
    local old_DoAction = playercontroller.DoAction
    playercontroller.DoAction = function(self, buffaction, ...)
        if buffaction ~= nil
            and buffaction.action == G.ACTIONS.ATTACK
            and buffaction.target ~= nil then
            attack_intent.target = buffaction.target
            attack_intent.t = G.GetTime()
        end
        return old_DoAction(self, buffaction, ...)
    end

    -- F 键 / 自动攻击路径（与原版 DoAttackButton 同款取目标，纯只读不影响行为）
    local old_DoAttackButton = playercontroller.DoAttackButton
    playercontroller.DoAttackButton = function(self, ...)
        if G.TheInput ~= nil then
            local force = G.TheInput:IsControlPressed(G.CONTROL_FORCE_ATTACK)
            local target = self:GetAttackTarget(force)
            if target ~= nil then
                attack_intent.target = target
                attack_intent.t = G.GetTime()
            end
        end
        return old_DoAttackButton(self, ...)
    end
end)

```



### 变体演进：Mod 2996761707 (Mod 2996761707)
- **变体场景与切面**：收录来自工坊 Mod 2996761707 (`Mod 2996761707`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2996761707)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:locomotor

AddComponentPostInit("locomotor", hookLocoMotorForPlayer)





```



### 变体演进：robobeestatuerecipeconfig (Mod 3054561212)
- **变体场景与切面**：收录来自工坊 Mod 3054561212 (`robobeestatuerecipeconfig`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3054561212)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:pickable
-- OBBY: Combinding of previous two AddComponentPostInit uses into one, and fix for newer Pick which (sometimes) returns a value
AddComponentPostInit("pickable", function(Pickable)
	local OldPick = Pickable.Pick
	local OldRegen = Pickable.Regen

	Pickable.Pick = function(self, picker, ...)
		if self.inst and picker ~= nil and not picker:HasTag("robobee") and self.inst.robobee_picker ~= nil then
			self.inst.robobee_picker.pickable_target = nil
			self.inst.robobee_picker:PushEvent("robobee_targetstolen")
			self.inst.robobee_picker = picker
		end

		local inst = self.inst
		self.inst:DoTaskInTime(2, function(inst)
			if inst and inst.components.pickable and inst.components.pickable:CanBePicked() and self.inst.robobee_picker ~= nil then
				if self.inst.robobee_picker.bufferedaction ~= nil and self.inst.robobee_picker.bufferedaction.action == ACTIONS.PICK and self.inst.robobee_picker.bufferedaction.target == self.inst then
					-- check for 2 cases: IF player has picked the object earlier OR Wickerbottom is mass farming resources
					-- if yes, then clear robobee_picker
				else
					self.inst.robobee_picker = nil
				end
			end
		end) -- crappy hacky way to prevent bee targeting bug

		return OldPick(self, picker, ...)
	end

	Pickable.Regen = function(self, ...)
		if self.inst and self.inst:IsValid() then
			if self.inst:HasTag("robobee_target") then
				self.inst:RemoveTag("robobee_target")
			end
			if self.inst.robobee_picker ~= nil then
				self.inst.robobee_picker = nil
			end
		end

		OldRegen(self, ...)
	end
end)

-- OBBY: Simplification of function args and combinding of previous two AddComponentPostInit uses into one
AddComponentPostInit("inventoryitem", function(Inventoryitem)
	local OldOnPutInInventory = Inventoryitem.OnPutInInventory
	local OldOnDropped = Inventoryitem.OnDropped

	Inventoryitem.OnPutInInventory = function(self, ...)
		if self.inst.robobee_picker ~= nil then
			if self.inst.robobee_picker.pickable_target ~= nil then
				self.inst.robobee_picker.pickable_target = nil
			end
			self.inst.robobee_picker = nil
		end

		if self.inst.stackbreaker ~= nil then
			if self.inst.stackbreaker.stacktobreak ~= nil then
				self.inst.stackbreaker.stacktobreak = nil
				if self.inst.stackbreaker.bufferedaction ~= nil and self.inst.stackbreaker.bufferedaction == ACTIONS.BREAKSTACK and self.inst.stackbreaker.bufferedaction.target == self.inst then
					self.inst.stackbreaker:ClearBufferedAction()
				end
			end
			self.inst.stackbreaker = nil
		end

		if self.inst:HasTag("robobee_target") then
			self.inst:RemoveTag("robobee_target")
		end

		OldOnPutInInventory(self, ...)
	end

	Inventoryitem.OnDropped = function(self, ...)
		if self.inst.wasmadeclear ~= nil and self.inst.wasmadeclear == true and self.inst.AnimState then
			self.inst.AnimState:OverrideMultColour(1, 1, 1, 1)
			self.inst.wasmadeclear = nil
		end

		--if self.inst ~= nil and self.inst.Transform ~= nil and self.inst.originaltransformsize ~= nil then
			--local oldsize = self.inst.originaltransformsize
			--self.inst.Transform:SetScale(oldsize, oldsize, oldsize)
			--self.inst.originaltransformsize = nil
		--end

		--if self.inst ~= nil and self.inst.AnimState ~= nil and self.inst.originalcolour ~= nil then
			--local oldcolour = self.inst.originalcolour
			--self.inst.AnimState:SetAddColour(oldcolour[1], oldcolour[2], oldcolour[3], oldcolour[4])
			--self.inst.originalcolour = nil
		--end

		OldOnDropped(self, ...)
	end
end)

-- OBBY: Simplification of function args
AddComponentPostInit("spellcaster", function(SpellCaster)
	local OldCanCast = SpellCaster.CanCast
	SpellCaster.CanCast = function(self, doer, target, ...)

		if target ~= nil and target:HasTag("robobee") then
			-- Keep that dir ty magic away from my pure bee!
			return false
		else
			return OldCanCast(self, doer, target, ...)
		end

	end
end)

-- OBBY: Fix for newer ReleaseAllChildren that returns a value, simplification of function args
AddComponentPostInit("childspawner", function(ChildSpawner)
	local OldReleaseAllChildren = ChildSpawner.ReleaseAllChildren
	ChildSpawner.ReleaseAllChildren = function(self, target, ...)

	-- Don't release children if robobee is the target
	-- Yes, I had to edit the component, because beebox is not very mod-friendly
		if target == nil or target ~= nil and not target:HasTag("robobee") then
			return OldReleaseAllChildren(self, target, ...)
		end
	end
end)

function RobobeePickableItems(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst:AddTag("robobee_transportable")
	end
end

if GetModConfigData("excludeitemsconfig") ~= 4 then
	local plants_shrooms =
		{"berries",
		"berries_juicy",
		"carrot",
		"cactus_meat",
		"watermelon",
		"dragonfruit",
		"pomegranate",
		"durian",
		"eggplant",
		"pumpkin",
		"cave_banana",
		"cactus_flower",
		"seeds",
		"red_cap",
		"green_cap",
		"blue_cap",
		"petals",
		"petals_evil",
		"foliage",
		"lightbulb",}
	for _,v in ipairs(plants_shrooms) do AddPrefabPostInit(v, RobobeePickableItems) end
end

if GetModConfigData("excludeitemsconfig") ~= 3 then
	local meats_eggs =
		{"meat",
		"monstermeat",
		"monstermeat_dried",
		"meat_dried",
		"smallmeat_dried",
		"smallmeat",
		"drumstick",
		"batwing",
		"plantmeat",
		"fish",
		"eel",
		"bird_egg",
		"tallbirdegg",
		"froglegs",}
	for _,v in ipairs(meats_eggs) do AddPrefabPostInit(v, RobobeePickableItems) end
end

local manure =
	{"poop",
	"guano",
	"spoiled_food",
	"glommerfuel",}
for _,v in ipairs(manure) do AddPrefabPostInit(v, RobobeePickableItems) end

local resources =
	{"cutreeds",
	"cutgrass",
	"twigs",
	"manrabbit_tail",
	"pigskin",
	"rocks",
	"flint",
	"goldnugget",
	"nitre",
	"marble",
	"log",
	"pinecone",
	"acorn",
	"twiggy_nut",
	"spidergland",
	"silk",}
for _,v in ipairs(resources) do AddPrefabPostInit(v, RobobeePickableItems) end

local other =
	{"charcoal",
	"honey",
	"ash",
	"butterflywings",
	"beardhair",
	"goatmilk",
	"stinger",
	"slurper_pelt",
	"houndstooth",
	"beefalowool"}
for _,v in ipairs(other) do AddPrefabPostInit(v, RobobeePickableItems) end

---

function RobobeeExcludedItems(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst:AddTag("robobee_excluded")
	end
end

if GetModConfigData("excludeitemsconfig") == 2 then
	local flowers =
		{"flower",
		"flower_evil",
		"cave_fern",
		"succulent_plant",
		"flower_rose",
		"flower_withered",}
	for _,v in ipairs(flowers) do AddPrefabPostInit(v, RobobeeExcludedItems) end
end

if GetModConfigData("excludeitemsconfig") == 3 then
	AddPrefabPostInit("meatrack", RobobeeExcludedItems)
end

if GetModConfigData("excludeitemsconfig") == 4 then
	AddPrefabPostInit("plant_normal", RobobeeExcludedItems)
end

if GetModConfigData("includecrops") == 1 then
	local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
	for _,v in ipairs(PLANT_DEFS) do AddPrefabPostInit(v.prefab, RobobeeExcludedItems) end

	local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS
	for _,v in ipairs(WEED_DEFS) do AddPrefabPostInit(v.prefab, RobobeeExcludedItems) end
end

---

function ForbiddenStructuresPostInit(inst)
	if GLOBAL.TheWorld.ismastersim then -- no need to add the tag for clients, G10MM-3R operates locally
		inst:AddTag("robobee_excluded")
	end
end
AddPrefabPostInit("sculptingtable", ForbiddenStructuresPostInit)

if GetModConfigData("robobeetechconfig") == 1 then

	function GlommerStatuePostInit(inst)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.lootdropper then
				inst.components.lootdropper:AddChanceLoot("statuerobobee_blueprint", 1)
			end
		end
	end
	AddPrefabPostInit("statueglommer", GlommerStatuePostInit)

	function RaidBossesRecipeDropPostInit(inst)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.lootdropper then
				inst.components.lootdropper:AddChanceLoot("statuerobobee_blueprint", 0.2)
			end
		end
	end
	local bosses = {"dragonfly", "beequeen"}
	for _,v in ipairs(bosses) do AddPrefabPostInit(v, RaidBossesRecipeDropPostInit) end

	function ClockworkJunkRecipeDropPostInit(inst)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.lootdropper then
				inst.components.lootdropper:AddChanceLoot("statuerobobee_blueprint", 0.01)
			end
		end
	end
	local junkpiles = {"chessjunk1", "chessjunk2", "chessjunk3"}
	for _,v in ipairs(junkpiles) do AddPrefabPostInit(v, ClockworkJunkRecipeDropPostInit) end

end

local BREAKSTACK = GLOBAL.Action({ priority= 10 })
BREAKSTACK.str = "Break Stack"
BREAKSTACK.id = "BREAKSTACK"
BREAKSTACK.fn = function(act)
	if act.target ~= nil and
	   act.target.components.inventoryitem ~= nil and
	   not act.target.components.inventoryitem:IsHeld() and
	   act.target.components.stackable ~= nil and
	   act.target.components.stackable:IsStack() then
		local target = act.target
		return act.doer.components.stackbreaker:BreakStack(target)
	end
end
AddAction(BREAKSTACK)

AddComponentAction("SCENE", "stackbreaker", function(inst, doer, actions, right)
	if inst and inst.components.stackable and (inst.components.inventoryitem and not inst.components.inventoryitem:IsHeld()) and doer and doer:HasTag("robobee") then
		table.insert(actions, ACTIONS.BREAKSTACK)
	end
end)

-- CONTAINERS:
-- OBBY: Removal of unnecessary return statement since containers.widgetsetup doesn't return a value
local containers = GLOBAL.require("containers")
local oldwidgetsetup = containers.widgetsetup
_G=GLOBAL
mods=_G.rawget(_G,"mods")or(function()local m={}_G.rawset(_G,"mods",m)return m end)()
mods.old_widgetsetup = mods.old_widgetsetup or containers.smartercrockpot_old_widgetsetup or oldwidgetsetup
containers.widgetsetup = function(container, prefab, ...)
	if ((not prefab and container and container.inst and container.inst.prefab == "statuerobobee") or (prefab and container and container.inst and container.inst.prefab == "statuerobobee")) or
		((not prefab and container and container.inst and container.inst.prefab == "statuerobobee_78") or (prefab and container and container.inst and container.inst.prefab == "statuerobobee_78")) or
		((not prefab and container and container.inst and container.inst.prefab == "statuerobobee_caterpillar") or (prefab and container and container.inst and container.inst.prefab == "statuerobobee_caterpillar")) then
		prefab = "treasurechest"
	end
	oldwidgetsetup(container, prefab, ...)
end

STRINGS.NAMES.ROBOBEE = "G10MM-3R"
STRINGS.NAMES.ROBOBEE_78 = "G10MM-3R"
STRINGS.NAMES.ROBOBEE_CATERPILLAR = "G10MM-3R"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.ROBOBEE = "It's buzzing with electricity."
STRINGS.CHARACTERS.WILLOW.DESCRIBE.ROBOBEE = "It's not as fuzzy as the real thing..."
STRINGS.CHARACTERS.WENDY.DESCRIBE.ROBOBEE = "The original is dead. This one is just a mindless drone..."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ROBOBEE = "Is robot bug tiny robot person's friend?"
STRINGS.CHARACTERS.WX78.DESCRIBE.ROBOBEE = "MAYBE IT HAS A SIMPLE BRAIN, BUT IT'S NOT A BRAIN MADE OF FLESH"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ROBOBEE = "An artificial creature with seemingly infinite energy."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.ROBOBEE = "Whatever I chop, it'll collect, eh?"
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ROBOBEE = "Well, at least this one doesn't leave its feces everywhere."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ROBOBEE = "Majestic goober, in a majestic armor."
STRINGS.CHARACTERS.WEBBER.DESCRIBE.ROBOBEE = "Always busy! He has no time for fun."
STRINGS.CHARACTERS.WINONA.DESCRIBE.ROBOBEE = "Oh, it looks amazing! I'd like to take a peek inside..."

STRINGS.NAMES.STATUEROBOBEE = "G10MM-3R Base"
STRINGS.NAMES.STATUEROBOBEE_78 = "G10MM-3R Base"
STRINGS.NAMES.STATUEROBOBEE_CATERPILLAR = "G10MM-3R Base"

GLOBAL.STRINGS.SKIN_NAMES.statuerobobee = "Default"
GLOBAL.STRINGS.SKIN_NAMES.statuerobobee_78 = "Clockwork"
GLOBAL.STRINGS.SKIN_NAMES.statuerobobee_caterpillar = "Caterpillar"

STRINGS.RECIPE_DESC.STATUEROBOBEE = "Small deposit station. Comes with a drone."
STRINGS.RECIPE_DESC.STATUEROBOBEE_78 = "Small deposit station. Comes with a drone." -- this fixes disappearing in-menu flavor text after crafting the skinned robobee base
STRINGS.RECIPE_DESC.STATUEROBOBEE_CATERPILLAR = "Small deposit station. Comes with a drone."

STRINGS.CHARACTERS.GENERIC.DESCRIBE.STATUEROBOBEE = {
	GENERIC = "It's an electric plant. I named it a \"power-plant\".",
	BEEINSIDE = "Scientifically speaking, sleeping does \"charge your batteries\"." }

STRINGS.CHARACTERS.WILLOW.DESCRIBE.STATUEROBOBEE = {
	GENERIC = "I like the flower part of it.",
	BEEINSIDE = "It's actually sleeping or is it just trying to mock me?" }

STRINGS.CHARACTERS.WENDY.DESCRIBE.STATUEROBOBEE = {
	GENERIC = "It provides that hollow drone a place to rest.",
	BEEINSIDE = "One day it's going to die from an electrical outage." }

STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.STATUEROBOBEE = {
	GENERIC = "Hah, dumb machine. You are not flower.",
	BEEINSIDE = "Flower is cozy bed for robot." }

STRINGS.CHARACTERS.WX78.DESCRIBE.STATUEROBOBEE = {
	GENERIC = "I APPRECIATE ITS NON-ORGANIC PARTS",
	BEEINSIDE = "SLEEP WELL, FRIEND" }

STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.STATUEROBOBEE = {
	GENERIC = "A structure utilizing conductivity of flora.",
	BEEINSIDE = "This automated creature is able to imitate the act of sleeping." }

STRINGS.CHARACTERS.WOODIE.DESCRIBE.STATUEROBOBEE = {
	GENERIC = "That thing's trunk looks like it's made of metal.",
	BEEINSIDE = "So it comes here for a nap, eh?" }

STRINGS.CHARACTERS.WAXWELL.DESCRIBE.STATUEROBOBEE = {
	GENERIC = "This flower may be pretty, but its smell... not so much.",
	BEEINSIDE = "It's resting after a long day of physical labor." }

STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.STATUEROBOBEE = {
	GENERIC = "It's not real gold, but I appreciate the effort.",
	BEEINSIDE = "Goober is resting after a battle." }

STRINGS.CHARACTERS.WEBBER.DESCRIBE.STATUEROBOBEE = {
	GENERIC = "Hey, we've seen a similar statue somewhere...",
	BEEINSIDE = "Shh, he's sleeping!" }

STRINGS.CHARACTERS.WINONA.DESCRIBE.STATUEROBOBEE = {
	GENERIC = "Pure utility, I love it!",
	BEEINSIDE = "You're not fooling anyone, little guy." }


-- Skin strings
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ROBOBEE_78 = "It's buzzing with electricity."
STRINGS.CHARACTERS.WILLOW.DESCRIBE.ROBOBEE_78 = "It's not as fuzzy as the real thing..."
STRINGS.CHARACTERS.WENDY.DESCRIBE.ROBOBEE_78 = "The original is dead. This one is just a mindless drone..."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ROBOBEE_78 = "Is robot bug tiny robot person's friend?"
STRINGS.CHARACTERS.WX78.DESCRIBE.ROBOBEE_78 = "MAYBE IT HAS A SIMPLE BRAIN, BUT IT'S NOT A BRAIN MADE OF FLESH"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ROBOBEE_78 = "An artificial creature with seemingly infinite energy."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.ROBOBEE_78 = "Whatever I chop, it'll collect, eh?"
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ROBOBEE_78 = "Well, at least this one doesn't leave its feces everywhere."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ROBOBEE_78 = "Majestic goober, in a majestic armor."
STRINGS.CHARACTERS.WEBBER.DESCRIBE.ROBOBEE_78 = "Always busy! He has no time for fun."
STRINGS.CHARACTERS.WINONA.DESCRIBE.ROBOBEE_78 = "Oh, it looks amazing! I'd like to take a peek inside..."

STRINGS.CHARACTERS.GENERIC.DESCRIBE.STATUEROBOBEE_78 = {
	GENERIC = "It's an electric plant. I named it a \"power-plant\".",
	BEEINSIDE = "Scientifically speaking, sleeping does \"charge your batteries\"." }

STRINGS.CHARACTERS.WILLOW.DESCRIBE.STATUEROBOBEE_78 = {
	GENERIC = "I like the flower part of it.",
	BEEINSIDE = "It's actually sleeping or is it just trying to mock me?" }

STRINGS.CHARACTERS.WENDY.DESCRIBE.STATUEROBOBEE_78 = {
	GENERIC = "It provides that hollow drone a place to rest.",
	BEEINSIDE = "One day it's going to die from an electrical outage." }

STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.STATUEROBOBEE_78 = {
	GENERIC = "Hah, dumb machine. You are not flower.",
	BEEINSIDE = "Flower is cozy bed for robot." }

STRINGS.CHARACTERS.WX78.DESCRIBE.STATUEROBOBEE_78 = {
	GENERIC = "I APPRECIATE ITS NON-ORGANIC PARTS",
	BEEINSIDE = "SLEEP WELL, FRIEND" }

STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.STATUEROBOBEE_78 = {
	GENERIC = "A structure utilizing conductivity of flora.",
	BEEINSIDE = "This automated creature is able to imitate the act of sleeping." }

STRINGS.CHARACTERS.WOODIE.DESCRIBE.STATUEROBOBEE_78 = {
	GENERIC = "It's made o' metal and all. Even has little gears grinding about.",
	BEEINSIDE = "So it comes here for a nap, eh?" }

STRINGS.CHARACTERS.WAXWELL.DESCRIBE.STATUEROBOBEE_78 = {
	GENERIC = "This flower may be pretty, but its smell... not so much.",
	BEEINSIDE = "It's resting after a long day of physical labor." }

STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.STATUEROBOBEE_78 = {
	GENERIC = "Brings back memories of war against the fierce automatons!",
	BEEINSIDE = "Goober is resting after a battle." }

STRINGS.CHARACTERS.WEBBER.DESCRIBE.STATUEROBOBEE_78 = {
	GENERIC = "Hey, we've seen a similar statue somewhere...",
	BEEINSIDE = "Shh, he's sleeping!" }

STRINGS.CHARACTERS.WINONA.DESCRIBE.STATUEROBOBEE_78 = {
	GENERIC = "Pure utility, I love it!",
	BEEINSIDE = "You're not fooling anyone, little guy." }

-- Skin strings #2:
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ROBOBEE_CATERPILLAR = "It's buzzing with electricity."
STRINGS.CHARACTERS.WILLOW.DESCRIBE.ROBOBEE_CATERPILLAR = "It's not as fuzzy as the real thing..."
STRINGS.CHARACTERS.WENDY.DESCRIBE.ROBOBEE_CATERPILLAR = "The original is dead. This one is just a mindless drone..."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ROBOBEE_CATERPILLAR = "Is robot bug tiny robot person's friend?"
STRINGS.CHARACTERS.WX78.DESCRIBE.ROBOBEE_CATERPILLAR = "MAYBE IT HAS A SIMPLE BRAIN, BUT IT'S NOT A BRAIN MADE OF FLESH"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ROBOBEE_CATERPILLAR = "An artificial creature with seemingly infinite energy."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.ROBOBEE_CATERPILLAR = "Whatever I chop, it'll collect, eh?"
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ROBOBEE_CATERPILLAR = "Well, at least this one doesn't leave its feces everywhere."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ROBOBEE_CATERPILLAR = "Majestic goober, in a majestic armor."
STRINGS.CHARACTERS.WEBBER.DESCRIBE.ROBOBEE_CATERPILLAR = "Always busy! He has no time for fun."
STRINGS.CHARACTERS.WINONA.DESCRIBE.ROBOBEE_CATERPILLAR = "Oh, it looks amazing! I'd like to take a peek inside..."

STRINGS.CHARACTERS.GENERIC.DESCRIBE.STATUEROBOBEE_CATERPILLAR = {
	GENERIC = "It's an electric plant. I named it a \"power-plant\".",
	BEEINSIDE = "Scientifically speaking, sleeping does \"charge your batteries\"." }

STRINGS.CHARACTERS.WILLOW.DESCRIBE.STATUEROBOBEE_CATERPILLAR = {
	GENERIC = "It would look prettier if its flower was red.",
	BEEINSIDE = "It's actually sleeping or is it just trying to mock me?" }

STRINGS.CHARACTERS.WENDY.DESCRIBE.STATUEROBOBEE_CATERPILLAR = {
	GENERIC = "It provides that hollow drone a place to rest.",
	BEEINSIDE = "One day it's going to die from an electrical outage." }

STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.STATUEROBOBEE_CATERPILLAR = {
	GENERIC = "Hah, dumb machine. You are not flower.",
	BEEINSIDE = "Flower is cozy bed for robot." }

STRINGS.CHARACTERS.WX78.DESCRIBE.STATUEROBOBEE_CATERPILLAR = {
	GENERIC = "IT'S ORGANIC ONLY FROM THE OUTSIDE",
	BEEINSIDE = "SLEEP WELL, FRIEND" }

STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.STATUEROBOBEE_CATERPILLAR = {
	GENERIC = "A structure utilizing conductivity of flora.",
	BEEINSIDE = "This automated creature is able to imitate the act of sleeping." }

STRINGS.CHARACTERS.WOODIE.DESCRIBE.STATUEROBOBEE_CATERPILLAR = {
	GENERIC = "That's one weird flower growing outta beanstalk.",
	BEEINSIDE = "So it comes here for a nap, eh?" }

STRINGS.CHARACTERS.WAXWELL.DESCRIBE.STATUEROBOBEE_CATERPILLAR = {
	GENERIC = "This flower may be pretty, but its smell... not so much.",
	BEEINSIDE = "It's resting after a long day of physical labor." }

STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.STATUEROBOBEE_CATERPILLAR = {
	GENERIC = "Reminds me of a legendary plant which was reaching heavens!",
	BEEINSIDE = "Goober is resting after a battle." }

STRINGS.CHARACTERS.WEBBER.DESCRIBE.STATUEROBOBEE_CATERPILLAR = {
	GENERIC = "Hey, we've seen a similar statue somewhere...",
	BEEINSIDE = "Shh, he's sleeping!" }

STRINGS.CHARACTERS.WINONA.DESCRIBE.STATUEROBOBEE_CATERPILLAR = {
	GENERIC = "Pure utility, I love it!",
	BEEINSIDE = "You're not fooling anyone, little guy." }

-- Skins:
local function RecipePopupPostConstruct( widget )
	local _GetSkinsList = widget.GetSkinsList
	widget.GetSkinsList = function( self )
		if self.recipe.skinnable == nil then
			return _GetSkinsList( self )
		end

		self.skins_list = {}
		if self.recipe and GLOBAL.PREFAB_SKINS[self.recipe.name] then
			for _,item_type in pairs(GLOBAL.PREFAB_SKINS[self.recipe.name]) do
				local data  = {}
				    data.type = type
				    data.item = item_type
				    data.timestamp = nil
				    table.insert(self.skins_list, data)
			end
	    end

	    return self.skins_list
	end

	local GetName = function(var)
		return GLOBAL.STRINGS.SKIN_NAMES[var]
	end

	local _GetSkinOptions = widget.GetSkinOptions
	widget.GetSkinOptions = function( self )
		if self.recipe.skinnable == nil then
			return _GetSkinOptions( self )
		end

		local skin_options = {}

		table.insert(skin_options,
		{
			text = GLOBAL.STRINGS.UI.CRAFTING.DEFAULT,
			data = nil,
			colour = GLOBAL.SKIN_RARITY_COLORS["Common"],
			new_indicator = false,
			image =  {self.recipe.atlas or "images/inventoryimages.xml", self.recipe.image or self.recipe.name .. ".tex", "default.tex"},
		})

		local recipe_timestamp = GLOBAL.Profile:GetRecipeTimestamp(self.recipe.name)
		--print(self.recipe.name, "Recipe timestamp is ", recipe_timestamp)
		if self.skins_list and GLOBAL.TheNet:IsOnlineMode() then
			for which = 1, #self.skins_list do
				local image_name = self.skins_list[which].item

				local rarity = GLOBAL.GetRarityForItem("item", image_name)
				local colour = rarity and GLOBAL.SKIN_RARITY_COLORS[rarity] or GLOBAL.SKIN_RARITY_COLORS["Common"]
				local text_name = GetName(image_name) or GLOBAL.SKIN_STRINGS.SKIN_NAMES["missing"]
				local new_indicator = not self.skins_list[which].timestamp or (self.skins_list[which].timestamp > recipe_timestamp)

				if image_name == "" then
					image_name = "default"
				else
					image_name = string.gsub(image_name, "_none", "")
				end

				table.insert(skin_options,
				{
					text = text_name,
					data = nil,
					colour = colour,
					new_indicator = new_indicator,
					image = {self.recipe.atlas or image_name .. ".xml" or "images/inventoryimages.xml", image_name..".tex" or "default.tex", "default.tex"},
				})
			end

	    else
			self.spinner_empty = true
	    end

	    return skin_options

	end
end
AddClassPostConstruct("widgets/recipepopup", RecipePopupPostConstruct)

local function BuilderPostInit( builder )
	local _MakeRecipeFromMenu = builder.MakeRecipeFromMenu
	builder.MakeRecipeFromMenu = function( self, recipe, skin )
		if recipe.skinnable == nil then
			_MakeRecipeFromMenu( self, recipe, skin )

		else

			if recipe.placer == nil then
				if self:KnowsRecipe(recipe.name) then

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:inventoryitem
-- OBBY: Simplification of function args and combinding of previous two AddComponentPostInit uses into one
AddComponentPostInit("inventoryitem", function(Inventoryitem)
	local OldOnPutInInventory = Inventoryitem.OnPutInInventory
	local OldOnDropped = Inventoryitem.OnDropped

	Inventoryitem.OnPutInInventory = function(self, ...)
		if self.inst.robobee_picker ~= nil then
			if self.inst.robobee_picker.pickable_target ~= nil then
				self.inst.robobee_picker.pickable_target = nil
			end
			self.inst.robobee_picker = nil
		end

		if self.inst.stackbreaker ~= nil then
			if self.inst.stackbreaker.stacktobreak ~= nil then
				self.inst.stackbreaker.stacktobreak = nil
				if self.inst.stackbreaker.bufferedaction ~= nil and self.inst.stackbreaker.bufferedaction == ACTIONS.BREAKSTACK and self.inst.stackbreaker.bufferedaction.target == self.inst then
					self.inst.stackbreaker:ClearBufferedAction()
				end
			end
			self.inst.stackbreaker = nil
		end

		if self.inst:HasTag("robobee_target") then
			self.inst:RemoveTag("robobee_target")
		end

		OldOnPutInInventory(self, ...)
	end

	Inventoryitem.OnDropped = function(self, ...)
		if self.inst.wasmadeclear ~= nil and self.inst.wasmadeclear == true and self.inst.AnimState then
			self.inst.AnimState:OverrideMultColour(1, 1, 1, 1)
			self.inst.wasmadeclear = nil
		end

		--if self.inst ~= nil and self.inst.Transform ~= nil and self.inst.originaltransformsize ~= nil then
			--local oldsize = self.inst.originaltransformsize
			--self.inst.Transform:SetScale(oldsize, oldsize, oldsize)
			--self.inst.originaltransformsize = nil
		--end

		--if self.inst ~= nil and self.inst.AnimState ~= nil and self.inst.originalcolour ~= nil then
			--local oldcolour = self.inst.originalcolour
			--self.inst.AnimState:SetAddColour(oldcolour[1], oldcolour[2], oldcolour[3], oldcolour[4])
			--self.inst.originalcolour = nil
		--end

		OldOnDropped(self, ...)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:spellcaster
-- OBBY: Simplification of function args
AddComponentPostInit("spellcaster", function(SpellCaster)
	local OldCanCast = SpellCaster.CanCast
	SpellCaster.CanCast = function(self, doer, target, ...)

		if target ~= nil and target:HasTag("robobee") then
			-- Keep that dir ty magic away from my pure bee!
			return false
		else
			return OldCanCast(self, doer, target, ...)
		end

	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:childspawner
-- OBBY: Fix for newer ReleaseAllChildren that returns a value, simplification of function args
AddComponentPostInit("childspawner", function(ChildSpawner)
	local OldReleaseAllChildren = ChildSpawner.ReleaseAllChildren
	ChildSpawner.ReleaseAllChildren = function(self, target, ...)

	-- Don't release children if robobee is the target
	-- Yes, I had to edit the component, because beebox is not very mod-friendly
		if target == nil or target ~= nil and not target:HasTag("robobee") then
			return OldReleaseAllChildren(self, target, ...)
		end
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:meatrack
if GetModConfigData("excludeitemsconfig") == 3 then
	AddPrefabPostInit("meatrack", RobobeeExcludedItems)
end

if GetModConfigData("excludeitemsconfig") == 4 then
	AddPrefabPostInit("plant_normal", RobobeeExcludedItems)
end

if GetModConfigData("includecrops") == 1 then
	local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
	for _,v in ipairs(PLANT_DEFS) do AddPrefabPostInit(v.prefab, RobobeeExcludedItems) end

	local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS
	for _,v in ipairs(WEED_DEFS) do AddPrefabPostInit(v.prefab, RobobeeExcludedItems) end
end

---

function ForbiddenStructuresPostInit(inst)
	if GLOBAL.TheWorld.ismastersim then -- no need to add the tag for clients, G10MM-3R operates locally
		inst:AddTag("robobee_excluded")
	end

```



### 变体演进：凑企鹅死亡音效（服务器端） (Mod 3672625502)
- **变体场景与切面**：收录来自工坊 Mod 3672625502 (`凑企鹅死亡音效（服务器端）`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3672625502)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:swineclops

AddPrefabPostInit("swineclops", function(inst)
    if type(inst.sounds) == "table" then 
        --inst.sounds.attack = "bigdog/bigdog/once"
        inst.sounds.swipe = "bigdog/bigdog/once"
        inst.sounds.taunt = "bigdog/bigdog/jiaoo"
        inst.sounds.jump = "bigdog/bigdog/once"
        --inst.sounds.hit_2 = "bigdog/bigdog/jiao"
    end
end)

```



### 变体演进：Gumby (Mod 1811968982)
- **变体场景与切面**：收录来自工坊 Mod 1811968982 (`Gumby`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 1811968982)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:minotaur
	STRINGY.NAMES.MINOTAUR = "The Affront"
	AddPrefabPostInit("minotaur", function(inst)
		inst.AnimState:SetBuild("affront_build")
		inst.AnimState:AddOverrideBuild("affront_build")
		inst.AnimState:SetBank("affront")
	end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:beequeen
if bqueenC then
	AddPrefabPostInit("beequeen", function(inst) --adds this to the bee queen's file
		inst.AnimState:SetBuild("hivebeequeen_build")
	end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:catcoon
if catgunC then
	AddPrefabPostInit("catcoon", function(inst)
		inst.AnimState:SetBuild("guncatcoon_build")
	end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:dragonfly
	RemapSoundEvent("dontstarve_DLC001/creatures/dragonfly/hurt", "dontstarve_DLC001/creatures/catcoon/hurt") --the game needs a full restart to undo the remap
	AddPrefabPostInit("dragonfly", function(inst)
		inst.AnimState:SetBuild("catcoonfly_build")
	end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:bunnyman
if chungusC then
	AddPrefabPostInit("bunnyman", function(inst)
		inst.AnimState:SetBank("chungus") --Chungus uses custom animation files so the object was rename chungus in Spriter and this will use all of the chungus animations
		inst.AnimState:SetBuild("chungus_build")
		inst.AnimState:SetClientsideBuildOverride("insane", "chungus_build", "chungus_beard_build") --this is how insane players see beardlords instead of regular bunnymen
	end)

```



### 变体演进：全角色技能点MAX (Mod 3718595178)
- **变体场景与切面**：收录来自工坊 Mod 3718595178 (`全角色技能点MAX`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3718595178)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:skilltreeupdater
-- 锁定最大技能点为30（修复nil崩溃版）
AddComponentPostInit("skilltreeupdater", function(self) 	
    local old_AddSkillXP = self.AddSkillXP
    function self:AddSkillXP(...) 		
        -- 先判断组件是否存在，避免nil崩溃
        if self.inst and self.inst.components.skillpoints then
            -- 获取当前可用技能点
            local available = self.inst.components.skillpoints:GetAvailableSkillPoints()
            -- 超过30点直接拦截，不执行加经验逻辑
            if available >= 30 then
                return
            end
        end
        return old_AddSkillXP(self, ...) 	
    end 	
end) 

```



### 变体演进：小恶魔整合增强 (Mod 3747885715)
- **变体场景与切面**：收录来自工坊 Mod 3747885715 (`小恶魔整合增强`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3747885715)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:wortox_nabbag

AddPrefabPostInit("wortox_nabbag", function(inst)
    if inst.components.equippable ~= nil then
        inst.components.equippable.walkspeedmult = 1 + SPEED_BONUS
    end
end)

```



### 变体演进：Easy F Attack (Mod 3781730683)
- **变体场景与切面**：收录来自工坊 Mod 3781730683 (`Easy F Attack`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3781730683)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller

AddComponentPostInit("playercontroller", function(self)
    if not ENABLED then
        return
    end

    local _GetAttackTarget = self.GetAttackTarget
    self.GetAttackTarget = function(ctrl, force_attack, force_target, isretarget, use_remote_predict)
        local use_force = force_attack or INCLUDE_PASSIVE

        -- Never auto-attack walls / fences even if vanilla (or a retarget) suggests them.
        if force_target ~= nil and IsExcludedObject(force_target) then
            force_target = nil
            isretarget = false
        end

        -- Keep an explicitly provided target when still valid inside our search radius.
        if force_target ~= nil then
            local combat = ctrl.inst.replica.combat
            if combat ~= nil
                and CanSelectTarget(ctrl.inst, combat, force_target, use_force)
                and ctrl.inst:IsNear(force_target, SEARCH_RADIUS)
            then
                if isretarget and not IsEntityDead(force_target) and CanEntitySeeTarget(ctrl.inst, force_target) then
                    return force_target
                end
                return force_target
            end
            -- Do not fall back to vanilla here: it will happily force-attack walls.
            local nearest_retry = FindNearestMob(ctrl.inst, use_force)
            if nearest_retry ~= nil then
                return nearest_retry
            end
            return nil
        end

        local nearest = FindNearestMob(ctrl.inst, use_force)
        if nearest ~= nil then
            return nearest
        end

        -- Vanilla fallback, but strip walls/fences (force-attack path loves them).
        local vanilla = _GetAttackTarget(ctrl, force_attack, force_target, isretarget, use_remote_predict)
        if vanilla ~= nil and IsExcludedObject(vanilla) then
            return nil
        end
        return vanilla
    end

    local _DoAttackButton = self.DoAttackButton
    self.DoAttackButton = function(ctrl, retarget, isleftmouse)
        -- Left mouse stays vanilla; only F / attack-button path is expanded.
        if isleftmouse then
            return _DoAttackButton(ctrl, retarget, isleftmouse)
        end

        if not ctrl:IsEnabled() then
            return _DoAttackButton(ctrl, retarget, isleftmouse)
        end

        if ctrl:IsOverrideAttack() then
            return _DoAttackButton(ctrl, retarget, isleftmouse)
        end

        local inventory = ctrl.inst.replica.inventory
        if inventory ~= nil and (inventory:IsHeavyLifting() or inventory:IsFloaterHeld()) then
            return _DoAttackButton(ctrl, retarget, isleftmouse)
        end

        local force_attack = TheInput:IsControlPressed(CONTROL_FORCE_ATTACK) or INCLUDE_PASSIVE
        local target = ctrl:GetAttackTarget(force_attack, retarget, retarget ~= nil and retarget ~= ctrl:GetCombatTarget())

        if target ~= nil and IsExcludedObject(target) then
            target = nil
        end

        if target == nil then
            return _DoAttackButton(ctrl, retarget, isleftmouse)
        end

        local control = CONTROL_ATTACK

        if ctrl.ismastersim then
            ctrl.locomotor:PushAction(BufferedAction(ctrl.inst, target, ACTIONS.ATTACK), true)
        elseif ctrl.locomotor == nil then
            if ACTIONS.ATTACK.pre_action_cb ~= nil then
                ACTIONS.ATTACK.pre_action_cb(BufferedAction(ctrl.inst, target, ACTIONS.ATTACK))
            end
            ctrl:RemoteAttackButton(target, force_attack, false)
        else
            if ctrl.remote_controls[control] == nil then
                ctrl:RemoteAttackButton(nil, nil, false)
            end
            if ctrl:CanLocomote() then
                local buffaction = BufferedAction(ctrl.inst, target, ACTIONS.ATTACK)
                buffaction.preview_cb = function()
                    local isreleased = not TheInput:IsControlPressed(control)
                    ctrl:RemoteAttackButton(target, force_attack, false, isreleased)
                end
                ctrl.locomotor:PreviewAction(buffaction, true)
            end
        end
    end
end)

```



### 变体演进：Better Abigail (Mod 2361334841)
- **变体场景与切面**：收录来自工坊 Mod 2361334841 (`Better Abigail`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2361334841)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:abigail

AddPrefabPostInit("abigail", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return
	end
		inst:AddTag("crazy")
end)

```



### 变体演进：Woodrow (Mod 2881867062)
- **变体场景与切面**：收录来自工坊 Mod 2881867062 (`Woodrow`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2881867062)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:transistor

AddPrefabPostInit("transistor", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if not inst.components.tradable then
			inst:AddComponent("tradable")
		end
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:purebrilliance

AddPrefabPostInit("purebrilliance", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if not inst.components.tradable then
			inst:AddComponent("tradable")
		end
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:moonglass_charged

AddPrefabPostInit("moonglass_charged", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if not inst.components.tradable then
			inst:AddComponent("tradable")
		end
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:moonstorm_spark

AddPrefabPostInit("moonstorm_spark", function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if not inst.components.tradable then
			inst:AddComponent("tradable")
		end
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:zapncrack

AddPrefabPostInit("zapncrack", function(inst)	
	if GLOBAL.TheWorld.ismastersim then
		inst.entity:AddSoundEmitter()
		
		if not inst.components.trader then
			inst:AddComponent("trader")
		end
		
		local function onattackother(self)
			inst.components.finiteuses:Use(1) 
		end
		
		local function onfinished(inst, owner)
					if inst.components.equippable ~= nil then
	inst.components.weapon:SetDamage(1)
			end
		end
		
		local function AbleToAcceptTest(inst, item)
			return item ~= nil and item.prefab == "transistor" or item.tag == "transistor"
		end
		
		local function OnAccept(inst, giver, item)
			local fuelvalue =
			{
				["transistor"] = 75,
			}
			inst.SoundEmitter:PlaySound("dontstarve/common/lightningrod")
			if inst.components.finiteuses then
				inst.components.finiteuses:SetUses(inst.components.finiteuses:GetUses() + fuelvalue[item.prefab])
				if inst.components.finiteuses:GetPercent() > 1 then
					inst.components.finiteuses:SetPercent(1)
				end
			end
			if not 	inst.components.weapon:SetDamage(45) then
					inst.components.weapon:SetDamage(45)
			end
		end
		
		if inst.components.finiteuses ~= nil then
			inst.components.finiteuses:SetOnFinished(onfinished)
		end
		
		inst.components.trader:SetAbleToAcceptTest(AbleToAcceptTest)
		inst.components.trader.onaccept = OnAccept
	end
end)

```



### 变体演进：自动做饭 (Mod 3066039598)
- **变体场景与切面**：收录来自工坊 Mod 3066039598 (`自动做饭`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3066039598)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller

AddComponentPostInit("playercontroller", function(self, inst)
	if inst ~= ThePlayer then return end

	local PlayerControllerOnControl = self.OnControl
	self.OnControl = function(self, control, down)
		if down then -- 按下鼠标
			if not TUNING.AutoCooking then
				if control == CONTROL_PRIMARY and TheInput:IsControlPressed(CONTROL_FORCE_INSPECT) then
					Autocooking:fn()
				end
			else --TUNING.AutoCooking
				local target = TheInput:GetWorldEntityUnderMouse()
				local hud = TheInput:GetHUDEntityUnderMouse()
				local activate = ThePlayer.replica.inventory:GetActiveItem()
				if (control == CONTROL_SECONDARY or control == CONTROL_PRIMARY)
					and not (target or hud or activate) then
					Autocooking:fn()
				end
			end
		else
		end
		return PlayerControllerOnControl(self, control, down)
	end
	local oldpredict = self.DoPredictWalking
	function self:DoPredictWalking(dt)
		if not self.ismastersim and self.locomotor then
			local x, y, z = self.inst.Transform:GetPredictionPosition()
			if x == nil and KEY_util:MoveKeyDown() then
				self:RemotePredictWalking(self.inst:GetPosition().x, self.inst:GetPosition().z,
					self.locomotor:GetTimeMoving() == 0)
			end
		end
		return oldpredict(self, dt)
	end
end)

```



### 变体演进：Don (Mod 3693244442)
- **变体场景与切面**：收录来自工坊 Mod 3693244442 (`Don`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3693244442)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:burnable

    AddComponentPostInit("burnable", OnBurnablePostInit)
end

if cfg_temp_heatrock or cfg_light_heatrock or cfg_moisture_heatrock then
    local function UpdateTemp(inst)
        local ambient_temp = GetLocalTemperature(inst)
        local heatrock_cur_temp = inst.components.temperature:GetCurrent()
        local heatrock_target_temp = math.clamp(70 - ambient_temp, TUNING.MIN_ENTITY_TEMP, TUNING.MAX_ENTITY_TEMP)

        if math.abs(heatrock_cur_temp - heatrock_target_temp) > 1 then
            inst.components.temperature:SetTemperature(heatrock_target_temp)
        end

        local owner = inst.components.inventoryitem:GetGrandOwner()
        if owner and owner:HasTag("player") then
            local player_cur_temp = owner.components.temperature:GetCurrent()
            local player_target_temp = math.clamp(player_cur_temp, 20, 50)

            if math.abs(player_cur_temp - player_target_temp) > 1 then
                owner.components.temperature:SetTemperature(player_target_temp)
            end
        end
    end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:heatrock

    AddPrefabPostInit("heatrock", OnHeatRockPostInit)
end

if cfg_ghost_player then
    local function OnBecameGhost(inst)
        inst.components.locomotor:SetExternalSpeedMultiplier(inst, "ghost_speed", 5)
    end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:inventory

    AddComponentPostInit("inventory", OnInventoryPostInit)

    local function OnDrownablePostInit(self)
        local _ShouldDropItems = self.ShouldDropItems
        if _ShouldDropItems then
            local function NewShouldDropItems(self)
                if self.inst:HasTag("player") then
                    return false
                end
                return _ShouldDropItems(self)
            end
            self.ShouldDropItems = NewShouldDropItems
        end

        local _OnFallInOcean = self.OnFallInOcean
        if _OnFallInOcean then
            local function NewOnFallInOcean(self, shore_x, shore_y, shore_z)
                local inv = self.inst.components.inventory
                local active_item = inv and inv:GetActiveItem()

                if active_item then
                    inv.activeitem = nil
                end

                _OnFallInOcean(self, shore_x, shore_y, shore_z)

                if active_item then
                    inv.activeitem = active_item
                end
            end
            self.OnFallInOcean = NewOnFallInOcean
        end
    end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:drownable

    AddComponentPostInit("drownable", OnDrownablePostInit)

    local function FixRender(inst)
        if not inst.sg:HasStateTag("busy") then
            if inst.fix_render then
                inst.fix_render:Cancel()
                inst.fix_render = nil
            end

            local inv = inst.components.inventory
            local equips = {}

            for index, item in pairs(inv.equipslots) do
                equips[index] = item
            end

            for index, item in pairs(equips) do
                inv:Unequip(index, nil, true)
                inv:Equip(item)
            end
        end
    end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:upgrademoduleowner

    AddComponentPostInit("upgrademoduleowner", OnUpgradeModuleOwnerPostInit)

    local function OnWX78BackupBodyPostInit(inst)
        if not TheWorld.ismastersim then return end

        local _Remove = inst.Remove
        if _Remove then
            local function NewRemove(inst)
                inst.wx78_backupbody_inventory.components.inventory:DropEverything()
                inst.components.container:DropEverything()

                local items = inst.components.socketholder:UnsocketEverything()
                for _, item in ipairs(items) do
                    inst.components.lootdropper:FlingItem(item)
                end

                local modules = inst.components.upgrademoduleowner:PopAllModules()
                for _, onemodule in ipairs(modules) do
                    inst.components.lootdropper:FlingItem(onemodule)
                end

                return _Remove(inst)
            end
            inst.Remove = NewRemove
        end
    end

```



### 变体演进：󰀄 Ember Favor 󰀄 (Mod 2938233879)
- **变体场景与切面**：收录来自工坊 Mod 2938233879 (`󰀄 Ember Favor 󰀄`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2938233879)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:forest

AddPrefabPostInit("forest", function(inst)
	if not inst.ismastersim then
		return inst
	end
	
	inst:AddComponent("embereventmanager")
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:cave

AddPrefabPostInit("cave", function(inst)
	if not inst.ismastersim then
		return inst
	end
	
	inst:AddComponent("embereventmanager")
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:portablecookpot

AddPrefabPostInit("portablecookpot", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.stewer then
		inst.components.stewer.emberfavorsymbol = "wood"
	end
end)

```



### 变体演进：Wilson S. Kennedy (Mod 3805587491)
- **变体场景与切面**：收录来自工坊 Mod 3805587491 (`Wilson S. Kennedy`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3805587491)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:beard

AddPrefabPostInit("beard", function(inst)
    if inst and inst.AnimState then
        inst.AnimState:SetBuild("Beard")
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:wilson

AddPrefabPostInit("wilson", function(inst)
    if inst and inst.AnimState then
        inst.AnimState:SetBuild("Wilson S. Kennedy")
    end
end)

```


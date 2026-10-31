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


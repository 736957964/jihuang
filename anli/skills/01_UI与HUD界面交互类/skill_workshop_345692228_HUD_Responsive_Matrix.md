# 饥荒一线工坊深度研读 Skill：HUD 矩阵反缩放自适应与视口输入隔离机制

- **工坊 ID**：345692228 (`Minimap HUD`)
- **领域分类**：客户端 UI 工程、HUD 矩阵逆缩放坐标系对齐、窗口动态重排、摄像机与输入冲突隔离
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发饥荒联机版的悬浮窗口、状态栏或雷达时，开发者常面临：
1. 玩家调整了游戏系统设置中的 **HUD 缩放比例**，导致控件溢出屏幕边缘；
2. 玩家**拖动窗口边框**或在全屏/无边框窗口间切换，UI 错位；
3. 鼠标悬停在 UI 上滚动滚轮，误触发游戏视角拉近拉远。

`Minimap HUD` 提炼了一套纯数学且极其轻量的防御框架。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式：自适应 HUD 挂载与输入隔离容器 (scripts/widgets/responsive_hud_container.lua)
-- ==============================================================================

local Widget = require "widgets/widget"

local ResponsiveContainer = Class(Widget, function(self, owner)
    Widget._ctor(self, "ResponsiveContainer")
    self.owner = owner
    self.camera_lock = false
end)

-- 1. 矩阵逆缩放贴边算法 (支持九宫格锚定)
function ResponsiveContainer:Reposition(controls, align_x, align_y, margin_x, margin_y)
    local hudscale = controls.top_root:GetScale()
    local screenw_full, screenh_full = GLOBAL.TheSim:GetScreenSize()
    
    -- 反向求出真实逻辑视口坐标
    local screenw = screenw_full / hudscale.x
    local screenh = screenh_full / hudscale.y

    local target_x = 0
    local target_y = 0

    if align_x == "right" then
        target_x = (screenw * 0.5) - margin_x
    elseif align_x == "left" then
        target_x = -(screenw * 0.5) + margin_x
    end

    if align_y == "top" then
        target_y = (screenh * 0.5) - margin_y
    elseif align_y == "bottom" then
        target_y = -(screenh * 0.5) + margin_y
    end

    self:SetPosition(target_x, target_y, 0)
end

-- 2. 鼠标滚轮焦点与摄像机缩放阻断
function ResponsiveContainer:OnGainFocus()
    ResponsiveContainer._base.OnGainFocus(self)
    if GLOBAL.TheCamera and GLOBAL.TheCamera:IsControllable() then
        self.camera_lock = true
        GLOBAL.TheCamera:SetControllable(false)
    end
end

function ResponsiveContainer:OnLoseFocus()
    ResponsiveContainer._base.OnLoseFocus(self)
    if self.camera_lock and GLOBAL.TheCamera then
        GLOBAL.TheCamera:SetControllable(true)
        self.camera_lock = false
    end
end

-- 3. 消费滚轮与控制事件，防止穿透到底层世界
function ResponsiveContainer:OnControl(control, down)
    if ResponsiveContainer._base.OnControl(self, control, down) then return true end
    if control == GLOBAL.CONTROL_MAP_ZOOM_IN or control == GLOBAL.CONTROL_MAP_ZOOM_OUT then
        -- 内部消费滚轮缩放事件
        return true
    end
    return false
end

return ResponsiveContainer
```

---

## 三、避坑与生产安全准则

1. **`OnLoseFocus` 必须兜底防漏**：
   - 如果用户在悬停该 UI 的瞬间按下了 ESC 键切出菜单，或者切回桌面，可能会跳过 `OnLoseFocus`。建议在控件的 `Kill` 和 `Hide` 方法中，同样加入对 `TheCamera:SetControllable(true)` 的安全恢复调用，防止玩家摄像机被永久锁死。
2. **`controls.OnUpdate` 增量轻量比较**：
   - 监听窗口分辨率变化时，切忌每帧去调用复杂的布局计算。只在 `w ~= last_w or h ~= last_h` 时才触发一次 `Reposition`。


## 五、进阶拓扑演进与变体分支

### 变体演进：Mod 2880540712 (Mod 2880540712)
- **变体场景与切面**：收录来自工坊 Mod 2880540712 (`Mod 2880540712`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2880540712)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:inventory
AddComponentPostInit("inventory", function(self,inst)
    local original_Equip = self.Equip
    self.Equip = function(self, item, old_to_active, no_animation)
        local eslot = item.components.equippable.equipslot
        if item ~= nil and
            self.equipslots[eslot] ~= nil and
            item.components.inventoryitem.owner ~= nil then --可执行
            if item.components.inventoryitem.owner.components.container ~= nil then --存放在背包/其他容器内
                self.equipslots[eslot].prevcontainer = item.components.inventoryitem.owner.components.container
                if item.components.inventoryitem.owner.components.inventoryitem ~= nil then --背包
                    self.equipslots[eslot].prevslot = item.components.inventoryitem.owner.components.container:GetItemSlot(item)
                else --其他
                    self.equipslots[eslot].prevslot = item.components.inventoryitem.owner.components.container:GetItemSlot(item)
                end
            else --存放在物品栏中
                self.equipslots[eslot].prevcontainer = item.prevcontainer
                self.equipslots[eslot].prevslot = self:GetItemSlot(item)
            end
        end
        return original_Equip(self, item, old_to_active, no_animation)
    end
end)

```



### 变体演进：Quick Pick (Mod 2923790645)
- **变体场景与切面**：收录来自工坊 Mod 2923790645 (`Quick Pick`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2923790645)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:sapling

AddPrefabPostInit("sapling", pick)
AddPrefabPostInit("marsh_bush", pick)
AddPrefabPostInit("reeds", pick)
AddPrefabPostInit("grass", pick)
AddPrefabPostInit("berrybush2", pick)
AddPrefabPostInit("berrybush_snake", pick)
AddPrefabPostInit("berrybush2_snake", pick)
AddPrefabPostInit("berrybush", pick)
AddPrefabPostInit("flower_cave", pick)
AddPrefabPostInit("flower_cave_double", pick)
AddPrefabPostInit("flower_cave_triple", pick)
AddPrefabPostInit("red_mushroom", pick)
AddPrefabPostInit("green_mushroom", pick)
AddPrefabPostInit("blue_mushroom", pick)
AddPrefabPostInit("cactus", pick)
AddPrefabPostInit("lichen", pick)
AddPrefabPostInit("seaweed_planted", pick)
AddPrefabPostInit("limpetrock", pick)
AddPrefabPostInit("grass_water", pick)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:marsh_bush
AddPrefabPostInit("sapling", pick)
AddPrefabPostInit("marsh_bush", pick)
AddPrefabPostInit("reeds", pick)
AddPrefabPostInit("grass", pick)
AddPrefabPostInit("berrybush2", pick)
AddPrefabPostInit("berrybush_snake", pick)
AddPrefabPostInit("berrybush2_snake", pick)
AddPrefabPostInit("berrybush", pick)
AddPrefabPostInit("flower_cave", pick)
AddPrefabPostInit("flower_cave_double", pick)
AddPrefabPostInit("flower_cave_triple", pick)
AddPrefabPostInit("red_mushroom", pick)
AddPrefabPostInit("green_mushroom", pick)
AddPrefabPostInit("blue_mushroom", pick)
AddPrefabPostInit("cactus", pick)
AddPrefabPostInit("lichen", pick)
AddPrefabPostInit("seaweed_planted", pick)
AddPrefabPostInit("limpetrock", pick)
AddPrefabPostInit("grass_water", pick)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:reeds
AddPrefabPostInit("marsh_bush", pick)
AddPrefabPostInit("reeds", pick)
AddPrefabPostInit("grass", pick)
AddPrefabPostInit("berrybush2", pick)
AddPrefabPostInit("berrybush_snake", pick)
AddPrefabPostInit("berrybush2_snake", pick)
AddPrefabPostInit("berrybush", pick)
AddPrefabPostInit("flower_cave", pick)
AddPrefabPostInit("flower_cave_double", pick)
AddPrefabPostInit("flower_cave_triple", pick)
AddPrefabPostInit("red_mushroom", pick)
AddPrefabPostInit("green_mushroom", pick)
AddPrefabPostInit("blue_mushroom", pick)
AddPrefabPostInit("cactus", pick)
AddPrefabPostInit("lichen", pick)
AddPrefabPostInit("seaweed_planted", pick)
AddPrefabPostInit("limpetrock", pick)
AddPrefabPostInit("grass_water", pick)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:grass
AddPrefabPostInit("reeds", pick)
AddPrefabPostInit("grass", pick)
AddPrefabPostInit("berrybush2", pick)
AddPrefabPostInit("berrybush_snake", pick)
AddPrefabPostInit("berrybush2_snake", pick)
AddPrefabPostInit("berrybush", pick)
AddPrefabPostInit("flower_cave", pick)
AddPrefabPostInit("flower_cave_double", pick)
AddPrefabPostInit("flower_cave_triple", pick)
AddPrefabPostInit("red_mushroom", pick)
AddPrefabPostInit("green_mushroom", pick)
AddPrefabPostInit("blue_mushroom", pick)
AddPrefabPostInit("cactus", pick)
AddPrefabPostInit("lichen", pick)
AddPrefabPostInit("seaweed_planted", pick)
AddPrefabPostInit("limpetrock", pick)
AddPrefabPostInit("grass_water", pick)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:berrybush2
AddPrefabPostInit("grass", pick)
AddPrefabPostInit("berrybush2", pick)
AddPrefabPostInit("berrybush_snake", pick)
AddPrefabPostInit("berrybush2_snake", pick)
AddPrefabPostInit("berrybush", pick)
AddPrefabPostInit("flower_cave", pick)
AddPrefabPostInit("flower_cave_double", pick)
AddPrefabPostInit("flower_cave_triple", pick)
AddPrefabPostInit("red_mushroom", pick)
AddPrefabPostInit("green_mushroom", pick)
AddPrefabPostInit("blue_mushroom", pick)
AddPrefabPostInit("cactus", pick)
AddPrefabPostInit("lichen", pick)
AddPrefabPostInit("seaweed_planted", pick)
AddPrefabPostInit("limpetrock", pick)
AddPrefabPostInit("grass_water", pick)

```



### 变体演进：Full Build Refund (Mod 3820010792)
- **变体场景与切面**：收录来自工坊 Mod 3820010792 (`Full Build Refund`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3820010792)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:workable
-- when disabled; a save without the mod removes it. No new save component.
AddComponentPostInit("workable", function(self)
    local save, load = self.OnSave, self.OnLoad
    self.OnSave = function(c, ...)
        local data = save(c, ...)
        if c[PAID] then data[PAID] = c[PAID] end
        return data
    end
    self.OnLoad = function(c, data, ...)
        load(c, data, ...)
        c[PAID] = data and validPaid(data[PAID]) or nil
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:builder
-- structures. BufferBuild can pay before placement, including across reloads.
AddComponentPostInit("builder", function(self)
    local pending = {}
    local remove = self.RemoveIngredients
    self.RemoveIngredients = function(c, ingredients, recname, discounted, ...)
        local recipe = G.AllRecipes[recname]
        local paid
        if recipe and recipe.placer and recipe.numtogive == 1 and not c.freebuildmode then
            local cost, reduced = {}, false
            for _, ing in ipairs(recipe.ingredients) do
                local count = 0
                for _, amount in pairs(ingredients[ing.type] or {}) do count = count + amount end
                cost[ing.type] = count
                reduced = reduced or count < ing.amount
            end
            if reduced then paid = { product = recipe.product, cost = cost } end
        end
        local result = pack(remove(c, ingredients, recname, discounted, ...))
        if recipe and recipe.placer then pending[recname] = paid end
        return unpack(result, 1, result.n)
    end
    self.inst:ListenForEvent("buildstructure", function(_, data)
        if not (data and data.recipe and data.item) then return end
        local recname = data.recipe.name
        local paid = pending[recname]
        local w = data.item.components.workable
        if paid and paid.product == data.item.prefab and w and w:GetWorkAction() == G.ACTIONS.HAMMER then
            w[PAID] = paid
        end
        pending[recname] = nil
    end)
    local save, load = self.OnSave, self.OnLoad
    self.OnSave = function(c, ...)
        local data = save(c, ...)
        local buffered = {}
        for name, paid in pairs(pending) do
            if c:IsBuildBuffered(name) then buffered[name] = paid end
        end
        if G.next(buffered) then data[PAID] = buffered end
        return data
    end
    self.OnLoad = function(c, data, ...)
        load(c, data, ...)
        pending = {}
        if data and type(data[PAID]) == "table" then
            for name, paid in pairs(data[PAID]) do
                if c:IsBuildBuffered(name) then pending[name] = validPaid(paid) end
            end
        end
    end
end)

```



### 变体演进：Auto-Equip Light (Mod 3465643011)
- **变体场景与切面**：收录来自工坊 Mod 3465643011 (`Auto-Equip Light`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3465643011)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller

AddComponentPostInit("playercontroller", function(self)
    if self.inst and self.inst:HasTag("player") then
        self.inst:AddComponent("lightauto")
    end
end)

```



### 变体演进：猪人房重建 (Pig House Rebuild) (Mod 3804423239)
- **变体场景与切面**：收录来自工坊 Mod 3804423239 (`猪人房重建 (Pig House Rebuild)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3804423239)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:<房子>
    实现思路（针对 DST build 747465 的源码设计，全部有出处）
      1. AddPrefabPostInit("<房子>") 把 components.workable.onfinish 包一层
         （猪人房 pighouse.lua:411 / 兔人房 rabbithouse.lua:208 注册；
          workable.lua:162 是**直接调用** self.onfinish，所以换掉它 = 接管销毁）。
      2. 包的那层先原样调用原版 onfinish（放生物 / DropLoot / collapse_big
         / Remove 全部照旧），所以拆掉那一瞬间和原版 100% 一样。
      3. 拆除前记住坐标，回调返回后生成对应的"遗址"实体（只有"记性"）。
      4. 烧毁走另一条路：监听 "burntup"（standardcomponents.lua:58 推的），
         在焦黑房子自己身上挂倒计时。
      5. 倒计时结束 → SpawnPrefab("<房子>") + PushEvent("onbuilt")
         播放房子自带的 "place" 生长动画。

    兔人房和猪人房在源码上的差异（已逐个核对）
      · rabbithouse.lua:49-65 onhammered 与 pighouse 同构：Extinguish → 取消
        doortask → spawner:ReleaseChild()（兔人跑出来）→ lootdropper:DropLoot()
        → collapse_big(wood) → Remove()。⇒ 同一套"包 onfinish"的写法直接可用。
      · rabbithouse.lua:225 MakeMediumBurnable(inst, nil, nil, true)  +  :227
        监听 "burntup" ⇒ 会被烧成焦黑废墟（standardcomponents.lua:52-70：
        加 "burnt" tag、播 "burnt" 动画、workleft=1），焦黑重建那条路同样可用。
      · rabbithouse.lua:233 也监听 "onbuilt" ⇒ "玩家自己盖的"判据同样可用。
      · 兔人 bunnyman.lua:363-368 的 tag 里有 "manrabbit"，**也有 "pig"**
        （所以"等猪人"那个搜索会顺带数到兔人，这里改用 "manrabbit" 精确匹配）。
      · anim/rabbit_house.zip 里确实有 idle / lit / unbuilt / hit / burnt / place
        （已解析 anim.bin 确认）⇒ 重建时的 "place" 生长动画可以复用。

    关于掉落
      原版结构掉落 = 配方材料 × TUNING.HAMMER_LOOT_PERCENT(0.5)
      （lootdropper.lua:242 / GetRecipeLoot）
        · 猪人房配方 recipes.lua:583 {boards 4, cutstone 3, pigskin 4}
          → 2 木板 + 2 石砖 + 2 猪皮
        · 兔人房配方 recipes.lua:584 {boards 4, carrot 10, manrabbit_tail 4}
          → 2 木板 + 5 胡萝卜 + 2 兔人尾巴
      所以"重建出来的房子"关掉 lootdropper.droprecipeloot 就能堵住无限刷材料
      （兔人房尤其要看住：兔人尾巴本身是盖兔人房的材料）。
----------------------------------------------------------------------]]

PrefabFiles = {
    "rebuildsite",      -- scripts/prefabs/rebuildsite.lua（mods.lua:696 会自动补 "prefabs/"）
}

Assets = {
    -- 复用游戏自带的"地面痕迹"贴花素材，不需要新美术
    -- （Asset 在白名单里，可以用裸名；这里照样写清楚来源）
    Asset("ANIM", "anim/scorched_ground.zip"),
}

--==============================================================
--  配置：两种房子各一套，互不影响
--==============================================================
--  ⚠️ 加/改配置项的同步清单（少改一处就会出现"设置读不到时悄悄回落成旧默认"）：
--    ① modinfo.lua 的 options + default
--    ② 下面 PIG_CFG / RABBIT_CFG 里 `or <兜底>` 的兜底值
--    ③ README 的配置表 + 正文里散落的"默认 N 天"这类句子
--    ④ 版本号 + 更新记录
--    改完用「定义 ↔ 读取」对表验证（键必须是**字面量**，别用字符串拼接，
--    拼接了这个对表就查不出来了）：
--      $mi = [regex]::Matches((Get-Content modinfo.lua -Raw), 'name = "([A-Z][A-Za-z0-9_]+)"') | %{ $_.Groups[1].Value }
--      $mm = [regex]::Matches((Get-Content modmain.lua -Raw), 'GetModConfigData\("([A-Za-z0-9_]+)"\)') | %{ $_.Groups[1].Value }
--      Compare-Object $mi $mm        # 期望为空

local DAY = (GLOBAL.TUNING ~= nil and GLOBAL.TUNING.TOTAL_DAY_TIME) or 480

-- 猪人房那一套。配置键沿用 v0.1.x 的 PHR_*（**故意不改名**：
-- 改了键名 = 玩家之前在游戏里选过的值会被当成"没设置过"而回落默认）
local PIG_CFG =
{
    days          = GetModConfigData("PHR_DAYS") or 4,   -- 兜底值和 modinfo 的 default 保持一致（4 天）
    mode          = GetModConfigData("PHR_MODE") or "timer",
    drop          = GetModConfigData("PHR_DROP") or "reduced",
    burnt_rebuild = GetModConfigData("PHR_BURNT"),
    mark          = GetModConfigData("PHR_MARK"),
    playerbuilt   = GetModConfigData("PHR_PLAYERBUILT"),
}

-- 兔人房那一套（v0.3.0 起和猪人房完全分开，键是 PHR_R_*）
local RABBIT_CFG =
{
    days          = GetModConfigData("PHR_R_DAYS") or 4,
    mode          = GetModConfigData("PHR_R_MODE") or "timer",
    drop          = GetModConfigData("PHR_R_DROP") or "reduced",
    burnt_rebuild = GetModConfigData("PHR_R_BURNT"),
    mark          = GetModConfigData("PHR_R_MARK"),
    playerbuilt   = GetModConfigData("PHR_R_PLAYERBUILT"),
}

-- 兔人房总开关：关掉就完全不接管兔人房（已躺在地上的遗址不受影响）
local RABBIT_ENABLED = GetModConfigData("PHR_RABBIT")

-- 把 days 换算成秒，并给布尔项兜底。
-- ⚠️ 布尔选项**不能**用 `or 默认值`：用户选"否"返回的是 false，`or` 会把它吃掉变回默认
local function FixHouseCfg(c, burnt_default, mark_default, built_default)
    if c.burnt_rebuild == nil then c.burnt_rebuild = burnt_default end
    if c.mark == nil then c.mark = mark_default end
    -- 默认：玩家自己盖的房子拆了/烧了不重建（用户定的默认值）
    if c.playerbuilt == nil then c.playerbuilt = built_default end
    c.seconds = math.max(30, math.floor(c.days * DAY))   -- 重建倒计时（秒）
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:scorchedground
--  只有"我们自己放的"痕迹才带 phr_target 字段，原版烧焦地面读到就跳过，行为不变。
AddPrefabPostInit("scorchedground", function(inst)
    local cfg  = GLOBAL.PHR_CFG
    local wrap = cfg ~= nil and cfg.wrap_trace_save or nil
    if wrap ~= nil then
        wrap(inst)
    end
end)

```



### 变体演进：Quicker Beefalo Domestication (Mod 2833026884)
- **变体场景与切面**：收录来自工坊 Mod 2833026884 (`Quicker Beefalo Domestication`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2833026884)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:beefalo
if GetModConfigData("domestication_nopoop") then
    AddPrefabPostInit("beefalo", function(inst)
        if not GLOBAL.TheWorld.ismastersim then return inst end

        if inst.components.periodicspawner ~= nil then
            local _SetSpawnTestFn = inst.components.periodicspawner.SetSpawnTestFn
            inst.components.periodicspawner:SetSpawnTestFn(function(inst)
                if inst.components.domesticatable and inst.components.domesticatable:IsDomesticated() then
                    return false
                else
                    return _SetSpawnTestFn(inst)
                end
            end)
        end
    end)

```



### 变体演进：HEADER (Mod 3590081957)
- **变体场景与切面**：收录来自工坊 Mod 3590081957 (`HEADER`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3590081957)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:vault_portal_fx

AddPrefabPostInit("vault_portal_fx", function(inst)
	if not (TheMod.navigator and TheMod.navigator:IsActivated()) then return end
	--
	inst:DoTaskInTime(0, function(inst)
		TheMod.navigator:OnPortalFX(inst)
	end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:playercontroller
-- Expect rooms upon right clicking a teleporter
AddComponentPostInit("playercontroller", function(self)
	local oldrightfn = self.OnRightClick
	function self:OnRightClick(down)
		if down and TheMod.navigator then
			local act = self:GetRightMouseAction()
			local target = TheInput:GetWorldEntityUnderMouse()

			if act and act.action == ACTIONS.STARTCHANNELING and target and target:HasTag("virtualroomteleporter") and TheMod.navigator:IsActivated() then
				TheMod.navigator:ExpectRoom(target.destination_room) 
			end
		end
		return oldrightfn(self, down)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:vault_teleporter

AddPrefabPostInit("vault_teleporter", function(inst) 
	TheMod.do_areacheck = true -- activates area checks
	--
	inst.CreateStarTrail = CreateStarTrail
	inst.StopStarTrail = StopStarTrail
	waymarks[inst] = true
	inst:ListenForEvent("onremove", onremove)
end)

```



### 变体演进：人物hud限制解除器 (Mod 3100347966)
- **变体场景与切面**：收录来自工坊 Mod 3100347966 (`人物hud限制解除器`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3100347966)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller
})
AddComponentPostInit("playercontroller", function(self, inst)
    if inst ~= ThePlayer then return end
    local oldenable = self.IsEnabled
    function self:IsEnabled()
        --mmdx_print(self.inst.HUD)
        if ThePlayer and ThePlayer.prefab == 'wathom' and ThePlayer:HasTag('attack') then
            return oldenable(self)
        elseif TheFrontEnd and TheFrontEnd.textProcessorWidget then
            return oldenable(self)
        else
            return true
        end
    end

    local old1 = self.DoCameraControl
    function self:DoCameraControl()
        local isenabled, ishudblocking = oldenable(self)
        if not isenabled and not ishudblocking then
            return
        end
        return old1(self)
    end

    local OldOnControl = self.OnControl
    function self:OnControl(control, down)
        if self:IsEnabled() and not oldenable(self) and down and control >= GLOBAL.CONTROL_INV_1 and control <= GLOBAL.CONTROL_INV_10 then
            local inventory = GLOBAL.ThePlayer.replica.inventory
            if inventory ~= nil then
                local hot_key_num = control - GLOBAL.CONTROL_INV_1 + 1
                local new_item = inventory:GetItemInSlot(hot_key_num)
                inventory:UseItemFromInvTile(new_item)
            end
        end
        --print(control, down)
        return OldOnControl(self, control, down)
    end
end)
--地图移动
AddClassPostConstruct("screens/mapscreen", function(self)
    local oldupdate = self.OnUpdate
    self.OnUpdate = function(self, dt)
        local olddeadzone = TUNING.CONTROLLER_DEADZONE_RADIUS
        TUNING.CONTROLLER_DEADZONE_RADIUS = 100
        local result = oldupdate(self, dt)
        TUNING.CONTROLLER_DEADZONE_RADIUS = olddeadzone
        return result
    end
end)

```



### 变体演进：Auto-Unequip (Mod 3381334962)
- **变体场景与切面**：收录来自工坊 Mod 3381334962 (`Auto-Unequip`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3381334962)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:inventoryitem_classified

AddPrefabPostInit('inventoryitem_classified', function (inst)
	if not G.TheNet:IsDedicated() then
		inst:DoTaskInTime(0, function ()
			PostInit(inst)
		end)
	end
end)

```



### 变体演进：Auto-Unequip on 1-20% (2026 Update) (Mod 2706972372)
- **变体场景与切面**：收录来自工坊 Mod 2706972372 (`Auto-Unequip on 1-20% (2026 Update)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2706972372)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller

AddComponentPostInit(
    "playercontroller",
    function(self)
        if self.inst ~= GLOBAL.ThePlayer then
            return
        end
        -- self.inst:ListenForEvent("equip", checkEquip)
        self.inst:ListenForEvent("equip", checkEquip)
    end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:inventoryitem_classified

AddPrefabPostInit(
    "inventoryitem_classified",
    function(inst)
        if not G.TheNet:IsDedicated() then
            inst:DoTaskInTime(
                0,
                function()
                    PostInit(inst)
                end
            )
        end
    end

```



### 变体演进：[Gorge] Victorian HUD (Mod 1583765151)
- **变体场景与切面**：收录来自工坊 Mod 1583765151 (`[Gorge] Victorian HUD`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 1583765151)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player
-- delay to make sure it runs after other mods
AddPrefabPostInit("player", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", BadgePostConstruct)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world

AddPrefabPostInit("world", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", WetBadgePostConstruct)
	end
end)

```


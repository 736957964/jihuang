# 饥荒一线工坊深度研读 Skill：高性能动态波次刷怪与防卡顿内存自回收机制

- **来源工程**：`十面埋伏 (#MOD-shimianmaifu)` 与 `smallAn.md 工业案例`
- **核心逻辑对应**：`scripts/components/rp_monster_point.lua`、`rp_autodelete.lua`
- **领域分类**：服务端动态事件生成器、Passable 坐标安全探测、防卡顿自销毁回收（TTL/Despawn）

---

## 一、核心实现原理与架构全貌

在开放世界或塔防/刷怪类 MOD 中，未经节制的实体生成是服务器严重掉帧（TPS 跌至 5~10）乃至世界坏档的首要元凶。常见弊病包括：怪刷入不可行走的海洋/虚空、玩家跑路后怪物永久留在遥远未加载区域常驻内存、怪物死亡后引用表未释放导致泄露。十面埋伏工程给出了标准工业级闭环：

### 1. 严格的地皮合法性与防卡死断言（Passable Detection）
- 必须通过 `TheWorld.Map:IsPassableAtPoint(x, 0, z)` 校验地皮是否可行走，并剔除阻挡实体。
- 严禁向虚空投掷怪兽，否则怪物每帧都会进行寻路碰撞探测，导致主线程物理引擎开销飙升。

### 2. 弱引用倒序遍历与存活上限（Max Alive Gate）
- 维护刷怪器本地表 `spawned_monsters = {}`。
- 每次触发新波次前，执行**倒序循环**（`for k = #self.spawned_monsters, 1, -1`）清洗已失效句柄（`not m:IsValid() or m.components.health:IsDead()`），彻底消除野指针。
- 设立同屏上限（`max_alive`），达到上限时自动挂起生成，绝不无脑堆怪。

### 3. 脱战缓释与无痛回收机制（Autodelete / Despawn）
- 给生成的怪兽动态挂载超时自毁任务（TTL）：若在 N 秒（如 120 秒）后仍无战斗目标（`not monster.components.combat.target`），并且与所有玩家距离大于设定视距，生成离场特效（`small_puff`）后直接平滑 `Remove()`。

---

## 二、标准化生产级代码范式 (可直接复用)

```lua
-- ==============================================================================
-- 范式：工业级波次怪物生成与内存回收组件 (scripts/components/dynamic_wave_spawner.lua)
-- ==============================================================================

local DynamicWaveSpawner = Class(function(self, inst)
    self.inst = inst
    self.interval = 30         -- 生成周期 (秒)
    self.max_monsters = 8      -- 场上最大并发存活数
    self.spawn_radius_min = 6
    self.spawn_radius_max = 14
    self.monsters = {}
    self.prefab_pool = { "spider", "spider_warrior" }
    self.task = nil
end)

function DynamicWaveSpawner:Start()
    if self.task == nil then
        self.task = self.inst:DoPeriodicTask(self.interval, function() self:OnSpawnTick() end)
    end
end

function DynamicWaveSpawner:OnSpawnTick()
    -- 1. 倒序逆向清洗无效引用，杜绝内存泄漏
    for i = #self.monsters, 1, -1 do
        local m = self.monsters[i]
        if not (m and m:IsValid()) or (m.components.health and m.components.health:IsDead()) then
            table.remove(self.monsters, i)
        end
    end

    -- 2. 闸门守卫：同屏存活已满，放弃本波生成
    if #self.monsters >= self.max_monsters then
        return
    end

    -- 3. 极坐标安全点探测
    local cx, cy, cz = self.inst.Transform:GetWorldPosition()
    local angle = math.random() * 2 * PI
    local radius = math.random(self.spawn_radius_min, self.spawn_radius_max)
    local sx = cx + radius * math.cos(angle)
    local sz = cz + radius * math.sin(angle)

    -- 地皮可行走断言
    if TheWorld.Map:IsPassableAtPoint(sx, 0, sz) then
        local chosen_prefab = self.prefab_pool[math.random(#self.prefab_pool)]
        local monster = SpawnPrefab(chosen_prefab)
        if monster then
            monster.Transform:SetPosition(sx, 0, sz)
            
            -- 4. 挂载脱战自销毁守卫，防止玩家离开后怪物常驻
            monster:DoPeriodicTask(15, function(target)
                if target:IsValid() and (not target.components.combat or target.components.combat.target == nil) then
                    -- 检查 30 码内是否有活着的玩家
                    local nearest_player = FindEntity(target, 30, nil, { "player" }, { "playerghost" })
                    if nearest_player == nil then
                        SpawnPrefab("small_puff").Transform:SetPosition(target.Transform:GetWorldPosition())
                        target:Remove()
                    end
                end
            end)

            table.insert(self.monsters, monster)
        end
    end
end

function DynamicWaveSpawner:OnRemoveFromEntity()
    if self.task then
        self.task:Cancel()
        self.task = nil
    end
end

return DynamicWaveSpawner
```

---

## 三、踩坑与避错实战指南

1. **`table.remove` 的正序循环陷阱**：
   - 永远不要用正序 `for i = 1, #list do if ... table.remove(list, i) end end` 移除数组元素！因为删除元素会导致后续索引前移，导致紧接着的下一个元素被直接跳过，漏清理的死亡怪兽会长期占用引用表槽位。
2. **生成动画（Spawn Animation）的物理穿模**：
   - 如果怪物具有专属破土而出或跳跃入场动画，在播放入场动画期间，必须先打上 `inst.Physics:SetActive(false)` 或使用碰撞掩码，直到动画结束才激活碰撞；否则多只怪生成在重叠点时，会被饥荒物理引擎瞬间向外以超高速度弹射（甚至弹进深海虚空）。

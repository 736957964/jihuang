# 饥荒一线工坊深度研读 Skill：空间几何网格吸附与对象池增量渲染引擎

- **工坊 ID**：351325790 (`Geometric Placement`)
- **领域分类**：纯客机几何投影引擎、Placer 切面重写、对象池增量位移、帧时间预算控制
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

`Geometric Placement` 的核心在于：将鼠标发散无序的世界连续坐标系，通过**仿射矩阵投影**映射到抽象的离散晶格空间（Lattice Space），完成吸附后逆向投影回世界坐标，并借助**增量对象池**与**时间预算**渲染出视觉网格。

### 1. 晶格坐标与世界坐标双向投影公式
设晶格坐标为 $(u, v)$，行偏移向量为 $\vec{r} = (r_x, r_z)$，列偏移向量为 $\vec{c} = (c_x, c_z)$：
$$x = u \cdot c_x + v \cdot r_x$$
$$z = u \cdot c_z + v \cdot r_z$$
通过调整行向量与列向量的角度（如夹角 60° 或 120°），即可自然形成正六边形或菱形点阵，完全无需硬编码几何判断。

### 2. 对象池增量滑窗算法
当光标在晶格间移动 $\Delta u, \Delta v$ 时：
- **移出窗格**：旧区域边缘点不销毁，直接 `Hide()` 并压入空闲队列 `to_move_list`；
- **进入窗格**：新区域点优先从 `to_move_list` 弹出，调用 `Transform:SetPosition(...)` 并 `Show()`；
- **开销**：单帧内存申请数为 0，几何计算复杂度由 $O(N^2)$ 降为 $O(\Delta N)$。

---

## 二、标准化生产级代码范式 (可直接移植开发)

```lua
-- ==============================================================================
-- 范式：纯客户端空间吸附与网格对象池增量调度器 (GridSnapManager)
-- ==============================================================================

local GridSnapManager = Class(function(self, step)
    self.step = step or 1.0
    self.pool = {}        -- 闲置网格实体对象池
    self.active_grid = {} -- 当前激活的坐标键值对 key -> entity
end)

-- 1. 离散网格吸附计算
function GridSnapManager:SnapPosition(world_pt, offset)
    local ox = (offset and offset.x) or 0
    local oz = (offset and offset.z) or 0
    local sx = math.floor((world_pt.x - ox) / self.step + 0.5) * self.step + ox
    local sz = math.floor((world_pt.z - oz) / self.step + 0.5) * self.step + oz
    return Vector3(sx, 0, sz)
end

-- 2. 从对象池获取或创建临时提示点
function GridSnapManager:GetGridPoint(x, z)
    local key = string.format("%.2f_%.2f", x, z)
    if self.active_grid[key] then
        return self.active_grid[key]
    end

    local ent = table.remove(self.pool)
    if not ent or not ent:IsValid() then
        ent = CreateEntity()
        ent.entity:AddTransform()
        ent.entity:AddAnimState()
        ent.AnimState:SetBank("buildgridplacer")
        ent.AnimState:SetBuild("buildgridplacer")
        ent.AnimState:PlayAnimation("anim")
        ent:AddTag("FX")
        ent:AddTag("NOCLICK")
        ent.persists = false
    end

    ent.Transform:SetPosition(x, 0, z)
    ent:Show()
    self.active_grid[key] = ent
    return ent
end

-- 3. 增量清理离开范围的点，回收到对象池
function GridSnapManager:CullOutOfRange(center_pt, max_dist_sq)
    for key, ent in pairs(self.active_grid) do
        if ent:IsValid() then
            local pos = ent:GetPosition()
            if distsq(pos.x, pos.z, center_pt.x, center_pt.z) > max_dist_sq then
                ent:Hide()
                table.insert(self.pool, ent)
                self.active_grid[key] = nil
            end
        else
            self.active_grid[key] = nil
        end
    end
end

-- 4. 销毁全部网格点
function GridSnapManager:ClearAll()
    for _, ent in pairs(self.active_grid) do
        if ent:IsValid() then ent:Remove() end
    end
    self.active_grid = {}
    for _, ent in ipairs(self.pool) do
        if ent:IsValid() then ent:Remove() end
    end
    self.pool = {}
end
```

---

## 三、踩坑与生产避错指南

1. **`persists = false` 遗漏导致的存档膨胀**：
   - 任何客户端视觉定位点、几何网格实体，必须显式声明 `ent.persists = false`，否则一旦发生主机存档，客户端生成的辅助实体被错误序列化进世界文件，会导致读档时生成大量无逻辑僵尸实体。
2. **手柄 Controller 模式下的相对偏移补偿**：
   - 在键鼠下通过 `TheInput:GetWorldPosition()` 获取点，但在手柄下必须基于 `ThePlayer.entity:LocalToWorldSpace(offset, 0, 0)` 获取玩家朝向延伸点，否则吸附点会直接锁死在玩家脚底无法前推放置。

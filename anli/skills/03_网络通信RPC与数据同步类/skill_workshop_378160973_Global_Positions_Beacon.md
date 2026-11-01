# 饥荒一线工坊深度研读 Skill：伴生网络信标（Classified Entity）与跨视距同步架构

- **工坊 ID**：378160973 (`Global Positions`)
- **领域分类**：联机网络同步机制、Classified 伴生轻量实体设计、远距离跨视距雷达穿透、团队迷雾序列化互通
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

饥荒联机版的实体系统具有严格的**网络休眠与视距裁剪机制**：离开玩家视距范围的实体不会向客机同步坐标。若要制作诸如“全图指示器、队友雷达、跨屏求救标记、甚至载具追踪”，最佳解法就是模仿官方与 `Global Positions` 采用的 **伴生微型信标（Classified Proxy Entity）**。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：轻量伴生网络信标预制体定义 (scripts/prefabs/my_beacon_classified.lua)
-- ==============================================================================

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:Hide() -- 视觉隐藏，仅作网络数据桥梁

    inst:AddTag("CLASSIFIED")
    inst.entity:SetCanSleep(false) -- 核心：常驻全图不休眠

    -- 网络变量 (NetVars) 定义
    inst.host_guid = net_entity(inst.GUID, "host_entity")
    inst.beacon_type = net_string(inst.GUID, "beacon_type")
    inst.is_active = net_bool(inst.GUID, "is_active", "activedirty")

    inst.entity:SetPristine()

    -- 客户端逻辑
    if not TheWorld.ismastersim then
        inst:ListenForEvent("activedirty", function()
            -- 触发客机雷达/小地图注册
            if ThePlayer and ThePlayer.HUD and inst.is_active:value() then
                ThePlayer.HUD:PushEvent("register_custom_beacon", { beacon = inst })
            end
        end)
        return inst
    end

    inst.persists = false -- 不持久化到硬盘，由宿主动态派生
    return inst
end

return Prefab("my_beacon_classified", fn)


-- ==============================================================================
-- 范式 2：宿主实体服务端伴生与坐标同步组件 (scripts/components/network_beacon.lua)
-- ==============================================================================

local NetworkBeacon = Class(function(self, inst)
    self.inst = inst
    self.classified = nil

    if TheWorld.ismastersim then
        self.inst:DoTaskInTime(0, function() self:SpawnClassified() end)
    end
end)

function NetworkBeacon:SpawnClassified()
    if self.classified ~= nil then return end

    local c = SpawnPrefab("my_beacon_classified")
    c.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
    c.host_guid:set(self.inst)
    c.beacon_type:set(self.inst.prefab)
    c.is_active:set(true)

    -- 坐标跟随绑定
    self.inst:DoPeriodicTask(0.1, function()
        if self.inst:IsValid() and c:IsValid() then
            c.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
        end
    end)

    self.classified = c
end

function NetworkBeacon:OnRemoveFromEntity()
    if self.classified and self.classified:IsValid() then
        self.classified.is_active:set(false)
        self.classified:Remove()
        self.classified = nil
    end
end

return NetworkBeacon
```

---

## 三、避坑与生产安全准则

1. **`persists = false` 是信标必须铁律**：
   - 伴生微型信标一旦漏写 `persists = false`，服务器保存世界时会把成百上千个脱离宿主的僵尸信标写入世界文件，导致读档后坐标错乱甚至坏档！
2. **伴随跟随频度（Throttle）**：
   - 不必在 `OnUpdate` 每帧（1/60s）同步一次信标坐标，使用 `DoPeriodicTask(0.1)`（每秒 10 次）甚至 `0.2` 秒同步一次坐标，客户端自身的插值系统（Transform Smoothing）即可呈现极其丝滑的平移轨迹，带宽节省 85% 以上。

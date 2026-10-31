# 饥荒一线工坊深度研读 Skill：双向 RPC 空间容器寻物与色彩通道高亮管理器

- **工坊 ID**：2281925291 (`Finder Redux`)
- **领域分类**：双向 ModRPC 协议（`SendModRPCToServer` / `SendModRPCToClient`）、空间实体范围检索（`TheSim:FindEntities`）、实体渲染色彩栈管理（Push/Pop Colour）、UI 焦点驱动寻物
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发“寻物高亮、箱子整理、材料速查、空间范围透视”类 Mod 时：
1. **客户端焦点捕获**：在合成材料（`ingredientui`）或鼠标悬停物品时，通过 `SendModRPCToServer` 上报要寻找的物品名；
2. **服务端空间容器扫描**：服务端使用 `TheSim:FindEntities` 结合 `container:Has(item, 1)` 快速定位目标箱子，并通过客户端 RPC 逐次回传；
3. **色彩管理器栈式高亮**：客户端使用 `PushColour` 与 `PopColour` 对目标实体注入 `AnimState:SetAddColour`，确保色彩叠加与撤销时不破坏原生贴图。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：色彩高亮管理器 (scripts/colour_manager.lua)
-- ==============================================================================

local ColourManager = {}
ColourManager.__index = ColourManager

function ColourManager.New(default_colour)
    local self = setmetatable({}, ColourManager)
    self.colour = default_colour or {1, 1, 0, 1} -- 默认高亮黄色
    self.highlighted = {}
    return self
end

--- 压入高亮色彩
function ColourManager:PushColour(inst, id)
    if not inst or not inst:IsValid() or not inst.AnimState then return end
    
    if not self.highlighted[inst] then
        self.highlighted[inst] = {}
    end
    self.highlighted[inst][id] = true

    -- 叠加色彩通道
    local r, g, b, a = unpack(self.colour)
    inst.AnimState:SetAddColour(r, g, b, a)
end

--- 弹出并还原高亮色彩
function ColourManager:PopColour(inst, id)
    if not inst or not inst:IsValid() or not inst.AnimState then return end

    if self.highlighted[inst] then
        self.highlighted[inst][id] = nil
        if next(self.highlighted[inst]) == nil then
            self.highlighted[inst] = nil
            -- 清除色彩叠加
            inst.AnimState:SetAddColour(0, 0, 0, 0)
        end
    end
end

-- ==============================================================================
-- 范式 2：双向 RPC 寻物网络管道 (modmain.lua)
-- ==============================================================================

-- 1. 客户端接收服务端高亮实体并渲染
local CM = ColourManager.New({0, 1, 0, 1})
local CURRENT_HIGHLIGHTS = {}

AddClientModRPCHandler("ITEM_FINDER", "ON_FOUND", function(target_entity)
    if target_entity and target_entity:IsValid() then
        CM:PushColour(target_entity, "finder_focus")
        table.insert(CURRENT_HIGHLIGHTS, target_entity)
    elseif #CURRENT_HIGHLIGHTS > 0 then
        -- 传 nil 表示清空当前所有高亮
        for _, ent in ipairs(CURRENT_HIGHLIGHTS) do
            CM:PopColour(ent, "finder_focus")
        end
        CURRENT_HIGHLIGHTS = {}
    end
end)

-- 2. 服务端响应客户端的寻找请求
AddModRPCHandler("ITEM_FINDER", "SEARCH", function(player, item_prefab)
    if not player or not player:IsValid() then return end

    if item_prefab then
        local x, y, z = player.Transform:GetWorldPosition()
        local containers = GLOBAL.TheSim:FindEntities(x, y, z, 25, { "_container" }, { "INLIMBO", "NOCLICK" })
        for _, container in ipairs(containers) do
            if container.components.container and container.components.container:Has(item_prefab, 1) then
                SendModRPCToClient(GetClientModRPC("ITEM_FINDER", "ON_FOUND"), player, container)
            end
        end
    else
        -- 清除请求
        SendModRPCToClient(GetClientModRPC("ITEM_FINDER", "ON_FOUND"), player, nil)
    end
end)
```

---

## 三、避坑与生产安全准则

1. **`FindEntities` 的标签过滤性能（Tag Filtering）**：
   - 必须传入必备标签（如 `{"_container"}`）与排除标签（如 `{"INLIMBO", "NOCLICK"}`）。如果无条件扫描半径内的所有实体，当基地中散落大量杂物或地皮装饰时，每次悬停都会触发严重的掉帧。
2. **色彩重置的时机契合**：
   - 当玩家切换界面、关闭制造栏或移动角色时，必须向服务端发送清理指令（`SEARCH(nil)`）以撤销所有高亮，否则离开视距后回来的箱子可能会永久残留发光状态。

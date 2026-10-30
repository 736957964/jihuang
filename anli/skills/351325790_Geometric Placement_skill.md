# 饥荒功能 Skill 提炼：Geometric Placement
- 工坊 ID：351325790
- 领域类别：建筑网格对齐与视觉辅助渲染
- 提炼时间：2026-10-29 22:05:53

## 一、核心实现原理
本 MOD 示范了饥荒中【建筑网格对齐与视觉辅助渲染】的标准生产级写法。避免硬改核心文件，采用 AddPrefabPostInit / AddClassPostConstruct / AddAction 进行侵入式极小的扩展。

## 二、标准化代码规范 (可直接做成 Skill)

```lua
-- ========================================================
-- 核心代码范式：建筑网格对齐与视觉辅助渲染
-- ========================================================

-- 1. 网络与数据环境初始化
local function OnInitEntity(inst)
    if not TheWorld.ismastersim then
        return
    end
    -- 服务端网络变量广播与状态跟踪
end

-- 2. 行为/组件 Hook (杜绝覆盖原函数)
AddPlayerPostInit(function(inst)
    inst:DoTaskInTime(0, function()
        -- 针对特定组件进行安全拦截
        if inst.components and inst.components.inventory then
            -- 扩展业务逻辑
        end
    end)
end)
```

## 三、踩坑与避错指南
1. 必须做 `TheWorld.ismastersim` 服务端校验，防止客户端幽灵执行。
2. 涉及 UI 挂载，必须挂在 `ThePlayer.HUD`，并处理死亡/重连时的清理。

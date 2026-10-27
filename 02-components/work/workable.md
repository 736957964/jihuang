# Workable 可工作组件

> 源码: `scripts/components/workable.lua`

## 概述

Workable 组件赋予实体"可被采集/砍伐/挖掘/敲击"的能力。通过设置 `action` 和 `workleft`，定义工作类型和所需工作量。是 DST 中最常用的交互组件之一。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `action` | Action | `ACTIONS.CHOP` | 工作动作类型（CHOP/MINE/DIG/HAMMER 等） |
| `workleft` | number | `10` | 剩余工作量 |
| `maxwork` | number | `-1` | 最大工作量（-1=无限/无恢复） |
| `workable` | boolean | `true` | 是否可被工作 |
| `savestate` | boolean | `false` | 是否保存工作状态 |
| `onwork` | function | `nil` | 每次工作回调 `fn(inst, worker, workleft)` |
| `onfinish` | function | `nil` | 工作完成回调 `fn(inst, worker)` |
| `onloadfn` | function | `nil` | 加载后回调 |
| `tough` | boolean | `nil` | 是否需要坚韧工具 |
| `workmultiplierfn` | function | `nil` | 工作倍率函数 |
| `shouldrecoilfn` | function | `nil` | 弹反判定函数 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetWorkAction(act)` | — | 设置工作动作类型 |
| `GetWorkAction()` | Action | 获取工作动作 |
| `SetWorkLeft(work)` | — | 设置剩余工作量 |
| `GetWorkLeft()` | number | 获取剩余工作量 |
| `SetWorkable(able)` | — | 设置是否可工作 |
| `CanBeWorked()` | boolean | 是否可被工作 |
| `Destroy(destroyer)` | — | 强制销毁（完成所有剩余工作） |
| `WorkedBy(worker, workmult)` | — | 被工作（核心方法，减少 workleft） |
| `SetOnWork(fn)` | — | 设置每次工作回调 |
| `SetOnFinish(fn)` | — | 设置完成回调 |
| `SetOnLoadFn(fn)` | — | 设置加载回调 |
| `SetRequiresToughWork(tough)` | — | 设置需要坚韧工具 |
| `GetDebugString()` | string | 调试字符串 |
| `OnSave()` | table/nil | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |
| `OnRemoveFromEntity()` | — | 清理标签 |

## 事件

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `workfinished` | 工作完成 | `{worker}` |
| `workmultiplier` | 计算工作倍率 | `{workmultiplier, worker}` |

## 标签

修改 `action` 或 `workleft` 时自动管理：`{action.id}_workable` 标签（如 `CHOP_workable`）

## 使用示例

### 砍树

```lua
inst:AddComponent("workable")
inst.components.workable:SetWorkAction(ACTIONS.CHOP)
inst.components.workable:SetWorkLeft(TUNING.EVERGREEN_CHOPS_SMALL)
inst.components.workable:SetOnWork(function(inst, worker, workleft)
    -- 播放砍树特效
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
end)
inst.components.workable:SetOnFinish(function(inst, worker)
    -- 掉落木头
    inst.components.lootdropper:SpawnLootPrefab("log")
    inst:Remove()
end)
```

### 挖矿

```lua
inst:AddComponent("workable")
inst.components.workable:SetWorkAction(ACTIONS.MINE)
inst.components.workable:SetWorkLeft(6)
```

### 敲击

```lua
inst:AddComponent("workable")
inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
inst.components.workable:SetWorkLeft(3)
inst.components.workable:SetOnFinish(function(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end)
```

### 需要坚韧工具

```lua
inst.components.workable:SetRequiresToughWork(true)
-- 需要 worker 有 "toughworker" 标签或工具能 CanDoToughFight
```

### 动态工作倍率

```lua
inst.components.workable.workmultiplierfn = function(inst, worker)
    if worker and worker:HasTag("beaver") then
        return 3  -- 海狸3倍效率
    end
    return 1
end
```

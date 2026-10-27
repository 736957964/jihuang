# PlayerActionPicker 玩家动作选择组件

> 源码: `scripts/components/playeractionpicker.lua`

## 概述

PlayerActionPicker 根据当前场景（鼠标指向的实体、物品栏物品等）决定显示哪些可用动作。它是右键菜单的核心逻辑。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `isclientcontrollerattached` | boolean | `false` | 客户端控制器是否附加 |
| `ismastersim` | boolean | — | 是否为主机 |
| `sortactions` | table | — | 动作排序列表 |
| `rightclickoverride` | function/nil | `nil` | 右键覆盖回调 |
| `leftclickoverride` | function/nil | `nil` | 左键覆盖回调 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `GetLeftClickActions()` | table | 获取左键可用动作 |
| `GetRightClickActions()` | table | 获取右键可用动作 |
| `GetControllableActions()` | table | 获取可控动作列表 |
| `GetActionButton()` | table | 获取动作按钮信息 |
| `SetRightClickOverride(fn)` | — | 设置右键覆盖 |
| `SetLeftClickOverride(fn)` | — | 设置左键覆盖 |
| `DoGetMouseItemActions(item)` | table | 获取鼠标物品的动作 |
| `DoGetSceneActions()` | table | 获取场景动作 |
| `DoGetUseItemActions()` | table | 获取使用物品动作 |
| `DoGetPointSpecialActions()` | table | 获取点击特殊动作 |
| `DoGetEquippedItemActions()` | table | 获取装备物品动作 |
| `DoGetInventoryActions()` | table | 获取背包物品动作 |

## 使用示例

### 右键覆盖

```lua
-- 一般不需要直接操作此组件
-- 通过 ACTIONS 和 COMPONENT_ACTIONS 注册新动作即可
```

### 添加自定义动作（通过 COMPONENT_ACTIONS）

```lua
-- 在 modmain.lua 中注册新动作
AddComponentAction("SCENE", "mycomponent", function(inst, doer, actions, right)
    if right then
        table.insert(actions, ACTIONS.MY_ACTION)
    end
end)
```

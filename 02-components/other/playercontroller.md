# PlayerController 玩家控制组件

> 源码: `scripts/components/playercontroller.lua`

## 概述

PlayerController 是玩家输入与游戏逻辑之间的桥梁，处理键盘/鼠标输入，转换为游戏动作。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `isclientcontrollerattached` | boolean | `false` | 客户端控制器是否附加 |
| `ismastersim` | boolean | — | 是否为主机 |
| `directwalking` | boolean | `false` | 是否直接行走（WASD） |
| `enabled` | boolean | `true` | 控制器是否启用 |
| `mapcontrols` | table | `{}` | 地图操作映射表 |
| `remote_vector` | table | `{0,0}` | 远程移动向量 |
| `predicted_remote_actions` | table | — | 预测的远程动作 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `Enable(enable)` | — | 启用/禁用控制器 |
| `IsEnabled()` | boolean | 是否已启用 |
| `SetMapControls(map)` | — | 设置地图操作映射 |
| `GetBuildBtnText()` | string | 获取建造按钮文本 |
| `OnControl(control, down)` | — | 控制输入处理 |
| `GetActionButtonState()` | table | 获取动作按钮状态 |

## 使用示例

### 禁用玩家控制

```lua
-- 过场动画中禁用控制
local player = ThePlayer
player.components.playercontroller:Enable(false)
-- ... 播放动画 ...
player.components.playercontroller:Enable(true)
```

### 自定义控制映射

```lua
-- 一般不需要直接操作此组件
-- 通过修改 CONTROL 表来添加自定义按键
```

### 冻结状态

```lua
-- 使玩家无法移动和操作
local function FreezePlayer(player)
    player.components.playercontroller:Enable(false)
    player.components.locomotor:Stop()
end
```

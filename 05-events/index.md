# 事件/监听系统 (Events)

> 事件系统是 DST 中实体间通信的核心机制。通过 `inst:ListenForEvent` 注册监听，`inst:PushEvent` 触发事件。

## 概述

DST 事件系统基于观察者模式：
- **PushEvent** — 触发事件，通知所有监听者
- **ListenForEvent** — 注册事件监听
- **RemoveEventCallback** — 移除事件监听

## API

```lua
-- 注册事件监听
inst:ListenForEvent("eventname", function(inst, data) ... end)

-- 注册事件监听（监听其他实体）
inst:ListenForEvent("eventname", function(inst, data) ... end, other_entity)

-- 触发事件
inst:PushEvent("eventname", { key = value })

-- 移除事件监听
inst:RemoveEventCallback("eventname", fn)
inst:RemoveEventCallback("eventname", fn, other_entity)

-- 触发立即事件（同帧处理）
inst:PushEventImmediate("eventname", data)
```

---

## 一、实体事件

### 生命/死亡

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `healthdelta` | 生命值变化 | `{oldpercent, newpercent, overtime, cause, afflicter}` |
| `death` | 死亡 | `{cause, afflicter}` |
| `respawnfromghost` | 从鬼魂复活 | `{source, useresurrect}` |
| `killed` | 击杀其他实体 | `{victim, attacker}` |
| `minhealth` | 到达最低生命值 | — |

### 受击/攻击

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `attacked` | 被攻击 | `{attacker, damage, damageresolved, original_damage, weapon, stimuli, spdamage, redirected, noimpactsound}` |
| `blocked` | 攻击被格挡 | `{attacker, damage, spdamage, original_damage}` |
| `onhitother` | 命中其他实体 | `{target, damage, damageresolved, stimuli, spdamage, weapon, redirected}` |
| `onattackother` | 攻击其他实体 | `{target, weapon, projectile, stimuli}` |
| `doattack` | 请求执行攻击 | `{target}` |
| `onmissother` | 未命中 | `{target, weapon}` |
| `onareaattackother` | AOE命中 | `{target, weapon, stimuli}` |
| `recoil_off` | 弹反卸力 | `{target}` |

### 战斗

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `newcombattarget` | 获取新战斗目标 | `{target, oldtarget}` |
| `droppedtarget` | 丢弃目标 | `{target}` |
| `losttarget` | 目标丢失 | — |
| `giveuptarget` | 放弃战斗 | `{target}` |
| `weapontooweak` | 武器太弱 | — |

## 二、世界事件

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `cycleschanged` | 天数变化 | — |
| `seasontick` | 季节变化 | `{season, progress}` |
| `ms_newseason` | 新季节开始 | `{season}` |
| `ms_seasonclock` | 季节时钟 | `{data}` |
| `ms_weathertick` | 天气变化 | — |
| `ms_setseasonlength` | 设置季节长度 | `{season, length}` |
| `weathertick` | 天气更新 | — |
| `rainstart` | 开始下雨 | — |
| `rainstop` | 停止下雨 | — |

## 三、物品事件

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `equip` | 装备物品 | `{eslot, item}` |
| `unequip` | 卸下装备 | `{eslot, item}` |
| `onpickup` | 拾取物品 | `{item}` |
| `itemget` | 物品进入容器 | `{item, slot}` |
| `itemlose` | 物品离开容器 | `{item, slot}` |
| `percentusedchange` | 耐久度变化 | `{percent}` |
| `armorbroke` | 防具破碎 | `{armor}` |
| `armordamaged` | 防具受损 | `damage_amount` |
| `weapononattack` | 武器攻击 | `{attacker, target}` |
| `enterlimbo` | 进入limbo | — |
| `exitlimbo` | 离开limbo | — |
| `onremove` | 实体移除 | — |
| `player_despawn` | 玩家消失 | — |

## 四、玩家事件

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `playeractivated` | 玩家激活 | `{player}` |
| `ms_playerjoined` | 玩家加入 | `{player}` |
| `ms_playerleft` | 玩家离开 | `{player}` |
| `setowner` | 设置所有者 | `{userid}` |
| `playeractivated` | 玩家激活 | — |
| `playerdeactivated` | 玩家停用 | — |
| `playerghostified` | 变成鬼魂 | — |
| `respawnfromghost` | 复活 | `{source, useresurrect}` |
| `sanitydelta` | 理智变化 | `{oldpercent, newpercent, overtime, sanitymode}` |
| `hungerdelta` | 饥饿变化 | `{oldpercent, newpercent, overtime, delta}` |
| `gosane` | 恢复理智 | — |
| `goinsane` | 陷入疯狂 | — |
| `goenlightened` | 陷入启蒙 | — |
| `sanitymodechanged` | 理智模式切换 | `{mode}` |
| `startstarving` | 开始饥饿 | — |
| `stopstarving` | 停止饥饿 | — |

## 五、状态机事件

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `enter_state` | 进入状态 | `{statename}` |
| `exit_state` | 退出状态 | — |

## 六、自定义事件指南

### 定义与触发

```lua
-- 在 modmain.lua 中自定义事件
-- 事件名就是一个字符串，不需要预定义

-- 触发自定义事件
inst:PushEvent("my_custom_event", { value = 42 })
```

### 监听自定义事件

```lua
-- 监听自己的事件
inst:ListenForEvent("my_custom_event", function(inst, data)
    print("Custom event fired with value:", data.value)
end)

-- 监听其他实体的事件
local function OnOtherEntityEvent(inst, data)
    -- inst 是监听者，不是触发者
end
inst:ListenForEvent("other_entity_event", OnOtherEntityEvent, other_entity)
```

### 清理事件监听

```lua
-- 保存函数引用
local my_listener = function(inst, data)
    -- ...
end
inst:ListenForEvent("my_event", my_listener)

-- 移除时使用同一引用
inst:RemoveEventCallback("my_event", my_listener)
```

### 常见模式

```lua
-- 1. 组件内部监听
function MyComponent:OnAddComponent()
    self.inst:ListenForEvent("healthdelta", self._onHealthDelta, self.inst)
end

function MyComponent:OnRemoveFromEntity()
    self.inst:RemoveEventCallback("healthdelta", self._onHealthDelta, self.inst)
end

-- 2. 使用 PrefabPostInit 添加监听
AddPrefabPostInit("spear", function(inst)
    inst:ListenForEvent("weapononattack", function(inst, data)
        -- 长矛攻击时触发
    end)
end)

-- 3. 事件传播链
inst:ListenForEvent("death", function(inst)
    inst:PushEvent("my_entity_died", { entity = inst })
end)
```

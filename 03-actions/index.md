# 03 - 动作系统（Actions）

> **源码位置**: `scripts/actions.lua` + `scripts/componentactions.lua`

动作系统是 DST 中所有玩家交互行为的核心机制。每个 `Action` 实例代表一种可执行的操作（如攻击、拾取、建造、烹饪等），`COMPONENT_ACTIONS` 表则将实体的组件与可用的动作关联起来。

---

## 目录

- [Action 类定义](#1-action-类定义)
- [所有 ACTIONS 列表](/03-actions/detail/action-list)
- ACTIONS.fn 详解（待补充）
- COMPONENT_ACTIONS 详解（待补充）
- Mod 自定义动作指南（待补充）

---

## 1. Action 类定义

### 1.1 构造函数

```lua
Action = Class(function(self, data, instant, rmb, distance, ghost_valid, ghost_exclusive, canforce, rangecheckfn)
```

**推荐用法**：传入一个 table：

```lua
ACTIONS.MY_ACTION = Action({
    priority = 1,          -- 优先级
    distance = 3,          -- 执行距离
    rmb = true,            -- 右键专属
    mount_valid = true,    -- 骑乘时可用
    instant = false,       -- 是否即时动作
    ghost_valid = false,   -- 幽灵状态可用
    -- ...更多参数
})
```

### 1.2 完整属性表

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `priority` | `number` | `0` | 动作优先级。值越大越优先。`HIGH_ACTION_PRIORITY = 10` |
| `fn` | `function` | `return false` | 动作执行函数，服务端运行。返回 `true`=成功, `false`/`"reason"`=失败 |
| `strfn` | `function`\|`nil` | `nil` | 动作字符串修饰函数，返回 `"HEAVY"`、`"CLOSE"` 等，影响按钮文字 |
| `stroverridefn` | `function`\|`nil` | `nil` | 完全覆盖动作显示字符串 |
| `instant` | `boolean` | `false` | 是否即时执行（不需要走到目标） |
| `rmb` | `boolean`\|`nil` | `nil` | `nil`=左右键均可, `true`=仅右键, `false`=仅左键 |
| `distance` | `number`\|`nil` | `nil` | 执行动作所需距离 |
| `mindistance` | `number`\|`nil` | `nil` | 最小距离限制 |
| `arrivedist` | `number`\|`nil` | `nil` | 到达判定距离 |
| `ghost_exclusive` | `boolean` | `false` | 是否仅幽灵可用 |
| `ghost_valid` | `boolean` | `false` | 幽灵状态下是否可用 |
| `mount_valid` | `boolean` | `false` | 骑乘状态下是否可用 |
| `encumbered_valid` | `boolean` | `false` | 负重搬运时是否可用 |
| `floating_valid` | `boolean` | `false` | 漂浮时是否可用 |
| `paused_valid` | `boolean` | `false` | 游戏暂停时是否可用 |
| `canforce` | `boolean`\|`nil` | `nil` | 是否可强制触发（如 Ctrl+点击） |
| `rangecheckfn` | `function`\|`nil` | `nil` | 自定义距离检查函数（`canforce` 非 nil 时启用） |
| `silent_fail` | `boolean`\|`nil` | `nil` | 失败时静默不提示 |
| `silent_generic_fail` | `boolean`\|`nil` | `nil` | 通用失败静默 |
| `customarrivecheck` | `function`\|`nil` | `nil` | 自定义到达检查，返回 `true` 表示已到达 |
| `is_relative_to_platform` | `boolean`\|`nil` | `nil` | 距离计算是否相对于平台（船） |
| `disable_platform_hopping` | `boolean`\|`nil` | `nil` | 禁止跨平台跳转 |
| `skip_locomotor_facing` | `boolean`\|`nil` | `nil` | 跳过朝向调整 |
| `do_not_locomote` | `boolean`\|`nil` | `nil` | 禁止移动（原地执行） |
| `extra_arrive_dist` | `function`\|`nil` | `nil` | 额外到达距离计算函数 |
| `tile_placer` | `string`\|`nil` | `nil` | 地块放置器类型（如 `"gridplacer"`） |
| `show_tile_placer_fn` | `function`\|`nil` | `nil` | 控制地块放置器显示 |
| `theme_music` | `string`\|`nil` | `nil` | 关联主题音乐（如 `"farming"`） |
| `theme_music_fn` | `function`\|`nil` | `nil` | 客户端动态主题音乐函数 |
| `pre_action_cb` | `function`\|`nil` | `nil` | 执行前回调（客户端+服务端均运行） |
| `invalid_hold_action` | `boolean`\|`nil` | `nil` | 标记为无效的"按住"动作 |
| `actionmeter` | `boolean`\|`nil` | `nil` | 是否显示动作进度条 |
| `show_primary_input_left` | `boolean`\|`nil` | `nil` | 显示左键输入提示 |
| `show_secondary_input_right` | `boolean`\|`nil` | `nil` | 显示右键输入提示 |
| `map_action` | `boolean`\|`nil` | `nil` | 可在地图上执行 |
| `closes_map` | `boolean`\|`nil` | `nil` | 执行后关闭地图 |
| `map_only` | `boolean`\|`nil` | `nil` | 仅地图上可用 |
| `map_works_on_unexplored` | `boolean`\|`nil` | `nil` | 对未探索区域生效 |
| `map_works_on_impassable` | `boolean`\|`nil` | `nil` | 对不可通行地块生效 |
| `mod_name` | `string`\|`nil` | `nil` | 所属 Mod 名称（Mod 动作自动设置） |

### 1.3 运行时属性

| 属性名 | 类型 | 说明 |
|--------|------|------|
| `str` | `string` | 从 `STRINGS.ACTIONS[id]` 获取的显示名 |
| `id` | `string` | Action 的 key（如 `"CHOP"`、`"ATTACK"`） |
| `code` | `number` | Action 数字编码（按定义顺序递增） |

---

## 2. 优先级体系

```
HIGH_ACTION_PRIORITY (10)   - 最高优先级（如 BLINK, CASTAOE, TOSS_MAP）
  ...
6-9                          - 高优先级动作（如 OCEAN_FISHING_CATCH=6）
5                            - 中高优先级
4                            - 普通优先级（如 ABANDON_SHIP=4）
3                            - 较高优先级（如 PICKUP=1, CHECKTRAP=2, NET=3）
2                            - 标准优先级（如 ATTACK=2, ACTIVATE=2, TURNON=2）
1                            - 基础优先级（如 COOK=1, FEED=1, MURDER=1）
0                            - 默认优先级（大多数动作）
-1                           - 低优先级（如 DROP=-1, RUMMAGE=-1）
-2                           - 更低优先级
-3                           - 很低优先级（如 LOOKAT=-3）
-4                           - 最低优先级（如 WALKTO=-4, LIGHT=-4）
```

**关键原则**：HIGH_ACTION_PRIORITY 用于"如果可用就一定优先"的动作，且假设没有两个此类动作会同时可用。

---

## 3. 辅助函数

### 3.1 `MakeRangeCheckFn(range)`

创建距离检查闭包。返回一个函数 `(doer, target) => boolean`，检查执行者与目标是否在指定范围内。

```lua
local function MakeRangeCheckFn(range)
    return function(doer, target)
        if target then
            return doer:IsNear(target, range)
        end
    end
end
```

### 3.2 `DefaultRangeCheck`

基于 `MakeRangeCheckFn(4)` 的默认距离检查（4 单位半径）。

### 3.3 `PickRangeCheck(doer, target)`

PICK 动作专用距离检查。对带有 `jostlepick`/`jostlerummage`/`jostlesearch` 标签的目标会加上武器攻击范围。

### 3.4 `ExtraPickRange(doer, dest, bufferedaction)`

PICK 动作的额外距离加成。水面目标 +0.75。

### 3.5 `ExtraPickupRange(doer, dest)`

PICKUP 动作的额外距离加成。水面目标 +0.75。

### 3.6 `ExtraDropDist(doer, dest, bufferedaction)`

DROP 动作的额外距离。水面 +1.75；物品与玩家物理碰撞时 +物品物理半径+0.5。

### 3.7 `ExtraDeployDist(doer, dest, bufferedaction)`

DEPLOY 动作的额外距离。投射物 +8-DEPLOY.distance；水陆交界 +1。

### 3.8 `ExtraHealRange(doer, dest, bufferedaction)`

HEAL 动作额外距离。修正物理半径与实际碰撞半径的差异。

### 3.9 `CheckFishingOceanRange(doer, dest)` / `CheckRowRange(doer, dest)` / `CheckOceanFishingCastRange(doer, dest)` / `CheckIsOnPlatform(doer, dest)` / `CheckTileWithinRange(doer, dest)` / `ArriveAnywhere()`

各动作专用的自定义到达检查函数。

---

## 4. COMPONENT_ACTIONS 结构

`COMPONENT_ACTIONS` 表定义实体组件与可用动作的映射关系，分为 5 大类：

| 分类 | 说明 | 触发时机 |
|------|------|----------|
| `SCENE` | 场景交互动作 | 鼠标悬停在场景中的实体上时 |
| `INVENTORY` | 背包物品动作 | 鼠标悬停在背包/容器中的物品上时 |
| `USEITEM` | 使用物品动作 | 选中手持物品后点击目标时 |
| `POINT` | 指向点动作 | 选中手持物品后点击空白地面/水面时 |
| `EQUIPPED` | 装备物动作 | 物品装备在角色身上时可用 |

### 4.1 SCENE 分类（场景中的实体）

> 参数: `(inst, doer, actions, right)`

场景中的实体通过其注册的组件自动获得对应的动作选项。例如：
- `activatable` 组件 → `ACTIONS.ACTIVATE` 动作
- `burnable` 组件 → `ACTIONS.SMOTHER`（冒烟时）/ `ACTIONS.STOKEFIRE`（右键）
- `book` 组件 → `ACTIONS.READ`
- `workable` 组件 → 根据 work action 显示 CHOP/MINE/HAMMER 等

完整映射见 COMPONENT_ACTIONS 详解（待补充）。

### 4.2 INVENTORY 分类（背包中的物品）

> 参数: `(inst, doer, actions, right, target)`

背包中的物品根据其组件获得右键/左键动作：
- `equippable` 组件 → `ACTIONS.EQUIP`
- `edible` 组件 → `ACTIONS.EAT`
- `deployable` 组件 → `ACTIONS.DEPLOY`
- `fuel` 组件 → `ACTIONS.ADDFUEL`
- 等等...

### 4.3 USEITEM 分类（手持物品对目标使用）

> 参数: `(inst, doer, target, actions, right)`

手持物品对场景中的目标使用时触发：
- `healer` 组件 → `ACTIONS.HEAL`（对可治疗目标）
- `fertilizer` 组件 → `ACTIONS.FERTILIZE`（对可施肥目标）
- `fishingrod` 组件 → `ACTIONS.FISH`（对池塘）
- 等等...

### 4.4 POINT 分类（指向地面/水面点）

> 参数: `(inst, doer, pos, actions, right)`

手持物品指向地面或水面时触发：
- `deployable` 组件 → `ACTIONS.DEPLOY`（可放置物品）
- `caster` 组件 → `ACTIONS.CASTAOE`（AOE 施法）
- `blinkstaff` 组件 → `ACTIONS.BLINK`（闪现法杖）
- 等等...

### 4.5 EQUIPPED 分类（装备中的物品）

> 参数: `(inst, doer, target, actions, right)`

物品装备在身上时可用的动作：
- `weapon` 组件 → `ACTIONS.ATTACK`
- `tool` 组件 → 根据工具类型显示 CHOP/MINE/DIG 等
- `fishingrod` 组件 → `ACTIONS.FISH_OCEAN`
- 等等...

---

## 5. 动作执行流程

```
1. 玩家输入（鼠标点击/按键）
   ↓
2. 客户端收集可用动作（COMPONENT_ACTIONS）
   ↓
3. 按 priority 排序，选择最高优先级的动作
   ↓
4. 设置 CLIENT_REQUESTED_ACTION
   ↓
5. 执行者移动到目标位置（除非 instant/do_not_locomote）
   ↓
6. 调用 act.fn(act) 执行动作逻辑（服务端）
   ↓
7. 返回 true（成功）或 false/"reason"（失败）
```

### act 对象属性

在 `fn(act)` 中可以访问：

| 属性 | 说明 |
|------|------|
| `act.doer` | 执行者（玩家/生物） |
| `act.target` | 目标实体 |
| `act.invobject` | 使用的物品（从背包） |
| `act.pos` | 目标位置（POINT 动作） |
| `act.recipe` | 建造配方（BUILD 动作） |
| `act.rotation` | 建造旋转角度 |
| `act.skin` | 建造皮肤 |

---

## 6. Mod 开发相关

### 6.1 添加自定义动作

```lua
-- 在 modmain.lua 中
local MY_ACTION = AddAction("MY_ACTION", "我的动作", function(act)
    -- 动作执行逻辑
    if act.target then
        act.target:DoSomething()
        return true
    end
    return false
end)
```

### 6.2 添加组件动作映射

```lua
AddComponentAction("USEITEM", "mycomponent", function(inst, doer, target, actions, right)
    if target:HasTag("valid_target") then
        table.insert(actions, GLOBAL.ACTIONS.MY_ACTION)
    end
end)
```

详细指南见 Mod 自定义动作指南（待补充）。

---

## 7. 关键全局变量

| 变量 | 说明 |
|------|------|
| `ACTIONS` | 所有动作的全局表 |
| `ACTIONS_BY_ACTION_CODE` | 按数字编码索引的动作表 |
| `CLIENT_REQUESTED_ACTION` | 客户端当前请求的动作 |
| `ACTIONS_MAP_REMAP` | 地图动作映射表 |
| `ACTION_IDS` | 动作 ID 列表（按定义顺序） |

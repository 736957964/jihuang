# 19-fx — 特效系统 (FX System)

> 源码: `scripts/fx.lua` (120KB, 432+ 特效定义)
> fx.lua 定义了 DST 中所有视觉特效（FX），通过 `SpawnPrefab("fx_name")` 生成。特效是临时的视觉元素，播放完动画后自动消失。

---

## 1. 特效系统概述

### 1.1 特效数据结构

每个特效定义包含以下字段：

| 字段 | 类型 | 说明 |
|------|------|------|
| `name` | string | 特效名称（用于 SpawnPrefab） |
| `bank` | string | 动画 Bank 文件名 |
| `build` | string | 动画 Build 文件名 |
| `anim` | string | 播放的动画名 |
| `sound` | string | 播放的音效 |
| `sound2` | string | 第二个音效 |
| `sounddelay2` | number | 第二个音效延迟（帧数） |
| `tint` | Vector3 | 颜色着色 (RGB 0~1) |
| `tintalpha` | number | 着色透明度 |
| `fn` | function | 初始化函数（设置 offset/层级等） |
| `autorotate` | boolean | 是否自动旋转面向相机 |
| `nameoverride` | string | 覆盖显示名称 |
| `description` | function | 描述函数（检查时显示） |

### 1.2 生成特效

```lua
-- 基本用法：在指定位置生成特效
local fx = SpawnPrefab("splash")  -- 生成水花特效

-- 在实体位置生成
local fx = SpawnPrefab("die_fx")
fx.Transform:SetPosition(inst.Transform:GetWorldPosition())

-- 跟随实体
local fx = SpawnPrefab("sanity_raise")
fx.entity:SetParent(inst.entity)
fx.Transform:SetPosition(0, 0, 0)  -- 相对于父实体的偏移
```

### 1.3 特效生命周期

特效 prefab 在播放完动画后自动调用 `Remove()`，通常不需要手动管理。也可以：

```lua
fx:Remove()  -- 手动移除
fx:ListenForEvent("animover", function() fx:Remove() end)  -- 动画结束后移除
```

---

## 2. 特效分类目录

### 2.1 基础通用特效

| 名称 | 说明 | 用途 |
|------|------|------|
| `die_fx` | 死亡烟雾 | 实体死亡/消失 |
| `small_puff` | 小烟雾 | 通用小型效果 |
| `sand_puff` | 沙尘烟雾 | 沙漠环境 |
| `sand_puff_large_front` | 大沙尘（前层） | 沙漠大型效果 |
| `sand_puff_large_back` | 大沙尘（后层） | 沙漠大型效果 |
| `dirt_puff` | 泥土烟雾 | 挖掘/种植 |
| `charlie_snap` | 查理攻击 | 黑暗伤害 |
| `charlie_snap_solid` | 查理攻击（实心） | 黑暗伤害 |
| `shadow_puff` | 暗影烟雾 | 暗影相关 |
| `shadow_puff_solid` | 暗影烟雾（实心） | 暗影相关 |
| `shadow_puff_solid_large` | 大暗影烟雾 | 暗影大型效果 |
| `shadow_puff_large_front` | 大暗影（前层） | 暗影大型效果 |
| `shadow_puff_large_back` | 大暗影（后层） | 暗影大型效果 |
| `maxwell_smoke` | 麦斯威尔烟雾 | 暗影魔法 |

### 2.2 挖掘/采集特效

| 名称 | 说明 | 用途 |
|------|------|------|
| `shovel_dirt` | 铲子挖土 | 挖掘 |
| `mining_fx` | 采矿特效 | 矿脉 |
| `mining_ice_fx` | 采冰特效 | 冰块/冰矿 |

### 2.3 砍树/落叶特效

| 名称 | 说明 |
|------|------|
| `pine_needles` | 松针飘落 |
| `pine_needles_chop` | 砍树松针 |
| `green_leaves_chop` | 砍树绿叶 |
| `red_leaves_chop` | 砍树红叶 |
| `orange_leaves_chop` | 砍树橙叶 |
| `yellow_leaves_chop` | 砍树黄叶 |
| `purple_leaves_chop` | 砍树紫叶 |
| `green_leaves` | 绿叶飘落 |
| `red_leaves` | 红叶飘落 |
| `orange_leaves` | 橙叶飘落 |
| `yellow_leaves` | 黄叶飘落 |
| `purple_leaves` | 紫叶飘落 |
| `sugarwood_leaf_fx` | 糖木叶飘落 |
| `sugarwood_leaf_fx_chop` | 砍糖木 |
| `sugarwood_leaf_withered_fx` | 枯萎糖木叶 |
| `sugarwood_leaf_withered_fx_chop` | 砍枯萎糖木 |
| `tree_petal_fx_chop` | 花瓣树砍伐 |

### 2.4 水面/液体特效

| 名称 | 说明 | 用途 |
|------|------|------|
| `splash` | 水花 | 通用落水 |
| `hot_splash` | 热水花 | 热物落水 |
| `ink_splash` | 墨水水花 | 墨鱼相关 |
| `bile_splash` | 胆汁水花 | 变异知更鸟 |
| `frogsplash` | 青蛙水花 | 青蛙落水 |
| `waterballoon_splash` | 水球水花 | 水球 |
| `splash_ocean` | 旧版海洋水花 | 旧海洋 |
| `spat_splat_fx` | 唾液飞溅 | 口水 |
| `spat_splash_fx_full` | 唾液水花（大） | 口水落水 |
| `spat_splash_fx_med` | 唾液水花（中） | 口水落水 |
| `spat_splash_fx_low` | 唾液水花（小） | 口水落水 |
| `spat_splash_fx_melted` | 唾液水花（融化） | 口水融化 |
| `icing_splat_fx` | 糖霜飞溅 | 糖霜 |
| `icing_splash_fx_full` | 糖霜水花（大） | 糖霜落水 |
| `icing_splash_fx_med` | 糖霜水花（中） | 糖霜落水 |
| `icing_splash_fx_low` | 糖霜水花（小） | 糖霜落水 |
| `icing_splash_fx_melted` | 糖霜水花（融化） | 糖霜融化 |

### 2.5 理智特效

| 名称 | 说明 |
|------|------|
| `sanity_raise` | 理智上升 |
| `sanity_lower` | 理智下降 |

### 2.6 温度特效

| 名称 | 说明 |
|------|------|
| `dr_warm_loop_1` | 升温循环 1 |
| `dr_warm_loop_2` | 升温循环 2 |
| `dr_warmer_loop` | 较热循环 |
| `dr_hot_loop` | 过热循环 |

### 2.7 生成/传送特效

| 名称 | 说明 |
|------|------|
| `spawn_fx_tiny` | 极小型生成 |
| `spawn_fx_small` | 小型生成 |
| `spawn_fx_medium` | 中型生成 |
| `spawn_fx_large` | 大型生成 |
| `slurper_respawn` | 吸食兽重生 |
| `chester_transform_fx` | 切斯特变形 |
| `statue_transition` | 雕像转换（噩梦） |
| `statue_transition_2` | 雕像转换（普通） |
| `pandorachest_reset` | 潘多拉宝箱重置 |

### 2.8 表情/情感特效

| 名称 | 说明 |
|------|------|
| `emote_fx` | 表情气泡 |
| `tears` | 眼泪 |
| `balloon_pop_body` | 气球爆炸（身体） |
| `balloon_pop_head` | 气球爆炸（头部） |

### 2.9 洞穴/暗影特效

| 名称 | 说明 |
|------|------|
| `cavehole_flick_warn` | 洞穴裂缝预警 |
| `cavehole_flick` | 洞穴裂缝闪烁 |
| `lightning_rod_fx` | 避雷针特效 |
| `mole_move_fx` | 鼹鼠移动 |

### 2.10 特殊功能函数

| 函数 | 说明 |
|------|------|
| `FinalOffset1(inst)` | 设置 FinalOffset = 1（渲染在最前层） |
| `FinalOffset2(inst)` | 设置 FinalOffset = 2 |
| `FinalOffset3(inst)` | 设置 FinalOffset = 3 |
| `FinalOffsetNegative1(inst)` | 设置 FinalOffset = -1（渲染在后层） |
| `FinalOffsetNegative2(inst)` | 设置 FinalOffset = -2 |
| `UsePointFiltering(inst)` | 启用点过滤（像素风格） |
| `GroundOrientation(inst)` | 地面朝向 + 背景层 |
| `Bloom(inst)` | 泛光效果 |
| `Wx78ShieldFn(inst)` | WX-78 护盾特效 |
| `Wx78ShieldBreakFn(inst)` | WX-78 护盾破碎特效 |

---

## 3. 常用代码模式

### 3.1 在实体位置生成特效

```lua
local fx = SpawnPrefab("die_fx")
fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
```

### 3.2 跟随实体（作为子对象）

```lua
local fx = SpawnPrefab("sanity_raise")
fx.entity:SetParent(inst.entity)
fx.Transform:SetPosition(0, 1, 0)  -- 头上方
```

### 3.3 在指定坐标生成

```lua
local fx = SpawnPrefab("small_puff")
fx.Transform:SetPosition(x, y, z)
```

### 3.4 生成带音效的特效

```lua
-- 特效自带音效时会自动播放
local fx = SpawnPrefab("splash")
fx.Transform:SetPosition(x, y, z)
-- sound = "turnoftides/common/together/water/splash/bird" 会自动播放
```

### 3.5 着色特效

```lua
-- 在 fx 定义中使用 tint 字段
-- 运行时也可以设置
fx.AnimState:SetMultColour(r, g, b, a)
fx.AnimState:SetAddColour(r, g, b, a)
```

---

## 4. Mod 开发参考

### 4.1 注册自定义特效

```lua
-- 在 modmain.lua 中
local function MyCustomFxFn(inst)
    inst.AnimState:SetFinalOffset(1)
end

local function MakeMyCustomFx(name, bank, build, anim)
    local assets = {
        Asset("ANIM", "anim/"..bank..".zip"),
    }

    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation(anim)

        -- 跟随实体时的处理
        inst:AddTag("FX")

        if not TheNet:IsDedicated() then
            -- 客户端特效
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        -- 动画结束后自动移除
        inst:ListenForEvent("animover", inst.Remove)

        return inst
    end

    return Prefab(name, fn, assets)
end

return MakeMyCustomFx("my_custom_fx", "my_bank", "my_build", "anim_name")
```

### 4.2 使用已有特效

```lua
-- 在你的 component 或 prefab 中
inst:DoTaskInTime(1.0, function()
    local fx = SpawnPrefab("spawn_fx_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
end)
```

---

## 5. 完整特效列表索引

由于 fx.lua 包含 432+ 个特效定义，这里列出查找规则：
- 所有特效都在 `local fx = { ... }` 表中
- 每个特效的 `name` 字段即是 SpawnPrefab 的参数
- 包含的字段：`name`, `bank`, `build`, `anim`, 可选 `sound`, `tint`, `fn` 等

如需查找具体特效，在 `scripts/fx.lua` 中搜索 `name = "特效名"` 即可找到定义。

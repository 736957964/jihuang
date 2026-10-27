# 06-stategraphs — 常用状态机 (SG) 详细参考

> 源码: `scripts/stategraphs/` (261 个 SG 文件)
> 每个生物/实体都有自己的 StateGraph，定义其动画状态、事件处理和状态转换逻辑。

---

## 1. 通用状态 (commonstates.lua)

`commonstates.lua` 定义了几乎所有 SG 共享的基础状态。

### 1.1 基础状态列表

| 状态名 | 说明 | 标签 |
|--------|------|------|
| `idle` | 待机 | `"idle"`, `"canrotate"` |
| `walk` | 走路 | `"moving"`, `"walking"`, `"canrotate"` |
| `run` | 跑步 | `"moving"`, `"running"`, `"canrotate"` |
| `hit` | 被击中 | `"busy"` |
| `death` | 死亡 | `"busy"`, `"dead"` |
| `eat` | 吃东西 | `"busy"` |
| `sleep` | 睡眠 | `"sleeping"`, `"busy"` |
| `wakeup` | 醒来 | `"busy"` |
| `dance` | 跳舞 | `"dancing"` |
| `freeze` | 冻结 | `"frozen"`, `"busy"` |
| `electrocute` | 触电 | `"busy"` |
| `jump` | 跳跃 | `"jumping"` |
| `fall` | 掉落 | `"falling"` |
| `knockback` | 击退 | `"busy"` |
| `teleport` | 传送 | `"busy"` |
| `hide` | 隐藏 | `"hiding"` |

### 1.2 常用状态标签

| 标签 | 含义 |
|------|------|
| `"idle"` | 待机中，可接受新动作 |
| `"busy"` | 忙碌中，不接受新动作 |
| `"moving"` | 正在移动 |
| `"canrotate"` | 可以旋转朝向 |
| `"nopredict"` | 不进行动作预测 |
| `"attack"` | 攻击动作 |
| `"jumping"` | 跳跃中 |
| `"frozen"` | 被冻结 |
| `"sleeping"` | 睡眠中 |
| `"dead"` | 已死亡 |
| `"nointerrupt"` | 不可打断 |

### 1.3 事件处理器

通用状态响应的事件：

```lua
-- 通用事件处理器
EventHandler("attacked", function(inst) ... end)     -- 被攻击
EventHandler("death", function(inst) ... end)         -- 死亡
EventHandler("gotnewitem", function(inst) ... end)    -- 获得新物品
EventHandler("eat", function(inst) ... end)           -- 吃东西
EventHandler("frozen", function(inst) ... end)        -- 被冻结
EventHandler("electrocuted", function(inst) ... end)  -- 被电击
EventHandler("locomote", function(inst) ... end)      -- 移动命令
EventHandler("knockback", function(inst) ... end)     -- 被击退
```

---

## 2. 玩家 SG (SGplayer_*.lua)

玩家 SG 是最复杂的，包含大量状态。

### 2.1 玩家核心状态

| 状态 | 说明 | 动画 |
|------|------|------|
| `idle` | 待机 | idle |
| `walk` | 走路 | walk |
| `run` | 跑步 | run |
| `doshortaction` | 短动作（捡起/采集） | 取决于动作 |
| `dolongaction` | 长动作（砍树/挖矿） | 取决于动作 |
| `domediumaction` | 中等动作 | 取决于动作 |
| `attack` | 攻击 | attack |
| `death` | 死亡 | death |
| `readbook` | 读书 | 取决于书 |
| `castspell` | 施法 | 取决于法术 |
| `mount` | 骑乘 | 取决于坐骑 |
| `dismount` | 下马 | 取决于坐骑 |
| `fish` | 钓鱼 | fishing |
| `row` | 划船 | rowing |
| `sail` | 扬帆 | sailing |
| `steer` | 掌舵 | steering |
| `pickup` | 捡起 | pickup |
| `eat` | 吃 | eat |
| `build` | 建造 | build |
| `place` | 放置 | 取决于物品 |
| `useitem` | 使用物品 | 取决于物品 |
| `sleepin` | 入睡 | 取决于床 |
| `sleepout` | 醒来 | 取决于床 |
| `hide` | 躲藏 | hide |
| `emote` | 表情 | 取决于表情 |

### 2.2 玩家特殊状态

| 状态 | 说明 |
|------|------|
| `umbrella` | 撑伞 |
| `mining` | 挖矿 |
| `chop` | 砍树 |
| `hammer` | 锤击 |
| `net` | 捕虫网 |
| `shave` | 剃毛 |
| `heal` | 治疗 |
| `revive` | 复活 |
| `resurrect` | 被复活 |
| `cook` | 烹饪 |
| `fish_catch` | 钓到鱼 |
| `oceanfishing` | 海钓 |
| `plant` | 种植 |
| `fertilize` | 施肥 |
| `till` | 耕地 |
| `water` | 浇水 |

### 2.3 角色特有 SG

| SG 文件 | 角色 | 特殊状态 |
|---------|------|----------|
| `SGwilson.lua` | 威尔逊 | 胡子生长 |
| `SGwillow.lua` | 薇洛 | 打火机、火焰 |
| `SGwolfgang.lua` | 沃尔夫冈 | 力量变身 |
| `SGwendy.lua` | 温蒂 | 阿比盖尔召唤 |
| `SGwx78.lua` | WX-78 | 电路、扫描 |
| `SGwickerbottom.lua` | 薇克巴顿 | 读书 |
| `SGwoodie.lua` | 伍迪 | 变身动画 |
| `SGmaxwell.lua` | 麦斯威尔 | 暗影召唤 |
| `SGwigfrid.lua` | 薇格弗德 | 战吼、专属武器 |
| `SGwebber.lua` | 韦伯 | 蜘蛛相关 |
| `SGwinona.lua` | 薇诺娜 | 投石机 |
| `SGwortox.lua` | 沃拓克斯 | 灵魂跳跃 |
| `SGwormwood.lua` | 沃姆伍德 | 种植、开花 |
| `SGwurt.lua` | 沃特 | 鱼人相关 |
| `SGwalter.lua` | 沃尔特 | 弹弓、沃比 |
| `SGwanda.lua` | 旺达 | 时钟魔法 |
| `SGwarly.lua` | 沃利 | 厨师动作 |

---

## 3. Boss SG 列表

| SG 文件 | Boss | 核心状态 |
|---------|------|----------|
| `SGdeerclops.lua` | 独眼巨鹿 | attack, groundpound, howl |
| `SGbearger.lua` | 熊獾 | attack, groundpound, yawn |
| `SGdragonfly.lua` | 蜻蜓龙 | attack, enrage, stomp, lavae_spawn |
| `SGmoose.lua` | 麋鹿鹅 | attack, honk, charge |
| `SGklaus.lua` | 克劳斯 | attack, cast, leap, summon |
| `SGbeequeen.lua` | 蜂后 | attack, screech, summon_grubs |
| `SGantlion.lua` | 蚁狮 | attack, spikes, sandstorm |
| `SGmalbatross.lua` | 邪天翁 | attack, dive, swoop, tornado |
| `SGcrabking.lua` | 螃蟹王 | attack, heal, summon_claws, freeze |
| `SGtoadstool.lua` | 蟾蜍王 | attack, spore_bomb, boom_mushroom, jump |
| `SGstalker.lua` | 远古织影者 | attack, shield, summon, bone_cage |
| `SGminotaur.lua` | 远古守护者 | attack, charge, stomp |
| `SGalterguardian_phase1.lua` | 天体守护者 P1 | attack, laser, spin |
| `SGalterguardian_phase2.lua` | 天体守护者 P2 | attack, crystal_summon, charge |
| `SGalterguardian_phase3.lua` | 天体守护者 P3 | attack, enlightened_attack |
| `SGeyeofterror.lua` | 恐怖之眼 | attack, charge, spawn_minis |
| `SGdaywalker.lua` | 昼行者 | attack, dash, howl |

---

## 4. 常用生物 SG 列表

| SG 文件 | 生物 |
|---------|------|
| `SGspider.lua` | 蜘蛛 |
| `SGpig.lua` | 猪人 |
| `SGbeefalo.lua` | 牛 |
| `SGhound.lua` | 猎犬 |
| `SGtallbird.lua` | 高鸟 |
| `SGfrog.lua` | 青蛙 |
| `SGbee.lua` | 蜜蜂 |
| `SGbat.lua` | 蝙蝠 |
| `SGchester.lua` | 切斯特 |
| `SGbunnyman.lua` | 兔人 |
| `SGmerm.lua` | 鱼人 |
| `SGkoalefant.lua` | 考拉象 |
| `SGkrampus.lua` | 坎普斯 |
| `SGLeif.lua` | 树精 |
| `SGrocky.lua` | 岩石龙虾 |
| `SGpenguin.lua` | 企鹅 |
| `SGbird.lua` | 鸟类 |
| `SGbutterfly.lua` | 蝴蝶 |
| `SGmole.lua` | 鼹鼠 |
| `SGcatcoon.lua` | 浣熊猫 |
| `SGglommer.lua` | 格罗姆 |
| `SGperd.lua` | 火鸡 |
| `SGslurtle.lua` | 蜗牛龟 |
| `SGmosquito.lua` | 蚊子 |
| `SGbuzzard.lua` | 秃鹰 |
| `SGlightninggoat.lua` | 闪电羊 |
| `SGgrassgekko.lua` | 草壁虎 |
| `SGworm.lua` | 洞穴蠕虫 |
| `SGslurper.lua` | 吸食兽 |

---

## 5. SG 编写教程

### 5.1 基础 SG 模板

```lua
-- SGmycreature.lua
require("stategraphs/commonstates")

local actionhandlers = {
    ActionHandler(ACTIONS.ATTACK, "attack"),
    ActionHandler(ACTIONS.EAT, "eat"),
}

local events = {
    CommonHandlers.OnLocomote(false, true),  -- 走路+跑步
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnAttack(),
    CommonHandlers.OnHit(),
    CommonHandlers.OnEat(),

    EventHandler("my_event", function(inst, data)
        if not (inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("dead")) then
            inst.sg:GoToState("my_state", data)
        end
    end),
}

local states = {
    State{
        name = "idle",
        tags = { "idle", "canrotate" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("idle", true)  -- true = 循环
        end,

        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "attack",
        tags = { "attack", "busy", "canrotate" },

        onenter = function(inst, target)
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("attack")
            inst.sg.statemem.target = target
        end,

        timeline = {
            TimeEvent(8 * FRAMES, function(inst)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
            end),
        },

        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "death",
        tags = { "busy", "dead" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("death")
            inst.components.lootdropper:DropLoot()
        end,

        events = {
            EventHandler("animover", function(inst)
                inst:Remove()
            end),
        },
    },
}

return StateGraph("mycreature", states, events, "idle", actionhandlers)
```

### 5.2 TimeEvent 用法

```lua
timeline = {
    -- 在动画的第 N 帧执行
    TimeEvent(5 * FRAMES, function(inst)
        -- 第 5 帧
    end),

    TimeEvent(10 * FRAMES, function(inst)
        -- 第 10 帧
    end),

    -- 根据动画事件触发
    TimeEvent("hit", function(inst)
        -- 动画中标记 "hit" 的位置
    end),

    -- 范围事件
    TimeEvent(5 * FRAMES, 15 * FRAMES, function(inst)
        -- 5-15 帧期间持续执行
    end),
}
```

### 5.3 状态转换

```lua
-- 基本转换
inst.sg:GoToState("walk")

-- 带参数转换
inst.sg:GoToState("attack", target)

-- 条件转换
if not inst.sg:HasStateTag("busy") then
    inst.sg:GoToState("idle")
end

-- 检查当前状态
if inst.sg:HasStateTag("idle") then
    -- 在待机中
end

-- 获取当前状态名
local state = inst.sg.currentstate.name
```

### 5.4 在 Prefab 中绑定 SG

```lua
local function fn()
    local inst = CreateEntity()
    -- ... 实体设置 ...
    inst:SetStateGraph("SGmycreature")
    return inst
end
```

### 5.5 在 Mod 中修改 SG

```lua
-- 在 modmain.lua 中
AddStategraphPostInit("wilson", function(sg)
    -- 修改已有状态
    local idleState = sg.states["idle"]
    -- ...

    -- 添加新状态
    sg.states["my_state"] = State{
        name = "my_state",
        -- ...
    }
end)
```

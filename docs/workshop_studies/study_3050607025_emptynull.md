# 饥荒创意工坊研读报告：EmptyNull

- **模组标识**：`3050607025`
- **作者**：大大果汁、凉时白开、小瑾、天涯共此时、小花朵
- **版本**：2.8.25
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：15 个 Lua 文件 / 共 2747 行；网络变量 4 处；RPC 0 处；注入钩子 10 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/auto_clean.lua`
- `scripts/auto_stack.lua`
- `scripts/batch_trade.lua`
- `scripts/batch_trade_bk.lua`
- `scripts/lang/strings_cn.lua`
- `scripts/lang/strings_en.lua`
- `scripts/more_stack_item.lua`
- `scripts/more_stack_size.lua`
- `scripts/no_stump.lua`
- `scripts/stop_regrowth.lua`
- `scripts/twiggy.lua`
- `scripts/winona_catapult.lua`
- `scripts/winter_ornament.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `world` | 2 |
| `AddComponentPostInit` | `stackable` | 2 |
| `AddPrefabPostInit` | `mermking` | 2 |
| `AddPrefabPostInit` | `pigking` | 2 |
| `AddPrefabPostInit` | `birdcage` | 2 |
| `AddPrefabPostInit` | `antlion` | 2 |
| `AddComponentPostInit` | `growable` | 1 |
| `AddPrefabPostInit` | `lg_litchi_tree` | 1 |
| `AddPrefabPostInit` | `lg_lemon_tree` | 1 |
| `AddPrefabPostInit` | `lg_palmtree` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("world")
```lua
	end	
	AddPrefabPostInit("world", function(inst)
		if GLOBAL.TheShard:IsMaster() then
			noticeTask = GLOBAL.TheWorld:DoPeriodicTask(cleancycle_ultimate - 0.5 * TUNING.TOTAL_DAY_TIME, NoticeTask)
		end
		GLOBAL.TheWorld:DoPeriodicTask(cleancycle_ultimate , CleanDelay)
	end)
end

-- Get Player var userid
local function GetPlayerById(playerid)
	for _, v in ipairs(GLOBAL.AllPlayers) do
```
### AddComponentPostInit("stackable")
```lua
end
AddComponentPostInit('stackable', function(Stackable)
    local Get = Stackable.Get
    function Stackable:Get(...)
        local instance = Get(self, ...)
        if instance.xt_stack_task then
            instance.xt_stack_task:Cancel()
            instance.xt_stack_task = nil
        end
        return instance
    end
end)
```
### AddPrefabPostInit("mermking")
```lua
-- ==================== 鱼人王相关 ====================
AddPrefabPostInit("mermking", function(inst)
    -- 批量交易 - 分帧处理
    local old_tradeitem = inst.TradeItem
    inst.TradeItem = function(inst)
        local giver = inst.tradegiver
        local item = inst.itemtotrade
        ProcessInFrames(inst, 
            function(inst, giver, item)
                inst.tradegiver = giver
                inst.itemtotrade = item
                old_tradeitem(inst)
```
### AddPrefabPostInit("pigking")
```lua
-- ==================== 猪王 ====================
AddPrefabPostInit("pigking", function(inst)
    local old_onaccept = inst.components.trader.onaccept
    inst.components.trader.onaccept = function(inst, giver, item)
        ProcessInFrames(inst, old_onaccept, giver, item)
    end
    
    TraderBusyTest(inst)
end)

-- ==================== 鸟笼 ====================
AddPrefabPostInit("birdcage", function(inst)
```
### AddPrefabPostInit("birdcage")
```lua
-- ==================== 鸟笼 ====================
AddPrefabPostInit("birdcage", function(inst)
    local old_onaccept = inst.components.trader.onaccept
    inst.components.trader.onaccept = function(inst, giver, item)
        ProcessInFrames(inst, old_onaccept, giver, item)
    end
    
    TraderBusyTest(inst)
end)

-- ==================== 蚁狮 ====================
AddPrefabPostInit("antlion", function(inst)
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 4 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。
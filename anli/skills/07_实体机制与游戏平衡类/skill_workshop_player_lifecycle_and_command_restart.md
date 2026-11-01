# 饥荒工业级最佳实践范式：服务端聊天指令拦截与玩家生命周期注销重启
> 对应工坊权威基准：Mod 462434129 (`Restart`) 及全指令衍生变体
> 技术标签：Networking_Say Hook、ms_playerdespawnanddelete、静默指令截断、无污染注销重选、实体生命周期

---

## 一、架构背景与设计哲学
在联机版服务器中，玩家往往需要通过公屏聊天输入指令（如 `#restart`、`#resurrect`）实现自杀重选、原地复活或清理个人实体数据。
官方没有公开标准的模组聊天指令注册总线，导致多数模组暴力篡改 `Networking_Say`，引发以下严重问题：
1. **指令泄露公屏**：指令文本被广播至全服玩家聊天框，造成视觉污染；
2. **实体残留与内存泄漏**：简单使用 `player:Remove()` 会导致地图标记、计分板（Scoreboard）数据、专属装备及宠物脱靶残留在世界中无法回收；
3. **客机客户端闪退**：未通知客户端网络层即销毁角色实体，导致客户端在接收后续数据包时产生空指针崩溃。

## 二、核心底层时钟与生命周期序列
1. **指令静默吞吐流**：
   在全局 `Networking_Say` 入口点执行前缀捕获（`string.sub(message, 1, 1) == "#"`），命中自定义指令后立即静默返回 `nil`，彻底拦截下游广播。
2. **官方安全注销管道（ms_playerdespawnanddelete）**：
   绝不调用裸 `Remove()`，必须将注销委托给世界状态管理器：
   ```lua
   TheWorld:PushEvent("ms_playerdespawnanddelete", player)
   ```
   触发官方完整的注销链：卸载容器 -> 触发掉落回执 -> 保存全局元数据 -> 优雅通知客机返回选人界面。

## 三、标准化生产级代码范式（可直接移植）

```lua
-- ============================================================================
-- 生产级无污染聊天指令拦截与玩家生命周期重置器
-- ============================================================================
local GLOBAL = GLOBAL
local TheNet = GLOBAL.TheNet
local TheWorld = GLOBAL.TheWorld

-- 1. 注册指令分发总线
local COMMANDS = {}

function RegisterChatCommand(cmd, handler)
    COMMANDS[string.lower(cmd)] = handler
end

-- 2. Hook 底层网络聊天通道 (静默拦截)
local Old_Networking_Say = GLOBAL.Networking_Say
GLOBAL.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, isemote, user_vanity)
    if message and (string.sub(message, 1, 1) == "#" or string.sub(message, 1, 1) == "/") then
        local raw_cmd = string.sub(message, 2)
        local args = {}
        for word in string.gmatch(raw_cmd, "%S+") do
            table.insert(args, word)
        end
        local cmd_name = string.lower(args[1] or "")
        
        if COMMANDS[cmd_name] then
            local player = GLOBAL.TheWorld.net and GLOBAL.TheWorld.net:GetPlayerTableByUserId(userid)
            if player and player.inst then
                table.remove(args, 1)
                COMMANDS[cmd_name](player.inst, args)
                -- 核心拦截点：直接返回，绝对不交给下游广播函数，实现静默执行
                return
            end
        end
    end
    return Old_Networking_Say(guid, userid, name, prefab, message, colour, whisper, isemote, user_vanity)
end

-- 3. 生产级安全自杀重选处理
RegisterChatCommand("restart", function(player, args)
    if not player:IsValid() then return end
    
    -- 掉落随身物品，避免存档数据污染
    if player.components.inventory then
        player.components.inventory:DropEverything(true)
    end
    
    -- 官方规范注销并弹出选人界面
    TheWorld:PushEvent("ms_playerdespawnanddelete", player)
end)
```

## 四、方案对比矩阵与权衡取舍（Trade-off Matrix）

| 技术选型方案 | 核心技术原理 | 优势与收益 | 代价与潜在风险 | 推荐适用场景 |
| :--- | :--- | :--- | :--- | :--- |
| **方案 A：ms_playerdespawnanddelete 世界管道（本母本）** | 挂载官方世界级状态事件 | 100% 内存安全、无残留幽灵、自动唤起选人界面 | 无法保留玩家原有技能树加成 | 绝大多数公共生存服、自建开荒服 |
| **方案 B：实体就地变鬼 + 坐标传送重生（In-situ Respawn）** | `PushEvent("makeplayerghost")` 并迁移坐标 | 保留玩家原有历史数据、无重连开销 | 若在非安全区易引发二次暴毙、无法更换角色 | 挑战服、专属特定角色体验服 |

## 五、进阶拓扑演进与变体分支
- **变体 1（惩罚锁冷却机制）**：增加全服每玩家 5 分钟 CD 限制（记录于 `TheWorld._restart_cooldown[userid]`），防止玩家恶意刷取开局初始物资。
- **变体 2（骨片遗留与死亡通知）**：在执行销毁前，在原坐标原子化生成一个玩家骸骨 `skeleton_player`，并向全服广播死亡原因通知。

## 六、踩坑与反模式避错指南（防御性闭环）
1. **直接调用 `player:Remove()`**：极其致命的重大反模式！会导致计分板出现幽灵死锁占位、全服玩家看该玩家显示仍在游戏且无法回收其网络 GUID。
2. **骑乘（Rider）状态直接注销**：如果玩家骑在牛背上直接触发重选，牛实体会因为缺少骑乘者注销回执而永久进入无法交互的静默假死状态。必须在触发前强制调用 `player.components.rider:Dismount()`！
3. **断网重入竞态**：玩家输入 `#restart` 后瞬间断网，重载入后可能出现重复加载。必须在执行时打上脏标记 `player._despawn_in_progress = true` 防重入。

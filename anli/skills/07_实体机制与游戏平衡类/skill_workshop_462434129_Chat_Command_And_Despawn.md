# 饥荒一线工坊深度研读 Skill：聊天指令总线拦截与玩家实体生命周期重置切面

- **工坊 ID**：462434129 (`Restart`)
- **领域分类**：服务端控制台拦截（`Networking_Say`）、玩家注销事件（`ms_playerdespawnanddelete`）、迷雾二进制继承、幽灵重生状态机
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发“玩家自选换人、死亡自救、管理控制台指令系统”时，核心机制包括：
1. **聊天消息拦截切面**：Hook `Networking_Say`，解析首字符带 `#` 或 `/` 的指令，截胡消费并静默返回；
2. **安全退出与重选**：调用世界事件 `TheWorld:PushEvent("ms_playerdespawnanddelete", player)` 触发官方标准退人序列；
3. **幽灵重生触发**：使用 `player:PushEvent("respawnfromghost")` 恢复肉身。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：服务端聊天文本命令路由拦截器 (scripts/tools/chat_command_router.lua)
-- ==============================================================================

local ChatCommandRouter = {}
local COMMAND_HANDLERS = {}

--- 注册聊天命令处理器
--- @param cmd_name string 命令字符串 (如 "#reset", "#suicide")
--- @param handler function 处理函数 function(player, args)
function ChatCommandRouter.Register(cmd_name, handler)
    COMMAND_HANDLERS[string.lower(cmd_name)] = handler
end

--- 安装聊天拦截切面 (仅在 MasterSim 执行)
function ChatCommandRouter.Install()
    if not GLOBAL.TheWorld.ismastersim then return end

    local old_Networking_Say = GLOBAL.Networking_Say
    GLOBAL.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, isemote, user_vanity)
        if message and string.sub(message, 1, 1) == "#" then
            local cmd = string.lower(string.match(message, "^(%S+)") or "")
            local handler = COMMAND_HANDLERS[cmd]

            if handler then
                -- 查找对应的玩家实体
                local player = GLOBAL.UserToPlayer(userid)
                if player and player:IsValid() then
                    handler(player, message)
                end
                -- 核心拦截：不广播该指令字符串到聊天公屏
                return
            end
        end

        return old_Networking_Say(guid, userid, name, prefab, message, colour, whisper, isemote, user_vanity)
    end
end

-- ==============================================================================
-- 范式 2：官方级玩家安全重置换人与迷雾记忆保留接口
-- ==============================================================================

local SAVED_MAPS = {}

--- 安全送回选人界面
--- @param player table 玩家实体
--- @param drop_items boolean 是否掉落全身装备
--- @param keep_map boolean 是否保留迷雾记忆
function ChatCommandRouter.DespawnAndReselect(player, drop_items, keep_map)
    if not player or not player:IsValid() or not GLOBAL.TheWorld.ismastersim then return end

    local userid = player.userid

    -- 1. 抓取迷雾二进制流
    if keep_map and player.player_classified and player.player_classified.MapExplorer then
        SAVED_MAPS[userid] = player.player_classified.MapExplorer:RecordMap()
    end

    -- 2. 掉落全身装备与物品 (防止带走专属物品)
    if drop_items and player.components.inventory then
        player.components.inventory:DropEverything(false, false)
    end

    -- 3. 官方原生注销事件 (通知客机退回选人大厅，绝无句柄残留)
    GLOBAL.TheWorld:PushEvent("ms_playerdespawnanddelete", player)
end

--- 监听新角色登入：无缝还原迷雾
GLOBAL.TheWorld:ListenForEvent("ms_playerjoined", function(world, new_player)
    if not new_player or not new_player:IsValid() then return end
    local userid = new_player.userid
    if SAVED_MAPS[userid] then
        new_player:DoTaskInTime(1, function()
            if new_player.player_classified and new_player.player_classified.MapExplorer then
                new_player.player_classified.MapExplorer:LearnRecordedMap(SAVED_MAPS[userid])
            end
            SAVED_MAPS[userid] = nil
        end)
    end
end)

return ChatCommandRouter
```

---

## 三、避坑与生产安全准则

1. **绝对禁止使用 `player:Remove()` 代替 `ms_playerdespawnanddelete`**：
   - 直接 `player:Remove()` 会强制断开客机的网络 Socket，客户端会显示“Dedicated Server Connection Lost”强制跳出房间。必须推送 `ms_playerdespawnanddelete` 事件，由官方引擎平滑执行客机退回大厅逻辑。
2. **指令参数的大写/小写鲁棒性**：
   - 玩家在聊天框输入指令时可能误开启大写锁定（如 `#RESTART`），必须使用 `string.lower` 统一规整，防止命令因大小写不匹配而泄漏到全服聊天流中。

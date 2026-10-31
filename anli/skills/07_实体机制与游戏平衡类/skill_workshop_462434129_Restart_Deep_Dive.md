# 饥荒一线工坊深度研读 Skill：462434129_Restart 聊天网络劫持与软重置机制

- **工坊 ID**：462434129 (`Restart`)
- **领域分类**：网络聊天事件 Hook (`Networking_Say`)、跨平台多语言热重载、玩家软重置/重生全流程治理
- **研读源码**：`modmain.lua`

---

## 一、核心实现原理与硬核突破点

### 1. 网络聊天底层劫持机制 (`Networking_Say` Hook)
- 饥荒没有公开的“玩家公屏命令注册器”，该 MOD 采用直接拦截全局 `GLOBAL.Networking_Say` 函数：
  ```lua
  local Old_Networking_Say = _G.Networking_Say
  _G.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, isemote, ...)
      Old_Networking_Say(guid, userid, name, prefab, message, colour, whisper, isemote, ...)
      -- 解析 message，判断是否命中命令（如 #restart / #resurrect / #kill）
  end
  ```
- **关键设计精髓**：先让原版 `Old_Networking_Say` 执行完毕，确保公屏气泡正常冒出、聊天记录正常记录，随后立即做异步 `player:DoTaskInTime(...)` 处理业务，避免阻塞整个网络包收发管线。

### 2. 玩家跨生命周期冷却（Cooldown）治理
- 玩家在重置、死亡、复活期间实体可能被销毁再创建（GUID 改变），不能将 CD 记录在 `player` 实体上！
- MOD 维护了独立的全局内存字典：`restartlist[player.userid] = { restart = ..., resurrect = ..., kill = ... }`，以 Steam ID (`userid`) 作为绝对主键。
- 在 `playerspawner` 的 `ms_playerjoined` 监听中重新恢复该玩家的 CD 状态。

### 3. 彻底重置角色与地图数据保留机制
- **重选角色实现**：
  ```lua
  player:PushEvent("player_despawnanddelete")
  -- 或者调用官方重生流程，结合 UserToPlayer(userid)
  ```
- **地图探索数据跨生命周期传承**：
  - 在重置前，通过 `player.player_classified.MapExplorer:RecordMap()` 保存玩家探索过的迷雾信息。
  - 在重新选人加入世界后，通过 `player.player_classified.MapExplorer:TeachMap()` 把上一世的地图迷雾重新刷回给客户端，极大提升联机体验。

---

## 二、标准化生产级代码范式

```lua
-- ==============================================================================
-- 范式：基于 Networking_Say 劫持的无侵入式服务端玩家交互命令系统
-- ==============================================================================

local _G = GLOBAL
if not (_G.TheNet and _G.TheNet:GetIsServer()) then return end

local PlayerCommandCD = {} -- 以 userid 为 key

local COMMANDS = {
    ["#help"] = function(player)
        player.components.talker:Say("当前可用命令：#help, #suicide")
    end,
    ["#suicide"] = function(player)
        if player:IsValid() and not player:HasTag("playerghost") then
            player.components.health:Kill()
        end
    end
}

local Old_Networking_Say = _G.Networking_Say
_G.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, isemote, ...)
    -- 保证原聊天逻辑正常执行
    Old_Networking_Say(guid, userid, name, prefab, message, colour, whisper, isemote, ...)
    
    if not message or type(message) ~= "string" then return end
    
    local clean_msg = string.lower(string.match(message, "^%s*(.-)%s*$"))
    local handler = COMMANDS[clean_msg]
    if handler then
        local player = _G.UserToPlayer(userid)
        if player and player:IsValid() then
            -- 0.1秒延时调度，脱离当前网络帧上下文
            player:DoTaskInTime(0.1, handler)
        end
    end
end
```

---

## 三、避坑与生产安全准则

1. **绝对不要在客户端执行网络聊天解析业务**：
   - 首行必须写死 `if not (_G.TheNet and _G.TheNet:GetIsServer()) then return end`。聊天命令的执行权限属于服务端逻辑，严禁在客户端直接调用重置/击杀函数。
2. **重置掉落物安全机制**：
   - 玩家重置清包时，必须使用 `player.components.inventory:DropEverything(false, true)` 并额外检查 `overflow` 背包，防止玩家身上的独有法宝因删除实体而彻底消失在虚空中。

# 饥荒创意工坊深度研读报告：Restart（快捷重选角色与世界重置体系）

- **模组标识**：`462434129` (`Restart / 快捷重选角色`)
- **作者**：Skull & Orange
- **版本**：v0.3.2
- **领域分类**：服务端控制台协议拦截（`Networking_Say`）、玩家生命周期销毁重选（`ms_playerdespawnanddelete`）、幽灵复活与地图迷雾继承、冷却时间（Cooldown）动态衰减与惩罚步长
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含完整解压后的 `modmain.lua` 与多语言切面）

---

## 一、架构全貌与顶层设计思想

在饥荒联机版中，如果玩家选错角色或想换人体验，原版要求管理员重置整个世界或者玩家自杀后使用极其昂贵的天体之门道具。

`Restart` 作为服务器端权威运维与换人利器，其核心技术价值在于：
1. **聊天文本命令协议总线（Chat Command Bus）**：无侵入式切面拦截 `Networking_Say`，支持 `#restart`、`#restart_d`、`#resurrect`、`#kill` 等伪指令；
2. **底层世界事件驱动换人（`ms_playerdespawnanddelete`）**：调用引擎原生的销毁与注销原语，将玩家安全送回选人界面（Lobby），杜绝脏数据残留；
3. **记忆迷雾跨生继承（Map Learning Cross-Life）**：在角色销毁前抓取迷雾二进制流（`MapExplorer:RecordMap()`），新角色登入时无缝重学，不丢失已探索地图。

---

## 二、四大硬核核心技术解构

### 1. `Networking_Say` 拦截器与指令静默路由（Command Router）
- 原版玩家按 Y/U 发送的聊天消息，最终由 `GLOBAL.Networking_Say` 分发。
- **MOD 切面设计**：
  ```lua
  local old_Networking_Say = GLOBAL.Networking_Say
  GLOBAL.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, isemote, user_vanity)
      local msg = string.lower(message)
      if MSG_CHOOSE[msg] then
          -- 1. 命中自定义指令，执行换人或复活逻辑
          ExecuteCommand(userid, MSG_CHOOSE[msg])
          -- 2. 核心拦截：不调用 old_Networking_Say，防止向全服广播 #restart 杂乱字符串！
          return
      end
      return old_Networking_Say(guid, userid, name, prefab, message, colour, whisper, isemote, user_vanity)
  end
  ```
  在服务端入口层实现文本拦截，玩家输入指令时聊天框不会泛滥刷屏，兼顾了指令交互与社交私密性。

### 2. 原生玩家注销与删除事件（`ms_playerdespawnanddelete`）
- **痛点**：若直接调用 `player:Remove()`，玩家的客户端网络通道会被强行掐断，导致客机直接崩溃退服。
- **官方级解法**：
  ```lua
  TheWorld:PushEvent("ms_playerdespawnanddelete", player)
  ```
  该事件通知底层世界管理器执行官方标准注销序列：
  - 自动清理该玩家的物理碰撞体与网络信标；
  - 向客机下发退出世界并返回大厅（Lobby）的选人通知；
  - 释放角色占据的槽位资源，实现绝对零内存泄漏的安全换人。

### 3. 跨角色地图迷雾二进制继承（MapExplorer Serializer）
- 换人后原本已探索的世界迷雾默认被重置。MOD 提供了保存迷雾配置：
  1. **销毁前快照**：
     ```lua
     if map_save == 1 and player.player_classified and player.player_classified.MapExplorer then
         restartlist[player.userid].map = player.player_classified.MapExplorer:RecordMap()
     end
     ```
  2. **新生后灌注**：
     新角色生成触发 `ms_playerjoined` 时：
     ```lua
     player.player_classified.MapExplorer:LearnRecordedMap(saved_map)
     ```
     一键还原前世记忆，兼顾了换角色的灵活性与探图成果。

### 4. 冷却惩罚与幽灵死亡状态机补偿（Cooldown Lifecycle）
- 维护了按 Steam `userid` 索引的常驻数据结构 `restartlist`；
- 独创“死亡状态下的倒计时衰减（`DeathRemove`）”机制：当玩家在幽灵状态无法通过移动恢复冷却时，启动定时任务 `target:DoTaskInTime(1, DeathRemove)` 逐秒扣除 CD，杜绝卡冷却死锁。

---

## 三、避坑实战经验

1. **`player.rezsource` 死亡/复活来源标记**：
   - 使用指令复活幽灵时，必须标记 `player.rezsource = "resurrect"` 并调用 `player:PushEvent("respawnfromghost")`。若直接修改生命值 `health:SetCurrentHealth(100)` 而不恢复幽灵状态机，角色会变成拥有满血血条却依然只能飘浮穿墙的不可交互“活死人”。
2. **掉落物品判定（Force Drop All）**：
   - 执行换人前，必须检测是否需要强制掉落（`player.components.inventory:DropEverything()`）。若不清空背包，部分角色专属装备（如薇洛的打火机、温蒂的阿比盖尔之花）可能会被带给其他角色引发状态错乱。

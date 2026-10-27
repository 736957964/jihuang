# 网络/同步系统 (Networking)

> 源码: `scripts/networking.lua` + `scripts/netvars.lua`

## 概述

DST 是客户端-服务器架构的多人游戏。网络同步系统负责：
- 在服务器和客户端之间同步实体数据
- 管理网络变量（NetVars）
- 处理远程过程调用（RPC）

## 核心概念

### 主客机判断

```lua
-- 判断当前是否为主机（服务器）
if TheWorld.ismastersim then
    -- 仅在服务器执行的逻辑
end

-- 判断当前是否为客户端
if not TheWorld.ismastersim then
    -- 仅在客户端执行的逻辑
end

-- 判断是否为专用服务器
if TheNet:IsDedicated() then
    -- 专用服务器逻辑
end

-- 获取当前游戏模式
TheNet:GetServerGameMode()  -- "survival" / "endless" / "wilderness"
```

## 网络变量 (NetVars)

网络变量是同步服务器数据到客户端的主要机制。

### 定义 NetVar

```lua
-- 在实体初始化时定义
inst.mydata = net_int(inst.GUID, "myname.mydata")
-- 或
inst.mydata = net_float(inst.GUID, "myname.mydata")
inst.mydata = net_bool(inst.GUID, "myname.mydata")
inst.mydata = net_string(inst.GUID, "myname.mydata")
inst.mydata = net_entity(inst.GUID, "myname.mydata")
inst.mydata = net_byte(inst.GUID, "myname.mydata")
inst.mydata = net_short(inst.GUID, "myname.mydata")
```

### 读写 NetVar

```lua
-- 写入（仅服务器）
inst.mydata:set(42)

-- 读取（服务器和客户端都可）
local value = inst.mydata:value()

-- 本地写入（不网络同步）
inst.mydata:set_local(100)
```

### NetVar 类型

| 类型 | 函数 | 范围 |
|------|------|------|
| `net_bool` | 布尔 | true/false |
| `net_byte` | 字节 | 0-255 |
| `net_short` | 短整数 | -32768~32767 |
| `net_int` | 整数 | -2^31~2^31-1 |
| `net_float` | 浮点数 | - |
| `net_string` | 字符串 | - |
| `net_entity` | 实体引用 | GUID |
| `net_tinybyte` | 微小字节 | 0-7 |

### NetVar 脏标记

```lua
-- 检查是否有脏数据需要同步
inst.mydata:dirty()

-- 标记为脏（强制下次同步）
inst.mydata:setdirty()
```

## 网络事件 (NetEvents)

网络事件用于从服务器向客户端推送一次性事件。

```lua
-- 服务器推送网络事件
inst:PushEvent("my_net_event", data)

-- 需要预先在客户端注册
-- 在 modmain.lua 中：
AddNetEvent("my_net_event")
```

## RPC (远程过程调用)

### 服务器 → 客户端

```lua
-- 客户端定义 RPC 处理函数
AddClientModRPCHandler(modname, "MyRPCName", function(player, data)
    -- 在客户端执行
end)

-- 服务器发送 RPC
SendModRPCToClient(
    CLIENT_MOD_RPC[modname]["MyRPCName"],
    userid,
    data
)
```

### 客户端 → 服务器

```lua
-- 服务器定义 RPC 处理函数
AddModRPCHandler(modname, "MyServerRPC", function(player, data)
    -- 在服务器执行
end)

-- 客户端发送 RPC
SendModRPCToServer(
    MOD_RPC[modname]["MyServerRPC"],
    data
)
```

## 副本系统 (Replicas)

Replicas 是客户端侧的数据镜像，自动同步关键数据。

### 定义 Replica

```lua
-- 在 components/ 中创建 xxx_replica.lua
local MyReplica = Class(function(self, inst)
    self.inst = inst
    self._myvalue = net_int(inst.GUID, "myreplica.myvalue")
end)

function MyReplica:SetMyValue(val)
    self._myvalue:set(val)
end

function MyReplica:GetMyValue()
    return self._myvalue:value()
end

return MyReplica
```

### 在组件中使用 Replica

```lua
-- 服务器端组件设置值
function MyComponent:SetValue(val)
    self.myvalue = val
    self.inst.replica.mycomponent:SetMyValue(val)
end
```

## 分类网络变量 (Classified)

Classified 变量是特殊的网络变量，存储在玩家专属的 classified 实体上，仅该玩家可见。

```lua
-- 在玩家预制体中
inst.mydata = net_int(inst.GUID, "myname.mydata", "mydata_dirty")

-- 或使用 classified
if TheWorld.ismastersim then
    inst.player_classified.mydata:set(value)
end
```

## 网络同步最佳实践

```lua
-- 1. 区分主客机逻辑
if TheWorld.ismastersim then
    -- 服务器逻辑（伤害计算、状态改变、AI）
    inst:DoTaskInTime(1, function()
        inst.components.health:DoDelta(-10)
    end)
end

-- 2. 使用 NetVar 同步关键数据
-- 服务器
inst.myvalue:set(new_value)
-- 客户端
local value = inst.myvalue:value()

-- 3. 使用 AddComponentAction 进行交互（自动网络同步）
AddComponentAction("USEITEM", "mycomponent", function(inst, doer, actions, right)
    -- 客户端和服务器都会执行
end)

-- 4. 使用 Stategraph 事件处理网络动作
-- stategraphs 自动处理动作的网络同步

-- 5. 确保在正确的端执行
if not TheWorld.ismastersim then
    return  -- 客户端不需要执行服务器逻辑
end
```

## 网络调试

```lua
-- 打印网络变量
print("Net var value:", inst.mydata:value())

-- 检查是否有脏数据
if inst.mydata:dirty() then
    print("Net var is dirty!")
end

-- 获取当前连接的玩家
for i, v in ipairs(AllPlayers) do
    print("Player:", v.userid, v.name)
end
```

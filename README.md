# 饥荒联机版 (Don't Starve Together) Mod 开发参考文档

> 基于 DST 源码 `scripts.zip` 完整反编译分析，覆盖所有重要模块的 API 参考。
> 在线网址：https://736957964.github.io/jihuang/#/README
## 目录导航

| 模块 | 路径 | 说明 |
|------|------|------|
| **核心系统** | [01-core/](/01-core/index) | EntityScript、Prefab、Class、全局函数、全局变量 |
| **组件系统** | [02-components/](/02-components/index) | 815个组件，按功能分10大类 |
| **动作系统** | [03-actions/](/03-actions/index) | 所有 ACTIONS 定义和使用 |
| **标签系统** | [04-tags/](/04-tags/index) | TAG 完整分类列表 |
| **事件系统** | [05-events/](/05-events/index) | 所有推送事件、监听机制 |
| **状态机** | [06-stategraphs/](/06-stategraphs/index) | SG 状态机系统 |
| **大脑系统** | [07-brains/](/07-brains/index) | AI 行为树 |
| **预制体** | [08-prefabs/](/08-prefabs/index) | 1583个预制体分类索引 |
| **TUNING** | [09-tuning/](/09-tuning/index) | 游戏数值配置 |
| **网络同步** | [10-networking/](/10-networking/index) | 主客机同步、NetVar、RPC |
| **Mod开发** | [11-modding/](/11-modding/index) | modinfo、modmain、PostInit系列 |
| **烹饪系统** | [12-cooking/](/12-cooking/index) | 食谱、烹饪机制 |
| **世界系统** | [13-world/](/13-world/index) | 地图、季节、天气 |
| **技能树** | [14-skilltree/](/14-skilltree/index) | 技能树系统 |
| **UI系统** | [15-ui/](/15-ui/index) | Widget、Screen |
| **常量枚举** | [16-constants/](/16-constants/index) | 所有常量与枚举定义 |
| **标准组件函数** | [17-standardcomponents/](/17-standardcomponents/index) | Make系列标准组件函数 |

## 快速开始

### Mod 开发最小模板

```lua
-- modinfo.lua
name = "我的Mod"
description = "Mod描述"
author = "作者"
version = "1.0"
dst_compatible = true
all_clients_require_mod = true

-- modmain.lua
-- 全局Hook点
AddPrefabPostInit("wilson", function(inst)
    -- 修改wilson角色
end)
```

### 常用全局变量速查

| 变量 | 说明 | 可用范围 |
|------|------|----------|
| `TheWorld` | 世界实例 | 游戏中 |
| `ThePlayer` | 当前玩家 | 客户端 |
| `TheSim` | 引擎层接口 | 全局 |
| `TheNet` | 网络接口 | 全局 |
| `TheFrontEnd` | 前端UI管理 | 全局 |
| `AllPlayers` | 所有玩家列表 | 服务端 |
| `Ents[guid]` | 通过GUID获取实体 | 全局 |
| `GLOBAL` | 全局环境表 | Mod环境 |

### 主客机区分

```lua
if TheWorld.ismastersim then
    -- 仅在主机执行的逻辑
end

if TheNet:GetIsServer() then
    -- 服务端逻辑
end
```

## 源码版本

基于 Don't Starve Together `scripts.zip` 解压分析，815个组件、1583个预制体、191个Brain、261个StateGraph。

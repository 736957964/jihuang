# 饥荒创意工坊研读报告：启蒙待机修复·服务器版 Lunar Idle Fix (Server)

- **模组标识**：`3830162539`
- **作者**：鱼老师
- **版本**：1.0.0
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：2 个 Lua 文件 / 共 143 行；网络变量 0 处；RPC 0 处；注入钩子 1 处

## 一、代码结构与入口分布

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddStategraphPostInit` | `wilson` | 1 |

## 三、关键代码片段

### AddStategraphPostInit("wilson")
```lua
-- 路径 A：模组框架的 stategraph 后处理
AddStategraphPostInit("wilson", PatchGraph)

-- 路径 B：玩家出生后直接补它身上的状态机实例（更可靠）
AddPlayerPostInit(function(inst)
	if inst.components ~= nil and inst.components.sanity ~= nil
		and inst.sg ~= nil and inst.sg.sg ~= nil then
		PatchGraph(inst.sg.sg)
	end
end)
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。
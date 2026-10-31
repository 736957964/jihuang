# 饥荒创意工坊研读报告：everything_chop

- **模组标识**：`3830318655`
- **作者**：山本粥子的小老公
- **版本**：1.0.1
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：2 个 Lua 文件 / 共 532 行；网络变量 0 处；RPC 0 处；注入钩子 1 处

## 一、代码结构与入口分布

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddComponentPostInit` | `actionqueuer` | 1 |

## 三、关键代码片段

### AddComponentPostInit("actionqueuer")
```lua
--------------------------------------------------------------------
ENV.AddComponentPostInit("actionqueuer", function(self)
	ActionQueuer = self

	local CheckAllowedActions = GetUpvalue(self.Wait, "CheckAllowedActions")

	-- 1) 覆盖 GetAction：手持发光物且没在移动时，把目标动作覆盖成"用对应工具"
	local GetAction = self.GetAction
	self.GetAction = function(self, target, rightclick, pos)
		local IsRiding = ThePlayer.replica.rider:IsRiding()
		local active_item = ThePlayer.replica.inventory:GetActiveItem()
		if active_item or IsRiding then
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。
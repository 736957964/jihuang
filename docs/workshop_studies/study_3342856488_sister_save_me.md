# 饥荒创意工坊研读报告：姐姐救救我(Sister, save me)

- **模组标识**：`3342856488`
- **作者**：Alice
- **版本**：1.21
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：2 个 Lua 文件 / 共 715 行；网络变量 0 处；RPC 0 处；注入钩子 2 处

## 一、代码结构与入口分布

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `world` | 1 |
| `AddPrefabPostInit` | `abigail` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("world")
```lua

AddPrefabPostInit("world", function(inst)
    if TheWorld.ismastersim and allplayer_enable and startinventory then
        inst:ListenForEvent("ms_playerspawn", function(inst, player)
            local CurrentOnNewSpawn = player.OnNewSpawn or function() return true end
            player.OnNewSpawn = function(...)
                if player.prefab ~= "wendy" then
                    player.components.inventory.ignoresound = true
                    player.components.inventory:GiveItem(SpawnPrefab("abigail_flower"))
                end
                return CurrentOnNewSpawn(...)
            end
```
### AddPrefabPostInit("abigail")
```lua

AddPrefabPostInit("abigail", function(inst)
	if not TheWorld.ismastersim then
		return
	end

    if inst.components.aura then
        inst.components.aura.radius = TUNING.ABIGAIL_AURA_RADIUS
    end

    -- crazy标签，让阿比盖尔能够攻击影怪
    if GetModConfigData("ABIGAIL_SHADOWATK") then
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。
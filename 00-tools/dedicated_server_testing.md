# 饥荒专用服务器（Dedicated Server）离线测试指南

## 概述

在开发饥荒（DST）MOD 时，专用服务器（Dedicated Server / NullRenderer）是验证服务端逻辑、排查崩溃（Crash/LUA ERROR）、网络同步及伤害结算的最佳工具。

专服的无头版本（`dontstarve_dedicated_server_nullrenderer_x64.exe`）去除了图形渲染损耗，能高速启动并输出完整的 Lua 堆栈日志。

---

## 一、服务器环境与目录要求

专服程序通常位于游戏安装根目录下的 `bin64` 或 `bin` 文件夹：
- **可执行文件路径**：`bin64/dontstarve_dedicated_server_nullrenderer_x64.exe`
- **工作目录强制要求**：**启动进程时，工作目录（Working Directory）必须设置为 `bin64`**。  
  *原因：引擎底层需要根据相对路径加载 `../data/databundles/scripts.zip` 等游戏核心资源包，若在其他路径启动会报 `DoLuaFile Could not load lua file scripts/main.lua`。*

---

## 二、离线免 Token 启动命令行

在本地测试场景下，通常无需联网注册 Klei 服务器令牌。若直接启动会触发 `E_INVALID_TOKEN` 报错并中断。

通过加入 `-lan -offline` 参数，可强制开启纯净局域网离线测试模式：

```powershell
& "路径\bin64\dontstarve_dedicated_server_nullrenderer_x64.exe" -lan -offline
```

---

## 三、挂载与启用本地开发中的 MOD

专用服务器不会默认开启目录下的所有本地 MOD，必须通过存档集群配置显式启用。

### 1. 放置 MOD
将开发的 MOD 文件夹放置（或创建软链接）在游戏根目录的 `mods/` 下，例如：
`Don't Starve Together/mods/my_weapon_mod`

### 2. 配置 modoverrides.lua
在存档世界的 Master 目录中（通常为 `Documents/Klei/DoNotStarveTogether/Cluster_1/Master/`），编辑或创建 `modoverrides.lua`：

```lua
return {
    ["my_weapon_mod"] = {
        enabled = true,
    },
}
```

服务器启动时，日志将显示：
```log
modoverrides.lua enabling my_weapon_mod
Loading mod: my_weapon_mod (...)
```

---

## 四、自动化测试桩编写与清理规范（重要）

为了让服务器自动验证伤害或功能，可以在开发阶段临时注入一个自动化测试桩（Test Runner）。

### 1. 测试桩范例（临时注入）
```lua
AddPrefabPostInit("world", function(w)
    if not GLOBAL.TheWorld.ismastersim then return end

    w:DoTaskInTime(3, function()
        print("[TEST_RUNNER] >>> 开始测试 <<<")
        local weapon = GLOBAL.SpawnPrefab("my_weapon_mod")
        local target = GLOBAL.SpawnPrefab("pigman")
        local attacker = GLOBAL.SpawnPrefab("pigman")

        attacker.components.inventory:GiveItem(weapon)
        attacker.components.inventory:Equip(weapon)

        local hp_before = target.components.health.currenthealth
        attacker.components.combat:DoAttack(target, weapon)
        local hp_after = target.components.health.currenthealth

        print(string.format("[TEST_RUNNER] 实测伤害: %d", hp_before - hp_after))

        -- 销毁测试产生的实体
        if target:IsValid() then target:Remove() end
        if attacker:IsValid() then attacker:Remove() end
    end)
end)
```

### 2. 测试后清理规范（红线要求）
- 测试代码只在验证阶段使用；
- **一旦在 `server_log.txt` 中捕获到验证成功的日志，必须立即将测试代码完整移除**；
- 严禁将 `DoTaskInTime` 实体生成、自动化攻击或测试 print 残留在最终交付的 MOD 业务源码中。

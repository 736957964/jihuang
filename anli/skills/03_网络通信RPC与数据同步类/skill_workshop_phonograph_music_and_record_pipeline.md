# 饥荒工业级最佳实践范式：留声机随身播放与多音轨唱片扩展架构

> 权威基准整合：Mod 2988233681 (`Phonograph Tweaked`)、Mod 3379258656 (`明日方舟唱片`)、Mod 3586130971 (`kramel华语经典唱片`)、Mod 3716634921 (`HOWLS唱片`)
> 技术分类：03_网络通信RPC与数据同步类 | 领域涵盖：音频流挂载、随身背包播放劫持、跨端音效网络广播

本母本系统性提炼了饥荒联机版中**留声机（Phonograph）机制改造与自定义唱片资产注入**的工业级标准切面。

---

## 一、核心底层痛点与网络拓扑

官方原生留声机存在以下三大架构限制：
1. **播放时长锁死**：官方原版硬编码了 64 秒后强制调用 `TurnOffMachine` 关闭机器；
2. **场景空间绑定**：一旦拿起放入玩家物品栏（`inventoryitem`），声音直接中断或残留在原地；
3. **客机音画脱节**：多玩家联机时，若未通过 `TheWorld.ismastersim` 服务端调度与 `SoundEmitter` 挂载，其他玩家无法同步听到背景音乐。

---

## 二、标准工业级生产代码范式（开箱即用）

```lua
local GLOBAL = GLOBAL
local TheWorld = GLOBAL.TheWorld

-- 1. 随身携带留声机与音轨挂载切面
AddPrefabPostInit("phonograph", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    -- 解除官方原版 64 秒强制切断机制
    inst.TurnOffMachine = function() end 

    if inst.components.inventoryitem then
        local Oldonputininventoryfn = inst.components.inventoryitem.onputininventoryfn
        inst.components.inventoryitem.onputininventoryfn = function(inst, owner, ...)
            local song = inst:GetRecordSong and inst:GetRecordSong() or nil
            if song and inst.components.machine and inst.components.machine:IsOn() and owner and owner.SoundEmitter then
                -- 将音轨无缝挂载至玩家身上（实现随身移动音箱）
                owner._custom_phonograph = inst
                owner.SoundEmitter:PlaySound(song, "custom_ragtime")
                
                -- 监听丢弃与背包移除事件，自动清理音轨
                owner:ListenForEvent("itemlose", function(src, data)
                    if data and data.prev_item == inst and owner.SoundEmitter then
                        owner.SoundEmitter:KillSound("custom_ragtime")
                    end
                end)
            end
            if Oldonputininventoryfn then
                return Oldonputininventoryfn(inst, owner, ...)
            end
        end

        local Oldondropfn = inst.components.inventoryitem.ondropfn
        inst.components.inventoryitem.ondropfn = function(inst, ...)
            -- 掉落地面时，恢复由留声机实体自身发声
            if inst.components.machine and inst.components.machine:IsOn() and inst.SoundEmitter then
                local song = inst:GetRecordSong and inst:GetRecordSong() or nil
                if song then
                    inst.SoundEmitter:PlaySound(song, "ragtime")
                end
            end
            if Oldondropfn then
                return Oldondropfn(inst, ...)
            end
        end
    end
end)

-- 2. 批量注册与注入自定义唱片 Prefab
local function RegisterCustomRecord(record_name, song_path)
    AddPrefabPostInit("record_" .. record_name, function(inst)
        if not TheWorld.ismastersim then return end
        if inst.components.record then
            inst.components.record:SetSong(song_path)
        end
    end)
end
```

---

## 三、四大变体演进与实战扩展

1. **变体 A（明日方舟 / 经典唱片扩展）**：通过批量构造 `record_*` 预制体，重载 `inst.components.record.song`，支持数十张独立音轨切换；
2. **变体 B（随身背包免手持播放）**：在 `equipslots` 或 `container` 打开时直接嗅探背包内激活的留声机；
3. **变体 C（跨端音效衰减与距离衰减网络表）**：利用 `inst.SoundEmitter:SetParameter("ragtime", "distance", dist)` 动态计算全服听觉衰减半径。

---

## 四、避坑指南与防御性规范
1. **SoundEmitter 幽灵播放防御**：玩家实体死亡、断线或被传送时，必须在 `onremove` 与 `player_despawn` 事件中显式 `KillSound`，防止死后依然循环播放；
2. **双端同步隔离**：音轨的播放逻辑必须严格在服务端判定后，由底层音频系统自动网络同步，切忌在客机执行全屏发声导致爆音。

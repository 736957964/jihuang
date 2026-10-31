# 饥荒创意工坊研读报告：植物大战饥荒 Plants vs. DST

- **模组标识**：`3513671528`
- **作者**：Loong
- **版本**：未声明
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：188 个 Lua 文件 / 共 38971 行；网络变量 20 处；RPC 0 处；注入钩子 28 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/actions_pvz1.lua`
- `scripts/behaviours/doingnothingpvz1.lua`
- `scripts/behaviours/keepattackwallpvz1.lua`
- `scripts/brains/davepvz1brain.lua`
- `scripts/brains/peashooterpvz1brain.lua`
- `scripts/brains/puffshroompvz1brain.lua`
- `scripts/brains/yetipvz1brain.lua`
- `scripts/brains/zombiepvz1brain.lua`
- `scripts/components/animfreezerpvz1.lua`
- `scripts/components/animjumperpvz1.lua`
- `scripts/components/animvtopslicepvz1.lua`
- `scripts/components/clientattackedeventpvz1.lua`
- `scripts/components/dashfloaterpvz1.lua`
- `scripts/components/dave_talker_pvz1.lua`
- `scripts/components/davemanagerpvz1.lua`
- `scripts/components/davestorestockpvz1.lua`
- `scripts/components/daysleeperpvz1.lua`
- `scripts/components/dyingpvz1.lua`
- `scripts/components/explosivepvz1.lua`
- `scripts/components/fertilizableplantpvz1.lua`
- `scripts/components/flasherpvz1.lua`
- `scripts/components/floatingfetchablepvz1.lua`
- `scripts/components/fogmanagerpvz1.lua`
- `scripts/components/fogwatcherpvz1.lua`
- `scripts/components/gravebusterpvz1.lua`
- `scripts/components/gravebusterstarterpvz1.lua`
- `scripts/components/hammerpvz1.lua`
- `scripts/components/highprioritypickablepvz1.lua`
- `scripts/components/indicatorpvz1.lua`
- `scripts/components/lawnmowerpvz1.lua`
- `scripts/components/lawnmoweruserpvz1.lua`
- `scripts/components/neighborpvz1.lua`
- `scripts/components/notepvz1.lua`
- `scripts/components/plantupgraderpvz1.lua`
- `scripts/components/pointproviderpvz1.lua`
- `scripts/components/potplantablepvz1.lua`
- `scripts/components/potpvz1.lua`
- `scripts/components/repairerpvz1.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `world` | 4 |
| `AddComponentPostInit` | `playercontroller` | 4 |
| `AddComponentPostInit` | `combat` | 3 |
| `AddStategraphPostInit` | `wilson` | 2 |
| `AddComponentPostInit` | `playeractionpicker` | 2 |
| `AddPrefabPostInit` | `poop` | 1 |
| `AddPrefabPostInit` | `guano` | 1 |
| `AddPrefabPostInit` | `ghost` | 1 |
| `AddPrefabPostInit` | `inventory_classified` | 1 |
| `AddPrefabPostInit` | `container_classified` | 1 |
| `AddPrefabPostInit` | `pond` | 1 |
| `AddComponentPostInit` | `eater` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("world")
```lua
-- Using "world" prefab for all possible worlds
AddPrefabPostInit("world", function (inst)
    if not TheWorld.ismastersim then return inst end
    if TheWorld:HasTag("cave") then return inst end
    if TheWorld:HasTag("worldnosun_pvz1") then return inst end

    inst:AddComponent("sunspawnerpvz1")
end)

-- function Launch2(inst, launcher, basespeed, speedmult, startheight, startradius, vertical_speed, force_angle)
local function daylight_postinit(height)
    local function dropsun(inst)
```
### AddComponentPostInit("playercontroller")
```lua
-- #region Hammer
AddComponentPostInit("playercontroller", function (PlayerController)
    local _OnLeftClick = PlayerController.OnLeftClick
    function PlayerController:OnLeftClick(down, ...)
        if self:UsingMouse() and down then
            local active_item = self.inst.replica.inventory:GetActiveItem()
            if active_item
            and ((active_item.prefab == "hammer_pvz1") or (active_item.nameoverride == "hammer_pvz1")) then
                TheFrontEnd:GetSound():PlaySound("pvz1/hud/swing")
            end

            if self.inst.HUD ~= nil and self.inst.HUD.controls and self.inst.HUD.controls.inv
```
### AddComponentPostInit("combat")
```lua
-- #region Custom impact sound
AddComponentPostInit("combat", function (Combat)
    local function WearingValidArmor(inv, attacker, weapon)
        for k, v in pairs(inv.equipslots) do
            if v.components.armor ~= nil and v.components.armor:CanResist(attacker, weapon) then
                return true
            end
        end
        return false
    end
    local _GetImpactSound = Combat.GetImpactSound
    -- victim == self.inst
```
### AddStategraphPostInit("wilson")
```lua
end)
AddStategraphPostInit("wilson", function (self)
    local catchfish = self.states["catchfish"]
    if catchfish then
        local _onenter = catchfish.onenter
        catchfish.onenter = function (inst, build, ...)
            if _onenter ~= nil then
                _onenter(inst, build, ...)
            end
            if build == "zengardenglove_pvz1" then
                -- inst.AnimState:OverrideSymbol("fish01", "zengardenitems_pvz1", "glove")
                local fx = SpawnPrefab("zengardenglovefx_pvz1")
```
### AddComponentPostInit("playeractionpicker")
```lua

AddComponentPostInit("playeractionpicker", function (PlayerActionPicker)
    function PlayerActionPicker:GetLawnMowerPvz1AimActions(inst, pos, right)
        local lawnmoweruserpvz1 = self.inst.components.lawnmoweruserpvz1
        if lawnmoweruserpvz1 ~= nil and lawnmoweruserpvz1:GetTarget() ~= nil then
            if right then
                return self:SortActionList({ ACTIONS.LAWNMOWER_STOP_AIMING_PVZ1 }, pos)
            else
                if inst == ThePlayer then
                    pos = lawnmoweruserpvz1:GetAimPos()
                    if pos == nil then
                        return nil
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 20 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。
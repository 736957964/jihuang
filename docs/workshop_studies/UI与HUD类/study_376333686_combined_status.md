# 饥荒创意工坊深度研读报告：Combined Status（五维综合状态显示）

- **模组标识**：`376333686` (`Combined Status / 综合状态显示`)
- **作者**：rezecib, Kiopho, Soilworker, hotmatrixx, penguin0616
- **版本**：v1.9.8
- **领域分类**：多版本同构（DS/ROG/SW/HAM/DST）兼容、HUD 状态数字数据驱动切面、网络脏标记事件监听、淘气值/温度/月相时钟复合扩展
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含 1243 行 `modmain.lua` 及全部独立控件预制体）

---

## 一、架构全貌与顶层设计思想

`Combined Status` 是饥荒工坊历史上最不可或缺的现象级界面 MOD，也是多版本兼容（单机版与联机版共用一套代码）的代码典范。它以非侵入式方式，将原本只能通过环形颜色大致估计的“血量、饥饿、精神、湿度、温度、淘气值、季节剩余、月相”，全部无缝增强为精确的实时动态数值。

### 1. 深度跨平台同构环境嗅探
- **单机与联机版环境隔离**：
  ```lua
  local DST = GLOBAL.TheSim.GetGameID ~= nil and GLOBAL.TheSim:GetGameID() == "DST"
  local ROG = DST or CheckDlcEnabled("REIGN_OF_GIANTS")
  local CSW = CheckDlcEnabled("CAPY_DLC")
  local HML = CheckDlcEnabled("PORKLAND_DLC")
  ```
  通过动态嗅探游戏引擎运行时，一份源码同时完美支撑联机版与单机巨人国、海难、猪镇。

---

## 二、四大硬核核心技术解构

### 1. 事件驱动的高性能数值监听（Event-Driven Delta Binding）
很多劣质状态显示 Mod 会在 `OnUpdate` 中每帧读取角色状态（每秒 60 次）。`Combined Status` 坚决杜绝帧轮询，全部采用**事件驱动机制**：
- 监听 `healthdelta`、`hungerdelta`、`sanitydelta`、`temperaturedelta`、`naughtydelta`；
- 只有当底层数据发生改变时，才触发一次字符串格式化与 `self.num:SetString(...)`。这保证了哪怕同屏 20 个角色，UI 层依然几乎为零开销。

### 2. Badge 控件层级的非侵入式装配（Badge PostConstruct Pattern）
原版无论是血量球（`heart`）、饱食度（`stomach`）还是理智（`brain`），都继承自 `widgets/badge`。
- **MOD 解构**：
  在 `BadgePostConstruct` 中，动态注入 `self.num = self:AddChild(Text(NUMBERFONT, 28))` 与自定义背景底图 `status_bgs.tex`；
  通过劫持原版 `self.SetPercent`：
  ```lua
  local oldSetPercent = self.SetPercent
  self.SetPercent = function(self, val, max, penaltypercent)
      oldSetPercent(self, val, max, penaltypercent)
      -- 动态计算并更新数值字符串
      self:UpdateStatusText(val, max)
  end
  ```
  在完全不影响原版环形遮罩动画的前提下，平滑地叠加了数字渲染层。

### 3. 客机温度与网络化淘气值（Networked Naughtiness / Temperature）
在联机版非主机客户端上，原版 `player.components.temperature` 在客机是为 nil 的。
- **客机状态嗅探规范**：
  ```lua
  local val = DST and self.owner:GetTemperature() or self.owner.components.temperature.current
  ```
  优先调用联机版官方暴露在 Player 实体上的原生 getter（`GetTemperature()` 会自动从网络实体 `player_classified` 解码），防止在客机上因读取 components 发生 nil 崩溃。
- **跨 MOD 数据契约（Insight 兼容）**：
  对于联机版没有向客机同步的“淘气值（Kramped）”，MOD 与社区知名监测 MOD `Insight` 达成协议，通过监听 `self.inst:ListenForEvent("naughtydelta", ...)`，让服务端有 Insight 的情况下客机也能同步获得小偷即将出现的警报！

### 4. 浮动数字漂移与控制台自适应（Controller / Detailed Mode）
- 手柄模式下，玩家烘干后，湿度计可能残留一个孤立的 "1"。MOD 在 `ShowStatusNumbers` 中进行了严密的状态同步保护：
  ```lua
  if self.moisturemeter and not self.moisturemeter.active then
      self.moisturemeter.num:Hide()
  end
  ```
- 支持详细模式（Detailed Mode），在数值下方附带最大值与扣减惩罚指示，字号由 28 自动切为 20 并重算中心点偏移。

---

## 三、避坑实战经验

1. **DST 与单机版头像组件类型的差异**：
   - 在单机版中，玩家头像 `PlayerBadge.head` 是 `UIAnim`；但在 DST 联机版中，官方为了网络优化将其改为了静态 `Image`。如果盲目调用 `head:GetAnimState()` 会直接爆 `attempt to call method 'GetAnimState' (a nil value)`。必须像 MOD 源码一样做类型检测分流：在 DST 下将原 head 隐藏，并在 `icon` 上新建专属 `UIAnim`。
2. **多语言字体渲染与度数符号（ASCII 176）**：
   - 摄氏度符号不要直接在代码里写硬字符 `°`（因为 Windows 与 Linux 的 UTF-8 BOM 容易乱码），标准写法是使用八进制转义 `\176C`，保证跨平台字体库渲染不出错。

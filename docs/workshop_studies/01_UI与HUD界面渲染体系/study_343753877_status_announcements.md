# 饥荒创意工坊深度研读报告：Status Announcements（状态通告与 HUD 交互事件拦截机制）

- **模组标识**：`343753877` (`Status Announcements / 状态通告`)
- **作者**：rezecib
- **版本**：v3.x
- **领域分类**：HUD 组件交互拦截（`PlayerHud` 与 `SlotClass`）、聊天栏广播控制（`ChatHistory` 与 `Talker`）、多语言动态匹配（`KnownModIndex`）、控制器按键映射重定义
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含完整解压后的 `modmain.lua` 与 `statusannouncer.lua`）

---

## 一、架构全貌与顶层设计思想

在饥荒联机版中，纯键盘或手柄玩家在向队友通告自己的饥饿值（Hunger）、SAN值（Sanity）、生命值（Health）、物品耐久、制作配方进度时，常常需要繁琐地打开聊天框输入文字。

`Status Announcements` 是工坊传奇大牛 `rezecib` 打造的、与 `Combined Status` 和 `Geometric Placement` 齐名的顶流 QoL 神作：
1. **HUD 鼠标与键盘组合键劫持（`PlayerHud:OnMouseButton` & `SlotClass:OnControl`）**：允许玩家按住 `Ctrl / Inspect` 键并点击饥饿/脑残/生命状态面板，或者点击背包中的物品、合成栏中的配方，瞬间将其转化为结构化的聊天广播（如“我的胃空空如也：20/150！”）；
2. **聊天历史与头顶气泡清洗（`ChatHistory` & `Talker` Hook）**：通过对底层聊天记录和说话组件的切面拦截，可选择性隐藏冗余的系统广播，确保通告机制既高效又不会刷屏。

---

## 二、四大硬核核心技术解构

### 1. 状态栏与物品栏输入拦截（HUD Input Interception）
- 模组通过对 `PlayerHud`、`inventorybar`、`invslot`、`equipslot` 及 `craftingmenu_hud` 的全方位类后置构造（`AddClassPostConstruct`）注入点击监听：
  ```lua
  local SlotClass = require("widgets/invslot")
  local SlotClass_OnControl = SlotClass.OnControl
  function SlotClass:OnControl(control, down, ...)
      if down and control == GLOBAL.CONTROL_ACCEPT
          and TheInput:IsControlPressed(GLOBAL.CONTROL_FORCE_INSPECT)
          and TheInput:IsControlPressed(GLOBAL.CONTROL_FORCE_TRADE)
          and self.tile then -- 点击非空格子
          return StatusAnnouncer:AnnounceItem(self)
      else
          return SlotClass_OnControl(self, control, down, ...)
      end
  end
  ```
  精准捕获玩家的操作意图，阻断原生事件的默认向下传递，转而触发通告管理器（`StatusAnnouncer`）。

### 2. 动态语言与主流模组兼容侦测（Mod & Language Autofetv）
- 启动时自动扫描环境中的其他主流模组（如 `Combined Status`、`Whisper Only` 等）：
  ```lua
  for k,v in pairs(GLOBAL.KnownModIndex:GetModsToLoad()) do
      local mod_type = CHECK_MODS[v]
      if mod_type then HAS_MOD[mod_type] = v end
  end
  ```
  根据当前语言配置或自动检测结果动态加载对应的本地化翻译表（`announcestrings/*.lua`），并与全局 `STRINGS._STATUS_ANNOUNCEMENTS` 实行深度递归合并（Deep Merge）。

### 3. 聊天与气泡静默过滤（ChatHistory & Talker Patch）
- 当用户开启 `HIDEANNOUNCEMENTS` 配置时，模组会拦截底层聊天历史和头顶文字气泡：
  ```lua
  local function IsStatusAnnouncementMessage(message)
      type(message) == "string" and message:len() > 3 and message:sub(1,3) == GLOBAL.STRINGS.LMB
  end
  -- 拦截 ChatHistory:AddToHistory 与 Talker:Say
  ```
  确保通告消息在特定模式下只传达给队友或按需静默。

---

## 三、避坑实战经验

1. **组合键冲突防范**：
   - 在拦截 `OnControl` 时，必须结合 `TheInput:IsControlPressed(GLOBAL.CONTROL_FORCE_INSPECT)` 等修饰键进行严格判断，否则会破坏玩家正常拾取或移动物品的操作手感。
2. **多人联机 RPC 广播同步**：
   - 通告本质上是客户端组装好本地化文本后通过 `Networking_Say` 或类似聊天通道发送给服务器广播。在编写类似功能时，应注意控制发送频率（Rate Limiting），防止恶意玩家连续高频刷屏造成服务器网络封包阻塞。

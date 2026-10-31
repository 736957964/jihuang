# 饥荒创意工坊深度研读报告：Food Values - Item Tooltips（悬浮物品食物属性与网络动态回传架构）

- **模组标识**：`458940297` (`Food Values - Item Tooltips / 食物属性与物品提示增强`)
- **作者**：gregdwilson
- **版本**：v2.5
- **领域分类**：双端混合架构（Server and Client）、`widgets/itemtile` 悬浮提示切面、按需 ModRPC 查询与脏标记事件反向推送、多国语言本地化注入
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含完整解压后的 `modmain.lua`、`itemvalues` 组件与字体资源）

---

## 一、架构全貌与顶层设计思想

在饥荒联机版中，当鼠标悬停在物品栏槽位上的物品图标（`ItemTile`）时，原版默认只显示预制体名称。若要向玩家展示“食用回复三维数值、距离腐烂剩余天数、燃料剩余时长、护甲剩余吸收量”，面临着**客户端缺少服务端权威数据组件**的困境。

`Food Values - Item Tooltips` 创造了一套经典的**按需按键触发与事件回推式网络架构（On-Demand ModRPC Query & Event-Driven Pushback）**：
1. **客户端悬浮监听**：在 `ItemTile:UpdateTooltip()` 中捕获鼠标聚焦与按键状态（Ctrl / Alt）；
2. **轻量请求下发**：通过自定义 ModRPC 向服务端发起查询；
3. **服务端序列化计算并触发网络脏标记**：服务端读取目标实体的真实 `components.edible` / `perishable` / `armor`，格式化后写入玩家伴随的 `itemvalues.string_dirty` NetVar；
4. **客户端事件监听回填**：客户端监听到 `item_value_updated` 事件，重新调用 `SetTooltip` 渲染富文本。

---

## 二、四大硬核核心技术解构

### 1. 按需 ModRPC 与网络脏标记回推通道（On-Demand RPC Pipeline）
- **痛点**：如果服务端无差别广播全图所有物品的三维属性，会导致带宽剧烈消耗。
- **神级设计**：
  - 只有当玩家真正把鼠标悬浮（`focus`）在某个物品图标上时，客户端才发送一次 RPC：
    ```lua
    SendModRPCToServer(MOD_RPC["FoodValues - ItemTooltips"]["FIU"], self.item, keydown, ctrlkeydown, ...)
    ```
  - 服务端处理完后，推送网络事件回流：
    ```lua
    player:ListenForEvent("item_value_updated", function()
        local str = self:GetDescriptionString()
        self:SetTooltip(str)
        -- 针对浸湿物品同步切换潮湿字体颜色
        if self.item:GetIsWet() then
            self:SetTooltipColour(GLOBAL.unpack(GLOBAL.WET_TEXT_COLOUR))
        else
            self:SetTooltipColour(GLOBAL.unpack(GLOBAL.NORMAL_TEXT_COLOUR))
        end
    end)
    ```
  实现了极低网络开销下的高精度属性查询。

### 2. `widgets/itemtile` 原语安全注入与百分比标签改写
- 原版 `ItemTile:SetPercent` 用于显示耐久或新鲜度百分比。
- MOD 拦截并重新定义了 `SetPercent`：
  ```lua
  function ItemTile:SetPercent(percent)
      if not self.percent then
          self.percent = self:AddChild(Text(GLOBAL.NUMBERFONT, 42))
          self.percent:SetPosition(5, -17, 0)
      end
      local val = math.floor(percent * 100)
      self.percent:SetString(string.format("%2.0f%%", val))
      -- 当处于聚焦状态时，联动刷新提示框
      if self.focus then
          self:UpdateTooltip()
      end
  end
  ```
  保证了当箱子内物品新鲜度因时间流逝发生改变时，浮动提示框能够毫秒级实时刷新，不会残留过期数据。

### 3. 多语言本地化字串字典（DFV_LANG Engine）
- 在 `GLOBAL.STRINGS` 中开辟专属前缀 `DFV_*`；
- 内置英语（EN）、法语（FR）、德语（GR）、意大利语（IT）、西班牙语（SP）、俄语（RU）等多国语言的精确烹饪与保质期名词对照表；
- 结合极简模式（`DFV_MinimalMode`），支持紧凑符号化展示（如 `+12.5H / +5S / +30F`）或全文本长句描述，满足不同玩家群体的个性化诉求。

### 4. 潮湿状态感知与颜色对齐（Wetness Palette Guard）
- 原版饥荒如果物品被雨水淋湿，文字会变成浅蓝色（`WET_TEXT_COLOUR`）。
- MOD 在重写提示框时，调用 `self.item:GetIsWet()` 显式解包官方调色板：
  ```lua
  self:SetTooltipColour(GLOBAL.unpack(self.item:GetIsWet() and GLOBAL.WET_TEXT_COLOUR or GLOBAL.NORMAL_TEXT_COLOUR))
  ```
  在微小细节处保证了与官方原生手感的高度一致，杜绝了突兀感。

---

## 三、避坑实战经验

1. **`player:ListenForEvent` 闭包累积导致的内存泄漏陷阱**：
   - 在 `ItemTile:UpdateTooltip()` 中如果每次悬停都调用一次 `player:ListenForEvent`，随着鼠标不断划过几十个物品，会在 `ThePlayer` 上绑定成百上千个重复监听器！
   - **最佳工业准则**：监听器必须在 `ItemTile` 初始化时只注册一次，或者通过临时标志位 `self._has_listener` 予以守卫，避免高频移动鼠标导致客户端内存暴涨。
2. **`self.item` 在网络延迟下的销毁容错**：
   - 当客户端发送查询 RPC 后，物品可能在半途被队友捡走或吃掉（`self.item:IsValid() == false`）。在服务端响应回调执行 `self:GetDescriptionString()` 时，必须加入 `if self.item and self.item:IsValid()` 校验，防止解包野指针崩溃。

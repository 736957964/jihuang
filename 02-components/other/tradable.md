# Tradable 可交易组件

> 源码: `scripts/components/tradable.lua`

## 概述

Tradable 定义物品的交易价值，用于猪王交易、寄居蟹交易等系统。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `goldvalue` | number | `0` | 黄金价值（猪王交易用） |
| `tradefor` | table/nil | `nil` | 交易获得物品数组 |
| `rocktribute` | table/nil | `nil` | 岩石贡品配置 |
| `onexchange` | function/nil | `nil` | 交易完成回调 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetGoldValue(value)` | — | 设置黄金价值 |
| `SetTradeFor(items)` | — | 设置交易获得物品 |
| `SetOnExchange(fn)` | — | 设置交易回调 |
| `IsTradable()` | boolean | 是否可交易 |
| `OnSave()` | table | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |

## 使用示例

### 基础交易物

```lua
inst:AddComponent("tradable")
inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT  -- 一块大肉 = 1金币
```

### 自定义交易

```lua
inst:AddComponent("tradable")
inst.components.tradable:SetTradeFor({
    {prefab = "goldnugget", amount = 3},
    {prefab = "flint", amount = 2},
})
-- 交易获得3个金块+2个燧石
```

### 交易回调

```lua
inst.components.tradable:SetOnExchange(function(inst, giver)
    giver.components.sanity:DoDelta(10)  -- 交易后回复10理智
end)
```

### 岩石贡品（寄居蟹）

```lua
inst.components.tradable.rocktribute = {
    rocktype = "moonrocknugget",
    rockcount = 5,
}
```

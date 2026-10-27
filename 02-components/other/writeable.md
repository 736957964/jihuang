# Writeable 可书写组件

> 源码: `scripts/components/writeable.lua`

## 概述

Writeable 允许实体被书写（如告示牌、日记等），玩家可输入自定义文字。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `text` | string | `""` | 当前书写内容 |
| `maxcharacters` | number | `128` | 最大字符数 |
| `allownewline` | boolean | `true` | 是否允许换行 |
| `onsavefn` | function/nil | `nil` | 保存回调 |
| `onwrotefn` | function/nil | `nil` | 书写完成回调 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetText(text)` | — | 设置文本 |
| `GetText()` | string | 获取文本 |
| `SetMaxCharacters(n)` | — | 设置最大字符数 |
| `SetAllowNewline(allow)` | — | 设置是否允许换行 |
| `SetOnWrote(fn)` | — | 设置书写回调 |
| `OnSave()` | table | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |

## 使用示例

### 告示牌

```lua
inst:AddComponent("writeable")
inst.components.writeable.maxcharacters = 200
inst.components.writeable:SetOnWrote(function(inst, doer, text)
    print(doer:GetDisplayName() .. " 写下了: " .. text)
end)
```

### 限制格式

```lua
inst:AddComponent("writeable")
inst.components.writeable.allownewline = false  -- 不允许换行
inst.components.writeable.maxcharacters = 20    -- 最多20字
```

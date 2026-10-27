# Named 命名组件

> 源码: `scripts/components/named.lua`

## 概述

Named 为实体提供自定义名称功能。玩家可给宠物、容器等命名，名称会显示在游戏界面中。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `name` | string | `""` | 当前名称 |
| `possiblenames` | table | `{}` | 可选名称池 |
| `nameformat` | string/nil | `nil` | 名称格式化模板（用于 `string.format`） |
| `name_author_netid` | number/nil | `nil` | 命名者的网络ID |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `PickNewName()` | — | 从 `possiblenames` 中随机选名 |
| `SetName(name, author)` | — | 设置名称（nil 恢复默认） |
| `GetName()` | string | 获取当前名称 |
| `OnSave()` | table | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |

## 使用示例

### 随机名称池

```lua
inst:AddComponent("named")
inst.components.named.possiblenames = {
    STRINGS.NAMES.PIG_NAMES[1],
    STRINGS.NAMES.PIG_NAMES[2],
    STRINGS.NAMES.PIG_NAMES[3],
}
inst.components.named:PickNewName()  -- 随机选一个名字
```

### 自定义名称

```lua
inst:AddComponent("named")
inst.components.named:SetName("小黄", userid)
```

### 带格式的名称

```lua
inst.components.named.nameformat = "%s的宠物"
inst.components.named:SetName("小明", userid)
-- 显示为 "小明的宠物"
```

### 恢复默认名称

```lua
inst.components.named:SetName(nil)  -- 传nil恢复默认
```

# 饥荒知识提炼 Skill：index
- 来源目录：02-components\burnable\index.md (核心Gameplay组件库 (combat, inventory, builder))
- 提炼时间：2026-10-30 00:00:03

## 一、核心概念与API规范
# 火/光相关组件

| 组件名 | 文件 | 说明 |
|--------|------|------|
| `burnable` | burnable.lua | 可燃属性（燃烧/熄灭/闷烧） |
| `fueled` | fueled.lua | 燃料系统（篝火） |
| `light` | light.lua | 光源属性 |
| `propagator` | propagator.lua | 火焰传播 |
| `heater` | heater.lua | 加热器属性 |
| `cooker` | cooker.lua | 烹饪设备（也属于 edible 分类） |
| `lighter` | lighter.lua | 打火机 |

## 详细文档

- [Burnable 可燃](/02-components/burnable/burnable)


## 二、生产级代码模版
```lua
-- 针对 index 的标准扩展范式
AddPrefabPostInit("player", function(inst)
    if not TheWorld.ismastersim then return end
    -- 结合 index 进行安全切面扩展
end)
```

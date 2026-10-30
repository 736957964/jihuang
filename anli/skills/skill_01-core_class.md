# 饥荒知识提炼 Skill：class
- 来源目录：01-core\class.md (核心引擎与Entity/Class底层)
- 提炼时间：2026-10-29 22:09:18

## 一、核心概念与API规范
# Class 类系统

> 源码文件：`scripts/class.lua`

DST 的类系统是自定义实现的面向对象系统，支持继承、实例检查、属性监听等。

## Class 定义

### Class(base, _ctor, props)
```lua
-- 无继承
MyClass = Class(function(self, name)
    self.name = name
end)

-- 继承
MySubClass = Class(MyClass, function(self, name, age)
    MyClass._ctor(self, name)  -- 调用父类构造
    self.age = age
end)

-- 带属性监听
MyObservedClass = Class(function(self)
    self.x = 0
end, {
    x = function(t, v, old)  -- x 属性变化时的回调
        print("x changed:", old, "->", v)
    end
})
```

*

## 二、生产级代码模版
```lua
-- 针对 class 的标准扩展范式
AddPrefabPostInit("player", function(inst)
    if not TheWorld.ismastersim then return end
    -- 结合 class 进行安全切面扩展
end)
```

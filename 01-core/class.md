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

**参数说明**：
- `base`：父类（table 类型），可省略
- `_ctor`：构造函数，可省略（如果 base 是 function，则 base 被当作 _ctor）
- `props`：属性监听表，key 为属性名，value 为变化回调函数

## 实例化

```lua
local obj = MyClass("hello")
-- 调用等价于 MyClass._ctor(obj, "hello")
```

## 类型检查

### obj:is_a(klass) → boolean
判断对象是否是某个类的实例（含继承链）。
```lua
if obj:is_a(MyClass) then
    print("obj is a MyClass")
end
```

### klass.is_instance(obj) → boolean
类的静态方法，判断对象是否是该类的实例。
```lua
if MyClass.is_instance(obj) then
    print("obj is instance of MyClass")
end
```

### klass:is_class() → boolean
判断自身是否是一个类（而非实例）。

## 属性监听系统

当 `props` 参数传入时，类实例会使用 `__index` 和 `__newindex` 元方法拦截属性访问：

```lua
MyComponent = Class(function(self)
    self._hp = 100
end, {
    _hp = function(t, new_val, old_val)
        print("HP changed:", old_val, "->", new_val)
    end
})
```

**注意**：带 props 的类，属性实际存储在 `obj._[key] = { value, callback }` 中。

### makereadonly(t, k)
将属性设为只读。
```lua
local obj = MyObservedClass()
makereadonly(obj, "x")
obj.x = 10  -- 会报错：Cannot change read only property
```

### addsetter(t, k, fn)
为属性添加/替换 setter 回调。
```lua
addsetter(obj, "x", function(t, v, old)
    if v < 0 then v = 0 end  -- 防止负值
end)
```

### removesetter(t, k)
移除属性的 setter 回调，恢复为普通属性。

## 继承

子类会**浅拷贝**父类的所有成员：

```lua
BaseClass = Class(function(self)
    self.value = 0
end)

function BaseClass:Method()
    return self.value
end

SubClass = Class(BaseClass, function(self)
    BaseClass._ctor(self)  -- 必须手动调用父类构造
    self.extra = true
end)
```

**注意**：子类必须手动调用 `ParentClass._ctor(self, ...)` 来初始化父类成员。

## ClassRegistry

所有创建的类都注册在 `ClassRegistry` 中：
```lua
ClassRegistry[class] = c_inherited  -- 继承的成员表
```

### ReloadedClass(mt)
热重载时清除注册信息。
```lua
ReloadedClass(MyClass)
```

## HandleClassInstanceTracking()
如果 `TrackClassInstances = true`，会定期输出实例追踪信息（调试用）。

## DST 中常见的类

| 类名 | 定义位置 | 说明 |
|------|----------|------|
| `EntityScript` | entityscript.lua | 所有实体的基类 |
| `Prefab` | prefabs.lua | 预制体定义 |
| `Asset` | prefabs.lua | 资源定义 |
| `Action` | actions.lua | 动作定义 |
| `StateGraph` | stategraph.lua | 状态机定义 |
| `Brain` | brains/ | 大脑/AI定义 |
| `Widget` | widgets/widget.lua | UI 组件 |
| `Screen` | screens/screen.lua | UI 屏幕 |
| 所有 `Component` | components/*.lua | 组件类 |

# 16 - Constants 常量与枚举

> **源码位置**: `scripts/constants.lua` — 全局常量与枚举定义  
> **关联文件**: `scripts/tuning.lua` — 调参常量（见 09-tuning）

## 1. 文件概述

`constants.lua` 定义了 DST 中使用的所有全局常量和枚举，包括：

- 数学常量
- 渲染层
- 控件 ID
- 键盘/鼠标按键码
- 碰撞组
- 颜色常量
- 材质常量
- 节点类型
- 路径查找常量
- 事件类型

---

## 2. 数学常量

```lua
PI = math.pi                    -- 3.14159...
PI2 = PI * 2                    -- 6.28318... (TWOPI)
TWOPI = PI2
HALFPI = PI / 2                 -- 1.57079...
QUARTERPI = PI / 4              -- 0.78539...
EIGHTHPI = PI / 8               -- 0.39269...
SQRT2 = math.sqrt(2)            -- 1.41421...
GOLDENANGLE = PI * (3 - math.sqrt(5))  -- 黄金角度
DEGREES = PI / 180              -- 角度转弧度系数
RADIANS = 180 / PI              -- 弧度转角度系数
FRAMES = 1 / 30                 -- 每帧时间 (30 FPS)
TILE_SCALE = 4                  -- 地皮尺寸倍数
HALF_TILE_SCALE = TILE_SCALE / 2
MAXUINT = 4294967295            -- 最大无符号整数
```

---

## 3. 分辨率与相机

```lua
RESOLUTION_X = 1280             -- 基准分辨率 X
RESOLUTION_Y = 720              -- 基准分辨率 Y

PLAYER_REVEAL_RADIUS = 30.0     -- 玩家可见半径
PLAYER_CAMERA_SEE_DISTANCE = 40.0 -- 相机最大可见距离
PLAYER_CAMERA_SHOULD_SNAP_DISTANCE = 20.0 -- 相机应瞬移距离
PLAYER_CAMERA_MAX_DIST = 80     -- 相机最大距离

ENTITY_POPIN_RADIUS = 64.0      -- 实体出现半径
ENTITY_POPOUT_RADIUS = 76.8     -- 实体消失半径 (×1.2)
```

---

## 4. 朝向常量

```lua
FACING_RIGHT = 0
FACING_UP = 1
FACING_LEFT = 2
FACING_DOWN = 3
FACING_UPRIGHT = 4
FACING_UPLEFT = 5
FACING_DOWNRIGHT = 6
FACING_DOWNLEFT = 7
FACING_NONE = 8
```

---

## 5. 渲染层

```lua
-- 渲染层级（从前到后）
LAYER_BACKDROP = 0              -- 背景幕
LAYER_BELOW_OCEAN = 1           -- 海洋之下
LAYER_BELOW_GROUND = 2          -- 地面之下
LAYER_GROUND = 3                -- 地面
LAYER_BACKGROUND = 4            -- 背景
LAYER_WORLD_BACKGROUND = 5      -- 世界背景
LAYER_WORLD = 6                 -- 世界层
-- 客户端专用 --
LAYER_WORLD_DEBUG = 7           -- 调试层
LAYER_FRONTEND = 8              -- 前端层
LAYER_FRONTEND_DEBUG = 9        -- 前端调试层
```

---

## 6. 排序与锚点

```lua
-- 排序偏移范围
FINALOFFSET_MIN = -7
FINALOFFSET_MAX = 7
SORTORDER_MIN = -3
SORTORDER_MAX = 3

-- 锚点
ANCHOR_MIDDLE = 0
ANCHOR_LEFT = 1
ANCHOR_RIGHT = 2
ANCHOR_TOP = 1
ANCHOR_BOTTOM = 2
```

---

## 7. 缩放模式

```lua
SCALEMODE_NONE = 0              -- 不缩放
SCALEMODE_FILLSCREEN = 1        -- 拉伸填充屏幕
SCALEMODE_PROPORTIONAL = 2      -- 保持宽高比（取较小的缩放比例）
SCALEMODE_FIXEDPROPORTIONAL = 3 -- 固定等比缩放
SCALEMODE_FIXEDSCREEN_NONDYNAMIC = 4 -- 固定屏幕非动态缩放
```

---

## 8. 物理类型

```lua
PHYSICS_TYPE_ANIMATION_CONTROLLED = 0  -- 动画驱动
PHYSICS_TYPE_PHYSICS_CONTROLLED = 1    -- 物理驱动
```

---

## 9. 移动方向

```lua
MOVE_UP = 1
MOVE_DOWN = 2
MOVE_LEFT = 3
MOVE_RIGHT = 4
```

---

## 10. 控件 ID (CONTROL_*)

### 10.1 玩家操作

```lua
CONTROL_PRIMARY = 0             -- 主操作（鼠标左键）
CONTROL_SECONDARY = 1           -- 副操作（鼠标右键）
CONTROL_ATTACK = 2              -- 攻击
CONTROL_INSPECT = 3             -- 检查
CONTROL_ACTION = 4              -- 动作
```

### 10.2 玩家移动

```lua
CONTROL_MOVE_UP = 5             -- 上移
CONTROL_MOVE_DOWN = 6           -- 下移
CONTROL_MOVE_LEFT = 7           -- 左移
CONTROL_MOVE_RIGHT = 8          -- 右移
```

### 10.3 视角控制

```lua
CONTROL_ZOOM_IN = 9             -- 放大
CONTROL_ZOOM_OUT = 10           -- 缩小
CONTROL_ROTATE_LEFT = 11        -- 左转
CONTROL_ROTATE_RIGHT = 12       -- 右转
```

### 10.4 菜单控制

```lua
CONTROL_PAUSE = 13              -- 暂停
CONTROL_MAP = 14                -- 地图
CONTROL_INV_1 ~ CONTROL_INV_15  -- 物品栏槽位 1-15 (15-24, 77-81)
CONTROL_ACCEPT = 29             -- 确认
CONTROL_CANCEL = 30             -- 取消
CONTROL_SPLITSTACK = 35         -- 拆分堆叠
CONTROL_OPEN_INVENTORY = 45     -- 打开背包
CONTROL_OPEN_CRAFTING = 46      -- 打开制造
```

### 10.5 其他控制

```lua
CONTROL_FORCE_INSPECT = 38      -- 强制检查
CONTROL_FORCE_ATTACK = 39       -- 强制攻击（Ctrl+攻击）
CONTROL_FORCE_TRADE = 40        -- 强制交易
CONTROL_FORCE_STACK = 41        -- 强制堆叠
CONTROL_OPEN_DEBUG_CONSOLE = 42 -- 调试控制台
CONTROL_TOGGLE_SAY = 63         -- 聊天
CONTROL_TOGGLE_WHISPER = 64     -- 密语
CONTROL_START_EMOJI = 82        -- 表情
CONTROL_OPEN_COMMAND_WHEEL = 87 -- 命令轮盘
CONTROL_TARGET_LOCK = 88        -- 锁定目标
CONTROL_TARGET_CYCLE = 89       -- 切换目标
```

---

## 11. 按键码 (KEY_*)

### 11.1 字母键

```lua
KEY_A = 97  ...  KEY_Z = 122
```

### 11.2 数字键

```lua
KEY_0 = 48  ...  KEY_9 = 57
KEY_KP_0 = 256  ...  KEY_KP_9 = 265  -- 小键盘
```

### 11.3 功能键

```lua
KEY_F1 = 282  ...  KEY_F12 = 293
```

### 11.4 方向键

```lua
KEY_UP = 273
KEY_DOWN = 274
KEY_RIGHT = 275
KEY_LEFT = 276
```

### 11.5 特殊键

```lua
KEY_TAB = 9
KEY_SPACE = 32
KEY_ENTER = 13
KEY_ESCAPE = 27
KEY_BACKSPACE = 8
KEY_DELETE = 127
KEY_HOME = 278
KEY_END = 279
KEY_INSERT = 277
KEY_PAGEUP = 280
KEY_PAGEDOWN = 281
KEY_PAUSE = 19
KEY_CAPSLOCK = 301
KEY_SCROLLOCK = 302
```

### 11.6 修饰键

```lua
KEY_SHIFT = 402     -- 虚拟 Shift
KEY_CTRL = 401      -- 虚拟 Ctrl
KEY_ALT = 400       -- 虚拟 Alt

KEY_LSHIFT = 304    -- 左 Shift
KEY_RSHIFT = 303    -- 右 Shift
KEY_LCTRL = 306     -- 左 Ctrl
KEY_RCTRL = 305     -- 右 Ctrl
KEY_LALT = 308      -- 左 Alt
KEY_RALT = 307      -- 右 Alt
```

### 11.7 鼠标按键

```lua
-- 注意：这些仅用于 UI，不能用于游戏逻辑！
MOUSEBUTTON_LEFT = 1000
MOUSEBUTTON_RIGHT = 1001
MOUSEBUTTON_MIDDLE = 1002
MOUSEBUTTON_SCROLLUP = 1003
MOUSEBUTTON_SCROLLDOWN = 1004
```

---

## 12. 碰撞组 (COLLISION.*)

```lua
COLLISION.GROUND            -- 地面
COLLISION.WORLD             -- 世界
COLLISION.OBSTACLES         -- 障碍物
COLLISION.SMALLOBSTACLES    -- 小障碍物
COLLISION.CHARACTERS        -- 角色
COLLISION.GIANTS            -- 巨型生物
COLLISION.ITEMS             -- 物品
COLLISION.FLYERS            -- 飞行物
COLLISION.LIMITS            -- 边界
COLLISION.SANITY            -- 精神实体
COLLISION.SHADOW            -- 暗影实体
COLLISION.LAND_OCEAN        -- 陆地/海洋
```

---

## 13. 颜色常量

```lua
-- 基本颜色
WHITE = {1, 1, 1, 1}
BLACK = {0, 0, 0, 1}
RED = {1, 0, 0, 1}
GREEN = {0, 1, 0, 1}
BLUE = {0, 0, 1, 1}
YELLOW = {1, 1, 0, 1}
CYAN = {0, 1, 1, 1}
MAGENTA = {1, 0, 1, 1}
GRAY = {0.5, 0.5, 0.5, 1}
TRANSPARENT = {0, 0, 0, 0}
```

---

## 14. 材质常量

```lua
MATERIALS = {
    WOOD = "wood",
    STONE = "stone",
    METAL = "metal",
    FLESH = "flesh",
    ICE = "ice",
    GEMS = "gems",
    THULECITE = "thulecite",
    SHELL = "shell",
    MOONROCK = "moonrock",
    MARBLE = "marble",
    GLASS = "glass",
    GOLD = "gold",
    BEEFALO = "beefalo",
    -- ...
}

MATERIAL_TYPES = {
    -- 材料类型（用于制作分类）
}
```

---

## 15. 节点类型 (NODE_TYPE.*)

```lua
NODE_TYPE = {
    Default = 0,
    Random = 1,
    Sequence = 2,
    Selector = 3,
    Parallel = 4,
    Condition = 5,
    Action = 6,
    Decorator = 7,
    -- ...
}
```

---

## 16. 路径查找

```lua
-- 路径查找类型
PATHFINDING = {
    WALKABLE = 1,       -- 可行走
    FLYABLE = 2,        -- 可飞行
    SWIMMABLE = 4,      -- 可游泳
    -- ...
}
```

---

## 17. 事件数据类型

```lua
-- 数据序列化类型
NETVAR_TYPES = {
    NETVAR_BOOL = "bool",
    NETVAR_FLOAT = "float",
    NETVAR_INT = "int",
    NETVAR_STRING = "string",
    NETVAR_ENTITY = "entity",
    NETVAR_USERDATA = "userdata",
}
```

---

## 18. 食物组枚举

```lua
FOODGROUP = {
    OMNI = "omni",
    VEGETARIAN = "vegetarian",
    CARNIVORE = "carnivore",
    -- 扩展食物组
    FOODTYPE = {
        GENERIC = "GENERIC",
        MEAT = "MEAT",
        VEGGIE = "VEGGIE",
        SEEDS = "SEEDS",
        ELEMENTAL = "ELEMENTAL",
        INSECT = "INSECT",
        GEARS = "GEARS",
        HORRIBLE = "HORRIBLE",
        WOOD = "WOOD",
        BURNT = "BURNT",
        ROUGHAGE = "ROUGHAGE",
        GOODIES = "GOODIES",
        RAW = "RAW",
    },
}
```

---

## 19. 物品稀有度

```lua
RARITY = {
    COMMON = "common",
    UNCOMMON = "uncommon",
    RARE = "rare",
    EPIC = "epic",
    LEGENDARY = "legendary",
}
```

---

## 20. Mod 使用注意事项

- `constants.lua` 中的常量是**全局变量**，可直接在任何脚本中使用
- 按键码（`KEY_*`）在 `GLOBAL` 中可用
- 控件 ID 在 `GLOBAL` 中可用
- 碰撞组用于物理系统，影响碰撞检测
- 渲染层决定实体绘制顺序
- 朝向常量用于 `inst.Transform:SetRotation()` 等场景

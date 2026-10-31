# 饥荒一线工坊深度研读 Skill：复合子实体生命周期管理与跨 Mod 动态图集编译技术

- **工坊 ID**：1595631294 (`Smart Minisign`)
- **领域分类**：复合实体链接（`AddChild` / `persists = false`）、跨 Mod 资源动态扫描、`ATLAS_BUILD` 运行时编译、容器关闭事件驱动
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发“智能容器、展示架、武器挂件、随从伴生装饰”等复合型 Mod 时：
1. **父子实体链接**：利用 `parent:AddChild(child)` 锁定相对空间坐标，并标记 `child.persists = false` 杜绝存档残留；
2. **动态图集补齐**：拦截 `ModManager.RegisterPrefabs`，自动为缺失 `ATLAS_BUILD` 的第三方图集进行运行时补全；
3. **事件驱动视图更新**：在 `onclose` 事件中捕获槽位物品并重绘外观。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：复合附属子实体安全绑定组件 (scripts/components/attached_display.lua)
-- ==============================================================================

local AttachedDisplay = GLOBAL.Class(function(self, inst)
    self.inst = inst
    self.attached_child = nil

    -- 监听宿主实体的销毁与燃烧事件
    self.inst:ListenForEvent("onremove", function() self:Cleanup() end)
    if self.inst.components.burnable then
        local old_onburnt = self.inst.components.burnable.onburnt
        self.inst.components.burnable.onburnt = function(inst)
            if old_onburnt then old_onburnt(inst) end
            self:Cleanup()
        end
    end

    -- 延迟一帧初始化，确保宿主实体完成世界加载
    self.inst:DoTaskInTime(0, function()
        self:AttachChildEntity("minisign")
    end)
end)

--- 挂载附属子实体并实施防残留隔离
function AttachedDisplay:AttachChildEntity(child_prefab)
    if not GLOBAL.TheWorld.ismastersim or self.inst:HasTag("burnt") then return end
    if self.attached_child ~= nil then return end

    local child = GLOBAL.SpawnPrefab(child_prefab)
    if not child then return end

    self.attached_child = child
    self.inst:AddChild(child)
    child.Transform:SetPosition(0, 0, 0)

    -- 铁律 1：标记不持久化保存，存档时仅存宿主实体
    child.persists = false

    -- 铁律 2：移除子实体的引燃与燃烧传播，防止重叠双重火灾
    if child.components.burnable then child:RemoveComponent("burnable") end
    if child.components.propagator then child:RemoveComponent("propagator") end
    if child.components.workable then child:RemoveComponent("workable") end
end

--- 安全清理子实体
function AttachedDisplay:Cleanup()
    if self.attached_child and self.attached_child:IsValid() then
        self.attached_child:Remove()
        self.attached_child = nil
    end
end

-- ==============================================================================
-- 范式 2：跨 Mod 图集扫描与 ATLAS_BUILD 动态热编译管线 (modmain.lua)
-- ==============================================================================

local function RegisterDynamicAtlasBuilder()
    local ModManager = GLOBAL.ModManager
    local old_RegisterPrefabs = ModManager.RegisterPrefabs

    ModManager.RegisterPrefabs = function(self)
        old_RegisterPrefabs(self)

        local dynamic_assets = {}
        local enabled_mods = ModManager.enabledmods

        for _, modname in ipairs(enabled_mods) do
            local mod = ModManager:GetMod(modname)
            if mod and mod.Assets then
                for _, asset in ipairs(mod.Assets) do
                    -- 扫描普通物品栏图集，自动补充编译级 ATLAS_BUILD
                    if asset.type == "ATLAS" and type(asset.file) == "string" and string.find(asset.file, "images/") then
                        local clean_file = string.gsub(asset.file, "%.%./mods/[^/]+/", "", 1)
                        table.insert(dynamic_assets, GLOBAL.Asset("ATLAS_BUILD", clean_file, 256))
                    end
                end
            end
        end

        if #dynamic_assets > 0 then
            -- 封装为自建虚拟 Prefab 强制载入引擎
            local pkg_name = "MOD_DYNAMIC_ATLAS_BUNDLE"
            GLOBAL.RegisterPrefabs(GLOBAL.Prefab(pkg_name, nil, dynamic_assets, nil, true))
            GLOBAL.TheSim:LoadPrefabs({ pkg_name })
            table.insert(self.loadedprefabs, pkg_name)
        end
    end
end

RegisterDynamicAtlasBuilder()

return {
    AttachedDisplay = AttachedDisplay,
}
```

---

## 三、避坑与生产安全准则

1. **子实体的 `persists = false` 绝对不能省略**：
   - 如果未设置 `persists = false`，每次世界重载时宿主实体会通过组件重新生成一个木牌，而存档文件又会单独加载出一个旧木牌，随着存档天数增加，实体数量呈指数级暴增，造成极度严重的卡顿。
2. **`clean_file` 路径规整处理**：
   - 第三方 Mod 在声明 Assets 时经常包含 `../mods/<modname>/images/...` 的相对跨级路径。在重新包装为 `ATLAS_BUILD` 时，必须使用 `string.gsub(path, "%.%./mods/[^/]+/", "", 1)` 抹平相对路径前缀，否则引擎底层在查找材质哈希时会匹配失败报红。

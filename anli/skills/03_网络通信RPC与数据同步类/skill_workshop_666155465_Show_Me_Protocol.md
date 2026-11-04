# 饥荒一线工坊深度研读 Skill：紧凑单字节网络编码与 Hoverer 浮动提示切面

- **工坊 ID**：666155465 (`Show Me`)
- **领域分类**：网络协议压缩优化、紧凑 ASCII 字节打包、Hoverer 悬停切面拦截、Mod 生态互斥与避让
- **研读基准**：Steam 创意工坊在线原版源码

在开发需要将服务端数据广播给客户端悬浮展示（如装备耐久、生物血量、法宝冷却时间）的 MOD 时，使用 JSON 或长字符串是极差的实践。`Show Me` 提供了一套被饥荒社区验证数十年的 **轻量单字节 Header 压缩协议** 与 **客户端 Hoverer 切面模板**。

```lua
-- ==============================================================================
-- ==============================================================================

local CompactPacker = {}

local PROTOCOL_MAP = {
    A = "ARMOR",       -- 护甲
    D = "DAMAGE",      -- 攻击力
    H = "HEALTH",      -- 生命值
    F = "FRESHNESS",   -- 新鲜度
    C = "COOLDOWN",    -- 冷却
}

function CompactPacker.Encode(header_char, params)
    local payload = header_char
    if params and #params > 0 then
        payload = payload .. table.concat(params, ";")
    end
    return payload
end

function CompactPacker.Decode(raw_str)
    if not raw_str or #raw_str == 0 then return nil end

    local header = string.sub(raw_str, 1, 1)
    local type_name = PROTOCOL_MAP[header]
    if not type_name then return nil end

    local params = {}
    local data_part = string.sub(raw_str, 2)
    for p in string.gmatch(data_part, "([^;]+)") do
        table.insert(params, p)
    end

    return {
        type = type_name,
        params = params,
    }
end

-- ==============================================================================
-- ==============================================================================

local function InstallHovererInterceptor()
    AddClassPostConstruct("widgets/hoverer", function(self)
        if not self.text then return end

        local old_SetString = self.text.SetString
        self.text.SetString = function(widget, str, ...)
            if str and widget.inst and ThePlayer then
                local target = TheInput:GetWorldEntityUnderMouse()
                if target and target.injected_hover_info then
                    str = str .. "\n" .. target.injected_hover_info
                end
            end
            return old_SetString(widget, str, ...)
        end
end)
end

return {
    CompactPacker = CompactPacker,
    InstallHovererInterceptor = InstallHovererInterceptor,
}
```

1. **协议头字符安全区间（ASCII 65~126）**：
   - 自定义网络单字符 Header 时，必须严格限制在 ASCII 可见字符区间（`A-Z`, `a-z`, 常用符号），严禁使用控制字符（0~31）或多字节 UTF-8 字符作为 Header，否则容易被底层网络 socket 截断抛出乱码异常。
2. **Hoverer 实体生命周期校验（`target:IsValid()`）**：
   - 在客户端 `Hoverer` 拦截中，通过 `TheInput:GetWorldEntityUnderMouse()` 取出的实体指针可能刚好在下一物理帧被服务端广播销毁。在读取任何字段前，必须加入 `target:IsValid()` 断言！

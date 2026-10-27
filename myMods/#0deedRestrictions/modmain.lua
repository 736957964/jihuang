GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

local _G = GLOBAL

modimport("debug.lua") --测试模式
modimport("./publicFn.lua") --公有的封装好的函数

-- modimport("./codePackage/b001.lua")
-- modimport("./codePackage/b002.lua")
modimport("./codePackage/b003.lua")

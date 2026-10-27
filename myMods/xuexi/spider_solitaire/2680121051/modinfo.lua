
name = "客户端-蜘蛛纸牌（SpiderSolitaire）"
description = [[
你可以在饥荒中玩到蜘蛛纸牌
请注意,你需要在一个安全的地方打开它
bug反馈Q群 917979244
当前模组为客户端版本
st-2680121051 wg-
--------当前版本b1.0.4--------
You can play spider cards in famine
Please note that you need to open it in a safe place
The current module is the client version
]]
author = "菜菜菜"  --mod作者
version = "1.0.4" --mod版本


standalone = false
restart_required = false

priority = 99

dont_starve_compatible = true         --是否兼容饥荒完整版本
reign_of_giants_compatible = false     --是否兼容饥荒单机版本体版本
dst_compatible = true                 --是否兼容饥荒联机版本
shipwrecked_compatible = false         --是否兼容饥荒单机版海滩DLC
hamlet_compatible = false              --是否兼容饥荒单机版哈姆雷特DLC
all_clients_require_mod= false        --是否需求所有人下载该mod
client_only_mod = true               --是否仅仅需求客户端拥有此mod
api_version = 9                       --API饥荒单机版本
api_version_dst = 10                  --API饥荒联机版本 

-- GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end}) --搜索全局必备,防止找不到相应东西而报错

--mod图标文件
icon_atlas = "dipai.xml"
icon = "dipai.tex"

-- This information tells other players more about the mod
name = "九霄龙吟惊天变"
description = [[

	这其实是场阴谋，猪王如是说。

]]

author = "RedPig"
version = "1.3.91"

-- This is the URL name of the mod's thread on the forum; the part after the index.php? and before the first & in the URL
-- Example:
-- http://forums.kleientertainment.com/index.php?/files/file/202-sample-mods/
-- becomes
-- /files/file/202-sample-mods/
forumthread = ""

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

priority = -8886

---- Can specify a custom icon for this mod!
--icon_atlas = "modicon.xml"
--icon = "modicon.tex"

--This lets the clients know that they need to download the mod before they can join a server that is using it.
all_clients_require_mod = false

--This lets the game know that this mod doesn't need to be listed in the server's mod listing
client_only_mod = false

--Let the mod system know that this mod is functional with Don't Starve Together
dst_compatible = true

--These tags allow the server running this mod to be found with filters from the server listing screen
server_filter_tags = {"redpig", "hard", "wtf" ,"challenge"}

icon_atlas = "modicon.xml"
icon = "modicon.tex"

--想改动的同学们看这里，有说明！！！
--开服务器用该mod又想手动更改设置的同学，只需把下面对应的default属性改成相应的data属性里面的值即可（有引号的记得要加引号哦，没有就不加）
--注意：不要用记事本修改本文件，最好去网上下载专业的代码编辑器，比如 notepad++ 
--举例：想要更改难度为简单，找到"游戏难度"，把下面的default = "normal" 改成 default = "easy"即可

configuration_options =
{
	{
        name = "language",
        label = "游戏语言(Language)",
        options =
        {
            {description = "中文(Chinese)", data = "chinese", hover = "中文"},
            {description = "英文(English)", data = "english", hover = "English" },
        },
        default = "chinese",
    },
	
    {
        name = "game_style",
        label = "游戏难度(Game Mode)",
        options =
        {
            {description = "普通(easy)", data = "easy", hover = "easy"},
            {description = "地狱(hard)", data = "hard", hover = "hard"},
        },
        default = "normal",
    },
	
	{
        name = "give_start_item",
        label = "是否给初始物品(Start Item)",
        options =
        {
            {description = "是(Yes)", data = true, hover = "YES"},
            {description = "否(No)", data = false, hover = "NO"},
        },
        default = false,
    },
	
	{
        name = "original_roles_balance",
        label = "原始角色配合模式(Original Roles Cooperation)",
        options =
        {
            {description = "开(ON)", data = true, hover = "Original Roles Cooperation ON"},
            {description = "关(OFF)", data = false, hover = "Original Roles Cooperation OFF"},
        },
        default = true,
    },
}
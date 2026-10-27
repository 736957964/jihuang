
name = "最后的战役"
description = [[

该模组必须开启情人。储藏室。沙漠棕榈



]]

author = "二月红"
version = "1.0.11"
forumthread = ""
api_version = 10
priority = -99999
all_clients_require_mod = false
client_only_mod = false
dst_compatible = true


configuration_options =
{
	{
		name = "title",
		label = " Display Title",
		hover = "Please edit me in the modoverrides.lua file.",
		options =
		{
			{description = "Default", data = "Message of the Day"},
		},
		default = "欢迎来到我的饥荒世界",
	},

	{
		name = "message",
		label = "Display Message",
		hover = "Please edit me in the modoverrides.lua file.",
		options =
		{
			{description = "Default", data = "Welcome to the server."},
		},
		default = "您使用了二月红的MOD，谢谢",
	},
}

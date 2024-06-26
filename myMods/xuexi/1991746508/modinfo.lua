local L = locale ~= "zh" and locale ~= "zhr" --true-英文; false-中文

name = L and "[DST] Myth Words" or "[DST] 神话书说 世事无常·篇"
author = "羽中, 幼儿园小班花, lw老王，老司饥, 杨柳, ti_Tout, 逸尘, 八戒Godfrey, 小明"
version = "7.10.21"
description =
    L and "Thanks for using this mod!\n                                           [version]"..version.."  [file]1991746508\n\n*Main contents here!"
    or "感谢订阅本mod！                                [版本]"..version.."  [文件]1991746508\n\n*包含了《神话书说》主要内容！\n\n*欢迎加Q群与我们讨论，以及问题反馈：一群-959381112；二群-1023311816"
forumthread = ""

api_version = 6
api_version_dst = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

all_clients_require_mod = true
-- client_only_mod = true

icon_atlas = "modicon_theme.xml"
icon = "modicon_theme.tex"

priority = -999999999 --大于人物mod
server_filter_tags = L and { "MYTH WORDS: theme" } or { "神话书说：主题" }

configuration_options =
{
    L and {
        name = "Language",
        label = "Language",
        hover = "Set Language",
        options =
        {
            {description = "English", data = "ENGLISH"},
            {description = "中文", data = "CHINESE"},
            {description = "日本語", data = "JAPAN"},
            {description = "Tiếng Việt", data = "VI"},
            {description = "Auto", data = 'A'}
        },
        default = 'A',
    } or {
        name = "Language",
        label = "语言",
        hover = "设置语言",
        options =
        {
            {description = "中文", data = "CHINESE"},
            {description = "英文", data = "ENGLISH"},
            {description = "日本語", data = "JAPAN"},
            {description = "越南语", data = "VI"},
            {description = "自动", data = 'A'}
        },
        default = 'A',
    },

    L and {
        name = "ShowBuff",
        label = "Buff Icons",
        hover = "Show Buff Icons",
        options =
        {
            {description = "Yes", data = true},
            {description = "No", data = false},
        },
        default = true,
    } or {
        name = "ShowBuff",
        label = "buff图标",
        hover = "是否显示buff状态的图标",
        options =
        {
            {description = "是", data = true},
            {description = "否", data = false},
        },
        default = true,
    },
}

--禁用动态加载
StaticAssetsReg = {'gourd'}

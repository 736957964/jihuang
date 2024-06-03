name = "威廉古堡"
forumthread = ""
description = [[各种boss增强及其他修改
]]
author = "GuardAngelY"
version = "1.0.0"
api_version = 10
priority = -9527
dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true
all_clients_require_mod = false
client_only_mod = false
server_only_mod = true
server_filter_tags = {"MonsterPower","GuardAngelY"}

icon_atlas = "modicon.xml"
icon = "modicon.tex"

--如果是搭建专属服务器，可通过两种方式更改MOD配置。
--一种是直接修改该modinfo文件各配置项的默认值（注意UTF-8编码格式）。
--另一种是在modoverride文件中进行配置，具体配置详情请参考链接http://www.lyun.me/lyun/427。

configuration_options =
{
    {
        name = "player_up",
        label = "角色加强",
        options =
        {
            {description = "开启", data = true, hover = "角色将可以通过打怪吃东西等进行升级"},
            {description = "关闭", data = false},
        },
        default = true,
    },
    {
        name = "player_baby",
        label = "玩家宝宝",
        options =
        {
            {description = "开启", data = true, hover = "玩家可以用各种宝石跟猪王换取宝宝"},
            {description = "关闭", data = false},
        },
        default = true,
    },
    {
        name = "equip_up",
        label = "装备升级",
        options =
        {
            {description = "开启", data = true, hover = [[
                使用稀有材料给你的装备升级
                拿起材料对着你想升级的武器右键即可
                武器可以用相应的材料进行修复
                宝石可以给武器上随机属性，等级与幸运值有关，不同宝石得到的属性几率各不相同，几率爆掉武器(和幸运值有关)
                幸运值会一定程度增加掉落物几率(最多增加两样掉落物)
                绿宝石随机给武器上幸运值1~10
                只允许出现3种永久性属性和一种暂时性属性
                武器战斗力越高，修复成本越大
            ]]},
            {description = "关闭", data = false},
        },
        default = false,
    },
    {
        name = "deerclops_up",
        label = "独眼巨鹿加强",
        options =
        {
            {description = "开启", data = true, hover = "加强"},
            {description = "关闭", data = false, hover = "不加强"},
        },
        default = false,
    },
    {
        name = "bearger_up",
        label = "熊獾加强",
        options =
        {
            {description = "开启", data = true, hover = "加强"},
            {description = "关闭", data = false, hover = "不加强"},
        },
        default = true,
    },
    {
        name = "dragonfly_up",
        label = "龙蝇加强",
        options =
        {
            {description = "开启", data = true, hover = "加强"},
            {description = "关闭", data = false, hover = "不加强"},
        },
        default = true,
    },
    {
        name = "moose_up",
        label = "麋鹿鹅加强",
        options =
        {
            {description = "开启", data = true, hover = "加强"},
            {description = "关闭", data = false, hover = "不加强"},
        },
        default = true,
    },
    {
        name = "minotaur_up",
        label = "远古守护者加强",
        options =
        {
            {description = "开启", data = true, hover = "加强"},
            {description = "关闭", data = false, hover = "不加强"},
        },
        default = true,
    },
	{
        name = "eviltobignum",
        label = "邪恶生物变大倍数",
        options =
        {
            {description = "1.25倍-2倍", data = 1},
            {description = "2倍-3倍", data = 2},

        },
        default = 1,
    },
	{
        name = "neutraltobignum",
        label = "中立生物变大倍数",
        options =
        {
            {description = "1.25倍-2倍", data = 1},
            {description = "2倍-3倍", data = 2},
        },
        default = 1,
    },
	{
        name = "bosstobignum",
        label = "boss级生物变大倍数",
        options =
        {
            {description = "1.5倍", data = 1},
            {description = "2倍", data = 2},
        },
        default = 1,
    },
    {
        name = "rabbit_spawn",
        label = "兔人刷新时间",
        options = 
        {
            {description = "1天(默认)", data = 1},
			{description = "2天", data = 2},
            {description = "3天", data = 3},
			{description = "4天", data = 4},
            {description = "5天", data = 5},
			{description = "6天", data = 6},
            {description = "7天", data = 7},
			{description = "8天", data = 8},
			{description = "9天", data = 9},
			{description = "10天", data = 10},
            {description = "11天", data = 11},
			{description = "12天", data = 12},
        },
        default = 4,
    },
    {
        name = "pig_spawn",
        label = "猪人刷新时间",
        options = 
        {
            {description = "1天", data = 1},
			{description = "2天", data = 2},
            {description = "3天", data = 3},
			{description = "4天(默认)", data = 4},
            {description = "5天", data = 5},
			{description = "6天", data = 6},
            {description = "7天", data = 7},
			{description = "8天", data = 8},
			{description = "9天", data = 9},
			{description = "10天", data = 10},
            {description = "11天", data = 11},
			{description = "12天", data = 12},
        },
        default = 3,
    },
    {
		name = "dog_atk_warning_days",
		label = "提前多少天警告猎犬袭击",
		options =
        {
            {description = "7天", data = 7},
            {description = "6天", data = 6},
            {description = "5天", data = 5},
            {description = "4天", data = 4},
            {description = "3天", data = 3},
            {description = "2天", data = 2},
            {description = "1天", data = 1},
            {description = "关闭", data = 0},
		},
		default =2,
	},
    {
		name = "restart_cd",
		label = "重生CD冷却时间（分）",
		hover = "重生的冷却时间,默认六十分钟",
		options =
		{
			{description = "无", data = 0, hover = "无限重生"},
			{description = "1", data = 1, hover = "1 分钟"},
			{description = "2", data = 2, hover = "2 分钟"},
			{description = "3", data = 3, hover = "3 分钟"},
			{description = "5", data = 5, hover = "5 分钟"},
			{description = "7", data = 7, hover = "7 分钟"},
			{description = "10", data = 10, hover = "10 分钟"},
            {description = "15", data = 15, hover = "15 分钟"},
            {description = "30", data = 30, hover = "30 分钟"},
            {description = "45", data = 45, hover = "45 分钟"},
            {description = "60", data = 60, hover = "60 分钟"},
            {description = "关闭", data = -1, hover = "不允许命令重生"},
		},
		default = 0,
	},
	{
		name = "resurrect_cd",
		label = "复活CD冷却时间（分）",
		hover = "复活的冷却时间,默认为十分钟",
		options =
		{
			{description = "无", data = 0, hover = "无限复活"},
			{description = "1", data = 1, hover = "1 分钟"},
			{description = "2", data = 2, hover = "2 分钟"},
			{description = "3", data = 3, hover = "3 分钟"},
			{description = "5", data = 5, hover = "5 分钟"},
			{description = "7", data = 7, hover = "7 分钟"},
			{description = "10", data = 10, hover = "10 分钟"},
            {description = "15", data = 15, hover = "15 分钟"},
            {description = "30", data = 30, hover = "30 分钟"},
            {description = "45", data = 45, hover = "45 分钟"},
            {description = "60", data = 60, hover = "60 分钟"},
            {description = "关闭", data = -1, hover = "不允许命令复活"},
		},
		default = 0,
	},
	{
		name = "kill_cd",
		label = "自杀CD冷却时间（分）",
		hover = "自杀的冷却时间,默认为三分钟",
		options =
		{
			{description = "无", data = 0, hover = "无限自杀"},
			{description = "1", data = 1, hover = "1 分钟"},
			{description = "2", data = 2, hover = "2 分钟"},
			{description = "3", data = 3, hover = "3 分钟"},
			{description = "5", data = 5, hover = "5 分钟"},
			{description = "7", data = 7, hover = "7 分钟"},
			{description = "10", data = 10, hover = "10 分钟"},
            {description = "15", data = 15, hover = "15 分钟"},
            {description = "30", data = 30, hover = "30 分钟"},
            {description = "45", data = 45, hover = "45 分钟"},
            {description = "60", data = 60, hover = "60 分钟"},
            {description = "关闭", data = -1, hover = "不允许命令自杀"},
		},
		default = 3,
	},
    {
        name = "drop_min",
        label = "最小掉落",
        hover = "最小掉落的物品格数",
        options =
        {
            {description = "不掉落", data = 0, hover = "不掉落任何物品"},
            {description = "1",  data = 1,  hover = "最少掉落1件"},
            {description = "2",  data = 2,  hover = "最少掉落2件"},
            {description = "3",  data = 3,  hover = "最少掉落3件"},
            {description = "4",  data = 4,  hover = "最少掉落4件"},
            {description = "5",  data = 5,  hover = "最少掉落5件"},
            {description = "6",  data = 6,  hover = "最少掉落6件"},
            {description = "7",  data = 7,  hover = "最少掉落7件"},
            {description = "8",  data = 8,  hover = "最少掉落8件"},
            {description = "9",  data = 9,  hover = "最少掉落9件"},
            {description = "10", data = 10, hover = "最少掉落10件"},
            {description = "11", data = 11, hover = "最少掉落11件"},
            {description = "12", data = 12, hover = "最少掉落12件"},
            {description = "13", data = 13, hover = "最少掉落13件"},
            {description = "14", data = 14, hover = "最少掉落14件"},
            {description = "15", data = 15, hover = "最少掉落15件"},
        },
        default = 0,
    },
    {
        name = "drop_max",
        label = "最大掉落",
        hover = "最大掉落的物品格数",
        options =
        {
            {description = "不掉落", data = 0, hover = "不掉落任何物品"},
            {description = "1",  data = 1,  hover = "最大掉落1件"},
            {description = "2",  data = 2,  hover = "最大掉落2件"},
            {description = "3",  data = 3,  hover = "最大掉落3件"},
            {description = "4",  data = 4,  hover = "最大掉落4件"},
            {description = "5",  data = 5,  hover = "最大掉落5件"},
            {description = "6",  data = 6,  hover = "最大掉落6件"},
            {description = "7",  data = 7,  hover = "最大掉落7件"},
            {description = "8",  data = 8,  hover = "最大掉落8件"},
            {description = "9",  data = 9,  hover = "最大掉落9件"},
            {description = "10", data = 10, hover = "最大掉落10件"},
            {description = "11", data = 11, hover = "最大掉落11件"},
            {description = "12", data = 12, hover = "最大掉落12件"},
            {description = "13", data = 13, hover = "最大掉落13件"},
            {description = "14", data = 14, hover = "最大掉落14件"},
            {description = "15", data = 15, hover = "最大掉落15件"},
        },
        default = 0,
    },
    {
		name = "speed",
		label = "冰箱保鲜",
        hover = "改变冰箱中食物的腐烂速度.",
		options =
        {
            {description = "超快", data = "100000", hover = "食物将在10秒内腐烂."},
            {description = "快20倍", data = "20", hover = "腐烂速度快20倍."},
            {description = "快10倍", data = "10", hover = "腐烂速度快10倍."},
            {description = "快8倍", data = "8", hover = "腐烂速度快8倍."},
            {description = "快6倍", data = "6", hover = "腐烂速度快6倍."},
            {description = "快4倍", data = "4", hover = "腐烂速度快4倍."},
            {description = "快2倍", data = "2", hover = "腐烂速度快2倍."},
            {description = "正常", data = "1", hover = "腐烂速度为系统默认."},
            {description = "慢2倍", data = "0.5", hover = "腐烂速度慢2倍."},
            {description = "慢4倍", data = "0.25", hover = "腐烂速度慢4倍."},
            {description = "慢6倍", data = "0.165", hover = "腐烂速度慢6倍."},
            {description = "慢8倍", data = "0.125", hover = "腐烂速度慢8倍."},
            {description = "慢10倍", data = "0.1", hover = "腐烂速度慢10倍."},
            {description = "慢20倍", data = "0.05", hover = "腐烂速度慢20倍."},
            {description = "永不腐烂", data = "0", hover = "冰箱食物永不腐烂."},
        },
		default = "1",
	},
    {
	    name = "stack_size",
        label = "叠加上限",
        options = 
        {
            {description = "关闭", data = -1},
            {description = "5", data = 5},
            {description = "10", data = 10},
			{description = "15", data = 15},
            {description = "20", data = 20},
			{description = "25", data = 25},
            {description = "30", data = 30},
			{description = "35", data = 35},
			{description = "45", data = 40},
			{description = "45", data = 45},
            {description = "50", data = 50},
			{description = "55", data = 55},
			{description = "60", data = 60},
        },
        default = -1,
	},
    {
        name = "TentUses",
        label = "帐篷使用次数",
        options = 
        {
            {description = "5", data = 5},
			{description = "6 (默认)", data = 6},
            {description = "10", data = 10},
			{description = "15", data = 15},
            {description = "20", data = 20},
			{description = "25", data = 25},
            {description = "30", data = 30},
			{description = "35", data = 35},
			{description = "45", data = 40},
			{description = "45", data = 45},
            {description = "50", data = 50},
			{description = "55", data = 55},
			{description = "60", data = 60},
			{description = "65", data = 65},
            {description = "70", data = 70},
			{description = "75", data = 75},
			{description = "80", data = 80},
			{description = "85", data = 85},
            {description = "90", data = 90},
			{description = "95", data = 95},
			{description = "100", data = 100},
			{description = "无限", data = 10000000}
        },
        default = 6,
    },
	{
	    name = "SiestaCanopyUses",
        label = "凉棚使用次数",
        options = 
        {
            {description = "5", data = 5},
			{description = "6 (默认)", data = 6},
            {description = "10", data = 10},
			{description = "15", data = 15},
            {description = "20", data = 20},
			{description = "25", data = 25},
            {description = "30", data = 30},
			{description = "35", data = 35},
			{description = "45", data = 40},
			{description = "45", data = 45},
            {description = "50", data = 50},
			{description = "55", data = 55},
			{description = "60", data = 60},
			{description = "65", data = 65},
            {description = "70", data = 70},
			{description = "75", data = 75},
			{description = "80", data = 80},
			{description = "85", data = 85},
            {description = "90", data = 90},
			{description = "95", data = 95},
			{description = "100", data = 100},
			{description = "无限", data = 10000000}
        },
        default = 6,
	},
    {
        name = "heatrock_no_durability",
        label = "暖石无耐久",
        options =
        {
			{description = "开启", data = true, hover = "暖石无限耐久"}, 
			{description = "关闭", data = false}, 
        },
        default = false,
    },
    {
        name = "todog",
        label = "todog",
        options =
        {
			{description = "开启", data = true, hover = "todog"}, 
			{description = "关闭", data = false}, 
        },
        default = false,
    },
    {
        name = "atsave",
        label = "atsave",
        options =
        {
			{description = "开启", data = true, hover = "atsave"}, 
			{description = "关闭", data = false}, 
        },
        default = false,
    },
    {
        name = "teleport",
        label = "teleport",
        options =
        {
			{description = "开启", data = true, hover = "teleport"}, 
			{description = "关闭", data = false}, 
        },
        default = false,
    },
}
name = "boss合集(可调整血量,攻击,掉落物,体型,和怪物随时间成长)"
description = [[
1.改变BOSS的血量(以倍数来计算,支持0.2-8倍,需要更多的请直接修改数值,默认血量不变)
2.改变BOSS的攻击(以倍数来计算,支持0.2-3倍,需要更多的请直接修改数值,默认攻击不变)
3.改变BOSS的攻击范围(以倍数来计算,支持0.2-3倍,需要更多的请直接修改数值,默认攻击范围不变)
4.增加BOSS的掉落物(0代表不变,0.2代表20%的概率掉落第二份奖励,1代表100%掉落俩份奖励,默认掉落不变)	
5.改变BOSS的防御(有一个开关,先把开关调到true再调该值)	
6.击杀怪物公告
7.BOSS血量随着天数成长
8.boss血量回复
9.boss体型改变
10.暂定  当前版本：1.16.03
workshop-2677451059
]]
--——————————————————
author = "菜菜菜"
version = "1.16.03"
forumthread = ""
api_version = 10
all_clients_require_mod = false
client_only_mod = false
dst_compatible = true
icon_atlas = "modicon.xml"
icon = "modicon.tex"
configuration_options =
{
	{
        name = "bosshealth",
        label = "BOSS血量倍数(1代表血量不变)",
		hover = "0.2代表BOSS血量为原来的20%,1代表不变,2代表血量为原来的俩倍",
        options =
        {
            {description = "BOSS变成1血", data = 66666},
            {description = "0.2倍", data = 0.2},
			{description = "0.4倍", data = 0.4},
            {description = "0.6倍", data = 0.6},
			{description = "0.8倍", data = 0.8},
            {description = "1.0倍", data = 1.0},
			{description = "1.2倍", data = 1.2},
            {description = "1.4倍", data = 1.4},
			{description = "1.6倍", data = 1.6},
			{description = "1.8倍", data = 1.8},
            {description = "2.0倍", data = 2.0},
			{description = "2.2倍", data = 2.2},
            {description = "2.4倍", data = 2.4},
			{description = "2.6倍", data = 2.6},
            {description = "2.8倍", data = 2.8},
			{description = "3.0倍", data = 3.0},
			{description = "5.0倍", data = 5.0},
			{description = "8.0倍", data = 8.0},
			{description = "99倍",data = 99}
        },
        default = 1.0,
    },
	
	{
        name = "bossdefaultdamage",
        label = "BOSS攻击倍数(1代表攻击不变)",
		hover = "0.2代表BOSS攻击为原来的20%,1代表不变,2代表攻击为原来的俩倍",
        options =
        {
		    {description = "BOSS无害", data = 0},
            {description = "0.2倍", data = 0.2},
			{description = "0.4倍", data = 0.4},
            {description = "0.6倍", data = 0.6},
			{description = "0.8倍", data = 0.8},
            {description = "1.0倍", data = 1.0},
			{description = "1.2倍", data = 1.2},
            {description = "1.4倍", data = 1.4},
			{description = "1.6倍", data = 1.6},
			{description = "1.8倍", data = 1.8},
            {description = "2.0倍", data = 2.0},
			{description = "2.2倍", data = 2.2},
            {description = "2.4倍", data = 2.4},
			{description = "2.6倍", data = 2.6},
            {description = "2.8倍", data = 2.8},
			{description = "3.0倍", data = 3.0},
			{description = "99倍",data = 99},
        },
        default = 1.0,
    },
	
	{
        name = "bossattackrange",
        label = "boss攻击范围倍数(1代表攻击不变)",
		hover = "0.2代表boss攻击范围为原来的20%,1代表不变,2代表攻击范围为原来的俩倍",
        options =
        {
            {description = "0.2倍", data = 0.2},
			{description = "0.4倍", data = 0.4},
            {description = "0.6倍", data = 0.6},
			{description = "0.8倍", data = 0.8},
            {description = "1.0倍", data = 1.0},
			{description = "1.2倍", data = 1.2},
            {description = "1.4倍", data = 1.4},
			{description = "1.6倍", data = 1.6},
			{description = "1.8倍", data = 1.8},
            {description = "2.0倍", data = 2.0},
			{description = "2.2倍", data = 2.2},
            {description = "2.4倍", data = 2.4},
			{description = "2.6倍", data = 2.6},
            {description = "2.8倍", data = 2.8},
			{description = "3.0倍", data = 3.0},
			{description = "99倍",data = 99},
        },
        default = 1.0,
    },
	
	{
        name = "drop",
        label = "额外的boss掉落物(1代表掉俩份奖励)",
		hover = "0.2代表20%的概率掉落额外的奖励,1代表100%掉落俩份奖励,1.2代表掉落俩份奖励的同时还有20%的概率掉落第三份奖励,2代表掉落三份奖励",
        options =
        {
		    {description = "0倍", data = 0},
            {description = "0.2倍", data = 0.2},
			{description = "0.4倍", data = 0.4},
            {description = "0.6倍", data = 0.6},
			{description = "0.8倍", data = 0.8},
            {description = "1.0倍", data = 1.0},
			{description = "1.2倍", data = 1.2},
            {description = "1.4倍", data = 1.4},
			{description = "1.6倍", data = 1.6},
			{description = "1.8倍", data = 1.8},
            {description = "2.0倍", data = 2.0},
			{description = "2.2倍", data = 2.2},
            {description = "2.4倍", data = 2.4},
			{description = "2.6倍", data = 2.6},
            {description = "2.8倍", data = 2.8},
			{description = "3.0倍", data = 3.0},
			{description = "4.0倍", data = 4.0},
			{description = "5.0倍", data = 5.0},
			{description = "99倍(想要卡死直说)",data = 99},
        },
        default = 0,
    },
	
	{
        name = "absorptionAmountswitch",
        label = "boss是否添加防御",
		hover = "写开关的原因主要是为了配合一些穿甲的武器,不然调血量也是一样的,默认关闭",
        options =
        {
		    {description = "开", data = true},
            {description = "关", data = false},
        },
        default = false,
    },
	
	{
        name = "absorptionAmount",
        label = "boss防御百分比(默认防御为0.25)",
		hover = "25%代表100攻击的武器只能造成75的伤害",
        options =
        {
		    {description = "0倍", data = 0},
            {description = "10%", data = 0.10},
			{description = "15%", data = 0.15},
            {description = "20%", data = 0.20},
			{description = "25%", data = 0.25},
            {description = "30%", data = 0.30},
			{description = "35%", data = 0.35},
            {description = "40%", data = 0.40},
			{description = "45%", data = 0.45},
			{description = "50%", data = 0.50},
            {description = "55%", data = 0.55},
			{description = "60%", data = 0.60},
            {description = "65%", data = 0.65},
			{description = "70%", data = 0.70},
            {description = "75%", data = 0.75},
			{description = "80%", data = 0.80},
			{description = "85%", data = 0.85},
			{description = "90%", data = 0.90},
			{description = "95%", data = 0.95},
			{description = "99%", data = 0.99},
        },
        default = 0.25,
    },
	
	{
        name = "KillAnnounce",
        label = "击杀公告开关(默认开启)",
		hover = "击杀公告开关",
        options =
        {
		    {description = "开", data = true},
            {description = "关", data = false},
        },
        default = true,
    },
	
	{
        name = "growup",
        label = "boss血量随着世界天数增加开关(默认关)",
		hover = "成长开关",
        options =
        {
		    {description = "开", data = true},
            {description = "关", data = false},
        },
        default = false,
    },
	
	{
        name = "growuphealth",
        label = "boss血量随着世界天数增加(需先打开开关)",
		hover = "10为怪物每天增加10血,默认每天加10",
        options =
        {
		    {description = "不增加血量", data = 0},
		    {description = "每天增加5血", data = 5},
            {description = "每天增加10血", data = 10},
			{description = "每天增加15血", data = 15},
            {description = "每天增加20血", data = 20},
			{description = "每天增加25血", data = 25},
			{description = "每天增加30血", data = 30},
			{description = "每天增加35血", data = 35},
			{description = "每天增加40血", data = 40},
			{description = "每天增加45血", data = 45},
			{description = "每天增加50血", data = 50},
			{description = "每天增加60血", data = 60},
			{description = "每天增加70血", data = 70},
			{description = "每天增加80血", data = 80},
			{description = "每天增加90血", data = 90},
			{description = "每天增加100血", data = 100},
			{description = "每天增加125血", data = 125},
			{description = "每天增加150血", data = 150},
			{description = "每天增加200血", data = 200},
			{description = "每天增加300血", data = 300},
			{description = "每天增加999血", data = 999},
        },
        default = 10,
    },
	
	{
        name = "growup2",
        label = "boss回血开关(默认关)",
		hover = "boss回血开关",
        options =
        {
		    {description = "开", data = true},
            {description = "关", data = false},
        },
        default = false,
    },
	
	{
        name = "growuptime",
        label = "boss每N秒回血一次(默认为5)",
		hover = "boss每N秒回血一次",
        options =
        {
		    {description = "boss每1秒回血一次", data = 1},
            {description = "boss每3秒回血一次", data = 3},
			{description = "boss每5秒回血一次", data = 5},
            {description = "boss每8秒回血一次", data = 8},
			{description = "boss每10秒回血一次", data = 10},
			{description = "boss每15秒回血一次", data = 15},
			{description = "boss每20秒回血一次", data = 20},
			{description = "boss每30秒回血一次", data = 30},
			{description = "boss每一分钟回血一次", data = 60},
			{description = "boss每俩分钟回血一次", data = 120},
			{description = "boss每三分钟回血一次", data = 180},
			{description = "boss每五分钟回血一次", data = 300},
			{description = "boss每一天回血一次(饥荒一天)", data = 480},
			{description = "boss每俩天回血一次(饥荒俩天)", data = 480*2},
			{description = "boss每三天回血一次(饥荒三天)", data = 480*3},
			{description = "boss每五天回血一次(饥荒五天)", data = 480*5},
			{description = "boss每八天回血一次(饥荒八天)", data = 480*8},
			{description = "boss每十天回血一次(饥荒十天)", data = 480*10},
			{description = "boss每十五天回血一次(饥荒十五天)", data = 480*15},
			{description = "boss每二十天回血一次(饥荒二十天)", data = 480*20},
			{description = "boss每三十天回血一次(饥荒三十天)", data = 480*30},
			{description = "boss每五十天回血一次(饥荒五十天)", data = 480*50},
			{description = "boss每一百天回血一次(饥荒一百天)", data = 480*100},
			{description = "boss每999天回血一次", data = 480*999},
        },
        default = 5,
    },
	
	{
        name = "growuphealthtwo",
        label = "boss回血(需先打开开关)",
		hover = "20为怪物每N秒回20血(N秒需要在上面调整),默认每5秒加20血",
        options =
        {
		    {description = "不回血", data = 0},
		    {description = "回血数量为1", data = 1},
            {description = "回血数量为3", data = 3},
			{description = "回血数量为5", data = 5},
            {description = "回血数量为10", data = 10},
			{description = "回血数量为15", data = 15},
			{description = "回血数量为20", data = 20},
			{description = "回血数量为25", data = 25},
			{description = "回血数量为30", data = 30},
			{description = "回血数量为35", data = 35},
			{description = "回血数量为40", data = 40},
			{description = "回血数量为45", data = 45},
			{description = "回血数量为50", data = 50},
			{description = "回血数量为60", data = 60},
			{description = "回血数量为70", data = 70},
			{description = "回血数量为80", data = 80},
			{description = "回血数量为90", data = 90},
			{description = "回血数量为100", data = 100},
			{description = "回血数量为120", data = 120},
			{description = "回血数量为150", data = 150},
			{description = "回血数量为180", data = 180},
			{description = "回血数量为200", data = 200},
			{description = "回血数量为300", data = 300},
			{description = "回血数量为500", data = 500},
			{description = "回血数量为800", data = 800},
			{description = "回血数量为1000", data = 1000},
			{description = "回血数量为2000", data = 2000},
			{description = "回血数量为3000", data = 3000},
			{description = "回血数量为5000", data = 5000},
			{description = "回血数量为99999(....你是有多无聊选这个)", data = 999999},
        },
        default = 20,
    },
	
	
	{
        name = "bossSetScale",
        label = "boss体型(1代表体型不变)",
		hover = "0.2代表boss体型为原来的20%,1代表不变,2代表体型为原来的俩倍",
        options =
        {
            {description = "0.2倍", data = 0.2},
			{description = "0.4倍", data = 0.4},
            {description = "0.6倍", data = 0.6},
			{description = "0.8倍", data = 0.8},
            {description = "1.0倍", data = 1.0},
			{description = "1.2倍", data = 1.2},
            {description = "1.4倍", data = 1.4},
			{description = "1.6倍", data = 1.6},
			{description = "1.8倍", data = 1.8},
            {description = "2.0倍", data = 2.0},
			{description = "2.2倍", data = 2.2},
            {description = "2.4倍", data = 2.4},
			{description = "2.6倍", data = 2.6},
            {description = "2.8倍", data = 2.8},
			{description = "3.0倍", data = 3.0},
			{description = "4.0倍(不推荐)",data = 1.0},
        },
        default = 1.0,
    },
}
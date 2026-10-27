
local STRINGS = GLOBAL.STRINGS
local TECH = GLOBAL.TECH
local Ingredient = GLOBAL.Ingredient
local resolvefilepath = GLOBAL.resolvefilepath
local RECIPETABS = GLOBAL.RECIPETABS

GLOBAL.bosscave_animals = {
	"rabbit",--兔子
	"perd", --火鸡
	"frog",--青蛙
	"ghost",--鬼魂
	"mole",--鼹鼠
	"catcoon",--浣熊
	"krampus",--小偷
	--"mossling",--小鸭子
	"grassgekko",--草蜥蜴
	--鹿类
	"deer",--无眼鹿
	"lightninggoat",--闪电羊
	--类人
	"pigman",--猪人
	"pigguard",--猪人守卫
	"merm",--鱼人
	--齿轮类
	"knight",
	"bishop",
	"rook",
	"bishop_nightmare_spawner",
	--牛
	"babybeefalo",
	"beefalo",
	--蜘蛛
	"spider_hider",
	"spider_spitter",
	"spider",
	"spider_warrior",
	"spiderqueen",
	"spider_dropper",
	--狗
	"hound",
	"firehound",
	"icehound",
	--树精
	"leif",
	"leif_sparse",
	--海象
	"walrus",
	"little_walrus",
	--高鸟
	"smallbird",
	"teenbird",
	"tallbird",
	--大象
	"koalefant_summer",
	"koalefant_winter",
	--暗影类
	"nightmarebeak",--尖嘴影怪
	"crawlingnightmare",--匍匐暗影怪
	"shadow_bishop",--暗影主教
	"shadow_knight",--暗影骑士
	"shadow_rook",--暗影战车
	
	--洞穴生物
	"bunnyman",
	"worm",
	"slurtle",--尖壳蜗牛
	"snurtle",--圆壳蜗牛
	--"rocky",
	"monkey",
	"slurper",
	
	--fly
	--"bee",--蜜蜂
	--"crow",--乌鸦
	--"robin",
	--"robin_winter",
	--"canary",--金丝雀
	--"butterfly",
	"mosquito",--蚊子
	"killerbee",--杀人蜂
	"bat",--蝙蝠
	--"buzzard",--秃鹫
}

local bosstable = {
	"bearger", --熊
	"warg", --座狼
	"deerclops",--巨鹿
	"minotaur",--远古守护者
	"moose",--鸭子
	"dragonfly",--蜻蜓
	"beequeen",--女王蜂
	"klaus",--克劳斯
	"spat",--钢铁羊
	"toadstool",--毒蘑菇boss
	"stalker",--复活的骷髅
}


for k,v in pairs(bosstable) do
	table.insert(GLOBAL.bosscave_animals, v)
end

	--添加洞穴数量统计组件
AddPrefabPostInit("world", function(inst)
	if inst.ismastersim then
		inst:AddComponent("bosscave_record")
	end
end)
	


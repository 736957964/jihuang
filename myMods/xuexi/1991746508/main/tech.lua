-- 4.1更新
-- 添加神话科技, 制作台为无字天书

-- 代码作者：ti_Tout

table.insert(PrefabFiles, "book_myth")
--------------------------------------------------------------------------
--[[ 修改默认的科技树生成方式 ]]
--------------------------------------------------------------------------

local TechTree = require("techtree")

table.insert(TechTree.AVAILABLE_TECH, "MYTH_TECH")  --其实就是加个自己的科技树名称
table.insert(TechTree.AVAILABLE_TECH, "MYTH_TECH_CHANGE")

table.insert(TechTree.BONUS_TECH, "MYTH_TECH_CHANGE")

TechTree.Create = function(t)
    t = t or {}
    for i, v in ipairs(TechTree.AVAILABLE_TECH) do
        t[v] = t[v] or 0
    end
    return t
end

--------------------------------------------------------------------------
--[[ 制作等级中加入自己的部分 ]]
--------------------------------------------------------------------------

TECH.NONE.MYTH_TECH = 0
TECH.MYTH_TECH = { MYTH_TECH = 1 }

TECH.NONE.MYTH_TECH_CHANGE = 0
TECH.MYTH_TECH_CHANGE_ONE = { MYTH_TECH_CHANGE = 1 }
TECH.MYTH_TECH_CHANGE_TWO = { MYTH_TECH_CHANGE = 2 }
TECH.MYTH_TECH_CHANGE_THREE = { MYTH_TECH_CHANGE = 3 }
TECH.MYTH_TECH_CHANGE_FOUR = { MYTH_TECH_CHANGE = 4 }
--------------------------------------------------------------------------
--[[ 解锁等级中加入自己的部分 ]]
--------------------------------------------------------------------------

for k,v in pairs(TUNING.PROTOTYPER_TREES) do
    v.MYTH_TECH = 0
	v.MYTH_TECH_CHANGE = 0
end

--ELECOURMALINE_ONE可以改成任意的名字，这里和TECH.ELECOURMALINE_ONE名字相同只是懒得改了
TUNING.PROTOTYPER_TREES.MYTH_TECH = TechTree.Create({
    MYTH_TECH = 1,
})

TUNING.PROTOTYPER_TREES.MYTH_TECH_CHANGE = TechTree.Create({
	MYTH_TECH_CHANGE = 0,
})
TUNING.PROTOTYPER_TREES.MYTH_TECH_CHANGE_ONE = TechTree.Create({
	MYTH_TECH_CHANGE = 2,
})
TUNING.PROTOTYPER_TREES.MYTH_TECH_CHANGE_TWO = TechTree.Create({
	MYTH_TECH_CHANGE = 4,
})
TUNING.PROTOTYPER_TREES.MYTH_TECH_CHANGE_THREE = TechTree.Create({
	MYTH_TECH_CHANGE = 6,
})
TUNING.PROTOTYPER_TREES.MYTH_TECH_CHANGE_FOUR = TechTree.Create({
	MYTH_TECH_CHANGE = 7,
})

----------------------------------------------------------
--[[ 修改全部制作配方，对缺失的值进行补充 ]]
--------------------------------------------------------------------------

for i, v in pairs(AllRecipes) do
    if v.level.MYTH_TECH == nil then
        v.level.MYTH_TECH = 0
    end
	if v.level.MYTH_TECH_CHANGE == nil then
		v.level.MYTH_TECH_CHANGE = 0
	end
end
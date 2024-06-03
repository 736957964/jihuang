local _G = GLOBAL
local TUNING = _G.TUNING

-- 兔人刷新时间
local rabbit_spawn = GetModConfigData("rabbit_spawn")
-- 猪人刷新时间
local pig_spawn = GetModConfigData("pig_spawn")

-- 兔人房
TUNING.BUNNYMAN_SPAWN_TIME = rabbit_spawn * TUNING.TOTAL_DAY_TIME
AddPrefabPostInit("rabbithouse", function (inst)
	-- 随机增加5天范围
	inst.components.spawner:Configure("bunnyman", TUNING.BUNNYMAN_SPAWN_TIME + (math.random(1, 10) * TUNING.TOTAL_DAY_TIME))
	--inst.components.spawner:Configure("bunnyman", TUNING.BUNNYMAN_SPAWN_TIME)
	inst.components.spawner:CancelSpawning()
end)

-- 猪人房
TUNING.PIGMAN_SPAWN_TIME = pig_spawn * TUNING.TOTAL_DAY_TIME
AddPrefabPostInit("pighouse", function (inst)
	-- 随机增加5天范围
	inst.components.spawner:Configure("pigman", TUNING.PIGMAN_SPAWN_TIME + (math.random(1, 10) * TUNING.TOTAL_DAY_TIME))
	--inst.components.spawner:Configure("pigman", TUNING.PIGMAN_SPAWN_TIME)
	inst.components.spawner:CancelSpawning()
end)
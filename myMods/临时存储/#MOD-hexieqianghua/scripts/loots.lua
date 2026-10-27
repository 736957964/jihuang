local _G = GLOBAL
--local SetSharedLootTable = _G.SetSharedLootTable

local function PickLootRandomItems(number, loot)
	local refinedloot = {}

	for i = 1, number do
		local num = math.random(#loot)
		table.insert(refinedloot, loot[num])
		--table.remove(loot, num)
	end

	return refinedloot
end

function AddLootItems(srcLoot, loot, num)
	--_G.dumptable(srcLoot, 1, 10)
	if srcLoot == nil then
		srcLoot = {}
	end

	local numloot = num or #loot
	local rdLoot = loot
	if #loot > numloot then
		rdLoot = PickLootRandomItems(numloot, loot)
	end

	for k, itemtype in ipairs(rdLoot) do
		local itemToSpawn = itemtype.item or itemtype
		if type(itemToSpawn) == "table" then
			itemToSpawn = itemToSpawn[math.random(#itemToSpawn)]
		end

		local spawn = math.random() <= (itemtype.chance or 1)

		local count = itemtype.count or 1

		if spawn then
			for i = 1, count do
				table.insert(srcLoot, itemToSpawn)
			end
		end
	end

	return srcLoot
end

local items = 
{
	{
		--Body Items
		item = "armorruins", --图勒护甲
		chance = 0.33
	},
	{
		--Body Items
		item = "ruinshat", --图勒王冠
		chance = 0.33
	},
	{
		item = {"ruins_bat"},
		chance = 0.25
	},
	-- {
	-- 	--Weapon Items [图勒棒,瞬移魔杖,晨星法杖]
	-- 	item = {"ruins_bat", "orangestaff", "yellowstaff"},
	-- 	chance = 0.25
	-- },
	-- {
	-- 	--Weapon Items [火杖,冰杖,传送魔杖,远古斧]
	-- 	item = {"firestaff", "icestaff", "telestaff", "multitool_axe_pickaxe"},
	-- 	chance = 0.5
	-- },
	{
		item = "thulecite",
		count = math.random(7, 14),
		chance = 0.75,
	},
	{
		item = "thulecite_pieces",
		count = math.random(7, 14),
		chance = 0.5,
	},
	{
		item = "nightmarefuel",
		count = math.random(5, 10),
		chance = 0.75,
	},
	{
		item = {"redgem", "bluegem", "purplegem"},
		count = math.random(3, 6),
		chance = 0.66,
	},
	{
		item = {"yellowgem", "orangegem", "greengem"},
		count = math.random(3, 6),
		chance = 0.45,
	},
	{
		item = "gears",
		count = math.random(3, 6),
		chance = 0.33,
	},
}
function AddLootChestItems(srcLoot)
	return AddLootItems(srcLoot, items, 9)
end
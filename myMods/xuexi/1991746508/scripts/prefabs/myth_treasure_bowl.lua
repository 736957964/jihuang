local assets=
{
	Asset("ANIM", "anim/myth_treasure_bowl.zip"),
}

local prefabs = 
{
	"goldnugget",
}

local giant_loot2 = --特殊蓝图
{
    "dragonflyfurnace_blueprint",
    "red_mushroomhat_blueprint",
    "green_mushroomhat_blueprint",
    "blue_mushroomhat_blueprint",
    "mushroom_light2_blueprint",
    "mushroom_light_blueprint",
    "townportal_blueprint",
    "bundlewrap_blueprint",
	"trident_blueprint",
}

local giant_loot1 =
{
    "tools_blueprint",
    "light_blueprint",
    "survival_blueprint",
    "farm_blueprint",
    "science_blueprint",
    "war_blueprint",
    "town_blueprint",
    "refine_blueprint",
    "magic_blueprint",
    "dress_blueprint",
}

local itemslist = {
	prize1 = {"goldnugget","townportaltalisman","myth_lotus_flower","pig_skin","beefalowool","myth_coin","manrabbit_tail","nitre"},
	
	prize2 = {"gears","boneshard","livinglog","fireflies","mole","horn"},
	
	prize3 = {"gourd","wobster_sheller_land","myth_bamboo_shoots","dug_marsh_bush","steelwool","carrot_oversized","corn_oversized","pumpkin_oversized","eggplant_oversized",
				"durian_oversized","pomegranate_oversized","dragonfruit_oversized ","watermelon_oversized","tomato_oversized",
				"potato_oversized","asparagus_oversized","onion_oversized","garlic_oversized","pepper_oversized",
			
			},
	
	prize4 = {"gourd_oversized","lightninggoathorn","phlegm","slurper_pelt","walrus_tusk","pig_coin",
				"honeycomb","butter","movemountain_pill","fly_pill'","bloodthirsty_pill","condensed_pill","armor_pill",
				"nitre","siving_rocks","waterplant_bomb",
			    "purplegem","bluegem","redgem","orangegem","yellowgem","greengem",
			},
	
			-- 金蝉*3
	prize5 = {"book_gardening", "specil_blueprint","fossil_piece","armorsnurtleshell","myth_redlantern","mandrake","nightsword","armor_sanity","cane",
				"myth_mooncake_nuts","myth_mooncake_lotus","myth_mooncake_ice","thorns_pill","myth_huanhundan","myth_coin_box","ruins_bat","ruinshat","armorruins","oceantreenut",
			},
			--小金蟾*6
	prize6 = {"bigpeach","opalpreciousgem","dragon_scales","deerclops_eyeball","shroom_skin","bearger_fur",
				"shadowheart","hivehat","minotaurhorn","gnarwail_horn","malbatross_beak","krampus_sack","myth_small_goldfrog",
				"pill_bottle_gourd_bb","myth_mooncake_box","siving_hat","armorsiving","myth_greenbamboo",
			},
	
	prize7 = {"dust_resistant_pill","cold_resistant_pill","heat_resistant_pill","purple_gourd",
			"myth_rhino_redheart","myth_rhino_blueheart","myth_rhino_yellowheart",
	},
}

local shengwu = {
	rabbit = true,
	wobster_sheller_land = true,
	mole = true,
	myth_small_goldfrog = true,
	oceantreenut = true,
}

local fnfnfn = {
	myth_mooncake_box = function(inst)
		if inst.components.container then
			inst.components.container:GiveItem(SpawnPrefab("myth_mooncake_nuts"))
			inst.components.container:GiveItem(SpawnPrefab("myth_mooncake_lotus"))
			inst.components.container:GiveItem(SpawnPrefab("myth_mooncake_ice"))
		end
	end
}
local prizevalues = 
{
	prize1 = 0.5,
	prize2 = 0.3,
	prize3 = 0.1,
	prize4 = 0.05,
	prize5 = 0.03,
	prize6 = 0.015,
	prize7 = 0.005,
}

local function launchitem(item)
    local speed = math.random() * 3 + 2
    local angle = math.random(360) * DEGREES
    item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
end

local function OnGetItemFromPlayer(inst, giver, item)
	inst.SoundEmitter:PlaySound("Myth_ghg/sfx/mythcoin")
	inst:DoTaskInTime(0.5, function(inst) 
	local prizevalue = weighted_random_choice(prizevalues)
	if prizevalue and itemslist[prizevalue] ~= nil then
		local items = itemslist[prizevalue]
	
		local prefab = items[math.random(#items)]
		
		if  prefab == "specil_blueprint" then
			prefab = giant_loot2[math.random(#giant_loot2)]
		elseif prefab == "blueprint" then
			prefab = giant_loot1[math.random(#giant_loot1)]
		end
		local num = 1
		if prefab == "myth_small_goldfrog" then
			num = 6
		elseif prefab == "nitre" then
			num = prizevalue == "prize1" and 1 or 3
		elseif prefab == "waterplant_bomb" then
			num = 5
		end
		for k =1,num do
			local item = SpawnPrefab(prefab)
			if item then
				if shengwu[prefab] or string.find(prefab,"oversized")  then
					local down = TheCamera:GetDownVec()
					local spawnangle = math.atan2(down.z, down.x)
					local angle = math.atan2(down.z, down.x) + (math.random()*90-45)*DEGREES
					local sp = math.random()*1+1			
					local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(1*math.cos(spawnangle), 0, 1*math.sin(spawnangle))
					pt = pt + Vector3(sp*math.cos(angle), 0, sp*math.sin(angle))
					item.Transform:SetPosition(pt:Get())
					SpawnPrefab("collapse_small").Transform:SetPosition(pt:Get())				
					if (item:HasTag("mole") or item:HasTag("rabbit")) and item.sg then
						item.sg:GoToState("stunned")
					end			
				else
					local x, y, z = inst.Transform:GetWorldPosition()
					item.Transform:SetPosition(x,2.1,z)
					if prefab == "fireflies" then
						local fx = SpawnPrefab("myth_yylp_fx")
						fx.Transform:SetPosition(x,1.5,z)
						fx:ListenForEvent("animover", fx.Remove)
					end
					launchitem(item)
				end

				if fnfnfn[prefab] ~= nil then
					fnfnfn[prefab](item)
				end
			end
		end
	end
	end)
end

local function addjbp(inst)
	table.insert(TUNING.MYTH_TREASURE_BOWL,inst)
end

local function fn(Sim)
    
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
	
    inst.Transform:SetScale(1.4,1.4,1.4)
    
    inst.AnimState:SetBank("myth_treasure_bowl")
    inst.AnimState:SetBuild("myth_treasure_bowl")
    inst.AnimState:PlayAnimation("idle")

    inst.MiniMapEntity:SetIcon("myth_treasure_bowl.tex")
    inst.MiniMapEntity:SetPriority(4)
    inst.entity:SetPristine()
	
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

	MakeObstaclePhysics(inst, .8,0.5)
	
    if not TheWorld.ismastersim then
        return inst
    end		
	
    inst:AddComponent("inspectable")

    inst:AddComponent("trader")
	
	inst:AddComponent("locomotor")

	inst.components.trader:SetAcceptTest(
		function(inst, item, giver)	
			return item and (item.prefab == "lucky_goldnugget" or item.prefab == "myth_coin" )
		end)

    inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader:Enable()
  
	addjbp(inst)
    return inst
end

return Prefab( "myth_treasure_bowl", fn, assets, prefabs) 

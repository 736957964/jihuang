

local function nofueled(inst)
	if inst.prefab == "thorns_pill" then
		inst:Remove()
	else
		inst.components.fueled:StopConsuming()
		inst:RemoveTag(inst.prefab)
	end
end

local function check(inst)
	if  inst.components.fueled:GetPercent() > 0 then
		--inst.components.fueled:StartConsuming()
		inst:AddTag(inst.prefab)
	else
		nofueled(inst)
	end
end

local buffs = {"fly_pill_buff","bloodthirsty_pill_buff","condensed_pill_buff","armor_pill_buff"}
local function removeotherbuff(inst,neglect)
	for i,v in ipairs(buffs) do
		if inst.components.debuffable:HasDebuff(v) then
			inst.components.debuffable:RemoveDebuff(v)
		end
	end
	if neglect ~= nil and inst.components.debuffable:HasDebuff(neglect) then
		inst.components.debuffable:RemoveDebuff(neglect)
	end
end

local function makepill(name,caneat,fueled,stackable,neglect)
	
	local assets =
	{
		Asset("ANIM", "anim/mk_pills.zip"),
		Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
	}

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank("mk_pills")
		inst.AnimState:SetBuild("mk_pills")
		inst.AnimState:PlayAnimation(name)
		inst:AddTag("mk_pills")
		
		inst:AddTag("preparedfood")
		MakeInventoryFloatable(inst)
		
		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
		
		if caneat then
			inst:AddComponent("edible")
			inst.components.edible.foodtype = FOODTYPE.GOODIES
			inst.components.edible.hungervalue = 0
			if name == "bloodthirsty_pill" then
				inst.components.edible.healthvalue = -40
				inst.components.edible.sanityvalue = -50
			else
				inst.components.edible.healthvalue = 0
			end
			inst.components.edible.oneaten = function(inst,eater)
				if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
					not (eater.components.health ~= nil and eater.components.health:IsDead()) and
					not eater:HasTag("playerghost") then
					local neglect = neglect or nil
					removeotherbuff(eater,neglect) --移除旧的buff
					eater.components.debuffable:AddDebuff(name.."_buff", name.."_buff")
				end
			end
		end
		
		inst:AddComponent("tradable")

		inst:AddComponent("inspectable")

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

		if fueled then
			inst:AddComponent("fueled")
			inst.components.fueled:InitializeFuelLevel(name == "thorns_pill" and TUNING.CHESTER_RESPAWN_TIME*15 or TUNING.CHESTER_RESPAWN_TIME*81)
			inst.components.fueled:SetDepletedFn(nofueled)	
			inst.components.fueled:StartConsuming()
			inst:DoTaskInTime(0, check)
		end
		if stackable then
			inst:AddComponent("stackable")
			inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
		end
		MakeHauntableLaunch(inst)

		return inst
	end
	return Prefab(name, fn, assets)
end

return  makepill("heat_resistant_pill",false,true), --避火
		makepill("cold_resistant_pill",false,true), --避水
		makepill("dust_resistant_pill",false,true), --避尘
		makepill("fly_pill",true,false,true), --腾云
		makepill("bloodthirsty_pill",true,false,true), --嗜血
		makepill("condensed_pill",true,false,true,"buff_attack"),--会心
		makepill("armor_pill",true,false,true,"buff_playerabsorption"), --壮骨
		--makepill("detoxic_pill",true,false,true), --化毒 联机不用了
		makepill("thorns_pill",false,true), --荆棘
		makepill("movemountain_pill",true,false,true) --移山
local buff_assets = {
	Asset( "ATLAS", "images/bufficons/bloodthirsty.xml" ),
	Asset( "IMAGE", "images/bufficons/bloodthirsty.tex" ),

	Asset( "ATLAS", "images/bufficons/broken.xml" ),
	Asset( "IMAGE", "images/bufficons/broken.tex" ),

	Asset( "ATLAS", "images/bufficons/calm.xml" ),
	Asset( "IMAGE", "images/bufficons/calm.tex" ),

	Asset( "ATLAS", "images/bufficons/charged.xml" ),
	Asset( "IMAGE", "images/bufficons/charged.tex" ),

	Asset( "ATLAS", "images/bufficons/cool.xml" ),
	Asset( "IMAGE", "images/bufficons/cool.tex" ),

	Asset( "ATLAS", "images/bufficons/donotstarve.xml" ),
	Asset( "IMAGE", "images/bufficons/donotstarve.tex" ),

	Asset( "ATLAS", "images/bufficons/doubles_work.xml" ),
	Asset( "IMAGE", "images/bufficons/doubles_work.tex" ),

	Asset( "ATLAS", "images/bufficons/electric_field.xml" ),
	Asset( "IMAGE", "images/bufficons/electric_field.tex" ),

	Asset( "ATLAS", "images/bufficons/freeze.xml" ),
	Asset( "IMAGE", "images/bufficons/freeze.tex" ),

	Asset( "ATLAS", "images/bufficons/glow.xml" ),
	Asset( "IMAGE", "images/bufficons/glow.tex" ),

	Asset( "ATLAS", "images/bufficons/gnaw.xml" ),
	Asset( "IMAGE", "images/bufficons/gnaw.tex" ),

	Asset( "ATLAS", "images/bufficons/hard.xml" ),
	Asset( "IMAGE", "images/bufficons/hard.tex" ),

	Asset( "ATLAS", "images/bufficons/increase_attack_power.xml" ),
	Asset( "IMAGE", "images/bufficons/increase_attack_power.tex" ),

	Asset( "ATLAS", "images/bufficons/infirmus.xml" ),
	Asset( "IMAGE", "images/bufficons/infirmus.tex" ),

	Asset( "ATLAS", "images/bufficons/regenerating _sanity.xml" ),
	Asset( "IMAGE", "images/bufficons/regenerating _sanity.tex" ),

	Asset( "ATLAS", "images/bufficons/regenerating_health.xml" ),
	Asset( "IMAGE", "images/bufficons/regenerating_health.tex" ),

	Asset( "ATLAS", "images/bufficons/slow_down.xml" ),
	Asset( "IMAGE", "images/bufficons/slow_down.tex" ),

	Asset( "ATLAS", "images/bufficons/swift.xml" ),
	Asset( "IMAGE", "images/bufficons/swift.tex" ),

	Asset( "ATLAS", "images/bufficons/undead.xml" ),
	Asset( "IMAGE", "images/bufficons/undead.tex" ),

	Asset( "ATLAS", "images/bufficons/warm.xml" ),
	Asset( "IMAGE", "images/bufficons/warm.tex" ),

	Asset( "ATLAS", "images/bufficons/wetness_immunity.xml" ),
	Asset( "IMAGE", "images/bufficons/wetness_immunity.tex" ),

	Asset( "ATLAS", "images/bufficons/mountain_shaking.xml" ),
	Asset( "IMAGE", "images/bufficons/mountain_shaking.tex" ),

	Asset( "ATLAS", "images/bufficons/dust.xml" ),
	Asset( "IMAGE", "images/bufficons/dust.tex" ),

	Asset( "ATLAS", "images/bufficons/thorns.xml" ),
	Asset( "IMAGE", "images/bufficons/thorns.tex" ),

	Asset( "ATLAS", "images/bufficons/immunewater.xml" ),
	Asset( "IMAGE", "images/bufficons/immunewater.tex" ),

	Asset( "ATLAS", "images/bufficons/immunefire.xml" ),
	Asset( "IMAGE", "images/bufficons/immunefire.tex" ),

	Asset( "ATLAS", "images/bufficons/deathheart.xml" ),
	Asset( "IMAGE", "images/bufficons/deathheart.tex" ),

	Asset( "ATLAS", "images/bufficons/iceshield.xml" ),
	Asset( "IMAGE", "images/bufficons/iceshield.tex" ),

	Asset( "ATLAS", "images/bufficons/immuneice.xml" ),
	Asset( "IMAGE", "images/bufficons/immuneice.tex" ),

	Asset( "ATLAS", "images/bufficons/insomnia.xml" ),
	Asset( "IMAGE", "images/bufficons/insomnia.tex" ),

	Asset( "ATLAS", "images/bufficons/promote_health.xml" ),
	Asset( "IMAGE", "images/bufficons/promote_health.tex" ),
	Asset( "ATLAS", "images/bufficons/promote_hunger.xml" ),
	Asset( "IMAGE", "images/bufficons/promote_hunger.tex" ),
	Asset( "ATLAS", "images/bufficons/promote_sanity.xml" ),
	Asset( "IMAGE", "images/bufficons/promote_sanity.tex" ),

	Asset( "ATLAS", "images/bufficons/stench.xml" ),
	Asset( "IMAGE", "images/bufficons/stench.tex" ),
}

for k,v in pairs(buff_assets) do 
	table.insert(Assets,v)
end 

-- MythBuffBar类的一些操作：

-- AddBuff 新增一个buffui
-- 参数说明：
-- name:索引名，字符串类型。我一般把buff实体的prefab名当做索引。如果没有buff实体或者不想的话，你也可以任取，只要不重复或者别太离谱就行。
-- image_name:图片名，字符串类型。ui会根据此名字自动将 "images/bufficons/"..image_name 的相关文件用作ui图片
-- desc_name:描述名，字符串类型。用于显示ui的描述名字 例如 "嗜血"
-- time_remain:剩余时间，整型。用于显示buff的剩余时间
-- ent:buff实体，entity型。用于绑定客机的buff实体，可以为空。如果不为空，在ent被remove后，对应的buff ui会自动移除。这个功能在MakeMythBuffTimeShow已经实现。
-- player.HUD.controls.MythBuffBar:AddBuff(name,image_name,desc_name,time_remain,ent)

-- UpdateBuff 更新一个buffui的数据
-- 参数说明：
-- name:索引名，字符串类型。你需要更新数据的buff索引名，详见AddBuff
-- image_name:图片名，字符串类型。用于更新buff贴图
-- desc_name:描述名，字符串类型。用于更新buff描述
-- time_remain:剩余时间，整型。用于更新buff剩余时间
-- player.HUD.controls.MythBuffBar:UpdateBuff(name,image_name,desc_name,time_remain)

-- RemoveBuff 移除一个buffui
-- 参数说明：
-- name:索引名，字符串类型。你需要移除的buff索引名，详见AddBuff
-- delay:动画延时，浮点数类型。表示buffui缩小移除消失所需时间，可以为空，默认为0.33秒
-- player.HUD.controls.MythBuffBar:RemoveBuff(name,delay)

local function UpdateBuffTask(inst)
	local parent = inst._myth_buff_owner:value()
	if parent and parent:IsValid() and parent.HUD and parent.HUD.controls and parent.HUD.controls.MythBuffBar then 
		if inst._myth_buff_attached:value() then 
			parent.HUD.controls.MythBuffBar:UpdateBuff(inst.prefab,inst._myth_buff_image_name:value(),inst._myth_buff_name:value(),inst._myth_buff_remain:value())
		end 
	end
end

local function UpdateAttachedTask(inst)
	local parent = inst._myth_buff_owner:value()
	if parent and parent:IsValid() and parent.HUD and parent.HUD.controls and parent.HUD.controls.MythBuffBar then 
		if inst._myth_buff_attached:value() then 
			parent.HUD.controls.MythBuffBar:AddBuff(inst.prefab,inst._myth_buff_image_name:value(),inst._myth_buff_name:value(),inst._myth_buff_remain:value())
		else
			-- print("UpdateAttachedTask removeing",inst)
			parent.HUD.controls.MythBuffBar:RemoveBuff(inst.prefab)
		end
	end
end

-- data参数表：
-- timer_name:使用timer组件做cd计算时，使用的StartTimer的第一个参数名字。默认为"regenover"
-- display:自定义显示buff名字的函数。该值为字符串时，就直接表示buff名字。默认为buff实体的name或者prefab
-- image:自定义显示buff图标名字的函数。该值为字符串时，就直接表示buff图标名字。默认为inst.prefab
-- remain:自定义显示buff剩余时间的函数。如果写了timer_name就可以置空
GLOBAL.MakeMythBuffTimeShow = function(inst,data)
	-- print("MakeBuffTimeShow",inst)

	inst._myth_buff_attached = net_bool(inst.GUID,"inst._myth_buff_attached","mythbuff_attached")
	inst._myth_buff_owner = net_entity(inst.GUID,"inst._myth_buff_owner","mythbuff_owner")
	inst._myth_buff_name = net_string(inst.GUID,"inst._myth_buff_name","mythbuff_updated")
	inst._myth_buff_image_name = net_string(inst.GUID,"inst._myth_buff_image_name","mythbuff_updated")
	inst._myth_buff_remain = net_shortint(inst.GUID,"inst._myth_buff_remain","mythbuff_updated")

	if not TheNet:IsDedicated() then 
		inst:ListenForEvent("mythbuff_updated",UpdateBuffTask)
		inst:ListenForEvent("mythbuff_attached",UpdateAttachedTask)

		-- 如果在主机的buff实体移除后，即便把inst._myth_buff_attached设置为false也无法让ui消失
		-- 直接在客机监听客机实体移除，才能让ui消失
		inst:ListenForEvent("onremove",function()
			inst._myth_buff_attached:set(false)
			UpdateAttachedTask(inst)
		end)
	end

	if not TheWorld.ismastersim then
		return
	end

	local function DoDetachedTask(inst)
		-- print("DoDetachedTask",inst)
		if inst.BuffTimeShowTask then 
			inst.BuffTimeShowTask:Cancel()
			inst.BuffTimeShowTask = nil 
		end 
		inst._myth_buff_attached:set(false)
	end

	inst.BuffTimeShowTask = inst:DoPeriodicTask(0.1,function()
		local time_remain = (data.remain and data.remain(inst)) 
			or (inst.components.timer and inst.components.timer:GetTimeLeft(data.timer_name or "regenover")) 
			or -1
		local name = (data.display and (type(data.display) == "function" and data.display(inst,time_remain) or tostring(data.display)))
			 or inst.name 
			 or inst.prefab 
			 or "NAMELESS MYTH BUFF"
		local image_name = (data.image and (type(data.image) == "function" and data.image(inst,time_remain) or tostring(data.image))) or inst.prefab 


		inst._myth_buff_name:set(name)
		inst._myth_buff_image_name:set(image_name)
		inst._myth_buff_remain:set(time_remain)

		local owner = inst.components.debuff and inst.components.debuff.target
		if owner and owner:IsValid() then 
			inst._myth_buff_owner:set(owner)
			inst._myth_buff_attached:set(true)
		else
			-- print(inst,"BuffTimeShowTask detached....")
			DoDetachedTask(inst)
		end
	end)

	inst:ListenForEvent("onremove",function()
		-- print(inst,"Server onremove....")
		DoDetachedTask(inst)
	end)
end

local buff_show_data = {
	fly_pill_buff = { image = "swift", display = STRINGS.NAMES.BUFF_M_LOCO_UP },
	bloodthirsty_pill_buff = { image="bloodthirsty", display = STRINGS.NAMES.BUFF_M_BLOODSUCK },
	condensed_pill_buff = { image = "increase_attack_power", display = STRINGS.NAMES.BUFF_M_ATK_UP },
	armor_pill_buff = { image = "hard", display = STRINGS.NAMES.BUFF_M_DEF_UP },
	myth_zpd_buff = { image = "undead", display = STRINGS.NAMES.BUFF_M_UNDEAD },
	myth_freezebuff = { image = "freeze", display = STRINGS.NAMES.BUFF_M_ATK_ICE },
	myth_mooncake_nutsbuff = { image = "donotstarve", display = STRINGS.NAMES.BUFF_M_HUNGER_STAY },
	myth_mooncake_icebuff = { image = "calm", display = STRINGS.NAMES.BUFF_M_SANITY_STAY },
	myth_mooncake_lotusbuff = { image = "gnaw", display = STRINGS.NAMES.BUFF_M_HUNGER_STRONG },

	movemountain_pill_buff = { image = "mountain_shaking", display = STRINGS.NAMES.BUFF_M_STRENGTH_UP },
	myth_flyerfx_wheel_buff = { image = "immunefire", display = STRINGS.NAMES.BUFF_M_IMMUNE_FIRE },
	myth_food_fhy_buff = { image = "immunewater", display = STRINGS.NAMES.BUFF_M_IMMUNE_WATER },

	myth_rhino_redbuff = { image = "warm", display = STRINGS.NAMES.BUFF_M_WARM },
	myth_rhino_bluebuff = { image = "cool", display = STRINGS.NAMES.BUFF_M_COOL },
	myth_rhino_yellowbuff = { image = "dust", display = STRINGS.NAMES.BUFF_M_DUST },

	myth_sanity_regenbuff = { timer_name = "buffover", image = "regenerating _sanity", display = STRINGS.NAMES.BUFF_M_SANITY_REGEN },
	buff_m_workup = { timer_name = "buffover", image = "doubles_work", display = STRINGS.NAMES.BUFF_M_WORKUP },
	buff_m_insomnia = { timer_name = "buffover", image = "insomnia", display = STRINGS.NAMES.BUFF_M_INSOMNIA },
	buff_m_fireimmune = { timer_name = "buffover", image = "immunefire", display = STRINGS.NAMES.BUFF_M_IMMUNE_FIRE },
	buff_m_iceimmune = { timer_name = "buffover", image = "immuneice", display = STRINGS.NAMES.BUFF_M_IMMUNE_ICE },
	buff_m_iceshield = { timer_name = "buffover", image = "iceshield", display = STRINGS.NAMES.BUFF_M_ICESHIELD },
	buff_m_atkelec = { timer_name = "buffover", image = "electric_field", display = STRINGS.NAMES.BUFF_M_ATK_ELEC },
	buff_m_glow = { timer_name = "buffover", image = "glow", display = STRINGS.NAMES.BUFF_M_GLOW },
	buff_m_regenhealth = { timer_name = "buffover", image = "regenerating_health", display = STRINGS.NAMES.BUFF_M_HEALTH_REGEN },
}

for prefab,data in pairs(buff_show_data) do
	AddPrefabPostInit(prefab,function(inst)
        MakeMythBuffTimeShow(inst,data)

		if not TheWorld.ismastersim then
			return inst
		end
	end)
end

-- 身上有某样物品时触发buff ui，虽然本身算不上buff
local conditions_item_data = {
    -- image:buff图标文件名
    -- display:显示的buff名字

    -- 避寒 避暑 避尘 荆棘 丹药依靠特定tags发挥作用，所以不能光靠物品在身上判断buff 固移除。
	-- cold_resistant_pill = {image = "warm",display = "避寒"},
	-- heat_resistant_pill = {image = "cool",display = "避暑"},

	-- dust_resistant_pill = {image = "dust",display = "避尘"},
	-- thorns_pill = {image = "thorns",display = "荆棘"},
}


-- 带有特定tags的物品戴在身上时触发buff ui
local conditions_tag_data = {
	cold_resistant_pill = { image = "warm", display = STRINGS.NAMES.BUFF_M_WARM },
	heat_resistant_pill = { image = "cool", display = STRINGS.NAMES.BUFF_M_COOL },
	dust_resistant_pill = { image = "dust", display = STRINGS.NAMES.BUFF_M_DUST },
	thorns_pill = { image = "thorns", display = STRINGS.NAMES.BUFF_M_THORNS },
}

local function FnOrStrVal(val,... )
	return type(val) == "function" and val(...) or tostring(val)
end

local function CalcConditionItems(inst)
	if inst.HUD and inst.HUD.controls and inst.HUD.controls.MythBuffBar then 
		for prefab,data in pairs(conditions_item_data) do 
			if not inst.HUD.controls.MythBuffBar:HasBuff(prefab) and inst.replica.inventory:Has(prefab,1) then 
				local image_name = FnOrStrVal(data.image,inst,prefab)
				local desc_name = FnOrStrVal(data.display,inst,prefab)
				inst.HUD.controls.MythBuffBar:AddBuff(prefab,image_name,desc_name,-1,nil)
			elseif inst.HUD.controls.MythBuffBar:HasBuff(prefab) and not inst.replica.inventory:Has(prefab,1) then 
				inst.HUD.controls.MythBuffBar:RemoveBuff(prefab)
			end 
		end
	end
end

local function CalcConditionTags(inst)
	if inst.HUD and inst.HUD.controls and inst.HUD.controls.MythBuffBar then 
		for tag,data in pairs(conditions_tag_data) do 
			if not inst.HUD.controls.MythBuffBar:HasBuff(tag) and inst.replica.inventory:HasItemWithTag(tag,1) then 
				local image_name = FnOrStrVal(data.image,inst,tag)
				local desc_name = FnOrStrVal(data.display,inst,tag)
				inst.HUD.controls.MythBuffBar:AddBuff(tag,image_name,desc_name,-1,nil)
			elseif inst.HUD.controls.MythBuffBar:HasBuff(tag) and not inst.replica.inventory:HasItemWithTag(tag,1) then 
				inst.HUD.controls.MythBuffBar:RemoveBuff(tag)
			end 
		end
	end
end

AddPlayerPostInit(function(inst)
	if not TheNet:IsDedicated() then 
		-- 监听itemget itemlose的方法无法顾及背包，增加背包监听太麻烦，直接一个0.33秒循环检测就好了，还可以防止ui错乱
		inst._CalcConditionItemsTask = inst:DoPeriodicTask(0.33,CalcConditionItems)
		inst._CalcConditionTagsTask = inst:DoPeriodicTask(0.33,CalcConditionTags)
	end 
	if not TheWorld.ismastersim then
		return inst
	end
end)


local MythBuffBar = require("widgets/mythbuffbar")
AddClassPostConstruct("widgets/controls",function(self,owner)
	self.MythBuffBar = self:AddChild(MythBuffBar(self.owner))
	self.MythBuffBar:SetPosition(250,-50)
end)

GLOBAL.c_pills = function()
    -- medicine_pestle_myth
	local list = {
		fly_pill = 10,
		bloodthirsty_pill  = 10,
		condensed_pill = 10,
		armor_pill = 10,
		myth_mooncake_nuts = 3,
		myth_mooncake_ice = 3,
		myth_mooncake_lotus = 3,
		myth_food_zpd = 3,
	}
	for k,v in pairs(list) do
		c_give(k,v)
	end
end

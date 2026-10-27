local assets=
{
	Asset("ANIM", "anim/laozi.zip"),
	Asset("SOUND", "sound/pig.fsb"),
}

local prefabs = 
{
	"goldnugget",
}

local LootTable = {
    featherfan = {bananafan = 1}, 
    tropicalfan = {bananafan = 1},

    amulet = {armor_pill = 3},
    blueamulet = {fly_pill = 3},
    purpleamulet = {bloodthirsty_pill = 3},

    ruinshat = {ruinshat = 1},
    armorruins = {armorruins = 1},
    ruins_bat = {ruins_bat = 1},

    nz_wheel = {nz_wheel = 1},
    golden_armor_mk = {golden_armor_mk = 1},
    golden_hat_mk = {golden_hat_mk = 1},
	
    yangjian_hair = {yangjian_hair = 1},
    yangjian_armor = {yangjian_armor = 1},
	
    deerclops_eyeball = {randompill = 1}, 
    dragon_scales = {randompill = 3},
    bearger_fur = {randompill = 1},
	shadowheart = {randompill = 2},
	shroom_skin = {randompill = 3},
	
	hivehat = {randompill = 3},
	malbatross_beak = {randompill = 1},

	armorsiving = {armorsiving = 1},
	siving_hat = {siving_hat = 1},
    reviver = {myth_huanhundan = 1},
}


local specific_trading = {

    laozi_bell = function(inst, giver, item, pos)
        item:Remove()
        local beef = SpawnPrefab("laozi_qingniu")
        local targpos = pos + Vector3(GetRandomMinMax(-4,4), 0, GetRandomMinMax(-4,4))
        beef.Transform:SetPosition(targpos:Get())
        local fx = SpawnPrefab('mk_cloudpuff')
        fx.Transform:SetScale(1,1,1)
        fx.Transform:SetPosition(targpos:Get())

        local beel = SpawnPrefab("laozi_bell")
        beel.components.useabletargeteditem:StartUsingItem(beef, giver)
        if giver.components.inventory then
            giver.components.inventory:GiveItem(beel)
        end
        inst.components.talker:Say(STRINGS.LAOZI.F)
    end,

}

local randompills = {
    "fly_pill",
    "bloodthirsty_pill",
    "condensed_pill",
    --"detoxic_pill",
    "armor_pill",
}


--哪些角色限制交易呢？
local banchar = {
    white_bone = true,
    wx78 = true,
    wortox = true,
    wormwood = true,
    wurt = true,
}

local function OnGetItemFromPlayer(inst, giver, item)
    local pos = inst:GetPosition()
    local prefab = item and item.prefab
    local skin = item and item:GetSkinName()
    local skin_id = item and item.skin_id
    local loots = prefab and LootTable[prefab]
    if loots then
		item:Remove()
        for name, num in pairs(loots)do
            for i = 1, num do
                local item
                if name == 'randompill' then
                    item = SpawnPrefab(randompills[math.random(#randompills)])
                elseif name == 'nz_wheel' then
                    item = SpawnPrefab(name)
                    item.components.fueled:SetPercent(1)
                    item:SetHot()
                else
                    --设置皮肤
                    if name == prefab and skin and skin_id then
                        item = SpawnPrefab(name, skin, skin_id)
                    else
                        item = SpawnPrefab(name)
                    end
                end

                if item then
                    local targpos = pos + Vector3(GetRandomMinMax(-4,4), 0, GetRandomMinMax(-4,4))
                    item.Transform:SetPosition(targpos:Get())
                    local fx = SpawnPrefab('mk_cloudpuff')
                    fx.Transform:SetScale(.6,.6,.6)
                    fx.Transform:SetPosition(targpos:Get())
                end
            end
        end
        if giver.userid ~= nil then
            table.insert(inst.trader_list, giver.userid)
        end
		if #inst.trader_list > 2 then
			inst:DoTaskInTime(1, inst.Despawn)
		end
    elseif specific_trading[prefab] ~= nil then
        specific_trading[prefab](inst, giver, item, pos)
        if giver.userid ~= nil then
            table.insert(inst.trader_list, giver.userid)
        end
		if #inst.trader_list > 2 then
			inst:DoTaskInTime(1, inst.Despawn)
		end
	end
    if giver and banchar[giver.prefab] and giver.components.inventory:HasItemWithTag("myth_passcard_jie", 1)  then
        inst.components.talker:Say("好一个有教无类.")
    end
end

local function CanAccept(inst, item, giver)
    if giver and banchar[giver.prefab] and not (giver.components.inventory:HasItemWithTag("myth_passcard_jie", 1))  then
        return false
    end
    if #inst.trader_list > 2  then
        inst.components.talker:Say(STRINGS.LAOZI.D)	
        return false
    elseif giver.userid and table.contains(inst.trader_list, giver.userid) then
        inst.components.talker:Say(STRINGS.LAOZI.A)
        return false
    end		
    return item and item.prefab and (LootTable[item.prefab] ~= nil or specific_trading[item.prefab] ~= nil )
end

local function OnRefuseItem(inst, giver, item)
    if giver and banchar[giver.prefab] then
        inst.components.talker:Say(STRINGS.LAOZI.E)
        return
    end
end

local function OnAttacked(inst,data)
    if data.attacker and data.attacker:IsValid() then
        local pos = data.attacker.Transform and data.attacker:GetPosition()
        if pos then
			SpawnPrefab("lightning").Transform:SetPosition(pos:Get())
        end
        if data.attacker:HasTag("player") then --攻击者是玩家
			inst.components.talker:Say(data.attacker.prefab == "monkey_king" and "猴头，莫要胡闹" or STRINGS.LAOZI.B)
			--受到伤害
			if data.attacker.components.combat and data.attacker.components.health and not data.attacker.components.health:IsDead() then
				data.attacker.components.combat:GetAttacked(nil,30,nil,"lightning")
			end
            local weapon = data.attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if weapon then
                data.attacker.components.inventory:DropItem(weapon)
            end
		elseif data.attacker:HasTag("companion") then
			inst.components.talker:Say(STRINGS.LAOZI.C)
			if data.attacker.components.health and  not data.attacker.components.health:IsDead() then
				data.attacker.components.health:Kill()
			end
		else--其他生物
			inst.components.talker:Say(STRINGS.LAOZI.C)
			if not data.attacker:HasTag("yj_spear") then
				data.attacker:DoTaskInTime(0.1, data.attacker.Remove)
			end
			--移除
        end
    end
end

local function onsave(inst, data)
    data.trader_list = inst.trader_list
end
local function onload(inst, data)
	if data and data.trader_list then
		inst.trader_list =  data.trader_list
	end
end

local function Despawn(inst)
    if inst.persists == false then
        return
    end
    local fx = SpawnPrefab('mk_cloudpuff')
    fx.Transform:SetScale(2.2,2.2,2.2)
    fx.Transform:SetPosition(inst:GetPosition():Get())

    inst.persists = false
    inst:AddTag("NOCLICK")
    inst:AddTag("notarget")
    inst:AddComponent('colourtweener')
    inst.components.colourtweener:StartTween({1,1,1,0},1,inst.Remove)
    inst.components.mk_cloudfxspawner:StartTween({1,1,1,0},0.8)
end

local hua = {
	"大圣，唤老夫有何贵干",
	"大圣，别来无恙",
	"大圣，这金箍棒用的可还顺手？",
}
local function onnear(inst,player)
	if player and player.prefab == "monkey_king" and math.random() < 0.2 then
		inst.components.talker:Say(hua[math.random(3)])
	end
end
local function fn(Sim)
    
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
    inst.entity:AddMiniMapEntity()
	inst.DynamicShadow:SetSize( 10, 5 )
    inst.entity:AddNetwork()
	
    inst.Transform:SetScale(0.66,0.66,0.66)
    
    inst.AnimState:SetBank("laozi")
    inst.AnimState:SetBuild("laozi")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.colour = Vector3(255/255, 255/255, 20/255)
    inst.components.talker.offset = Vector3(0,-800,0)
	
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	--inst.AnimState:SetLightOverride(1)

    inst.MiniMapEntity:SetIcon("laozi.tex")
    inst.MiniMapEntity:SetPriority(4)
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end	
	
    inst.trader_list = {}
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("health")
    inst.components.health.canheal = false
    inst.components.health.absorb = 1
    inst.components.health:SetInvincible(true)

    inst:AddComponent("combat")
    
	inst:ListenForEvent('blocked', OnAttacked)
    inst:ListenForEvent('attacked', OnAttacked)

    inst:AddComponent("trader")

    inst:AddComponent("mk_cloudfxspawner")
    inst.components.mk_cloudfxspawner.laozi = true

	inst.components.trader:SetAcceptTest(CanAccept)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
	inst.components.trader.deleteitemonaccept = false
	inst.components.trader:Enable()
	
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetDist(4, 6)

    inst:AddComponent('timer')
    inst:ListenForEvent('timerdone', Despawn)
    inst.Despawn = Despawn
   
    inst.OnSave = onsave
    inst.OnLoad = onload   
    return inst
end

return Prefab( "common/objects/laozi", fn, assets, prefabs) 

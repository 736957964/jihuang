local assets =
{
    Asset("ANIM", "anim/myth_chang_e.zip"),
    Asset("ANIM", "anim/myth_chang_e_furniture.zip"),
}

local prefabs =
{
    "purplegem",
    "bluegem",
    "redgem",
    "orangegem",
    "yellowgem",
    "greengem",
    "opalpreciousgem",
	"bigpeach",
}

local values = {bigpeach = 50, opalpreciousgem = 20}
local cakes = {"myth_mooncake_ice","myth_mooncake_lotus","myth_mooncake_nuts"}

local yutuTradeItems = {
	mandrake = {
		recipename = "powder_m_hypnoticherb",
		giveback = true,
	},
	minotaurhorn = {
		recipename = "powder_m_lifeelixir",
		giveback = true,
	},
	lightninggoathorn = {
		recipename = "powder_m_charged",
		giveback = true,
	},
	royal_jelly = {
		recipename = "powder_m_improvehealth",
		giveback = true,
	},
	deerclops_eyeball = {
		recipename = "powder_m_coldeye",
		giveback = true,
	},
	wormlight = {
		recipename = "powder_m_becomestar",
		giveback = true,
	},
	sweettea = {
		recipename = "powder_m_takeiteasy",
		giveback = true,
	},

	hivehat = {
		recipename = "song_m_workup"
	},
	onemanband = {
		recipename = "song_m_insomnia"
	},
	dragon_scales = {
		recipename = "song_m_fireimmune"
	},
	heatrock = { --滚烫的热能石
		recipename = "song_m_iceimmune",
		fn_accepttest = function(change, yutu, item)
			return item.currentTempRange ~= nil and item.currentTempRange >= 5
		end
	},
	oceanfish_medium_8_inv = { --冰鲷鱼
		recipename = "song_m_iceshield"
	},

	spidereggsack = {
		recipename = "song_m_nocure"
	},
	featherfan = {
		recipename = "song_m_weakattack"
	},
	bearger_fur = {
		recipename = "song_m_weakdefense"
	},
	beefalohat = {
		recipename = "song_m_nolove"
	},
	panflute = {
		recipename = "song_m_sweetdream"
	},
}
yutuTradeItems.cookedmandrake = yutuTradeItems.mandrake
yutuTradeItems.dish_fleshnapoleon = yutuTradeItems.wormlight
yutuTradeItems.klaussackkey = yutuTradeItems.deerclops_eyeball
yutuTradeItems.icire_rock = { recipename = yutuTradeItems.heatrock.recipename }

local function givemooncake(inst, spawncake, giver)
	local spawncake = spawncake or cakes[math.random(#cakes)]
	local  cake = SpawnPrefab(spawncake)
	if cake then
		inst.components.inventory:GiveItem(cake, nil, giver:GetPosition())
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	inst.sg:GoToState("spell")

	local tradedata = yutuTradeItems[item.prefab]
	local value = nil
	if tradedata ~= nil then
		value = tradedata.giveback and 1 or 3
	else
		value = values[item.prefab] or 1
		if giver.prefab == "pigsy" then
			value = math.floor(value/2)
		end
		if giver.prefab == "myth_yutu" then
			value = value + 1
		end
	end

	if giver.components.myth_favorability then
		local old = giver.myth_tech_change_bonus or 0
		giver.components.myth_favorability:DoDelta(value)

		local new = giver.myth_tech_change_bonus
		if old ~= new and STRINGS.MYTHCEHAOGANDU[new] ~= nil then
			inst.components.talker:Say(STRINGS.MYTHCEHAOGANDU[new][string.upper(giver.prefab)] or STRINGS.MYTHCEHAOGANDU[new].GENERIC)
		end
		if giver.components.myth_favorability:IsMax() and not inst.firstmoonpan then
			local  myth_yylp = SpawnPrefab("myth_yylp")
			if myth_yylp and giver.components.inventory then 
				giver.components.inventory:GiveItem(myth_yylp, nil,inst:GetPosition())	
				givemooncake(giver,"myth_mooncake_ice",inst)
				givemooncake(giver,"myth_mooncake_ice",inst)
				givemooncake(giver,"myth_mooncake_ice",inst)
				givemooncake(giver,"myth_mooncake_nuts",inst)
				givemooncake(giver,"myth_mooncake_nuts",inst)
				givemooncake(giver,"myth_mooncake_nuts",inst)
			end
			inst.firstmoonpan = true
		end
	end

	if tradedata ~= nil then
		if giver.components.builder ~= nil and giver.components.builder:CanLearn(tradedata.recipename) then
			giver.components.builder:UnlockRecipe(tradedata.recipename)
			giver:PushEvent("learnrecipe", { teacher = inst, recipe = tradedata.recipename })

			local string = STRINGS.MKCETALK_YUTU[string.upper(tradedata.recipename)]
			if string ~= nil then
				inst.components.talker:Say(string.GENERIC)
			end
		end

		if tradedata.giveback then
			if giver.components.inventory ~= nil then
				giver.components.inventory:GiveItem(item, nil, inst:GetPosition())
			else
				local x, y, z = giver.Transform:GetWorldPosition()
				if item.Physics ~= nil then
					item.Physics:Teleport(x, y, z)
				else
					item.Transform:SetPosition(x, y, z)
				end
			end
			return
		elseif math.random() < 0.2 then
			givemooncake(giver, nil, inst)
		end
	else
		if item.prefab == "bigpeach" then
			givemooncake(giver, nil, inst)
			givemooncake(giver, nil, inst)
		elseif item.prefab == "opalpreciousgem" then
			givemooncake(giver, nil, inst)
		elseif math.random() < 0.1 then
			givemooncake(giver, nil, inst)
		end
		if giver.prefab == "myth_yutu" and math.random() < 0.1 then
			givemooncake(giver, nil, inst)
		end
	end

	item:Remove()
end

local function OnRefuseItem(inst, giver, item)
	if inst.trade_refuse_cause ~= nil and yutuTradeItems[item.prefab] ~= nil then
		local string = STRINGS.MKCETALK_YUTU[string.upper(yutuTradeItems[item.prefab].recipename)]
		if string ~= nil and string[inst.trade_refuse_cause] ~= nil then
			inst.components.talker:Say(string[inst.trade_refuse_cause])
			inst.sg:GoToState("refuse")
			inst.trade_refuse_cause = nil
			return
		end
	end

	inst.components.talker:Say(STRINGS.MYTHGHG_NOCURRENTITEM[string.upper(giver.prefab)] or STRINGS.MYTHGHG_NOCURRENTITEM.GENERIC)
    inst.sg:GoToState("refuse")
end

local function AcceptTest(inst, item, giver)
	if giver.prefab == "myth_yutu" and yutuTradeItems[item.prefab] ~= nil then
		local data = yutuTradeItems[item.prefab]

		if giver.components.builder ~= nil then
			if giver.components.builder:KnowsRecipe(data.recipename) then
				inst.trade_refuse_cause = "LEARNED"
				return false
			end
		else
			return false
		end

		if data.fn_accepttest ~= nil then
			if not data.fn_accepttest(inst, giver, item) then
				inst.trade_refuse_cause = "WRONGSTATE"
				return false
			end
		end
		return true
	end

	if string.sub(item.prefab, -3) == "gem" then
		return true
	elseif item.prefab == "bigpeach" then
		return true
	end

    return false
end

local function OnHaunt(inst, haunter)
    if inst.components.trader ~= nil and inst.components.trader.enabled then
        OnRefuseItem(inst)
        return true
    end
    return false
end

local function onload(inst, data)
    if data ~= nil and data.firstmoonpan then
        inst.firstmoonpan = data.firstmoonpan
    end
end

local function onsave(inst, data)
    data.firstmoonpan = inst.firstmoonpan
end

local function dotalk(inst)
	inst.components.talker:Say(STRINGS.MKCETALK_TOLEAVE)
	inst.sg:GoToState("talk", "talk_long")
	inst._talktask = inst:DoTaskInTime(math.random(50,70),dotalk)
end

local function ontalk(inst,phase)
	if phase ~= "dusk"  then
		if inst._talktask ~= nil then
			inst._talktask:Cancel()
			inst._talktask = nil
		end
	else
		if inst._talktask ~= nil then
			inst._talktask:Cancel()
		end
		dotalk(inst)
	end
end

local function onsay(inst)
	local num = 0
	local player = nil
	local x,y,z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 20, {"player"})
	for i,v in ipairs(ents) do
		num = num +1
		player = v
	end

	if num > 1 then
		inst.components.talker:Say(STRINGS.MKCETALK_TOMANYPEOLE)
		inst.sg:GoToState("talk","talk_long")
	elseif player ~= nil then
		local saystring = STRINGS.MYTHGHG_RCWH[string.upper(player.prefab)] or STRINGS.MYTHGHG_RCWH.GENERIC
		inst.components.talker:Say(saystring[math.random(#saystring)])
		inst.sg:GoToState("talk","talk_long")
	end
end

local function dodaytalk(inst)
	onsay(inst)
	inst:DoTaskInTime(math.random(90,120),dodaytalk)
end

local function newplayer(inst, player)
	if player then
		inst.components.talker:Say(STRINGS.MYTHGHG_JMWH[string.upper(player.prefab)] or STRINGS.MYTHGHG_JMWH.GENERIC )
		inst.sg:GoToState("talk","talk_long")
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1.2, .5)

    inst.DynamicShadow:SetSize(10, 5)

    inst.AnimState:SetBank("myth_chang_e")
    inst.AnimState:SetBuild("myth_chang_e")
    inst.AnimState:SetFinalOffset(1)

    inst.AnimState:PlayAnimation("idle", true)

	inst.Transform:SetScale(0.6, 0.6, 0.6)

    inst:AddTag("trader")

    inst:AddTag("birdblocker")
	inst:AddTag("prototyper")
	inst:AddTag("myth_chenge")

    inst:AddTag("trader")

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0, -900, 0)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst.firstmoonpan = false

    inst:AddComponent("inspectable")

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(AcceptTest)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
	inst.components.trader.deleteitemonaccept = false --收到物品不马上移除，根据具体物品决定
	inst.components.trader.acceptnontradable = true

	inst:AddComponent("prototyper")
	inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.MYTH_TECH_CHANGE
	local old_TurnOn = inst.components.prototyper.TurnOn
	inst.components.prototyper.TurnOn = function(self,doer)
		if doer and doer.components.builder then
			local old = doer.components.builder.myth_tech_change_bonus
			local  my_myth_tech_change_bonus = doer.myth_tech_change_bonus or 0
			if old ~= my_myth_tech_change_bonus then
				doer.components.builder.myth_tech_change_bonus = my_myth_tech_change_bonus
			end
		end
		old_TurnOn(self,doer)
	end
	local old_TurnOff = inst.components.prototyper.TurnOff
	inst.components.prototyper.TurnOff = function(self,doer)
		if doer and doer.components.builder then
			doer.components.builder.myth_tech_change_bonus = 0
		end
		old_TurnOff(self,doer)
	end

    inst:SetStateGraph("SGmyth_chang_e")

	inst:WatchWorldState("phase", ontalk)
	ontalk(inst, TheWorld.state.phase)

	inst.NewPlayer = newplayer

    inst.OnSave = onsave
    inst.OnLoad = onload

	inst:DoTaskInTime(math.random(10,15),dodaytalk)
    return inst
end

local function itemfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("myth_chang_e_furniture")
    inst.AnimState:SetBuild("myth_chang_e_furniture")

	inst.Transform:SetScale(0.6, 0.6, 0.6)

    inst.AnimState:PlayAnimation("idle")

	inst.AnimState:SetFinalOffset(-1)

    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 3 )

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("sit_on_myth")
    return inst
end
--------------------------------------------------------------------------

return Prefab("myth_chang_e", fn, assets, prefabs),
	Prefab("myth_chang_e_furniture", itemfn)

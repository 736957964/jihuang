local assets =
{
    Asset("ANIM", "anim/sign_arrow_post.zip"),
    Asset("ANIM", "anim/sign_arrow_panel.zip"),
    Asset("ANIM", "anim/ui_board_5x3.zip"),
    Asset("MINIMAP_IMAGE", "sign"),
}

local prefabs =
{
    "collapse_small",
    "arrowsign_panel",
}

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle", false)
    end
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
	----------------------------------修改 商店系统个人
	if inst.huangjin then data.huangjin = inst.huangjin end
	if inst.shangdiansuoyouzheid then data.shangdiansuoyouzheid = inst.shangdiansuoyouzheid end
	if inst.name then data.name = inst.name end

	if inst.jiage then data.jiage = inst.jiage end
	----------------------------------修改 商店系统个人
end

local function onload(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
	----------------------------------修改 商店系统个人
	if data and data.huangjin then inst.huangjin = data.huangjin end
	if data and data.shangdiansuoyouzheid then inst.shangdiansuoyouzheid = data.shangdiansuoyouzheid end
	if data and data.xiangziname then 
		inst.name = data.name 
		inst.components.named:SetName(inst.name)
	end

	if data and data.jiage then inst.jiage = data.jiage end
	----------------------------------修改 商店系统个人
end

local function onbuilt(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/sign_craft")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

--修改    MakeObstaclePhysics(inst, .2)

    inst.MiniMapEntity:SetIcon("sign.png")

    inst.AnimState:SetBank("sign_arrow_post")
    inst.AnimState:SetBuild("sign_arrow_post")
    inst.AnimState:PlayAnimation("idle")

    inst.Transform:SetEightFaced()

    MakeSnowCoveredPristine(inst)

    inst:AddTag("structure")
    inst:AddTag("sign")
    inst:AddTag("nointerpolate")

    inst:AddTag("_writeable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:RemoveTag("_writeable")

    inst:AddComponent("inspectable")
    inst:AddComponent("writeable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    MakeSnowCovered(inst)

    inst:AddComponent("savedrotation")

    MakeSmallBurnable(inst, nil, nil, true)
    MakeSmallPropagator(inst)
    inst.OnSave = onsave
    inst.OnLoad = onload

    MakeHauntableWork(inst)
    inst:ListenForEvent("onbuilt", onbuilt)
	
	-------------------------------------------------修改 个人商店系统
	inst:AddComponent("named")--修改
	inst:RemoveComponent("workable")--修改
	inst.shangdianzhanshi = 4
	inst.wufaranshao = true       --修改
	inst:AddTag("wufafenjie")     --修改
	inst:AddTag("gerenshangdian") --修改
	local Shangtext = ""
	inst:DoPeriodicTask(5.1, function(inst)
		if inst.components.writeable.text == nil then return end
		if inst.jiage == nil then
			local jiage = inst.components.writeable.text
			inst.jiage = tonumber(jiage)
			if (inst.jiage or 0) >= 64*5*10 then
				Shangtext = "购买需个人银行有 "..inst.jiage.." 个金元宝"
			else Shangtext = "购买需身上携带有 "..(inst.jiage or 0).." 个金元宝" end
			inst.components.writeable.text = Shangtext
			if inst.jiage == nil then 
				if inst.shangdiansuoyouzhe and inst.shangdiansuoyouzhe.components.talker then
					inst.shangdiansuoyouzhe.components.talker:Say("价格必须是数字",2.5)
				end
				inst:Remove() 
				return
			end
		end
		if (inst.huangjin or 0) > 0 then 
			if inst.shangdiansuoyouzhe and inst.shangdiansuoyouzhe:IsValid() and not inst.shangdiansuoyouzhe:HasTag("playerghost") then 
				if inst.huangjin >= 64*5*10 then 
					inst.shangdiansuoyouzhe.zuiduohuangjin = (inst.shangdiansuoyouzhe.zuiduohuangjin or 0) + inst.huangjin
					inst.shangdiansuoyouzhe.components.talker:Say("我的商品卖出去了，自动充值到银行："..inst.huangjin)
				else geihuangjinxiaoguo(inst.shangdiansuoyouzhe,inst.huangjin) end
				inst.huangjin = 0
			else
				for k,v in pairs(AllPlayers) do
					if (inst.shangdiansuoyouzheid or "") == v.userid then
						if inst.huangjin >= 64*5*10 then 
							v.zuiduohuangjin = (v.zuiduohuangjin or 0) + inst.huangjin
							v.components.talker:Say("我的商品卖出去了，元宝已转入银行："..inst.huangjin)
						else geihuangjinxiaoguo(v,inst.huangjin) end
						inst.huangjin = 0
						break
					end
				end
			end
			return
		end
		if inst.shangdianwupin == nil then
			local p1x, p1y, p1z = inst.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(p1x, p1y, p1z, 1.5,{"_inventoryitem"})
			for k,v in pairs(ents) do
				if v.shangdianzhanshi == nil and v.components.inventoryitem:GetContainer() == nil and v.components.perishable == nil then
					v.shangdianjiage = math.floor(inst.jiage)
					v.shangdianzhanshi = 4
					v.wufaranshao = true
					v:AddTag("wufafenjie")
					v.shangdiansuoyouzhe = inst
					inst.shangdianwupin = v
					v.AnimState:SetMultColour(1,0.84,0, 1)
					break
				end
			end
		end
	end)
	-------------------------------------------------修改


    return inst
end

local function panelfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("sign_arrow_panel")
    inst.AnimState:SetBuild("sign_arrow_panel")
    inst.AnimState:PlayAnimation("idle")

    inst.Transform:SetEightFaced()

    inst:AddTag("nointerpolate")
    inst:AddTag("sign")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("writeable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("savedrotation")

    -- TODO: Make workable, but transfer the work to the sign base instead

    MakeSnowCovered(inst)

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab("arrowsign_post", fn, assets, prefabs),
        MakePlacer("arrowsign_post_placer", "sign_arrow_post", "sign_arrow_post", "idle", nil, nil, nil, nil, -90, "eight"),
        Prefab("arrowsign_panel", panelfn, assets, prefabs),
        MakePlacer("arrowsign_panel_placer", "sign_arrow_panel", "sign_arrow_panel", "idle", nil, nil, nil, nil, -90, "eight")

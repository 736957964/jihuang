local assets =
{
    Asset("ANIM", "anim/hua_house_interiors.zip"),
}

local function addwall(prefab,x,z)
	local item = SpawnPrefab(prefab)
	item.Transform:SetPosition(x,0,z)
end

local function onhammered(inst, worker)
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function get_name(inst)
	return inst:HasTag("myth_oldinteriors") and STRINGS.OLDMYTH_INTERIORS..STRINGS.NAMES[string.upper(inst.prefab)] or STRINGS.NAMES[string.upper(inst.prefab)]
end

local function IsLowPriorityAction(act, force_inspect)
    return act == nil
        or act.action == ACTIONS.WALKTO
        or (act.action == ACTIONS.LOOKAT and not force_inspect)
end

local function CanMouseThrough(inst)
    if not inst:HasTag("fire") and ThePlayer ~= nil and ThePlayer.components.playeractionpicker ~= nil then
        local force_inspect = ThePlayer.components.playercontroller ~= nil and ThePlayer.components.playercontroller:IsControlPressed(CONTROL_FORCE_INSPECT)
        local lmb, rmb = ThePlayer.components.playeractionpicker:DoGetMouseActions(inst:GetPosition(), inst)
        return IsLowPriorityAction(rmb, force_inspect)
            and IsLowPriorityAction(lmb, force_inspect)
    end
end

local function book(inst,first)
	if inst.has_flybook then
		return
	end
    local book = SpawnPrefab("book_fly_myth")
    inst:AddChild(book)
	book.entity:AddFollower()
    book.Follower:FollowSymbol(inst.GUID, "book", 0, 0, 0.5)
	if first then
		book.AnimState:PlayAnimation("proximity_pst")
		book.AnimState:PushAnimation("idle",false)
		book.SoundEmitter:PlaySound("dontstarve/common/together/book_maxwell/drop")
	end	
			
    local deng = SpawnPrefab("myth_interiors_light")
    inst:AddChild(deng)
    deng.entity:AddFollower()
    deng.Follower:FollowSymbol(inst.GUID, "deng", 0, 0, 0)
	inst.has_flybook  = true
end
--写的什么垃圾代码这个
local function bed(inst)
	inst:DoTaskInTime(0,function()
		local x,y,z = inst.Transform:GetWorldPosition()
		addwall("myth_physics_big",x,z)
		addwall("myth_physics_big",x+1.6,z)
		addwall("myth_physics_big",x+3.2,z)
		addwall("myth_physics_big",x-1.6,z)
		addwall("myth_physics_big",x-3.2,z)
	end)
end
--写的什么垃圾代码这个
local function zz(inst)
	inst.components.myth_oldinteriors.onnew = book
	inst:DoTaskInTime(0,function()
		local x,y,z = inst.Transform:GetWorldPosition()
		addwall("myth_physics_samll",x-0.2,z+0.3)
		addwall("myth_physics_samll",x-0.2,z+0.9)
		addwall("myth_physics_samll",x-0.2,z+1.5)
		addwall("myth_physics_samll",x-0.2,z-0.3)
		addwall("myth_physics_samll",x-0.2,z-0.9)
		addwall("myth_physics_samll",x-0.2,z-1.5)
		addwall("myth_physics_samll",x-0.2,z-1.8)
		addwall("myth_physics_samll",x-0.2,z+2.1)
		addwall("myth_physics_middle",x-0.9,z+1.8)
		addwall("myth_physics_middle",x-0.9,z-1.5)
	end)
end
--写的什么垃圾代码这个
local function pf(inst)
	inst:DoTaskInTime(0,function()
		local x,y,z = inst.Transform:GetWorldPosition()
		addwall("myth_physics_samll",x,z+0.3)
		addwall("myth_physics_samll",x,z+0.9)
		addwall("myth_physics_samll",x,z+1.5)
		addwall("myth_physics_samll",x,z-0.3)
		addwall("myth_physics_samll",x,z-0.9)
		addwall("myth_physics_samll",x,z-1.5)
		addwall("myth_physics_samll",x,z-1.8)
	end)
end


local function onclear(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(x,y,z)
    fx:SetMaterial("none")
	local zz 
	local all = {}
	local ents = TheSim:FindEntities(x, 0, z, 15,nil,{"INLIMBO"},{"myth_interiors","myth_oldinteriors"})
	for i,v in ipairs(ents) do
		if v.prefab =="myth_interiors_zz" then
			zz = v
		end
		if v:HasTag("myth_oldinteriors") then
			table.insert(all,v.GUID)
		end	
	end
	if zz ~= nil and next(all) == nil then
		zz.components.myth_oldinteriors:SetNew(true)
	end
end

local function makeinteriors(build,size,hua,masterfn)
	local assets =
	{
		Asset("ANIM", "anim/"..build..".zip"),
	}
	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		inst.AnimState:SetBank(build)
		inst.AnimState:SetBuild(build)
		inst.AnimState:PlayAnimation("old")
		
		inst:AddTag("antlion_sinkhole_blocker")
		inst:AddTag("nonpackable")
		if not hua then
			inst:AddTag("myth_interiors")
		end
		inst.GetIsWet = function(...) return false end
	
		inst.displaynamefn = get_name
		
		if build == "myth_interiors_zz" then
			inst.CanMouseThrough = CanMouseThrough
		end
		
		if build == "myth_interiors_pf" then
			inst.Transform:SetScale(size, 1.2, size)
		else
			inst.Transform:SetScale(size, size, size)
		end
		
		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
		inst:AddComponent("inspectable")
		
		if not hua then
			inst:AddComponent("myth_oldinteriors")
			inst.components.myth_oldinteriors:SetOnClearFn(onclear)
		end
		if masterfn then
			masterfn(inst)
		end
		return inst
	end
	return Prefab(build, fn , assets)
end


local function make(name,rad)
	local function fn()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddNetwork()

		MakeObstaclePhysics(inst, rad)

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
		inst.persists = false
		return inst
	end
	return Prefab(name, fn)
end

return makeinteriors("myth_interiors_bed",1.45,false,bed),
	makeinteriors("myth_interiors_gz",1),
	makeinteriors("myth_interiors_gh",1.38,true),
	makeinteriors("myth_interiors_gh_small",1.1,true),
	makeinteriors("myth_interiors_pf",1.25,false,pf),
	makeinteriors("myth_interiors_xl",1.2),
	makeinteriors("myth_interiors_zz",1.2,false,zz),
	make("myth_physics_samll",0.3),	
	make("myth_physics_middle",0.6),
	make("myth_physics_big",1.8)
local assets = {
	-- anim
	Asset( "ANIM", "anim/myth_surf.zip"),
	Asset( "ANIM", "anim/act_jumpboat.zip"),
	-- build
	Asset( "ANIM", "anim/mk_cloudfx0.zip" ),
	Asset( "ANIM", "anim/mk_cloudfx1.zip" ),
	Asset( "ANIM", "anim/mk_cloudfx2.zip" ),
	Asset( "ANIM", "anim/mk_cloudfx3.zip" ),
	Asset( "ANIM", "anim/mk_cloudfx4.zip" ),

	Asset( "ANIM", "anim/mk_cloudfx_purple.zip" ),
	Asset( "ANIM", "anim/mk_cloudfx_blue.zip" ),

	Asset( "ANIM", "anim/mk_cloudfx_ear.zip" ),
	Asset( "ANIM", "anim/nz_wheel_pink.zip" ),
	Asset( "ANIM", "anim/mk_cloudfx_apricot.zip" ),

	Asset( "ANIM", "anim/nz_wheel.zip" ),

}

local tailskin = {
	monkey_king_ear = "mk_cloudfx_ear",
	neza_pink = "nz_wheel_pink",
	myth_yutu_apricot = "mk_cloudfx_apricot",
}

local function Root()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.persists = false
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")

	return inst
end

local function ThunderFx() -- 杨戬的闪电
	local inst = Root()
	local anim = inst.entity:AddAnimState()
	anim:SetBank("lavaarena_hammer_attack_fx")
	anim:SetBuild("yj_spear_elec_shockfx_build")
	anim:PlayAnimation("crackle_loop")
	anim:SetFinalOffset(-10)
	anim:SetLightOverride(1)
	-- anim:SetLayer( LAYER_FRONTEND )

	local s = 1
	inst.Transform:SetScale(s,s,s)

	inst:ListenForEvent("animover", inst.Remove)
	return inst
end

local function SingleCloud() -- 圆云
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.AnimState:SetBank("mk_cloudfx")
    inst.AnimState:PlayAnimation("anim_loop", true)
    inst.AnimState:SetTime(math.random())
	inst.AnimState:SetFinalOffset(-1)
	inst.persists = false
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")

	return inst
end

local function cloud_update(inst) -- 控制云的大小
	local base = math.sin((GetTime()+inst.timeoffset)*inst.scalespeed) -- -1~1
	local scale = inst.scale + inst.scale_v*base
	scale = scale * inst.scale_mult 
	inst.Transform:SetScale(scale, scale, scale)
end

local function cloud_config(inst, data)
	-- 缩放大小
	inst.scale = data.scale or 1
	inst.scale_v = data.scale_v or 0.3
	-- 缩放速度
	inst.scalespeed = data.scalespeed or 1
	inst.scalespeed_v = data.scalespeed_v or 0.2
	-- 动画速度
	inst.animspeed = data.animspeed or 1
	inst.animspeed_v = data.animspeed_v or 0
	-- 半径
	inst.radius = data.radius or 0.6
	-- build
	inst.build = data.build or error("Must set a build!")

	if  data.owner ~= nil then	
		inst.owner = data.owner
	end
	inst.base_alpha = data.base_alpha or 1
end

local function tryskinconfig(inst)
	for k in pairs(inst.fx) do
		if k:IsValid() and inst.owner ~= nil and  tailskin[inst.owner.AnimState:GetBuild()] ~= nil then
			k.AnimState:SetBuild(tailskin[inst.owner.AnimState:GetBuild()])
		end
	end
end

local function applyconfig(inst, other)
	other.scale = inst.scale
	other.scale_v = inst.scale_v
	other.scale_mult = 1

	other.scalespeed = GetRandomWithVariance(inst.scalespeed, inst.scalespeed_v)
	other.timeoffset = 2*PI*math.random()/other.scalespeed

	other.AnimState:SetDeltaTimeMultiplier(GetRandomWithVariance(inst.animspeed, inst.animspeed_v))

	if inst.owner ~= nil and  tailskin[inst.owner.AnimState:GetBuild()] ~= nil then
		other.AnimState:SetBuild(tailskin[inst.owner.AnimState:GetBuild()])
	else
		other.AnimState:SetBuild(inst.build)
	end
	--other.AnimState:SetBuild(inst.build)

	other.base_alpha = inst.base_alpha

	local a = other.base_alpha
	other.AnimState:SetMultColour(a,a,a,a)
end

local function cloud_init(inst)
	-- 经典的七朵云
	for i = 1,7 do
		local r = i == 7 and 0 or inst.radius
		local a = i* PI/3
		local offset = Vector3(math.cos(a)*r, 0, math.sin(a)*r)
		local fx = SingleCloud()
		inst:applyconfig(fx)
		inst:AddChild(fx)
		inst.fx[fx] = true
		fx.Transform:SetPosition(offset:Get())
		fx:DoPeriodicTask(0, cloud_update)
	end
end

local function Despawn(inst, time)
	-- 渐隐消失
	time = time or 1
	local progress = 1
	inst:DoPeriodicTask(0, function()
		for k in pairs(inst.fx)do
			if k:IsValid() then
				k.scale_mult = progress
				local a = progress * inst.base_alpha
				k.AnimState:SetMultColour(a, a, a, a)
			end
		end
		progress = progress - FRAMES/time
		if progress < 0 then
			inst:Remove()
		end
	end)
end

local function CloudFx()
	local inst = Root()
	local s = 0.7
	inst.Transform:SetScale(s,s,s)
	inst.fx = {}
	inst.config = cloud_config
	inst.applyconfig = applyconfig
	inst.tryskinconfig = tryskinconfig
	inst.init = cloud_init
	inst.Despawn = Despawn

	return inst
end

local function tail_config(inst, data)
	-- 初始大小
	inst.scale = data.scale or 1
	inst.scale_v = data.scale_v or 0.1
	-- 渐隐时间
	inst.fadetime = data.fadetime or 2
	-- 变小
	inst.changescale = data.changescale ~= false
	-- 变透明
	inst.changealpha = data.changealpha ~= false
	-- build
	inst.build = data.build or error("Must set a build!")

	if  data.owner ~= nil then	
		inst.owner = data.owner
	end
	inst.base_alpha = data.base_alpha or 1
end

local function tail_apply(inst, other)
	other.scale = 0.7* GetRandomWithVariance(inst.scale, inst.scale_v)
	other.Transform:SetScale(other.scale, other.scale, other.scale)
	if inst.owner ~= nil and  tailskin[inst.owner.AnimState:GetBuild()] ~= nil then
		other.AnimState:SetBuild(tailskin[inst.owner.AnimState:GetBuild()])
	else
		other.AnimState:SetBuild(inst.build)
	end

	other.fadetime = inst.fadetime
	other.changescale = inst.changescale
	other.changealpha = inst.changealpha
	other.base_alpha = inst.base_alpha
	local a = inst.base_alpha
	other.AnimState:SetMultColour(a,a,a,a)
end

local function tail_update(inst, parent)
	local p = inst.progress
	if inst.changescale then
		local s = inst.scale * p
		inst.Transform:SetScale(s,s,s)
	end
	if inst.changealpha then
		local a = p * inst.base_alpha
		inst.AnimState:SetMultColour(a,a,a,a)
	end
	inst.progress = p - FRAMES/inst.fadetime
	if inst.progress < 0 then
		if parent:IsValid() then
			parent:Remove()
		end
		if inst:IsValid() then
			inst:Remove()
		end
	end
end

local function tail_init(inst)
	local fx = SingleCloud()
	inst:AddChild(fx)
	inst.fx = fx
	tail_apply(inst, fx)
	fx.progress = 1
	fx:DoPeriodicTask(0, tail_update, nil, inst)
end

local function setheight(inst, height)
	if inst.fx and inst.fx:IsValid() then
		inst.fx.Transform:SetPosition(0,height,0)
	end
end

local function CloudTailFx()
	local inst = Root()
	MakeInventoryPhysics(inst)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)

	inst.config = tail_config
	inst.init = tail_init
	inst.setheight = setheight

	return inst
end

local function UpdateFacing(inst,i)
	local player = inst.parent and inst.parent.parent
	if player and player:IsValid()then
		inst.Transform:SetRotation(player.Transform:GetRotation())
	end
	local face = inst.AnimState:GetCurrentFacing()
	if face == FACING_LEFT or face == FACING_RIGHT then
		inst.AnimState:SetScale(0.7,0.7)
	elseif face == FACING_UP or face == FACING_DOWN then
		inst.AnimState:SetScale(.2,1)
	else
		inst.AnimState:SetScale(.5,1)
	end
end

local function SingleWheel() -- 单个风火轮
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.AnimState:SetBank("nz_wheel")
    inst.AnimState:SetBuild("nz_wheel")
    inst.AnimState:PlayAnimation("flying", true)
	inst.persists = false
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst.Transform:SetScale(1.5, 1.5, 1.5)
	inst.Transform:SetEightFaced()
	inst.UpdateFacing = UpdateFacing
		
	local fire = inst:SpawnChild("torchfire")
	if fire._light and fire._light.Light then
		fire._light.Light:Enable(false)
	end
	fire.SoundEmitter:KillSound("torch")
	return inst
end

local function wheel_update_facing(inst)
	for _, v in ipairs(inst.wheels)do
		if v:IsValid() then
			v:UpdateFacing()
		end
	end
end

local function wheel_config(inst, data)
	if  data.owner ~= nil then	
		inst.owner = data.owner
		for _, v in ipairs(inst.wheels)do
			if v:IsValid() then
				if inst.owner ~= nil and  tailskin[inst.owner.AnimState:GetBuild()] ~= nil then
					v.AnimState:SetBuild(tailskin[inst.owner.AnimState:GetBuild()])
				end
			end
		end
	end
end

local function WheelFx() --风火轮s
	local inst = Root()
	local wheel1 = SingleWheel()
	local wheel2 = SingleWheel()
	inst:AddChild(wheel1)
	inst:AddChild(wheel2)
	
	wheel1.Transform:SetPosition(0,0,0.3)
	wheel2.Transform:SetPosition(0,0,-0.3)

	inst.wheels = {wheel1, wheel2}
	inst:DoPeriodicTask(0, wheel_update_facing)

	inst.configwheel = wheel_config

	inst.Despawn = function(inst)
		-- 不希望立刻移除
		inst:Hide()
		inst.persists = false
		inst:DoTaskInTime(2, inst.Remove)
	end
	return inst
end

return Prefab("myth_flyerfx_cloud", CloudFx, assets),
	Prefab("myth_flyerfx_cloud_thunder", ThunderFx, assets),
	Prefab("myth_flyerfx_cloud_tail", CloudTailFx, assets),
	Prefab("myth_flyerfx_wheel", WheelFx, assets)

require "prefabutil"

local assets = {
    Asset("ANIM", "anim/myth_honeypot.zip"),
    Asset("ANIM", "anim/ui_chest_3x3.zip")
}

local prefabs = {
    "collapse_small"
}

local function GetSpawnPoint(pt)
    local theta = math.random() * 2 * PI
    local radius = 30

	local offset = FindWalkableOffset(pt, theta, radius, 12, true)
	if offset then
		return pt+offset
	end
end

local function getanim(inst, state)
    local state = state or "close"
    return inst.components.container:IsFull() and "full_" .. state or "idle_" .. state
end
local function onopen(inst)
    inst.AnimState:PlayAnimation(getanim(inst, "open"))
    inst.SoundEmitter:PlaySound("dontstarve/common/together/portable/spicer/lid_open")
end

local function onclose(inst)
    inst.AnimState:PlayAnimation(getanim(inst, "close"))
    inst.SoundEmitter:PlaySound("dontstarve/common/together/portable/spicer/lid_close")

    if inst.components.container:IsFull() and not inst.components.timer:TimerExists("blackbear") then
        local pt = Vector3(inst.Transform:GetWorldPosition())
        local spawn_pt = GetSpawnPoint(pt)
        if spawn_pt then
            inst.components.container.canbeopened = false
            local boos = SpawnPrefab("blackbear_wind")
            boos.Physics:Teleport(spawn_pt:Get())
            boos:SetPot(inst)
            inst:DoTaskInTime(5.5,function()
                if not inst.components.container.canbeopened then
                    inst.components.container.canbeopened = true
                end
            end)
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("myth_honeypot.tex")

    inst.AnimState:SetBank("myth_honeypot")
    inst.AnimState:SetBuild("myth_honeypot")
    inst.AnimState:PlayAnimation("idle_close")

    MakeSnowCoveredPristine(inst)

    TheWorld.myth_honeypot = inst

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("myth_honeypot")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    inst.components.container.OnUpdate = function(self,dt)
        if self.opencount == 0 then
            self.inst:StopUpdatingComponent(self)
        else
            for opener, _ in pairs(self.openlist) do
                if not opener:IsValid() then
                    self:Close()
                elseif not (self.inst.components.inventoryitem ~= nil and
                        self.inst.components.inventoryitem:IsHeldBy(opener)) and
                        ((opener.components.rider ~= nil and opener.components.rider:IsRiding()) or
                        not (opener:IsNear(self.inst, 3) and
                        CanEntitySeeTarget(opener, self.inst))) then
                    self:Close(opener)
                end
            end
        end
    end

    inst:AddComponent("timer")
    inst:DoTaskInTime(0,function()
        inst.AnimState:PlayAnimation(getanim(inst, "close"))
    end)

	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(0)
    return inst
end

return Prefab("myth_honeypot", fn, assets, prefabs)

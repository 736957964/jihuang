local function SetOn(inst, instant)
    inst.on = true
	if inst.components.lr_light then
		if inst.components.lr_light.randomcolour then
			inst.components.lr_light.red = math.random(0,255)/255
			inst.components.lr_light.green = math.random(0,255)/255
			inst.components.lr_light.blue = math.random(0,255)/255
		end
		inst.components.lr_light:Start()
	end
	inst.SoundEmitter:PlaySound("dontstarve/common/together/mushroom_lamp/change_colour")
end

local function SetOff(inst, instant)
    inst.on = false
	if inst.components.lr_light then
		inst.components.lr_light:Stop()
	end
	inst.SoundEmitter:PlaySound("dontstarve/common/together/mushroom_lamp/change_colour")
end

local Lr_light = Class(function(self, inst)
	self.inst = inst

	self.enabled = false
	self.falloff = 1
	self.intensity = .5
	self.radius = 50
	self.red = 180/255--默认为紫色
	self.green = 0/255
	self.blue = 255/255
	self.machine = false
	self.caninteractfn = nil
	self.cooldowntime = .5
	
	self.randomcolour = true
	
	self.fx = nil
	
end)

function Lr_light:Start()
	self.enabled = true
	if self.inst.lr_light == nil then
		self.inst.lr_light = self.fx and SpawnPrefab(self.fx) or SpawnPrefab("mushtree_small")
		self.inst.lr_light.entity:SetParent(self.inst.entity)
		local fx = self.inst.lr_light
		if fx.MiniMapEntity then fx.MiniMapEntity:SetEnabled(false) end
		if fx.components.workable then fx:RemoveComponent("workable") end
		fx:Hide()
		RemovePhysicsColliders(fx)
		fx:AddTag("wildfireprotected")
		if fx:HasTag("canlight") then
			fx:RemoveTag("canlight")
		end
		fx:AddTag("nolight")
		fx:AddTag("fireimmune")
		fx.Light:SetFalloff(self.falloff)
		fx.Light:SetIntensity(self.intensity)
		fx.Light:SetRadius(self.radius)
		fx.Light:SetColour(self.red, self.green, self.blue)
		fx.Light:Enable(true)
	else
		local fx = self.inst.lr_light
		if fx.MiniMapEntity then fx.MiniMapEntity:SetEnabled(false) end
		if fx.components.workable then fx:RemoveComponent("workable") end
		fx:Hide()
		RemovePhysicsColliders(fx)
		fx:AddTag("wildfireprotected")
		if fx:HasTag("canlight") then
			fx:RemoveTag("canlight")
		end
		fx:AddTag("nolight")
		fx:AddTag("fireimmune")
		fx.Light:SetFalloff(self.falloff)
		fx.Light:SetIntensity(self.intensity)
		fx.Light:SetRadius(self.radius)
		fx.Light:SetColour(self.red, self.green, self.blue)
		fx.Light:Enable(true)
	end
end

function Lr_light:Stop()
	self.enabled = false
	if self.inst.lr_light ~= nil then
        if self.inst.lr_light:IsValid() then
            self.inst.lr_light:Remove()
        end
        self.inst.lr_light = nil
    end
end

function Lr_light:MakeMachine()--可以鼠标右键调节开关灯源
	self.machine = true
	if self.inst.components.machine == nil then
		self.inst:AddComponent("machine")
	end
    self.inst.components.machine.turnonfn = SetOn
    self.inst.components.machine.turnofffn = SetOff
    self.inst.components.machine.caninteractfn = self.CanInteract
    self.inst.components.machine.cooldowntime = self.cooldowntime
end

function Lr_light:OnSave()
    return
    {
		enabled = self.enabled,
		falloff = self.falloff,
		intensity = self.intensity,
		radius = self.radius,
		red = self.red,
		green = self.green,
		blue = self.blue,
		machine = self.machine,
		randomcolour = self.randomcolour,
		fx = self.fx,
    }
end

function Lr_light:OnLoad(data)
	if data then
		self.enabled = data.enabled
		self.falloff = data.falloff
		self.intensity = data.intensity
		self.radius = data.radius
		self.red = data.red
		self.green = data.green
		self.blue = data.blue
		self.machine = data.machine
		self.randomcolour = data.randomcolour
		self.fx = data.fx
		if self.machine then
			self:MakeMachine()
		end
		if self.enabled then
			self:Start()
		end
	end
end

function Lr_light:Enable(val)
	if type(val) == "boolean" then
		if val then
			self:Start()
		else
			self:Stop()
		end
    end
end

function Lr_light:SetFalloff(num)
	self.falloff = num
	if self.enabled then
		self:Start()
	end
end

function Lr_light:SetIntensity(num)
	self.intensity = num
	if self.enabled then
		self:Start()
	end
end

function Lr_light:SetRadius(num)
	self.radius = num
	if self.enabled then
		self:Start()
	end
end

function Lr_light:SetColour(r,g,b)
	self.red = r
	self.green = g
	self.blue = b
	if self.enabled then
		self:Start()
	end
end

return Lr_light
local DOZE_OFF_TIME = 2

local function onenble(self,enble)
	if enble then
		self.inst:AddTag("canusechenshe")
	else
		self.inst:RemoveTag("canusechenshe")
	end
end

local Projectile = Class(function(self, inst)
    self.inst = inst
    self.owner = nil
    self.target = nil
    self.start = nil
    self.dest = nil

    self.speed = nil
    self.hitdist = 1.5
    self.homing = true
    self.range = nil
    self.onthrown = nil
    self.onhit = nil
    self.onmiss = nil
	
	self.enble = true
	self.targets ={}

    --inst:AddTag("projectile")
end,
nil,
{
	enble = onenble,
})

function Projectile:SetEnble(bb)
	self.enble = bb
end

function Projectile:OnRemoveFromEntity()
    self.inst:RemoveTag("projectile")
end

function Projectile:SetSpeed(speed)
    self.speed = speed
end

function Projectile:SetRange(range)
    self.range = range
end

function Projectile:SetHitDist(dist)
    self.hitdist = dist
end

function Projectile:SetOnHitFn(fn)
    self.onhit = fn
end

function Projectile:SetOnMissFn(fn)
    self.onmiss = fn
end

function Projectile:SetOnThrownFn(fn)
    self.onthrown = fn
end

function Projectile:SetLaunchOffset(offset)
    self.launchoffset = offset -- x is radius, y is height, z is ignored
end

function Projectile:FaShe(pos,doer)
	if self.fashe ~= nil then
		return self.fashe(self.inst,pos,doer)
	end
	return false
end

function Projectile:Throw(attacker, pos)
    self.owner = attacker
    self.start = attacker:GetPosition()
    self.dest = pos
    self:Start()
    if attacker ~= nil and self.launchoffset ~= nil then --偏移
        local x, y, z = self.inst.Transform:GetWorldPosition()
        local facing_angle = attacker.Transform:GetRotation() * DEGREES
        self.inst.Transform:SetPosition(x + self.launchoffset.x * math.cos(facing_angle), y + self.launchoffset.y, z - self.launchoffset.x * math.sin(facing_angle))
    end

    self:RotateToTarget(self.dest) --朝向
    self.inst.Physics:SetMotorVel(self.speed, 2, 0) --飞行
    self.inst:StartUpdatingComponent(self) --更新

    if self.onthrown ~= nil then
        self.onthrown(self.inst, attacker)
    end
end

function Projectile:Miss()
    local owner = self.owner
    self:Stop()
    if self.onmiss ~= nil then
        self.onmiss(self.inst,owner)
    end
end

function Projectile:Stop()
    if self.inst.shadow_task then
        self.inst.shadow_task:Cancel()
        self.inst.shadow_task = nil 
    end

	self.inst.Physics:Stop()
    self.inst.AnimState:PlayAnimation("idle")
	self.inst:RemoveTag("NOCLICK")
	ChangeToInventoryPhysics(self.inst)
    self.inst.AnimState:SetOrientation(ANIM_ORIENTATION.BillBoard) --不贴地
	self.inst.components.inventoryitem.canbepickedup = true
    self.inst.components.inventoryitem.pushlandedevents = true
    self.inst.components.weapon:SetDamage(34)

    self.inst:StopUpdatingComponent(self)
    SpawnPrefab("lucy_transform_fx").Transform:SetPosition(self.inst:GetPosition():Get())
    self.owner = nil
end

function Projectile:Start()
    self.targets = {}
	self.inst:AddTag("NOCLICK")
    self.inst.AnimState:PlayAnimation("thrown")
    self.inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	self.inst.Physics:ClearCollidesWith(COLLISION.LIMITS)
	self.inst.components.inventoryitem.canbepickedup = false
    self.inst.components.inventoryitem.pushlandedevents = false
    self.inst.components.weapon:SetDamage(100)
end

function Projectile:Hit(target)
    local attacker = self.owner
    local weapon = self.inst
	
    if attacker ~= nil and attacker.components.combat ~= nil then
		if attacker.components.combat.ignorehitrange then
	        attacker.components.combat:DoAttack(target, weapon, self.inst)
		else
			attacker.components.combat.ignorehitrange = true
			attacker.components.combat:DoAttack(target, weapon, self.inst)
			attacker.components.combat.ignorehitrange = false
		end
    end
    if self.onhit ~= nil then
        --self.onhit(self.inst, attacker, target)
    end
end

function Projectile:OnUpdate(dt)
    self.inst.Physics:SetMotorVel(self.speed, 2, 0) --飞行
	local pos = self.inst:GetPosition()
    --超过了最大距离就miss
	if self.range ~= nil and distsq(self.start, pos) > self.range * self.range then
        self:Miss()
        return true
	else --否则就检查周围的可以攻击的目标hit一次
		local ents = TheSim:FindEntities(pos.x,0,pos.z, self.hitdist,{"_health","_combat"},{'FX', 'NOCLICK', 'INLIMBO', 'DECOR', 'hiding', 'player','wall',"companion","abigail"})

		for i,v in pairs(ents) do
			if not self.targets[v]  and v:IsValid() and self.inst:IsValid() and self.inst:IsNear(v, self.hitdist + (v.Physics and v.Physics:GetRadius() or 0)) and v ~= self.owner 
                and v.components.health ~=nil and v.components.combat ~=nil  and not v.components.health:IsDead() then
                self.targets[v]  = true
				self:Hit(v)
			end
		end
	end
end

function Projectile:RotateToTarget(dest)
    local direction = (dest - self.inst:GetPosition()):GetNormalized()
    local angle = math.acos(direction:Dot(Vector3(1, 0, 0))) / DEGREES
    self.inst.Transform:SetRotation(angle)
    self.inst:FacePoint(dest)
end

return Projectile

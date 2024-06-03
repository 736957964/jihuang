GD_KiteAndAttack = Class(BehaviourNode, function(self, inst, safe_dist)
    BehaviourNode._ctor(self, "GD_KiteAndAttack")
    self.inst = inst
    -- self.ifrunfn = ifrunfn
    self.safe_dist = safe_dist
    self.numattacks = 0
    
    -- we need to store this function as a key to use to remove itself later
    self.onattackfn = function(inst, data)
        self:OnAttackOther(data.target) 
    end

    self.inst:ListenForEvent("onattackother", self.onattackfn)
    self.inst:ListenForEvent("onmissother", self.onattackfn)
end)

function GD_KiteAndAttack:__tostring()
    return string.format("target %s", tostring(self.inst.components.combat.target))
end

function GD_KiteAndAttack:OnStop()
    self.inst:RemoveEventCallback("onattackother", self.onattackfn)
    self.inst:RemoveEventCallback("onmissother", self.onattackfn)
end

function GD_KiteAndAttack:OnAttackOther(target)
    -- print ("on attack other", target)
    self.numattacks = self.numattacks + 1
    self.startruntime = nil -- reset max chase time timer
end

function GD_KiteAndAttack:GetRunAngle(pt, hp)
    if self.avoid_angle ~= nil then
        local avoid_time = GetTime() - self.avoid_time
        if avoid_time < 1 then
            return self.avoid_angle
        else
            self.avoid_time = nil
            self.avoid_angle = nil
        end
    end

    local angle = self.inst:GetAngleToPoint(hp) + 180 -- + math.random(30)-15
    if angle > 360 then
        angle = angle - 360
    end

    --print(string.format("RunAway:GetRunAngle me: %s, hunter: %s, run: %2.2f", tostring(pt), tostring(hp), angle))

    local radius = 6

    local result_offset, result_angle, deflected = FindWalkableOffset(pt, angle*DEGREES, radius, 8, true, false) -- try avoiding walls
    if result_angle == nil then
        result_offset, result_angle, deflected = FindWalkableOffset(pt, angle*DEGREES, radius, 8, true, true) -- ok don't try to avoid walls, but at least avoid water
        if result_angle == nil then
            return angle -- ok whatever, just run
        end
    end

    result_angle = result_angle / DEGREES
    if deflected then
        self.avoid_time = GetTime()
        self.avoid_angle = result_angle
    end
    return result_angle
end

function GD_KiteAndAttack:GetKitePos(pt, hp, target, attackrange)
    if self.kite_pos ~= nil then
        local kite_time = GetTime() - self.kite_time
        if kite_time < 1 then
            return self.kite_pos
        else
            self.kite_time = nil
            self.kite_pos = nil
        end
    end

    local angle = target:GetAngleToPoint(pt)
    local dist_angle = angle * DEGREES
    local offset = Vector3( attackrange * math.cos(dist_angle), 0, -attackrange * math.sin(dist_angle) )
    self.kite_pos = hp + offset
    self.kite_time = GetTime()

    -- SpawnPrefab("spawn_fx_medium").Transform:SetPosition(self.kite_pos:Get())

    return self.kite_pos
end

-- 不走位的生物
local noKitePrefabs = {
    -- pigman = true,        -- 猪人
    -- pigguard = true,      -- 猪人守卫
    walrus = true,        -- 海象爸爸
}

-- 特定攻击间隔规避的生物
local cdKitePrefabs = {
    deerclops = 0.75,     -- 独眼巨鹿
}

-- 生物特定远离范围
local awayDistPrefabs = {
    pigman = 4,        -- 猪人
    pigguard = 4,      -- 猪人守卫
}

function GD_KiteAndAttack:Visit()
    local combat = self.inst.components.combat
    if self.status == READY then
        combat:ValidateTarget()

        if combat.target then
            self.inst.components.combat:BattleCry()
            self.startruntime = GetTime()
            self.numattacks = 0
            self.status = RUNNING
        else
            self.status = FAILED
        end
    end

    if self.status == RUNNING then
        -- local is_attacking = self.inst.sg:HasStateTag("attack")
        if not combat.target or not combat.target.entity:IsValid() then
            self.status = FAILED
            combat:SetTarget(nil)
            self.inst.components.locomotor:Stop()
        elseif combat.target.components.health and combat.target.components.health:IsDead() then
            self.status = SUCCESS
            combat:SetTarget(nil)
            self.inst.components.locomotor:Stop()
        else
            local equip = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            local targetCooldown = combat.target.components.combat:GetCooldown()
            local target_lastattacktime = combat.target.components.combat.laststartattacktime or 0
            local target_lastatk_rgtime = GetTime() - target_lastattacktime
            local target_areahitrange = combat.target.components.combat.areahitrange
            local hp = Point(combat.target.Transform:GetWorldPosition())
            local pt = Point(self.inst.Transform:GetWorldPosition())
            local dsq = distsq(hp, pt)
            local attackrange = combat.target.components.combat.attackrange
            local max_dist = awayDistPrefabs[combat.target.prefab] or math.max(self.safe_dist, attackrange + 1)
            if (target_lastatk_rgtime < 0.5 or targetCooldown > (cdKitePrefabs[combat.target.prefab] or 0.5)) and not combat.target.sg:HasStateTag("attack") then
                self.isaway = false
            end
            if (target_areahitrange == nil and self.inst ~= combat.target.components.combat.target)
               or (not self.isaway and targetCooldown > (cdKitePrefabs[combat.target.prefab] or 0.5))
               or noKitePrefabs[combat.target.prefab]
            --    or (noKitePrefabs[combat.target.prefab] and equip ~= nil and equip.components.weapon ~= nil and equip.components.weapon.damage > 30)
            then
                local angle = self.inst:GetAngleToPoint(hp)
                local r= self.inst.Physics:GetRadius()+ (combat.target.Physics and combat.target.Physics:GetRadius() + .1 or 0)
                local running = self.inst.components.locomotor:WantsToRun()
                
                if (running and dsq > r*r) or (not running and dsq > combat:CalcAttackRangeSq() ) then
                    --self.inst.components.locomotor:RunInDirection(angle)
                    local shouldRun = not self.walk
                    self.inst.components.locomotor:GoToPoint(hp, nil, shouldRun)
                elseif not (self.inst.sg and self.inst.sg:HasStateTag("jumping")) then
                    self.inst.components.locomotor:Stop()
                    if self.inst.sg:HasStateTag("canrotate") then
                        self.inst:FacePoint(hp)
                    end                
                end
                    
                if combat:TryAttack() then
                    -- reset chase timer when attack hits, not on attempts
                else
                    if not self.startruntime then
                        self.startruntime = GetTime()
                        self.inst.components.combat:BattleCry()
                    end
                end
                self:Sleep(.125)
            else
                self.isaway = true
                if targetCooldown == 0 then
                    local pos = self:GetKitePos(pt, hp, combat.target, attackrange)
                    self.inst.components.locomotor:GoToPoint(pos)
                else
                    local angle = self:GetRunAngle(pt, hp)
                    if angle ~= nil then
                        self.inst.components.locomotor:RunInDirection(angle)
                    else
                        self.isaway = false
                        self.inst.components.locomotor:Stop()
                    end

                    if dsq > max_dist * max_dist then
                        -- self.isaway = false
                        self.inst.components.locomotor:Stop()
                    end
                end
                self:Sleep(.25)
            end
        end
    end
end

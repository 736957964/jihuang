Bh_RunAway = Class(BehaviourNode, function(self, inst, hunterparams, see_dist, safe_dist, fn, runhome)
    BehaviourNode._ctor(self, "Bh_RunAway")
    self.safe_dist = safe_dist	--新的安全距离delta
    self.see_dist = see_dist	--新的观测距离
    if type(hunterparams) == "string" then
        self.huntertags = { hunterparams }
        self.hunternotags = { "noclick" }
    elseif type(hunterparams) == "table" then
        self.hunterfn = hunterparams.fn
        self.huntertags = hunterparams.tags
        self.hunternotags = hunterparams.notags
        self.hunteroneoftags = hunterparams.oneoftags
    else
        self.hunterfn = hunterparams
    end
    self.inst = inst
    self.runshomewhenchased = runhome
    self.shouldrunfn = fn
end)

function Bh_RunAway:__tostring()
    return string.format("Bh_RunAway %f from: %s", self.safe_dist, tostring(self.hunter))
end

function Bh_RunAway:GetRunAngle(pt, hp)
    if self.avoid_angle ~= nil then
        local avoid_time = GetTime() - self.avoid_time
        if avoid_time < 1 then
            return self.avoid_angle
        else
            self.avoid_time = nil
            self.avoid_angle = nil
        end
    end

	--反方向跑
	local angle
	--对于非玩家
	if not self.hunter:HasTag("player") then
		angle = self.inst:GetAngleToPoint(hp) + 180 -- + math.random(30)-15
		if angle > 360 then
			angle = angle - 360
		end
	--对于玩家
	else
		local hunter_angle = self.hunter.Transform:GetRotation()
		angle = hunter_angle + math.random(30)-15
		if angle > 360 then
			angle = angle - 360
		end
	end

    --print(string.format("Bh_RunAway:GetRunAngle me: %s, hunter: %s, run: %2.2f", tostring(pt), tostring(hp), angle))

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

function Bh_RunAway:Visit()
    if self.status == READY then
	
		--获得hunter
        self.hunter = FindEntity(self.inst, self.see_dist, self.hunterfn, self.huntertags, self.hunternotags, self.hunteroneoftags)

        if self.hunter ~= nil and self.shouldrunfn ~= nil and not self.shouldrunfn(self.hunter) then
            self.hunter = nil
        end
		
		--节点失败的条件: 没有hunter, hunter是墙壁, hunter不在开始逃跑距离内: 失败之后到下一个节点
		--节点成功条件: 离hunter比较安全的区域, 逃跑时间结束: 成功之后回顶节点
		
		if self.hunter==nil or self.hunter:HasTag("wall") or 
			not self.hunter:IsNear(self.inst, (self.hunter.components.combat and self.hunter.components.combat:CalcHitRangeSq(self.inst) or 0)+self.inst.zg_startrunaway_dist ) 
			then
			
			self.status=FAILED
		else
			self.status=RUNNING
		end

        --self.status = self.hunter ~= nil and RUNNING or FAILED
		--[[
		if self.hunter and not self.hunter:HasTag("wall") then
			--尝试逃跑
			self.status=RUNNING
		else
			self.status=FAILED
		end]]
    end

    if self.status == RUNNING then
	
        if self.hunter == nil or not self.hunter.entity:IsValid() or self.hunter:HasTag("wall") or
			not self.hunter:IsNear(self.inst, (self.hunter.components.combat and self.hunter.components.combat:CalcAttackRangeSq(self.inst) or 0)+(self.hunter:HasTag("wall") and 0 or self.inst.zg_startrunaway_dist) ) 
			then
            self.status = FAILED
            self.inst.components.locomotor:Stop()
			
        else
            if self.runshomewhenchased and
                self.inst.components.homeseeker ~= nil then
                self.inst.components.homeseeker:GoHome(true)
            else
                local pt = self.inst:GetPosition()
                local hp = self.hunter:GetPosition()

                local angle = self:GetRunAngle(pt, hp)
                if angle ~= nil then
                    self.inst.components.locomotor:RunInDirection(angle)
                else
                    self.status = FAILED
                    self.inst.components.locomotor:Stop()
                end

				--成功条件1
				local stop_dist=self.safe_dist+(self.hunter.components.combat and self.hunter.components.combat:CalcHitRangeSq(self.inst) or 0)
                if distsq(hp, pt) > stop_dist * stop_dist then
                    self.status = SUCCESS
                    self.inst.components.locomotor:Stop()
                end
				
				--成功条件2
				if self.inst.components.combat and not self.inst.components.combat:InCooldown() and self.hunter:HasTag("player") then
					self.status = SUCCESS
                    self.inst.components.locomotor:Stop()
				end
				
            end

            self:Sleep(self.inst.zg_runaway_period)
        end
    end
end

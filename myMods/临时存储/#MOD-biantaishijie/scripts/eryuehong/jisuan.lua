local g=GLOBAL
local TheNet = g.TheNet
local GetTime = g.GetTime
local TheWorld = g.TheWorld
local TUNING = g.TUNING
local TheSim = g.TheSim
local AllPlayers = g.AllPlayers
local EQUIPSLOTS = g.EQUIPSLOTS


----被攻击时调用, 作为回调函数
local function Zg_GetDisplay_Resistance(inst, destimuli)

	local max = inst["zg_max_anti_"..destimuli] or .75
	local res = inst["zg_inh_anti_"..destimuli] or 0

	local inventory = inst.components.inventory
	if inventory then
	
		----装备栏增加的
		for k, v in pairs(inventory.equipslots) do
			 local res2 = v["zg_add_anti_"..destimuli] or 0
			 res = res + res2
			 
			 local max2 = v["zg_ext_anti_"..destimuli] or 0
			 max = max + max2
		end
		
		----物品栏增加的
		for k, v in pairs(inventory.itemslots) do
			 local res3 = v["zg_addinv_anti_"..destimuli] or 0
			 res = res + res3
			 
			 local max3 = v["zg_extinv_anti_"..destimuli] or 0
			 max = max + max3
		end
		
	end
	
	----祝福或诅咒
	
	
	
	----最后判定
	if max > 1 then
		max = 1
	end
	if res > max then
		res = max
	end
	
	return res
	
end

----对于持续性火焰伤害,修改DoFireDamage即可
AddComponentPostInit("health", function(cmp)
	
	function cmp:DoFireDamage(amount, doer, instant, nodmgdisplay)
		if not self.invincible then
			if not self.takingfiredamage then
				self.takingfiredamage = true
				self.takingfiredamagestarttime = GetTime()
				self.inst:StartUpdatingComponent(self)
				self.inst:PushEvent("startfiredamage")
				--ProfileStatsAdd("onfire")
			end

			local time = GetTime()
			self.lastfiredamagetime = time

			if (instant or time - self.takingfiredamagestarttime > self.fire_timestart) and amount > 0 then

				--We're going to take damage at this point, so make sure it's now over the cap/second
				if self.firedamagecaptimer <= time then
					self.firedamageinlastsecond = 0
					self.firedamagecaptimer = time + 1
				end

				if self.firedamageinlastsecond + amount > TUNING.MAX_FIRE_DAMAGE_PER_SECOND then
					amount = TUNING.MAX_FIRE_DAMAGE_PER_SECOND - self.firedamageinlastsecond
				end

				--self:DoDelta(-amount*self.fire_damage_scale, false, "fire")
				--if self.inst.components.combat then
				--	self.inst.components.combat:Zg_GetAttacked("fire", amount, nil, "zg_ele_fire", true)
				--end
				
				----燃烧的火焰不经过盾牌
				
				----装备提供的抗性
				if self.inst.components.inventory then
					amount = self.inst.components.inventory:Zg_ApplyHurt(amount, nil, nil, "fire")	
				end
				----获取自身的抗性(可被装备特殊属性加成)
				local resistance = Zg_GetDisplay_Resistance(self.inst, "fire")
				amount = amount * (1 - resistance)
				
				----实施dodelta
				self:DoDelta(-amount, nodmgdisplay, "fire")
				
				self.inst:PushEvent("firedamage")       

				self.firedamageinlastsecond = self.firedamageinlastsecond + amount
			end
		end
	end
	
end)

AddComponentPostInit("inventory", function(cmp)

	function cmp:Zg_ApplyHurt(damage, attacker, weapon, destimuli)
	
		--分担计算分数,计算剩余伤害
		local absorbed_percent = 0
		local total_absorption = 0	--正防御
		
		local deabsorbed_percent = 0
		local detotal_absorption = 0 	--负防御 
		
		for k, v in pairs(self.equipslots) do
			if v and v["zg_equ_anti_"..destimuli] and v["zg_equ_anti_"..destimuli] ~= 0 then
				absorbed_percent = math.max( v["zg_equ_anti_"..destimuli], absorbed_percent )
				total_absorption = total_absorption + ( v["zg_equ_anti_"..destimuli] > 0 and v["zg_equ_anti_"..destimuli] or 0 )
				
				deabsorbed_percent = math.min( v["zg_equ_anti_"..destimuli], deabsorbed_percent )
				detotal_absorption = detotal_absorption + ( v["zg_equ_anti_"..destimuli] < 0 and v["zg_equ_anti_"..destimuli] or 0 )
			end
		end
		
		local absorbed_damage = damage * absorbed_percent	----吸收伤害由正防御来吸收, 负防御只是表现护甲自己抵御不了该属性伤害
		local deabsorbed_damage = damage * deabsorbed_percent
		
		local leftover_damage = damage - absorbed_damage
		
		--护甲消耗
		if total_absorption > 0 then
			for k, v in pairs(self.equipslots) do
				if v and v.components.armor and v["zg_equ_anti_"..destimuli] and v["zg_equ_anti_"..destimuli] > 0 then
					----防具为主人吸收伤害
					v.components.armor:TakeDamage( absorbed_damage * v["zg_equ_anti_"..destimuli] / total_absorption )
				end
			end
		end
		if detotal_absorption < 0 then
			for k, v in pairs(self.equipslots) do
				if v and v.components.armor and v["zg_equ_anti_"..destimuli] and v["zg_equ_anti_"..destimuli] < 0 then
					----防具自己承受伤害
					v.components.armor:TakeDamage( - deabsorbed_damage * v["zg_equ_anti_"..destimuli] / detotal_absorption )
				end
			end
		end
		
		return leftover_damage
	end
	
end)


AddComponentPostInit("combat", function(cmp)

	--function cmp:GetAttacked(attacker, damage, weapon, stimuli)
		----不走这条线
	--end
	
	--紧急分享目标
	function cmp:wy_ShareTarget(target, range, fn, maxnum)
		if maxnum <= 0 then
			return
		end

		local x, y, z = self.inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, g.SpringCombatMod(range), { "_combat" })

		local num_helpers = 0
		for i, v in ipairs(ents) do
			if v ~= self.inst
				and not (v.components.health ~= nil and
						v.components.health:IsDead())
				and fn(v)
				and v.components.combat:SetTarget(target) then

				num_helpers = num_helpers + 1

				if num_helpers >= maxnum then
					return
				end
			end
		end
	end
	
	----重写aoe
	function cmp:DoAreaAttack(target, range, weapon, validfn, stimuli, excludetags)
		local hitcount = 0
		local x, y, z = target.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, range, { "_combat" }, excludetags)
		for i, ent in ipairs(ents) do
			if ent ~= target and
				ent ~= self.inst and
				self:IsValidTarget(ent) and
				(validfn == nil or validfn(ent)) then
				self.inst:PushEvent("onareaattackother", { target = target, weapon = weapon, stimuli = stimuli })
				ent.components.combat:Zg_GetAttacked(self.inst, self:CalcDamage(ent, weapon, self.areahitdamagepercent), weapon, stimuli)
				hitcount = hitcount + 1
			end
		end
		return hitcount
	end
	
	----重写计算规则	
	function cmp:CalcDamage(target, weapon, multiplier)
		if target:HasTag("alwaysblock") then
			return 0
		end

		local basedamage
		
		
		--local basemultiplier = self.damagemultiplier
		--local dmg_mult = self.damagemultiplier or 1
		local basemultiplier = self.damagemultiplier or 1
		
		
		local bonus = self.damagebonus --not affected by multipliers
		local playermultiplier = target ~= nil and target:HasTag("player")
		local pvpmultiplier = playermultiplier and self.inst:HasTag("player") and self.pvp_damagemod or 1

		--NOTE: playermultiplier is for damage towards players
		--      generally only applies for NPCs attacking players

		if weapon ~= nil then
			--No playermultiplier when using weapons
			basedamage = weapon.components.weapon.damage or 0
			playermultiplier = 1
		else
			basedamage = self.defaultdamage
			playermultiplier = playermultiplier and self.playerdamagepercent or 1

			if self.inst.components.rider ~= nil and self.inst.components.rider:IsRiding() then
				local mount = self.inst.components.rider:GetMount()
				if mount ~= nil and mount.components.combat ~= nil then
					basedamage = mount.components.combat.defaultdamage
					basemultiplier = mount.components.combat.damagemultiplier
					bonus = mount.components.combat.damagebonus
				end

				local saddle = self.inst.components.rider:GetSaddle()
				if saddle ~= nil and saddle.components.saddler ~= nil then
					basedamage = basedamage + saddle.components.saddler:GetBonusDamage()
				end
			end
		end

		return basedamage
			* (basemultiplier or 1)
			* (multiplier or 1)
			* playermultiplier
			* pvpmultiplier
			+ (bonus or 0)
	end
	
	----重写攻击
	function cmp:DoAttack(target_override, weapon, projectile, stimuli, instancemult, nostill)
		local targ = target_override or self.target
		local weapon = weapon or self:GetWeapon()

		if not self:CanHitTarget(targ, weapon) then
			self.inst:PushEvent("onmissother", { target = targ, weapon = weapon })
			if self.areahitrange ~= nil then
				self:DoAreaAttack(projectile or self.inst, self.areahitrange, weapon, nil, stimuli)
			end
			return
		end

		self.inst:PushEvent("onattackother", { target = targ, weapon = weapon, projectile = projectile, stimuli = stimuli })

		if weapon ~= nil and projectile == nil then
			if weapon.components.projectile ~= nil then
				local projectile = self.inst.components.inventory:DropItem(weapon, false)
				if projectile ~= nil then
					projectile.components.projectile:Throw(self.inst, targ)
				end
				return

			elseif weapon.components.complexprojectile ~= nil then
				local projectile = self.inst.components.inventory:DropItem(weapon, false)
				if projectile ~= nil then
					projectile.components.complexprojectile:Launch(targ:GetPosition(), self.inst)
				end
				return

			elseif weapon.components.weapon:CanRangedAttack() then
				weapon.components.weapon:LaunchProjectile(self.inst, targ)
				return
			end
		end

		local reflected_dmg = 0
		local reflect_list = {}
		if targ.components.combat ~= nil then
			local mult =
				(stimuli == "electric" or
				(weapon ~= nil and weapon.components.weapon ~= nil and weapon.components.weapon.stimuli == "electric"))
				and not (targ:HasTag("electricdamageimmune") or
						(targ.components.inventory ~= nil and targ.components.inventory:IsInsulated()))
				and TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT * (targ.components.moisture ~= nil and targ.components.moisture:GetMoisturePercent() or (targ:GetIsWet() and 1 or 0))
				or 1
			--local dmg = self:CalcDamage(targ, weapon, mult) * (instancemult or 1)
			local dmg = self:CalcDamage(targ, weapon, mult)
			 
			if projectile == nil then
				reflected_dmg = self:CalcReflectedDamage(targ, dmg, weapon, stimuli, reflect_list)
			end
			targ.components.combat:Zg_GetAttacked(self.inst, dmg, weapon, stimuli, nostill)
		elseif projectile == nil then
			reflected_dmg = self:CalcReflectedDamage(targ, 0, weapon, stimuli, reflect_list)
		end

		if weapon ~= nil then
			weapon.components.weapon:OnAttack(self.inst, targ, projectile)
		end

		if self.areahitrange ~= nil then
			self:DoAreaAttack(targ, self.areahitrange, weapon, nil, stimuli)
		end

		self.lastdoattacktime = GetTime()

		if reflected_dmg > 0 and self.inst.components.health ~= nil and not self.inst.components.health:IsDead() then
			self:Zg_GetAttacked(targ, reflected_dmg)
			for i, v in ipairs(reflect_list) do
				if v.inst:IsValid() then
					v.inst:PushEvent("onreflectdamage", v)
				end
			end
		end
	end
	
	----猪哥的计算伤害
	function cmp:Zg_GetAttacked(attacker, damage, weapon, stimuli, nostill)
	
		local stimuli2 = weapon and weapon.components.weapon and weapon.components.weapon.stimuli 

		local dmg = damage or 0
	
		----非普通物理伤害列表
		local stimulitable = 
		{
			"fire", "ice", "electric", "stone", "wood", "ray",
			"dark",   
			"bone", --不是骨头的意思, 而是魔法伤害的意思, 意思是渗透到骨髓的夸张的修辞手法
			--物理伤害, 还要进行一次ApplyDamage, 比如子弹属于zg_ele_physics大类
			"bullet",
		}
		
		for k, v in pairs(stimulitable) do
			if stimuli == "zg_ele_"..v or stimuli2 == "zg_ele_"..v then
			
				local zg_dmg = dmg
				
				----盾牌提供的格挡, 暗属性和魔法不能格挡
				if v ~= "dark" and v ~= "bone" then
					
					----检测盾牌
					local shield = nil
		
					if self.inst.components.inventory then
						shield = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.ZGHAND2)
					end
					
					local hasshield = shield and shield:HasTag("zg_shield") or nil 
					if hasshield then
					
						----格挡率
						local block = shield["zg_shield_block"] or 0		--法向格挡率
						if block > 1 then block = 1 end
						
						local absorb = shield["zg_shield_absorb"] or 0		--格挡成功时伤害吸收
						if absorb > 1 then absorb = 1 end
						
						local true_block = 0 		--真实格挡率
					
						
						----计算实际格挡率
						if attacker then
						
							--获取当前朝向
							local theta = self.inst.Transform:GetRotation()
							local theta2 = self.inst:GetAngleToPoint( attacker:GetPosition():Get() )
							local delta = math.abs( theta-theta2 )
								
							if delta > 90 then
								true_block = 0
							else
								true_block = ( 1 - delta / 90 ) * block
							end
							
						end
						
						----格挡成功时
						if math.random() < true_block then
						
						----格挡失败时伤害吸收
						else
							absorb = shield["zg_shield_absorb2"] or 0	--格挡失败时伤害吸收	
							if absorb > 1 then absorb = 1 end
						end
						
						----盾牌承受伤害
						if shield.components.armor then
							shield.components.armor:TakeDamage( zg_dmg * absorb )
						end	
						----剩余伤害
						zg_dmg = zg_dmg * ( 1 - absorb )
						
					end
					
				end
				
				----装备提供的抗性
				if self.inst.components.inventory then
					zg_dmg = self.inst.components.inventory:Zg_ApplyHurt(zg_dmg, attacker, weapon, v)	
				end
				
				----获取自身的抗性(可被装备特殊属性加成)
				local resistance = Zg_GetDisplay_Resistance(self.inst, v)
				zg_dmg = zg_dmg * (1 - resistance)
				
				--[[
				if zg_dmg<=0 and (stimuli=="zg_ele_dark" or stimuli2=="zg_ele_dark") and attacker and attacker.components.talker then
					attacker.components.talker:Say("暗系无效需要暗属性武器")
				end]]
				
				return self:Zg_OK_GetAttacked(attacker, zg_dmg, weapon, stimuli, nostill)
				
			end
		end
		
		----检测盾牌
		
		--print(EQUIPSLOTS.ZGHAND2)
		
		local shield = nil
		
		if self.inst.components.inventory then
			shield = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.ZGHAND2)
		end
		
		local hasshield = shield and shield:HasTag("zg_shield") or nil 
		if hasshield then
			--print("ok")
			----格挡率
			local block = shield["zg_shield_block"] or 0		--法向格挡率
			if block > 1 then block = 1 end
			
			local absorb = shield["zg_shield_absorb"] or 0		--格挡时伤害吸收
			if absorb > 1 then absorb = 1 end
			
			local true_block = 0 		--真实格挡率
			
			----计算实际格挡率
			if attacker then
				
				--获取当前朝向
				local theta = self.inst.Transform:GetRotation()
				local theta2 = self.inst:GetAngleToPoint( attacker:GetPosition():Get() )
				local delta = math.abs( theta-theta2 )
				if delta > 90 then
					true_block = 0
				else
					true_block = ( 1 - delta / 90 ) * block
				end
				
			end
			
			----格挡成功时
			if math.random() < true_block then
				
			----格挡失败时伤害吸收
			else
				absorb = shield["zg_shield_absorb2"] or 0	--格挡失败时伤害吸收	
				if absorb > 1 then absorb = 1 end
			end
				
			----盾牌承受伤害
			if shield.components.armor then
				shield.components.armor:TakeDamage( dmg * absorb )
			end
			----剩余伤害
			dmg = dmg * ( 1 - absorb )
			
		end
		
		----普通物理攻击
		return self:Zg_OK_GetAttacked(attacker, dmg, weapon, stimuli, nostill)
		
	end

	----普通物理攻击
	function cmp:Zg_OK_GetAttacked(attacker, damage, weapon, stimuli, nostill)
		self.lastwasattackedtime = GetTime()

		local stimuli2 = weapon and weapon.components.weapon and weapon.components.weapon.stimuli 
		
		local blocked = false
		local damageredirecttarget = self.redirectdamagefn ~= nil and self.redirectdamagefn(self.inst, attacker, damage, weapon, stimuli) or nil

		self.lastattacker = attacker
		
---------------------------------------------------------------------		
		----触发被击中事件(被击中而已,是否输出伤害不一定)
		self.inst:PushEvent("zg_pre_attacked", { attacker = attacker, weapon = weapon, stimuli = stimuli})
		if attacker then
			attacker:PushEvent("zg_pre_onhitother", { target = self.inst, weapon = weapon, stimuli = stimuli })
		end
---------------------------------------------------------------------		

		if self.inst.components.health ~= nil and damage ~= nil and damageredirecttarget == nil then
		
			--local stimuli2 = weapon and weapon.components.weapon and weapon.components.weapon.stimuli 
		
			----这个只是针对物理伤害
			if (stimuli == nil and stimuli2 == nil) or (stimuli == "zg_ele_bullet" or stimuli2 == "zg_ele_bullet") then
				----防具防护
				if self.inst.components.inventory then
					damage = self.inst.components.inventory:ApplyDamage(damage, attacker, weapon)
				end
				----物理伤害抗性,当然要在护甲层更内部
				local resistance = Zg_GetDisplay_Resistance(self.inst, "physics")
				damage = damage * (1 - resistance)
			
			----电流伤害判断潮湿度, 伤害倍数因子
			elseif (stimuli == "zg_ele_electric" or stimuli2 == "zg_ele_electric") then
				local mult = 1
				mult = mult + 1.5 * ( self.inst.components.moisture and self.inst.components.moisture:GetMoisturePercent() or (self.inst:GetIsWet() and 1 or 0) )
				damage = damage * mult
			end
			
			if damage > 0 and not self.inst.components.health:IsInvincible() then
				--Bonus damage only applies after unabsorbed damage gets through your armor
				if attacker ~= nil and attacker.components.combat ~= nil and attacker.components.combat.bonusdamagefn ~= nil then
					damage = damage + attacker.components.combat.bonusdamagefn(attacker, self.inst, damage, weapon) or 0
				end
				local cause = attacker == self.inst and weapon or attacker
				self.inst.components.health:DoDelta(-damage, nil, cause ~= nil and (cause.nameoverride or cause.prefab) or "NIL", nil, cause)
				if self.inst.components.health:IsDead() then
					if attacker ~= nil then
						attacker:PushEvent("killed", { victim = self.inst })
						attacker:PushEvent("zg_killed", { victim = self.inst })
					end
					if self.onkilledbyother ~= nil then
						self.onkilledbyother(self.inst, attacker)
					end
				end
			else
				blocked = true
			end
		end

		local redirect_combat = damageredirecttarget ~= nil and damageredirecttarget.components.combat or nil
		if redirect_combat ~= nil then
			redirect_combat:Zg_GetAttacked(attacker, damage, weapon, stimuli)
		end

		if self.inst.SoundEmitter ~= nil and not self.inst:IsInLimbo() then
			local hitsound = self:GetImpactSound(damageredirecttarget or self.inst, weapon)
			if hitsound ~= nil then
				self.inst.SoundEmitter:PlaySound(hitsound)
			end
			if damageredirecttarget ~= nil then
				if redirect_combat ~= nil and redirect_combat.hurtsound ~= nil then
					self.inst.SoundEmitter:PlaySound(redirect_combat.hurtsound)
				end
			elseif self.hurtsound ~= nil then
				self.inst.SoundEmitter:PlaySound(self.hurtsound)
			end
		end

		if not blocked then
			self.inst:PushEvent("attacked", 
				{ attacker = attacker, damage = damage, weapon = weapon, stimuli = stimuli, redirected=damageredirecttarget, nostill = nostill, stimuli2 = stimuli2 }
			)

			if self.onhitfn ~= nil then
				self.onhitfn(self.inst, attacker, damage)
			end

			if attacker ~= nil then
				attacker:PushEvent("onhitother", { target = self.inst, damage = damage, stimuli = stimuli, redirected=damageredirecttarget })
				if attacker.components.combat ~= nil and attacker.components.combat.onhitotherfn ~= nil then
					attacker.components.combat.onhitotherfn(attacker, self.inst, damage, stimuli)
				end
			end
		else
			self.inst:PushEvent("blocked", { attacker = attacker })
		end

		return not blocked
	end

end)
------------------------------------------------------------------------------------------------------------------------

--定义全局变量
local CAMERASHAKE = GLOBAL.CAMERASHAKE



--其他和GetAttacked有关的组件
AddComponentPostInit("explosive", function(cmp)

	function cmp:OnBurnt()
		for i, v in ipairs(AllPlayers) do
			local distSq = v:GetDistanceSqToInst(self.inst)
			local k = math.max(0, math.min(1, distSq / 1600))
			local intensity = k * (k - 2) + 1 --easing.outQuad(k, 1, -1, 1)
			if intensity > 0 then
				v:ScreenFlash(intensity)
				v:ShakeCamera(CAMERASHAKE.FULL, .7, .02, intensity / 2)
			end
		end

		if self.onexplodefn ~= nil then
			self.onexplodefn(self.inst)
		end

		local stacksize = self.inst.components.stackable ~= nil and self.inst.components.stackable:StackSize() or 1
		local totaldamage = self.explosivedamage * stacksize

		local x, y, z = self.inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, self.explosiverange, nil, { "INLIMBO" })

		for i, v in ipairs(ents) do
			if v ~= self.inst and v:IsValid() and not v:IsInLimbo() then
				if v.components.workable ~= nil and v.components.workable:CanBeWorked() then
					v.components.workable:WorkedBy(self.inst, self.buildingdamage)
				end

				--Recheck valid after work
				if v:IsValid() and not v:IsInLimbo() then
					if self.lightonexplode and
						v.components.fueled == nil and
						v.components.burnable ~= nil and
						not v.components.burnable:IsBurning() and
						not v:HasTag("burnt") then
						v.components.burnable:Ignite()
					end

					if v.components.combat ~= nil then
						v.components.combat:Zg_GetAttacked(self.inst, totaldamage, nil)
					end

					v:PushEvent("explosion", { explosive = self.inst })
				end
			end
		end

		local world = GLOBAL.TheWorld
		for i = 1, stacksize do
			world:PushEvent("explosion", { damage = self.explosivedamage })
		end

		if self.inst.components.health ~= nil then
			self.inst:PushEvent("death")
		end

		self.inst:Remove()
	end
	
end)

AddComponentPostInit("grue", function(cmp)

	function cmp:OnUpdate(dt)
		if self.nextHitTime ~= nil and self.nextHitTime > 0 then
			self.nextHitTime = self.nextHitTime - dt
		end

		if self.nextSoundTime ~= nil and self.nextSoundTime > 0 then
			self.nextSoundTime = self.nextSoundTime - dt

			if self.nextSoundTime <= 0 then
				if self.soundwarn ~= nil then
					self.inst.SoundEmitter:PlaySound(self.soundwarn)
				end
				self.inst:DoTaskInTime(self.warndelay, self.inst.PushEvent, "heargrue")
			end
		end

		if self.nextHitTime ~= nil and self.nextHitTime <= 0 then
			self.nextHitTime = self.nextHitTime - dt
			self.nextSoundTime = self.nextSoundTime - dt
			self.inst.components.combat:Zg_GetAttacked(nil, TUNING.GRUEDAMAGE, nil, "darkness")
			self.inst.components.sanity:DoDelta(-TUNING.SANITY_MEDLARGE)

			self.nextHitTime = 5 + math.random() * 6
			self.nextSoundTime = self.nextHitTime * (.4 + math.random() * .4)
			if self.soundattack ~= nil then
				self.inst.SoundEmitter:PlaySound(self.soundattack)
			end

			self.inst:PushEvent("attackedbygrue")
		end
	end

end)


----------------------------------------------------------------------------------
local stimulitable2 = 
{
	"fire", "ice", "electric", "stone", "wood",
	
	"dark", "ray",  
	
	"bone", 
	
	"bullet", "physics",
}
----------元素化时代
local function AddDark(inst)

	if inst and TheNet:GetIsServer() then
		
		for k, v in pairs(stimulitable2) do
			if v == "dark" then
				inst["zg_inh_anti_"..v] = .25
				inst["zg_max_anti_"..v] = 1
			else
				inst["zg_inh_anti_"..v] = .9
				inst["zg_max_anti_"..v] = .9
			end
		end
		
	end
end
AddPrefabPostInit("crawlinghorror", AddDark)
AddPrefabPostInit("terrorbeak", AddDark)
AddPrefabPostInit("crawlingnightmare", AddDark)
AddPrefabPostInit("nightmarebeak", AddDark)

local function AddDark2(inst)
	if inst and TheNet:GetIsServer() then
	
		if inst.components.weapon then
			inst.components.weapon.stimuli = "zg_ele_dark"
		end
		
	end	
end
AddPrefabPostInit("nightsword", AddDark2)

-----------------------------------------------------------重写grogginess方法---------------------------------------
--[[
AddComponentPostInit("grogginess", function(cmp)

	
	local function DefaultKnockoutTest1(inst)
		local self = inst.components.grogginess
		return self.grog_amount >= self.resistance
			and not (inst.components.health ~= nil and inst.components.health.takingfiredamage)
			and not (inst.components.burnable ~= nil and inst.components.burnable:IsBurning())
	end

	local function DefaultComeToTest1(inst)
		local self = inst.components.grogginess
		return self.knockouttime > self.knockoutduration and self.grog_amount < self.resistance
	end

	local function DefaultWhileGroggy1(inst)
		--assume grog_amount > 0
		--local self = inst.components.grogginess
		--local pct = self.grog_amount < self.resistance and self.grog_amount / self.resistance or 1
		--local speed_mod = Remap(pct, 1, 0, TUNING.MIN_GROGGY_SPEED_MOD, TUNING.MAX_GROGGY_SPEED_MOD)
		--inst.components.locomotor:SetExternalSpeedMultiplier(inst, "grogginess", speed_mod)
	end

	local function DefaultWhileWearingOff1(inst)
		--assume wearofftime > 0
		--local self = inst.components.grogginess
		--local pct = self.wearofftime < TUNING.GROGGINESS_WEAR_OFF_DURATION and easing.inQuad(self.wearofftime / TUNING.GROGGINESS_WEAR_OFF_DURATION, 0, 1, 1) or 1
		--local speed_mod = Remap(pct, 0, 1, TUNING.MAX_GROGGY_SPEED_MOD, 1)
		--inst.components.locomotor:SetExternalSpeedMultiplier(inst, "grogginess", speed_mod)
	end

	local function DefaultOnWearOff1(inst)
		--inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "grogginess")
	end

	
	function cmp:SetDefaultTests()
		self.knockouttestfn = DefaultKnockoutTest1
		self.cometotestfn = DefaultComeToTest1
		self.whilegroggyfn = DefaultWhileGroggy1
		self.whilewearingofffn = DefaultWhileWearingOff1
		self.onwearofffn = DefaultOnWearOff1
	end
----------------------------------------------------------
	function cmp:AddGrogginess(grogginess, knockoutduration)
		if grogginess <= 0 then
			return
		end

		self.grog_amount = self.grog_amount + grogginess
		self.wearofftime = 0

		--if not self.inst:HasTag("groggy") then
			--self.inst:AddTag("groggy")
			self.inst:StartUpdatingComponent(self)
			self.knockouttime = 0
		--end

		if self.knockouttestfn ~= nil and self.knockouttestfn(self.inst) then
			if not self:IsKnockedOut() then
				self.knockouttime = 0
			end
			self.knockoutduration = math.max(self.knockoutduration, knockoutduration or TUNING.MIN_KNOCKOUT_TIME)
			self:KnockOut()
		end
	end
	
	function cmp:OnUpdate(dt)
		self.grog_amount = math.max(0, self.grog_amount - self.decayrate)

		if self:IsKnockedOut() then
			self.knockouttime = self.knockouttime + dt
			if self.cometotestfn ~= nil and self.cometotestfn(self.inst) then
				self:ComeTo()
			end
		elseif self.grog_amount <= 0 then
			--self.inst:RemoveTag("groggy")
			self.wearofftime = math.min(self.wearoffduration, self.wearofftime + dt)
			if self.wearofftime >= self.wearoffduration then
				self.inst:StopUpdatingComponent(self)
				self.knockouttime = 0
				self.knockoutduration = 0
				self.wearofftime = 0
				if self.onwearofffn ~= nil then
					self.onwearofffn(self.inst)
				end            
			elseif self.whilewearingofffn ~= nil then
				self.whilewearingofffn(self.inst)
			end
		elseif self.whilegroggyfn ~= nil then
			self.whilegroggyfn(self.inst)
		end
	end
	
	function cmp:OnRemoveFromEntity()
		--if self.inst:HasTag("groggy") then
			--self.inst:RemoveTag("groggy")
			if self.onwearofffn ~= nil then
				self.onwearofffn(self.inst)
			end
		--end
	end


end)]]

-----------------------------------------------------------官方带抗性的物体-----------------------------------------

----鳞甲
local function armordragonflyfn(inst)
	--if inst and TheNet:GetIsServer() then
		inst["zg_equ_anti_fire"] = .75	
	--end	
end
AddPrefabPostInit("armordragonfly", armordragonflyfn)

----雨衣
local function raincoatfn(inst)
	--if inst and TheNet:GetIsServer() then
		inst["zg_equ_anti_electric"] = .5	
	--end	
end
AddPrefabPostInit("raincoat", raincoatfn)

----眼球伞
local function eyebrellahatfn(inst)
	--if inst and TheNet:GetIsServer() then
		inst["zg_equ_anti_electric"] = .75	
	--end	
end
AddPrefabPostInit("eyebrellahat", eyebrellahatfn)

----暗影甲
local function armor_sanityfn(inst)
	--if inst and TheNet:GetIsServer() then
		inst["zg_equ_anti_dark"] = .25	
	--end	
end
AddPrefabPostInit("armor_sanity", armor_sanityfn)

----木甲
local function armorwoodfn(inst)
	--if inst and TheNet:GetIsServer() then	
	
		----一个是护甲承受, 另一个是为主角降低抗性
		inst["zg_equ_anti_fire"] = -1.5
		inst["zg_add_anti_fire"] = -1.5
		
		--inst["zg_equ_anti_wood"] = .33
	--end	
end
AddPrefabPostInit("armorwood", armorwoodfn)

----草甲
local function armorgrassfn(inst)
	--if inst and TheNet:GetIsServer() then	
		inst["zg_equ_anti_fire"] = -1.25
		inst["zg_add_anti_fire"] = -1.25
		
		--inst["zg_equ_anti_wood"] = .33
	--end
end
AddPrefabPostInit("armorgrass", armorgrassfn)


----垃圾清理

AddPrefabPostInit("researchlab", function(inst)

	if inst and GLOBAL.TheNet:GetIsServer() then

		inst:AddComponent("talker")
		--inst:DoPeriodicTask(10,function()
		--	inst.components.talker:Say("把垃圾给我,我可以帮你销毁哦!")
		--end)
		
		inst:AddComponent("trader")
		inst.components.trader.acceptnontradable=true
		inst.components.trader:SetAcceptTest(function(inst, item)
			return item and not item:HasTag("zg_task_key")
		end)
		inst.components.trader.onaccept = function(inst, giver, item)
			inst.components.talker:Say("垃圾销毁成功!")
			inst.AnimState:PlayAnimation("use")
			inst.AnimState:PushAnimation("idle")
		end
	
	end

end)

















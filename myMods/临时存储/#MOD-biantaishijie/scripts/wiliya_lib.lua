--反复用到的函数

--寻找目标
function wy_FindEntity(inst, radius, fn, musttags, canttags, mustoneoftags)
    if inst then
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, radius, musttags, canttags, mustoneoftags) 
        for i, v in ipairs(ents) do
            if v and v ~= inst and (fn == nil or fn(v, inst)) then
                return v
            end
        end
    end
end

--获取世界天数
function wy_worldday()
	return TheWorld.state.cycles or 0
end

--统计表格的key数
function wy_getn(a)
	local count=0
	for k,v in pairs(a) do
		if v~=nil then
			count=count+1
		end
	end
	return count
end

--寻找最近的实体
function wy_GetClosestInstWithName(name, inst, radius)
	local entities={}
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, radius)
	for k,v in ipairs(ents) do
		if type(name)=="string" then
			if v.prefab==name then
				table.insert(entities,v)
			end
		elseif type(name)=="table" then
			for i,j in pairs(name) do
				if v.prefab==j then
					table.insert(entities,v)
					break	
				end
			end
		end
	end
	
    return entities[1] ~= inst and entities[1] or entities[2]
end

--染色
function wy_addcolor(inst,tab)
	if inst and inst.AnimState then
		inst.AnimState:SetAddColour(unpack(tab))
	end
end
function wy_multcolor(inst,tab)
	if inst and inst.AnimState then
		inst.AnimState:SetMultColour(unpack(tab))
	end
end
--大小
function wy_scale(inst,x,y,z)
	local x=x or 1
	if inst and inst.Transform then
		if not y or not z then
			inst.Transform:SetScale(x,x,x)
		else
			inst.Transform:SetScale(x,y,z)
		end
	end
end

--有武器吗？
function wy_hasweapon(inst)
	local inv=inst.components.inventory
	return inv and inv:GetEquippedItem(EQUIPSLOTS.HANDS)
end	
--需要装备武器吗？
function wy_needweapon(inst)
	return inst.components.inventory and not wy_hasweapon(inst)
end


--添加材质
function wy_asset(tab,t,name)
	if type(tab)~="table" or t==nil or name==nil then return end
	if t=="anim" then
		table.insert(tab, Asset("ANIM","anim/"..name..".zip") )
	elseif t=="atlas" then
		table.insert(tab, Asset("ATLAS","images/"..name..".xml") )
	end
end
--设置物品栏图片
function wy_atlas(inst,name)	
	if inst.components.inventoryitem then
		inst.components.inventoryitem.atlasname="images/"..name..".xml"
		inst.components.inventoryitem.imagename=name
	end
end

--活着?
function wy_isalive(inst)
	return inst and inst.components.health and not inst.components.health:IsDead() and not inst:HasTag("playerghost")
end

--加血
function wy_ghealth(inst,delta,overtime)
	if wy_isalive(inst) then
		inst.components.health:DoDelta(delta,overtime)
	end
end
function wy_ghunger(inst,delta,overtime)
	if wy_isalive(inst) then
		inst.components.hunger:DoDelta(delta,overtime)
	end
end
function wy_gsanity(inst,delta,overtime)
	if wy_isalive(inst) then
		inst.components.sanity:DoDelta(delta,overtime)
	end
end

--被攻击 - 反击攻击者
function q1attacked(inst,sharefn)
	local function OnAttacked(inst, data)
		local attacker = data and data.attacker
		if attacker then
			if inst.components.combat:CanTarget(attacker) and not attacker:HasTag("q1boss") and not attacker:HasTag("shadowboss") then
				inst.components.combat:SetTarget(attacker)
				if sharefn then
					sharefn(inst,attacker)
				end
			end
		end
	end
	inst:ListenForEvent("attacked", OnAttacked)
end

--搜索目标 - 定位玩家
function q1retarget(inst,dist,period,change,sharefn)
	local dist=dist or 15
	local period=period or 3
	local function RetargetFn(inst)
		local invader = nil
		invader = FindEntity(inst,dist,function(guy)
			return guy:HasTag("player") 
				or (guy.components.combat.target and guy.components.combat.target.prefab==inst.prefab)
		end,
		{ "_combat", "_health" },
        { "q1boss", "playerghost", "shadowboss" }
		)
		if invader then
			local t = GetTime()
			if inst.nexttaunttime==nil or t > inst.nexttaunttime then
				inst.nexttaunttime=t + 15 + math.random() * 30
				if inst.SoundEmitter then inst.SoundEmitter:PlaySound(inst.def and inst.def.callsound or "") end
			end
			--if t > inst.nexttaunttime then
			--	inst.SoundEmitter:PlaySound(inst.def.callsound or "")
			--end
			--[[
			local t = GetTime()
			if inst.nexttaunttime == nil or t > inst.nexttaunttime then
				inst.nexttaunttime = t + 10 + math.random() * 10
				inst.SoundEmitter:PlaySound(inst.def.callsound or "")
			end]]
			if sharefn then
				sharefn(inst,invader)
			end
		end
		return invader,change
	end
	inst.components.combat:SetRetargetFunction(period, RetargetFn)
end

--保持目标 
function q1keeptarget(inst)
	local function KeepTargetFn(inst, target)
		return inst.components.combat:CanTarget(target)     
	end
	inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
end

--掉落单个物品
function q1loot(inst,pref,pt)
	if inst and inst.components.lootdropper and pref then
		local pt=pt or inst:GetPosition()
		inst.components.lootdropper:SpawnLootPrefab(pref, pt)
	end
end
--按几率掉落一组物品
function q1loots(inst,tab,pt,chancemult)
	for k,v in pairs(tab) do
		if math.random()<v*(chancemult or 1) then
			q1loot(inst,k,pt)
		end
	end
end


--死亡 - 喊叫+函数
function q1death(inst, fn)
	local function OnDead(inst)
		if inst._dead==nil then
			if fn then fn(inst) end
			inst._dead=true
		end
	end
	inst:ListenForEvent("death", OnDead)
end

------------------------------------------------------------------------------------------------
function c(a,b)
	c_give(a,b)
end

--生成物品
function wy_spawn(inst, other, offset, mode, scale, phys, sound, fn_tar, fn_inst)

	if not inst then return end
	--local mode = mode or 0
	local tar
	
	if type(other) == "string" then
		tar = SpawnPrefab(other)
	elseif type(other) == "table" then
	
		--获取权重
		local weight = 0
		for k,v in pairs(other) do
			weight = weight + v
		end
		
		--选取物体
		local t = 0
		local ran = math.random()
		for k,v in pairs(other) do
			t = t + v
			if ran <= t/weight then
				tar = SpawnPrefab(k)
				break
			end
		end
	else
		return
	end
	
	if not tar then return end
		
	--物体的父子位置关系
	if mode == 1 then
		
		tar.entity:SetParent(inst.entity)
		if type(offset) == "table" then
			tar.Transform:SetPosition(offset[1],offset[2],offset[3])
		else
			tar.Transform:SetPosition(0,0,0)
		end
	
	--Follow Symbol的关系
	elseif type(mode) == "string" then
		
		tar.entity:SetParent(inst.entity)
		tar.entity:AddFollower()
		if type(offset) == "table" then
			tar.Follower:FollowSymbol(inst.GUID, mode, offset[1],offset[2],offset[3])
		else
			tar.Follower:FollowSymbol(inst.GUID, mode, 0,0,0)
		end
	
	--普通生成模式
	else
		local x,y,z = inst.Transform:GetWorldPosition()
		local x1,y1,z1 = x,y,z
		if type(offset) == "table" then
			x1,y1,z1 = x+offset[1], y+offset[2], z+offset[3]
		end
		tar.Transform:SetPosition(x1,y1,z1)
	end
	
	--新事物的体积,多用于调试特效
	if scale then
		tar.Transform:SetScale(scale,scale,scale)
	end
	
	--新事物飞出的速度,多用于弹道类物体,也可用于掉落物
	if type(phys) == "table" and tar.Physics then

		--获取方向, 以自己为起点的方向
		if phys[1] then
			local angle = tar:GetAngleToPoint( phys[1]:Get() )	
			
			--偏离角度
			local angel_d = phys[2] or 0
			angle = angle + angel_d
			
			--获得最终面向角度
			while (angle < 0) do
				angle = angle + 360
			end
			while (angle >= 360) do
				angle = angle - 360
			end
			
			--设置最终面向
			tar.Transform:SetRotation(angle)
		end
		
		--获取速度, 如果速度小于0则倒退方向运行
		local vel = phys[3]
		if vel then
			tar.Physics:SetMotorVelOverride(vel[1],vel[2],vel[3])
		end
		
	end
	
	--新事物的音效,用于生成时的声音效果
	if type(sound) == "table" then
		if not tar.SoundEmitter then
			tar.entity:AddSoundEmitter()
		end
		tar:DoTaskInTime(sound[2] or 0, function()
			tar.SoundEmitter:PlaySound(sound[1])
		end)
	elseif type(sound) == "string" then
		if not tar.SoundEmitter then
			tar.entity:AddSoundEmitter()
			tar.SoundEmitter:PlaySound(sound)
		end
	end
	
	-------------------------------------------一般情况是用不着的----------------
	--新事物的其他初始化
	if type(fn_tar) == "function" then
		fn_tar(tar)
	end
	
	--旧事物的操作
	if type(fn_inst) == "function" then
		fn_inst(inst)
	end

	return tar
end


--是否含有tag
function zg_checktag(inst, add, del, mult)
	if not inst then return false end
	local res	
	if type(add) == "table" then
		res = false
		for k,v in pairs(add) do
			res = res or inst:HasTag(v)
		end
	else
		res = true
	end
	if type(del) == "table" then
		for k,v in pairs(del) do
			res = res and not inst:HasTag(v)
		end
	end
	if type(mult) == "table" then
		for k,v in pairs(mult) do
			res = res and inst:HasTag(v)
		end
	end
	return res
end

--对方对 我或者指定标签 有敌意
function zg_isenemy(tar,inst,add,del,mult)
	local target=tar and tar.components.combat and tar.components.combat.target
	
	local leader=tar and tar.components.follower and tar.components.follower.leader
	local target2=leader and leader.components.combat and leader.components.combat.target
	
	return (target and (target==inst or zg_checktag(target,add,del,mult)))
		or (target2 and (target2==inst or zg_checktag(target2,add,del,mult)))
end

--是否活着
function zg_isalive(inst)
	return inst and inst.components.health and not inst.components.health:IsDead() and not inst:HasTag("playerghost") and inst.components.combat
end

--创建虚武器并装备
function wy_virtual_weapon(inst,damage,uses,attackrange,hitrange,projectile,build,bank,tag,stimuli,onattack)
	if inst.components.inventory then
		local weapon = CreateEntity()
		weapon.entity:AddTransform()
		weapon.entity:AddSoundEmitter()
		weapon:AddComponent("weapon")
		weapon.components.weapon:SetDamage(damage or 10)
		
		--攻击特效
		if onattack then
			weapon.components.weapon:SetOnAttack(onattack)
		end
		
		--刺激物
		if stimuli then
			weapon.components.weapon.stimuli=stimuli
		end
		
		--耐久
		if uses then
			weapon:AddComponent("finiteuses")
			weapon.components.finiteuses:SetMaxUses(uses)
			weapon.components.finiteuses:SetUses(uses)
			weapon.components.finiteuses:SetOnFinished(function(weapon)
				inst:PushEvent("toolbroke", {tool = weapon})
				weapon:Remove()
			end)
		end
		
		--距离
		if attackrange then
			weapon.components.weapon:SetRange(attackrange, hitrange or attackrange)
		end
		
		--抛射物
		if projectile then
			weapon.components.weapon:SetProjectile(projectile)
		end
		
		weapon:AddComponent("inventoryitem")
		weapon.persists = false
		weapon.components.inventoryitem:SetOnDroppedFn(weapon.Remove)
		weapon:AddComponent("equippable")
		
		--样式
		if build and bank then
			weapon.components.equippable:SetOnEquip(function(weapon, owner)
				owner.AnimState:OverrideSymbol("swap_object", build, bank)
				owner.AnimState:Show("ARM_carry") 
				owner.AnimState:Hide("ARM_normal") 
			end)
			weapon.components.equippable:SetOnUnequip(function(weapon, owner) 
				owner.AnimState:Hide("ARM_carry") 
				owner.AnimState:Show("ARM_normal")
				weapon:Remove()
			end)
		end
		
		--标签
		if type(tag) == "table" then
			for k,v in pairs(tag) do
				weapon:AddTag(v)
			end
		end
		
		inst.components.inventory:Equip(weapon)
		--inst.zg_weapon_slot=slot
	end
end

--创建虚帽子并装备
function zg_virtual_hat(inst,condition,absorb,build,open,tag,slot)
	if inst.components.inventory then
		local hat = CreateEntity()
		hat.entity:AddTransform()
		
		--护甲
		if condition and absorb then
			hat:AddComponent("armor")
			hat.components.armor:InitCondition(condition,absorb)
		end
		
		hat:AddComponent("inventoryitem")
		hat.persists = false
		hat.components.inventoryitem:SetOnDroppedFn(hat.Remove)
		hat:AddComponent("equippable")
		hat.components.equippable.equipslot=EQUIPSLOTS.HEAD
		
		--样式
		if build then
			hat.components.equippable:SetOnEquip(function(hat, owner)
			
				owner.AnimState:OverrideSymbol("swap_hat", build, "swap_hat")
				if open then
					owner.AnimState:Show("HAT")
					owner.AnimState:Hide("HAT_HAIR")
					owner.AnimState:Show("HAIR_NOHAT")
					owner.AnimState:Show("HAIR")
					owner.AnimState:Show("HEAD")
					owner.AnimState:Hide("HEAD_HAT")
				else
					owner.AnimState:Show("HAT")
					owner.AnimState:Show("HAT_HAIR")
					owner.AnimState:Hide("HAIR_NOHAT")
					owner.AnimState:Hide("HAIR")
					owner.AnimState:Hide("HEAD")
					owner.AnimState:Show("HEAD_HAT")
				end
				
			end)
			hat.components.equippable:SetOnUnequip(function(hat, owner) 
				
				owner.AnimState:ClearOverrideSymbol("swap_hat")
				owner.AnimState:Hide("HAT")
				owner.AnimState:Hide("HAT_HAIR")
				owner.AnimState:Show("HAIR_NOHAT")
				owner.AnimState:Show("HAIR")
				owner.AnimState:Show("HEAD")
				owner.AnimState:Hide("HEAD_HAT")

			end)
		end
		
		--标签
		if type(tag) == "table" then
			for k,v in pairs(tag) do
				hat:AddTag(v)
			end
		end
		
		inst.components.inventory:Equip(hat)
		inst.zg_hat_slot=slot
	end
end

--创建虚护甲并装备
function zg_virtual_armor(inst,condition,absorb,build,tag,slot)
	if inst.components.inventory then
		local hat = CreateEntity()
		hat.entity:AddTransform()
		
		--护甲
		if condition and absorb then
			hat:AddComponent("armor")
			hat.components.armor:InitCondition(condition,absorb)
		end
		
		hat:AddComponent("inventoryitem")
		hat.persists = false
		hat.components.inventoryitem:SetOnDroppedFn(hat.Remove)
		hat:AddComponent("equippable")
		hat.components.equippable.equipslot=EQUIPSLOTS.BODY
		
		--样式
		if build then
			hat.components.equippable:SetOnEquip(function(hat, owner)
				owner.AnimState:OverrideSymbol("swap_body", build, "swap_body")
			end)
			hat.components.equippable:SetOnUnequip(function(hat, owner) 
				owner.AnimState:ClearOverrideSymbol("swap_body")
			end)
		end
		
		--标签
		if type(tag) == "table" then
			for k,v in pairs(tag) do
				hat:AddTag(v)
			end
		end
		
		inst.components.inventory:Equip(hat)
		inst.zg_hat_slot=slot
	end
end

--获得循环数组的下一个数值,就是那种首位相连的结构,类似圆环的
function zg_loop_next(tab,key,step)
	local step=step or 1
	local maxn=#tab
	local getn=key+step
	while (getn>maxn) do
		getn=getn-maxn
	end
	return getn
end

--可攻击到 目标否
function zg_canattacktarget(inst)
	local target=inst and inst.components.combat and inst.components.combat.target
	if target then
		return inst.components.combat:CanAttack(target)
	else
		return false
	end
end

--可被 自己目标 攻击到否
function zg_canbeattacked(inst)
	local target=inst and inst.components.combat and inst.components.combat.target
	if target and target.components.combat then
		return target.components.combat:CanAttack(inst)
	else
		return false
	end
end

--[[
--开始 走位距离
function zg_startdogedist(inst,add)
	local target=inst and inst.components.combat and inst.components.combat.target
	if target and target.components.combat and not target:HasTag("wall") then
		--local range = inst.Physics ~= nil and inst.Physics:GetRadius() + inst.components.combat:GetAttackRange() or inst.components.combat:GetAttackRange()
		local range=target.components.combat:GetAttackRange()+( inst.Physics and inst.Physics:GetRadius() or 0 )
		return range+(add or 0)
	else
		return 0	--+(add or 0)
	end
end

--结束 走位距离
function zg_stopdogedist(inst,add)
	local target=inst and inst.components.combat and inst.components.combat.target
	if target and target.components.combat and not target:HasTag("wall") then
		local range=target.components.combat:GetAttackRange()+( inst.Physics and inst.Physics:GetRadius() or 0 )
		return range+(add or 0)
	else
		return 0	--+(add or 0)
	end
end]]

--目标是否 无 比自己长些的攻击距离
function zg_target_noexweapon(inst,add)
	--目标攻击距离
	local target=inst and inst.components.combat and inst.components.combat.target
	if target and target.components.combat then
		local distsq=target.components.combat:CalcHitRangeSq(inst)
		local distsq2=inst.components.combat:CalcHitRangeSq(target)
		return distsq<(distsq2+(add or 0))
	else
		return true	--安全
	end
end

--可以乘着 目标攻击间隔 袭击否
function zg_cansneak(inst,a,b)
	local target=inst and inst.components.combat and inst.components.combat.target
	if target and target:HasTag("wall") then return true end
	if target and target.components.combat then
		local lastattacktime=target.components.combat.lastdoattacktime or 0
		local timedelta=GetTime()-lastattacktime
		local attackperiod=target.components.combat.min_attack_period
		if timedelta>(a or .75)*attackperiod and timedelta<(b or 1.25)*attackperiod then
			return false
		else
			return true
		end
	else
		return true
	end
end

--[[
--目标 表面上 正在逃跑否
function zg_target_isescaping(inst)
	local target=inst and inst.components.combat and inst.components.combat.target
	if target then
		
	end
end]]

-------------------------------------------------------------------------------------------------------
--获取2个物体的角度的差值, 后者减去前者
function tw_getangle(a)
	return a.Transform:GetRotation()
end

function tw_anglediff(a,b)
	return tw_getangle(b)-tw_getangle(a)
end

--是否在陆地上
function tw_isonland(inst, x,y,z)
	if not x or not y or not z then
		return inst and inst:IsOnValidGround()
	else
		local ground=TheWorld
		local tx, ty = ground.Map:GetTileCoordsAtPoint(x, 0, z)
		local actual_tile = ground.Map:GetTile(tx, ty)
		return actual_tile ~= GROUND.IMPASSABLE
	end
end

--离自己前方的某个位置的 Vetor3
function tw_getforwardpos_offset(inst, dist, theta, other, height)
	local basic_angle = other and inst:GetAngleToPoint(other.Transform:GetWorldPosition()) or inst.Transform:GetRotation()
	local heading_angle = -( basic_angle + (theta or 0) )
	local dist = dist or 0
	local offset = Vector3(math.cos(heading_angle*DEGREES) * dist, height or 0, math.sin(heading_angle*DEGREES) * dist)
	return offset
end

--获取前方的相对位置的表
function wy_getoffset(inst, dist, theta, other, height)
	local offset=tw_getforwardpos_offset(inst, dist, theta, other, height)
	return {offset.x,offset.y,offset.z}
end

function tw_getforwardpos(inst, dist, theta, other, height)
	local pt = inst:GetPosition()
	local offset = tw_getforwardpos_offset(inst, dist, theta, other, height)
	return pt + offset
end

--离自己前方的某个位置是否在陆地上
function tw_getforwardposisonland(inst, dist, theta, other)
	local x0,y0,z0 = tw_getforwardpos(inst, dist, theta, other):Get()
	return tw_isonland(inst, x0,y0,z0)
end

--是否和自己前方某个位置在联通地形
function tw_iscontinuous(inst, dist, theta, other)
	local x0,y0,z0 = tw_getforwardpos(inst, dist, theta, other):Get()
	return tw_isonland(inst) == tw_isonland(inst, x0,y0,z0)
end






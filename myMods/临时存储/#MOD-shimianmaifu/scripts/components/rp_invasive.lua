--[[怪物进攻性 Monster Invasive]]--

local RP_Invasive = Class(function(self, inst)
	self.inst = inst
	self.inst.isInvasive = false
	self.inst.makeType = 0
end)

local function makeKing(inst)
end

local function makeCommander(inst)
end

--local brain = require "brains/rp_invade_monsterbrain"
local brain = require "brains/leifbrain"

local function makeMob(inst)
	inst:AddTag("shadowboss")
	inst:AddTag("wave_monster")
	inst:AddTag("rp_monster")
	inst:AddTag("houndedKiller")
	inst:AddTag("hostile")
	inst:AddTag("monster")

	
	--ewecushat	
	--inst.AnimState:OverrideSymbol("swap_hat", "hat_top", "swap_hat")
	--inst.AnimState:Show("HAT")
	--inst.AnimState:Show("HAT_HAIR")
	--inst.AnimState:Hide("HAIR_NOHAT")
	--inst.AnimState:Hide("HAIR")
	
	--设置怪物大小
	local currentscale = inst.Transform:GetScale()
	inst.Transform:SetScale(currentscale*1.5,currentscale*1.5,currentscale*1.5)
	
	--设置攻击目标
	local origCanTarget = inst.components.combat.keeptargetfn
	local function keepTargetOverride(inst, target)
		-- TODO: Testing this 
		if true then
			return inst.components.combat:CanTarget(target)
		end
		-- This wont get hit. Was original code. TODO : if above is better, remove this.
		if target:HasTag("player") and inst.components.combat:CanTarget(target) then
			return true
		else
			return origCanTarget and origCanTarget(inst,target)
		end
	end
	inst.components.combat:SetKeepTargetFunction(keepTargetOverride)
	
	local function retargetfn(inst)
		-- Give all mobs same search dist as hounds
		local dist = 40		
		local invader = nil
		invader = FindEntity(inst, dist, function(guy)
			return guy:HasTag("player") and not guy:HasTag("rp_monster") 
			and not guy:HasTag("wave_monster")
			and not guy:HasTag("shadowboss")
			and not guy:HasTag("playerghost")
		end)
		
		return invader
	end
	
	local function FindTarget(inst, radius)
    return FindEntity(
        inst,
        SpringCombatMod(radius),
        function(guy)
            return inst.components.combat:CanTarget(guy) and not (inst.components.follower ~= nil and inst.components.follower.leader == guy)
        end,
        { "_combat", "character"},
        { "rp_monster", "INLIMBO" }
    )
	end
	
	local function NormalRetarget(inst)
    return FindTarget(inst, 40)
	end
	
	--if not inst.components.teamattacker then
	inst.components.combat:SetRetargetFunction(3, NormalRetarget)
	--end
	
	----击中点燃玩家
	inst:ListenForEvent("onattackother", function(inst,data)
	local target = data.target
	
		if target:HasTag("wall") then
			print("---attack wall---")
		end 
		
	end)
	--inst:ListenForEvent("onattackother", function(inst,data)
	--	local target = data.target
	--	print("attack target----------"..target.prefab)
	--end)
	
	--inst:ListenForEvent("doattack", function(inst,data)
	--	local target = data.target
	--	print("attack target----------"..target.prefab)
	--	if target:HasTag("wall") then
			--if inst.components.combat then
				--inst.components.combat:SetDefaultDamage(100)
				--inst.components.combat:SetAttackPeriod(0.2)
			--end
	--	end
	--end)
	
	local r, g, b = HexToPercentColor("#FF0705")
	--设置怪物颜色
	inst.AnimState:SetMultColour(r, g, b, 1)
	inst:SetBrain(nil)
	inst:SetBrain(brain)
end

function RP_Invasive:Make(make_type)
	
	local monster = self.inst
	if make_type == INVASIVE_MOB then
		makeMob(monster)
		self.inst.makeType = INVASIVE_MOB
		self.inst.isInvasive = true
	elseif make_type == INVASIVE_COMMANDER then
		makeCommander(monster)
		self.inst.makeType = INVASIVE_COMMANDER
		self.inst.isInvasive = true
	elseif make_type == INVASIVE_KING then
		makeKing(monster)
		self.inst.makeType = INVASIVE_KING
		self.inst.isInvasive = true
	end
	
	
end

function RP_Invasive:OnSave()
	return
	{
		isInvasive = self.inst.isInvasive,
		makeType = self.inst.makeType
		
	}
end

function RP_Invasive:OnLoad(data)
	--print("onload!!!--RP_Invasive")
	if data ~= nil then
		self.inst.isInvasive = data.isInvasive
		self.inst.makeType = data.makeType
		if self.inst.isInvasive then 
			self:Make(self.inst.makeType)
		end
	end
end

return RP_Invasive

local  Aoespell = Class(function(self, inst)
	self.inst = inst
	self.spell = nil
	self.ispassableatallpoints = false
end)

function Aoespell:CanCast(doer, pos)
        return self.spell and self.ispassableatallpoints or
            (TheWorld.Map:IsAboveGroundAtPoint(pos:Get())
            and not TheWorld.Map:IsGroundTargetBlocked(pos))
end

function Aoespell:SetSpellFn(fn)
    self.spell = fn
end

function Aoespell:CastSpell(doer, pos)
	if not self.inst.components.aoetargeting:IsEnabled()  then
        return 
	end	
    if self.spell ~= nil then
        self.spell(self.inst,doer, pos)
	end
end

return Aoespell



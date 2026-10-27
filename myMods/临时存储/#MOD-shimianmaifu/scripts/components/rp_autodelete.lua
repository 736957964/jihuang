local RP_Autodelete = Class(function(self, inst)
	self.inst = inst
	self.inst.isShouldDelete = false
	self.perishtime = nil
	self.updatetask = nil
	self.perishremainingtime = nil
end)

----更新函数，功能的主体部分
local function Update(inst, dt)

    if inst.components.rp_autodelete then
		local owner = nil 
			----判断物品的拥有者或占有方
		owner = inst.components.inventoryitem 
		and inst.components.inventoryitem.owner or nil
			
		if not owner and inst.components.occupier then
			owner = inst.components.occupier:GetOwner()
		end
		
			----拥有者或占有者为空的时候,开始动用定时删除
			if not owner then
			
				----对距离删除时间的计算,核心部分 
				if inst.components.rp_autodelete.perishremainingtime then
						
						inst.components.rp_autodelete.perishremainingtime = inst.components.rp_autodelete.perishremainingtime - 1
						if inst.components.rp_autodelete.perishremainingtime <= 0 then
							inst.components.rp_autodelete:Perish()
						end
					
				end
			----拥有者或占有方存在的时候，剩余离删除时间清零，即重置为设定的perishtime
			else 
				inst.components.rp_autodelete.perishremainingtime = inst.components.rp_autodelete.perishtime
			end	
		
    end
	
end

----物体移除后
function RP_Autodelete:OnRemoveEntity()
	self:StopPerishing()
end

----执行删除
function RP_Autodelete:Perish()
    if self.updatetask ~= nil then
        self.updatetask:Cancel()
        self.updatetask = nil
    end
	if self.inst then
		if self.inst:HasTag("rp_monster") then
			local currentscale = self.inst.Transform:GetScale()
			local collapse = SpawnPrefab("collapse_small")
			if collapse ~= nil then
				collapse.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
				collapse.Transform:SetScale(currentscale*1,currentscale*1,currentscale*1)
			end
			self.inst:Remove()
		elseif self.inst:HasTag("poop_bomb") then
			--local currentscale = self.inst.Transform:GetScale()
			local collapse = SpawnPrefab("die_fx")
			if collapse ~= nil then
				collapse.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
				collapse.Transform:SetScale(2.5,2.5,2.5)
			end
			--local data = {0,0,0}
			--local x,y,z = self.inst.Transform:GetWorldPosition()
		
			self.inst:PushEvent("rp_poop_bomb")
			self.inst:Remove()
		else
			self.inst:Remove()
		end
	end
end

----设置删除时间
function RP_Autodelete:SetPerishTime(delete_time)
	self.perishtime = delete_time
	self.perishremainingtime = delete_time
    if self.updatetask ~= nil then
        self:StartPerishing()
    end
end

----开始计算
function RP_Autodelete:StartPerishing()
	
	self.inst.isShouldDelete = true
    if self.updatetask ~= nil then
        self.updatetask:Cancel()
        self.updatetask = nil
    end
    --local dt = .1
    self.updatetask = self.inst:DoPeriodicTask(1, Update)
end
----停止计算
function RP_Autodelete:StopPerishing()
    if self.updatetask ~= nil then
        self.updatetask:Cancel()
        self.updatetask = nil
    end
end

----存储与载入
function RP_Autodelete:OnSave()
    return
    {
        paused = self.updatetask == nil or nil,
        time = self.perishremainingtime,
		isShouldDelete = self.inst.isShouldDelete
    }
end

function RP_Autodelete:OnLoad(data)
    if data ~= nil and data.isShouldDelete then
	
		self.inst.isShouldDelete = data.isShouldDelete
		if data.time ~= nil then
			self.perishremainingtime = data.time
			if not data.paused then
				self:StartPerishing()
			end
		end
		
    end
end

return RP_Autodelete
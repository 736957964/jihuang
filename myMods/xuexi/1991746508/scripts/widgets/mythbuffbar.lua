local Text = require "widgets/text"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"
local MythBuffSlot = require "widgets/mythbuffslot"

local STZRT_X = 0
local SLOTDIST = 90
local UPDATE_PERIOD = 0.2

local MythBuffBar = Class(Widget, function(self, owner)
    Widget._ctor(self,"MythBuffBar")
	self.owner = owner
	self.buffslots = {}
	self.anim_queue = {}
	self.time = 0
	self.AnimTask = nil 
	
	self:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
	self:SetVAnchor(1) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下	
end)

function MythBuffBar:EnableAnimTask(enable)
	if self.AnimTask then 
		self.AnimTask:Cancel()
		self.AnimTask = nil 
	end 
	if enable then 
		self.AnimTask = self.inst:DoPeriodicTask(UPDATE_PERIOD,function()
			self:PopAnim()
		end)
	end 
end

function MythBuffBar:PushAnim(fn)
	table.insert(self.anim_queue,fn)
	if not self.AnimTask then 
		self:EnableAnimTask(true)
	end
end

function MythBuffBar:PopAnim()
	if #self.anim_queue > 0 then 
		self.anim_queue[1]()
		table.remove(self.anim_queue,1)
	else
		self:EnableAnimTask(false)
	end
end

function MythBuffBar:HasBuff(name)
	return self.buffslots[name] ~= nil 
end

function MythBuffBar:AddBuff(name,image_name,desc_name,time_remain,ent)
	if not self.buffslots[name] then 
		local child = self:AddChild(MythBuffSlot(image_name,desc_name,time_remain,ent))
		child.add_time = GetTime()
		self.buffslots[name] = child
		-- ent主要是buff的实体，监听实体在客机移除时移除buffui，可以不加，我在myth_buff_ly_api里还有很多备用措施为此准备
		if ent then 
			ent:ListenForEvent("onremove",function()
				self:RemoveBuff(name)
			end)
		end
		
		self:PushAnim(function()
			child:SlideIn()
			self:Line()
		end)
		
	else
		--print("[MythBuffBar-AddBuff]:AddBuff failed,"..tostring(name).." already exists")
	end
end

function MythBuffBar:UpdateBuff(name,image_name,desc_name,time_remain)
	if self.buffslots[name] then 
		-- self.buffslots[name] = self:AddChild(MythBuffSlot(image_name,desc_name,time_remain))
		if image_name then 
			self.buffslots[name]:SetImage(image_name)
		end 
		if desc_name then 
			self.buffslots[name]:SetDescName(desc_name)
		end
		if time_remain then 
			self.buffslots[name]:SetTimeRemain(time_remain)
		end
	else
		--print("[MythBuffBar-UpdateBuff]:Update failed,no name "..tostring(name))
	end
end

function MythBuffBar:RemoveBuff(name,delay)	
	if delay == nil then 
		delay = 0.33
	end 
	local tar = self.buffslots[name]
	self.buffslots[name] = nil 
	self:PushAnim(function()
		tar:SlideOut(delay)
		self:Line()
	end)

	-- self.buffslots[name]:SlideOut(delay)
	-- self.buffslots[name] = nil 
	-- if self.RemoveBuffAndLineTask then 
	-- 	self.RemoveBuffAndLineTask:Cancel()
	-- 	self.RemoveBuffAndLineTask = nil 
	-- end 
	-- self.RemoveBuffAndLineTask = self.inst:DoTaskInTime(delay,function()
	-- 	self:Line()
	-- 	if self.RemoveBuffAndLineTask then 
	-- 		self.RemoveBuffAndLineTask:Cancel()
	-- 		self.RemoveBuffAndLineTask = nil 
	-- 	end 
	-- end)	
end

-- 把buff列表按照添加时间从大到小重新排序·····
-- 你问我为啥要搞这蜜汁操作？？？当然是为了美观啦！
-- 我也可以选择把self.buffslots的数据结构从键值对形式改为普通列表结构
-- 										 但是我不想改↑
-- 别问，问就是我懒
-- 快速排序法不稳定
function MythBuffBar:ListByTime()
	local list = {}
	for name,v in pairs(self.buffslots) do 
		table.insert(list,v)
	end
	table.sort(list,function(a,b)
		return a.add_time > b.add_time
	end)

	return list
end

function MythBuffBar:Line(instant)
	-- local index = 1 
	for index,v in pairs(self:ListByTime()) do 
		local x,y,z = STZRT_X + SLOTDIST * (index - 1),0,0
		v:CancelMoveTo()
		if instant then 
			v:SetPosition(x,y,z)
		else
			local old_pos = v:GetPosition()
			v:MoveTo(old_pos,Vector3(x,y,z),0.5)
		end 
		-- index = index + 1
	end
end 

-- function MythBuffBar:OnUpdate(dt)
-- 	self.time = self.time - dt 
-- 	if self.time <= 0 then 
-- 		self.time = UPDATE_PERIOD
-- 		-- Do Anim here
-- 	end
-- end



return MythBuffBar

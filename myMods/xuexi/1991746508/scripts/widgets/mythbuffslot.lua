local Text = require "widgets/text"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"

local L = MK_MOD_LANGUAGE_SETTING
local V = L == "VI" and true or false

local MythBuffSlot = Class(Widget, function(self,image_name,desc_name,time_remain,ent)	
	Widget._ctor(self,"MythBuffSlot")

	self.ent = ent
	self.desc_name = desc_name or "未知Buff"
	self.time_remain = time_remain or -1

	self.icon = self:AddChild(Image("images/bufficons/"..image_name..".xml", image_name..".tex"))
	self.icon:SetScale(0.01,0.01)

	self.tip = self:AddChild(Text(NUMBERFONT, 32,"未知Buff\n剩余时间:-秒"))
	self.tip:SetPosition(0,-75,0)
	self.tip:Hide()
	self:Hide()
	self:CheckDesc()
end)

function MythBuffSlot:OnGainFocus()
    self.tip:Show()
end

function MythBuffSlot:OnLoseFocus()
    self.tip:Hide()
end

function MythBuffSlot:SetImage(image_name)
	self.icon:SetTexture("images/bufficons/"..image_name..".xml", image_name..".tex")
end

function MythBuffSlot:SetTimeRemain(time)
	self.time_remain = time
	self:CheckDesc()
end

function MythBuffSlot:SetDescName(name)
	self.desc_name = name
	self:CheckDesc()
end

function MythBuffSlot:CheckDesc()
	if type(self.time_remain) == "number" and (self.time_remain  < 0) then 
		self.time_remain = "∞"
	end
	local indicator = V and "%s\nHiệu lực: %s giây" or "%s\n剩余时间:%s秒"
	self.tip:SetString(string.format(indicator,self.desc_name,tostring(self.time_remain)))
end

function MythBuffSlot:SlideIn()
	self:Show()
	self.icon:ScaleTo(0.01,0.4,0.33)
end

function MythBuffSlot:SlideOut(delay)
	self.icon:ScaleTo(0.4,0.01,delay,function()
		self:Kill()
	end)
end

return MythBuffSlot

AddPrefabFiles('cassock')

--免疫硬直的接口
AddStategraphPostInit("wilson", function(sg)
    local old_onattacked = sg.events['attacked'].fn
    sg.events['attacked'] = EventHandler('attacked', function(inst,data,...)
        if inst.replica.inventory:EquipHasTag("myth_nostunned") or inst.sg:HasStateTag("myth_nostunned")   then
            if not inst.sg:HasStateTag('frozen') and not inst.sg:HasStateTag('sleeping') then
                return
            end
        end     
        return old_onattacked(inst,data,...)
    end)

	local old_equip = sg.events['equip'].fn
    sg.events["equip"] = EventHandler("equip", function(inst,data,...)
		if data.item ~= nil and data.item:HasTag("wb_armorstorage_back") then
			return
		end
		return old_equip(inst,data,...)
    end)
end)

--界面部分
local UIAnim = require "widgets/uianim"
AddClassPostConstruct("widgets/itemtile", function(self)
	function self:SetHotMeterPercent(cur) --刷新
		if self.show_hotmeter then
			self.show_hotmeter:GetAnimState():SetPercent("anim", cur/100)
		end
	end
	if self.item and self.item:HasTag("show_hotmeter") then
		self.show_hotmeter = self:AddChild(UIAnim())
		self.show_hotmeter:GetAnimState():SetBank("obsidian_tool_meter")
		self.show_hotmeter:GetAnimState():SetBuild("obsidian_tool_meter")
		self.show_hotmeter:MoveToBack()
		self.show_hotmeter:SetClickable(false)

		self.inst:ListenForEvent("hotmeterchange", --事件
        	function(invitem, current)
            self:SetHotMeterPercent(current)
        end, self.item)
        if self.item and self.item.replica.myth_show_hotmeter ~= nil then
			self:SetHotMeterPercent(self.item.replica.myth_show_hotmeter:GetCurrent())
		end      
	end

	local old_Refresh = self.Refresh
	function self:Refresh()
		if self.item and self.item.replica.myth_show_hotmeter ~= nil then
			self:SetHotMeterPercent(self.item.replica.myth_show_hotmeter:GetCurrent())
		end
		old_Refresh(self)
	end
end)

local PopupDialogScreen 	= require("screens/popupdialog")
local Text 					= require "widgets/text"

return Class(function(self, inst)
	self.inst = inst
	self.message = nil
	self.title = nil
	self._message = net_string(self.inst.GUID, "message._message", "messagedirty")
	self._title = net_string(self.inst.GUID, "message._title", "titledirty")

	local function OnPlayerActivated()
		local screen = PopupDialogScreen( self.title, self.message, { { text = "Close", cb = function() TheFrontEnd:PopScreen() end } } )
		TheFrontEnd:PushScreen( screen )
	end

	self.inst:ListenForEvent("playeractivated", OnPlayerActivated, TheWorld)
	self.inst:StartUpdatingComponent(self)

	local function OnMessageDirty(inst)
		self.message = self._message:value()
	end

	local function OnTitleDirty(inst)
		self.title = self._title:value()
	end

	if not TheWorld.ismastersim then
		self.inst:ListenForEvent("messagedirty", OnMessageDirty)
		self.inst:ListenForEvent("titledirty", OnTitleDirty)
	end

	function self:SetTitle(title)
		self.title = title
		self._title:set(title)
	end

	function self:SetMessage(message)
		self.message = message
		self._message:set(message)
	end

end)
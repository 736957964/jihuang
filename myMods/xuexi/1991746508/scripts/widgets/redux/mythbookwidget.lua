local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Grid = require "widgets/grid"
local Spinner = require "widgets/spinner"

local TEMPLATES = require "widgets/redux/templates"

local MythPillPage = require "widgets/redux/mythbookpage_pill"
local MythPlayerPage = require "widgets/redux/mythbookpage_player"
local MythDaoJu = require "widgets/redux/mythbookpage_daoju"
local Mythshenxian = require "widgets/redux/mythbookpage_shenxian"
local MythDiXing = require "widgets/redux/mythbookpage_dixing"
local MythGuaiWu = require "widgets/redux/mythbookpage_guaiwu"

require("util")

local L = MK_MOD_LANGUAGE_SETTING
local titlesizi = L == "VI" and 25  or 40
-------------------------------------------------------------------------------------------------------
local MythBookWidget = Class(Widget, function(self, parent)
    Widget._ctor(self, "MythBookWidget")

    self.root = self:AddChild(Widget("root"))

	local tab_root = self.root:AddChild(Widget("tab_root"))

	local backdrop = self.root:AddChild(Image("images/myth_bookinfo.xml", "quagmire_recipe_menu_bg.tex"))
    backdrop:ScaleToSize(900, 550)
	local base_size = .7

	local button_data = {
		{text = STRINGS.MYTH_BOOINFO.ITEM_TYPE.renwu, build_panel_fn = function() return MythPlayerPage(parent, "player") end},
		{text = STRINGS.MYTH_BOOINFO.ITEM_TYPE.dixing, build_panel_fn = function() return MythDiXing(parent, "dixing") end},

		{text = STRINGS.MYTH_BOOINFO.ITEM_TYPE.lianzhi, build_panel_fn = function() return MythPillPage(parent, "pill") end},
		{text = STRINGS.MYTH_BOOINFO.ITEM_TYPE.shenhua, build_panel_fn = function() return MythDaoJu(parent, "daoju") end},

		{text = STRINGS.MYTH_BOOINFO.ITEM_TYPE.shenxian, build_panel_fn = function() return Mythshenxian(parent, "shenxian") end},
		{text = STRINGS.MYTH_BOOINFO.ITEM_TYPE.yaoguai, build_panel_fn = function() return MythGuaiWu(parent, "guaiwu") end},
	}

	local function MakeTab(data, index)
		local tab = ImageButton("images/myth_bookinfo.xml", "quagmire_recipe_tab_inactive.tex", nil, nil, nil, "quagmire_recipe_tab_active.tex")
		tab:SetFocusScale(0.7, base_size)
		tab:SetNormalScale(0.7, base_size)
		tab:SetText(data.text)
		tab:SetTextSize(titlesizi)
		tab:SetFont(HEADERFONT)
		tab:SetTextColour(UICOLOURS.BROWN_DARK)
		tab:SetTextFocusColour(UICOLOURS.BROWN_DARK)
		tab:SetTextSelectedColour(UICOLOURS.BROWN_DARK)
		tab.text:SetPosition(0, -2)
		tab.clickoffset = Vector3(0,5,0)
		tab:SetOnClick(function()
	        self.last_selected:Unselect()
	        self.last_selected = tab
			tab:Select()
			tab:MoveToFront()
			if self.panel ~= nil then 
				self.panel:Kill()
			end
			self.panel = self.root:AddChild(data.build_panel_fn())
			self.focus_forward = self.panel.parent_default_focus

		    if TheInput:ControllerAttached() then
				if self.panel.parent_default_focus then
					self.panel.parent_default_focus:SetFocus()
				end
			end
			MYTH_BOOKINFO_PAGES.ZHUYE = index
		end)
		tab._tabindex = index - 1

		return tab
	end
	
	self.tabs = {}
	for i = 1, #button_data do
		table.insert(self.tabs, tab_root:AddChild(MakeTab(button_data[i], i)))
		self.tabs[#self.tabs]:MoveToBack()
	end
	self:_PositionTabs(self.tabs, -450, 285)

	-----
	local starting_tab = MYTH_BOOKINFO_PAGES.ZHUYE
	if self.tabs[starting_tab] == nil then
		starting_tab = 1
	end
	
	self.last_selected = self.tabs[starting_tab]
	self.last_selected:Select()	
	self.last_selected:MoveToFront()
	self.panel = self.root:AddChild(button_data[starting_tab].build_panel_fn())
	self.focus_forward = self.panel.parent_default_focus
end)

function MythBookWidget:_PositionTabs(tabs, w, y)
	local offset = #self.tabs / 6
	for i = 1, #self.tabs do
		local x = w + i*120+ (i> 3 and 70 or 0) --(i - offset - 0.5) * w
		tabs[i]:SetPosition(x, y)
	end
end

function MythBookWidget:OnControlTabs(control, down)
	if control == CONTROL_OPEN_CRAFTING then
		local tab = self.tabs[((self.last_selected._tabindex - 1) % #self.tabs) + 1]
		if not down then
			tab.onclick()
			return true
		end
	elseif control == CONTROL_OPEN_INVENTORY then
		local tab = self.tabs[((self.last_selected._tabindex + 1) % #self.tabs) + 1]
		if not down then
			tab.onclick()
			return true
		end
	end
end

function MythBookWidget:OnControl(control, down)
    if MythBookWidget._base.OnControl(self, control, down) then return true end

	return self:OnControlTabs(control, down)
end

function MythBookWidget:GetHelpText()
    local controller_id = TheInput:GetControllerID()
    local t = {}

    table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_OPEN_CRAFTING).."/"..TheInput:GetLocalizedControl(controller_id, CONTROL_OPEN_INVENTORY).. " " .. STRINGS.UI.HELP.CHANGE_TAB)

    return table.concat(t, "  ")
end


return MythBookWidget

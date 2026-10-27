local Widget = require "widgets/widget"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local Grid = require "widgets/grid"
local Spinner = require "widgets/spinner"

local TEMPLATES = require "widgets/redux/templates"

local MYTH_BOOINFO = STRINGS.MYTH_BOOINFO.YAOGUAI
require("util")

local L = MK_MOD_LANGUAGE_SETTING
local IS_VI = L == "VI"
local titlesizi = IS_VI and 22  or 30
local contentsizi = IS_VI and 14  or 22

--线条哦
local function MakeDetailsLine(details_root, x, y, scale, image_override)
	local value_title_line = details_root:AddChild(Image("images/myth_bookinfo.xml", image_override or "line_long.tex"))
	value_title_line:SetScale(scale, scale)
	value_title_line:SetPosition(x, y)
end

-----------显示的内容
local tsetskin = {
{"",
	{
		names = "names_blackbearger.tex",
		names_pos = {-75 , 80},
		boos = "boos_blackbearger.tex",

		text = MYTH_BOOINFO.blackbearger.title,
		showfn = function(self)
			self:PoopData1()
		end
	}
},

{"",
{
	names = "names_sxn.tex",
	names_pos = {-75 , 100},
	boos = "boos_sxn.tex",
	text = MYTH_BOOINFO.sxn.title,
	showfn = function(self)
		self:PoopData2()
	end
}
},

{"",
{
	names = "names_myth_goldfrog.tex",
	names_pos = {-75 , 80},
	boos = "boos_myth_goldfrog.tex",
	text = MYTH_BOOINFO.myth_goldfrog.title,
	showfn = function(self)
		self:PoopData3()
	end
}
},

{"",
{
	names = "names_zgxn.tex",
	names_pos = {-75 , 80},
	boos = "boos_zgxn.tex",
	text = MYTH_BOOINFO.zgxn.title,
	showfn = function(self)
		self:PoopData4()
	end
}
},
}

-------------------------------------------------------------------------------------------------------
local MythbookPageGuaiWu = Class(Widget, function(self, parent_screen, category)
    Widget._ctor(self, "MythbookPageGuaiWu")

    self.parent_screen = parent_screen
	self.category = category or "cookbook"

	self.filters = {}

	self:CreateRecipeBook()

	self:_DoFocusHookups()

	return self
end)

function MythbookPageGuaiWu:_DoFocusHookups()
	for i, v in ipairs(self.spinners) do
		v:ClearFocusDirs()

		if i > 1 then
			v:SetFocusChangeDir(MOVE_UP, self.spinners[i-1])
		end
		if i < #self.spinners then
			v:SetFocusChangeDir(MOVE_DOWN, self.spinners[i+1])
		end
	end
	
    local reset_default_focus = self.parent_default_focus ~= nil and self.parent_screen ~= nil and self.parent_screen.default_focus == self.parent_default_focus

	if self.recipe_grid and self.recipe_grid.items ~= nil and #self.recipe_grid.items > 0 then
		self.spinners[#self.spinners]:SetFocusChangeDir(MOVE_DOWN, self.recipe_grid)
		self.recipe_grid:SetFocusChangeDir(MOVE_UP, self.spinners[#self.spinners])
	
		self.parent_default_focus = self.recipe_grid
	    self.focus_forward = self.recipe_grid
	else
		self.parent_default_focus = self.spinners[1]
	    self.focus_forward = self.spinners[1]
	end
end


function MythbookPageGuaiWu:CreateRecipeBook()

	local panel_root = self
	-----------
	self.gridroot = panel_root:AddChild(Widget("grid_root"))
    self.gridroot:SetPosition(-280, -35)

	self.names = self.gridroot:AddChild(Image())
	--self.names:SetScale(0.6)
	self.names:SetPosition(-75 , 80)

	self.boos = self.gridroot:AddChild(Image())
	--self.boos:SetScale(0.7)
	self.boos:SetPosition(85 , 120)

	self.spinner_root = self.gridroot:AddChild(self:BuildSkinSpinners(self))
	self.spinner_root:SetPosition(0, 40)

	local details_decor = self.gridroot:AddChild(Image("images/myth_bookinfo.xml", "quagmire_recipe_menu_block_small.tex"))
    details_decor:ScaleToSize(320, 150)
	details_decor:SetPosition(65, -70)

	MakeDetailsLine(self.gridroot, 65, 270, 0.95, "quagmire_recipe_line_break.tex")

	MakeDetailsLine(self.gridroot, 65, -170, -0.95, "quagmire_recipe_line_break.tex")

	self.jieshaotext = self.gridroot:AddChild(Text(HEADERFONT, IS_VI and 20 or 28, "", DARKGREY))
	self.jieshaotext:SetPosition(70, 24)
	self.jieshaotext:SetHAlign(ANCHOR_LEFT)
	self.jieshaotext:SetRegionSize(310, 300)
	self.jieshaotext:EnableWordWrap(true)

	self.details_root = self.gridroot:AddChild(Widget("details_root"))
	self.details_root:SetPosition(500, 10)
	self:Updatedata(tsetskin[ MYTH_BOOKINFO_PAGES.GUAIWU][2])
end

local ingredient_icon_remap = {}
ingredient_icon_remap.onion = "quagmire_onion"
ingredient_icon_remap.tomato = "quagmire_tomato"
ingredient_icon_remap.acorn = "acorn_cooked"

local ingredient_name_remap = {}
ingredient_name_remap.acorn = "acorn_cooked"

local teshu = {
	golden_armor_mk = "golden_armor_mk_none",
	golden_hat_mk = "golden_hat_mk_none",
	yangjian_hair = "yangjian_hair_none",
	yangjian_armor = "yangjian_armor_none",

	myth_redlantern = "redlantern_myth_a",
	myth_interiors_ghg_groundlight = "myth_interiors_ghg_light",
	myth_bbn = "myth_bbn_full",
}

function MythbookPageGuaiWu:_SetupRecipeIngredientDetails(recipes, parent, y,posx)
	local ingredient_size =  40
	local x_spacing = 10

	local inv_backing_root = parent:AddChild(Widget("inv_backing_root"))
	local inv_item_root = parent:AddChild(Widget("inv_item_root"))
	local index = 1
	if #recipes <= 3 then
		for b = 1, #recipes do
			local items = recipes[index]
			local x = -((#items + 1)*ingredient_size + (#items-1)*x_spacing) / 2 + posx
			for i = 1, #items do
				--这是配方！！
				local backing = inv_backing_root:AddChild(Image("images/quagmire_recipebook.xml", "ingredient_slot.tex"))
				backing:ScaleToSize(ingredient_size, ingredient_size)
				backing:SetPosition(x + (i)*ingredient_size + (i-1)*x_spacing, y - ingredient_size/2 - (b-1)*(ingredient_size+5))

				local img_name = teshu[items[i]] ~= nil and teshu[items[i]]..".tex"  or (ingredient_icon_remap[items[i]] or items[i])..".tex"
				local img_atlas = GetInventoryItemAtlas(img_name, true)
				local img = inv_item_root:AddChild(Image(img_atlas or "images/inventoryimages/"..items[i]..".xml", img_atlas ~= nil and img_name or items[i]..".tex"))

				img:ScaleToSize(ingredient_size, ingredient_size)
				img:SetPosition(backing:GetPosition())
				img:SetHoverText(STRINGS.NAMES[string.upper(ingredient_name_remap[items[i]] or items[i])] or subfmt(STRINGS.UI.COOKBOOK.UNKNOWN_INGREDIENT_NAME, {ingredient = items[i]}))
			end
			index = index + 1
		end
	else
		local width = ((4)*ingredient_size + (4-1)*x_spacing)
		local column_spacing_offset = 5
		for b = 1, #recipes do
			local items = recipes[index]
			local x = (b%2 == 1) and (-width - ingredient_size + column_spacing_offset) or -column_spacing_offset
			for i = 1, #items do
				local backing = inv_backing_root:AddChild(Image("images/quagmire_recipebook.xml", "ingredient_slot.tex"))
				backing:ScaleToSize(ingredient_size, ingredient_size)
				backing:SetPosition(x + (i)*ingredient_size + (i-1)*x_spacing, y - ingredient_size/2 - math.floor((b-1)/2)*(ingredient_size+5))

				local img_name = (ingredient_icon_remap[items[i]] or items[i])..".tex"
				local img_atlas = GetInventoryItemAtlas(img_name, true)
				local img = inv_item_root:AddChild(Image(img_atlas or "images/inventoryimages/"..items[i]..".xml", img_atlas ~= nil and img_name or items[i]..".tex"))
				img:ScaleToSize(ingredient_size, ingredient_size)
				img:SetPosition(backing:GetPosition())
				img:SetHoverText(STRINGS.NAMES[string.upper(items[i])] or subfmt(STRINGS.UI.COOKBOOK.UNKNOWN_INGREDIENT_NAME, {ingredient = items[i]}))
			end
			index = index + 1
		end
	end
end

local recipes1 = {
	{"pill_bottle_gourd", "cassock", "lucky_goldnugget", "myth_coin","honeycomb"},
}
local goldfrog_recipes1 = {{"lucky_goldnugget", "myth_coin"}}
local goldfrog_recipes2 = {
	{"redgem", "bluegem","purplegem", "orangegem"},
	{"yellowgem", "greengem","opalpreciousgem", "froglegs"},		
	}

local sxu_recipes = {
	{"redgem", "bluegem","yellowgem", "minotaurhorn","myth_coin", "myth_redlantern"},
	{"meat", "lucky_goldnugget","myth_rhino_yellowheart", "myth_rhino_redheart","myth_rhino_blueheart"},
}
function MythbookPageGuaiWu:PoopData1(data)
	self.details_root:KillAllChildren()
	local details_root = self.details_root

	local y = 270

	MakeDetailsLine(details_root, 0, y, .59)

	local peachtree = details_root:AddChild(UIAnim())
	peachtree:SetScale(0.32)
    peachtree:GetAnimState():SetBank("myth_honeypot")
    peachtree:GetAnimState():SetBuild("myth_honeypot")
    peachtree:GetAnimState():PlayAnimation('full_open')
	peachtree:SetPosition(0 ,y-100)
	peachtree:MoveToBack()
	peachtree:SetClickable(false)
	y = y-150
	local title = details_root:AddChild(Text(HEADERFONT, titlesizi, MYTH_BOOINFO.blackbearger.text1, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y)

	y = y- 35
	title = details_root:AddChild(Text(HEADERFONT, contentsizi, MYTH_BOOINFO.blackbearger.text2, DARKGREY))
	title:SetPosition(0, y)	

	MakeDetailsLine(details_root, 0, y-30, .8)

	y = y-60
	title = details_root:AddChild(Text(HEADERFONT, titlesizi, MYTH_BOOINFO.blackbearger.text3, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y)

	y = y- 45
	title = details_root:AddChild(Text(HEADERFONT, contentsizi, MYTH_BOOINFO.blackbearger.text4, DARKGREY))
	title:SetPosition(0, y)	
	y = y- 40
	MakeDetailsLine(details_root, 0, y, .59)

	y = y-40
	title = details_root:AddChild(Text(HEADERFONT, titlesizi, MYTH_BOOINFO.blackbearger.text5, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y)

	local backing = title:AddChild(Image("images/myth_bookinfo.xml", "kamlan_cassock_blueprint.tex"))
	backing:ScaleToSize(70, 70)
	backing:SetPosition(-140,y+75)

	self:_SetupRecipeIngredientDetails(recipes1, details_root, y-20,30)
	y = y-55
	MakeDetailsLine(details_root, 0, y-30, .8)
end

function MythbookPageGuaiWu:PoopData2()
	self.details_root:KillAllChildren()
	local details_root = self.details_root

	local y = 270

	MakeDetailsLine(details_root, 0, y, .59)

	local jyb = details_root:AddChild(UIAnim())
	jyb:SetScale(0.36)
    jyb:GetAnimState():SetBank("myth_rhino_desk")
    jyb:GetAnimState():SetBuild("myth_rhino_desk")
    jyb:GetAnimState():PlayAnimation('idle')
	jyb:SetPosition(-80 ,y-140)
	jyb:MoveToBack()
	jyb:SetClickable(false)

	y = y- 60
	local title = details_root:AddChild(Text(HEADERFONT, titlesizi, MYTH_BOOINFO.sxn.text1, UICOLOURS.BROWN_DARK))
	title:SetPosition(110, y+35)

	y = y- 35
	title = details_root:AddChild(Text(HEADERFONT, contentsizi+4, MYTH_BOOINFO.sxn.text2, DARKGREY))
	title:SetPosition(110, y)	
	y = y-55
	MakeDetailsLine(details_root, 0, y-5, .9)

	y = y-25
	title = details_root:AddChild(Text(HEADERFONT, titlesizi, MYTH_BOOINFO.sxn.text3, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y+5)

	y = y- 70
	title = details_root:AddChild(Text(HEADERFONT, titlesizi-2, MYTH_BOOINFO.sxn.text4, DARKGREY))
	title:SetPosition(0, y)	

	y = y-80
	MakeDetailsLine(details_root, 0, y+8, .85, "line_short.tex")

	y = y-20
	title = details_root:AddChild(Text(HEADERFONT, titlesizi-2, MYTH_BOOINFO.sxn.text5, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y+8)

	self:_SetupRecipeIngredientDetails(sxu_recipes, details_root, y-10,0)
	MakeDetailsLine(details_root, 0, y-110, .9)
end


function MythbookPageGuaiWu:PoopData3()
	self.details_root:KillAllChildren()
	local details_root = self.details_root

	local y = 270

	MakeDetailsLine(details_root, 0, y, .59)

	local jyb = details_root:AddChild(UIAnim())
	jyb:SetScale(0.22)
    jyb:GetAnimState():SetBank("myth_goldfrog_base")
    jyb:GetAnimState():SetBuild("myth_goldfrog_base")
    jyb:GetAnimState():PlayAnimation('idle')
	jyb:SetPosition(-120 ,y-130)
	jyb:MoveToBack()
	jyb:SetClickable(false)

	y = y- 60
	local title = details_root:AddChild(Text(HEADERFONT, titlesizi, MYTH_BOOINFO.myth_goldfrog.text1, UICOLOURS.BROWN_DARK))
	title:SetPosition(70, y+35)

	y = y- 35
	title = details_root:AddChild(Text(HEADERFONT, titlesizi-4, MYTH_BOOINFO.myth_goldfrog.text2, DARKGREY))
	title:SetPosition(70, y)	
	y = y-55
	MakeDetailsLine(details_root, 0, y-5, .9)

	y = y-25
	title = details_root:AddChild(Text(HEADERFONT, titlesizi-2, MYTH_BOOINFO.myth_goldfrog.text3, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y+5)

	y = y- 50
	title = details_root:AddChild(Text(HEADERFONT, contentsizi, MYTH_BOOINFO.myth_goldfrog.text4, DARKGREY))
	title:SetPosition(0, y)	

	y = y-60
	MakeDetailsLine(details_root, 0, y+8, .85, "line_short.tex")

	y = y-20
	title = details_root:AddChild(Text(HEADERFONT, titlesizi-2, MYTH_BOOINFO.myth_goldfrog.text5, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y)
	self:_SetupRecipeIngredientDetails(goldfrog_recipes1, details_root, y-10,100)

	self:_SetupRecipeIngredientDetails(goldfrog_recipes2, details_root, y-56,50)

	local peachtree = details_root:AddChild(UIAnim())
	peachtree:SetScale(0.28)
    peachtree:GetAnimState():SetBank("myth_treasure_bowl")
    peachtree:GetAnimState():SetBuild("myth_treasure_bowl")
    peachtree:GetAnimState():PlayAnimation('idle')
	peachtree:SetPosition(-130 ,y-130)
	peachtree:MoveToBack()
	peachtree:SetClickable(false)

	peachtree = details_root:AddChild(UIAnim())
	peachtree:SetScale(0.23)
    peachtree:GetAnimState():SetBank("myth_cash_tree")
    peachtree:GetAnimState():SetBuild("myth_cash_tree")
    peachtree:GetAnimState():PlayAnimation('idle')
	peachtree:SetPosition(-80 ,y-50)
	peachtree:MoveToBack()
	peachtree:SetClickable(false)

	MakeDetailsLine(details_root, 0, y-150, .9)

end

local xnrecipes = {
	{"siving_rocks"},
}

function MythbookPageGuaiWu:PoopData4()
	self.details_root:KillAllChildren()
	local details_root = self.details_root

	local y = 270

	MakeDetailsLine(details_root, 0, y, .59)

	y = y- 60
	local title = details_root:AddChild(Text(HEADERFONT, titlesizi, MYTH_BOOINFO.zgxn.text1, UICOLOURS.BROWN_DARK))
	title:SetPosition(-70, y+15)

	y = y- 35
	title = details_root:AddChild(Text(HEADERFONT, titlesizi-4, MYTH_BOOINFO.zgxn.text2, DARKGREY))
	title:SetPosition(-70, y-15)	
	y = y-55


	MakeDetailsLine(details_root, 0, y-35, .9)

	y = y-25
	title = details_root:AddChild(Text(HEADERFONT, titlesizi-2, MYTH_BOOINFO.zgxn.text3, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y-45)

	local peachtree1 = details_root:AddChild(UIAnim())
	peachtree1:SetScale(0.35)
    peachtree1:GetAnimState():SetBank("myth_plant_lotus")
    peachtree1:GetAnimState():SetBuild("myth_plant_lotus")
	peachtree1:GetAnimState():SetPercent("lotus_full", 1)
	peachtree1:SetPosition(80 ,y+10)
	peachtree1:MoveToBack()
	peachtree1:SetClickable(false)

	y = y- 90
	title = details_root:AddChild(Text(HEADERFONT, contentsizi+2, MYTH_BOOINFO.zgxn.text4, DARKGREY))
	title:SetPosition(0, y)	

	y = y-60
	MakeDetailsLine(details_root, 0, y+8, .85, "line_short.tex")


	y = y-25
	title = details_root:AddChild(Text(HEADERFONT, titlesizi-2, MYTH_BOOINFO.zgxn.text5, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y-5)

	y = y- 45
	title = details_root:AddChild(Text(HEADERFONT, contentsizi+2, MYTH_BOOINFO.zgxn.text6, DARKGREY))
	title:SetPosition(0, y)	

	self:_SetupRecipeIngredientDetails(xnrecipes, details_root, y+10,-140)

	MakeDetailsLine(details_root, 0, y-50, .9)
end

function MythbookPageGuaiWu:Updatedata(data)
	if data.names_pos ~= nil then
		self.names:SetPosition(unpack(data.names_pos))
	end
	self.names:SetTexture("images/myth_bookinfo.xml", data.names)

	self.boos:SetTexture("images/myth_bookinfo.xml", data.boos)

	self.jieshaotext:SetString(data.text)
	local _, msg_h = self.jieshaotext:GetRegionSize()

	self.jieshaotext:SetPosition(70, 80- msg_h/2)

	if  data.showfn ~= nil then
		data.showfn(self)
	end
end

function MythbookPageGuaiWu:BuildSkinSpinners()
	local root = Widget("spinner_root")
	
	local top = 50
	local left = 0 -- -width/2 + 5

	local sort_options = {

	}

	for i, v in ipairs(tsetskin) do
		table.insert(sort_options,{text = v[1],data = v[2]})
	end
	local function on_sort_fn(data,old)
		self:Updatedata(data)
		MYTH_BOOKINFO_PAGES.GUAIWU = self.spinners[1]:GetSelectedIndex()
	end

	local width_label = 120
	local width_spinner = 420
	local height = 45

	local function MakeSpinner(labeltext, spinnerdata, onchanged_fn, initial_data)
		local spacing = 5
		local font = HEADERFONT
		local font_size = 22

		local total_width = width_label + width_spinner + spacing
		local wdg = Widget("labelspinner")

		local lean = true
		wdg.spinner = wdg:AddChild(Spinner(spinnerdata, width_spinner, height, {font = font, size = font_size}, nil, "images/myth_bookinfo.xml", nil, lean))
		wdg.spinner:SetTextColour(UICOLOURS.BROWN_DARK)
		wdg.spinner:SetOnChangedFn(onchanged_fn)
		wdg.spinner:SetPosition((total_width/2)-(width_spinner/2), 12)
		wdg.spinner:SetSelected(initial_data)
		wdg.spinner:SetSelectedIndex(MYTH_BOOKINFO_PAGES.GUAIWU)
		return wdg
	end

	local items = {}
	--排序
	table.insert(items, MakeSpinner("", sort_options, on_sort_fn, sort_options[MYTH_BOOKINFO_PAGES.GUAIWU]))
	
	self.spinners = {}
	for i, v in ipairs(items) do
		local w = root:AddChild(v)
		w:SetPosition(0, (#items - i + 1)*(height + 3))
		table.insert(self.spinners, w.spinner)
	end
	
	return root
end

return MythbookPageGuaiWu

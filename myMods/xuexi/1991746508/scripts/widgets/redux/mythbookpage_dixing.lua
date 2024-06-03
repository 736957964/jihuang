local Widget = require "widgets/widget"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local Grid = require "widgets/grid"
local Spinner = require "widgets/spinner"

local TEMPLATES = require "widgets/redux/templates"

local MYTH_BOOINFO = STRINGS.MYTH_BOOINFO.DIXING
require("util")

local L = MK_MOD_LANGUAGE_SETTING
local V = L == "VI" and true or false

--线条哦
local function MakeDetailsLine(details_root, x, y, scale, image_override)
	local value_title_line = details_root:AddChild(Image("images/myth_bookinfo.xml", image_override or "line_long.tex"))
	value_title_line:SetScale(scale, scale)
	value_title_line:SetPosition(x, y)
end

local L = MK_MOD_LANGUAGE_SETTING
local IS_VI = L == "VI"
local titlesizi = IS_VI and 25  or 40
local contentsizi = IS_VI and 18  or 28

-----------显示的内容
local dixingdata = {
{"",
	{
		names = "myth_taoyuan.tex",
		text = MYTH_BOOINFO.taoyuan.title,
		
		showfn = function(self)
			self:PoopData1()
		end,

		buttons = {
			{
				image = "taoshu",
				clickfn =function(self) self:PoopData3() end,
				pos = {-58,-30},
			},
			{
				image = "fangcunshan",
				clickfn =function(self) self:PoopData1()  end,
				pos = {85,98},
			},
		},
	}
},

{"",
	{
		names = "myth_yuegong.tex",
		text = MYTH_BOOINFO.yuegong.title,
		size = IS_VI and 20 or 32,
		showfn = function(self)
			self:PoopData2()
		end,
		buttons = {
			{
				image = "jyb",
				clickfn =function(self) self:PoopData4()  end,
				pos = {85,-10},
			},
			{
				image = "ghg",
				clickfn =function(self) self:PoopData2()  end,
				pos = {-30,50},
			},
		},
	}
},

{"",
	{
		names = "myth_zhulin.tex",
		text = MYTH_BOOINFO.zhulin.title,
		size = IS_VI and 20 or 32,
		scale = 0.9,
		showfn = function(self)
			self:PoopData5()
		end,
		
		buttons = {
			{
				image = "gongzhuo",
				clickfn =function(self) self:PoopData5()  end,
				pos = {35,85},
			},
			{
				image = "zhuzi",
				clickfn =function(self) self:PoopData7()  end,
				pos = {-105,-25},
			},
			{
				image = "xiaozhen",
				clickfn =function(self) self:PoopData8()  end,
				pos = {-10,-45},
			},
			{
				image = "lianhua",
				clickfn =function(self) self:PoopData6()  end,
				pos = {-130,70},
			},
		},
	}
},
}

-------------------------------------------------------------------------------------------------------
local MythbookPageDiXingXian = Class(Widget, function(self, parent_screen, category)
    Widget._ctor(self, "MythbookPageDiXingXian")

    self.parent_screen = parent_screen
	self.category = category or "cookbook"

	self.filters = {}

	self:CreateRecipeBook()

	self:_DoFocusHookups()

	return self
end)

function MythbookPageDiXingXian:_DoFocusHookups()
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


function MythbookPageDiXingXian:CreateRecipeBook()

	local panel_root = self
	-----------
	self.gridroot = panel_root:AddChild(Widget("grid_root"))
    self.gridroot:SetPosition(-280, -35)

	self.names = self.gridroot:AddChild(Image())
	self.names:SetPosition(65 , 100)

	self.clickbutton ={}
	for k =1, 4 do
		self.clickbutton[k] = self.names:AddChild(ImageButton())
	end

	self.spinner_root = self.gridroot:AddChild(self:BuildSkinSpinners(self))
	self.spinner_root:SetPosition(0, 50)

	local details_decor = self.gridroot:AddChild(Image("images/myth_bookinfo.xml", "quagmire_recipe_menu_block_small.tex"))
    details_decor:ScaleToSize(390, 150)
	details_decor:SetPosition(75, -130)

	MakeDetailsLine(self.gridroot, 65, 270, 0.91)

	self.jieshaotext = self.gridroot:AddChild(Text(HEADERFONT, contentsizi+2 , "", DARKGREY))
	self.jieshaotext:SetPosition(4, 24)
	self.jieshaotext:SetHAlign(ANCHOR_LEFT)
	self.jieshaotext:SetRegionSize(370, 300)
	self.jieshaotext:EnableWordWrap(true)

	self.details_root = self.gridroot:AddChild(Widget("details_root"))
	self.details_root:SetPosition(500, 10)

	self:Updatedata(dixingdata[MYTH_BOOKINFO_PAGES.DIXING][2])
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

function MythbookPageDiXingXian:_SetupRecipeIngredientDetails(recipes, parent, y,nobank)
	local ingredient_size = nobank and 50 or 40
	local x_spacing = 10

	local inv_backing_root = parent:AddChild(Widget("inv_backing_root"))
	local inv_item_root = parent:AddChild(Widget("inv_item_root"))
	local index = 1
	if #recipes <= 3 then
		for b = 1, #recipes do
			local items = recipes[index]
			local x = -((#items + 1)*ingredient_size + (#items-1)*x_spacing) / 2 
			for i = 1, #items do
				--这是配方！！
				local backing = inv_backing_root:AddChild(Image("images/quagmire_recipebook.xml", "ingredient_slot.tex"))
				backing:ScaleToSize(ingredient_size, ingredient_size)
				backing:SetPosition(x + (i)*ingredient_size + (i-1)*x_spacing, y - ingredient_size/2 - (b-1)*(ingredient_size+5))
				if nobank then
					backing:Hide()
				end
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

function MythbookPageDiXingXian:PoopData1(data)
	self.details_root:KillAllChildren()
	local details_root = self.details_root

	local y = 250
	MakeDetailsLine(self.details_root, 0, y, 0.95, "quagmire_recipe_line_break.tex")

	y = y-40
	local title = details_root:AddChild(Text(HEADERFONT, titlesizi, MYTH_BOOINFO.taoyuan.text1, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y)

	MakeDetailsLine(details_root, -80, y-30, .55,"line_short.tex")

	MakeDetailsLine(details_root, -80, y-130, .55,"line_short.tex")

	y = y -80
	title = details_root:AddChild(Text(HEADERFONT, contentsizi, MYTH_BOOINFO.taoyuan.text2, UICOLOURS.BROWN_DARK))
	title:SetPosition(-80, y)

	local npcnaim = details_root:AddChild(UIAnim())
    npcnaim:GetAnimState():SetBank("fangcunhill")
    npcnaim:GetAnimState():SetBuild("fangcunhill")
    npcnaim:GetAnimState():PlayAnimation('anim')
	npcnaim:GetAnimState():OverrideSymbol("snow", "fangcunhill", "emptysnow")
	npcnaim:SetPosition(80 ,y-300)
	npcnaim:SetScale(0.18)
	npcnaim:MoveToBack()
	npcnaim:SetClickable(false)

	npcnaim = details_root:AddChild(UIAnim())
    npcnaim:GetAnimState():SetBank("myth_smalllight")
    npcnaim:GetAnimState():SetBuild("myth_smalllight")
    npcnaim:GetAnimState():PlayAnimation('turnoff')
	npcnaim:SetPosition(-160 ,y-300)
	npcnaim:SetScale(0.18)
	npcnaim:MoveToBack()
	npcnaim:SetClickable(false)


	npcnaim = details_root:AddChild(UIAnim())
    npcnaim:GetAnimState():SetBank("myth_zodiac")
    npcnaim:GetAnimState():SetBuild("myth_zodiac")
    npcnaim:GetAnimState():PlayAnimation('idle3')
	npcnaim:SetPosition(-80 ,y-150)
	npcnaim:SetScale(0.14)
	npcnaim:MoveToBack()
	npcnaim:SetClickable(false)

	npcnaim = details_root:AddChild(UIAnim())
    npcnaim:GetAnimState():SetBank("myth_zodiac")
    npcnaim:GetAnimState():SetBuild("myth_zodiac")
    npcnaim:GetAnimState():PlayAnimation('idle2')
	npcnaim:SetPosition(-80 ,y-150)
	npcnaim:SetScale(0.14)
	npcnaim:MoveToBack()
	npcnaim:SetClickable(false)

	npcnaim = details_root:AddChild(UIAnim())
    npcnaim:GetAnimState():SetBank("myth_zodiac")
    npcnaim:GetAnimState():SetBuild("myth_zodiac")
    npcnaim:GetAnimState():PlayAnimation('idle1')
	npcnaim:SetPosition(-80 ,y-150)
	npcnaim:SetScale(0.14)
	npcnaim:MoveToBack()
	npcnaim:SetClickable(false)

end

function MythbookPageDiXingXian:PoopData2()
	self.details_root:KillAllChildren()
	local details_root = self.details_root

	local y = 250
	MakeDetailsLine(self.details_root, 0, y, 0.95, "quagmire_recipe_line_break.tex")

	y = y-40
	local title = details_root:AddChild(Text(HEADERFONT, titlesizi, MYTH_BOOINFO.yuegong.text1, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y)

	MakeDetailsLine(details_root, -120, y-30, .55,"line_short.tex")

	MakeDetailsLine(details_root, -120, y-130, .55,"line_short.tex")

	y = y -80
	title = details_root:AddChild(Text(HEADERFONT, contentsizi-2, MYTH_BOOINFO.yuegong.text2, UICOLOURS.BROWN_DARK))
	title:SetPosition(-120, y)

	local npcnaim = details_root:AddChild(UIAnim())
    npcnaim:GetAnimState():SetBank("myth_ghg")
    npcnaim:GetAnimState():SetBuild("myth_ghg")
    npcnaim:GetAnimState():PlayAnimation('idle')
	npcnaim:SetPosition(60 ,y-300)
	npcnaim:SetScale(0.22)
	npcnaim:MoveToBack()
	npcnaim:SetClickable(false)

	npcnaim = details_root:AddChild(UIAnim())
    npcnaim:GetAnimState():SetBank("myth_interiors_ghg")
    npcnaim:GetAnimState():SetBuild("myth_interiors_ghg")
    npcnaim:GetAnimState():PlayAnimation('left_he')
	npcnaim:SetPosition(-140 ,y-310)
	npcnaim:SetScale(0.2)
	npcnaim:MoveToBack()
	npcnaim:SetClickable(false)
end


local peachstate = {
	{V and "Giai đoạn 1" or "阶段1","lv1_idle"},
	{V and "Giai đoạn 2" or "阶段2","lv2_idle"},
	{V and "Giai đoạn 3" or "阶段3","lv3_idle"},
	{V and "Giai đoạn 4" or "阶段4","lv3_idle"},
}

local lotusstate = {
	{V and "Giai đoạn 1" or "阶段1","lotus_sprout"},
	{V and "Giai đoạn 2" or "阶段2","lotus_small"},
	{V and "Giai đoạn 3" or "阶段3","lotus_med"},
	{V and "Giai đoạn 4" or "阶段4","lotus_full"},
	{V and "Giai đoạn 5" or "阶段5","lotus_rot"},
}

local zhuzistate = {
	{V and "Mầm măng" or "竹笋","short_0"},
	{V and "Măng" or "青竹芽","short_1"},
	{V and "Tre non" or "青竹苗","short_2"},
	{V and "Tre" or "青竹","idle"},
	{V and "Tre lớn" or "成竹","idle"},
	{V and "Tre già" or "苍竹","idle"},
}


local function updatestate(AnimState,level)
	if level == 1 then
		AnimState:OverrideSymbol("fruit", "myth_peachtree", "emptytop")
		AnimState:OverrideSymbol("tall_leaves", "myth_peachtree", "tall_leaves")
		AnimState:OverrideSymbol("flower", "myth_peachtree", "emptytop")
	elseif level == 2 then
		AnimState:OverrideSymbol("fruit", "myth_peachtree", "emptytop")
		AnimState:OverrideSymbol("tall_leaves", "myth_peachtree", "emptytop")
		AnimState:OverrideSymbol("flower", "myth_peachtree", "flower")
	elseif level == 3 then
		AnimState:OverrideSymbol("fruit", "myth_peachtree", "fruit")
		AnimState:OverrideSymbol("tall_leaves", "myth_peachtree", "emptytop")
		AnimState:OverrideSymbol("flower", "myth_peachtree", "emptytop")
	end
end

local zhubanks = {
	"plant_bamboo_short",
	"plant_bamboo_short",
	"plant_bamboo_short",
	"plant_bamboo_mild_3",
	"plant_bamboo_tall_1",
	"plant_bamboo_supertall_1",
}
local  function  zhuzibank(AnimState,level)
	if zhubanks[level+1] ~= nil then
		AnimState:SetBank(zhubanks[level+1])
	end
end

local function PeachSpinners(self,target,state,changfn)
	local root = Widget("spinner_root")
	
	local top = 50
	local left = 0 -- -width/2 + 5

	local sort_options = {

	}

	for i, v in ipairs(target) do
		table.insert(sort_options,{text = v[1],data = v[2]})
	end
	local function on_sort_fn(data)
		self:GetAnimState():PlayAnimation(data,true)
		if changfn ~= nil then
			changfn(self:GetAnimState(),self.spinners[1]:GetSelectedIndex()-1)
		end
	end

	local width_label = 120
	local width_spinner = 100
	local height = 20

	local function MakeSpinner(labeltext, spinnerdata, onchanged_fn, initial_data)
		local spacing = 5
		local font = HEADERFONT
		local font_size = 22

		local total_width = width_label + width_spinner + spacing
		local wdg = Widget("labelspinner")

		local lean = true
		wdg.spinner = wdg:AddChild(Spinner(spinnerdata, width_spinner, height, {font = font, size = font_size}, nil, "images/plantregistry.xml", nil, lean))
		wdg.spinner:SetTextColour(UICOLOURS.BROWN_DARK)
		wdg.spinner:SetOnChangedFn(onchanged_fn)
		wdg.spinner:SetPosition((total_width/2)-(width_spinner/2), 12)
		wdg.spinner:SetSelected(initial_data)

		wdg.spinner:SetSelectedIndex(state or #target)
		return wdg
	end

	local items = {}

	table.insert(items, MakeSpinner("", sort_options, on_sort_fn, sort_options[MYTH_BOOKINFO_PAGES.DIXING]))
	
	self.spinners = {}
	for i, v in ipairs(items) do
		local w = root:AddChild(v)
		w:SetPosition(0, (#items - i + 1)*(height + 3))
		table.insert(self.spinners, w.spinner)
	end
	
	return root
end
function MythbookPageDiXingXian:PoopData3(data)
	self.details_root:KillAllChildren()
	local details_root = self.details_root

	local y = 250
	MakeDetailsLine(self.details_root, 0, y, 0.95, "quagmire_recipe_line_break.tex")

	y = y-40
	local title = details_root:AddChild(Text(HEADERFONT, titlesizi, MYTH_BOOINFO.taoyuan.text3, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y)
	
	
	title = details_root:AddChild(Text(HEADERFONT, contentsizi, MYTH_BOOINFO.taoyuan.text4, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y-320)	
	title:SetHAlign(ANCHOR_LEFT)
	
	y = y-150

	local peachtree1 = details_root:AddChild(UIAnim())
	peachtree1:SetScale(0.26)
    peachtree1:GetAnimState():SetBank("myth_peachtree")
    peachtree1:GetAnimState():SetBuild("myth_peachtree")
    peachtree1:GetAnimState():PlayAnimation('lv3_idle2',true)
	peachtree1:GetAnimState():OverrideSymbol("snow", "myth_peachtree", "emptysnow")
	peachtree1:SetPosition(0 ,y-80)
	peachtree1:MoveToBack()
	peachtree1:SetClickable(false)

	local spinner = details_root:AddChild(PeachSpinners(peachtree1,peachstate,nil,updatestate))
	spinner:SetPosition(-60 ,y-140)

	MakeDetailsLine(details_root, 0, y-120, .65)
	MakeDetailsLine(details_root, 0, y-220, .65)
end

function MythbookPageDiXingXian:PoopData4(data)
	self.details_root:KillAllChildren()
	local details_root = self.details_root

	local y = 250
	MakeDetailsLine(self.details_root, 0, y, 0.95, "quagmire_recipe_line_break.tex")

	y = y-40
	local title = details_root:AddChild(Text(HEADERFONT, titlesizi, MYTH_BOOINFO.yuegong.text3, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y)
	
	
	title = details_root:AddChild(Text(HEADERFONT, contentsizi, MYTH_BOOINFO.yuegong.text4, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y-320)	
	title:SetHAlign(ANCHOR_LEFT)
	
	y = y-150

	local peachtree = details_root:AddChild(UIAnim())
	peachtree:SetScale(0.3)
    peachtree:GetAnimState():SetBank("myth_goldfrog_base")
    peachtree:GetAnimState():SetBuild("myth_goldfrog_base")
    peachtree:GetAnimState():PlayAnimation("idle")
	peachtree:SetPosition(0 ,y-60)
	peachtree:MoveToBack()
	peachtree:SetClickable(false)

	MakeDetailsLine(details_root, 0, y-120, .68)
	MakeDetailsLine(details_root, 0, y-220, .68)
end


function MythbookPageDiXingXian:PoopData5(data)
	self.details_root:KillAllChildren()
	local details_root = self.details_root

	local y = 250
	MakeDetailsLine(self.details_root, 0, y, 0.95, "quagmire_recipe_line_break.tex")

	y = y-40
	local title = details_root:AddChild(Text(HEADERFONT, titlesizi, MYTH_BOOINFO.zhulin.text3, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y)
	
	
	title = details_root:AddChild(Text(HEADERFONT, contentsizi, MYTH_BOOINFO.zhulin.text4, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y-310)	
	title:SetHAlign(ANCHOR_LEFT)
	
	y = y-150

	local peachtree = details_root:AddChild(UIAnim())
	peachtree:SetScale(0.4)
    peachtree:GetAnimState():SetBank("myth_rhino_desk")
    peachtree:GetAnimState():SetBuild("myth_rhino_desk")
    peachtree:GetAnimState():PlayAnimation("idle")
	peachtree:SetPosition(0 ,y-40)
	peachtree:MoveToBack()
	peachtree:SetClickable(false)

	MakeDetailsLine(details_root, 0, y-100, .88)
	MakeDetailsLine(details_root, 0, y-220, .88)
end

function MythbookPageDiXingXian:PoopData6(data)
	self.details_root:KillAllChildren()
	local details_root = self.details_root

	local y = 250
	MakeDetailsLine(self.details_root, 0, y, 0.95, "quagmire_recipe_line_break.tex")

	y = y-40
	local title = details_root:AddChild(Text(HEADERFONT, titlesizi, MYTH_BOOINFO.zhulin.text1, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y)
	
	
	title = details_root:AddChild(Text(HEADERFONT, contentsizi, MYTH_BOOINFO.zhulin.text2, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y-320)	
	title:SetHAlign(ANCHOR_LEFT)
	title:SetRegionSize(340, 300)
	title:EnableWordWrap(true)
	
	y = y-150

	local peachtree1 = details_root:AddChild(UIAnim())
	peachtree1:SetScale(0.35)
    peachtree1:GetAnimState():SetBank("myth_plant_lotus")
    peachtree1:GetAnimState():SetBuild("myth_plant_lotus")
    peachtree1:GetAnimState():PlayAnimation('lotus_full',true)
	peachtree1:SetPosition(0 ,y-50)
	peachtree1:MoveToBack()
	peachtree1:SetClickable(false)

	local front = peachtree1:AddChild(UIAnim())
	front:SetScale(0.6)
    front:GetAnimState():SetBank("float_front")
    front:GetAnimState():SetBuild("float_fx")
    front:GetAnimState():PlayAnimation('idle_front_small',true)
	front:SetPosition(0 ,20)
	front:SetClickable(false)

	local back = peachtree1:AddChild(UIAnim())
	back:SetScale(0.6)
    back:GetAnimState():SetBank("float_back")
    back:GetAnimState():SetBuild("float_fx")
    back:GetAnimState():PlayAnimation('idle_back_small',true)
	back:SetPosition(0 ,20)
	back:MoveToBack()
	back:SetClickable(false)

	local spinner = details_root:AddChild(PeachSpinners(peachtree1,lotusstate,4))
	spinner:SetPosition(-60 ,y-110)

	MakeDetailsLine(details_root, 0, y-100, .85)
	MakeDetailsLine(details_root, 0, y-240, .85)
end


function MythbookPageDiXingXian:PoopData7(data)
	self.details_root:KillAllChildren()
	local details_root = self.details_root

	local y = 250
	MakeDetailsLine(self.details_root, 0, y, 0.95, "quagmire_recipe_line_break.tex")

	y = y-40
	local title = details_root:AddChild(Text(HEADERFONT, titlesizi, MYTH_BOOINFO.zhulin.text5, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y)
	
	
	title = details_root:AddChild(Text(HEADERFONT, contentsizi, MYTH_BOOINFO.zhulin.text6, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y-310)	
	title:SetHAlign(ANCHOR_LEFT)
	
	y = y-150

	local peachtree1 = details_root:AddChild(UIAnim())
	peachtree1:SetScale(0.17)
    peachtree1:GetAnimState():SetBank("plant_bamboo_supertall_1")
    peachtree1:GetAnimState():SetBuild("myth_plant_bamboo")
    peachtree1:GetAnimState():PlayAnimation('idle',true)
	peachtree1:SetPosition(0 ,y-70)
	peachtree1:MoveToBack()
	peachtree1:SetClickable(false)

	local spinner = details_root:AddChild(PeachSpinners(peachtree1,zhuzistate,nil,zhuzibank))
	spinner:SetPosition(-60 ,y-120)

	MakeDetailsLine(details_root, 0, y-110, .65)
	MakeDetailsLine(details_root, 0, y-220, .65)
end

local qingzhustate = {
	{"","myth_statue_pandaman"},
	{"","myth_store"},
}

local qingmiaoshu = {
	{
		V and "Tượng người bảo hộ" or "守护者雕像",
	 	V and "Nội dung chưa ra mắt" or "更多内容敬请期待"
	},
	{
		V and "Quán đóng cửa" or "打烊的小店",
		V and "Nội dung chưa ra mắt" or "更多内容敬请期待"
	},
}

local function qingchange(self,self1,num)
	self:SetString(qingmiaoshu[num][1])
	self1:SetString(qingmiaoshu[num][2])
end

local function QingSpinners(self,target,state,changfn,self1,self2)
	local root = Widget("spinner_root")
	
	local top = 50
	local left = 0 -- -width/2 + 5

	local sort_options = {

	}

	for i, v in ipairs(target) do
		table.insert(sort_options,{text = v[1],data = v[2]})
	end
	local function on_sort_fn(data)
		self:GetAnimState():SetBank(data,true)
		self:GetAnimState():SetBuild(data,true)
		if changfn ~= nil then
			changfn(self1,self2,self.spinners[1]:GetSelectedIndex())
		end
	end

	local width_label = 120
	local width_spinner = 300
	local height = 30

	local function MakeaaSpinner(labeltext, spinnerdata, onchanged_fn, initial_data)
		local spacing = 5
		local font = HEADERFONT
		local font_size = 30

		local total_width = width_label + width_spinner + spacing
		local wdg = Widget("labelspinner")
		local lean = true
		wdg.spinner = wdg:AddChild(Spinner(spinnerdata, width_spinner, height, {font = font, size = font_size}, nil, "images/myth_bookinfo.xml", nil, lean))
		wdg.spinner:SetTextColour(UICOLOURS.BROWN_DARK)
		wdg.spinner:SetOnChangedFn(onchanged_fn)
		wdg.spinner:SetPosition((total_width/2)-(width_spinner/2), 122)
		wdg.spinner:SetSelected(initial_data)

		wdg.spinner:SetSelectedIndex(state or #target)
		return wdg
	end

	local items = {}

	table.insert(items, MakeaaSpinner("", sort_options, on_sort_fn, sort_options[MYTH_BOOKINFO_PAGES.DIXING]))
	
	self.spinners = {}
	for i, v in ipairs(items) do
		local w = root:AddChild(v)
		w:SetPosition(0, (#items - i + 1)*(height + 3))
		table.insert(self.spinners, w.spinner)
	end
	
	return root
end

function MythbookPageDiXingXian:PoopData8(data)
	self.details_root:KillAllChildren()
	local details_root = self.details_root

	local y = 250
	MakeDetailsLine(self.details_root, 0, y, 0.95, "quagmire_recipe_line_break.tex")

	y = y-40
	local title = details_root:AddChild(Text(HEADERFONT, titlesizi, MYTH_BOOINFO.zhulin.text7, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y)


	y = y-150

	local peachtree1 = details_root:AddChild(UIAnim())
	peachtree1:SetScale(0.2)
    peachtree1:GetAnimState():SetBank("myth_statue_pandaman")
    peachtree1:GetAnimState():SetBuild("myth_statue_pandaman")
    peachtree1:GetAnimState():PlayAnimation('idle')
	peachtree1:SetPosition(0 ,y-70)
	peachtree1:MoveToBack()
	peachtree1:SetClickable(false)

	local title1 = details_root:AddChild(Text(HEADERFONT, contentsizi, MYTH_BOOINFO.zhulin.text8, UICOLOURS.BLACK))
	title1:SetPosition(0, y-100)

	local title2 = details_root:AddChild(Text(HEADERFONT, contentsizi-2, qingmiaoshu[1][2], UICOLOURS.BROWN_DARK))
	title2:SetPosition(0, y-180)

	local spinner = details_root:AddChild(QingSpinners(peachtree1,qingzhustate,1,qingchange,title1,title2))
	spinner:SetPosition(-60 ,y-120)

	MakeDetailsLine(details_root, 0, y-120, .65)
	MakeDetailsLine(details_root, 0, y-240, .65)
end

function MythbookPageDiXingXian:Updatedata(data)
	self.names:SetTexture("images/myth_bookinfo.xml", data.names)
	self.names:SetScale(data.scale or 1)

	self.jieshaotext:SetString(data.text)
	local _, msg_h = self.jieshaotext:GetRegionSize()

	--size
	self.jieshaotext:SetSize(data.size or (IS_VI and 18 or 28))
	self.jieshaotext:SetPosition(75, 20- msg_h/2)
	if  data.showfn ~= nil then
		data.showfn(self)
	end

	if data.buttons ~= nil then
		for k = 1, #self.clickbutton do 
			if data.buttons[k] ~= nil and data.buttons[k].image ~= nil then
				self.clickbutton[k]:Show()
				self.clickbutton[k]:SetTextures("images/myth_bookinfo.xml", data.buttons[k].image.."_idle.tex", data.buttons[k].image.."_click.tex", data.buttons[k].image.."_idle.tex", data.buttons[k].image.."_click.tex", data.buttons[k].image.."_idle.tex")
				self.clickbutton[k]:SetPosition(unpack(data.buttons[k].pos))
				self.clickbutton[k].onclick = function() data.buttons[k].clickfn(self) end
				if data.buttons[k].size ~= nil then
					self.clickbutton[k]:SetScale(data.buttons[k].size)
				else
					self.clickbutton[k]:SetScale(1)
				end
			else
				self.clickbutton[k]:Hide()
			end
		end
	end
end

function MythbookPageDiXingXian:BuildSkinSpinners()
	local root = Widget("spinner_root")
	
	local top = 50
	local left = 0 -- -width/2 + 5

	local sort_options = {

	}

	for i, v in ipairs(dixingdata) do
		table.insert(sort_options,{text = v[1],data = v[2]})
	end
	local function on_sort_fn(data)
		self:Updatedata(data)
		MYTH_BOOKINFO_PAGES.DIXING = self.spinners[1]:GetSelectedIndex()
	end

	local width_label = 120
	local width_spinner = 400
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
		wdg.spinner:SetSelectedIndex(MYTH_BOOKINFO_PAGES.DIXING)
		return wdg
	end

	local items = {}

	table.insert(items, MakeSpinner("", sort_options, on_sort_fn, sort_options[MYTH_BOOKINFO_PAGES.DIXING]))
	
	self.spinners = {}
	for i, v in ipairs(items) do
		local w = root:AddChild(v)
		w:SetPosition(0, (#items - i + 1)*(height + 3))
		table.insert(self.spinners, w.spinner)
	end
	
	return root
end

return MythbookPageDiXingXian

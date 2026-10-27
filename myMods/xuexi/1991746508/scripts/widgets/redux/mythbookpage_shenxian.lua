local Widget = require "widgets/widget"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local Grid = require "widgets/grid"
local Spinner = require "widgets/spinner"

local TEMPLATES = require "widgets/redux/templates"

local L = MK_MOD_LANGUAGE_SETTING
local IS_VI = L == "VI"
local titlesizi = IS_VI and 24  or 34
local contentsizi = IS_VI and 18  or 24

require("util")

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
		names = "names_laozi.tex",
		anims = {bank ="laozi" ,build ="laozi" ,anim = "idle" ,size = 26,pos = {65,55}},

		text = STRINGS.MYTH_BOOINFO.SHENXIAN.laozi.title,
		showfn = function(self)
			self:PoopData1()
		end
	}
},

{"",
{
	names = "names_chenge.tex",
	anims = {bank = "myth_chang_e" ,build ="myth_chang_e"  ,anim ="idle"  ,size = 30 , pos = {65,82}},
	text = STRINGS.MYTH_BOOINFO.SHENXIAN.ghg.title,
	showfn = function(self)
		self:PoopData2()
	end
}
},

{"",
{
	names = "names_tudi.tex",
	anims = {bank ="wilson"  ,build ="myth_tudi"  ,anim ="idle_loop"  ,size = 60, pos = {65,72}},
	text = STRINGS.MYTH_BOOINFO.SHENXIAN.tudi.title,
	showfn = function(self)
		self:PoopData3()
	end
}
},
}

-------------------------------------------------------------------------------------------------------
local MythbookPageShenXian = Class(Widget, function(self, parent_screen, category)
    Widget._ctor(self, "MythbookPageShenXian")

    self.parent_screen = parent_screen
	self.category = category or "cookbook"

	self.filters = {}

	self:CreateRecipeBook()

	self:_DoFocusHookups()

	return self
end)

function MythbookPageShenXian:_DoFocusHookups()
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


function MythbookPageShenXian:CreateRecipeBook()

	local panel_root = self
	-----------
	self.gridroot = panel_root:AddChild(Widget("grid_root"))
    self.gridroot:SetPosition(-280, -35)

	self.names = self.gridroot:AddChild(Image())
	self.names:SetScale(0.8)
	self.names:SetPosition(65 , 29)

	self.npcnaim = self.gridroot:AddChild(UIAnim())
	self.npcnaim:GetAnimState():SetScale( 30, 30 )
    self.npcnaim:GetAnimState():SetBank("laozi")
    self.npcnaim:GetAnimState():SetBuild("laozi")
    --self.npcnaim:GetAnimState():SetPercent("anim", 0)
	self.npcnaim:GetAnimState():PlayAnimation("idle", true)
	self.npcnaim:GetAnimState():Hide("ARM_normal")--ARM_normal
    self.npcnaim:GetAnimState():Show("ARM_carry")
	self.npcnaim:GetAnimState():OverrideSymbol("swap_object", "myth_tuqi_weapon", "myth_tuqi_weapon")
	self.npcnaim:SetFacing(FACING_DOWN)
	self.npcnaim:SetPosition(65 ,65)
	self.npcnaim:Hide()
	self.npcnaim:MoveToBack()
	self.npcnaim:SetClickable(false)

	self.spinner_root = self.gridroot:AddChild(self:BuildSkinSpinners(self))
	self.spinner_root:SetPosition(0, 0)

	local details_decor = self.gridroot:AddChild(Image("images/myth_bookinfo.xml", "quagmire_recipe_menu_block_small.tex"))
    details_decor:ScaleToSize(320, 150)
	details_decor:SetPosition(65, -70)

	MakeDetailsLine(self.gridroot, 65, 270, 0.95, "quagmire_recipe_line_break.tex")

	MakeDetailsLine(self.gridroot, 65, -170, -0.95, "quagmire_recipe_line_break.tex")

	self.jieshaotext = self.names:AddChild(Text(HEADERFONT, titlesizi, "", DARKGREY)) --34
	self.jieshaotext:SetPosition(4, 24)
	self.jieshaotext:SetHAlign(ANCHOR_LEFT)
	self.jieshaotext:SetRegionSize(380, 300)
	self.jieshaotext:EnableWordWrap(true)

	self.details_root = self.gridroot:AddChild(Widget("details_root"))
	self.details_root:SetPosition(500, 10)

	self:Updatedata(tsetskin[MYTH_BOOKINFO_PAGES.SHENXIAN][2])
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

function MythbookPageShenXian:_SetupRecipeIngredientDetails(recipes, parent, y,nobank)
	local ingredient_size = nobank and 50 or 40
	local x_spacing = 10

	local inv_backing_root = parent:AddChild(Widget("inv_backing_root"))
	local inv_item_root = parent:AddChild(Widget("inv_item_root"))
	local index = 1
	if #recipes <= 5 then
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


local recipes1 = {
	{"featherfan", "bearger_fur", "amulet", "blueamulet","purpleamulet","armorsiving"},
	{"shroom_skin", "hivehat", "malbatross_beak","shadowheart","deerclops_eyeball","siving_hat"},
	{"ruins_bat","armorruins","ruinshat","dragon_scales","laozi_bell"},
}

local recipes2 = {
	{"bananafan", "armor_pill", "fly_pill", "bloodthirsty_pill","ruinshat","armorruins"},
	{"ruins_bat", "condensed_pill",},
}

local character_items = {"golden_armor_mk", "golden_hat_mk", "yangjian_hair", "yangjian_armor"}

if TUNING.MYTH_CHARACTER_MOD_OPEN then
	recipes1[4] = {}
	for _, v in ipairs(character_items) do
		table.insert(recipes1[4],v)
		table.insert(recipes2[2],v)
	end
end

function MythbookPageShenXian:PoopData1(data)
	self.details_root:KillAllChildren()
	local details_root = self.details_root

	local y = 250

	local title = details_root:AddChild(Text(HEADERFONT, contentsizi+6, STRINGS.MYTH_BOOINFO.DUIHUAN, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y)

	MakeDetailsLine(details_root, 0, y-20, .89)

	MakeDetailsLine(details_root, 0, -180, .89)

	self:_SetupRecipeIngredientDetails(recipes1, details_root, y-50)

	if TUNING.MYTH_CHARACTER_MOD_OPEN then
		y = y -30
	end
	y = y -220 
	title = details_root:AddChild(Text(HEADERFONT, contentsizi, STRINGS.MYTH_BOOINFO.GEIYU, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y)

	MakeDetailsLine(details_root, 0, y - 20, .75, "line_short.tex")
	y = y-50
	title = details_root:AddChild(Text(HEADERFONT, contentsizi, STRINGS.MYTH_BOOINFO.HUODE, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y)	

	self:_SetupRecipeIngredientDetails(recipes2, details_root, y-30)

end

local change_recipes1 = {{"myth_fence_item"}}
local change_recipes2 = {{"myth_interiors_ghg_lu","myth_interiors_ghg_flower"}}
local change_recipes3 = {{"myth_redlantern_ground"}}
local change_recipes4 = {{"myth_interiors_ghg_he_left","myth_redlantern","myth_interiors_ghg_he_right"}}
local change_recipes5 = {{"myth_ruyi","myth_interiors_ghg_groundlight"}}
local change_recipes6 = {{"myth_bbn","myth_yylp"}}
function MythbookPageShenXian:PoopData2()
	self.details_root:KillAllChildren()
	local details_root = self.details_root
	local y = 250
	local title = details_root:AddChild(Text(HEADERFONT, contentsizi+20, STRINGS.MKCERECIPE, UICOLOURS.BROWN_DARK))
	title:SetPosition(30, y)

	local backing = title:AddChild(Image("images/hud/myth_tab_change.xml", "myth_tab_change.tex"))
	backing:ScaleToSize(70, 70)
	backing:SetPosition(-120,0)


	MakeDetailsLine(details_root, 0, y-20, .89)

	MakeDetailsLine(details_root, 0, -180, .89)
	y = y-20
	self:_SetupRecipeIngredientDetails(change_recipes1, details_root, y-10,true)
	y = y-70
	MakeDetailsLine(details_root, 0, y+8, .85, "line_short.tex")

	self:_SetupRecipeIngredientDetails(change_recipes2, details_root, y-10,true)

	y = y-70
	MakeDetailsLine(details_root, 0, y+8, .85, "line_short.tex")

	self:_SetupRecipeIngredientDetails(change_recipes3, details_root, y-10,true)

	y = y-70
	MakeDetailsLine(details_root, 0, y+8, .85, "line_short.tex")

	self:_SetupRecipeIngredientDetails(change_recipes4, details_root, y-10,true)

	y = y-70
	MakeDetailsLine(details_root, 0, y+8, .85, "line_short.tex")

	self:_SetupRecipeIngredientDetails(change_recipes5, details_root, y-10,true)

	y = y-70
	MakeDetailsLine(details_root, 0, y+8, .85, "line_short.tex")

	self:_SetupRecipeIngredientDetails(change_recipes6, details_root, y-10,true)
end


function MythbookPageShenXian:PoopData3()
	self.details_root:KillAllChildren()
	local details_root = self.details_root

	local y = 200
	local backing = details_root:AddChild(Image("images/myth_bookinfo.xml", "tudi_shrines.tex"))
	backing:SetPosition(-80,y)

	local title = details_root:AddChild(Text(HEADERFONT, contentsizi+4, STRINGS.MYTH_BOOINFO.SHENXIAN.tudi.text1, DARKGREY))
	title:SetPosition(85, y+20)

	title = details_root:AddChild(Text(HEADERFONT, contentsizi+1, STRINGS.MYTH_BOOINFO.SHENXIAN.tudi.text2, DARKGREY))
	title:SetPosition(85, y-20)

	MakeDetailsLine(details_root, 85, y-50, .55, "line_short.tex")

	y = y - 120
	backing = details_root:AddChild(Image("images/myth_bookinfo.xml", "tudi_table.tex"))
	backing:SetPosition(0,y)

	title = details_root:AddChild(Text(HEADERFONT, contentsizi+4, STRINGS.MYTH_BOOINFO.SHENXIAN.tudi.text3, DARKGREY))
	title:SetPosition(0, y-50)

	title = details_root:AddChild(Text(HEADERFONT, contentsizi+1, STRINGS.MYTH_BOOINFO.SHENXIAN.tudi.text4, DARKGREY))
	title:SetPosition(0, y-90)
	y = y - 80
	MakeDetailsLine(details_root, 0, y-30, .85, "line_short.tex")
	
	y = y- 90
	backing = details_root:AddChild(Image("images/myth_bookinfo.xml", "tudi_thurible.tex"))
	backing:SetPosition(0,y+10)

	title = details_root:AddChild(Text(HEADERFONT, contentsizi+4, STRINGS.MYTH_BOOINFO.SHENXIAN.tudi.text5, DARKGREY))
	title:SetPosition(0, y-40)

	title = details_root:AddChild(Text(HEADERFONT, contentsizi+1, STRINGS.MYTH_BOOINFO.SHENXIAN.tudi.text6, DARKGREY))
	title:SetPosition(0, y-80)

	MakeDetailsLine(details_root, 0, y-110, .85)

end

function MythbookPageShenXian:Updatedata(data)
	self.names:SetTexture("images/myth_bookinfo.xml", data.names)
	self.jieshaotext:SetString(data.text)
	local _, msg_h = self.jieshaotext:GetRegionSize()

	self.jieshaotext:SetPosition(4, 24- msg_h/2)
	self.npcnaim:Hide()
	self.npcnaim:GetAnimState():SetScale( data.anims.size, data.anims.size )
	self.npcnaim:GetAnimState():SetBank(data.anims.bank)
	self.npcnaim:GetAnimState():SetBuild(data.anims.build)
	--self.npcnaim:GetAnimState():SetPercent(data.anims.anim, 0)
	self.npcnaim:GetAnimState():PlayAnimation(data.anims.anim, true)

	if data.anims.pos ~= nil then
		self.npcnaim:SetPosition(unpack(data.anims.pos))
	else 
		self.npcnaim:SetPosition(65 ,65)
	end
	self.npcnaim:Show()
	if  data.showfn ~= nil then
		data.showfn(self)
	end
end

function MythbookPageShenXian:BuildSkinSpinners()
	local root = Widget("spinner_root")
	
	local top = 50
	local left = 0 -- -width/2 + 5

	local sort_options = {

	}

	for i, v in ipairs(tsetskin) do
		table.insert(sort_options,{text = v[1],data = v[2]})
	end
	local function on_sort_fn(data)
		self:Updatedata(data)
		MYTH_BOOKINFO_PAGES.SHENXIAN = self.spinners[1]:GetSelectedIndex()
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

		wdg.spinner:SetSelectedIndex(MYTH_BOOKINFO_PAGES.SHENXIAN)
		return wdg
	end

	local items = {}
	--排序
	table.insert(items, MakeSpinner("", sort_options, on_sort_fn, sort_options[MYTH_BOOKINFO_PAGES.SHENXIAN]))
	
	self.spinners = {}
	for i, v in ipairs(items) do
		local w = root:AddChild(v)
		w:SetPosition(0, (#items - i + 1)*(height + 3))
		table.insert(self.spinners, w.spinner)
	end
	
	return root
end

return MythbookPageShenXian

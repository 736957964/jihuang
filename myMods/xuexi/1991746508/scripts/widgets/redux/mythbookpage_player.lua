local Widget = require "widgets/widget"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local Grid = require "widgets/grid"
local Spinner = require "widgets/spinner"
local UIAnimButton = require "widgets/uianimbutton"
local TEMPLATES = require "widgets/redux/templates"

require("util")

local L = MK_MOD_LANGUAGE_SETTING
local ISVI = L== "VI"

--线条哦
local function MakeDetailsLine(details_root, x, y, scale, image_override)
	local value_title_line = details_root:AddChild(Image("images/myth_bookinfo.xml", image_override or "line_long.tex"))
	value_title_line:SetScale(scale, scale)
	value_title_line:SetPosition(x, y)
end

-----------显示的内容
local playerinfo = {
{"",
	{
		names = "monkey_king",

		miaoshu= STRINGS.MYTH_RENWUMIAOSHU.MK,
	}
},
{"",
	{
		names = "neza",
		miaoshu= STRINGS.MYTH_RENWUMIAOSHU.NZ,
	}
},
{"",
	{
		names = "white_bone",
		miaoshu= STRINGS.MYTH_RENWUMIAOSHU.WB,
	}
},
{"",
	{
		names = "pigsy",
		miaoshu= STRINGS.MYTH_RENWUMIAOSHU.PG,
	}
},
{"",
	{
		names = "yangjian",
		miaoshu=STRINGS.MYTH_RENWUMIAOSHU.YJ,

	}
},
{"",
	{
		names = "myth_yutu",
		miaoshu=STRINGS.MYTH_RENWUMIAOSHU.YU,
	}
},
{"",
	{
		names = "yama_commissioners",
		miaoshu=STRINGS.MYTH_RENWUMIAOSHU.YA,
	}
},
}

local already = false
local function getplayerskin()
	if already then
		return
	end
	already = true
	for _, v in ipairs(playerinfo) do
		if PREFAB_SKINS[v[2].names] ~= nil then
			if not v[2].skins then
				v[2].skins = {}
			end
			for i1, v1 in ipairs(PREFAB_SKINS[v[2].names]) do 
				if not table.contains(v[2].skins,v1) then
					table.insert(v[2].skins,v1)
				end
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------
local MythbookPagePlayer = Class(Widget, function(self, parent_screen, category)
    Widget._ctor(self, "MythbookPagePlayer")

    self.parent_screen = parent_screen
	self.category = category or "cookbook"

	getplayerskin()

	self.filters = {}

	self:CreateRecipeBook()

	return self
end)

function MythbookPagePlayer:_DoFocusHookups()
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

local showsanwei = {
	{"hunger",{-97, -3}},
	{"sanity",{-57,-24}},
	{"health",{-10,-24}}
}

local CharacterButton = require "widgets/redux/characterbutton"
local CharacterSelect = require "widgets/redux/characterselect"
local CharacterBioScreen = require "screens/redux/characterbioscreen"

function MythbookPagePlayer:CreateRecipeBook()

	local panel_root = self
	-----------
	self.gridroot = panel_root:AddChild(Widget("grid_root"))
    self.gridroot:SetPosition(-280, -35)


	--你在这里有
	if not TUNING.MYTH_CHARACTER_MOD_OPEN then
		local boarder_scale = 0.90
		local grid_boarder = self.gridroot:AddChild(Image("images/myth_bookinfo.xml", "line_long.tex"))
		grid_boarder:SetScale(boarder_scale, boarder_scale)
		grid_boarder:SetPosition(70, 200)
    	local todo = grid_boarder:AddChild(Text(HEADERFONT, 35, STRINGS.MYTH_BOOINFO.NOPLAYER, UICOLOURS.BROWN_DARK))
		todo:SetPosition(0, 15)

		return
	end

	--名字
	self.names = self.gridroot:AddChild(Image())
	self.names:SetScale(0.26)
	self.names:SetPosition(155 , 220)

	--大图
	self.bigportraits = self.gridroot:AddChild(Image())
	self.bigportraits:SetScale(0.45)
	self.bigportraits:SetPosition(-35 , 110)


	self.sanwei = {}
	local status_scale = 0.6

	for i, v in ipairs(showsanwei) do
		self.sanwei[v[1]] = self.gridroot:AddChild(TEMPLATES.MakeUIStatusBadge(v[1]))
		self.sanwei[v[1]]:SetPosition(unpack(v[2]))
		self.sanwei[v[1]]:SetScale(status_scale)
		self.sanwei[v[1]].status_image:Hide()
		self.sanwei[v[1]].currentnum = self.sanwei[v[1]]:AddChild(Text(NUMBERFONT, 42))
		self.sanwei[v[1]].currentnum:SetPosition(2, 0)
		--self.sanwei[v[1]].currentnum:SetColour(245/255,198/255,73/255,1)
	end
	--食物
	MakeDetailsLine(self.gridroot, 155, -10, 0.75, "line_short.tex")
	self.food = self.gridroot:AddChild(Image())
	self.food:SetScale(0.5)
	self.food:SetPosition(40 , 10)

	self.playeranim = "monkey_king"
	self.currentskin = "monkey_king_none"
	self.npcnaim = self.gridroot:AddChild(UIAnimButton("wilson", "wilson", nil))
	self.npcnaim.animstate:PlayAnimation("idle_loop",true)
	self.npcnaim:SetScale(0.4)
	self.npcnaim.animstate:Hide("ARM_carry")
	self.npcnaim.animstate:Hide("ARM_carry")
	self.npcnaim.animstate:Hide("headbase_hat")
    self.npcnaim.animstate:Show("ARM_normal")
	self.npcnaim.uianim:SetFacing(FACING_DOWN)
	self.npcnaim:SetPosition(155 ,25)
	self.npcnaim:SetOnClick(function() 
		self:OnClickAnim()
	end)

	self.character_titles = self.gridroot:AddChild(Text(NUMBERFONT, 25))
	self.character_titles:SetPosition(155, -30)
	self.character_titles:SetColour(255/255,250/255,199/255,1)

	self.character_descriptions = self.gridroot:AddChild(Text(HEADERFONT, ISVI and 16 or 22,"", DARKGREY))
	self.character_descriptions:SetPosition(155, -30)
	self.character_descriptions:SetHAlign(ANCHOR_LEFT)

	MakeDetailsLine(self.gridroot, 158, -160, 0.75, "line_short.tex")

	self._skins	= self.gridroot:AddChild(Widget("skins_root"))
	self._invitems = self.gridroot:AddChild(Widget("items_root"))

	self.spinner_root = self.gridroot:AddChild(self:BuildSkinSpinners(self))
	self.spinner_root:SetPosition(0, 0)

	local details_decor_root = panel_root:AddChild(Widget("details_root"))
	details_decor_root:SetPosition(220, 10)
	local details_decor = details_decor_root:AddChild(Image("images/myth_bookinfo.xml", "quagmire_recipe_menu_block.tex"))
    details_decor:ScaleToSize(380, 470)

	MakeDetailsLine(self.gridroot, 65, 270, 0.95, "quagmire_recipe_line_break.tex")

	MakeDetailsLine(self.gridroot, 65, -190, -0.95, "quagmire_recipe_line_break.tex")

	self.jieshaotext = self.names:AddChild(Text(HEADERFONT, 34, "", DARKGREY))
	self.jieshaotext:SetPosition(4, 24)
	self.jieshaotext:SetHAlign(ANCHOR_LEFT)
	self.jieshaotext:SetRegionSize(380, 300)
	self.jieshaotext:EnableWordWrap(true)

	self.details_root = details_decor_root:AddChild(Widget("details_root"))
	self.details_root:SetPosition(0, 10)

	self:Updatedata(playerinfo[MYTH_BOOKINFO_PAGES.RENWU][2])
end

function MythbookPagePlayer:SetInCd(cd)
	self.animclickcd = true
	if cd then
		self.inst:DoTaskInTime(cd,function()
			self.animclickcd = false
		end)
	end
end


local emote_anim = {
	monkey_king = "emote_impatient",
	neza = "emote_fistshake",
	yangjian = "emoteXL_waving4",
}


local white_bone_skins ={
	white_bone_none = {'white_bone_beautiful','white_bone'},
	white_bone_white = {'white_bone_beautiful' ,'white_bone_white'},
	white_bone_opera = {'white_bone_opera_beautiful' ,'white_bone_opera'},
}
function MythbookPagePlayer:OnClickAnim()
	if self.animclickcd then
		return
	end
	if self.playeranim =="white_bone" and white_bone_skins[self.currentskin] ~= nil  then
		if self.npcnaim.animstate:GetBuild() == white_bone_skins[self.currentskin][1] then
			self.npcnaim.animstate:SetBuild(white_bone_skins[self.currentskin][2])
		else
			self.npcnaim.animstate:SetBuild(white_bone_skins[self.currentskin][1])
		end
	elseif self.playeranim =="yama_commissioners"   then
		if self.npcnaim.animstate:GetBuild() == "commissioner_black" then
			self.npcnaim.animstate:PlayAnimation("switch_balck_myth")
			self.npcnaim.animstate:PushAnimation("idle_loop")
			self.inst:DoTaskInTime(20*FRAMES,function()
				self.npcnaim.animstate:SetBuild("commissioner_white")
			end)
		else
			self.npcnaim.animstate:PlayAnimation("switch_white_myth")
			self.npcnaim.animstate:PushAnimation("idle_loop")
			self.inst:DoTaskInTime(20*FRAMES,function()
				self.npcnaim.animstate:SetBuild("commissioner_black")
			end)
		end
		self:SetInCd(2)
	elseif self.playeranim =="myth_yutu" then
		if self.npcnaim.animstate:IsCurrentAnimation("emote_loop_sit2") then
			self.npcnaim.animstate:PushAnimation("idle_loop", true)	
		else
			self.npcnaim.animstate:PlayAnimation("emote_pre_sit2")
			self.npcnaim.animstate:PushAnimation("emote_loop_sit2", true)
		end
		self:SetInCd(2)
	elseif self.playeranim =="pigsy" then
		if self.npcnaim.animstate:IsCurrentAnimation("sleep_loop") then
			self.npcnaim.animstate:PlayAnimation("wakeup")
			self.npcnaim.animstate:PushAnimation("idle_loop", true)
		else
			self.npcnaim.animstate:PlayAnimation("yawn")
			self.npcnaim.animstate:PushAnimation("insomniac_dozy",false)
			self.npcnaim.animstate:PushAnimation("sleep_loop")
		end
		self:SetInCd(4)
	elseif not self.animclickcd and emote_anim[self.playeranim]  then
		self.npcnaim.animstate:PlayAnimation(emote_anim[self.playeranim])
		self.npcnaim.animstate:PushAnimation("idle_loop", true)		
		self.animclickcd = true
		self:SetInCd(2)
	end
end

local my_spacing = {
	[5] = 88,
	[6] = 72,
	[7] = 65,
}
function MythbookPagePlayer:PoopData(data,name)
	self.details_root:KillAllChildren()
	local details_root = self.details_root
	local  y = 185
	local spacing = my_spacing[#data] or 65
	local jinengimage
	local jinengtext
	local cpoytext = details_root:AddChild(Text(HEADERFONT, 18))
	cpoytext:Hide()
	for i, v in ipairs(data) do
		jinengimage = details_root:AddChild(Image("images/myth_bookinfo.xml", name.."_info"..i..".tex"))
		jinengimage:SetPosition(-150,y)
		jinengimage:SetScale(0.8)

		jinengtext = details_root:AddChild(Text(HEADERFONT, ISVI and 14 or 18, v, DARKGREY))
		jinengtext:SetHAlign(ANCHOR_LEFT)
		jinengtext:SetRegionSize(270, 100)	
		jinengtext:EnableWordWrap(true)
		jinengtext:SetPosition(33, y)
		MakeDetailsLine(details_root, 28, y-30, .68)

		y = y - spacing
	end
end

local function BuildSkinSpinners(self,skins)
	local root = Widget("spinner_root")
	
	local top = 50
	local left = 0 -- -width/2 + 5

	local sort_options = {
	}

	for i, v in ipairs(skins) do
		table.insert(sort_options,{text = (i == 1 and STRINGS.UI.CRAFTING.DEFAULT  or STRINGS.SKIN_NAMES[v]),data = v})
	end
	local function on_sort_fn(data)
		local tex = "_oval.tex"
		local skin_data = GetSkinData(data)
		if skin_data ~= nil and skin_data.skins then
			self.npcnaim.animstate:SetBuild(skin_data.skins.normal_skin)
		end
		self.bigportraits:SetTexture("bigportraits/"..data..".xml", data..tex)

		if SKIN_RARITY_COLORS[string.upper(data)] ~= nil then
			self._skins.spinnersskins[1]:SetTextColour(unpack(SKIN_RARITY_COLORS[string.upper(data)]))
		end
		self.currentskin = data
	end

	local width_label = 120
	local width_spinner = 120
	local height = 25

	local function MakeSpinner(labeltext, spinnerdata, onchanged_fn, initial_data)
		local spacing = 5
		local font = NUMBERFONT
		local font_size = 25

		local total_width = width_label + width_spinner + spacing
		local wdg = Widget("labelspinner")
		local lean = true
		wdg.spinner = wdg:AddChild(Spinner(spinnerdata, width_spinner, height, {font = font, size = font_size}, nil, "images/myth_bookinfo.xml", nil, lean))
		--wdg.spinner:SetTextColour(UICOLOURS.BROWN_DARK)
		wdg.spinner:SetOnChangedFn(onchanged_fn)
		wdg.spinner:SetPosition((total_width/2)-(width_spinner/2), 12)
		wdg.spinner:SetSelected(initial_data)

		return wdg
	end
	local items = {}
	--排序
	table.insert(items, MakeSpinner("", sort_options, on_sort_fn, sort_options[1]))
	
	self._skins.spinnersskins ={}
	for i, v in ipairs(items) do
		local w = root:AddChild(v)
		w:SetPosition(0, (#items - i + 1)*(height + 3))
		table.insert(self._skins.spinnersskins , w.spinner)
	end
	
	return root
end

function MythbookPagePlayer:Updatedata(data)
	self.playeranim = data.names
	self.animclickcd = false
	self.currentskin = data.names.."_none"
	self.npcnaim.animstate:PlayAnimation("idle_loop",true)
	self.names:SetTexture("images/names_"..data.names..".xml", data.names..".tex")
	local tex = "_none_oval.tex"
	self.bigportraits:SetTexture("bigportraits/"..data.names.."_none.xml", data.names..tex)
	self.food:SetTexture("images/myth_bookinfo.xml", "food_"..data.names..".tex")

	for k, v in pairs(self.sanwei) do 
		self.sanwei[k].currentnum:SetString(TUNING[string.upper(data.names.."_"..k)] or "N/A")
	end
	self.character_titles:SetString(STRINGS.CHARACTER_TITLES[data.names] or "特殊人物")

	if STRINGS.CHARACTER_DESCRIPTIONS[data.names] ~= nil then
		self.character_descriptions:SetString(STRINGS.CHARACTER_DESCRIPTIONS[data.names])
		local _, msg_h = self.character_descriptions:GetRegionSize()
		self.character_descriptions:SetPosition(155, -50-msg_h/2)
	end

	self._skins:KillAllChildren()
	if data.skins ~= nil then
		local spinner_skin = self._skins:AddChild(BuildSkinSpinners(self,data.skins))
		spinner_skin:SetPosition(-100, -110)
		spinner_skin:SetScale(0.9)
	end

	--startitem
	local title_w, title_h = 0,102
	self._invitems:KillAllChildren()

	local inv_item_list = (TUNING.GAMEMODE_STARTING_ITEMS[TheNet:GetServerGameMode()] or TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT)[string.upper(data.names)]
	if inv_item_list ~= nil and #inv_item_list > 0 then
		local inv_items, item_count = {}, {}
		for _, v in ipairs(inv_item_list) do
			if item_count[v] == nil then
				item_count[v] = 1
				table.insert(inv_items, v)
			else
				item_count[v] = item_count[v] + 1
			end
		end
		local scale = 0.5
		local spacing = 5
		local slot_width, total_width, x

		for i = 1, 4 do
			local item = inv_items[i]
			local slot = self._invitems:AddChild(Image("images/hud.xml", "inv_slot.tex"))

			if item ~= nil then
				local override_item_image = TUNING.STARTING_ITEM_IMAGE_OVERRIDE[item]
				local atlas = override_item_image ~= nil and override_item_image.atlas or GetInventoryItemAtlas(item..".tex", true)
				if atlas ~= nil then
					local image = override_item_image ~= nil and override_item_image.image or (item..".tex")
					slot:AddChild(Image(atlas, image)):SetScale(0.9)
				end
			end
			slot:SetScale(scale)
			if slot_width == nil then
				slot_width = 68 * scale
				total_width = (slot_width * 2 + spacing * (2 - 1))
				x = (-total_width/2 + slot_width/2)
			end
			slot:SetPosition(x -80, -(title_h + spacing + slot_width/2))
			x = x + slot_width + spacing
		end
	end	
	local skin_data = GetSkinData(data.names.."_none")
	if skin_data ~= nil and skin_data.skins then
		self.npcnaim.animstate:SetBuild(skin_data.skins.normal_skin)
	end

	if data.miaoshu ~= nil then
		self:PoopData(data.miaoshu,data.names)
	end
end

function MythbookPagePlayer:BuildSkinSpinners()
	local root = Widget("spinner_root")
	
	local top = 50
	local left = 0 -- -width/2 + 5

	local sort_options = {

	}

	for i, v in ipairs(playerinfo) do
		table.insert(sort_options,{text = v[1],data = v[2]})
	end
	local function on_sort_fn(data)
		self:Updatedata(data)
		MYTH_BOOKINFO_PAGES.RENWU = self.spinners[1]:GetSelectedIndex()
	end

	local width_label = 120
	local width_spinner = 430
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

		wdg.spinner:SetSelectedIndex(MYTH_BOOKINFO_PAGES.RENWU)
		return wdg
	end

	local items = {}
	--排序
	table.insert(items, MakeSpinner("", sort_options, on_sort_fn, sort_options[MYTH_BOOKINFO_PAGES.RENWU]))
	
	self.spinners = {}
	for i, v in ipairs(items) do
		local w = root:AddChild(v)
		w:SetPosition(0, (#items - i + 1)*(height + 3))
		table.insert(self.spinners, w.spinner)
	end
	
	return root
end

return MythbookPagePlayer

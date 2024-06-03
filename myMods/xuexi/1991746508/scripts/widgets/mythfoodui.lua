local Widget = require "widgets/widget"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local Grid = require "widgets/grid"
local Spinner = require "widgets/spinner"

local TEMPLATES = require "widgets/redux/templates"
local function MakeDetailsLine(self, x, y, scale, image_override)
	local value_title_line = self:AddChild(Image("images/quagmire_recipebook.xml", image_override or "quagmire_recipe_line.tex"))
	value_title_line:SetScale(scale, scale)
	value_title_line:SetPosition(x, y)
end

--local L = MK_MOD_LANGUAGE_SETTING
local des = {"特殊作用","天","不会腐烂","配方","禁忌","未知","无","S"}
--if L then
--	des = {"特殊作用","天","不会腐烂","配方","禁忌","未知","无","S"}
--else
--	des = {"特殊作用","天","不会腐烂","配方","禁忌","未知","无","秒"}
--end

--摘自风铃

local ui = Class(Widget, function(self,data,parent,top,left)
    Widget._ctor(self, "details_root")
	local y = top - 11
	local image_size = 110
	local name_font_size = 34
	local title_font_size = 18 --22
	local body_font_size = 16 --18
	local value_title_font_size = 18
	local value_body_font_size = 16
	y = y - name_font_size/2
	local title = self:AddChild(Text(HEADERFONT, name_font_size, data.name, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y)
	y = y - name_font_size/2 - 4
	MakeDetailsLine(self, 0, y-10, -.55, "quagmire_recipe_line_break.tex")
	y = y - 30

	local icon_size = image_size - 20

	local frame = self:AddChild(Image("images/quagmire_recipebook.xml", "cookbook_known.tex"))
	frame:ScaleToSize(image_size, image_size)
	y = y - image_size/2
	frame:SetPosition(left + image_size/2 + 30, y)
	y = y - image_size/2

	local portrait_root = self:AddChild(Widget("portrait_root"))
	portrait_root:SetPosition(frame:GetPosition())

	--local food_img = portrait_root:AddChild(Image("images/inventoryimages/"..data.recipe_def.name..".xml", data.recipe_def.name..".tex"))
	--food_img:ScaleToSize(icon_size, icon_size)
	local food_img = portrait_root:AddChild(Image(data.food_atlas, not data.unlocked and "cookbook_unknown.tex" or data.food_tex))
	food_img:ScaleToSize(icon_size, icon_size)
		
	local details_x = 60
	local details_y = y + 85
    local status_scale = 0.7

	local health = data.recipe_def.health ~= nil and math.floor(10*data.recipe_def.health)/10 or nil
	self.health_status = self:AddChild(TEMPLATES.MakeUIStatusBadge((health ~= nil and health >= 0) and "health" or "health_bad"))
	self.health_status:SetPosition(details_x-60, details_y)
	self.health_status.status_value:SetString(health or STRINGS.UI.COOKBOOK.STAT_UNKNOWN)
	self.health_status:SetScale(status_scale)

	local hunger = data.recipe_def.hunger ~= nil and math.floor(10*data.recipe_def.hunger)/10 or nil
	self.hunger_status = self:AddChild(TEMPLATES.MakeUIStatusBadge((hunger ~= nil and hunger >= 0) and "hunger" or "hunger_bad"))
	self.hunger_status:SetPosition(details_x, details_y)
	self.hunger_status.status_value:SetString(hunger or STRINGS.UI.COOKBOOK.STAT_UNKNOWN)
	self.hunger_status:SetScale(status_scale)

	local sanity = data.recipe_def.sanity ~= nil and math.floor(10*data.recipe_def.sanity)/10 or nil
	self.sanity_status = self:AddChild(TEMPLATES.MakeUIStatusBadge((sanity ~= nil and sanity >= 0) and "sanity" or "sanity_bad"))
	self.sanity_status:SetPosition(details_x+60, details_y)
	self.sanity_status.status_value:SetString(sanity or STRINGS.UI.COOKBOOK.STAT_UNKNOWN)
	self.sanity_status:SetScale(status_scale)

	details_y = details_y - 42

	-- Side Effects
	local effects_str = parent:_GetSideEffectString(data.recipe_def)
	if effects_str then
		details_y = details_y - value_title_font_size/2+5
		title = self:AddChild(Text(HEADERFONT, value_title_font_size, des[1], UICOLOURS.BROWN_DARK))
		title:SetPosition(details_x, details_y)
		details_y = details_y - value_title_font_size/2
		MakeDetailsLine(self, details_x, details_y - 2, .5, "quagmire_recipe_line_short.tex")
		details_y = details_y - 8
		details_y = details_y - value_body_font_size/2
		local effects = self:AddChild(Text(HEADERFONT, value_body_font_size, "", UICOLOURS.BROWN_DARK))
		effects:SetMultilineTruncatedString(effects_str, 1, 190, nil, "...")
		effects:SetPosition(details_x, details_y)
		details_y = details_y - value_body_font_size/2 - 4
	end

	y = y - 12
	local row_start_y = y
	local column_offset_x = -100

	-- Food Type
	y = y - title_font_size/2
	title = self:AddChild(Text(HEADERFONT, title_font_size, STRINGS.UI.COOKBOOK.FOOD_TYPE_TITLE, UICOLOURS.BROWN_DARK))
	title:SetPosition(column_offset_x, y)
	y = y - title_font_size/2
	MakeDetailsLine(self, column_offset_x, y - 2, .3, "quagmire_recipe_line_veryshort.tex")
	y = y - 8
	y = y - body_font_size/2
	local str = STRINGS.UI.FOOD_TYPES[data.recipe_def.foodtype or FOODTYPE.GENERIC]  or STRINGS.UI.COOKBOOK.FOOD_TYPE_UNKNOWN
	local tags = self:AddChild(Text(HEADERFONT, body_font_size, str, UICOLOURS.BROWN_DARK))
	tags:SetPosition(column_offset_x, y)
	y = y - body_font_size/2 - 4

    column_offset_x = 0
	y = row_start_y

	-- Perish Rate
	y = y - title_font_size/2
	title = self:AddChild(Text(HEADERFONT, title_font_size, STRINGS.UI.COOKBOOK.PERISH_RATE_TITLE, UICOLOURS.BROWN_DARK))
	title:SetPosition(column_offset_x, y)
	y = y - title_font_size/2
	MakeDetailsLine(self, column_offset_x, y - 2, .3, "quagmire_recipe_line_veryshort.tex")
	y = y - 8
	y = y - body_font_size/2
	local str = data.recipe_def.perishtime ~= nil and string.format("%.f",(data.recipe_def.perishtime/480))..des[2] or des[3]
	local tags = self:AddChild(Text(HEADERFONT, body_font_size, str, UICOLOURS.BROWN_DARK))
	tags:SetPosition(column_offset_x, y)
	y = y - body_font_size/2 - 4

	column_offset_x = 100
    y = row_start_y

    
	-- Cooking Time
	y = y - title_font_size/2
	title = self:AddChild(Text(HEADERFONT, title_font_size, STRINGS.UI.COOKBOOK.COOKINGTIME_TITLE, UICOLOURS.BROWN_DARK))
	title:SetPosition(column_offset_x, y)
	y = y - title_font_size/2
	MakeDetailsLine(self, column_offset_x, y - 2, .3, "quagmire_recipe_line_veryshort.tex")
	y = y - 8
	y = y - body_font_size/2 -- 4
	local str = des[6]
    if data.recipe_def.cooktime then
        str = string.format("%.f",data.recipe_def.cooktime * 20 * 0.8)..des[8]
    end
    
	local tags = self:AddChild(Text(HEADERFONT, body_font_size, str, UICOLOURS.BROWN_DARK))
	tags:SetPosition(column_offset_x, y)
	y = y - body_font_size/2 - 4

    y = y -10
    self:AddChild(Text(HEADERFONT, title_font_size, des[4], UICOLOURS.BROWN_DARK)):SetPosition(-80, y)
    self:AddChild(Text(HEADERFONT, title_font_size, des[5], UICOLOURS.BROWN_DARK)):SetPosition(80, y)
    MakeDetailsLine(self, -80, y - 7, .5, "quagmire_recipe_line_veryshort.tex")
    MakeDetailsLine(self, 80, y - 7, .5, "quagmire_recipe_line_veryshort.tex")
    self:AddChild(Text(HEADERFONT, body_font_size*1.2, data.recipe_def.cook_need or des[6], UICOLOURS.BROWN_DARK)):SetPosition(-80, y-20)
    self:AddChild(Text(HEADERFONT, body_font_size*1.2, data.recipe_def.cook_cant or des[7] , UICOLOURS.BROWN_DARK)):SetPosition(80, y-20)
	
    y = y - 40
    -- INGREDIENTS
	y = y - title_font_size/2
	title = self:AddChild(Text(HEADERFONT, title_font_size, STRINGS.UI.RECIPE_BOOK.DETAILS_LABEL_RECIPES, UICOLOURS.BROWN_DARK))
	title:SetPosition(0, y)
	y = y - title_font_size/2
	MakeDetailsLine(self, 0, y - 2, .49)
	y = y - 10
    if data.recipes and #data.recipes > 0 then
        parent:_SetupRecipeIngredientDetails(data.recipes, self, y)
    end
end)


return ui

local Widget = require "widgets/widget" --Widget，所有widget的祖先类
local Text = require "widgets/text" --Text类，文本处理
local Image = require "widgets/image" -- Image图片
local ImageButton = require "widgets/imagebutton" -- ImageButton 图片按钮
local TextButton = require "widgets/textbutton" -- 文字按钮
local ScrollableList = require "widgets/scrollablelist" --滚动条

local introduceFn = require 'widgets/B001/chh_B001_introduceFn' --拆解一部分函数 避免文件行数过多

local MainProgram = Class(Widget,function(self,player) --第一个参数是父类，第二个参数是构造函数
	Widget._ctor(self,'chh_B001') --这一句必须写在构造函数的第一行，否则会报错。
	self.interface = self:AddChild(Widget('chh_B001'))

	self.interface.promptIcon = self:AddChild(ImageButton(TUNING.CHHDATA.B001.UI.ASSET..'huishou.xml','huishou.tex'))
	self.interface.promptIcon:SetPosition(100, 450) --设置偏移位置 左负上正
	self.interface.promptIcon:SetHoverText("菜菜的专属Mod",{wordwrap=true,font_size=20,bg=false,region_h=50,})
	self.interface.promptIcon:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
    self.interface.promptIcon:SetVAnchor(2) -- 中上下
	
	self.interface.promptIcon.OnControl = function(self2, control, down) --点击后触发的事件
        if not down then
            if control == 29 then self.interface.operationInterface:Show()  -- 设置information下的operationInterface为显示
			elseif control == 1 then self.interface.operationInterface:Hide() end -- 设置information下的operationInterface为隐藏
        end
    end
	-- 图标随着鼠标点击跟随拖拽
	self.interface.promptIcon.OnMouseButton = function(text, button, down, x, y, z, a, b, c)
        print("点击状态-------", text, button, down, x, y, z, a, b, c)
        if button == MOUSEBUTTON_LEFT and down then
            self.interface.promptIcon:FollowMouse() -- 判断鼠标按下时开启控件的鼠标跟随 需要默认屏幕x左 y下不然会偏移
        else
            self.interface.promptIcon:StopFollowMouse() -- 判断鼠标松开时，停止控件的跟随
            self.interface.promptIcon:SetPosition(TheInput:GetScreenPosition()) -- 并把当前鼠标的位置坐标设置成控件的坐标
        end
    end
	----------------------------主界面1----------------------------
	self.interface.operationInterface = self:AddChild(Image(TUNING.CHHDATA.B001.UI.ASSET..'operationInterface.xml','operationInterface.tex'))
	local operationInterface = self.interface.operationInterface
	local rootButTex = {} local showText = {} -- components按钮对象
	operationInterface:SetPosition(0, 0)
	operationInterface:Hide()
	operationInterface:SetScale(1.2,1.1,1.1)
-- operationInterface:SetScale(0.5,0.5,0.5)
	---关闭按钮
	operationInterface.close = operationInterface:AddChild(ImageButton(TUNING.CHHDATA.B001.UI.PUBLIC..'chh_close.xml','chh_close.tex'))
	operationInterface.close:SetPosition(240, 320)
	operationInterface.close:SetScale(0.8,0.8,0.8)
	operationInterface.close.OnControl = function(self, control, down) -- down为true是按下 down为false是弹起  一共触发俩次
		if not down then
			operationInterface:Hide()
		end			
	end
	---顶部-文字介绍 introduce
	operationInterface.introduce = operationInterface:AddChild(Text(TITLEFONT,40,"这是纯文本")) --(self, font, size, text, colour)
	operationInterface.introduce:SetPosition(-370, 340)
	operationInterface.introduce:SetHAlign(ANCHOR_LEFT) --左对齐
	operationInterface.introduce:SetVAlign(ANCHOR_TOP) --左对齐
	---获取预设按钮的大界面(鼠标移入然后触发 接收物品的效果)
	operationInterface.getPresetsButton = operationInterface:AddChild(ImageButton(TUNING.CHHDATA.B001.UI.ASSET..'chh_allBlack.xml','chh_allBlack.tex'))
	operationInterface.getPresetsButton:SetPosition(-5, -10) --偏移
	operationInterface.getPresetsButton:SetScale(5.35,5,5)--设置大小
	operationInterface.getPresetsButton.scale_on_focus = false --鼠标移入的时候不会放大图片了
	operationInterface.getPresetsButton.move_on_click = false --鼠标点击后不会有下降的效果了
	operationInterface.getPresetsButton:SetFadeAlpha(0.5, nil) ----设置透明度【参数2，为nil时，子体同步设置】
	operationInterface.getPresetsButton.OnControl = function(self, control, down) -- down为true是按下 down为false是弹起  一共触发俩次
		introduceFn.getPresetsButton_OnControl(self, control, down, operationInterface)
	end
	---文字按钮-预览
	operationInterface.preview = operationInterface:AddChild(TextButton()) -- (self, name)
	operationInterface.preview.text:SetHAlign(ANCHOR_LEFT) --左对齐 注意 这里的文字按钮里面多个text‘
	operationInterface.preview:SetPosition(210, 220) --偏移
	operationInterface.preview:SetFont(NEWFONT) --设置字体
	operationInterface.preview:SetTextSize(45) --文字大小
	operationInterface.preview:SetText("预览") --文本设置
	operationInterface.preview:SetTextColour({237/255,155/255,155/255,0.8})--设置文字按钮颜色和透明度 不写默认为淡灰黄
	operationInterface.preview:SetTextFocusColour({255/255,0/255,0/255,0.7}) --鼠标移入文字按钮时候的颜色和透明度 不写默认为白色
	operationInterface.preview:SetOnClick(function() --点击触发
        print('点击了预览文字按钮')
    end)
	-------------物品信息之类的 全丢 leftInfobar 里了-------------
	-- local leftInfobar = operationInterface.leftInfobar
	---左侧的预设物图片显示
	operationInterface.PrefabImg = operationInterface:AddChild(Image('images/inventoryimages.xml','axe.tex'))
	operationInterface.PrefabImg:SetPosition(-380, 190) --偏移
	operationInterface.PrefabImg:SetScale(2,2,2)--设置大小
	---左侧的预设物介绍显示
	-- operationInterface.PrefabText = operationInterface:AddChild(Text(UIFONT, 35, 'XXXXX'))
	-- operationInterface.PrefabText:SetPosition(0, 0)
	-- operationInterface.PrefabText:SetHAlign(0) --居中
	-- operationInterface.PrefabText:SetVAlign(1) --左对齐
	-- operationInterface.PrefabText:SetColour({ 255/255, 255/255, 255/255, 1 })

end)
-- local Button = require "widgets/button" -- 按钮
-- Button.textcolour = {255/255,0/255,	0/255,1}
return MainProgram
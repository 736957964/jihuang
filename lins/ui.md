>   图像界面随笔
## ui模块
```lua 
Assets = {
	Asset("ATLAS", "images/009/huishou.xml"),
	Asset("IMAGE","images/009/huishou.tex" ),
}
----图形用户界面---- https://www.zybuluo.com/longfei/note/603075
----部分来自 青木字典
--两个大类 Widget和Screen  Widget是用于界面上的小组件  Screen则是一整个界面 一个Screen里可以包含多个widget，一个widget也可以内含许多widget
---------------在widgets文件夹创建一个introduce
local Widget = require "widgets/widget" --Widget，所有widget的祖先类
local Text = require "widgets/text" --Text类，文本处理 --(self, font, size, text, colour)
local TextButton = require "widgets/textbutton" --Text按钮 (self, name)
local Image = require "widgets/image" -- Image图片
local ImageButton = require "widgets/imagebutton" -- ImageButton 图片按钮  ImageButton.text可用Text类函数
local TextEdit = require 'widgets/textedit'  -- TextEdit 输入框
local ListCursor = require 'widgets/listcursor'  -- 列表游标
local TrueScrollList = require "widgets/truescrolllist"
local ScrollableList = require "widgets/scrollablelist"
local UIAnim = require "widgets/uianim" -- 动画
local TEMPLATES = require "widgets/redux/templates" --模板文件
--TextButton 文字按钮----ListCursor 列表游标，和拖动条联合使用,常用场景为服务器列表----AnimButton 动画按钮-----UIAnimButton 界面动画按钮----
--HungerBadge 饥饿指示器----SanityBadge 精神指示器----HealthBadge 血量指示器-----BeaverBadge 木头值指示器---- SetPercent(val, max) 设置动画播放的百分比。
local Introduce = Class(Widget, function(self, owner) -- 这里定义了一个Class，第一个参数是父类，第二个参数是构造函数，函数的参数第一个固定为self，后面的参数可以不写，也可以自定义
    --这表明调用父类的构造函数（此处是Widget，如果继承Text，则应该写Text._ctor），第一个参数是固定的self，后面的参数同这个父类的构造函数的参数，此处写的是Widget的名字
   Widget._ctor(self, "Introduce") --这一句必须写在构造函数的第一行，否则会报错。
   self.text = self:AddChild(Text(BODYTEXTFONT, 130,"sb Klei")) --添加一个文本变量，接收Text实例
   ------例子------
   self.interface = self:AddChild(Widget("interface")) --创建一个总界面
   --在总界面下设置一个参数 为 图片类按钮 导入图片xml和tex(不要忘记用Assets注册图片) 	Assets = {Asset( "IMAGE", "images/XXXXX.tex" ),Asset( "ATLAS", "images/XXXXX.xml" ) }
   self.interface.promptIcon= self:AddChild(ImageButton("images/XXXXX.xml","XXXXX.tex")) --按钮类图片
   self.interface.promptIcon:SetPosition(-800, 630) --设置偏移位置 左负上正
   self.interface.promptIcon:SetHoverText("鼠标移入提示的信息",{wordwrap=true,font_size=19,bg=false,region_h=100,})
   ImageButton.scale_on_focus = false --鼠标移入的时候不会放大图片了
   ImageButton.move_on_click = false --鼠标点击后不会有下降的效果了
   ImageButton:SetFadeAlpha(0.5, nil) ----设置透明度【参数2，为nil时，子体同步设置】
   ImageButton:AddChild(ImageButton.hovertext) --设置移动显示的文字跟随imagebutton变大
   self.interface.promptIcon.OnControl = function(self, control, down) --点击后触发的事件
        if not down then
            if control == 29 then self.jnjm:Show()  -- 设置information下的jnjm为显示
            elseif control == 1 then self.jnjm:Hide() end -- 设置information下的jnjm为隐藏
        end
    end
    Widget:IsDeepestFocus()	--是否被指针聚焦【如果焦点在子实体上，返回false】返回值true
    Widget:OnMouseButton(button, down, x, y)--在被点击时候调用
    Widget:MoveToBack()	    Widget:MoveToFront()--搬到底层   --搬到前段
    Widget:OnFocusMove(dir, down)	Widget:OnRawKey(key, down)--在被指针聚焦时调用   --在被聚焦时候，按键行为fn
    Widget:IsVisible()	Widget:OnTextInput(text)	--是否为显示状态    --在被输入字符串时候调用
    Widget:ScaleTo(from, to, time, fn)	--变换大小【动画】【指定从大小，变换到大小，时间，完成后调用【可nil】】
    Widget:MoveTo(from, to, time, fn)	--移动位置【动画】【指定从位置，移动到位置，时间，完成后调用【可nil】】
    Widget:CancelMoveTo(run_complete_fn)    Widget:TintTo(from, to, time, fn)--|取消移动【可nil】    --变换颜色【动画】
    Widget:ForceStartWallUpdating() Widget:ForceStopWallUpdating()--强制启动动画完成之前的设定	   --强制停止动画效果
    Widget:GetParent()	Widget:GetChildren() --获取父体    --获取子表 返回 {}
    Widget:RemoveChild(child) Widget:KillAllChildren() Widget:AddChild(child)--删除指定子体    --删除全部子体   --增加指定子体
    Widget:Hide()	Widget:OnHide()  Widget:Show()--实体显示   --在实体被显示时候调用   --实体隐藏
    Widget:OnShow()	Widget:Kill()--在实体被隐藏时候调用    	--删除自己
    Widget:GetWorldPosition() 	Widget:Nudge(offset) --获取在世界上的坐标	   --在现有偏移坐标上 + offset坐标
    Widget:GetPosition() Widget:GetLocalPosition()--获取被附加后的偏移坐标   --获取被附加后的偏移坐标【同上，函数功能一模一样】
    Widget:SetPosition(pos, y, z)	Widget:UpdatePosition(x, y)--设置坐标   --设置坐标【同上】
    Widget:SetRotation(angle) Widget:SetScaleMode(mode)--设置旋转   --设置缩放模式【0原始	1满屏	2均衡	3固定比例	4非动态】
    Widget:SetVAnchor(anchor) Widget:SetHAnchor(anchor)--设置位置【上下便宜  0居中,1顶对齐,2底对齐】     --设置位置【左右偏移  0居中,1左对齐,2右对其】
    Widget:SetScale(pos, y, z) Widget:HookCallback(event, fn)--设置大小比例【0-1】   --设置监听事件【self.callbacks[event] = fn】
    Widget:StartUpdating() Widget:StopUpdating()--开启循环更新【:OnUpdate(dt)】  --停止循环更新【:OnUpdate(dt)】
    Widget:SetFadeAlpha(alpha, skipChildren)--设置透明度【参数2，为nil时，子体同步设置】
    Widget:SetCanFadeAlpha(fade, skipChildren)--设置可以被调整透明度【true or false ，true or nil，为nil时，子体同步设置】
    Widget:SetClickable(val)--设置可否被点击【true or false】
    Widget:SetOnClick(function() end)--被点击时调用 实际是OnControl里面的小分支
    Widget:FollowMouse() Widget:StopFollowMouse()--开启跟随指针   --停止跟随指针
    Widget:GetScale()	Widget:GetLooseScale()--获得大小比例【优先获取父体】   --获取大小比例【自己】
    Widget:GetDeepestFocus() Widget:GetFocusChild()--获取被指针聚焦的实体【优先级：子体】   --获取被指针聚焦的实体【子体】
    Widget:ClearFocus()	--取消被聚焦状态【调用self:OnLoseFocus() 和 self.onlosefocusfn()】
    Widget:SetFocus()--设置聚焦状态【调用self:OnGainFocus() 和 self.ongainfocusfn()】
    Widget:SetHoverText(text, params)--设置指针悬停信息
	Widget:SetOnGainFocus( fn ) --获取焦点的时候触发函数
	Widget:SetOnLoseFocus( fn ) --失去焦点的时候触发函数

    self.interface.promptIcon.IMG = self:AddChild(Image("images/XXX.xml","XXX.tex")) --设定了一张图片
    self.interface.promptIcon.IMG:SetPosition(0, 0)  self.interface.promptIcon.IMG:Hide() --不进行偏移 -- 默认是隐藏的
    self.interface.promptIcon.IMG:SetScale(0.5,0.5,0.5)  -- 设置图片的大小
	Image:SetTint(0, 0, 0, 0)
	----------------------------------------------Image-------------------------------------------------------
	self:AddChild(Image("images/textboxes.xml", "textbox_long.tex") )
	Image:SetAlphaRange(min, max) --设置可以被透明的最小和最大值
	Image:SetTexture("images/textboxes.xml", "textbox_long.tex")	--设定成像（切换图片）
	Image:SetMouseOverTexture(atlas, tex)--设置指针悬停时的图像
	Image:SetDisabledTexture(atlas, tex)--设置禁用时的图像
	Image:SetSize(w,h)--设置图像大小比例
	Image:GetSize()	--获取图像大小比例
	Image:ScaleToSize(w, h)	--按设定像素 / 原始大小比例
	Image:SetTint(r,g,b,a)--设置颜色覆盖
	Image:SetFadeAlpha(a, skipChildren) --设置透明度【参数2，为nil时，子体同步设置】
	Image:SetVRegPoint(anchor)
	Image:SetHRegPoint(anchor)
	Image:SetUVScale(xScale, yScale)
	Image:SetBlendMode(BLENDMODE.Additive)					--设置混合模式（0-6）

	XXXXX:Kill() --清除页面
    XXXXX:SetOnDown( function() end) -- 给XXXXX的图片按钮设置一个按钮弹起前的函数
    XXXXX:SetOnClick( function() end) -- 给XXXXX的图片按钮设置一个按钮弹起后的函数（这里可能需要用到rpg发送给服务器 具体看场景）
	-------------------------UIAnim-----------------------------
	self.bg = self:AddChild(UIAnim())
    self.bg:GetAnimState():SetBank("ui_construction_4x1")
    self.bg:GetAnimState():SetBuild("ui_construction_4x1")
	self.bg:GetAnimState():PlayAnimation("open", false) -- 播放动画

	npcnaim:GetAnimState():OverrideSymbol("snow", "fangcunhill", "emptysnow")


	------------------------------------------------------
	------------------------------------------------------

	----------------------------------------------Text-------------------------------------------------------
    self.interface.promptIcon.text:SetText("XXXXXXXXXXX") --给图片按钮设置XXXXXXXXXXX文字 如果报错 去掉text
    XXXXXXXXXXXXX:AddChild(Text(TITLEFONT,40,"文字显示")) --文字类导入 第一个参数为字体
    DEFAULTFONT	 DIALOGFONT--默认字体(小描边，字体和数字和符号自动转化全角)  --对话框字体
    TITLEFONT	UIFONT	BUTTONFONT	--标题字体 --界面字体 --按钮字体(无描边，数字比汉字高)
    NEWFONT	 NEWFONT_SMALL	 NEWFONT_OUTLINE NEWFONT_OUTLINE_SMALL--新字体(无描边)
    NUMBERFONT	TALKINGFONT	 --数字体(有描边) --小字体(有描边,数字略模糊)
    SMALLNUMBERFONT	 BODYTEXTFONT	CODEFONT
    -----如果需要对齐 name俩个文字都需要设置SetRegionSize
    Text:SetHAlign(ANCHOR_LEFT) --给文字类 设置左对齐 注意 真正的左对齐还需要设置范围 SetRegionSize(XX,X)
    Text:SetVAlign(ANCHOR_TOP) --给文字类 设置左对齐
    Text:SetColour(r, g, b, a)	--设置字体颜色
    Text:GetColour() --获取字体颜色 local r, g, b, a
    Text:SetHorizontalSqueeze(squeeze)	--挤压【0-1】  0是不显示了 1是正常 2的话宽度翻一倍
    Text:SetFadeAlpha(a, skipChildren)	--设置透明度【最后 * a】
    Text:SetAlpha(a)	--指定透明度
    Text:SetFont(font)	--设置字体库
    Text:SetSize(sz)	--设置字体大小
    Text:SetRegionSize(w,h)	--设置区域大小【像素级】
    Text:GetRegionSize()	--获取区域大小【没被指定时，会自动计算字符串总大小】
	Text:ResetRegionSize() --重置区域大小
    Text:SetString(str)		--设置显示字符串
    Text:GetString()	--获取被设置的字符串  返回 ""
    Text:SetTruncatedString(str, maxwidth, maxchars, ellipses) --设置最大字符串字数【字符串，最大区域长度，最大字数，true or "..."】
    Text:EnableWordWrap(enable)	--设置自动换行【true】
    Text:EnableWhitespaceWrap(enable)	--启用“空格换行” 【true】
	Text:SetMultilineTruncatedString(str, maxlines, maxwidth, maxcharsperline, ellipses, shrink_to_fit)--设置多行截断字符串

    ---文字按钮的一些参数
	----------------------------------------------TextButton-------------------------------------------------------
	operationInterface.preview = operationInterface:AddChild(TextButton()) -- (self, name)
	operationInterface.preview.text:SetHAlign(ANCHOR_LEFT) --左对齐 注意 这里的文字按钮里面多个text‘
	operationInterface.preview:SetPosition(0, 220) --偏移
	operationInterface.preview:SetFont(NEWFONT) --设置字体
	operationInterface.preview:SetTextSize(45) --文字大小
	operationInterface.preview:SetText("预览") --文本设置
	operationInterface.preview:SetTextColour({237/255,155/255,155/255,0.8})--设置文字按钮颜色和透明度 不写默认为淡灰黄
	operationInterface.preview:SetTextFocusColour({255/255,0/255,0/255,0.7}) --鼠标移入文字按钮时候的颜色和透明度 不写默认为白色
	operationInterface.preview:SetTextDisabledColour({0.5,0.5,0.5,1}) --禁用时候的颜色
    operationInterface.preview:SetTextSelectedColour({255/255,0/255,0/255,1})--选中时候的颜色？
    operationInterface.preview:SetOnClick(FN)--点击触发函数
    operationInterface.preview.scale_on_focus = false --鼠标移入的时候不会放大图片了
    operationInterface.preview.move_on_click = false --鼠标点击后不会有下降的效果了
	----------------------------------------------TextEdit 相关----------------------------------------------
	TextEdit = self.root:AddChild(TextEdit(BUTTONFONT, 50, ""))
	TextEdit:SetString("设置XX文字") -- 设置文字
	TextEdit:SetColour(0, 0, 0, 1) -- 设置文字颜色（初始进入的时候用的这个）
	TextEdit:SetEditCursorColour({255/255,255/255,255/255,1}) --设置编辑后闪动标颜色
	TextEdit.idle_text_color = {192/255,1/255,255/255,1}--粉 编辑结束后的颜色 实际SetColour通过这个参数设置
    TextEdit.edit_text_color = {1/255,255/255,234/255,1}--蓝 编辑开始时候的颜色
	TextEdit:SetForceEdit(true)
	TextEdit:SetPosition(0, 40, 0)
	TextEdit:SetRegionSize(430, 160) --输入框的大小 第一个参数为x,第二个参数为y 也就是代表多行
	TextEdit:SetHAlign(ANCHOR_LEFT)
	TextEdit:SetVAlign(ANCHOR_TOP)
	TextEdit:SetTextLengthLimit(MAX_WRITEABLE_LENGTH) --设置最大输入长度
	TextEdit:EnableWordWrap(true) -- 启动文字自动换行
	TextEdit:EnableWhitespaceWrap(true) --启用空格换行
	TextEdit:EnableRegionSizeLimit(true)--启用区域大小限制
	TextEdit:EnableScrollEditWindow(false)--关闭滚动编辑窗口
	local VALID_CHARS = [[0123456789]] -- [[ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,[]@!()'*+-/?{}" ]]
	TextEdit:SetCharacterFilter(VALID_CHARS) --限制输入的文字类型 也可以直接在里头输入 格式 "0123456789"
	------------ScrollableList-------下拉框滚动写法（供参考）------------------
	local rootButTex = {}
	for k=1,10,1 do -- 创建了10个按钮 放到了 下拉滚动条里（ScrollableList）
		rootButTex[k] = operationInterface:AddChild(ImageButton("images/global_redux.xml", "button_carny_xlong_normal.tex", "button_carny_xlong_hover.tex", "button_carny_xlong_disabled.tex", "button_carny_xlong_down.tex"))
		rootButTex[k]:SetText(string.format('数量%s',k))
		rootButTex[k].text:SetSize(30)
		rootButTex[k]:SetScale(0.5,0.5,0.5)
		rootButTex[k]:SetOnClick(function()
			print('dianji')
		end)
	end
	-- 第一个参数 为表一般情况放图片按钮 第二个参数为x的大小 第三个参数为y的大小  第四个参数为XX数据之间的间隔(项目高度) 第五个类似第四个 （项目填充）
	--6更新函数  7 未知  第八个参数为XX数据x偏移(整体的 第九 十 始终显示静态、起始偏移(不常用)
	--第十一个参数为XX数据y偏移位置(整体的)   第十二 三 比例 默认1  第十四为官方定义的 不写默认'BLACK' 可写'GOLD'
	operationInterface.componentsData = operationInterface:AddChild(ScrollableList(
	interface.shop_list, 500, 400, 38, 5,
	nil, nil, 200, nil, nil,
	-100, nil,nil,'GOLD'))
	local componentsData = operationInterface.componentsData
	componentsData:SetPosition(-380, -60)
	componentsData:LayOutStaticWidgets(25)
	componentsData:RecalculateStepSize() --重新计算（不加这个更新数据会不能滚动）
	componentsData:RefreshView()--刷新下拉框的数据
	componentsData:SetList(rootButTex,false,nil,nil) --可以删除原数据 更改列表并刷新 第三个参数设置0可以回到顶点
	ScrollableList:Scroll(0, true) --设置滚动条位置 （可以通过负的项目数量来回到顶部） 这里的项目数量是 #rootButTex
	ScrollableList:ScrollToEnd() --滚动条到最后
	ScrollableList:GetNumberOfItems() --获取项目数量
	------------------------------------------------------
    --人物出现后 开始更新ui （这里的人物是thePlayer传过来的）
	self.owner:DoTaskInTime(.2, function() self:StartUpdating() end)  --更新ui
end)
return Introduce
------------modmain.lua中---------
local Introduce = GLOBAL.require("widgets/introduce") --加载设定的introduce
---封装重复的代码 设置图标等比例变化
local function PositionUI(self, screensize)
    local hudscale = self.top_root:GetScale()  --获取屏幕大小比例(方便控制等比例变化)
    self.introduce:SetScale(0.55*hudscale.x,0.55*hudscale.y,1)
end
local function addIntroduceWidget(self)
    -- self:AddChild(Introduce()) 为controls添加 Introduce widget。
    self.introduce = self.top_root:AddChild(Introduce(ThePlayer)) --这里是为了ui界面自适应大屏幕所以写到了top_root下面 并且给了一个当前客户端玩家的传参
    self.introduce:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
    self.introduce:SetVAnchor(1) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
    self.introduce:SetPosition(70,-50,0) -- 设置introduce widget相对原点的偏移量，70，-50表明向右70，向下50，第三个参数无意义。
    self.introduce:MoveToFront()    --设置ui到上一层
    local screensize = {TheSim:GetScreenSize()} --获取屏幕大小（width,height）
    PositionUI(self, screensize)
    local old_OnUpdate = self.OnUpdate -- 获取更新函数
    self.OnUpdate = function(self, dt) --设置更新函数 在保持原有函数的情况添加新东西
        old_OnUpdate(self, dt)
        local curscreensize = { TheSim:GetScreenSize() }
        -- 这里旧的像素 对比了 新获取的像素 如果有变动 name就更新自己写的ui 然后新像素覆盖旧的
        if curscreensize[1] ~= screensize[1] or curscreensize[2] ~= screensize[2] then
            PositionUI(self, screensize)  screensize = curscreensize
        end
    end
	-- 图标随着鼠标点击跟随拖拽 方法一（原点设定为左下角）
	self.introduce.OnMouseButton = function(text, button, down, x, y, z, a, b, c)
        print("点击状态-------", text, button, down, x, y, z, a, b, c)
        if button == MOUSEBUTTON_LEFT and down then
            self.introduce:FollowMouse() -- 判断鼠标按下时开启控件的鼠标跟随 需要默认屏幕x左 y下不然会偏移
        else
            self.introduce:StopFollowMouse() -- 判断鼠标松开时，停止控件的跟随
            self.introduce:SetPosition(TheInput:GetScreenPosition()) -- 并把当前鼠标的位置坐标设置成控件的坐标
        end
    end
    -- 图标随着鼠标点击跟随拖拽 方法二（在没有设定原点的情况用这个）
    local promptIcon = self.interface.promptIcon
	local old_OnUpdate = promptIcon.OnUpdate -- 获取更新函数
	promptIcon.OnUpdate = function(_self, dt) --设置更新函数 在保持原有函数的情况添加新东西
		old_OnUpdate(_self, dt)
		local _pos  = (TheInput.GetScreenPosition() - self.interface:GetWorldPosition()) --鼠标当前位置 - 父级的当前世界位置
		local _scale = self.interface:GetScale() --获取父级的比例
		local posX = _pos.x/ _scale.x  local posY =  _pos.y/ _scale.y
		promptIcon:SetPosition(posX,posY)
		if not TheInput:IsMouseDown(MOUSEBUTTON_RIGHT) then --判定鼠标弹起
			promptIcon:StopUpdating() --停止更新
		end
	end
	promptIcon.OnMouseButton = function(text, button, down, x, y, z, a, b, c)
        print("点击状态-------", text, button, down, x, y, z, a, b, c)
        if button == MOUSEBUTTON_RIGHT and down then --鼠标右键
			promptIcon:StartUpdating() --开始更新
        end
    end
    --------------------------------------------------
end ]]
AddClassPostConstruct("widgets/controls", addIntroduceWidget) -- 这个函数是官方的MOD API，用于修改游戏中的类的构造函数。第一个参数是类的文件路径，根目录为scripts。第二个自定义的修改函数，第一个参数固定为self，指代要修改的类。
------------modmain.lua结束--------
```
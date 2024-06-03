local Widget = require "widgets/widget" --Widget，所有widget的祖先类
local Text = require "widgets/text" --Text类，文本处理
local Image = require "widgets/image" -- Image图片
local ImageButton = require "widgets/imagebutton" -- ImageButton 图片按钮
local TextButton = require "widgets/textbutton" -- 文字按钮
local ScrollableList = require "widgets/scrollablelist" --滚动条
local informationData = require('widgets/B003/B003_informationData')
local shopping = require('widgets/B003/B003_shopping')
local TextEdit = require 'widgets/textedit'  -- TextEdit 输入框
local ItemTile = require "widgets/itemtile" -- 物品栏
-------------
local chhEditText = require "widgets/B003/components/chh_auction14_editText" -- 自己创建的按钮

local function setTextEdit(TextEdit)
	--TextEdit:SetString("设置XX文字") -- 设置文字
	TextEdit:SetColour(0, 0, 0, 1) -- 设置文字颜色（初始进入的时候用的这个）
	TextEdit:SetEditCursorColour({255/255,255/255,255/255,1}) --设置编辑后闪动标颜色
	TextEdit.idle_text_color = {192/255,1/255,255/255,1}--粉 编辑结束后的颜色 实际SetColour通过这个参数设置
    TextEdit.edit_text_color = {153/255,51/255,51/255,1}--编辑开始时候的颜色
	TextEdit:SetForceEdit(true)
	TextEdit:SetPosition(0,-60)
	TextEdit:SetRegionSize(180, 80) --输入框的大小 第一个参数为x,第二个参数为y 也就是代表多行
	TextEdit:SetHAlign(ANCHOR_LEFT)
	TextEdit:SetVAlign(ANCHOR_TOP)
	TextEdit:SetTextLengthLimit(10) --设置最大输入长度
	TextEdit:EnableWordWrap(true) -- 启动文字自动换行
	TextEdit:EnableWhitespaceWrap(true) --启用空格换行
	TextEdit:EnableRegionSizeLimit(true)--启用区域大小限制
	TextEdit:EnableScrollEditWindow(false)--关闭滚动编辑窗口
	local VALID_CHARS = [[0123456789]] -- [[ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,[]@!()'*+-/?{}" ]]
	TextEdit:SetCharacterFilter(VALID_CHARS) --限制输入的文字类型 也可以直接在里头输入 格式 "0123456789"
end
-- 游览
local MainProgram = Class(Widget,function(self)
	local PATHUI = TUNING.CHHDATA.B003.UI
	Widget._ctor(self,'B003_information1') --这一句必须写在构造函数的第一行，否则会报错。
	self.interface = self:AddChild(Widget('B003_information1'))
	local interface = self.interface
	---------------------左侧管理
	interface.LeftData = interface:AddChild(Image())
	interface.LeftData:SetPosition(informationData.LeftDataPos) --统一拿其他文件的坐标 方便修改
	interface.RightData = interface:AddChild(Image())
	interface.RightData:SetPosition(informationData.RightDataPos) --统一拿其他文件的坐标 方便修改
	local LeftData,RightData = interface.LeftData,interface.RightData
	-- :AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_15.tex'))
	LeftData.pmText = LeftData:AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_20.tex'))
	LeftData.pmText:SetPosition(-45,0)
	LeftData.goodsBg = LeftData:AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_18.tex'))
	LeftData.goodsBg:SetPosition(0,-50)
	--输入价格 的统一由 price 管理
	LeftData.price = LeftData:AddChild(Image())
	local price = LeftData.price
	price:SetPosition(0,-90)
	price.priceBg1 = price:AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_17.tex')) --左输入框
	price.priceBg2 = price:AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_17.tex'))
	price.priceBtn1 = price:AddChild(ImageButton(PATHUI.ASSET..'chh_auction.xml','chh_auction_14.tex')) --右边的镜子按钮
	price.priceBtn2 = price:AddChild(ImageButton(PATHUI.ASSET..'chh_auction.xml','chh_auction_14.tex'))

	price.priceText1 = price:AddChild(Text(informationData.typeFace1,40,"起始价格")) -- 起始价格
	price.priceText2 = price:AddChild(Text(informationData.typeFace1,40,"一口价")) -- 一口价
	price.priceText1:SetHAlign(ANCHOR_LEFT) price.priceText1:SetVAlign(ANCHOR_TOP) price.priceText1:SetRegionSize(210,50)
	price.priceText2:SetHAlign(ANCHOR_LEFT) price.priceText2:SetVAlign(ANCHOR_TOP) price.priceText2:SetRegionSize(210,50)
	price.priceBg1:SetPosition(-20,-30) price.priceBg2:SetPosition(-20,-100+10)
	price.priceBtn1:SetPosition(100,-30+8) price.priceBtn2:SetPosition(100,-100+18) -- 10+8
	price.priceText1:SetPosition(0,-10) price.priceText2:SetPosition(0,-70)
	----输入价格----
	price.priceEditBg1 = price:AddChild(TextEdit(BUTTONFONT, 26, ""))
	price.priceEditBg2 = price:AddChild(TextEdit(BUTTONFONT, 26, ""))
	setTextEdit(price.priceEditBg1)
	setTextEdit(price.priceEditBg2)
	price.priceEditBg1:SetPosition(-12,-62)
	price.priceEditBg2:SetPosition(-12,-122)
	---物品栏框---
	tablePrint(self)
	price.ItemTile = price:AddChild(ItemTile(ThePlayer))
	price.ItemTile:SetPosition(-20,58)
	-------
	------时间按钮
	LeftData.setTime = LeftData:AddChild(Image())
	local setTime =LeftData.setTime
	setTime:SetScale(2.2,2.2,2.2)
	setTime:SetPosition(-80,-240)
	for k=1,4 do
		local setTimeName = setTime['setTime'..tostring(k)]
		setTimeName = setTime:AddChild(ImageButton(PATHUI.ASSET..'chh_auction.xml','chh_auction_3.tex'))
		if k <= 3 then
			setTimeName:SetPosition(33*(k-1),0)
		else
			setTimeName:SetPosition(33*(k-4),-25)
		end
		setTimeName:SetText(tostring(k*3)..'小时')
		setTimeName.text:SetSize(13)
	end
	setTime.zdyTime = setTime:AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_11.tex'))
	setTime.zdyTime:SetPosition(33,-25)
	setTime.zdyTime:SetScale(0.33,0.7,0.7)
	---开始拍卖按钮
	LeftData.startAuction = LeftData:AddChild(ImageButton(PATHUI.ASSET..'chh_auction.xml','chh_auction_24.tex'))
	local startAuction = LeftData.startAuction
	WidgetSetMouseOverAndOutImage(startAuction,PATHUI.ASSET..'chh_auction.xml','chh_auction_22.tex')
	startAuction:SetPosition(75,-320)
	-------------------------右侧管理-----------------
	RightData.bg = RightData:AddChild(shopping({1,2,3,1,2,3,1,2,3,3,1,2,3,3,1,2,3}))
end)

return MainProgram



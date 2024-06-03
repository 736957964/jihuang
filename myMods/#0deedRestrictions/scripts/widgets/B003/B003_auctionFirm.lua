local Widget = require "widgets/widget" --Widget，所有widget的祖先类
local Text = require "widgets/text" --Text类，文本处理
local Image = require "widgets/image" -- Image图片
local ImageButton = require "widgets/imagebutton" -- ImageButton 图片按钮
local TextButton = require "widgets/textbutton" -- 文字按钮
local ScrollableList = require "widgets/scrollablelist" --滚动条

local B003_information1 = require "widgets/B003/B003_information1"
local B003_information2 = require "widgets/B003/B003_information2"
local B003_information3 = require "widgets/B003/B003_information3"

local MainProgram = function(self)
	local PATHUI = TUNING.CHHDATA.B003.UI
	self.interface = self:AddChild(Widget('chh_B003'))

	self.interface.promptIcon = self.interface:AddChild(ImageButton(PATHUI.ASSET..'chh_auction.xml','chh_auction_15.tex'))
	self.interface.promptIcon:SetPosition(300, 300) --设置偏移位置 左负上正
	self.interface.promptIcon:SetScale(0.5, 0.5)
	self.interface.promptIcon:SetHoverText("拍卖商店(右键可挪动)",{wordwrap=true,font_size=80,bg=false,region_h=80,})
	self.interface.promptIcon:AddChild(self.interface.promptIcon.hovertext) --显示文字跟随
	self.interface.promptIcon.OnControl = function(_self, control, down) --点击后触发的事件
        if not down then
            if control == 29 then self.interface.operationInterface:Show()
			elseif control == 1 then self.interface.operationInterface:Hide()
			end
        end
    end
	draggable(self.interface,self.interface.promptIcon) --封装好的拖拽函数 第一个父级,第二个需要拖拽的对象
	
	------------------------主界面1----------------------------
	self.interface.operationInterface = self.interface:AddChild(Image())
	local operationInterface = self.interface.operationInterface
	operationInterface:Hide()
	-- 背景层
	operationInterface.bg = operationInterface:AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_31.tex'))
	operationInterface.bg:SetScale(1.05, 1.05, 1.05)
	-- 遮罩层
	operationInterface.chh_shade = operationInterface:AddChild(ImageButton(PATHUI.PUBLIC..'chh_shade.xml','chh_shade.tex'))
	operationInterface.chh_shade:SetScale(20, 10)
	operationInterface.chh_shade.scale_on_focus = false --鼠标移入的时候不会放大图片了
	operationInterface.chh_shade.move_on_click = false --鼠标点击后不会有下降的效果了
	operationInterface.chh_shade:SetFadeAlpha(0.3, nil) ----设置透明度【参数2，为nil时，子体同步设置】
	operationInterface.chh_shade:MoveToBack()
	operationInterface.chh_shade.OnControl = function(self, control, down) -- down为true是按下 down为false是弹起  一共触发俩次
		if not down and control == 29 then operationInterface:Hide() end
	end
	--分割 都塞入背景中 后续方便跟随移动 由 auction 统领
	operationInterface.bg.auction = operationInterface.bg:AddChild(Image())
	local auction = operationInterface.bg.auction
	-- -关闭按钮
	auction.close = auction:AddChild(ImageButton(PATHUI.PUBLIC..'chh_close.xml','chh_close.tex'))
	auction.close:SetPosition(500, 280)
	auction.close.OnControl = function(self, control, down) -- down为true是按下 down为false是弹起  一共触发俩次
		if not down and control == 29 then operationInterface:Hide() end
	end
	-- -头部背景 :AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_15.tex'))
	auction.bag = auction:AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_30.tex'))
	auction.bag.text = auction.bag:AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_15.tex'))
	auction.bag:SetPosition(0, 330)
	--分割 背景部分全部完成 由 auctionRecord 统一管理后续
	auction.record = auction:AddChild(Image())
	local auctionRecord = auction.record
	auctionRecord.type = auctionRecord:AddChild(Image())
	local type = auctionRecord.type -- 三个切换按钮由type管理
	type:SetPosition(-520, 270)
	type:SetScale(0.9,0.9,0.9)
	type.scale_on_focus = false --鼠标移入的时候不会放大图片了
	type.move_on_click = false --鼠标点击后不会有下降的效果了
	type.type1 = type:AddChild(ImageButton(PATHUI.ASSET..'chh_auction.xml','chh_auction_2.tex'))
	type.type2 = type:AddChild(ImageButton(PATHUI.ASSET..'chh_auction.xml','chh_auction_2.tex'))
	type.type3 = type:AddChild(ImageButton(PATHUI.ASSET..'chh_auction.xml','chh_auction_2.tex'))
	type.type1:SetPosition(0, 0) type.type2:SetPosition(120, 10) type.type3:SetPosition(240, 0)
	type.type1:SetText('游览') type.type2:SetText('竞标') type.type3:SetText('拍卖')
	-- type 下面的背景
	auctionRecord.leftBg = auctionRecord:AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_47.tex'))
	local leftBg = auctionRecord.leftBg
	leftBg:SetPosition(-405, -15)
	-- 物品显示的主体背景
	auctionRecord.rightBg = auctionRecord:AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_44.tex'))
	local rightBg = auctionRecord.rightBg
	rightBg:SetPosition(150, 10)
	--物品显示的主体背景下的分页
	auctionRecord.riBgPage = auctionRecord:AddChild(Image())
	local riBgPage = auctionRecord.riBgPage
	riBgPage:SetPosition(150, -230)
	riBgPage.previousPage = riBgPage:AddChild(ImageButton(PATHUI.ASSET..'chh_auction.xml','chh_auction_32.tex'))
	riBgPage.nextPage = riBgPage:AddChild(ImageButton(PATHUI.ASSET..'chh_auction.xml','chh_auction_33.tex'))
	riBgPage.center = riBgPage:AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_26.tex'))
	riBgPage.previousPage:SetPosition(-120, 0) riBgPage.center:SetPosition(0, -3) riBgPage.nextPage:SetPosition(120, 0)
	--底部背景
	auctionRecord.botBg = auctionRecord:AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_29.tex'))
	local botBg = auctionRecord.botBg
	botBg:SetPosition(0, -295)
	--底部背景里面的东西
	botBg.money1 = botBg:AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_19.tex'))
	botBg.money2 = botBg:AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_19.tex'))
	botBg.Rigbtn = botBg:AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_10.tex'))
	botBg.money1:SetPosition(-440,0)  botBg.money2:SetPosition(-220,0) botBg.Rigbtn:SetPosition(400,0)
	------------------------上面均为公用部分-------------------------
	-----------------------开始处理点击的分类------------------------
	auctionRecord.information1 = auctionRecord:AddChild(B003_information1()) --游览
	auctionRecord.information2 = auctionRecord:AddChild(B003_information2()) --竞标
	auctionRecord.information3 = auctionRecord:AddChild(B003_information3()) --拍卖
	local information1,information2,information3 = auctionRecord.information1,auctionRecord.information2,auctionRecord.information3

end

return MainProgram



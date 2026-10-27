local Widget = require "widgets/widget" --Widget，所有widget的祖先类
local Text = require "widgets/text" --Text类，文本处理
local Image = require "widgets/image" -- Image图片
local ImageButton = require "widgets/imagebutton" -- ImageButton 图片按钮
local TextButton = require "widgets/textbutton" -- 文字按钮
local ScrollableList = require "widgets/scrollablelist" --滚动条

local informationData = require('widgets/B003/B003_informationData')
--拍卖
local MainProgram = Class(Widget,function(self)
	local PATHUI = TUNING.CHHDATA.B003.UI
	Widget._ctor(self,'B003_information3') --这一句必须写在构造函数的第一行，否则会报错。
	self.interface = self:AddChild(Widget('B003_information3'))
	local interface = self.interface
	interface.LeftData = interface:AddChild(Image())
	interface.RightData = interface:AddChild(Image())
	local LeftData,RightData = interface.LeftData,interface.RightData
	-- :AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_15.tex'))
	-- LeftData.pmText = LeftData:AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_20.tex'))


end)

return MainProgram



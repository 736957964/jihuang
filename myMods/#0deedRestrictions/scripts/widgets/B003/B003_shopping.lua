local Widget = require "widgets/widget" --Widget，所有widget的祖先类
local Text = require "widgets/text" --Text类，文本处理
local Image = require "widgets/image" -- Image图片
local ImageButton = require "widgets/imagebutton" -- ImageButton 图片按钮
local TextButton = require "widgets/textbutton" -- 文字按钮
local ScrollableList = require "widgets/scrollablelist" --滚动条

local informationData = require('widgets/B003/B003_informationData')
--拍卖
local MainProgram = Class(Widget,function(self,shopnew)
	local PATHUI = TUNING.CHHDATA.B003.UI
	Widget._ctor(self,'B003_shopping') --这一句必须写在构造函数的第一行，否则会报错。
	self.interface = self:AddChild(Widget('B003_shopping'))
	local interface = self.interface
	interface.bg = interface:AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_1.tex'))
	interface.shop_list = {} --商品组
	interface.shop = shopnew

	local chh_auction_49 = nil
	for k,v in pairs(interface.shop) do
		chh_auction_49 = interface:AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_49.tex'))
		table.insert(interface.shop_list, chh_auction_49)
	end
-- 第一个参数 为表一般情况放图片按钮 第二个参数为x的大小 第三个参数为y的大小  第四个参数为XX数据之间的间隔(项目高度) 第五个类似第四个 （项目填充）
	--6更新函数  7 未知  第八个参数为XX数据x偏移(整体的 第九 十 始终显示静态、起始偏移(不常用)
	--第十一个参数为XX数据y偏移位置(整体的)   第十二 三 比例 默认1  第十四为官方定义的 不写默认'BLACK' 可写'GOLD'
	interface.shopAll = interface:AddChild(ScrollableList(
	interface.shop_list, 530, 320, 40, 5,
	nil, nil, 140, nil, nil,
	20, nil,nil,'GOLD'))

	local shopAll = interface.shopAll
	shopAll:SetPosition(123,-200)

	-- shopAll[1] = interface:AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_49.tex'))
	-- shopAll[2] = interface:AddChild(Image(PATHUI.ASSET..'chh_auction.xml','chh_auction_49.tex'))
	-- shopAll[1]:SetPosition(0,7+informationData.RightBgInterval)
	-- shopAll[2]:SetPosition(0,7+informationData.RightBgInterval*2)

end)

return MainProgram



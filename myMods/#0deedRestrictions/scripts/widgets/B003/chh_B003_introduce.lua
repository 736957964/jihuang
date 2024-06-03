local Widget = require "widgets/widget" --Widget，所有widget的祖先类

local B003_auctionFirm = require 'widgets/B003/B003_auctionFirm' --拆解一部分函数 避免文件行数过多

local MainProgram = Class(Widget,function(self) --第一个参数是父类，第二个参数是构造函数
	Widget._ctor(self,'chh_B003') --这一句必须写在构造函数的第一行，否则会报错。
	B003_auctionFirm(self)
	
end)

return MainProgram
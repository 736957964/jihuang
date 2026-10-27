local Widget = require "widgets/widget" --Widget，所有widget的祖先类
local Text = require "widgets/text" --Text类，文本处理
local Image = require "widgets/image" -- Image图片
local ImageButton = require "widgets/imagebutton" -- ImageButton 图片按钮
local TextButton = require "widgets/textbutton" -- 文字按钮
local ScrollableList = require "widgets/scrollablelist" --滚动条

local B002_spiderSolitaire = require 'widgets/B002/B002_spiderSolitaire' --拆解一部分函数 避免文件行数过多

local MainProgram = Class(Widget,function(self) --第一个参数是父类，第二个参数是构造函数
	Widget._ctor(self,'chh_B002') --这一句必须写在构造函数的第一行，否则会报错。
	B002_spiderSolitaire(self)
	
end)

return MainProgram
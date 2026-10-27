GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

local Introduce = require("widgets/B001/chh_B001_introduce")

local tab = {
	MODROOT = MODROOT..'json/gift_info.json',
	UI = { ASSET = "images/b001/",PUBLIC = "images/public/" }
}

if TUNING.CHHDATA then TUNING.CHHDATA.B001={} TUNING.CHHDATA.B001 = tab else TUNING.CHHDATA = { B001 = tab } end

--UI部分 所有需要注册的东西都插入在这张表
if not Assets then Assets = { } end
local UI ={ --注册的数据  对应文件夹路径 TUNING.CHHDATA.UI.ASSET
	ASSET = {'huishou','operationInterface','chh_allBlack','lansekuai'},
	PUBLIC = {'chh_close'}
}
for index,name in pairs(UI) do
	for k,v in pairs(name) do
		table.insert(Assets,Asset("ATLAS", TUNING.CHHDATA.B001.UI[index]..v..".xml"))
		table.insert(Assets,Asset("IMAGE", TUNING.CHHDATA.B001.UI[index]..v..".tex"))
	end
end
---重复的代码 设置图标等比例变化
local function PositionUI(self, screensize)
    local hudscale = self.top_root:GetScale()  --获取屏幕大小比例(方便控制等比例变化)
    self.introduce:SetScale(0.9*hudscale.x,0.9*hudscale.y,1)
end
local function AddIntroduce(self)
	self.introduce = self.top_root:AddChild(Introduce()) --这里是为了ui界面自适应大屏幕所以写到了top_root下面 并且给了一个当前客户端玩家的传参
    self.introduce:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
    self.introduce:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
    self.introduce:SetPosition(0,0,0) -- 设置introduce widget相对原点的偏移量，70，-50表明向右70，向下50，第三个参数无意义。
    self.introduce:MoveToBack()
	------------------
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
end

AddClassPostConstruct("widgets/controls", AddIntroduce)--设置UI


-- -- -- 以只读方式打开文件
-- file = io.open("wssbwswsbadqwqwqw.lua", "w+")

-- -- 输出文件第一行
-- print(file:read())

-- -- -- 关闭打开的文件
-- file:close()

-- -- 以附加的方式打开只写文件
-- file = io.open("wssbwswsbadqwqwqw.lua", "a")

-- -- 在文件最后一行添加 Lua 注释
-- file:write("--test")

-- -- 关闭打开的文件
-- file:close()
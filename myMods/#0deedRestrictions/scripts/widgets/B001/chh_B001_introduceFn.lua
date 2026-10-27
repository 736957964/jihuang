local Widget = require "widgets/widget" --Widget，所有widget的祖先类
local Text = require "widgets/text" --Text类，文本处理
local Image = require "widgets/image" -- Image图片
local ImageButton = require "widgets/imagebutton" -- ImageButton 图片按钮
local TextButton = require "widgets/textbutton" -- 文字按钮
local ScrollableList = require "widgets/scrollablelist" --滚动条
-- operationInterface外头界面 rootButTex showText 存储定义的对象 tableData 需要循环的表 StrType 循环表的下一级
-- 想把俩个列表分离 忘记创建一个大类了 改起来比较麻烦 所以多传了个 operationInterface2
local function presetsButton(self,operationInterface,rootButTex,showText,tableData,StrType,operationInterface2)
local data = deepcopy(tableData) --深度拷贝表
rootButTex = {}
showText = {}
local index = 1
local jiemian = operationInterface
local jiemian2 = operationInterface2
-------------components 的滚动条------------
-- 第一个参数 为表一般情况放图片按钮 第二个参数为x的大小 第三个参数为y的大小  第四个参数为XX数据之间的间隔 第五个类似第四个 6 7 9 10未知  第八个参数为XX数据x偏移(整体的) --第十一个参数为XX数据y偏移位置(整体的)  6更新函数

if not jiemian.showTextFace then
jiemian.showTextFace = jiemian:AddChild(ScrollableList(showText, 350, 280, 30, 10, nil, nil, 180, nil, nil, 0))
local showTextFace = jiemian.showTextFace
showTextFace:SetPosition(20, 0)
end
	for k,v in pairs(data[StrType] or data) do
		rootButTex[index] = jiemian:AddChild(ImageButton("images/global_redux.xml", "button_carny_xlong_normal.tex", "button_carny_xlong_hover.tex", "button_carny_xlong_disabled.tex", "button_carny_xlong_down.tex"))
		rootButTex[index]:SetText(string.format('组件：%s',k))
		rootButTex[index].text:SetSize(40)
		rootButTex[index]:SetScale(0.5,0.5,0.5)
		rootButTex[index]:SetOnClick(function()
		local index2 = 1
		local TextSize = 40
		showText = {}
		local textBtnPackage = function (setString,SetSize,storeData,setFn)
			if SetSize == nil then SetSize = 40 end
			if storeData == nil then storeData = showText end
			if #storeData == 0 then index2 = 1 end

			storeData[index2] = jiemian:AddChild(TextButton())
			storeData[index2].text:SetSize(SetSize)
			storeData[index2]:SetFont(NEWFONT) --设置字体
			storeData[index2]:SetText(setString)
			storeData[index2]:SetTextColour({237/255,155/255,155/255,0.8})--设置文字按钮颜色和透明度 不写默认为淡灰黄
			storeData[index2]:SetTextFocusColour({255/255,0/255,0/255,0.7}) --鼠标移入文字按钮时候的颜色和透明度 不写默认为白色
			storeData[index2]:SetTextDisabledColour({0.5,0.5,0.5,1}) --禁用时候的颜色
			storeData[index2]:SetTextSelectedColour({255/255,0/255,0/255,1})--选中时候的颜色？
			storeData[index2]:SetOnClick(setFn)--点击触发函数
			index2 = index2 + 1
		end
		local xunhuanFn = nil
		xunhuanFn = function(data,SetSize,storeData)
			for m,n in pairs(data) do
			m = tostring(m)
			if(type(n) == 'number') or type(n) == 'string' then
				textBtnPackage(string.format("%s：%s",m, n),SetSize,storeData)
			elseif type(n) == 'boolean' then
				textBtnPackage(string.format("%s：%s  布尔值",m, tostring(n)),SetSize,storeData)
			elseif type(n) == 'function' then
				textBtnPackage(string.format("%s  ◆ ：函数",m),SetSize,storeData)
			elseif type(n) == 'nil' then 
				textBtnPackage(string.format("%s：空的数据",m),SetSize,storeData)
			elseif type(n) == 'userdata' then
				textBtnPackage(string.format("%s：userdata",m),SetSize,storeData)
			else
				textBtnPackage(string.format("%s  ◆ ：%s",tostring(m),type(n)),SetSize,storeData,function()
					jiemian.textDisplay = jiemian:AddChild(Image()) -- 统一到这里 方便删除
					local textDisplay = jiemian.textDisplay
					textDisplay.getPresetsButtonTwo = textDisplay:AddChild(ImageButton(TUNING.CHHDATA.B001.UI.ASSET..'chh_allBlack.xml','chh_allBlack.tex'))
					local getPresetsButtonTwo = textDisplay.getPresetsButtonTwo
					getPresetsButtonTwo:SetPosition(-5, -10) --偏移
					getPresetsButtonTwo:SetScale(20,20,20)--设置大小
					getPresetsButtonTwo.scale_on_focus = false --鼠标移入的时候不会放大图片了
					getPresetsButtonTwo.move_on_click = false --鼠标点击后不会有下降的效果了
					getPresetsButtonTwo.image:SetTint(0, 0, 0, 0.3)
					getPresetsButtonTwo:SetOnClick(function()
						if textDisplay.inst then textDisplay:Kill() end
					end)
					textDisplay.dankuai = textDisplay:AddChild(Image(TUNING.CHHDATA.B001.UI.ASSET..'lansekuai.xml','lansekuai.tex'))
					local dankuai = textDisplay.dankuai
					dankuai:SetScale(3,3,3)--设置大小
					dankuai:SetTint(0.5, 0.5, 0.5, 0.9)
					local showText2 = {}
					local store = xunhuanFn(n,SetSize-1,showText2)
					--傻逼东西 浪费我时间 非要数据存完之后在创建 曹尼玛的 没事别写界面 多喝热水
					--用变量名的时候尽量用自己能预测到的东西 之前这里写了 textDisplay[k] 特殊情况就报错了==					
					textDisplay.rootButTex = textDisplay:AddChild(ScrollableList(store, 350, 280, 30, 10, nil, nil, 180, nil, nil, 0))
					textDisplay.rootButTex:SetPosition(20, 0)
					-- if store then textDisplay[m]:SetList(store,false,0,nil) print('更新数据') end
				end)
			end
			end
			---for循环结束
			return storeData
		end
		local storeData = xunhuanFn(v,TextSize,showText)
		if storeData then jiemian.showTextFace:SetList(storeData,false,0,nil) end
		end)
		index = index + 1
	end
if jiemian2.componentsData then jiemian2.componentsData:SetList(rootButTex,false,nil,nil) end 
end


local function getPresetsButton_OnControl(self, control, down,operationInterface,rootButTex,showText)
if not down and control == 29 then
local inventory = ThePlayer.replica.inventory
local activeitem = inventory:GetActiveItem()  -- ThePlayer.components.inventory.activeitem.Physics  ThePlayer.replica.inventory:GetActiveItem()
local inventoryitem_replica = activeitem and activeitem.replica.inventoryitem
if activeitem and activeitem.prefab then
-- inst.replica.inventoryitem:GetAtlas() 获取预设的xml  :GetImage() 获取tex  
	operationInterface.PrefabImg:SetTexture(inventoryitem_replica:GetAtlas(),inventoryitem_replica:GetImage(),'axe.tex')
	inventory:GetItemInSlot(activeitem)--把东西放回空格里
	-- inventory:SetActiveItem(nil)--鼠标置空 配合上面
	
	rootButTex = {} --我也不知道为什么一定要提前创建滚动 写presetsButton里头需要点俩次才会生效
	if not operationInterface.componentsData then
		operationInterface.componentsData = operationInterface:AddChild(ScrollableList(rootButTex, 350, 280, 30, 10, nil, nil, 220, nil, nil, 0))
		local componentsData = operationInterface.componentsData
		componentsData:SetPosition(-420, -50)
		componentsData:LayOutStaticWidgets(25)
	end
	if operationInterface.generalManager then operationInterface.generalManager:Kill() end
	operationInterface.generalManager = operationInterface:AddChild(Image())
	presetsButton(self,operationInterface.generalManager,rootButTex,showText,activeitem,'components',operationInterface)
end
end
end



local introduceFn = {
getPresetsButton_OnControl = getPresetsButton_OnControl



}



return introduceFn
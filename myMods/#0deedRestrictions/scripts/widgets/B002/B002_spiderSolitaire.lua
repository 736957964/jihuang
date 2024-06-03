local Widget = require "widgets/widget" --Widget，所有widget的祖先类
local Text = require "widgets/text" --Text类，文本处理
local Image = require "widgets/image" -- Image图片
local ImageButton = require "widgets/imagebutton" -- ImageButton 图片按钮
local TextButton = require "widgets/textbutton" -- 文字按钮
local ScrollableList = require "widgets/scrollablelist" --滚动条

local MainProgram = function(self)
print('这是 b002')
	local PATHUI = TUNING.CHHDATA.B002.UI
	self.interface = self:AddChild(Widget('chh_B002'))
	self.interface.promptIcon = self.interface:AddChild(ImageButton(PATHUI.ASSET..'poker.xml','dipai.tex'))
	self.interface.promptIcon:SetPosition(500, 400) --设置偏移位置 左负上正
	self.interface.promptIcon:SetHoverText("蜘蛛纸牌\n(右键可挪动)",{wordwrap=true,font_size=40,bg=false,region_h=70,})
	self.interface.promptIcon:AddChild(self.interface.promptIcon.hovertext) --显示文字跟随纸牌
	self.interface.promptIcon:SetScale(0.5,0.5,0.5)
	self.interface.promptIcon.OnControl = function(_self, control, down) --点击后触发的事件
        if not down then
            if control == 29 then self.interface.operationInterface:Show() ThePlayer.HUD.controls:HideCraftingAndInventory() -- 设置information下的operationInterface为显示
			elseif control == 1 then self.interface.operationInterface:Hide() ThePlayer.HUD.controls:ShowCraftingAndInventory() -- 设置information下的operationInterface为隐藏
			end
        end
    end
	draggable(self.interface,self.interface.promptIcon) --封装好的拖拽函数 第一个父级,第二个需要拖拽的对象
	------------------------主界面1----------------------------
	self.interface.operationInterface = self:AddChild(Image(PATHUI.ASSET..'background.xml','background.tex'))
	local operationInterface = self.interface.operationInterface
	local rootButTex = {} local showText = {} -- components按钮对象
	operationInterface:SetPosition(0, 0)
	operationInterface:Hide()
	operationInterface:SetScale(1.8,1.4,1.4)
	---------
	operationInterface.QQText = operationInterface:AddChild(TextButton())
	operationInterface.QQText:SetPosition(200,280) --偏移
	operationInterface.QQText:SetFont(NEWFONT) --设置字体 NEWFONT
	operationInterface.QQText:SetTextSize(20) --文字大小
	operationInterface.QQText:SetText("bug反馈Q群-917979244") --文本设置
	-- -关闭按钮
	operationInterface.close = operationInterface:AddChild(ImageButton(PATHUI.PUBLIC..'chh_close.xml','chh_close.tex'))
	operationInterface.close:SetPosition(300, 280)
	operationInterface.close:SetScale(0.7,0.8,0.8)
	operationInterface.close.OnControl = function(self, control, down) -- down为true是按下 down为false是弹起  一共触发俩次
		if not down then
			operationInterface:Hide()
			ThePlayer.HUD.controls:ShowCraftingAndInventory()
		end
	end
	local playGamesFn = nil
	-- 没事千万别在TUNING放自己的变量  我放在 TUNING纯属无奈,有个严重的bug导致数据不能放fn里（当然放在inst里也是可以的 就是我懒）
	TUNING.deckBackgroundPos = {} --背景位置存入 后续设定位置用的上（坐标）
	TUNING.deckBackgroundPos2 = {} --背景位置存入 后续设定位置用的上（偏移坐标）
	---开始文字按钮
	operationInterface.begin = operationInterface:AddChild(TextButton())
	operationInterface.begin.text:SetHAlign(ANCHOR_LEFT) --左对齐 注意 这里的文字按钮里面多个text‘
	operationInterface.begin:SetPosition(-350, 280) --偏移
	operationInterface.begin:SetFont(NUMBERFONT) --设置字体 NEWFONT
	operationInterface.begin:SetTextSize(35) --文字大小
	operationInterface.begin:SetText("开始(Begin)") --文本设置
	operationInterface.begin:SetTextColour({237/255,155/255,155/255,0.8})--设置文字按钮颜色和透明度 不写默认为淡灰黄
	operationInterface.begin:SetTextFocusColour({255/255,0/255,0/255,0.7}) --鼠标移入文字按钮时候的颜色和透明度 不写默认为白色
	operationInterface.begin:SetTextDisabledColour({0.5,0.5,0.5,1}) --禁用时候的颜色
    operationInterface.begin:SetTextSelectedColour({255/255,0/255,0/255,1})--选中时候的颜色
    operationInterface.begin:SetOnClick(function() playGamesFn() end)--点击触发函数
	---文字提示
	operationInterface.difficulty2 = operationInterface:AddChild(Text(NEWFONT_SMALL,30,"当前难度：")) --NEWFONT_SMALL
	operationInterface.difficulty2:SetPosition(-230,280) --偏移
	operationInterface.difficulty2:SetColour({237/255,155/255,155/255,0.8})
	local difficultyFn = function() -- 设置游戏难度
		operationInterface.difficulty:Hide()
		operationInterface.begin:Hide()
		operationInterface.difficultyEasy:Show()
		operationInterface.difficultyMedium:Show()
		operationInterface.difficultyDifficulty:Show()
	end
	--{'heitao_','hontao_','fangkuai_','meihua_', 'heitao_','hontao_','fangkuai_','meihua_'}
	TUNING.pokerDatas = {'heitao_','heitao_','heitao_','heitao_', 'heitao_','heitao_','heitao_','heitao_'}
	--简单
	operationInterface.difficultyEasy = operationInterface:AddChild(TextButton())
	operationInterface.difficultyEasy.text:SetHAlign(ANCHOR_LEFT) --左对齐 注意 这里的文字按钮里面多个text‘
	operationInterface.difficultyEasy.text:SetVAlign(ANCHOR_TOP)
	operationInterface.difficultyEasy:SetPosition(-150,300) --偏移
	operationInterface.difficultyEasy:SetFont(NEWFONT) --设置字体 NEWFONT
	operationInterface.difficultyEasy:SetTextSize(25) --文字大小
	operationInterface.difficultyEasy:SetText("简单(Easy)") --文本设置
	operationInterface.difficultyEasy:Hide()
	operationInterface.difficultyEasy:SetOnClick(function() --点击触发函数
		operationInterface.difficulty:SetText("简单(Easy)")
		operationInterface.begin:Show()
		operationInterface.difficulty:Show()
		operationInterface.difficultyEasy:Hide()
		operationInterface.difficultyMedium:Hide()
		operationInterface.difficultyDifficulty:Hide()
		TUNING.pokerDatas = {'heitao_','heitao_','heitao_','heitao_', 'heitao_','heitao_','heitao_','heitao_'}
	end)
	--中等
	operationInterface.difficultyMedium = operationInterface:AddChild(TextButton())
	operationInterface.difficultyMedium.text:SetHAlign(ANCHOR_LEFT) --左对齐 注意 这里的文字按钮里面多个text‘
	operationInterface.difficultyMedium.text:SetVAlign(ANCHOR_TOP)
	operationInterface.difficultyMedium:SetPosition(-140,270) --偏移
	operationInterface.difficultyMedium:SetFont(NEWFONT) --设置字体 NEWFONT
	operationInterface.difficultyMedium:SetTextSize(25) --文字大小
	operationInterface.difficultyMedium:SetText("中等(Medium)") --文本设置
	operationInterface.difficultyMedium:Hide()
	operationInterface.difficultyMedium:SetOnClick(function() --点击触发函数
		operationInterface.difficulty:SetText("中等(Medium)")
		operationInterface.begin:Show()
		operationInterface.difficulty:Show()
		operationInterface.difficultyEasy:Hide()
		operationInterface.difficultyMedium:Hide()
		operationInterface.difficultyDifficulty:Hide()
		TUNING.pokerDatas = {'heitao_','hontao_','heitao_','hontao_', 'heitao_','hontao_','heitao_','hontao_'}
	end)
	--困难
	operationInterface.difficultyDifficulty = operationInterface:AddChild(TextButton())
	operationInterface.difficultyDifficulty.text:SetHAlign(ANCHOR_LEFT) --左对齐 注意 这里的文字按钮里面多个text‘
	operationInterface.difficultyDifficulty.text:SetVAlign(ANCHOR_TOP)
	operationInterface.difficultyDifficulty:SetPosition(-135,240) --偏移
	operationInterface.difficultyDifficulty:SetFont(NEWFONT) --设置字体 NEWFONT
	operationInterface.difficultyDifficulty:SetTextSize(25) --文字大小
	operationInterface.difficultyDifficulty:SetText("困难(Difficulty)") --文本设置
	operationInterface.difficultyDifficulty:Hide()
	operationInterface.difficultyDifficulty:SetOnClick(function() --点击触发函数
		operationInterface.difficulty:SetText("困难(Difficulty)")
		operationInterface.begin:Show()
		operationInterface.difficulty:Show()
		operationInterface.difficultyEasy:Hide()
		operationInterface.difficultyMedium:Hide()
		operationInterface.difficultyDifficulty:Hide()
		TUNING.pokerDatas = {'heitao_','hontao_','fangkuai_','meihua_', 'heitao_','hontao_','fangkuai_','meihua_'}
	end)
	---难度选择
	operationInterface.difficulty = operationInterface:AddChild(TextButton())
	operationInterface.difficulty:SetPosition(-130,280) --偏移
	operationInterface.difficulty:SetFont(NEWFONT) --设置字体 NEWFONT
	operationInterface.difficulty:SetTextSize(30) --文字大小
	operationInterface.difficulty:SetText("简单(Easy)") --文本设置
	operationInterface.difficulty:SetOnClick(difficultyFn)--点击触发函数
	------
	operationInterface.playGamesTwo = operationInterface:AddChild(Image())
	local playGames = operationInterface.playGamesTwo
	playGames:SetScale(0.8,0.8,0.8)
	--顶部牌堆背景统一管理
	playGames.deckBackground = playGames:AddChild(Image())
	playGames.deckBackground:SetPosition(-570, 200)
	playGames.deckBackground:SetScale(0.66,0.9,0.9)
	for k=1,10,1 do
		playGames.deckBackground[k] = playGames.deckBackground:AddChild(Image(PATHUI.ASSET..'poker.xml','backBag2.tex'))
		playGames.deckBackground[k]:SetPosition(k*150, 0)
		TUNING.deckBackgroundPos[k] = playGames.deckBackground[k]:GetWorldPosition()
	end
---开始游戏 由 playGames 统一管理
playGamesFn = function()

	if operationInterface.playGames then operationInterface.playGames:Kill() end
	operationInterface.playGames = operationInterface:AddChild(Image())
	local playGames = operationInterface.playGames
	playGames:SetScale(0.8,0.8,0.8)

	--------- 牌组抽取
	local plateGather = { --所有的牌数据都存这
		total = {}, --所有牌的预设名称
		total_temporary = {},--暂存没用过的牌
		tenPokerData = {}, -- 10堆牌的数据都在这了
		finishNumber = 0  --完成的蜘蛛牌数量（左边显示）
	}
	playGames.pokerData = playGames:AddChild(Image())
	playGames.pokerData:SetScale(0.7,0.9,0.9)
	for k,v in pairs(TUNING.pokerDatas) do
		for k=1,13,1 do
			table.insert(plateGather.total,v..tostring(k))--数据插入到表
		end
	end
	plateGather.total_temporary = deepcopy(plateGather.total)--深拷贝表
	local indexK = nil
	-- 前4是5张 后6是4张 开局自动发一张
	local initialHand = function(k,m)
		plateGather.tenPokerData[k][m] = playGames.pokerData:AddChild(Image(PATHUI.ASSET..'poker.xml','dipai.tex'))
		plateGather.tenPokerData[k][m]:SetPosition(TUNING.deckBackgroundPos[k].x,TUNING.deckBackgroundPos[k].y-(m-1)*30)
		plateGather.tenPokerData[k][m].scale_on_focus = false  --鼠标移入的时候不会放大图片了
		plateGather.tenPokerData[k][m].move_on_click = false --鼠标点击后不会有下降的效果
		plateGather.tenPokerData[k][m].heapNumber = k --往 heapNumber 记录 当前几号牌堆
		plateGather.tenPokerData[k][m].isDipai = true --当前是否是底牌
		local index = math.random(#plateGather.total_temporary)
		plateGather.tenPokerData[k][m].pokerName = plateGather.total_temporary[index] --记录扑克名称
		table.remove(plateGather.total_temporary,index)
	end
	for k=1,10,1 do
		plateGather.tenPokerData[k] = {}
		if k >= 4 then --前4牌堆
			for m=1,5,1 do
				initialHand(k,m)
			end
		else --剩余牌堆(6个)
			for m=1,4,1 do
				initialHand(k,m)
			end
		end
	end
	--左下角蜘蛛牌统一管理
	playGames.licensing = playGames:AddChild(Image())
	playGames.licensing:SetPosition(480, -300)
	playGames.licensing:SetScale(0.62,0.8,0.8)
	indexK = 0 --记录还剩多少张蜘蛛牌（底部发牌次数）
	local downPoker = nil --记录当前鼠标点击着的牌
	local overFnDown =function(subset) --纸牌点击的时候触发
		if subset.heapNumber then downPoker = subset.heapNumber end
		if #plateGather.tenPokerData[subset.heapNumber] == 1 then TUNING.deckBackgroundPos2[subset.heapNumber] = subset:GetWorldPosition() end --底牌最后一张就记录
	end
	local ruleDecisionFn = function(tenPokerData,oldPock,subset)
		if #tenPokerData == 0 then print('空位,直接返回成功') return true end
		local number = regularMatching(tenPokerData[#tenPokerData].pokerName,"[^_]+")
		local number2 = regularMatching(oldPock.pokerName,"[^_]+")
		if number[1] == number2[1] and tonumber(number[2]) == tonumber(number2[2]) + 1 then
			return true
		else
			print('找到的牌堆不是连牌,删除假牌,显示原牌')
			local currentPock =plateGather.tenPokerData[subset.heapNumber]
			local yuanben = #currentPock
			for m=0,subset.jishu do
				local oldPock = currentPock[yuanben-subset.jishu+m]
				oldPock:Show() --显示隐藏的纸牌
			end
			subset:Kill() --删除假牌
			return false
		end
	end
	local overFnUP,additionalFn = nil,nil
	local turnCardFn = function(previousPock,isSkip) --判定是否翻蜘蛛牌的fn
		if (previousPock and previousPock.isDipai) or (previousPock and isSkip) then
			previousPock:SetTexture(PATHUI.ASSET..'poker.xml', previousPock.pokerName..".tex")
			draggable(operationInterface,previousPock,overFnDown,overFnUP,MOUSEBUTTON_LEFT,true,additionalFn)--赋予该牌拖拽功能
		end
	end
	local evenCardsFn = function(tenPokerData) --进行连续牌判定
		local jishu = 0
		if #tenPokerData < 13 then do return end end
		print('当前牌堆一共有牌'..#tenPokerData)
		for k=0,11,1 do
			local number = regularMatching(tenPokerData[#tenPokerData-k].pokerName,"[^_]+")
			local number2 = regularMatching(tenPokerData[#tenPokerData-k-1].pokerName,"[^_]+")
			if number[1] == number2[1] and tonumber(number[2]) == number2[2] - 1 then  jishu = jishu + 1 end
			if k == 11 then 
				print('判定成功次数'..jishu)
				if jishu == 12 then
					print('完整的收集了一副牌')
					local shuliang = #tenPokerData
					if playGames.LeftSpider == nil then
						playGames.LeftSpider = playGames:AddChild(Image())
						playGames.LeftSpider:SetScale(0.62,0.8,0.8)
						playGames.LeftSpider:SetPosition(-500 ,-300)
					end
					local LeftSpider = playGames.LeftSpider
					LeftSpider[plateGather.finishNumber+1] = LeftSpider:AddChild(Image(PATHUI.ASSET..'poker.xml',tenPokerData[#tenPokerData-12].pokerName..'.tex'))
					LeftSpider[plateGather.finishNumber+1]:SetPosition(plateGather.finishNumber*30,0)
					LeftSpider[plateGather.finishNumber+1]:MoveToFront()
					LeftSpider[plateGather.finishNumber+1]:Hide()
					plateGather.finishNumber = plateGather.finishNumber + 1
					for m=0,12,1 do
						-- 关于层级被覆盖的问题....不好改 将就吧 反正不影响功能
						playGames.inst:StartThread(function()
						tenPokerData[shuliang-m]:MoveTo(tenPokerData[shuliang-m]:GetWorldRealPosition(),LeftSpider:GetWorldRealPosition()+Vector3(-200,-40,0),1)
						playGames.inst:DoTaskInTime(1,function() tenPokerData[shuliang-m]:Kill() tenPokerData[shuliang-m] = nil  end)--1秒后调用删除
						Sleep(math.random(0.3, 0.3))
						end)
					end
					turnCardFn(tenPokerData[shuliang-13],true)
					playGames.inst:DoTaskInTime(1,function() LeftSpider[plateGather.finishNumber]:Show()  end)--1秒后调用显示
				end
			end
		end
	end
	overFnUP = function(subset) --纸牌拖拽完毕后触发的函数
		print('尝试寻找最近的点')
		local pos = TheInput:GetScreenPosition()
		local point ={
			A={},B={},C={}
		} --得到的坐标都存这
		for k=1,10,1 do -- 从中间开始往外推 寻找比较合适 懒得写了 反正性能差不了多少
			local ind = 0
			if downPoker == k then ind = 1 print('这是本体牌') end -- 如果是拿着的本体牌 需要往上一格
			-- print('当前downPoker='..downPoker)
			local tenPokerData = plateGather.tenPokerData[k]
			local deckPos = nil
			-- print(' #tenPokerData-ind='..(#tenPokerData-ind))
			-- print(' #tenPokerData'..(#tenPokerData))
			if #tenPokerData-ind <=0 then
				deckPos = TUNING.deckBackgroundPos2[k] --没牌了取背景位置
				print('当前k,取的背景位置位为') print(deckPos)
				-- if deckPos == nil then do return end end
				
				--这里是额外的bug处理 没找到触发条件 只能先这样了
				if deckPos == nil then deckPos = tenPokerData[#tenPokerData-ind]:GetWorldPosition() end
			else
				deckPos = tenPokerData[#tenPokerData-ind]:GetWorldPosition()
			end
			local diffA = (pos.x - deckPos.x)^2
			local diffB = (pos.y - deckPos.y)^2
			local diffC = diffB + diffA -- --math.sqrt() 不开方了 浪费性能 取开方前的数比较一样 这里得到的第三边
			point.C[k] = diffC point.A[k] = diffA point.B[k] = diffB
		end
		local diffMin = math.min(unpack(point.C))
		for k,v in pairs(point.C) do
			if diffMin == v then --寻找最小值的牌堆位置
				print('最近的牌堆'..k)
				local tenPokerData = plateGather.tenPokerData[k]
				local currentPock = plateGather.tenPokerData[subset.heapNumber]
				local pos = TUNING.deckBackgroundPos[k]
				if subset.isDummy then --仿造品的情况下
					local yuanben = #currentPock
					for m = 0,subset.jishu,1 do
						local oldPock = currentPock[yuanben-subset.jishu+m]
						print('旧牌名称'..oldPock.pokerName)
						if m==0 and not ruleDecisionFn(tenPokerData,oldPock,subset) then do return end end --判定是继续执行 还是返回原位  true为继续
						oldPock:Show() --显示隐藏的纸牌
						oldPock:MoveToFront() --必须搬到前段 不然坐标会重叠
						oldPock.heapNumber = k --设定当前牌堆
						tenPokerData[#tenPokerData+1] = oldPock --往新牌中加数据
						currentPock[yuanben-subset.jishu+m] = nil --清掉之前table里的数据
						oldPock:SetPosition(pos.x,pos.y-30*(#tenPokerData-1))
					end
					if subset.heapNumber ~= k then turnCardFn(currentPock[yuanben-subset.jishu-1]) end -- 不是放回原位那就进行翻牌的fn
					subset:Kill() --删除假牌
				else
					if subset.heapNumber ~= k then --判定是不是放回原来的位置了
						local number = regularMatching(tenPokerData[#tenPokerData].pokerName,"[^_]+") --目标位置
						local number2 = regularMatching(subset.pokerName,"[^_]+") --原本的牌
						if number[1] == number2[1] and tonumber(number[2]) == tonumber(number2[2]) + 1 then
							turnCardFn(currentPock[#currentPock-1]) -- 不是放回原位那就进行翻牌的fn 单牌直接获取上面的
							currentPock[#currentPock] = nil --清掉之前table里的数据
							tenPokerData[#tenPokerData+1] = subset --往新牌中加数据
							subset:SetPosition(TUNING.deckBackgroundPos[k].x,TUNING.deckBackgroundPos[k].y-(#tenPokerData-1)*30)
							subset.heapNumber = k
							evenCardsFn(tenPokerData) -- 进行连牌判定 A-K是否连牌
						else --判定失败 返回原位
							local pos = TUNING.deckBackgroundPos[subset.heapNumber]
							subset:SetPosition(pos.x,pos.y-30*(#currentPock - 1)) --
							
							do return end 
						end
						
					end
					
				end
				
			end
		end
	end
	local judgeFn = function(jishu,tenPokerData,index,heapNumber) --虚假欺骗
		playGames.pokerData.sham = playGames.pokerData:AddChild(Image())
		playGames.pokerData.sham.isDummy = true --仿造品判定
		playGames.pokerData.sham.index = index --记录键值
		playGames.pokerData.sham.heapNumber = heapNumber --记录牌堆
		playGames.pokerData.sham.jishu = jishu --记录计数
		local pos = TUNING.deckBackgroundPos[heapNumber]
		playGames.pokerData.sham:SetPosition(pos.x,pos.y-30*index)
		playGames.pokerData.sham:FollowMouse()
		draggable(playGames.pokerData,playGames.pokerData.sham,nil,overFnUP,MOUSEBUTTON_LEFT,true)--封装好的拖拽函数 第一个父级,第二个需要拖拽的对象 第三四个为触发的函数
		for k = 0,jishu,1 do
			local pokerName = tenPokerData[index+k].pokerName
			tenPokerData[#tenPokerData-k]:Hide()
			playGames.pokerData.sham[k+1] = playGames.pokerData.sham:AddChild(Image(PATHUI.ASSET..'poker.xml',pokerName..'.tex'))
			playGames.pokerData.sham[k+1]:SetPosition(0, (k-1)*-30)
		end
	end
	additionalFn =function(subset)
		local tenPokerData = plateGather.tenPokerData[subset.heapNumber]
		if tenPokerData[#tenPokerData] == subset then
			return true
		else
			for k,v in pairs(tenPokerData) do
				if subset == v then
					local jishu = 0
					for m=k, #tenPokerData-1,1 do
						local number = regularMatching(tenPokerData[m].pokerName,"[^_]+")
						local number2 = regularMatching(tenPokerData[m+1].pokerName,"[^_]+")
						if number[1] == number2[1] and tonumber(number[2]) == tonumber(number2[2]) + 1 then
							jishu = jishu + 1
						end
					end
					if #tenPokerData == jishu + 1 then TUNING.deckBackgroundPos2[subset.heapNumber] = v:GetWorldPosition() print('牌堆最后一张 存储坐标') end
					if jishu == #tenPokerData-k then
						print('连牌判定通过,转到欺骗程序')
						judgeFn(jishu,tenPokerData,k,subset.heapNumber)
						return false --这里不再走拖拽逻辑了 生成虚假显示图片欺骗视觉
					else
						return false
					end
				end
				if k == #tenPokerData then return false end --找到最后没有合适的给false
			end
		end
	end
	local licensingFn = function()
		playGames.inst:StartThread(function()
			for k=1,10,1 do
				local pokerName = nil
				local index = nil --继续寻找的位置 拿出来后变空
				if #plateGather.total_temporary ==0 then break end
				while(index == nil) do
					index = math.random(#plateGather.total_temporary)
				end
				pokerName = plateGather.total_temporary[index]
				local currentpoker = plateGather.tenPokerData[k] --找到要进去的牌堆
				table.remove(plateGather.total_temporary,index)
				currentpoker[#currentpoker+1] = playGames.pokerData:AddChild(Image(PATHUI.ASSET..'poker.xml',string.format("%s.tex",pokerName)))
				currentpoker[#currentpoker]:MoveTo(playGames.licensing:GetWorldRealPosition(),Vector3(TUNING.deckBackgroundPos[k].x, TUNING.deckBackgroundPos[k].y-30*(#currentpoker-1),0),0.5)
				-- currentpoker[#currentpoker]:SetPosition(TUNING.deckBackgroundPos[k].x, TUNING.deckBackgroundPos[k].y-30*(#currentpoker-1)) --上面已经创建完了所以#currentpoker不需要再加1
				currentpoker[#currentpoker].heapNumber = k --往 heapNumber 记录 当前几号牌堆
				currentpoker[#currentpoker].pokerName = pokerName --记录扑克名称
				currentpoker[#currentpoker].isDipai = false --当前是否是底牌
				draggable(operationInterface,currentpoker[#currentpoker],overFnDown,overFnUP,MOUSEBUTTON_LEFT,true,additionalFn)--封装好的拖拽函数 第一个父级,第二个需要拖拽的对象 第三四个为触发的函数
				Sleep(math.random(0.5, 0.5))
			end
		end)
		if indexK ~= 1 then playGames.licensing[indexK-1].scale_on_focus = true end
		playGames.licensing[indexK]:Kill()
		indexK = indexK - 1
	end
	for k = 1,6,1 do
		indexK = indexK + 1
		playGames.licensing[k] = playGames.licensing:AddChild(ImageButton(PATHUI.ASSET..'poker.xml','dipai.tex'))
		playGames.licensing[k]:SetPosition(-30*k, 0)
		if k ~= 6 then playGames.licensing[k].scale_on_focus = false end --鼠标移入的时候不会放大图片了
		playGames.licensing[k].move_on_click = false --鼠标点击后不会有下降的效果
		playGames.licensing[k]:SetOnClick(licensingFn)
	end
	licensingFn() -- 开局默认发牌
end

end

return MainProgram



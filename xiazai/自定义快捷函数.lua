------modinfo 循环参数配置----
-----单数为配置项 双数为当前配置项里面的参数 单数 第四参 如果为true则可以循环参数判定 不然就正常配置
configuration_options = {}

local render = {
	{'描述1','描述1-2',10},
	{'小描述1-1',10,'小描述1-2',20,'小描述1-3',40},
	{'描述2','描述2-2',20,true},
	{100,10,'小描述2-',{'快到底了！',9999,'已经到底！',19999,'已经到底啊！',29999}},
}

-- modinfo 不能用math. table. pairs 等....
for i=1,#render,2 do
	local value = {
		name = render[i][1],
		label = render[i][2],
		default = render[i][3],
		options = {}
	}
	local render_i2 = render[i+1]
	if render[i][4] then
		local number = 0
		for k=1,render_i2[1] do
			number = k * render_i2[2]
			value.options[k] = { description = render_i2[3]..k,data = number}
		end
		if render_i2[4] then
			local render_i2_4 = render_i2[4]
			for k=1,#render_i2_4,2 do
				local optionsValue = { description = render_i2_4[k],data = render_i2_4[k+1] }
				value.options[render_i2[1]+k/2+0.5] = optionsValue
			end
		end
	else
		for k=1,#render_i2,2 do
			local optionsValue = { description = render_i2[k],data = render_i2[k+1] }
			value.options[k/2+0.5] = optionsValue
		end
	end
	configuration_options[i/2+0.5] = value
end

---------耐久修复---------2021/11/8
---------前置条件-耐久小于100%---------
--必传 inst 武器本体 give 给过来的物品名称(接收物品 也可以直接为true不进行判断)  指定物品修复 repairGive (可为table 格式 {'11','2222'})
--选传 number 修复数量(默认10) item 人物(传参后默认说话)
local function wuqixiufu(inst,give,repairGive,number,item)
	if not number then number = 10 end
	if give == true or give.prefab == repairGive then --修复判断
		---------武器修复开始---------
		if inst.components.finiteuses and inst.components.finiteuses:GetPercent() < 1 then
		print("修复前武器耐久百分比"..(inst.components.finiteuses:GetPercent()))
			inst.components.finiteuses.current = ( number + inst.components.finiteuses.current)
			if inst.components.finiteuses:GetPercent() >= 1 then inst.components.finiteuses.current = inst.components.finiteuses.total end --超出100% 则改为100%
			inst.components.finiteuses:SetPercent(inst.components.finiteuses:GetPercent())--获取当前百分比
			if item and item.components.talker then item.components.talker:Say("武器修复成功,耐久值+"..number) end
		else
			if item and item.components.talker then item.components.talker:Say("非武器或耐久值已满,无法修复(不退还材料)") end
		end
		---------武器修复结束---------
		---------装备修复开始---------
		if not inst.components.finiteuses and inst.components.armor and inst.components.armor:GetPercent() < 1 then
		print("修复前装备耐久百分比"..(inst.components.armor:GetPercent()))
			inst.components.armor.condition = ( number + inst.components.armor.condition)
			if inst.components.armor:GetPercent() >= 1 then inst.components.armor.condition = inst.components.armor.maxcondition end --超出100% 则改为100%
			inst.components.armor:SetPercent(inst.components.armor:GetPercent())--获取当前百分比
			if item and item.components.talker then item.components.talker:Say("装备修复成功,耐久值+"..number) end
		else
			if item and item.components.talker then item.components.talker:Say("非装备或耐久值已满,无法修复(不退还材料)") end
		end
		---------装备修复结束---------
	else
		if item and item.components.talker then item.components.talker:Say("非指定物品,无法修复") end
	end
end

---------武器自动修复---------2021/11/8
--必传 inst 武器本体复---------
--选传 isTips 是否说话提示 默认true  setTime 自动恢复时间 默认60秒 repairNumber 修复耐久值 默认30---------
local function wuqizdxiufu(inst,isTips,setTime,repairNumber)
	local owner = inst.components.inventoryitem.owner --获取库存项目的主人
	if not isTips then isTips = true end  if not setTime then setTime = 60 end if not repairNumber then repairNumber = 30 end
	if owner and isTips then owner.components.talker:Say("该武器拥有自动修复能力,将随着时间自动修复耐久") end
	weaponRepairTimer = inst:DoPeriodicTask(setTime, function()   --定时器 默认60
		if inst.components.finiteuses and inst.components.finiteuses:GetPercent() < 1 then
			if inst.components.finiteuses.total >= (repairNumber + inst.components.finiteuses.current) then --修复没有超出的情况
				inst.components.finiteuses.current = repairNumber + inst.components.finiteuses.current
			else --超出的情况处理
				inst.components.finiteuses.current = inst.components.finiteuses.total
				-- weaponRepairTimer:Cancel() --耐久过多就关闭定时器
				-- weaponRepairTimer = nil
			end
			inst.components.finiteuses:SetPercent(inst.components.finiteuses:GetPercent())--获取当前百分比
			owner.components.talker:Say("武器修复成功,耐久值+"..repairNumber)
		end
	end)
end

---------快捷打印talbe---------2021/12/18
--必传 plData 打印体---------
--选传 subset 打印体下的子集  {'widget','XXX'} otherPrinting 不打印乱七八糟的类 默认打印  SetTextNumber 打印屏幕文字一行占的数量---------
_G.setPrint = false
local function tablePrint(plData, subset, otherPrinting, SetTextNumber)
	if SetTextNumber == nil then SetTextNumber = 123 end
	if otherPrinting == nil then otherPrinting = true end
	local data = plData
	if subset ~= nil then
		--设置一个 setPrint 他会强制覆盖 subset 传参（主要用于一些不能使用控制台的地方）
		if setPrint and #setPrint then subset = setPrint print('当前打印数据为自定义设置') end
		for k,v in pairs(subset) do  print(v) data = data[v] end
	end
    if data then
        if type(data) == 'number' or type(data) == 'string' then
			print(string.format("-----打印数据表开始---数据:%s",data))
        elseif type(data) == 'boolean' then
			print(string.format('-----打印数据表开始---布尔值:%s',tostring(data)))
		else
			print(string.format("-----打印数据表开始----当前预设物:%s",data.prefab or '无'))
			local dataString = '' local number = 1
			for k,v in pairs(data) do
				if type(v) == "string" or type(v) == "number" then
					if string.utf8len(dataString..(string.format("%s=>%s",k,v)))/SetTextNumber >= number then  dataString=dataString..'\n' number=number+1 end
					dataString = dataString..(string.format("%s=>%s",k,v))..' ◆ '
				elseif type(v) == 'boolean' then
					if string.utf8len(dataString..(string.format("%s=>布尔%s",k,tostring(v))))/SetTextNumber >= number then  dataString=dataString..'\n' number=number+1 end
					dataString = dataString..(string.format("%s=>布尔%s",k,tostring(v)))..' ◆ '
				else
					if string.utf8len(dataString..(string.format("%s=>%s",k,type(v))))/SetTextNumber >= number then  dataString=dataString..'\n' number=number+1  end
                    if otherPrinting then dataString = dataString..(string.format("%s=>类:%s",k,type(v)))..' ◆ ' end
                end
			end
			-- if otherPrinting then dataString = dataString..'\n当前没有打印为nil的参数,可能会有参数但显示为0的问题 ◆ ' end
			print(dataString..'总长度'..(string.utf8len(dataString)))
			return dataString..'\n总长度'..(string.utf8len(dataString))
        end
        print('-----打印数据表结束-----')
    else
        print('--打印的数据为空--')
    end
end

--必传 tab 表格  value 需要判断的值---------2021/11/8
--选传 uid为表套表的情况 tab.uid   uid不传则默认只有一张表  string---------
--判断表内是否有该值 返回的是一个table, 第一个参数为布尔，第二个参数为table的索引,第三个为得到的匹配值---------
local function is_include(value,tab,uid)
	for k,v in ipairs(tab) do
		if v[uid] == value or v == value then
			return Point(true,k,v):Get()
		end
	end
	return false -- Point(false,nil,nil):Get() 这样传回去的值是 0
end

------搜索函数-----------2021/11/8
local imagecache = {}
local repl = {}
local notimagecache = {}
function SoraGetImage(na)
    local name = repl[na] or na
    local t = name
    if t:sub(-4):lower() ~= ".tex" then
        t = t..".tex"
    end
    if notimagecache[name] then
        return nil,nil
    end
    if imagecache[name] then
        return imagecache[name].atlas,imagecache[name].image
    end
    if TheSim:AtlasContains("images/inventoryimages.xml", t) then
        imagecache[name] ={ atlas = "images/inventoryimages.xml",image=t}
        return "images/inventoryimages.xml",t
    elseif TheSim:AtlasContains("images/inventoryimages1.xml", t) then
        imagecache[name] = { atlas = "images/inventoryimages1.xml",image=t}
        return "images/inventoryimages1.xml",t
    elseif TheSim:AtlasContains("images/inventoryimages.xml", 'quagmire_'..t) then
        imagecache[name] ={ atlas = "images/inventoryimages.xml",image='quagmire_'..t}
        return "images/inventoryimages.xml",'quagmire_'..t
    elseif TheSim:AtlasContains("images/inventoryimages1.xml", 'quagmire_'..t) then
        imagecache[name] = { atlas = "images/inventoryimages1.xml",image='quagmire_'..t}
        return "images/inventoryimages1.xml",'quagmire_'..t
    elseif TheSim:AtlasContains("images/inventoryimages2.xml", t) then
        imagecache[name] ={ atlas =  "images/inventoryimages2.xml",image=t}
        return "images/inventoryimages2.xml",t
    else
        if GLOBAL.Prefabs[name] then
            local assets = GLOBAL.Prefabs[name].assets or {}
            for ak,av in pairs(assets) do
                if type(av) == "table" and av.type and av.file and av.type == "ATLAS"  then
                    if TheSim:AtlasContains(av.file, t) then
                        imagecache[name] = { atlas = av.file,image=t}
                        return av.file,t
                    end
                end
            end
        end

        local trueatlas = softresolvefilepath("images/inventoryimages/"..name..".xml")
        if trueatlas and TheSim:AtlasContains(trueatlas, t) then
            imagecache[name] = { atlas = "images/inventoryimages/"..name..".xml",image=t}
            return "images/inventoryimages/"..name..".xml",t
        end
        trueatlas = GetInventoryItemAtlas(t,true)
        if trueatlas and TheSim:AtlasContains(trueatlas, t) then
            imagecache[name] ={ atlas =  trueatlas,image=t}
            return trueatlas,t
        end
        trueatlas = softresolvefilepath("images/"..name..".xml")
        if trueatlas and TheSim:AtlasContains(trueatlas, t) then
            imagecache[name] ={ atlas =  "images/"..name..".xml",image=t}
            return "images/"..name..".xml",t
        end
        trueatlas = softresolvefilepath("images/monkey_king_item.xml")
        if trueatlas and TheSim:AtlasContains(trueatlas, t) then
            imagecache[name] = { atlas = "images/monkey_king_item.xml",image=t}
            return "images/monkey_king_item.xml",t
        end
        if PREFABDEFINITIONS[name] then
            for idx,asset in ipairs(PREFABDEFINITIONS[name].assets) do
              if asset.type == "ATLAS" then
                trueatlas = asset.file
              end
            end
        end
        if trueatlas and TheSim:AtlasContains(softresolvefilepath(trueatlas), t) then
            imagecache[name] = { atlas = trueatlas,image=t}
            return trueatlas,t
        end

        if trueatlas and TheSim:AtlasContains(softresolvefilepath(trueatlas), 'quagmire_'..t) then
            imagecache[name] = { atlas = trueatlas,image='quagmire_'..t}
            return trueatlas,'quagmire_'..t
        end

        for k,v in pairs(GLOBAL.Prefabs) do
            if k and k:match("MOD_") then
                local assets = v.assets or {}
                for ak,av in pairs(assets) do
                    if type(av) == "table" and av.type and av.file and av.type == "ATLAS"  then
                        if TheSim:AtlasContains(av.file, t) then
                            imagecache[name] = { atlas = av.file,image=t}
                            return av.file,t
                        end
                    end
                end
            end
        end
        notimagecache[name] = name
    return nil,nil
    end
end

---------------------------------------------------------------------------------------------------------
--UI快捷分页 2021-11-13
--fles 创建的widget参数  data 数据数组(指定义好的ui 存的数组) commandFn 外部可修改的Fn
--------------------------
---中间的图片数据（这里自定义 改一下AllTabel对应的表就行）
local shopData = {
	{prefab = 'dakongshi',number = 50},{prefab = 'bs_fanshang',number = 200},
	{prefab = 'bs_pojia',number = 400},{prefab = 'bs_shanghai',number = 300},
	{prefab = 'bs_naijiu',number = 200},{prefab = 'bs_shanbi',number = 200},
	{prefab = 'bs_xixue',number = 200},{prefab = 'bs_yisu',number = 200}
}
local ItemData = {
	UI = {}, Scale = {0.75,0.75,0.75}, --设置渲染的界面大小 , --渲染的界面
	Text = {}, TextPosition = {0,-55}, --界面对应的文字 --设置文字偏移位置
	numberRows = 4, number = 6,spacingX = 100,spacingY = 100, --放几行(行数)  -- 一行放几个 --x间距和y间距
	TextColour = {237/255,155/255,155/255,0.8}, --设置文字按钮颜色和透明度 不写默认为淡灰黄
	TextFocusColour = {255/255,0/255,0/255,0.7}, --鼠标移入文字按钮时候的颜色和透明度 不写默认为白色
	TextSelectedColour = {255/255,0/255,0/255,1}, --选中时候的颜色
	OnClickFn = {}, --设置渲染界面点击的函数 这里可以是对象也可以直接是单个fn(对象主要是为了特殊传参需要)
	page = 1, --当前页数
	AllTabel = shopData, --把要渲染的表格丢里头
	articlesPosXY={-300,-55},pagingPosXY={100,-60}, --图标偏移坐标 --偏移页码坐标
}
------------允许修改for循环里面部分---表名shopData记得改----------------------------
local commandFn = function()
	local tableName = ItemData.AllTabel
	local number = ItemData.numberRows*ItemData.number --计算一页一共有多少个
	local frequency = number
	if frequency +(ItemData.page-1)*number > #tableName then frequency = #tableName-(ItemData.page-1)*number end --最后一页限制不能超出表数量
	-- for i=1+(ItemData.page-1)*number,frequency do
	for i=1,frequency do
	ItemData.UI[i] = shopContent:AddChild(ImageButton("images/"..tableName[i+(ItemData.page-1)*number].prefab..".xml",tableName[i+(ItemData.page-1)*number].prefab..".tex"))
	ItemData.Text[i] = "价格:"..tableName[i].number
	local ClickFn = function()
		if (owner.shopMoney or 0) >= tableName[i].number then
			SendModRPCToServer(MOD_RPC["chh_smlh"]["smlh_shopBuy"],tableName[i].prefab,tableName[i].number)
		else
			if owner.components.talker then owner.components.talker:Say("我没有这么多钱") end
		end
	end
	ItemData.OnClickFn[i] = ClickFn
	end
end
--------------------------下面不要动------------------------------
local firstPosY = nil --记录第一次设置的坐标
local function dataPaging(fles,data,commandFn)
	commandFn()
	local currentNumber = 1 --当前行数(用来计算是否换行的)
	local total = #data.UI --获取总数量
	local posX = data.number/-2*data.spacingX
	local posY = 0
	local interface = fles:AddChild(Widget("interactiveInterface")) --创建一个总界面的子widget（总界面在哪就设定在哪）
	interface:SetPosition(unpack(ItemData.articlesPosXY)) --偏移坐标
	for k,v in ipairs(data.UI) do --循环ui数组
		if math.floor((k-1)/data.number) >= currentNumber then  --向下取整计算当前所需行数
			currentNumber = currentNumber + 1
			posX=data.number/-2*data.spacingX
		end
		posY = data.numberRows/2*data.spacingY - data.spacingY * (currentNumber -1) --设置y轴
		posX = posX + data.spacingX
		interface.articles = interface:AddChild(Image())
		interface.articles[k] = interface:AddChild(v)  --放入总界面 方便后续统一
		interface.articles[k]:SetPosition(posX,posY) --设置界面位置
		interface.articles[k]:SetScale(unpack(data.Scale)) --设置界面大小
		interface.articles[k]:SetText(data.Text[k]) --设置文字
		interface.articles[k]:SetTextColour(data.TextColour)--设置文字按钮颜色和透明度 不写默认为淡灰黄
		interface.articles[k]:SetTextFocusColour(data.TextFocusColour) --鼠标移入文字按钮时候的颜色和透明度 不写默认为白色
		interface.articles[k]:SetTextSelectedColour(data.TextSelectedColour)--选中时候的颜色
		interface.articles[k].text:SetPosition(unpack(data.TextPosition)) --设置文字偏移位置
		interface.articles[k]:SetOnClick(data.OnClickFn[k])
	end
	if firstPosY == nil then firstPosY = posY end --记录第一次的y坐标 避免后续点击变更位置
	if interface.paging then return end --已经创建过一次就不再创建了(目前无效 目前是所有都删除渲染的)
	local Pagetotal = ItemData.numberRows*ItemData.number --计算一页一共有多少个
	local total = math.ceil(#ItemData.AllTabel / Pagetotal) --向上取整
	interface.paging = interface:AddChild(Image()) -- 分页的东西都丢paging里头了方便诺位置
	local paging = interface.paging
	paging:SetPosition(unpack(ItemData.pagingPosXY))
	paging.LeftButton = paging:AddChild(ImageButton("images/global_redux.xml","arrow2_left_down.tex")) --左箭头
	paging.RightButton = paging:AddChild(ImageButton("images/global_redux.xml","arrow2_right_down.tex")) --右箭头
	paging.PageTextLeft = paging:AddChild(Text(TITLEFONT,50,ItemData.page)) --当前页数
	paging.PageTextContent = paging:AddChild(Text(TITLEFONT,50,' / ')) --中间的
	paging.PageTextRight = paging:AddChild(Text(TITLEFONT,50,total)) --右侧总页数

	paging.PageTextLeft:SetPosition(20,firstPosY-100)  paging.PageTextContent:SetPosition(50,firstPosY-100) paging.PageTextRight:SetPosition(80,firstPosY-100)
	paging.LeftButton:SetPosition(-40,firstPosY-95)  paging.RightButton:SetPosition(120,firstPosY-95)
	paging.LeftButton:SetScale(0.6,0.6,0.6) paging.RightButton:SetScale(0.6,0.6,0.6)
	paging.LeftButton:SetOnClick(function() --左边箭头点击
		if ItemData.page - 1 <=0 then return end  ItemData.page = ItemData.page - 1   paging.PageTextLeft:SetString(ItemData.page) --切换页码
		interface:Kill() data.UI={} dataPaging(fles,data,commandFn)
	end)
	paging.RightButton:SetOnClick(function() --右边箭头点击
		if ItemData.page + 1 > total then return end  ItemData.page = ItemData.page + 1   paging.PageTextLeft:SetString(ItemData.page) --切换页码
		interface:Kill() data.UI={} dataPaging(fles,data,commandFn)
	end)
	return interface
end
-------------------------上面不要动-------------------------------
local WidgetUi = dataPaging(self.shop.shopContent,ItemData,commandFn) --调用封装好的函数
---------------------------------------------------------------------------------------------------------

---------UI图标拖拽---------2021/11/25 （注意 这里需要加上UI拖拽适配）
--必传 Parent 父级Ui  subset 需要拖拽的ui---------
--选传 overFnDown,overFnUP 结束拖拽前后触发的fn Key 拖拽触发的按钮(默认右键)
--isMoveToFront 是否搬到前面 additionalFn 按键前判定附加函数是否正确（返回值必须是布尔）---------
local draggable = function(parent,subset,overFnDown,overFnUP,Key,isMoveToFront,additionalFn)
	if Key == nil then Key = MOUSEBUTTON_RIGHT end
	subset.OnMouseButton = function(text, button, down, x, y, z, a, b, c)
		print("点击状态-------", text, button, down, x, y, z, a, b, c)
		if additionalFn then
			if not additionalFn(subset) then do return end  end --如果附加函数拿到的是false,不会执行后面的
		end
        if button == Key and down then --鼠标右键
			subset:FollowMouse()  --开启控件的鼠标跟随
			if isMoveToFront then subset:MoveToFront() end --拖拽的固定往上挪一下
			if overFnDown then overFnDown(subset) end
		elseif button == Key then --传过来的Key 左键1000 右键1001
			subset:StopFollowMouse() --停止控件的跟随
			if overFnUP then overFnUP(subset) end
        end
    end
end


---------UI拖拽适配-------2021/11/24---来自小画家
local function ModFollowMouse(self)
--GetWorldPosition获得的坐标是基于屏幕原点的，默认为左下角，当单独设置了原点的时候，这个函数返回的结果和GetPosition的结果一样了，达不到我们需要的效果
    --因为官方没有提供查询原点坐标的接口，所以需要修改设置原点的两个函数，将原点位置记录在widget上
    --注意：虽然默认的屏幕原点为左下角，但是每个widget默认的坐标原点为其父级的屏幕坐标； --而当你单独设置了原点坐标后，不仅其屏幕原点改变了，而且坐标原点的位置也改变为屏幕原点了
    local old_sva = self.SetVAnchor
    self.SetVAnchor = function (_self, anchor)
        self.v_anchor = anchor
        return old_sva(_self, anchor)
    end

    local old_sha = self.SetHAnchor
    self.SetHAnchor = function (_self, anchor)
        self.h_anchor = anchor
        return old_sha(_self, anchor)
    end
    -- 默认的原点坐标为父级的坐标，如果widget上有v_anchor和h_anchor这两个变量，就说明改变了默认的原点坐标
    -- 我们会在GetMouseLocalPos函数里检查这两个变量，以对这种情况做专门的处理
    -- 这个函数可以将鼠标坐标从屏幕坐标系下转换到和wiget同一个坐标系下
    local function GetMouseLocalPos(ui, mouse_pos)        --ui: 要拖拽的widget, mouse_pos: 鼠标的屏幕坐标(Vector3对象)
        local g_s = ui:GetScale()                    --ui的全局缩放值
        local l_s = Vector3(0,0,0)
        l_s.x, l_s.y, l_s.z = ui:GetLooseScale()    --ui本身的缩放值
        local scale = Vector3(g_s.x/l_s.x, g_s.y/l_s.y, g_s.z/l_s.z)    --父级的全局缩放值

        local ui_local_pos = ui:GetPosition()        --ui的相对位置（也就是SetPosition的时候传递的坐标）
        ui_local_pos = Vector3(ui_local_pos.x * scale.x, ui_local_pos.y * scale.y, ui_local_pos.z * scale.z)
        local ui_world_pos = ui:GetWorldPosition()
        -- 如果修改过ui的屏幕原点，就重新计算ui的屏幕坐标（基于左下角为原点的）
        if not (not ui.v_anchor or ui.v_anchor == ANCHOR_BOTTOM) or not (not ui.h_anchor or ui.h_anchor == ANCHOR_LEFT) then
            local screen_w, screen_h = TheSim:GetScreenSize()        --获取屏幕尺寸（宽度，高度）
            if ui.v_anchor and ui.v_anchor ~= ANCHOR_BOTTOM then    --如果修改了原点的垂直坐标
                ui_world_pos.y = ui.v_anchor == ANCHOR_MIDDLE and screen_h/2 + ui_world_pos.y or screen_h - ui_world_pos.y
            end
            if ui.h_anchor and ui.h_anchor ~= ANCHOR_LEFT then        --如果修改了原点的水平坐标
                ui_world_pos.x = ui.h_anchor == ANCHOR_MIDDLE and screen_w/2 + ui_world_pos.x or screen_w - ui_world_pos.x
            end
        end
        local origin_point = ui_world_pos - ui_local_pos    --原点坐标
        mouse_pos = mouse_pos - origin_point
        return Vector3(mouse_pos.x/ scale.x, mouse_pos.y/ scale.y, mouse_pos.z/ scale.z)    --鼠标相对于UI父级坐标的局部坐标
    end
    -- 修改官方的鼠标跟随，以适应所有情况(垃圾科雷)
    self.FollowMouse = function(_self)
        if _self.followhandler == nil then
            _self.followhandler = TheInput:AddMoveHandler(function(x, y)
                local loc_pos = GetMouseLocalPos(_self, Vector3(x, y, 0))    --主要是将原本的x,y坐标进行了坐标系的转换，使用转换后的坐标来更新widget位置
                _self:UpdatePosition(loc_pos.x, loc_pos.y)
            end)
            _self:SetPosition(GetMouseLocalPos(_self, TheInput:GetScreenPosition()))
        end
    end
end
AddClassPostConstruct("widgets/widget", ModFollowMouse)

---------正则匹配-------2021-11-25
--必传 stringData 需要匹配的字符串  regular 正则表达式---------
local function regularMatching(stringData,regular)
	local result = {}
	local _ = string.gsub(stringData,regular,function(value) table.insert(result,value) end)
	return result
end
regularMatching("字符串_2323","[^_]+")

---------真实的世界坐标 GetWorldRealPosition-------2021-12-01
-----ui设置偏移 界面大小 原点后 GetPosition往往拿的都是偏移后的,重新设定一个函数来获取真实的坐标
local function GetWorldRealPosition(self)
    self.GetWorldRealPosition = function()
        local old_sva = self.SetVAnchor
        self.SetVAnchor = function (_self, anchor)
            self.v_anchor = anchor
            return old_sva(_self, anchor)
        end
        local old_sha = self.SetHAnchor
        self.SetHAnchor = function (_self, anchor)
            self.h_anchor = anchor
            return old_sha(_self, anchor)
        end
        local g_s = self:GetScale() --全局缩放值
        local l_s = Vector3(0,0,0)
        l_s.x, l_s.y, l_s.z = self:GetLooseScale()--本身的缩放值
        local scale = Vector3(g_s.x/l_s.x, g_s.y/l_s.y, g_s.z/l_s.z)    --父级的全局缩放值
        local ui_local_pos = self:GetPosition() --ui的相对位置（也就是SetPosition的时候传递的坐标）
        ui_local_pos = Vector3(ui_local_pos.x * scale.x, ui_local_pos.y * scale.y, ui_local_pos.z * scale.z)
        local ui_world_pos = self:GetWorldPosition()
   -- 如果修改过ui的屏幕原点，就重新计算ui的屏幕坐标（基于左下角为原点的）
        if not (not self.v_anchor or self.v_anchor == ANCHOR_BOTTOM) or not (not self.h_anchor or self.h_anchor == ANCHOR_LEFT) then
            local screen_w, screen_h = TheSim:GetScreenSize()        --获取屏幕尺寸（宽度，高度）
            if self.v_anchor and self.v_anchor ~= ANCHOR_BOTTOM then    --如果修改了原点的垂直坐标
                ui_world_pos.y = self.v_anchor == ANCHOR_MIDDLE and screen_h/2 + ui_world_pos.y or screen_h - ui_world_pos.y
            end
            if self.h_anchor and self.h_anchor ~= ANCHOR_LEFT then        --如果修改了原点的水平坐标
                ui_world_pos.x = self.h_anchor == ANCHOR_MIDDLE and screen_w/2 + ui_world_pos.x or screen_w - ui_world_pos.x
            end
        end
        local origin_point = ui_world_pos - ui_local_pos    --原点坐标
        local world_pos = self:GetWorldPosition() - origin_point
        return Vector3(world_pos.x/ scale.x, world_pos.y/ scale.y, world_pos.z/ scale.z)    --鼠标相对于UI父级坐标的局部坐标
    end
end
AddClassPostConstruct("widgets/widget", GetWorldRealPosition)

---------冰冻目标-------2021-11-29
--必传 target 冻结目标  coldness 冰冻值(影响冻结 一般10以内)---------
local function frozenTargetFn(target,coldness) --冰冻目标函数
    if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then --目标有睡眠组件 且目标是睡着的
        target.components.sleeper:WakeUp() --惊醒
    end
    if target.components.burnable ~= nil then --目标有可燃烧组件
        if target.components.burnable:IsBurning() then --是否在燃烧的
            target.components.burnable:Extinguish() --熄灭（水火不融）
        elseif target.components.burnable:IsSmoldering() then --是否是缓燃的
            target.components.burnable:SmotherSmolder() --缓燃
        end
    end
    if target.components.combat ~= nil then --目标拥有攻击组件
        target.components.combat:SuggestTarget(attacker) --建议目标 攻击者
    end
    if target.sg ~= nil and not target.sg:HasStateTag("frozen") then --目标有sg且没有冻结的状态标记
        target:PushEvent("attacked", { attacker = target, damage = 0 })--推动事件 攻击
    end
    if target.components.freezable ~= nil and target.components.health.currenthealth >0 then --目标有可冻结组件且存活
       target.components.freezable:AddColdness(coldness) --加冷使其冰冻（看生物的抗性,基本上10就够了）
		target.components.freezable:SpawnShatterFX()--生成粉碎效果
    end
end

---------Widget鼠标移入移出替换图片---------2021-12-11 仅限ImageButtom
--必传 self 需要改变的UI  移入的图片路径   移出的图片路径 注意SetTexture其实有三个传参 default_tex 不怎么用
--选传 outAtlas,outTex 默认值为移入前的图标图片
local function WidgetSetMouseOverAndOutImage(self,overAtlas,overTex,outAtlas,outTex)
    if outAtlas == nil then outAtlas = self.image.atlas end
    if outTex == nil then outTex = self.image.texture end
    self:SetOnGainFocus(function() --获取获取焦点的fn
        self.image:SetTexture(overAtlas,overTex)
    end)
    self:SetOnLoseFocus(function() --移出焦点的fn
        self.image:SetTexture(outAtlas,outTex)
    end)
end

-- imagebutton设置文字 鼠标移入文字不会跟随变大的问题 2021-12-18
local SetOnGainFocus = function(self)
    local old_OnGainFocus = self.OnGainFocus
    local old_OnLoseFocus =self.OnLoseFocus
    self.OnGainFocus = function(_self)
        if self.image_focus == self.image_normal and self.scale_on_focus and self.focus_scale then
            self.text:SetScale(self.focus_scale[1], self.focus_scale[2], self.focus_scale[3])
        end
        return old_OnGainFocus(_self)
    end
    self.OnLoseFocus =function(_self)
        if self.image_focus == self.image_normal and self.scale_on_focus and self.normal_scale then
            self.text:SetScale(self.normal_scale[1], self.normal_scale[2], self.normal_scale[3])
        end
        return old_OnLoseFocus(_self)
    end
end
AddClassPostConstruct("widgets/imagebutton", SetOnGainFocus)

---------工具修复---------2022/1/24
---------前置条件-耐久小于100%---------
--必传 inst 修复物 give 给过来的物品名称(接收物品 也可以直接为false不进行判断,会扣除数量 默认为1)
--选传 number 修复数量(默认10) item 人物(传参后默认说话) give_number 扣除物品数量(默认1)
local function finiteuses_repair(inst,give,number,item,give_number)
	if inst.components.finiteuses then
		if not number then number = 10 end
		if inst.components.finiteuses:GetPercent() >= 1 and item then item.components.talker:Say('耐久已满无需修复') do return end end
		if give then give.components.stackable:Get(1):Remove() else give:Remove() end
		if number + inst.components.finiteuses.current <= inst.components.finiteuses.total then
			inst.components.finiteuses.current = (number + inst.components.finiteuses.current)
		else
			inst.components.finiteuses.current = inst.components.finiteuses.total
		end
		if item then item.components.talker:Say('成功修复了'..number..'点耐久') end
		inst.components.finiteuses:SetPercent(inst.components.finiteuses:GetPercent())
	end
end

---------护甲修复---------2022/1/24
---------前置条件-耐久小于100%---------
--必传 inst 修复物 give 给过来的物品名称(接收物品 也可以直接为false不进行判断,会扣除give 默认为1)
--选传 number 修复数量(默认10) item 人物(传参后默认说话) give_number 扣除give数量(默认1)
local function armor_repair(inst,give,number,item,give_number)
	if inst.components.armor then
		if not number then number = 10 end
		if not give_number then give_number = 1 end
		if inst.components.armor:GetPercent() >= 1 and item then item.components.talker:Say('护甲耐久已满无需修复') do return end end
		if give then give.components.stackable:Get(give_number):Remove() else give:Remove() end
		if number + inst.components.armor.condition <= inst.components.armor.maxcondition then
			inst.components.armor.condition = (number + inst.components.armor.condition)
		else
			inst.components.armor.condition = inst.components.armor.maxcondition
		end
		if item then item.components.talker:Say('成功修复了护甲'..number..'点耐久') end
		inst.components.armor:SetPercent(inst.components.armor:GetPercent())
	end
end



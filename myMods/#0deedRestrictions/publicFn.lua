-- GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
--------- UI拖拽适配---------
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

---------UI图标拖拽---------2021/11/24 （注意 这里需要加上UI拖拽适配）
--必传 Parent 父级Ui  subset 需要拖拽的ui---------
--选传 overFnDown,overFnUP 结束拖拽前后触发的fn Key 拖拽触发的按钮(默认右键)
--isMoveToFront 是否搬到前面 additionalFn 按键前判定附加函数是否正确---------
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

GLOBAL.draggable = draggable

local regularMatching = function(stringData,regular)
	local result = {}
	local _ = string.gsub(stringData,regular,function(value) table.insert(result,value) end)
	return result
end
GLOBAL.regularMatching = regularMatching

---------真实的世界坐标 GetWorldRealPosition-------2021-12-01
-----ui设置偏移 界面大小 原点后 GetPosition往往拿的都是假坐标,重新设定一个函数来获取真实的坐标
local GetWorldRealPosition = function(self)
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

---------Widget鼠标移入移出替换图片---------2021/12-11 仅限ImageButtom
--必传 self 需要改变的UI  移入的图片路径   移出的图片路径 注意SetTexture其实有三个传参 default_tex 不怎么用
--选传 outAtlas,outTex 默认值为移入前的图标图片 
local WidgetSetMouseOverAndOutImage = function(self,overAtlas,overTex,outAtlas,outTex)
    if outAtlas == nil then outAtlas = self.image.atlas end
    if outTex == nil then outTex = self.image.texture end
    self:SetOnGainFocus(function() --获取获取焦点的fn
        self.image:SetTexture(overAtlas,overTex)
    end)
    self:SetOnLoseFocus(function() --移出焦点的fn
        self.image:SetTexture(outAtlas,outTex)
    end)
end
GLOBAL.WidgetSetMouseOverAndOutImage = WidgetSetMouseOverAndOutImage
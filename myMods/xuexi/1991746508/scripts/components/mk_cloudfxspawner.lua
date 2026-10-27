
local offsets = {}
for i = 1,6 do
    table.insert(offsets,Vector3(math.cos(i*6.283/6),0,math.sin(i*6.283/6)))
end

local offsets_lz = {}
for i = 1,12 do
    table.insert(offsets_lz,Vector3(math.cos(i*6.283/12),0.5,math.sin(i*6.283/12)))
end
for i = 1,6 do
    table.insert(offsets_lz,Vector3(0.5*math.cos(i*6.283/6),0.5,0.5*math.sin(i*6.283/6)))
end

local offsets_qn = {}
for i = 1,12 do
    table.insert(offsets_qn,Vector3(math.cos(i*6.283/12),0,math.sin(i*6.283/12)))
end
for i = 1,6 do
    table.insert(offsets_qn,Vector3(math.cos(i*6.283/6),0,math.sin(i*6.283/6)))
end

local Cloud = Class(function(self, inst)
    self.inst = inst
    self.clouds = {}
    self.tails = {}
    self.first = true
    self.canspawn = true

    inst:ListenForEvent('ondropped',function()self:OnExitLimbo()end)
    inst:ListenForEvent('exitlimbo',function()self:OnExitLimbo()end)
    inst:ListenForEvent('enterlimbo',function()self:OnEnterLimbo()end)
    inst:DoTaskInTime(0,function()
        if self.first then
            self:CreateClouds() 
         end
    end)
    --self.tailtask = self.inst:DoPeriodicTask(0.1,function()self:CreateTails()end)
end)

function Cloud:CreateClouds()
    if not self.canspawn then
        return
    end
    if self.inst:HasTag('INLIMBO') then
        return
    end
    for k,v in pairs(self.qn and offsets_qn or (self.laozi and offsets_lz or offsets))do
        local fx = SpawnPrefab('mk_cloudfx')
        local s = (math.mod(k,2) == 0 and 1 or .8)*(self.qn and 1.2 or self.laozi and 1.5 or 1)
        fx.AnimState:PlayAnimation('anim_loop',true)
        fx.AnimState:SetTime(2*math.random())
        fx.AnimState:SetFinalOffset(-3)
        fx.AnimState:SetDeltaTimeMultiplier(GetRandomMinMax(.9,1.1))
        fx.Transform:SetPosition((v*(self.qn and 1 or self.laozi and 1.4 or 0.7)):Get())
        fx.Transform:SetScale(s,s,s)
        fx.entity:SetParent(self.inst.entity)
        fx.cloud = self.inst
        if self.laozi then
            fx:ScaleFnLz()
            fx:AddTag('FX')
            fx:AddTag("NOCLICK")
        elseif self.qn then
            fx:ScaleFnQN()
            fx:AddTag('FX')
            fx:AddTag("NOCLICK")
        else
            fx:ScaleFn()
        end
        self.clouds[fx] = true
    end
end

function Cloud:RemoveClouds()
    for k in pairs(self.clouds)do
        if k:IsValid() then
            k:Remove()
        end
    end
end

function Cloud:OnRemoveEntity()
    for k,v in pairs(self.clouds)do
        if k:IsValid() then
            k.entity:SetParent(nil)
            k.AnimState:PlayAnimation('anim_fade')
            k:ListenForEvent("animover",k.Remove)
        end
    end
end

function Cloud:OnEnterLimbo()
    self:RemoveClouds()
end

function Cloud:OnExitLimbo()
    self:CreateClouds()
end

function Cloud:StartTween(...)
    for k,v in pairs(self.clouds)do
        if not k.components.colourtweener then
            k:AddComponent('colourtweener')
        end
        k.components.colourtweener:StartTween(...)
    end
end

return Cloud
local assets =--assets 加载资源表
{
    Asset("ANIM", "anim/liandao.zip"),--动画资源 放在地上
    Asset("ANIM", "anim/swap_liandao.zip"),--动画资源 拿在手里
	Asset("IMAGE", "images/inventoryimages/liandao.tex"),--物品栏图标的xml
    Asset("ATLAS", "images/inventoryimages/liandao.xml"),--图片文档 用于物品栏图片
}

local function gxfumo(inst)--更新附魔的效果
    inst.components.weapon:SetDamage(66 + inst.wuqi_fumo_ll)
end

local function zb(inst, owner)-- 装备回调函数
    owner.AnimState:OverrideSymbol("swap_object", "swap_liandao", "liandao")--这三句都是设置动画表现的
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    owner.DynamicShadow:SetSize(1.7, 1)--设置阴影大小
	gxfumo(inst)--更新附魔的效果
	if inst.wuqi_fumo_ll ~= 0 then
		GetPlayer().components.talker:Say("附魔后伤害是 " .. 66 + inst.wuqi_fumo_ll .. " 点")
	end
end

local function xz(inst, owner)-- 卸载回调函数
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.DynamicShadow:SetSize(1.3, 0.6)
end

local function fulan(inst)-- 耐久度归零回调函数
    inst:Remove()
end

local function OnLoad(inst, data)
	if data then
	inst.wuqi_fumo_ll = data.wuqi_fumo_ll
	gxfumo(inst)--更新附魔的效果
	end
end

local function onsave(inst, data)
	data.wuqi_fumo_ll = inst.wuqi_fumo_ll
end

local function onpreload(inst, data)
	if data then
	inst.wuqi_fumo_ll = data.wuqi_fumo_ll
	end
end

local function fn()--描述函数
    local inst = CreateEntity()--创建实体
	local trans = inst.entity:AddTransform()--添加变换组件
	local anim = inst.entity:AddAnimState()--添加动画组件
	MakeInventoryPhysics(inst)--添加物理属性

    anim:SetBank("liandao")--设置动画的Bank，也就是动画内容组合
    anim:SetBuild("liandao")--设置动画的Build，也就是外表材质
    anim:PlayAnimation("idle")--设置生成时应该播放的动画
	---------------------- 通用组件 -------------------------
	inst:AddComponent("inspectable")--可检查
    inst:AddComponent("inventoryitem")--可放入物品栏
	inst.components.inventoryitem.atlasname = "images/inventoryimages/liandao.xml"--设置物品栏图片文档。官方内置的物体有默认的图片文档，所以不需要设置这一项，但自己额外添加的物体使用自己的图片文档，就应该设置这一项
    inst:AddComponent("equippable")--可装备
    inst.components.equippable:SetOnEquip( zb )--设置装备时的回调函数
    inst.components.equippable:SetOnUnequip( xz )--设置卸载时的回调函数
	------------------------ 附魔 ---------------------------
	inst.wuqi_fumo_ll = 0--附魔力量
	---------------------- 伤害组件 -------------------------
	inst:AddComponent("weapon")--武器组件
    inst.components.weapon:SetDamage(66)--攻击力
   	inst.components.weapon:SetRange(1, 1)--攻击距离
	---------------------- 保存组件 -------------------------
	inst.OnLoad = OnLoad
    inst.OnSave = onsave
    inst.OnPreLoad = onpreload
    return inst
end

return Prefab("common/inventory/liandao", fn, assets)--Prefab(物体名，描述函数，加载资源表）
local MakePlayerCharacter = require("prefabs/player_common")

local assets =
{
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
    Asset("SOUND", "sound/winona.fsb"),
}

local prefabs =
{
    ---"sewing_tape",
}

local start_inv =
{
   -- "sewing_tape",
  --  "sewing_tape",
   -- "sewing_tape",
}



local function huan_rao(mubiao, kai_shi_dian)
	local inst = mubiao 										--获取玩家
	local juli = 3.5													--设定环绕需要的距离
	local t = {}													--创建一个表格
																	--开始创建圆周环绕坐标
	for i=0,360,5 do												--从0° 至 360°  每次增加5°  总计会生成 360/5 = 72个坐标， 如果5设置小点，环绕运行的速度就慢
		local j = Vector3(math.cos(math.rad(i))*juli, 2, math.sin(math.rad(i))*juli) 
		table.insert(t, j)
	end

	inst._qmt = t													--把创建好的坐标域赋值到玩家身上
	inst._qms = kai_shi_dian or 3									--坐标指针， 1代表从t表里的t[1]位置开始绕，如果需要三颗，可以同时设置一个72/3 = 24  【1,24+1,24+24+1】 平分3个位置开始点
	inst._wupin = SpawnPrefab("opalpreciousgem")					--创建一个预设物实体
																	--创建循环计时器
																	
	inst._kaishi = inst:DoPeriodicTask(0.01, function()
		if inst and inst:IsValid() and inst._qmt and inst._wupin and inst._wupin:IsValid() then				--这些是简单的保护，实际运行中，还需要更多的保护，比如物品是否被拿起之类的
			if inst._qms >= #inst._qmt then
				inst._qms = 1																				--这里是判定指针指向的坐标保护， 数值不能超出坐标域的最大值，不然获取坐标时会获取nil值
			end
			local pos = inst:GetPosition()																	--获取玩家的三维向量坐标
			local pop = inst._qmt[inst._qms]																--获取坐标域里的指向坐标
			local poq = pos + pop																			--把前2个坐标想加， 得到当前位置的下一个偏移位置坐标
			inst._wupin.Transform:SetPosition(poq:Get())													--设定坐标
			inst._qms = inst._qms + 1
		end
	end, 0)
end










local function common_postinit(inst)
    inst:AddTag("handyperson")
    inst:AddTag("fastbuilder")
	---inst:AddTag("renwu1")
end

local function master_postinit(inst)
    inst.components.grue:SetResistance(1)
	inst.renwu = 0
	huan_rao(inst,1)			--从0°开始一个
	--huan_rao(inst,24)			--从24*5 = 120°开始一个
	--huan_rao(inst,48)			--从48*5 = 240°开始一个
	
end

return MakePlayerCharacter("winona", prefabs, assets, common_postinit, master_postinit, start_inv)

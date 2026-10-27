
if GLOBAL.TheNet:IsDedicated() then

--[[
建筑放置:
这里是建筑物数量限制表，如要修改，直接修改P = 后面的数字即可，V是备用选项，暂不生效
]]

local JZB = {
	["pighouse"] =				{ P = 3, V = 4 },       --猪房
	["rabbithouse"] =			{ P = 3, V = 4 },       --兔房
	["beebox"] =				{ P = 3, V = 4 },       --蜂箱
	["slow_farmplot"] =			{ P = 4, V = 5 },       --普通农田
	["fast_farmplot"] =			{ P = 4, V = 5 },       --高级农田
	["firepit"] =				{ P = 5, V = 6 },       --石头营火
	["coldfirepit"] =			{ P = 5, V = 6 },       --石头冷火
	["cookpot"] =				{ P = 10, V = 11 },     --锅
	["winterometer"] =			{ P = 2, V = 3 },       --寒冰温度计
	["rainometer"] =			{ P = 2, V = 3 },       --雨量计
	["siestahut"] =				{ P = 5, V = 6 },       --午睡小屋
	["tent"] =					{ P = 5, V = 6 },       --帐篷
	["homesign"] =				{ P = 5, V = 6 },       --木牌
	["arrowsign_post"] =		{ P = 5, V = 6 },       --路牌
	["birdcage"] =				{ P = 5, V = 6 },       --鸟笼
	["meatrack"] =				{ P = 15, V = 16 },     --晾肉架
    ["lightning_rod"] =			{ P = 5, V = 6 },       --避雷针
	["nightlight"] =			{ P = 6, V = 7 },       --暗夜照明灯
	["researchlab"] =			{ P = 3, V = 4 },       --科学机器
	["researchlab2"] =			{ P = 3, V = 4 },       --炼金术引擎
	["researchlab3"] =			{ P = 3, V = 4 },       --阴影操纵者
	["researchlab4"] =			{ P = 3, V = 4 },       --灵子分解器
	["resurrectionstatue"] = 	{ P = 2, V = 3 },       --肉块雕像
	["telebase"] =				{ P = 5, V = 6 },       --传送核心
	["dragonflyfurnace"] =		{ P = 2, V = 3 },       --龙鳞火炉
	["sentryward"] =			{ P = 2, V = 3 },       --真眼
	["minisign_item"] =			{ P = 20, V = 21 },     --小木牌
	["mushroom_farm"] =			{ P = 10, V = 11 },     --蘑菇机
	["mushroom_light"] =		{ P = 10, V = 11 },     --荧菇灯
	["mushroom_light2"] =		{ P = 10, V = 11 },     --炽菇灯
	["cartographydesk"] =		{ P = 2, V = 3 },       --制图师桌子
	["sculptingtable"] =		{ P = 2, V = 3 },       --国际象棋
	["scarecrow"] =				{ P = 10, V = 11 },     --稻草人
	["winter_treestand"] =		{ P = 10, V = 11, T = {"winter_tree","winter_deciduoustree","winter_twiggytree"} },     --圣诞树盆
	["endtable"] =				{ P = 5, V = 6 },     --茶几
	["moondial"] =				{ P = 5, V = 6 },     --月盘
	["saltlick"] =				{ P = 2, V = 3 },       --盐舐砖
	["firesuppressor"] =		{ P = 5, V = 6 },       --灭火器
	["wardrobe"] =				{ P = 6, V = 7 },       --衣柜
}

---------------------------------------------------------
	local old_BUILD = GLOBAL.ACTIONS.BUILD.fn
	GLOBAL.ACTIONS.BUILD.fn = function(act)
		if act.doer and act.doer.Network:IsServerAdmin() then
			return old_BUILD(act)
		end
		if act.doer and act.doer.userid and act.recipe and JZB[act.recipe] ~= nil then
			local shu = 0
			local ena = GLOBAL.TheSim:FindEntities(0,0,0,9000)
			for k,v in pairs(ena) do
				if v and (v.prefab == act.recipe or JZB[act.recipe].T ~= nil and GLOBAL.table.contains(JZB[act.recipe].T, v.prefab))
				and v.ownerlist and v.ownerlist.master ~= nil and v.ownerlist.master == act.doer.userid then
					shu = shu + 1
				end
			end
			local panding = JZB[act.recipe].P
			if shu >= panding then
				if act.doer ~= nil and act.doer.components.talker then
					act.doer:DoTaskInTime(0,function()
						act.doer.components.talker:Say("✿二月锁 : 超出规定可建造数量"..(JZB[act.recipe].P or 5).."✿",5) end)
					return
				end
			end
		end
		local panding = false
		local ztt = GLOBAL.c_find("atrium_gate")
		if not ztt then
			panding = true
		elseif act.recipe and (act.recipe ~= "campfire" or act.recipe ~= "coldfire") then
			local x,y,z = ztt.Transform:GetWorldPosition()
			local julli = math.sqrt(act.doer:GetDistanceSqToPoint(x,y,z))
			if julli and julli <= 30 then
				panding = false
			else
				panding = true
			end
		end

		if not panding then
			if act.doer ~= nil and act.doer.components.talker then
				act.doer:DoTaskInTime(0,function()
					act.doer.components.talker:Say("✿二月锁 : 当前位置处于中庭３０码保护区,禁止建造✿",5) end)
				return
			end
		end
	    return old_BUILD(act)
	end

---建造限制有关参数--------------------------

local _wall = {"wall_hay","wall_wood","wall_stone","wall_ruins","fence","fence_gate"}
for k,v in pairs(_wall) do
	AddPrefabPostInit(v,function(inst)
		if inst.Physics then
			inst.Physics:SetCollisionGroup(GLOBAL.COLLISION.CHARACTERS)
		end
	end)
end

local function OnIDC(inst)
	if not inst then return end
	if inst._zdm ~= nil then 
        inst._zdm:Cancel() 
        inst._zdm = nil 
    end
	if inst.IDC and (type(inst.IDC) == "string" or type(inst.IDC) == "table") then
		inst._zdm = inst:DoPeriodicTask(.2, function() 
			local x1,y1,z1 = inst.Transform:GetWorldPosition() 
			local ents = {} 
			local ents = GLOBAL.TheSim:FindEntities(x1,y1,z1, 3,{ "player" }) 
			local D = nil 
			if ents[1] ~= nil then 
				for k,v in pairs(ents) do 
					if v and (type(inst.IDC) == "string" and v.userid == inst.IDC or type(inst.IDC) == "table" and GLOBAL.table.contains(inst.IDC, v.userid)) and not D then 
						D = true 
						break 
					end 
				end 
			end 
			if D and not inst._zdm_a then 
				inst.AnimState:SetMultColour(0, 0, 0, 0) 
				inst.Physics:SetActive(false) 
				inst:AddTag("NOBLOCK") 
				inst:AddTag("NOCLICK") 
				inst._zdm_a = true 
				GLOBAL.SpawnPrefab("lightning_rod_fx").Transform:SetPosition(x1,y1,z1) 
			elseif not D and inst._zdm_a then 
				inst.AnimState:SetMultColour(1, 1, 1, 1) 
				inst.Physics:SetActive(true) 
				inst:RemoveTag("NOBLOCK") 
				inst:RemoveTag("NOCLICK") 
				inst._zdm_a = nil 
				GLOBAL.SpawnPrefab("lightning_rod_fx").Transform:SetPosition(x1,y1,z1) 
			end 
		end) 
	end
end

local function OnSave_qm9(inst,data)
	if inst.OldOnSave_qm9 ~= nil then
		inst.OldOnSave_qm9(inst,data)
	end
	if inst.IDC ~= nil then
	    data.IDC = inst.IDC
	end
end

local function OnLoad_qm9(inst,data)
	if inst.OldOnLoad_qm9 ~= nil then
		inst.OldOnLoad_qm9(inst,data)
	end
	if data ~= nil and data.IDC then
	    inst.IDC = data.IDC
		if inst._OnIDC ~= nil then
			inst:_OnIDC()
		end
	end
end

AddPrefabPostInit("basalt_pillar",function(inst)
	if inst.Physics then
		inst.Physics:SetCollisionGroup(GLOBAL.COLLISION.CHARACTERS)
	end
	inst.IDC = nil
	inst._OnIDC = OnIDC
	inst.OldOnSave_qm9 = inst.OnSave
	inst.OnSave = OnSave_qm9
	inst.OldOnLoad_qm9 = inst.OnLoad
	inst.OnLoad = OnLoad_qm9
end)





end
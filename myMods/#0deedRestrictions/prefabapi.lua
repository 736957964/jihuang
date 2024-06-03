
local _G = GLOBAL

_G.RedirectPrefab = {} --所有的数据都存在这了
_G.RedirectWeapon = {}

_G.MyPrefab = function(name, basename, fn)	
    return {name = name, basename = basename, fn = fn}
end
_G.MyPrefab2 = function(name, basename, fn , assets , deps )	
    return {{name = name, basename = basename, fn = fn, assets = assets,deps = deps}}
end
_G.MyWeapon = function(name, fn)	
    return {name = name, fn = fn}
end

_G.MakeMyPrefab = function(inst, modifierfn)
    inst.specialdata = {}
    inst.SpecialInit = function(inst, name, ...)
        if _G.RedirectPrefab[name] == nil then
            inst:Remove()
            return
        end

        inst.myprefabname = name
        inst.specialdata.myprefabname = name
        inst.specialdata.myprefaboverride = name

        if modifierfn ~= nil then
            modifierfn(inst)
        end

        _G.RedirectPrefab[name].fn(inst, ...)
    end

    local OldOnSave = inst.OnSave --保存当前的预设物
    inst.OnSave = function(inst, data)
        if OldOnSave ~= nil then
            OldOnSave(inst, data)
        end
        data.specialdata = {}
        for k, v in pairs(inst.specialdata) do
            data.specialdata[k] = v
        end
    end

    local OldOnPreLoad = inst.OnPreLoad --加载当前的预设物
    inst.OnPreLoad = function(inst, data)
        if OldOnPreLoad ~= nil then
            OldOnPreLoad(inst, data)
        end
        if data ~= nil and data.specialdata ~= nil and data.specialdata.myprefabname ~= nil then
            inst:SpecialInit(data.specialdata.myprefabname, data.specialdata)
        end
    end
end

----------------------熔炉加载模块---------------------------
local correspondingtable = {
    longmulti = "blowdart_lava",
    long = "blowdart_lava2",
    aoesummon = "book_elemental",
    aoe = "fireballstaff",
    aoeheal = "healingstaff",
    aoesmall = "lavaarena_firebomb",
    arc = "lavaarena_heavyblade",
    line = "spear_gungnir",
	spear = "spiralspear"
}

local function checkandadd(inst, component)
    if inst.components[component] == nil then
        inst:AddComponent(component)
    end
end

local function makebasicweapon(inst)
    checkandadd(inst, "weapon") --武器
    checkandadd(inst, "inspectable") --可检查
    checkandadd(inst, "inventoryitem") --库存
    checkandadd(inst, "equippable") --可装备
    checkandadd(inst, "named") --名字
    checkandadd(inst, "tradable") --可交易
	checkandadd(inst, "lczy_rechargeable") --cd组件
	inst.components.rechargeable = inst.components.lczy_rechargeable --避免跟其他cd组件冲突
	
    inst:RemoveTag("aoeweapon_lunge")
    inst:RemoveTag("blowdart")
    inst:RemoveTag("throw_line")
    inst:RemoveTag("book")
    inst:RemoveTag("firestaff")
    inst:RemoveTag("parryweapon")

    inst.specialdata = {}

    inst.SpecialInit = function(inst, name, ...)
        if GLOBAL.RedirectWeapon[name] == nil then
            print("no corresponding init function")
            inst:Remove()
            return
        end

        inst.myprefabname = name
        inst.specialdata.myprefabname = name
        inst.specialdata.myprefaboverride = name
        -- GLOBAL.RedirectWeapon[name](inst, ...) --相当于把熔炉武器套了一下样子 实现客机显示范围 如果是正常写法 客机需要装所有人mod才能显示出来（弃用 直接利用prefab设置了）
    end

    inst.ChangeType = function(inst, mode)
        local newweapon =
            GLOBAL.SpawnMyWeapon(
            string.sub(inst.specialdata.myprefabname, 1, string.find(inst.specialdata.myprefabname, "_")) .. mode
        )
        if newweapon ~= nil then
            local entdata = inst:GetPersistData()
            if entdata ~= nil then
                for k, v in pairs(entdata) do
                    local cmp = newweapon.components[k]
                    if cmp ~= nil and cmp.OnLoad ~= nil then
                        cmp:OnLoad(v)
                    end
                end
            end
            inst:Remove()
        end
        return newweapon
    end

    inst.OnSave = function(inst, data) --保存
        data.specialdata = {}
        for k, v in pairs(inst.specialdata) do
            data.specialdata[k] = v
        end
    end

    inst.OnPreLoad = function(inst, data) --加载
        if data ~= nil and data.specialdata ~= nil and data.specialdata.myprefabname ~= nil then
            inst:SpecialInit(data.specialdata.myprefabname, data.specialdata)
        end
    end
end

--武器加载模块
for k, v in pairs(correspondingtable) do
    AddPrefabPostInit(
        v,
        function(inst)
            if GLOBAL.TheNet:GetIsServer() then
                makebasicweapon(inst)
            end
        end
    )
end
----------------------熔炉加载模块---------------------------
-- c_mygive("pistol")
-- MySpawn("bazooka_aoe")

-- c_mygive("cannon")
_G.SpawnMyPrefab = function(name, ...)
    local baseprefab
    if _G.RedirectPrefab[name] ~= nil then
        baseprefab = _G.SpawnPrefab(_G.RedirectPrefab[name].basename)
    elseif string.find(name, "_") ~= nil and correspondingtable[string.sub(name, string.find(name, "_") + 1)] ~= nil then
        baseprefab = _G.SpawnPrefab(correspondingtable[string.sub(name, string.find(name, "_") + 1)])
    else
        print("no prefab")
        return
    end
    baseprefab:SpecialInit(name, ...)
    return baseprefab
end


_G.MySpawn = function(name, ...) -- MySpawn("pistol") 控制台调试 地上的   c_mygive("pistol") 背包的
    if GLOBAL.TheSim ~= nil and GLOBAL.TheInput ~= nil then
        local inst = GLOBAL.SpawnMyPrefab(name, ...)
        if inst ~= nil then
            inst.Transform:SetPosition(GLOBAL.ConsoleWorldPosition():Get())
            return inst
        else
            print("myspawn failed")
        end
    end
end

_G.MakeCommonWeapon = function(inst, name, describe, melee, equipdata)  --武器的
	checkandadd(inst,"inspectable") --可检查
	checkandadd(inst,"inventoryitem") --可库存
	checkandadd(inst,"named") --名称
	checkandadd(inst,"equippable") --可装备组件
	checkandadd(inst,"weapon") --武器组件
	
    inst.components.equippable:SetOnEquip( --装备的时候触发
        function(inst, owner)
            owner.AnimState:OverrideSymbol(_G.unpack(equipdata))
            owner.AnimState:Show("ARM_carry")
            owner.AnimState:Hide("ARM_normal")
        end
    )
    inst.components.equippable:SetOnUnequip( --卸载的时候触发
        function(inst, owner)
            owner.AnimState:Hide("ARM_carry")
            owner.AnimState:Show("ARM_normal")
        end
    )
 
	if name ~= nil then inst.components.named:SetName(name)  else inst.components.named:SetName("特殊的武器") end
    inst.components.named.nopersist = true

	if describe~=nil then inst.components.inspectable:SetDescription(describe) else  inst.components.inspectable:SetDescription("特殊的产物") end
    inst.components.inventoryitem:SetSinks(false)
	
	inst.components.weapon:SetDamage(33)--默认伤害
	inst.components.weapon:SetRange(28, 30)--默认范围
end

_G.RandomPerson = function(inst) --随机模型人物
	local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78","wathgrithr","webber","waxwell","winona","warly"}
    local buildname = names[math.random(#names)] 
	inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild(buildname) --人物形象
	local hats = {"hat_bee","hat_beefalo","hat_bush","hat_feather","hat_flower","hat_football","hat_miner","hat_ruins","hat_slurper","hat_slurtle","hat_spider","hat_straw","hat_top","hat_walrus","hat_winter","hat_rain","hat_watermelon","hat_ice","hat_catcoon","hat_wathgrithr"}
    local hat = hats[math.random(#hats)] 
    inst.AnimState:OverrideSymbol("swap_hat", hat, "swap_hat")--帽子
	local armors = {"armor_grass","armor_marble","armor_onemanband","armor_ruins","armor_sanity","armor_slurper","armor_slurtleshell","armor_sweatervest","armor_trunkvest_summer","armor_trunkvest_winter","armor_wood","torso_rain"}
    local armor = armors[math.random(#armors)]
    inst.AnimState:OverrideSymbol("swap_body", armor, "swap_body") --衣服
	local wuqis = {"swap_goldenaxe","swap_spear","swap_spike","swap_batbat","swap_ruins_bat"} 
	local wuqi = wuqis[math.random(#wuqis)]
	inst.AnimState:OverrideSymbol("swap_object", wuqi, wuqi)  -- 武器
	inst.Transform:SetRotation(135) --默认角度
	inst.AnimState:Show("HAT")            
    inst.AnimState:Show("HAT_HAIR")
	inst.AnimState:Show("ARM_normal")
	inst.AnimState:Hide("HAIR_NOHAT")--隐藏头发和帽子（不然会有重叠）
	inst.AnimState:Hide("HAIR")--隐藏头发
	inst.Transform:SetFourFaced()--正常人物都是4面
	if not inst.components.named then inst:AddComponent("named") end	--名字组件	
	inst.components.named:SetName("模型人物")
	local stories = {"idle_loop"} --原地休息 空闲循环
    local story = stories[math.random(#stories)]
    inst.AnimState:PlayAnimation(story,true)
end


-- c_give("fireballstaff")
-- blowdart_lava 吹箭齐射 blowdart_lava2 融化吹箭 火球  book_elemental 召唤之书 fireballstaff 地狱魔杖
local pricsample ={ --通过这几个文件 把其他东西刷出来 必须要写  目前暂用 teleportato_potato
	"teleportato_potato", "teleportato_box", "teleportato_crank","teleportato_ring", --背包的
	"teleportato_base", --地上不能拿的
	"superjump_fx", --特效的
	 "pigman","bunnyman", --猪和兔子 用来显示白文字的
	"blowdart_lava","blowdart_lava2","book_elemental","fireballstaff","healingstaff","lavaarena_firebomb","lavaarena_heavyblade","spear_gungnir"--熔炉的
}
for i, v in ipairs(pricsample) do 
    AddPrefabPostInit(
        v,
        function(inst)
            if not _G.TheWorld.ismastersim then
                return
            end
			if v == "teleportato_base" then
				inst:AddTag("noRemove") --查找物品不删除标签
			end
            inst:RemoveTag("irreplaceable")
            inst:RemoveTag("teleportato_part")
			-- inst:RemoveTag("teleportato")
            _G.MakeMyPrefab(inst)
        end
    )
end

AddPlayerPostInit(function(inst) 
	if inst:HasTag("player") and not inst.components.buffable then
		inst:AddComponent("buffable") --所有人加一个buff 不加使用专用cd就会掉...
	end
end)

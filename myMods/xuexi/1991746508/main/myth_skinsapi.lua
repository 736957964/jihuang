
    local recipe_help = true
    local characterskins = {}
                      
    local skincharacters = {}

    local SKIN_AFFINITY_INFO = require("skin_affinity_info")
    function MakeCharacterSkin(base,skinname,data)
        data.type = nil
        if not skincharacters[base] then
            skincharacters[base] = true
        end
        characterskins[skinname] = data
        data.base_prefab = base
        data.rarity = data.rarity or "Loyal"
        data.build_name_override = data.build_name_override or skinname
        if not STRINGS.UI.RARITY[data.rarity] then
            STRINGS.UI.RARITY[data.rarity] = data.rarity
            SKIN_RARITY_COLORS[data.rarity] = data.raritycorlor or { 0.635, 0.769, 0.435, 1 }
            RARITY_ORDER[data.rarity] = data.rarityorder or -1
        end
        --注册到字符串
        STRINGS.SKIN_NAMES[skinname] = data.name or skinname
        STRINGS.SKIN_DESCRIPTIONS[skinname] = data.des or ""
        STRINGS.SKIN_QUOTES[skinname] = data.quotes or ""
        --注册到皮肤列表
        if not PREFAB_SKINS[base] then PREFAB_SKINS[base] = {} end
        table.insert(PREFAB_SKINS[base],skinname)
        if not SKIN_AFFINITY_INFO[base] then SKIN_AFFINITY_INFO[base] = {} end
        table.insert(SKIN_AFFINITY_INFO[base],skinname)
        
        --创建皮肤预制物
        local prefab_skin = CreatePrefabSkin(skinname,data)
        if data.clear_fn then
            prefab_skin.clear_fn = data.clear_fn 
        end
        prefab_skin.type = "base"
        RegisterPrefabs(prefab_skin)    --注册并加载皮肤的prefab
        TheSim:LoadPrefabs({skinname})
        return prefab_skin
    end
    local itemskins = {}
    local itembaseimage = {}
    function MakeItemSkinDefaultImage (base,atlas,image)
        itembaseimage[base] = { atlas,
                                    (image or base )..".tex",
                                  "default.tex"}
    end
    function MakeItemSkin(base,skinname,data)
        data.type = nil
        itemskins[skinname] = data
        data.base_prefab = base
        data.rarity = data.rarity or "Loyal"
        data.build_name_override = data.build_name_override or skinname
        if not STRINGS.UI.RARITY[data.rarity] then
            STRINGS.UI.RARITY[data.rarity] = data.rarity
            SKIN_RARITY_COLORS[data.rarity] = data.raritycorlor or { 0.635, 0.769, 0.435, 1 }
            RARITY_ORDER[data.rarity] = data.rarityorder or -1
        end
        STRINGS.SKIN_NAMES[skinname] = data.name or skinname
        STRINGS.SKIN_DESCRIPTIONS[skinname] = data.des or ""
        if not PREFAB_SKINS[base] then PREFAB_SKINS[base] = {} end
        table.insert(PREFAB_SKINS[base],skinname)
        if not PREFAB_SKINS_IDS[base] then
            PREFAB_SKINS_IDS[base] = {}
        end
        local index = 1
        for k,v in pairs(PREFAB_SKINS_IDS[base]) do
            index = index + 1
        end
        PREFAB_SKINS_IDS[base][skinname] = index
        data.skininit_fn = data.init_fn or nil
        data.skinclear_fn = data.clear_fn or nil
        data.init_fn  = function(i) basic_skininit_fn(i,skinname) end
        data.clear_fn  = function(i) basic_skinclear_fn(i,skinname) end 
        if data.skinpostfn  then
            data.skinpostfn(data)
        end
        local prefab_skin = CreatePrefabSkin(skinname,data)
        if data.clear_fn then
            prefab_skin.clear_fn = data.clear_fn 
        end
        prefab_skin.type = "item"
        RegisterPrefabs(prefab_skin)
        TheSim:LoadPrefabs({skinname})
        return prefab_skin
    end
    

	local mt = getmetatable(TheInventory)
    local oldTheInventoryCheckOwnership = TheInventory.CheckOwnership
	mt.__index.CheckOwnership  = function(i,name,...) 
		if type(name)=="string" and (characterskins[name] or itemskins[name]) then
            if characterskins[name] and characterskins[name].checkfn then
                return characterskins[name].checkfn(i,name,...)
            elseif itemskins[name] and itemskins[name].checkfn then
                return itemskins[name].checkfn(i,name,...)
            else
                return true 
            end
		else
			return oldTheInventoryCheckOwnership(i,name,...)
		end
	end
	local oldTheInventoryCheckOwnershipGetLatest = TheInventory.CheckOwnershipGetLatest
    mt.__index.CheckOwnershipGetLatest  = function(i,name,...) 
		if type(name)=="string" and (characterskins[name] or itemskins[name]) then
            if characterskins[name] and characterskins[name].checkfn then
                return characterskins[name].checkfn(i,name,...)
            elseif itemskins[name] and itemskins[name].checkfn then
                return itemskins[name].checkfn(i,name,...)
            else
                return true,0 
            end
		else
			return oldTheInventoryCheckOwnershipGetLatest(i,name,...)
		end
	end
    
	local oldTheInventoryCheckClientOwnership = TheInventory.CheckClientOwnership
	mt.__index.CheckClientOwnership  = function(i,userid,name,...) 
		if type(name)=="string"  and (characterskins[name] or itemskins[name]) then
			if characterskins[name] and characterskins[name].checkclientfn then
                return characterskins[name].checkclientfn(i,userid,name,...)
            elseif itemskins[name] and itemskins[name].checkclientfn then
                return itemskins[name].checkclientfn(i,userid,name,...)
            else
                return true 
            end
		else
			return oldTheInventoryCheckClientOwnership(i,userid,name,...)
		end
	end
	
	local oldExceptionArrays = GLOBAL.ExceptionArrays
	GLOBAL.ExceptionArrays = function(ta,tb,...)
			local need
			for i=1,100,1 do
				local data = debug.getinfo(i,"S")
				if data then
					if data.source and data.source:match("^scripts/networking.lua") then
						need = true
					end
				else
					break
				end
			end
			if need then
				local newt = oldExceptionArrays(ta,tb,...)
                for k,v in pairs(skincharacters) do
                    table.insert(newt,k)		--偷渡
                end
				return newt
			else
				return oldExceptionArrays(ta,tb,...)
			end
	end
    local oldIsDefaultCharacterSkin = IsDefaultCharacterSkin
    GLOBAL.IsDefaultCharacterSkin = function(item,...)
        if item and characterskins[item] then
            if characterskins[item].checkfn then
                return characterskins[item].checkfn(nil,item)
            else
                return true
            end
        else
        return oldIsDefaultCharacterSkin(item,...)
        end
    end

    
	local function sorabaseenable(self)
		if self.name == "LoadoutSelect" then
            for k,v in pairs(skincharacters) do
                if not table.contains(DST_CHARACTERLIST,k) then
                    table.insert(DST_CHARACTERLIST,k)
                end
            end
		elseif	self.name == "LoadoutRoot" then
            for k,v in pairs(skincharacters) do
                if table.contains(DST_CHARACTERLIST,k) then
                    RemoveByValue(DST_CHARACTERLIST,k)
                end
            end
		end
	end
	AddClassPostConstruct("widgets/widget", sorabaseenable)
    
    AddComponentPostInit("skinner",function(self)
        local oldfn = self.SetSkinName
        if oldfn then
            function self.SetSkinName(s,skinname,...)
                local old = s.skin_name
                local new = skinname
                if characterskins[old] and characterskins[old].clear_fn then
                    characterskins[old].clear_fn(s.inst,old)
                end
                if characterskins[new] and characterskins[new].init_fn then
                    characterskins[new].init_fn(s.inst,new)
                end
                oldfn(s,skinname,...)
            end
        end
    end)

    AddClassPostConstruct("widgets/recipepopup",function(self)
        local oldfn = self.GetSkinOptions
        function self.GetSkinOptions(s,...)
            local ret = oldfn(s,...)
            if ret then
                if ret[1] and ret[1].image then
                    if s.recipe and s.recipe.product and itembaseimage[s.recipe.product] then
                        ret[1].image = itembaseimage[s.recipe.product]
                    end
                end
                for k,v in pairs(s.skins_list)do
                    if ret[k+1] and ret[k+1].image and v and v.item and itemskins[v.item] and (itemskins[v.item].atlas or  itemskins[v.item].image ) then
                        
                        local image = itemskins[v.item].image or v.item..".tex"
                        if image:sub(-4) ~= ".tex" then
                            image = image..".tex"
                        end
                        local atlas = itemskins[v.item].atlas or GetInventoryItemAtlas(image)
                        ret[k+1].image = {atlas,image,"default.tex"}
                        
                    end
                end
            end
            return ret
        end
    end)
    function basic_skininit_fn(inst,skinname)
        if inst.components.placer == nil and not TheWorld.ismastersim then
            return
        end
        local data = itemskins[skinname] 
        if not data then return end
        if data.bank then
            inst.AnimState:SetBank(data.bank)
        end
        inst.AnimState:SetBuild(data.build or skinname)
        if data.anim then
            inst.AnimState:PlayAnimation(data.anim)
        end
        if inst.components.inventoryitem ~= nil then
            inst.components.inventoryitem.atlasname = data.atlas or ("images/inventoryimages/"..skinname .. ".xml")
            inst.components.inventoryitem:ChangeImageName(data.image or skinname )
        end
        if data.skininit_fn then
            data.skininit_fn(inst,skinname)
        end
    end
    function basic_skinclear_fn(inst, skinname)
        local prefab = inst.prefab or ""
        local data = itemskins[skinname] 
        if not data then return end
        if data.basebank then
            inst.AnimState:SetBank(data.basebank)
        end
        if data.baseanim then
            inst.AnimState:PlayAnimation(data.baseanim)
        end
        inst.AnimState:SetBuild(data.basebuild or prefab)
        if inst.components.inventoryitem ~= nil then
            if itembaseimage[prefab] then
                inst.components.inventoryitem.atlasname = itembaseimage[prefab][1]
                local imagename = itembaseimage[prefab][2]
                imagename = imagename:sub(1,-5)
                inst.components.inventoryitem:ChangeImageName(imagename)
            else
                inst.components.inventoryitem.atlasname = GetInventoryItemAtlas(prefab..".tex")
                inst.components.inventoryitem:ChangeImageName(prefab)
            end
            
        end
        if itemskins[skinname].skinclear_fn then
            itemskins[skinname].skinclear_fn(inst,skinname)
        end
    end
    local oldSpawnPrefab = SpawnPrefab
    GLOBAL.SpawnPrefab = function(prefab,skin,skinid,userid,...)
        if itemskins[skin] then
            skinid = 0
        end
        return oldSpawnPrefab(prefab,skin,skinid,userid,...)
    end
    local oldReskinEntity = Sim.ReskinEntity
    Sim.ReskinEntity = function(sim,guid,oldskin,newskin,skinid,userid,...)
        local inst = Ents[guid]
        if oldskin and itemskins[oldskin] then
            itemskins[oldskin].clear_fn(inst) --清除旧皮肤的
        end
        local r = oldReskinEntity(sim,guid,oldskin,newskin,skinid,userid,...)
        if newskin and itemskins[newskin] then
            
            itemskins[newskin].init_fn(inst)
            inst.skinname = newskin
            inst.skin_id = 0
        end
        return r
    end
    if recipe_help then
        AddSimPostInit(function()
            for k,v in pairs(AllRecipes) do
                if v.product ~= v.name and PREFAB_SKINS[v.product] then
                    PREFAB_SKINS[v.name]      = PREFAB_SKINS[v.product]
                    PREFAB_SKINS_IDS[v.name]  = PREFAB_SKINS_IDS[v.product]
                end
            end
        end)
    end
    function GetSkin(name)
        return characterskins[name] or itemskins[name] or nil
    end
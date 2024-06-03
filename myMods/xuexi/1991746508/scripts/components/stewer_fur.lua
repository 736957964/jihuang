

local function ondone(self, done)
    if done then
        self.inst:AddTag("donecooking_fur")
    else
        self.inst:RemoveTag("donecooking_fur")
    end
end

local function oncheckready(inst)
    if inst.components.container ~= nil and
        not inst.components.container:IsOpen() and
        inst.components.container:IsFull() then
        inst:AddTag("readytocook_fur")
    end
end

local function onnotready(inst)
    inst:RemoveTag("readytocook_fur")
end

local Stewer_Fur = Class(function(self, inst)
    self.inst = inst

    self.done = nil
    self.targettime = nil
    self.task = nil
	self.puff = nil
    self.product = nil
	self.percent = nil
    self.spoiledproduct = "spoiled_food"
    self.bell_chonglian = false

    inst:ListenForEvent("itemget", oncheckready)
    inst:ListenForEvent("onclose", oncheckready)

    inst:ListenForEvent("itemlose", onnotready)
    inst:ListenForEvent("onopen", onnotready)

end,
nil,
{
    done = ondone,
})

function Stewer_Fur:OnRemoveFromEntity()
    self.inst:RemoveTag("donecooking_fur")
    self.inst:RemoveTag("readytocook_fur")
end


local cooknook = {
    --炼制 时间  配方

    --避暑
    {"heat_resistant_pill",960,{minotaurhorn =1,myth_rhino_blueheart =1,foliage =1,nitre =1}},
    {"heat_resistant_pill",480,{heat_resistant_pill =1,bluegem= 1,foliage =1,nitre =1}},

    --避寒
    {"cold_resistant_pill",960,{minotaurhorn =1,myth_rhino_redheart =1,foliage =1,nitre =1}},
    {"cold_resistant_pill",480,{cold_resistant_pill =1,redgem = 1,foliage =1,nitre =1}},
    --避尘
    {"dust_resistant_pill",960,{minotaurhorn =1,myth_rhino_yellowheart =1,foliage =1,nitre =1}},
    {"dust_resistant_pill",960,{dust_resistant_pill =1,yellowgem = 1,foliage =1,nitre =1}},

    --腾云
    {"fly_pill",60,{nitre =1,dragonfruit =1,honey =1,nightmarefuel =1}},

    --嗜血
    {"bloodthirsty_pill",60,{purplegem =1,livinglog =1,batwing =1,nightmarefuel =1}},

    --凝神
    {"condensed_pill",60,{gunpowder =1,stinger =1,durian =1,nightmarefuel =1}},

    --壮骨
    {"armor_pill",60,{garlic =1,rocks =1,boneshard =1,nightmarefuel =1}},
    --移山
    {"movemountain_pill",60,{houndstooth =1,townportaltalisman =1,asparagus =1,nightmarefuel=1}},

    --急急如律令
    {"laozi_sp",60,{papyrus =1,featherpencil =1,petals =1,butterflywings =1}},
    --荆棘丹
    {"thorns_pill",180,{cactus_flower =2,waterplant_bomb =1,livinglog =1}},
    --花翎
    {"mk_hualing",60,{goose_feather =3,redgem =1}},

    --火猿石心
    {"mk_huoyuan",60,{bigpeach =1,rocks =2,shadowheart=1}},
    --龙皮绸缎
    {"mk_longpi",60,{bearger_fur =1,dragon_scales =2,shroom_skin=1}},
    --紫金葫芦
    {"purple_gourd",960,{krampussack_sealed =1,goldnugget =1,orangegem=1,pill_bottle_gourd =1}},
    --芭蕉宝扇
    {"bananafan_big",960,{laozi_sp =1,bananafan =1,dust_resistant_pill=1,myth_banana_leaf = 1}},
    --玉净瓶
    {"myth_yjp",960,{malbatross_beak =1,laozi_sp =1,butterfly=1,driftwood_log = 1}},
    --牛羚
    {"laozi_bell",240,{gnarwail_horn =1,horn =1,laozi_sp=1,lucky_goldnugget = 1}},
    {"laozi_bell",120,{laozi_bell_broken =1,redgem =1,bluegem=1,purplegem = 1}},
    --牛鞍
    {"saddle_qingniu",240,{saddle_race =1,succulent_picked =1,laozi_sp=1,lucky_goldnugget = 1}},

    --通天敕令
    {"myth_passcard_jie",240,{boneshard =1,lucky_goldnugget =1,walrus_tusk=1,myth_lotus_flower = 1}},

    --七星剑
    {"myth_qxj",960,{laozi_sp=1,siving_stone = 3}},

    --子圭战盔
    {"siving_hat",960,{siving_stone =2,ruinshat =1,livinglog = 1}},

    --子圭战甲
    {"armorsiving",960,{siving_stone =2,armorruins =1,livinglog = 1}},

    --子圭青金
    {"siving_stone",60,{siving_rocks =2,lucky_goldnugget =1,thulecite_pieces = 1}},

    --霜钺斧
    {"myth_weapon_syf",960,{moonglassaxe =1 ,myth_rhino_blueheart =1,moonrocknugget =1,bluegem = 1}},
    {"myth_weapon_syf",480,{myth_weapon_syf =1 ,redgem =1,bluegem=1,purplegem=1}},

    --扢挞藤
    {"myth_weapon_gtt",960,{ruins_bat =1 ,myth_rhino_yellowheart =1,townportaltalisman =1,yellowgem = 1}},
    {"myth_weapon_gtt",480,{myth_weapon_gtt =1 ,redgem =1,bluegem=1,purplegem=1}},

    --暑熤刀
    {"myth_weapon_syd",960,{glasscutter =1 ,myth_rhino_redheart =1,goldnugget =1,redgem = 1}},
    {"myth_weapon_syd",480,{myth_weapon_syd =1 ,redgem =1,bluegem=1,purplegem=1}},
    --浮尘
    {"myth_fuchen",60,{cane =1 ,furtuft =1,manrabbit_tail=1,beefalowool=1}},
}

local player_cooknook = {
    --大圣锁子甲
    {"golden_armor_mk",240,{mk_longpi =1,armorruins =1,mk_huoyuan=1,walrus_tusk=1}},
    {"golden_armor_mk",120,{golden_armor_mk =1,redgem =1,bluegem=1,purplegem=1}},

    --锁子清源甲
    {"yangjian_armor",240,{bigpeach =1,armorruins =1,opalpreciousgem=1,malbatross_feathered_weave=1}},
    {"yangjian_armor",120,{yangjian_armor =1,redgem =1,bluegem=1,purplegem=1}},
    --凤翅紫金冠
    {"golden_hat_mk",240,{mk_hualing =2,ruinshat =1,orangemooneye=1}},
    {"golden_hat_mk",120,{golden_hat_mk =1,redgem =1,bluegem=1,purplegem=1}},
    --三山飞凤冠
    {"yangjian_hair",240,{malbatross_beak =1,purplemooneye =1,bluemooneye=1,eyebrellahat=1}},
    {"yangjian_hair",120,{yangjian_hair =1,redgem =1,bluegem=1,purplegem=1}},
}

if TUNING.MYTH_CHARACTER_MOD_OPEN then
    for i,v in ipairs(player_cooknook) do
        table.insert(cooknook,v)
    end
end

local function cookcook(inst)
    for i, v in ipairs(cooknook) do 
        local cando = true
        for k1,v1 in pairs(v[3]) do 
            if not inst:Has(k1, v1) then
                cando = false
            end
        end
        if cando then 
            return v[1],v[2]
        end 
    end
    return nil , 1.5
end


local function dostew(inst, self) --over
    self.task = nil
    if self.puff ~= nil then
        self.puff:Cancel()
		self.puff = nil
    end
    if self.smoke ~= nil then
        self.smoke:Remove()
		self.smoke = nil
    end	
    self.targettime = nil
    
    if self.ondonecooking ~= nil then
        self.ondonecooking(inst)
    end
    self.done = true
end

local function dobad(inst, self) --over
    self.task = nil
    if self.puff ~= nil then
        self.puff:Cancel()
		self.puff = nil
    end	
    if self.smoke ~= nil then
        self.smoke:Remove()
		self.smoke = nil
    end	
    self.targettime = nil
    
    if self.ondobad ~= nil then
        self.ondobad(inst)
    end
    self.done = nil
	if inst.components.container then
		inst.components.container.canbeopened = true
	end
end


local function dopuff(inst, self)
    local skin = self.inst.AnimState:GetBuild()
	if skin ~= "alchmy_fur_ruins" then
		local pt = Vector3(inst.Transform:GetWorldPosition())
		local mk_cloudpuff = SpawnPrefab( "mk_cloudpuff" )
		mk_cloudpuff.Transform:SetPosition( pt.x , pt.y + 1, pt.z)
	end
	self.puff = inst:DoTaskInTime(math.random(5,8), dopuff, self)    
end

function Stewer_Fur:IsDone()
    return self.done
end

function Stewer_Fur:CheckSmoke()
	local skin = self.inst.AnimState:GetBuild()
	if skin == "alchmy_fur_ruins" then
		if not self.smoke then
			self.smoke = SpawnPrefab("torchfire_rag")
			self.smoke.entity:SetParent(self.inst.entity)
			self.smoke.Transform:SetPosition(0,0.9,0)
		end
	elseif self.smoke ~= nil then
		self.smoke:Remove()
		self.smoke = nil
	end
end

function Stewer_Fur:DoneCooking()
	if self.product == nil then
		return
	end
    if self.task ~= nil then
        self.task:Cancel()
		self.task = nil
    end
    if self.puff ~= nil then
        self.puff:Cancel()
		self.puff = nil
    end	
    if self.smoke ~= nil then
        self.smoke:Remove()
		self.smoke = nil
    end	
    self.targettime = nil

	if self.ondonecooking ~= nil then
		self.ondonecooking(self.inst)
	end
	self.done = true
end

function Stewer_Fur:IsCooking()
    return not self.done and self.targettime ~= nil
end

function Stewer_Fur:GetTimeToCook()
    return not self.done and self.targettime ~= nil and self.targettime - GetTime() or 0
end

function Stewer_Fur:CanCook()
    return self.inst.components.container ~= nil and self.inst.components.container:IsFull()
end

function Stewer_Fur:StartCooking()
    if self.targettime == nil and self.inst.components.container ~= nil then
        self.done = nil

        if self.onstartcooking ~= nil then 
            self.onstartcooking(self.inst)
        end
        local cooktime = 1
		self.product, cooktime = cookcook(self.inst.components.container) --"kabobs" ,  60 -- cooking.CalculateRecipe(self.inst.prefab, ings)
        if self.product ~= nil then
            --特别关照铃铛
            if self.product == "laozi_bell" and self.inst.components.container:Has("laozi_bell_broken", 1) then
                self.bell_chonglian = true
            end
		self.percent = nil
		self.targettime = GetTime() + cooktime
        if self.task ~= nil then
            self.task:Cancel()
        end
        self.task = self.inst:DoTaskInTime(cooktime, dostew, self)
		
        if self.puff ~= nil then
            self.puff:Cancel()
        end
        self.puff = self.inst:DoTaskInTime(math.random(5,8), dopuff, self)
		self:CheckSmoke()
        self.inst.components.container:Close()
        --self.inst.components.container:DestroyContents()
		for k = 1, self.inst.components.container.numslots do
			local item = self.inst.components.container:RemoveItemBySlot(k)
			if item ~= nil then
				if item:HasTag("mk_pills") then
					self.percent = item.components.fueled and item.components.fueled:GetPercent() or 1
				end
				item:Remove()
			end
		end		
        self.inst.components.container.canbeopened = false		
		
		else
		self.targettime = 1.5
		self.product = nil
		self.percent = nil
        if self.task ~= nil then
            self.task:Cancel()
        end
		
        if self.puff ~= nil then
            self.puff:Cancel()
        end
		self:CheckSmoke()
        self.task = self.inst:DoTaskInTime(1.5, dobad, self)
		
        self.inst.components.container:Close()
        self.inst.components.container:DestroyContents()
        self.inst.components.container.canbeopened = false
		end
    end
end

local function StopProductPhysics(prod)
    prod.Physics:Stop()
end

function Stewer_Fur:OnSave()
    local remainingtime = self.targettime ~= nil and self.targettime - GetTime() or 0
    return
    {
        done = self.done,
        product = self.product,
        remainingtime = remainingtime > 0 and remainingtime or nil,
		percent = self.percent,
        bell_chonglian = self.bell_chonglian,
    }
end

function Stewer_Fur:OnLoad(data)
    if data.product ~= nil then
        self.done = data.done or nil
        self.product = data.product or nil
		self.percent = data.percent or nil

        if self.task ~= nil then
            self.task:Cancel()
            self.task = nil
        end
        if data.bell_chonglian then
            self.bell_chonglian = data.bell_chonglian
        end
        if self.puff ~= nil then
            self.puff:Cancel()
            self.puff = nil
        end
		if self.smoke ~= nil then
			self.smoke:Remove()
			self.smoke = nil
		end	
        self.targettime = nil

        if data.remainingtime ~= nil then
            self.targettime = GetTime() + math.max(0, data.remainingtime)
            if self.done then
                --self.task = self.inst:DoTaskInTime(data.remainingtime, dospoil, self)
                if self.oncontinuedone ~= nil then
                    self.oncontinuedone(self.inst)
                end
            else
                self.task = self.inst:DoTaskInTime(data.remainingtime, dostew, self)
				self.puff = self.inst:DoTaskInTime(math.random(5,8), dopuff, self)
				self:CheckSmoke()
                if self.oncontinuecooking ~= nil then
                    self.oncontinuecooking(self.inst)
                end
            end
        elseif self.product ~= self.spoiledproduct  then
            self.targettime = GetTime()
            self.task = self.inst:DoTaskInTime(0, dostew, self)
            if self.oncontinuecooking ~= nil then
                self.oncontinuecooking(self.inst)
            end
        elseif self.oncontinuedone ~= nil then
            self.oncontinuedone(self.inst)
        end

        if self.inst.components.container ~= nil then
            self.inst.components.container.canbeopened = false
        end
    end
end

function Stewer_Fur:GetDebugString()
    local status = (self:IsCooking() and "COOKING")
                or (self:IsDone() and "FULL")
                or "EMPTY"

    return string.format("%s %s timetocook: %.2f",
            self.product or "<none>",
            status,
            self:GetTimeToCook())
end

function Stewer_Fur:Harvest(harvester)
    if self.done then
        if self.onharvest ~= nil then
            self.onharvest(self.inst)
        end

        if self.product ~= nil then
            local loot
            --if self.product == 'purple_gourd' then
            --    local tp = TheWorld.components.gourd_record:Get()
            --    if tp == "NONE" then
            --        loot = SpawnPrefab("pill_bottle_gourd")
            --    else
            --        loot = SpawnPrefab("purple_gourd")
            --        loot:SetType(tp)
            --   end
			if self.product == 'myth_yjp' then
				if not TheWorld.components.gourd_record.myth_yjp then
					TheWorld.components.gourd_record.myth_yjp = true
					loot = SpawnPrefab("myth_yjp")
				else
					loot = SpawnPrefab("premiumwateringcan")
				end
			elseif self.product == 'laozi_bell' then
				if self.bell_chonglian then
					loot = SpawnPrefab("laozi_bell")
                    self.bell_chonglian = false
                elseif not TheWorld.components.gourd_record.laozi_bell then
                    loot = SpawnPrefab("laozi_bell")
                    TheWorld.components.gourd_record.laozi_bell = true
				else
					loot = SpawnPrefab("beef_bell")
				end			
            else
                loot = SpawnPrefab(self.product)
            end
            if loot ~= nil then
				local stacksize =  1
				if stacksize > 1 then
					loot.components.stackable:SetStackSize(stacksize)
				end
				if  self.percent ~= nil and loot.components.fueled ~= nil   then
					loot.components.fueled:SetPercent(self.percent + 0.5)
				end
                if harvester ~= nil and harvester.components.inventory ~= nil then
                    harvester.components.inventory:GiveItem(loot, nil, self.inst:GetPosition())
                else
                    LaunchAt(loot, self.inst, nil, 1, 1)
                end
            end
            self.product = nil
			self.percent = nil
        end

        if self.task ~= nil then
            self.task:Cancel()
            self.task = nil
        end
        if self.puff ~= nil then
            self.puff:Cancel()
            self.puff = nil
        end
		if self.smoke ~= nil then
			self.smoke:Remove()
			self.smoke = nil
		end	
        self.targettime = nil
        self.done = nil

        if self.inst.components.container ~= nil then      
            self.inst.components.container.canbeopened = true
        end
        return true
    end
end

function Stewer_Fur:LongUpdate(dt)
    if self:IsCooking() then
        if self.task ~= nil then
            self.task:Cancel()
        end
        if self.task ~= nil then
            self.task:Cancel()
        end
        if self.targettime - dt > GetTime() then
            self.targettime = self.targettime - dt
            self.task = self.inst:DoTaskInTime(self.targettime - GetTime(), dostew, self)
			
			if self.targettime - GetTime() >= 5 then
				self.puff = self.inst:DoTaskInTime(math.random(5,8), dopuff, self)
			end
			self:CheckSmoke()
            dt = 0            
        else
            dt = dt - self.targettime + GetTime()
            dostew(self.inst, self)
        end
    end
end

return Stewer_Fur

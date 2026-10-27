table.insert(Assets, Asset("ATLAS", "images/myth_bookinfo.xml"))

---主要代码部分
AddPopup("MYTHBOOKINFO")
POPUPS.MYTHBOOKINFO.fn = function(inst, show)
    if inst.HUD then
        if not show then
            inst.HUD:CloseMythBookScreen()
        elseif not inst.HUD:OpenMythBookScreen() then
            POPUPS.MYTHBOOKINFO:Close(inst)
        end
    end
end

GLOBAL.MYTH_BOOKINFO_PAGES = require("components/mythbookinfodata")()

--screens
local MythBookPopupScreen = require "screens/mythbookpopupscreen"
local function addnewbook(self)
    function self:OpenMythBookScreen()
        self.mythbookscreen = MythBookPopupScreen(self.owner)
        self:OpenScreenUnderPause(self.mythbookscreen)
        return true
    end
    function self:CloseMythBookScreen()
        if self.mythbookscreen ~= nil then
            if self.mythbookscreen.inst:IsValid() then
                TheFrontEnd:PopScreen(self.mythbookscreen)
            end
            self.mythbookscreen = nil
        end
    end
end
AddClassPostConstruct("screens/playerhud", addnewbook)

--sg
local function redamythbook(sg)
    local old_read = sg.actionhandlers[ACTIONS.READ].deststate
    sg.actionhandlers[ACTIONS.READ].deststate = function(inst, action)
        if (action.invobject ~= nil and action.invobject:HasTag("mythbookinfo")) then
            return "mythbookinfo_open"
        end
        return old_read(inst, action)
    end
end
AddStategraphPostInit("wilson", redamythbook)

AddStategraphState(
    "wilson",
    State {
        name = "mythbookinfo_open",
        tags = {"doing"},
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:OverrideSymbol("book_cook", "bookinfo_myth_read", "book_cook")
            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("reading_in", false)
            inst.AnimState:PushAnimation("reading_loop", true)
        end,
        timeline = {
            TimeEvent(
                8 * FRAMES,
                function(inst)
                    inst:PerformBufferedAction()
                end
            )
        },
        onupdate = function(inst)
            if not CanEntitySeeTarget(inst, inst) then
                inst.sg:GoToState("cookbook_close")
            end
        end,
        events = {
            EventHandler(
                "ms_closepopup",
                function(inst, data)
                    if data.popup == POPUPS.MYTHBOOKINFO then
                        inst.sg:GoToState("cookbook_close")
                    end
                end
            )
        },
        onexit = function(inst)
            inst:ShowPopUp(POPUPS.MYTHBOOKINFO, false)
        end
    }
)

--============================主要代码完成

--炼制
---主题mod的炼制
--[[
STRINGS.MYTH_BOOINFO.ITEM_TYPE = { --物品类型
        xiandan = "仙丹",
        fabao = "法宝",
        cailiao = "材料",
        zhuangbei = "装备",
        jianzhu = "建筑",
        gongju = "工具",
        shiwu = "食物",
        jineng = "技能",
        feixingshu = "飞行术",
    },
STRINGS.MYTH_BOOINFO.ITEM_DES.物品名--物品描述
STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.物品名 --物品获取方式配方描述
STRINGS.MYTH_BOOINFO.ITEM_TIME = {
        tian = "天",
        naijiuzhi = "耐久值",
        mk = "孙悟空",
        nz = "哪吒",
        bg = "白骨夫人",
        zbj = "猪八戒",
        yj = "杨戬",
        yt = "玉兔",
        etc = "其他角色",


    },
STRINGS.MYTH_BOOINFO.ITEM_TIME.ITEM_SKIN --皮肤
STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO = {
        naijiu = "耐久",
        suoshu = "所属",
    },



]]
-------------perishtime --新加参数 药效(腐烂时间）
GLOBAL.MYTH_PillRefining = {
    heat_resistant_pill = {
        --避暑丹
        cookbook_tex = "heat_resistant_pill.tex",
        cookbook_atlas = "images/bookinfo/heat_resistant_pill.xml",
        recipes = {
            {"minotaurhorn", "myth_rhino_blueheart", "foliage", "nitre"},
            {"heat_resistant_pill", "bluegem", "foliage", "nitre"}
        },
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.heat_resistant_pill,   --"免疫火焰，免疫高温过热！",
        cooktime = 960,
        priority = 22,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.xiandan,  --"仙丹",
        perishtime = "81"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian,
    },
    cold_resistant_pill = {
        --避寒丹
        cookbook_tex = "cold_resistant_pill.tex",
        cookbook_atlas = "images/bookinfo/cold_resistant_pill.xml",
        recipes = {
            {"minotaurhorn", "myth_rhino_redheart", "foliage", "nitre"},
            {"cold_resistant_pill", "redgem", "foliage", "nitre"}
        },
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.cold_resistant_pill,
        cooktime = 960,
        priority = 20,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.xiandan ,
        perishtime = "81"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian,
    },
    dust_resistant_pill = {
        --避尘丹
        cookbook_tex = "dust_resistant_pill.tex",
        cookbook_atlas = "images/bookinfo/dust_resistant_pill.xml",
        recipes = {
            {"minotaurhorn", "myth_rhino_yellowheart", "foliage", "nitre"},
            {"dust_resistant_pill", "yellowgem", "foliage", "nitre"}
        },
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.dust_resistant_pill,
        cooktime = 960,
        priority = 21,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.xiandan,
        perishtime = "81"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian,
    },
    fly_pill = {
        --滕云丹
        cookbook_tex = "fly_pill.tex",
        cookbook_atlas = "images/bookinfo/fly_pill.xml",
        recipes = {{"dragonfruit", "honey", "nightmarefuel", "nitre"}},
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.fly_pill,
        cooktime = 60,
        priority = 19,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.xiandan,
        perishtime = "1"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian,
    },
    bloodthirsty_pill = {
        --嗜血丹
        cookbook_tex = "bloodthirsty_pill.tex",
        cookbook_atlas = "images/bookinfo/bloodthirsty_pill.xml",
        recipes = {{"batwing", "purplegem", "livinglog", "nightmarefuel"}},
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.bloodthirsty_pill,
        cooktime = 60,
        priority = 16,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.xiandan,
        sanwei = {-50, 0, 0},
        perishtime = "1"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian,
    },
    armor_pill = {
        --壮骨丹
        cookbook_tex = "armor_pill.tex",
        cookbook_atlas = "images/bookinfo/armor_pill.xml",
        recipes = {{"boneshard", "rocks", "garlic", "nightmarefuel"}},
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.armor_pill,
        cooktime = 60,
        priority = 18,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.xiandan,
        perishtime = "1"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian,
    },
    condensed_pill = {
        --凝味丹
        cookbook_tex = "condensed_pill.tex",
        cookbook_atlas = "images/bookinfo/condensed_pill.xml",
        recipes = {{"durian", "gunpowder", "stinger", "nightmarefuel"}},
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.condensed_pill,
        cooktime = 60,
        priority = 17,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.xiandan,
        perishtime = "1"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian,
    },
    thorns_pill = {
        --荆棘丹
        cookbook_tex = "thorns_pill.tex",
        cookbook_atlas = "images/bookinfo/thorns_pill.xml",
        recipes = {{"cactus_flower", "cactus_flower", "livinglog", "waterplant_bomb"}},
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.thorns_pill,
        cooktime = 180,
        priority = 14,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.xiandan,
        perishtime = "15"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian,
    },
    movemountain_pill = {
        --移山丹
        cookbook_tex = "movemountain_pill.tex",
        cookbook_atlas = "images/bookinfo/movemountain_pill.xml",
        recipes = {{"asparagus", "townportaltalisman", "houndstooth", "nightmarefuel"}},
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.movemountain_pill,
        cooktime = 60,
        priority = 15,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.xiandan,
        perishtime = "1"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian,
    },
    
    myth_huanhundan = {
        --还魂丹
        cookbook_tex = "myth_huanhundan.tex",
        cookbook_atlas = "images/bookinfo/myth_huanhundan.xml",
        --配方
        --适用于那种没有配方只有说明的
        recipes_text = STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_huanhundan,
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_huanhundan,
        cooktime = "无",
        priority = 17,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.xiandan,
        perishtime = "∞"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian,
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_huanhundan,
       
    },

    bananafan_big = {
        --芭蕉宝扇
        cookbook_tex = "bananafan_big.tex",
        cookbook_atlas = "images/bookinfo/bananafan_big.xml",
        recipes = {{"bananafan", "dust_resistant_pill", "laozi_sp", "myth_banana_leaf"}},
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.bananafan_big,
        cooktime = 960,
        priority = 10,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.fabao,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },
    laozi_sp = {
        --老君符
        cookbook_tex = "laozi_sp.tex",
        cookbook_atlas = "images/bookinfo/laozi_sp.xml",
        recipes = {{"papyrus", "featherpencil", "petals", "butterflywings"}},
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.laozi_sp,
        cooktime = 60,
        priority = 13,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },
    mk_huoyuan = {
        --火猿石心
        cookbook_tex = "mk_huoyuan.tex",
        cookbook_atlas = "images/bookinfo/mk_huoyuan.xml",
        recipes = {{"shadowheart", "bigpeach", "rocks", "rocks"}},
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.mk_huoyuan,
        cooktime = 60,
        priority = 4,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },
    mk_longpi = {
        --龙鳞绸缎
        cookbook_tex = "mk_longpi.tex",
        cookbook_atlas = "images/bookinfo/mk_longpi.xml",
        recipes = {{"dragon_scales", "dragon_scales", "bearger_fur", "shroom_skin"}},
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.mk_longpi,
        cooktime = 60,
        priority = 4,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },
    mk_hualing = {
        --花翎
        cookbook_tex = "mk_hualing.tex",
        cookbook_atlas = "images/bookinfo/mk_hualing.xml",
        recipes = {{"redgem", "goose_feather", "goose_feather", "goose_feather"}},
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.mk_hualing,
        cooktime = 60,
        priority = 4,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },
    purple_gourd = {
        --紫金葫芦
        cookbook_tex = "purple_gourd.tex",
        cookbook_atlas = "images/bookinfo/purple_gourd.xml",
        recipes = {{"pill_bottle_gourd",  "krampussack_sealed","orangegem", "goldnugget"}},
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.purple_gourd,
        cooktime = 960,
        priority = 10,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.fabao,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },
    myth_yjp = {
        --玉净瓶
        cookbook_tex = "myth_yjp.tex",
        cookbook_atlas = "images/bookinfo/myth_yjp.xml",
        recipes = {{"malbatross_beak", "driftwood_log", "laozi_sp", "butterfly"}},
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_yjp,
        cooktime = 960,
        priority = 10,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.fabao,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },

    myth_passcard_jie = {
        --通天敕令
        cookbook_tex = "myth_passcard_jie.tex",
        cookbook_atlas = "images/bookinfo/myth_passcard_jie.xml",
        recipes = {{"boneshard", "lucky_goldnugget", "walrus_tusk", "myth_lotus_flower"}},
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_passcard_jie,
        cooktime = 960,
        priority = 10,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.fabao,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },

    laozi_bell = {
        --牛铃铛
        cookbook_tex = "laozi_bell.tex",
        cookbook_atlas = "images/bookinfo/laozi_bell.xml",
        recipes = {{"gnarwail_horn", "horn", "laozi_sp", "lucky_goldnugget"},{"laozi_bell_broken", "redgem", "bluegem", "purplegem"},},
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.laozi_bell,
        cooktime = 240,
        priority = 12,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.fabao,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },

    saddle_qingniu = {
        --牛鞍
        cookbook_tex = "saddle_qingniu.tex",
        cookbook_atlas = "images/bookinfo/saddle_qingniu.xml",
        recipes = {{"saddle_race", "succulent_picked", "laozi_sp", "lucky_goldnugget"}},
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.saddle_qingniu,
        cooktime = 240,
        priority = 12,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.fabao,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },

    myth_weapon_syf = {
        --霜钺斧
        cookbook_tex = "myth_weapon_syf.tex",
        cookbook_atlas = "images/bookinfo/myth_weapon_syf.xml",
        recipes = {
            {"moonglassaxe", "myth_rhino_blueheart", "bluegem", "moonrocknugget"},
            {"myth_weapon_syf", "redgem", "bluegem", "purplegem"}
        },
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_weapon_syf,
        cooktime = 960,
        priority = 8,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
        perishtime = "400"..STRINGS.MYTH_BOOINFO.ITEM_TIME.naijiuzhi,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },

    myth_weapon_syd = {
        --暑熠刀 shu yi dao
        cookbook_tex = "myth_weapon_syd.tex",
        cookbook_atlas = "images/bookinfo/myth_weapon_syd.xml",
        recipes = {
            {"glasscutter", "myth_rhino_redheart", "redgem", "goldnugget"},
            {"myth_weapon_syd", "redgem", "bluegem", "purplegem"}
        },
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_weapon_syd,
        cooktime = 960,
        priority = 8,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
        perishtime = "600"..STRINGS.MYTH_BOOINFO.ITEM_TIME.naijiuzhi,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },

    myth_weapon_gtt = {
        --扢挞藤 gu ta teng
        cookbook_tex = "myth_weapon_gtt.tex",
        cookbook_atlas = "images/bookinfo/myth_weapon_gtt.xml",
        recipes = {
            {"ruins_bat", "myth_rhino_yellowheart", "yellowgem", "townportaltalisman"},
            {"myth_weapon_gtt", "redgem", "bluegem", "purplegem"}
        },
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_weapon_gtt,
        cooktime = 960,
        priority = 8,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
        perishtime = "400"..STRINGS.MYTH_BOOINFO.ITEM_TIME.naijiuzhi,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },

    siving_stone = {
        --子圭青金
        cookbook_tex = "siving_stone.tex",
        cookbook_atlas = "images/bookinfo/siving_stone.xml",
        recipes = {
            {"siving_rocks", "siving_rocks", "lucky_goldnugget", "thulecite_pieces"},
        },
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.siving_stone,
        cooktime = 60,
        priority = 7,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },

    myth_qxj = {
        --七星剑
        cookbook_tex = "myth_qxj.tex",
        cookbook_atlas = "images/bookinfo/myth_qxj.xml",
        recipes = {
            {"siving_stone", "siving_stone","siving_stone", "laozi_sp"},
        },
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_qxj,
        cooktime = 960,
        priority = 6,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },

    siving_hat = {
        --子圭战盔
        cookbook_tex = "siving_hat.tex",
        cookbook_atlas = "images/bookinfo/siving_hat.xml",
        recipes = {
            {"siving_stone", "siving_stone", "ruinshat", "livinglog"},
        },
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.siving_hat,
        cooktime = 960,
        priority = 6,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
        perishtime = "3000HP",
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },

    armorsiving = {
        --子圭战甲
        cookbook_tex = "armorsiving.tex",
        cookbook_atlas = "images/bookinfo/armorsiving.xml",
        recipes = {
            {"siving_stone", "siving_stone", "armorruins", "livinglog"},
        },
        oneat_desc =STRINGS.MYTH_BOOINFO.ITEM_DES.armorsiving ,
        cooktime = 960,
        priority = 6,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
        perishtime = "3000HP",
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },

    myth_fuchen = {
        --拂尘
        cookbook_tex = "myth_fuchen.tex",
        cookbook_atlas = "images/bookinfo/myth_fuchen.xml",
        recipes = {
            {"cane", "furtuft", "manrabbit_tail", "beefalowool"},
        },
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_fuchen,
        cooktime = 60,
        priority = 9,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.fabao,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },

}

---人物部分的炼制内容
local player_lianzhi = {
    yangjian_armor = {
        --锁子清源甲
        cookbook_tex = "yangjian_armor.tex",
        cookbook_atlas = "images/bookinfo/yangjian_armor.xml",
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/yangjian_armor.xml", "yangjian_armor.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.yangjian1, {"images/bookinfo/yangjian_armor_black.xml", "yangjian_armor_black.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.yangjian3, {"images/bookinfo/yangjian_armor_gold.xml", "yangjian_armor_gold.tex"}},
        },
        recipes = {
            {"bigpeach", "armorruins", "opalpreciousgem", "malbatross_feathered_weave"},
            {"yangjian_armor", "redgem", "bluegem", "purplegem"}
        },
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.yangjian_armor,
        cooktime = 240,
        priority = 1,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
        perishtime = "4000HP",
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },
    yangjian_hair = {
        --三山飞凤冠
        cookbook_tex = "yangjian_hair.tex",
        cookbook_atlas = "images/bookinfo/yangjian_hair.xml",
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/yangjian_hair.xml", "yangjian_hair.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.yangjian1, {"images/bookinfo/yangjian_hair_black.xml", "yangjian_hair_black.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.yangjian3, {"images/bookinfo/yangjian_hair_gold.xml", "yangjian_hair_gold.tex"}},
        },
        recipes = {
            {"eyebrellahat", "malbatross_beak", "bluemooneye", "purplemooneye"},
            {"yangjian_hair", "redgem", "bluegem", "purplegem"}
        },
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.yangjian_hair,
        cooktime = 240,
        priority = 1,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
        perishtime = "5"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },
    golden_armor_mk = {
        --锁子黄金甲
        cookbook_tex = "golden_armor_mk.tex",
        cookbook_atlas = "images/bookinfo/golden_armor_mk.xml",
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/golden_armor_mk.xml", "golden_armor_mk.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.monkey_king3, {"images/bookinfo/golden_armor_mk_opera.xml", "golden_armor_mk_opera.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.monkey_king4, {"images/bookinfo/golden_armor_mk_ear.xml", "golden_armor_mk_ear.tex"}},
        },
        recipes = {
            {"armorruins", "mk_longpi", "mk_huoyuan", "walrus_tusk"},
            {"golden_armor_mk", "redgem", "bluegem", "purplegem"}
        },
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.golden_armor_mk,
        cooktime = 240,
        priority = 2,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
        perishtime = "4000HP",
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    },
    golden_hat_mk = {
        --凤翅紫金冠
        cookbook_tex = "golden_hat_mk.tex",
        cookbook_atlas = "images/bookinfo/golden_hat_mk.xml",
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/golden_hat_mk.xml", "golden_hat_mk.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.monkey_king3, {"images/bookinfo/golden_hat_mk_opera.xml", "golden_hat_mk_opera.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.monkey_king4, {"images/bookinfo/golden_hat_mk_ear.xml", "golden_hat_mk_ear.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.monkey_king2, {"images/bookinfo/golden_hat_mk_fire.xml", "golden_hat_mk_fire.tex"}},
        },
        recipes = {
            {"ruinshat", "orangemooneye", "mk_hualing", "mk_hualing"},
            {"golden_hat_mk", "redgem", "bluegem", "purplegem"}
        },
        oneat_desc = STRINGS.MYTH_BOOINFO.ITEM_DES.golden_hat_mk,
        cooktime = 240,
        priority = 3,
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
        perishtime = "5"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.naijiu, --显示耐久而不是药效
    }
}

for k, v in pairs(GLOBAL.MYTH_PillRefining) do
    if v.skins ~= nil then
        for _, v1 in ipairs(v.skins) do 
            table.insert(Assets, Asset("ATLAS", v1[2][1]))
        end
    end
    table.insert(Assets, Asset("ATLAS", v.cookbook_atlas))
end
for k, v in pairs(player_lianzhi) do
    if v.skins ~= nil then
        for _, v1 in ipairs(v.skins) do
            table.insert(Assets, Asset("ATLAS", v1[2][1]))
        end
    end
    table.insert(Assets, Asset("ATLAS", v.cookbook_atlas))
end

--========================================================================

--神话部分
---装备道具食物
-----
--[[


--这里是解锁科技 部分
	如果是 玩家专属 那么是
	{"images/avatars/avatar_玩家代码.xml","avatar_玩家代码.tex"}

	如果是官方的四本 或者 嫦娥或者无字天书 那么
	第一个参数都是 
	"images/myth_bookinfo.xml" 第二个参数是 science_1  science_2 magic_1 magic_2  myth_tab  myth_tab_change
	合起来就是
	{"images/myth_bookinfo.xml", "science_2"}  --科学二本解锁



-----这里是制作栏 
---如果是官方的制作栏 那么写
{"images/hud.xml,"tab_tool.tex"} --工具栏解锁

如果是神话的 
天书的是 {"images/hud/myth_tab.xml", "myth_tab.tex"}  嫦娥的是 {"images/hud/myth_tab_change.xml", "myth_tab_change.tex"}

下面附所有工具栏的名字
	xml   "images/hud.xml"	
	text
    "tab_tool.tex" }, --工具
    "tab_light.tex" }, --照明
    "tab_trap.tex" }, --生存
    "tab_farm.tex" }, --食物
    "tab_science.tex" },--科学
    "tab_fight.tex" }, --战斗
    "tab_build.tex" }, --合成
    "tab_seafaring.tex" },--鱼
    "tab_refine.tex" },
    "tab_arcane.tex" },
    "tab_dress.tex" }, --服饰
]]

----神话 主题部分的内容
GLOBAL.MYTH_DaojuRefining = {
    
--神话书系列
    book_myth= {
        --无字天书
        cookbook_tex = "book_myth.tex",
        cookbook_atlas = "images/bookinfo/book_myth.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml", "magic_2.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {"papyrus", 2},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.book_myth,
        priority = 330,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.fabao,
    },
    
    alchmy_fur = {
        --炼丹炉
        cookbook_tex = "alchmy_fur.tex",
        cookbook_atlas = "images/bookinfo/alchmy_fur.xml",
        --皮肤
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/alchmy_fur.xml", "alchmy_fur.tex"}},
            {STRINGS.MYTH_SKIN_ALCHMY_FUR_COPPER, {"images/bookinfo/alchmy_fur_copper.xml", "alchmy_fur_copper.tex"}},
            {STRINGS.MYTH_SKIN_ALCHMY_FUR_RUINS, {"images/bookinfo/alchmy_fur_ruins.xml", "alchmy_fur_ruins.tex"}}
        },
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {"thulecite", 6},
            {"cutstone", 6},
            {"dragon_scales", 2}
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.alchmy_fur,
        priority = 329,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.jianzhu

    },

    myth_cash_tree_ground = {
        --摇钱树
        cookbook_tex = "myth_cash_tree_ground.tex",
        cookbook_atlas = "images/bookinfo/myth_cash_tree_ground.xml",
        --配方
        recipes = {
			{{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {"myth_cash_tree", 1},
            {"myth_coin", 66},
            {"lucky_goldnugget", 66}
        },
        --sanwei = {20, 40, 20},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_cash_tree_ground,
        priority = 76,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.jianzhu
    },

    cassock = {
        --袈裟
        cookbook_tex = "cassock.tex",
        cookbook_atlas = "images/bookinfo/cassock.xml",
        --配方
        recipes = {
			{{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {"silk", 9},
            {"manrabbit_tail", 3},
            {"slurper_pelt", 3}
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.cassock,
        priority = 80,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
        perishtime = "8"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian --不写就是无耐久的
    },

    kam_lan_cassock = {
        --锦斓袈裟
        cookbook_tex = "kam_lan_cassock.tex",
        cookbook_atlas = "images/bookinfo/kam_lan_cassock.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {"cassock", 1},
            {"bearger_fur", 1},
            {"dragon_scales", 1}
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.kam_lan_cassock,
        priority = 79,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
        perishtime = "8"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian --不写就是无耐久的
    },

    mk_battle_flag = {
        --战旗
        cookbook_tex = "mk_battle_flag.tex",
        cookbook_atlas = "images/bookinfo/mk_battle_flag.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {"boards", 2},
            {"silk", 9},
            {"houndstooth", 6},
            {"rope", 2}
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.mk_battle_flag,
        priority = 78,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.gongju,
        perishtime = "2"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian --不写就是无耐久的
    },

    xzhat_mk = {
        --行者帽
        cookbook_tex = "xzhat_mk.tex",
        cookbook_atlas = "images/bookinfo/xzhat_mk.xml",
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/xzhat_mk.xml", "xzhat_mk.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.monkey_king5, {"images/bookinfo/xzhat_mk_horse.xml", "xzhat_mk_horse.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.monkey_king3, {"images/bookinfo/xzhat_mk_opera.xml", "xzhat_mk_opera.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.monkey_king4, {"images/bookinfo/xzhat_mk_ear.xml", "xzhat_mk_ear.tex"}},
        },
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {"manrabbit_tail", 2},
            {"silk", 6},
            {"beeswax", 1}
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.xzhat_mk,
        priority = 319,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
        perishtime = "15"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian --不写就是无耐久的
    },

    pill_bottle_gourd = {
        --丹药葫芦
        cookbook_tex = "pill_bottle_gourd.tex",
        cookbook_atlas = "images/bookinfo/pill_bottle_gourd.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {"gourd", 1},
            {"beeswax", 1},
            {"rope", 2}
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.pill_bottle_gourd,
        priority = 145,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.gongju,
    },

    wine_bottle_gourd = {
        --酒葫芦
        cookbook_tex = "wine_bottle_gourd.tex",
        cookbook_atlas = "images/bookinfo/wine_bottle_gourd.xml",
        sanwei = {3, 12.5, 50},
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {"gourd", 1},
            {"beeswax", 1},
            {"peach_wine", 5}
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.wine_bottle_gourd,
        priority = 144,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.gongju,
        perishtime = "5"..STRINGS.MYTH_BOOINFO.ITEM_TIME.naijiuzhi
    },

    myth_zongzi1 = {
        --甜粽子
        cookbook_tex = "myth_zongzi1.tex",
        cookbook_atlas = "images/bookinfo/myth_zongzi1.xml",
        --有三维的要写三维 依次是 血量 饥饿 脑残
        sanwei = {10, 75, 0},
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {"vegetarian_food", 1},
            {"myth_banana_leaf", 1},
            {"rope", 1}
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_zongzi,
        priority = 139,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.shiwu
    },

    myth_zongzi2 = {
        --肉粽子
        cookbook_tex = "myth_zongzi2.tex",
        cookbook_atlas = "images/bookinfo/myth_zongzi2.xml",
        --有三维的要写三维 依次是 血量 饥饿 脑残
        sanwei = {3, 62.5, 5},
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {"meatballs", 1},
            {"myth_banana_leaf", 1},
            {"rope", 1}
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_zongzi,
        priority = 139,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.shiwu
    },



--嫦娥系列
    myth_redlantern = {
        --灯笼
        cookbook_tex = "redlantern_myth_a.tex",
        cookbook_atlas = "images/bookinfo/redlantern_myth_a.xml",
        --皮肤
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/redlantern_myth_a.xml", "redlantern_myth_a.tex"}},
            {STRINGS.MYTH_SKIN_REDLANTERN_MYTH_B, {"images/bookinfo/redlantern_myth_b.xml", "redlantern_myth_b.tex"}},
            {STRINGS.MYTH_SKIN_REDLANTERN_MYTH_C, {"images/bookinfo/redlantern_myth_c.xml", "redlantern_myth_c.tex"}},
            {STRINGS.MYTH_SKIN_REDLANTERN_MYTH_D, {"images/bookinfo/redlantern_myth_d.xml", "redlantern_myth_d.tex"}},
            {STRINGS.MYTH_SKIN_REDLANTERN_MYTH_E, {"images/bookinfo/redlantern_myth_e.xml", "redlantern_myth_e.tex"}}
        },
        --配方
        recipes = {
                --第一参数  背景 解锁 制作栏
                {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab_change.tex"},{"images/hud.xml","tab_light.tex"}}, 
                --第二参数 需要的具体的
                {"beeswax", 1}, 
                {"twigs", 3}, 
                {"papyrus", 2}},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_redlantern,
        priority = 38,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.gongju

    },

    myth_bbn = {
        --百宝囊
        cookbook_tex = "myth_bbn.tex",
        cookbook_atlas = "images/bookinfo/myth_bbn.xml",
        --配方
        recipes = {
                --第一参数  背景 解锁 制作栏
                {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab_change.tex"},{"images/hud/myth_tab_change.xml", "myth_tab_change.tex"}}, 
                --第二参数 需要的具体的
                {"silk", 7}, 
                {"moon_tree_blossom", 16}, 
                {"opalpreciousgem", 1}},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_bbn,
        priority = 34,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.fabao,
        perishtime = "9.5"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian
    },

    myth_fence = {
        --屏风
        cookbook_tex = "myth_fence.tex",
        cookbook_atlas = "images/bookinfo/myth_fence.xml",
        --配方
        recipes = {
                --第一参数  背景 解锁 制作栏
                {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab_change.tex"},{"images/hud.xml","tab_build.tex" }}, 
                --第二参数 需要的具体的
                {"papyrus", 3}, 
                {"boards", 3}, 
                {"silk", 3}},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_fence,
        priority = 35,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.jianzhu

    },

    myth_interiors_ghg_flower = {
        --月花盆景
        cookbook_tex = "myth_interiors_ghg_flower.tex",
        cookbook_atlas = "images/bookinfo/myth_interiors_ghg_flower.xml",
        --配方
        recipes = {
                --第一参数  背景 解锁 制作栏
                {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab_change.tex"},{"images/hud.xml","tab_build.tex" }}, 
                --第二参数 需要的具体的
                {"twigs", 4}, 
                {"moonbutterfly", 1}, 
                {"moonglass", 3}},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_interiors_ghg_flower,
        priority = 32,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.jianzhu

    },

    myth_interiors_ghg_groundlight = {
        --宫灯
        cookbook_tex = "myth_interiors_ghg_groundlight.tex",
        cookbook_atlas = "images/bookinfo/myth_interiors_ghg_groundlight.xml",
        --皮肤
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/myth_interiors_ghg_groundlight.xml", "myth_interiors_ghg_groundlight.tex"}},
            {STRINGS.MYTH_SKIN_GROUNDLIGHT_STD, {"images/bookinfo/myth_interiors_ghg_groundlight_std.xml", "myth_interiors_ghg_groundlight_std.tex"}},
            {STRINGS.MYTH_SKIN_GROUNDLIGHT_RYX,{"images/bookinfo/myth_interiors_ghg_groundlight_ryx.xml", "myth_interiors_ghg_groundlight_ryx.tex"}},
            {STRINGS.MYTH_SKIN_GROUNDLIGHT_QZH, {"images/bookinfo/myth_interiors_ghg_groundlight_qzh.xml", "myth_interiors_ghg_groundlight_qzh.tex"}},
            {STRINGS.MYTH_SKIN_GROUNDLIGHT_LLT, {"images/bookinfo/myth_interiors_ghg_groundlight_llt.xml", "myth_interiors_ghg_groundlight_llt.tex"}},
            {STRINGS.MYTH_SKIN_GROUNDLIGHT_BGZ, {"images/bookinfo/myth_interiors_ghg_groundlight_bgz.xml", "myth_interiors_ghg_groundlight_bgz.tex"}},
            {STRINGS.MYTH_SKIN_GROUNDLIGHT_BLZ, {"images/bookinfo/myth_interiors_ghg_groundlight_blz.xml", "myth_interiors_ghg_groundlight_blz.tex"}},
            {STRINGS.MYTH_SKIN_GROUNDLIGHT_GXY, {"images/bookinfo/myth_interiors_ghg_groundlight_gxy.xml", "myth_interiors_ghg_groundlight_gxy.tex"}},
            {STRINGS.MYTH_SKIN_GROUNDLIGHT_YHY, {"images/bookinfo/myth_interiors_ghg_groundlight_yhy.xml", "myth_interiors_ghg_groundlight_yhy.tex"}},
        },
        --配方
        recipes = {
                --第一参数  背景 解锁 制作栏
                {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab_change.tex"},{"images/hud.xml","tab_build.tex" }}, 
                --第二参数 需要的具体的
                {"myth_redlantern", 1}, 
                {"boards", 1}},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_interiors_ghg_groundlight,
        priority = 28,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.jianzhu

    },

    myth_interiors_ghg_he_left = {
        --仙鹤左
        cookbook_tex = "myth_interiors_ghg_he_left.tex",
        cookbook_atlas = "images/bookinfo/myth_interiors_ghg_he_left.xml",
        skins = {
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.myth_he_left, {"images/bookinfo/myth_interiors_ghg_he_left.xml", "myth_interiors_ghg_he_left.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.myth_he_right, {"images/bookinfo/myth_interiors_ghg_he_right.xml", "myth_interiors_ghg_he_right.tex"}},
        },
        --配方
        recipes = {
                --第一参数  背景 解锁 制作栏
                {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab_change.tex"},{"images/hud.xml","tab_build.tex" }}, 
                --第二参数 需要的具体的
                {"moonrocknugget", 4}, 
                {"malbatross_feather", 1}},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_interiors_ghg_he_left,
        priority = 29,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.jianzhu

    },

    --[[myth_interiors_ghg_he_right = {
        --仙鹤右
        cookbook_tex = "myth_interiors_ghg_he_right.tex",
        cookbook_atlas = "images/bookinfo/myth_interiors_ghg_he_right.xml",
        --配方
        recipes = {
                --第一参数  背景 解锁 制作栏
                {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab_change.tex"},{"images/hud.xml","tab_build.tex" }}, 
                --第二参数 需要的具体的
                {"moonrocknugget", 4}, 
                {"malbatross_feather", 1}},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_interiors_ghg_he_right,
        priority = 42,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.jianzhu

    },]]--

    myth_interiors_ghg_lu = {
        --香炉
        cookbook_tex = "myth_interiors_ghg_lu.tex",
        cookbook_atlas = "images/bookinfo/myth_interiors_ghg_lu.xml",
        --配方
        recipes = {
                --第一参数  背景 解锁 制作栏
                {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab_change.tex"},{"images/hud.xml","tab_build.tex" }}, 
                --第二参数 需要的具体的
                {"petals", 6}, 
                {"moonrocknugget", 2}, 
                {"charcoal", 1}},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_interiors_ghg_lu,
        priority = 33,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.jianzhu

    },

    myth_redlantern_ground = {
        --灯笼架
        cookbook_tex = "myth_redlantern_ground.tex",
        cookbook_atlas = "images/bookinfo/myth_redlantern_ground.xml",
        --配方
        recipes = {
                --第一参数  背景 解锁 制作栏
                {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab_change.tex"},{"images/hud.xml","tab_build.tex" }}, 
                --第二参数 需要的具体的
                {"boards", 2}, 
                {"charcoal", 1}},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_redlantern_ground,
        priority = 31,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.jianzhu

    },

    myth_ruyi = {
        --如意
        cookbook_tex = "myth_ruyi.tex",
        cookbook_atlas = "images/bookinfo/myth_ruyi.xml",
        --配方
        recipes = {
                --第一参数  背景 解锁 制作栏
                {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab_change.tex"},{"images/hud/myth_tab_change.xml", "myth_tab_change.tex"}}, 
                --第二参数 需要的具体的
                {"moonglass", 3}, 
                {"opalpreciousgem", 1}},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_ruyi,
        priority = 37,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.fabao

    },

    myth_yylp = {
        --莹月轮盘
        cookbook_tex = "myth_yylp.tex",
        cookbook_atlas = "images/bookinfo/myth_yylp.xml",
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_yylp},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_yylp,
        priority = 36,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.fabao

    },

    myth_mooncake_ice = {
        --冰皮月饼
        cookbook_tex = "myth_mooncake_ice.tex",
        cookbook_atlas = "images/bookinfo/myth_mooncake_ice.xml",
        --有三维的要写三维 依次是 血量 饥饿 脑残
        sanwei = {15, 15, 15},
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_mooncake},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_mooncake_ice,
        priority = 40,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.shiwu
    },

    myth_mooncake_lotus = {
        --双黄月饼
        cookbook_tex = "myth_mooncake_lotus.tex",
        cookbook_atlas = "images/bookinfo/myth_mooncake_lotus.xml",
        --有三维的要写三维 依次是 血量 饥饿 脑残
        sanwei = {15, 15, 15},
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_mooncake},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_mooncake_lotus,
        priority = 40,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.shiwu
    },


    myth_mooncake_nuts = {
        --五仁月饼
        cookbook_tex = "myth_mooncake_nuts.tex",
        cookbook_atlas = "images/bookinfo/myth_mooncake_nuts.xml",
        --有三维的要写三维 依次是 血量 饥饿 脑残
        sanwei = {15, 15, 15},
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_mooncake},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_mooncake_nuts,
        priority = 40,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.shiwu
    },

--荷风清韵系列
    lotus_flower = {
        --莲花
        cookbook_tex = "lotus_flower.tex",
        cookbook_atlas = "images/bookinfo/lotus_flower.xml",
        --有三维的要写三维 依次是 血量 饥饿 脑残
        --sanwei = {1, 12.5, 5},
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.lotus_flower},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.lotus_flower,
        priority = 134,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao,
        perishtime = "10"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian,
       
    },

    --[[lotus_flower_cooked = {
        --烤莲花
        cookbook_tex = "lotus_flower_cooked.tex",
        cookbook_atlas = "images/bookinfo/lotus_flower_cooked.xml",
        --有三维的要写三维 依次是 血量 饥饿 脑残
        sanwei = {1, 12.5, 15},
        --配方
        recipes = {"在火堆烹饪莲花获得！"},
        --描述
        desc = "可以食用，\n可以在火堆烹饪，哪吒食用无收益！",
        priority = 65,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.shiwu,
        perishtime = "10"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian,
       
    },]]

    lotus_seeds = {
        --莲子
        cookbook_tex = "lotus_seeds.tex",
        cookbook_atlas = "images/bookinfo/lotus_seeds.xml",
        --有三维的要写三维 依次是 血量 饥饿 脑残
        sanwei = {0, 4.6875, 0},
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.lotus_seeds},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.lotus_seeds,
        priority = 138,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.shiwu,
        perishtime = "40"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian,
       
    },

    lotus_seeds_cooked = {
        --烤莲子
        cookbook_tex = "lotus_seeds_cooked.tex",
        cookbook_atlas = "images/bookinfo/lotus_seeds_cooked.xml",
        --有三维的要写三维 依次是 血量 饥饿 脑残
        sanwei = {1, 4.6875, 0},
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.lotus_seeds_cooked},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.lotus_seeds_cooked,
        priority = 137,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.shiwu,
        perishtime = "10"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian,
       
    },

    lotus_root = {
        --莲藕
        cookbook_tex = "lotus_root.tex",
        cookbook_atlas = "images/bookinfo/lotus_root.xml",
        --有三维的要写三维 依次是 血量 饥饿 脑残
        sanwei = {8, 0, 25},
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.lotus_root},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.lotus_root,
        priority = 133,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.shiwu,
        perishtime = "10"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian,
       
    },

    lotus_root_cooked = {
        --烤莲藕
        cookbook_tex = "lotus_root_cooked.tex",
        cookbook_atlas = "images/bookinfo/lotus_root_cooked.xml",
        --有三维的要写三维 依次是 血量 饥饿 脑残
        sanwei = {20, 25, 15},
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.lotus_root_cooked},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.lotus_root_cooked,
        priority = 132,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.shiwu,
        perishtime = "6"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian,
       
    },

    myth_lotusleaf = {
        --莲叶
        cookbook_tex = "myth_lotusleaf.tex",
        cookbook_atlas = "images/bookinfo/myth_lotusleaf.xml",
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_lotusleaf},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_lotusleaf,
        priority = 136,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao,
        perishtime = "10"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian,
       
    },

    myth_lotusleaf_hat = {
        --莲叶帽
        cookbook_tex = "myth_lotusleaf_hat.tex",
        cookbook_atlas = "images/bookinfo/myth_lotusleaf_hat.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","abc.tex"},{"images/hud.xml","tab_dress.tex" }}, 
            {"myth_lotusleaf", 1},
            {"rope", 1}
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_lotusleaf_hat,
        priority = 135,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
        perishtime = "10"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian
       
    },

--青竹洲系列
    myth_bamboo = {
        --竹子
        cookbook_tex = "myth_bamboo.tex",
        cookbook_atlas = "images/bookinfo/myth_bamboo.xml",
        --配方
         recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_bamboo},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_bamboo,
        priority = 129,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao,
       
    },

    myth_greenbamboo = {
        --苍竹
        cookbook_tex = "myth_greenbamboo.tex",
        cookbook_atlas = "images/bookinfo/myth_greenbamboo.xml",
        --配方
         recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_greenbamboo},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_greenbamboo,
        priority = 128,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao,
       
    },

    myth_bamboo_shoots = {
        --竹笋
        cookbook_tex = "myth_bamboo_shoots.tex",
        cookbook_atlas = "images/bookinfo/myth_bamboo_shoots.xml",
        --有三维的要写三维 依次是 血量 饥饿 脑残
        sanwei = {8, 12.5, 0},
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_bamboo_shoots},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_bamboo_shoots,
        priority = 131,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.shiwu,
        perishtime = "10"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian ,--不写就是无耐久的
    },

    myth_bamboo_shoots_cooked = {
        --烤竹笋
        cookbook_tex = "myth_bamboo_shoots_cooked.tex",
        cookbook_atlas = "images/bookinfo/myth_bamboo_shoots_cooked.xml",
        --有三维的要写三维 依次是 血量 饥饿 脑残
        sanwei = {20, 12.5, 5},
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_bamboo_shoots_cooked},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_bamboo_shoots_cooked,
        priority = 130,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.shiwu,
        perishtime = "6"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian ,--不写就是无耐久的
    },


--其他
    bigpeach = {
        --大桃子
        cookbook_tex = "bigpeach.tex",
        cookbook_atlas = "images/bookinfo/bigpeach.xml",
        --有三维的要写三维 依次是 血量 饥饿 脑残
        sanwei = {1024, 2048, 4096},
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.bigpeach},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.bigpeach,
        priority = 150,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.shiwu,
        perishtime = "10"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian ,--不写就是无耐久的
    },

    peach = {
        --桃子
        cookbook_tex = "peach.tex",
        cookbook_atlas = "images/bookinfo/peach.xml",
        --有三维的要写三维 依次是 血量 饥饿 脑残
        sanwei = {6, 10.5, 5},
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.peach},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.peach,
        priority = 149,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.shiwu,
        perishtime = "6"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian ,--不写就是无耐久的
    },

    peach_cooked = {
        --烤桃子
        cookbook_tex = "peach_cooked.tex",
        cookbook_atlas = "images/bookinfo/peach_cooked.xml",
        --有三维的要写三维 依次是 血量 饥饿 脑残
        sanwei = {3, 10.5, 0},
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.peach_cooked},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.peach_cooked,
        priority = 148,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.shiwu,
        perishtime = "5"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian ,--不写就是无耐久的
    },

    gourd = {
        --葫芦
        cookbook_tex = "gourd.tex",
        cookbook_atlas = "images/bookinfo/gourd.xml",
        --有三维的要写三维 依次是 血量 饥饿 脑残
        sanwei = {3, 37.5, 0},
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.gourd},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.gourd,
        priority = 147,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.shiwu,
        perishtime = "10"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian ,--不写就是无耐久的
    },

    gourd_cooked = {
        --烤葫芦
        cookbook_tex = "gourd_cooked.tex",
        cookbook_atlas = "images/bookinfo/gourd_cooked.xml",
        --有三维的要写三维 依次是 血量 饥饿 脑残
        sanwei = {8, 10.5, 0},
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.gourd_cooked},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.gourd_cooked,
        priority = 146,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.shiwu,
        perishtime = "6"..STRINGS.MYTH_BOOINFO.ITEM_TIME.tian ,--不写就是无耐久的
    },

    myth_banana_leaf = {
        --芭蕉叶
        cookbook_tex = "myth_banana_leaf.tex",
        cookbook_atlas = "images/bookinfo/myth_banana_leaf.xml",
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_banana_leaf},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_banana_leaf,
        priority = 142,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao,
       
    },

    myth_bundle = {
        --蕉叶包裹
        cookbook_tex = "myth_bundle.tex",
        cookbook_atlas = "images/bookinfo/myth_bundle.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","science_2.tex"},{"images/hud.xml","tab_trap.tex" }}, 
            {"myth_banana_leaf", 2}
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_bundle,
        priority = 140,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.gongju,
       
    },

    myth_cash_tree = {
        --摇钱树苗
        cookbook_tex = "myth_cash_tree.tex",
        cookbook_atlas = "images/bookinfo/myth_cash_tree.xml",
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_cash_tree},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_cash_tree,
        priority = 77,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao,
       
    },

    myth_coin = {
        --铜钱
        cookbook_tex = "myth_coin.tex",
        cookbook_atlas = "images/bookinfo/myth_coin.xml",
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_coin},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_coin,
        priority = 75,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao,
       
    },

    myth_food_table = {
        --红木餐桌
        cookbook_tex = "myth_food_table.tex",
        cookbook_atlas = "images/bookinfo/myth_food_table.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","science_2.tex"},{"images/hud.xml","tab_farm.tex" }}, 
            {"boards", 6}
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_food_table,
        priority = 167,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.jianzhu,
       
    },

    myth_granary = {
        --谷仓
        cookbook_tex = "myth_granary.tex",
        cookbook_atlas = "images/bookinfo/myth_granary.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","science_2.tex"},{"images/hud.xml","tab_farm.tex" }}, 
            {"boards", 6},
            {"cutreeds", 12},
            {"rope", 3}
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_granary,
        priority = 168,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.jianzhu,
       
    },

    myth_toy_bookinfo = {
        
        cookbook_tex = "myth_toy_Chineseknot.tex",
        cookbook_atlas = "images/bookinfo/myth_toy_Chineseknot.xml",
        skins = {
            {STRINGS.NAMES.MYTH_TOY_CHINESEKNOT, {"images/bookinfo/myth_toy_Chineseknot.xml", "myth_toy_Chineseknot.tex"}},--中国结
            {STRINGS.NAMES.MYTH_TOY_FEATHERBUNDLE, {"images/bookinfo/myth_toy_featherbundle.xml", "myth_toy_featherbundle.tex"}},--毽子
            {STRINGS.NAMES.MYTH_TOY_TIGERDOLL,{"images/bookinfo/myth_toy_tigerdoll.xml", "myth_toy_tigerdoll.tex"}},--布老虎
            {STRINGS.NAMES.MYTH_TOY_TUMBLER, {"images/bookinfo/myth_toy_tumbler.xml", "myth_toy_tumbler.tex"}},--土地不倒翁
            {STRINGS.NAMES.MYTH_TOY_TWIRLDRUM, {"images/bookinfo/myth_toy_twirldrum.xml", "myth_toy_twirldrum.tex"}},--拨浪鼓
        },
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_toy},-- myth_toy
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_toy,
        priority = 0,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao
    },

    --[[myth_toy_featherbundle = {
        --毽子
        cookbook_tex = "myth_toy_featherbundle.tex",
        cookbook_atlas = "images/bookinfo/myth_toy_featherbundle.xml",
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_toy},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_toy,
        priority = 37,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao
    },

    myth_toy_tigerdoll = {
        --布老虎
        cookbook_tex = "myth_toy_tigerdoll.tex",
        cookbook_atlas = "images/bookinfo/myth_toy_tigerdoll.xml",
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_toy},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_toy,
        priority = 37,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao
    },

    myth_toy_tumbler = {
        --土地不倒翁
        cookbook_tex = "myth_toy_tumbler.tex",
        cookbook_atlas = "images/bookinfo/myth_toy_tumbler.xml",
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_toy},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_toy,
        priority = 37,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao
    },

    myth_toy_twirldrum = {
        --拨浪鼓
        cookbook_tex = "myth_toy_twirldrum.tex",
        cookbook_atlas = "images/bookinfo/myth_toy_twirldrum.xml",
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_toy},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_toy,
        priority = 37,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao
    },
    ]]--

    myth_tudi_shrines = {
        --土地庙
        cookbook_tex = "myth_tudi_shrines.tex",
        cookbook_atlas = "images/bookinfo/myth_tudi_shrines.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","science_2.tex"},{"images/hud.xml","tab_build.tex" }}, 
            {"cutstone", 3},
            {"boards", 4},
            {"mole", 1}
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_tudi_shrines,
        priority = 170,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.jianzhu,
       
    },

    myth_well = {
        --水井
        cookbook_tex = "myth_well.tex",
        cookbook_atlas = "images/bookinfo/myth_well.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","science_2.tex"},{"images/hud.xml","tab_farm.tex" }}, 
            {"cutstone", 3},
            {"shovel", 1},
            {"pickaxe", 1}
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_well,
        priority = 169,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.jianzhu,
       
    },

    myth_banana_tree = {
        --芭蕉树
        cookbook_tex = "myth_banana_tree.tex",
        cookbook_atlas = "images/bookinfo/myth_banana_tree.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","science_2.tex"},{"images/hud.xml","tab_farm.tex" }}, 
            {"cave_banana", 1},
            {"livinglog", 1},
            {"fertilizer", 1}
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_banana_tree,
        priority = 143,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.jianzhu,
       
    },

    bananafan = {
        --芭蕉扇
        cookbook_tex = "bananafan.tex",
        cookbook_atlas = "images/bookinfo/bananafan.xml",
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.bananafan},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.bananafan,
        priority = 141,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.fabao,
        perishtime = "3"..STRINGS.MYTH_BOOINFO.ITEM_TIME.naijiuzhi
       
    },

    myth_rhino_blueheart = {
        --辟寒心脏
        cookbook_tex = "myth_rhino_blueheart.tex",
        cookbook_atlas = "images/bookinfo/myth_rhino_blueheart.xml",
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_rhino_blueheart},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_rhino_blueheart,
        priority = 71,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao,
       
    },

    myth_rhino_redheart = {
        --辟暑心脏
        cookbook_tex = "myth_rhino_redheart.tex",
        cookbook_atlas = "images/bookinfo/myth_rhino_redheart.xml",
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_rhino_redheart},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_rhino_redheart,
        priority = 71,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao,
       
    },

    myth_rhino_yellowheart = {
        --辟尘心脏
        cookbook_tex = "myth_rhino_yellowheart.tex",
        cookbook_atlas = "images/bookinfo/myth_rhino_yellowheart.xml",
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_rhino_yellowheart},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_rhino_yellowheart,
        priority = 71,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao,
       
    },

    siving_rocks = {
        --子圭石
        cookbook_tex = "siving_rocks.tex",
        cookbook_atlas = "images/bookinfo/siving_rocks.xml",
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.siving_rocks},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.siving_rocks,
        priority = 72,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao,
       
    },

    krampussack_sealed = {
        --被封印的坎普斯背包
        cookbook_tex = "krampussack_sealed.tex",
        cookbook_atlas = "images/bookinfo/krampussack_sealed.xml",
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.krampussack_sealed},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.krampussack_sealed,
        priority = 73,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao,
       
    },

    myth_coin_box = {
        --铜钱串
        cookbook_tex = "myth_coin_box.tex",
        cookbook_atlas = "images/bookinfo/myth_coin_box.xml",
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.myth_coin_box},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_coin_box,
        priority = 74,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.gongju,
       
    },

    myth_mooncake_box = {
        --月饼盒
        cookbook_tex = "myth_mooncake_box.tex",
        cookbook_atlas = "images/bookinfo/myth_mooncake_box.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {"boards", 2},
            {"moon_tree_blossom", 1},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_mooncake_box,
        priority = 39,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.gongju,
       
    },



    ---普通角色飞行术，神话人物飞行术在神话人物部分的内容

    --白云
    myth_flyskill = {
        cookbook_tex = "myth_flyskill.tex",
        cookbook_atlas = "images/bookinfo/myth_flyskill.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab_fcs.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {"fly_pill", 1},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_flyskill,
        priority = 171,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.feixingshu,
        perishtime = STRINGS.MYTH_BOOINFO.ITEM_TIME.etc,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.suoshu, --显示所属而不是药效
    },
    
}


----神话 人物部分的内容
local player_shenhua = {
--猴子
    mk_jgb = {
        --金箍棒
        cookbook_tex = "mk_jgb.tex",
        cookbook_atlas = "images/bookinfo/mk_jgb.xml",
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/mk_jgb.xml", "mk_jgb.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.monkey_king1, {"images/bookinfo/mk_jgb_sea.xml", "mk_jgb_sea.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.monkey_king2, {"images/bookinfo/mk_jgb_fire.xml", "mk_jgb_fire.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.monkey_king3, {"images/bookinfo/mk_jgb_opera.xml", "mk_jgb_opera.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.monkey_king4, {"images/bookinfo/mk_jgb_ear.xml", "mk_jgb_ear.tex"}},
        },
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.mk_jgb},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.mk_jgb,
        priority = 320,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
    },

    --筋斗云
    myth_flyskill_mk = {
        cookbook_tex = "myth_flyskill_mk.tex",
        cookbook_atlas = "images/bookinfo/myth_flyskill_mk.xml",
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/myth_flyskill_mk.xml", "myth_flyskill_mk.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.monkey_king4, {"images/bookinfo/myth_flyskill_mk_ear.xml", "myth_flyskill_mk_ear.tex"}},
        },
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab_fcs.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {CHARACTER_INGREDIENT.SANITY, 25},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_flyskill_mk,
        priority = 200,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.feixingshu,
        perishtime = STRINGS.MYTH_BOOINFO.ITEM_TIME.mk,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.suoshu, --显示所属而不是药效
       
    },

    
    mk_dsf = {
        --定身法
        cookbook_tex = "mk_dsf.tex",
        cookbook_atlas = "images/bookinfo/mk_dsf.xml",
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab_fcs.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {CHARACTER_INGREDIENT.SANITY, 10},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.mk_dsf,
        priority = 199,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.jineng,
        perishtime = STRINGS.MYTH_BOOINFO.ITEM_TIME.mk,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.suoshu, --显示所属而不是药效
    },

--哪吒
    nz_lance = {
        --火尖枪
        cookbook_tex = "nz_lance.tex",
        cookbook_atlas = "images/bookinfo/nz_lance.xml",

        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/nz_lance.xml", "nz_lance.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.neza1, {"images/bookinfo/nz_lance_green.xml", "nz_lance_green.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.neza2, {"images/bookinfo/nz_lance_fire.xml", "nz_lance_fire.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.neza3, {"images/bookinfo/nz_lance_pink.xml", "nz_lance_pink.tex"}},
        },

        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.nz_zhuangbei_recipe},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.nz_lance,
        priority = 310,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
    },

    nz_ring = {
        --乾坤圈
        cookbook_tex = "nz_ring.tex",
        cookbook_atlas = "images/bookinfo/nz_ring.xml",
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/nz_ring.xml", "nz_ring.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.neza1, {"images/bookinfo/nz_ring_green.xml", "nz_ring_green.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.neza2, {"images/bookinfo/nz_ring_fire.xml", "nz_ring_fire.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.neza3, {"images/bookinfo/nz_ring_pink.xml", "nz_ring_pink.tex"}},
        },
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.nz_zhuangbei_recipe},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.nz_ring,
        priority = 308,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
    },

    nz_damask = {
        --混天绫
        cookbook_tex = "nz_damask.tex",
        cookbook_atlas = "images/bookinfo/nz_damask.xml",
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/nz_damask.xml", "nz_damask.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.neza1, {"images/bookinfo/nz_damask_green.xml", "nz_damask_green.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.neza2, {"images/bookinfo/nz_damask_fire.xml", "nz_damask_fire.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.neza3, {"images/bookinfo/nz_damask_pink.xml", "nz_damask_pink.tex"}},
        },
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.nz_zhuangbei_recipe},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.nz_damask,
        priority = 309,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
        perishtime = "10"..STRINGS.MYTH_BOOINFO.ITEM_TIME.naijiuzhi,
    },

    --风火轮
    myth_flyskill_nz = {
        cookbook_tex = "myth_flyskill_nz.tex",
        cookbook_atlas = "images/bookinfo/myth_flyskill_nz.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab_fcs.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {CHARACTER_INGREDIENT.SANITY, 25},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_flyskill_nz,
        priority = 197,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.feixingshu,
        perishtime = STRINGS.MYTH_BOOINFO.ITEM_TIME.nz,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.suoshu, --显示所属而不是药效
       
    },


--白骨
    bone_blade = {
        --骨刃
        cookbook_tex = "bone_blade.tex",
        cookbook_atlas = "images/bookinfo/bone_blade.xml",
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/bone_blade.xml", "bone_blade.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.white_bone1, {"images/bookinfo/bone_blade_opera.xml", "bone_blade_opera.tex"}},
        },
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/avatars/avatar_white_bone.xml","avatar_white_bone.tex"},{"images/hud/white_bone_tab.xml","white_bone_tab.tex"}}, 
            {"boneshard", 4},
            {"livinglog", 1},
            {"nightmarefuel", 1},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.bone_blade,
        priority = 299,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
        perishtime = "100"..STRINGS.MYTH_BOOINFO.ITEM_TIME.naijiuzhi,
    },

    bone_wand = {
        --骨杖
        cookbook_tex = "bone_wand.tex",
        cookbook_atlas = "images/bookinfo/bone_wand.xml",
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/bone_wand.xml", "bone_wand.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.white_bone1, {"images/bookinfo/bone_wand_opera.xml", "bone_wand_opera.tex"}},
        },
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/avatars/avatar_white_bone.xml","avatar_white_bone.tex"},{"images/hud/white_bone_tab.xml","white_bone_tab.tex"}}, 
            {"boneshard", 4},
            {"purplegem", 2},
            {"nightmarefuel", 2},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.bone_wand,
        priority = 298,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
        perishtime = "25"..STRINGS.MYTH_BOOINFO.ITEM_TIME.naijiuzhi,
    },

    bone_whip = {
        --骨鞭
        cookbook_tex = "bone_whip.tex",
        cookbook_atlas = "images/bookinfo/bone_whip.xml",
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/bone_whip.xml", "bone_whip.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.white_bone1, {"images/bookinfo/bone_whip_opera.xml", "bone_whip_opera.tex"}},
        },
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/avatars/avatar_white_bone.xml","avatar_white_bone.tex"},{"images/hud/white_bone_tab.xml","white_bone_tab.tex"}}, 
            {"boneshard", 4},
            {"livinglog", 1},
            {"nightmarefuel", 2},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.bone_whip,
        priority = 300,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
        perishtime = "100"..STRINGS.MYTH_BOOINFO.ITEM_TIME.naijiuzhi,
    },

    wb_heart = {
        --暗影之心
        cookbook_tex = "wb_heart.tex",
        cookbook_atlas = "images/bookinfo/wb_heart.xml",
        sanwei = {-20, 0, 0},
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/avatars/avatar_white_bone.xml","avatar_white_bone.tex"},{"images/hud/white_bone_tab.xml","white_bone_tab.tex"}}, 
            {"boneshard", 2},
            {"spidergland", 1},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.wb_heart,
        priority = 297,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.shiwu,
    },

    --白骨的云
    myth_flyskill_wb = {
        cookbook_tex = "myth_flyskill_wb.tex",
        cookbook_atlas = "images/bookinfo/myth_flyskill_wb.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab_fcs.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {CHARACTER_INGREDIENT.SANITY, 25},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_flyskill_wb,
        priority = 194,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.feixingshu,
        perishtime = STRINGS.MYTH_BOOINFO.ITEM_TIME.bg,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.suoshu, --显示所属而不是药效
       
    },

    bone_mirror = {
        --白骨妖镜
        cookbook_tex = "bone_mirror.tex",
        cookbook_atlas = "images/bookinfo/bone_mirror.xml",
        skins = {
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.bone_mirror1, {"images/bookinfo/bone_mirror.xml", "bone_mirror.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.bone_mirror2, {"images/bookinfo/bone_mirror_2.xml", "bone_mirror_2.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.bone_mirror3, {"images/bookinfo/bone_mirror_3.xml", "bone_mirror_3.tex"}},
        },
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/avatars/avatar_white_bone.xml","avatar_white_bone.tex"},{"images/hud/white_bone_tab.xml","white_bone_tab.tex"}}, 
            {"boneshard", 6},
            {"silk", 6},
            {"bluegem", 3},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.bone_mirror,
        priority = 296,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.fabao,
    },

    wb_armorlight = {
        --轻盈披风
        cookbook_tex = "wb_armorlight.tex",
        cookbook_atlas = "images/bookinfo/wb_armorlight.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/avatars/avatar_white_bone.xml","avatar_white_bone.tex"},{"images/hud/white_bone_tab.xml","white_bone_tab.tex"}}, 
            {"boneshard", 4},
            {"silk", 12},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.wb_armorlight,
        priority = 295,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
    },

    wb_armorbone = {
        --硬骨披风
        cookbook_tex = "wb_armorbone.tex",
        cookbook_atlas = "images/bookinfo/wb_armorbone.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/avatars/avatar_white_bone.xml","avatar_white_bone.tex"},{"images/hud/white_bone_tab.xml","white_bone_tab.tex"}}, 
            {"boneshard", 8},
            {"nightmarefuel", 4},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.wb_armorbone,
        priority = 295,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
    },

    wb_armorblood = {
        --血腥披风
        cookbook_tex = "wb_armorblood.tex",
        cookbook_atlas = "images/bookinfo/wb_armorblood.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/avatars/avatar_white_bone.xml","avatar_white_bone.tex"},{"images/hud/white_bone_tab.xml","white_bone_tab.tex"}}, 
            {"boneshard", 4},
            {"mosquitosack", 4},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.wb_armorblood,
        priority = 295,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
    },

    wb_armorgreed = {
        --贪婪披风
        cookbook_tex = "wb_armorgreed.tex",
        cookbook_atlas = "images/bookinfo/wb_armorgreed.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/avatars/avatar_white_bone.xml","avatar_white_bone.tex"},{"images/hud/white_bone_tab.xml","white_bone_tab.tex"}}, 
            {"boneshard", 4},
            {"slurper_pelt", 2},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.wb_armorgreed,
        priority = 295,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
    },

    wb_armorstorage = {
        --贮藏披风
        cookbook_tex = "wb_armorstorage.tex",
        cookbook_atlas = "images/bookinfo/wb_armorstorage.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/avatars/avatar_white_bone.xml","avatar_white_bone.tex"},{"images/hud/white_bone_tab.xml","white_bone_tab.tex"}}, 
            {"boneshard", 4},
            {"pigskin", 2},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.wb_armorstorage,
        priority = 295,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
    },

    wb_armorfog = {
        --雾隐披风
        cookbook_tex = "wb_armorfog.tex",
        cookbook_atlas = "images/bookinfo/wb_armorfog.xml",
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.wb_armorfog},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.wb_armorfog,
        priority = 294,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
    },

--八戒
	pigsy_hat = {
        --墨兰帽
        cookbook_tex = "pigsy_hat.tex",
        cookbook_atlas = "images/bookinfo/pigsy_hat.xml",
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/pigsy_hat.xml", "pigsy_hat.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.pigsy1, {"images/bookinfo/pigsy_hat_marry.xml", "pigsy_hat_marry.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.pigsy2, {"images/bookinfo/pigsy_hat_white.xml", "pigsy_hat_white.tex"}},
        },
        --配方
        recipes = {
			{{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/avatars/avatar_pigsy.xml","avatar_pigsy.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {"silk", 3},
            {"goldnugget", 1},	
		},
		--描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.pigsy_hat,
        priority = 289,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
        perishtime = "400"..STRINGS.MYTH_BOOINFO.ITEM_TIME.naijiuzhi,
    },

    pigsy_rake = {
        --九齿钉耙
        cookbook_tex = "pigsy_rake.tex",
        cookbook_atlas = "images/bookinfo/pigsy_rake.xml",
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/pigsy_rake.xml", "pigsy_rake.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.pigsy1, {"images/bookinfo/pigsy_rake_marry.xml", "pigsy_rake_marry.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.pigsy2, {"images/bookinfo/pigsy_rake_white.xml", "pigsy_rake_white.tex"}},
        },
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.pigsy_rake},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.pigsy_rake,
        priority = 290,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
    },

    pigsy_sleepbed = {
        --八戒草垛
        cookbook_tex = "pigsy_sleepbed.tex",
        cookbook_atlas = "images/bookinfo/pigsy_sleepbed.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/avatars/avatar_pigsy.xml","avatar_pigsy.tex"},{"images/hud.xml","tab_trap.tex"}}, 
            {"cutgrass", 3},  
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.pigsy_sleepbed,
        priority = 288,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.gongju,
        perishtime = "1"..STRINGS.MYTH_BOOINFO.ITEM_TIME.naijiuzhi,
    },

    myth_pigsyskill_bookinfo = {
        --刚鬣本相
        cookbook_tex = "myth_pigsyskill_bookinfo.tex",
        cookbook_atlas = "images/bookinfo/myth_pigsyskill_bookinfo.xml",
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/myth_pigsyskill_bookinfo.xml", "myth_pigsyskill_bookinfo.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.pigsy2, {"images/bookinfo/myth_pigsyskill_bookinfo_white.xml", "myth_pigsyskill_bookinfo_white.tex"}},
        
        },
        --配方
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.fcs_learn},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_pigsyskill_bookinfo,
        priority = 190,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.jineng,
        perishtime = STRINGS.MYTH_BOOINFO.ITEM_TIME.bj,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.suoshu, --显示所属而不是药效
    },

    --八戒的云
    myth_flyskill_pg = {
        cookbook_tex = "myth_flyskill_pg.tex",
        cookbook_atlas = "images/bookinfo/myth_flyskill_pg.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab_fcs.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {CHARACTER_INGREDIENT.SANITY, 25},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_flyskill_pg,
        priority = 191,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.feixingshu,
        perishtime = STRINGS.MYTH_BOOINFO.ITEM_TIME.bj,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.suoshu, --显示所属而不是药效
       
    },   

--杨戬
    yj_spear = {
        --三尖两刃刀
        cookbook_tex = "yj_spear.tex",
        cookbook_atlas = "images/bookinfo/yj_spear.xml",
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/yj_spear.xml", "yj_spear.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.yangjian1, {"images/bookinfo/yj_spear_black.xml", "yj_spear_black.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.yangjian2, {"images/bookinfo/yj_spear_clean.xml", "yj_spear_clean.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.yangjian3, {"images/bookinfo/yj_spear_gold.xml", "yj_spear_gold.tex"}},
        },
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.yj_spear},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.yj_spear,
        priority = 280,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
    },

     --雷云
    myth_flyskill_yj = {
        cookbook_tex = "myth_flyskill_yj.tex",
        cookbook_atlas = "images/bookinfo/myth_flyskill_yj.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab_fcs.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {CHARACTER_INGREDIENT.SANITY, 25},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_flyskill_yj,
        priority = 188,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.feixingshu,
        perishtime = STRINGS.MYTH_BOOINFO.ITEM_TIME.yj,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.suoshu, --显示所属而不是药效
       
    },

    yangjian_track = {
        --展翅化鹰
        cookbook_tex = "yangjian_track.tex",
        cookbook_atlas = "images/bookinfo/yangjian_track.xml",
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab_fcs.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {CHARACTER_INGREDIENT.SANITY, 25},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.yangjian_track,
        priority = 187,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.jineng,
        perishtime = STRINGS.MYTH_BOOINFO.ITEM_TIME.yj,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.suoshu, --显示所属而不是药效
    },

--玉兔
    medicine_pestle_myth = {
        --捣药杵
        cookbook_tex = "medicine_pestle_myth.tex",
        cookbook_atlas = "images/bookinfo/medicine_pestle_myth.xml",
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/medicine_pestle_myth.xml", "medicine_pestle_myth.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.yutu1, {"images/bookinfo/medicine_pestle_myth_gmz.xml", "medicine_pestle_myth_gmz.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.yutu2, {"images/bookinfo/medicine_pestle_myth_winter.xml", "medicine_pestle_myth_winter.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.yutu3, {"images/bookinfo/medicine_pestle_myth_apricot.xml", "medicine_pestle_myth_apricot.tex"}},
        },
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.medicine_pestle_myth},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.medicine_pestle_myth,
        priority = 270,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
    },

    guitar_jadehare = {
        --琵琶
        cookbook_tex = "guitar_jadehare.tex",
        cookbook_atlas = "images/bookinfo/guitar_jadehare.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/avatars/avatar_myth_yutu.xml","avatar_myth_yutu.tex"},{"images/hud/jadehare_tab.xml","jadehare_tab.tex"}}, 
            {"moonglass", 4},
            {"driftwood_log", 1},
            {"silk", 1},
        },
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/guitar_jadehare.xml", "guitar_jadehare.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.yutu3, {"images/bookinfo/guitar_jadehare_apricot.xml", "guitar_jadehare_apricot.tex"}},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.guitar_jadehare,
        priority = 269,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
       
    },

    myth_bamboo_basket = {
        --竹药篓
        cookbook_tex = "myth_bamboo_basket.tex",
        cookbook_atlas = "images/bookinfo/myth_bamboo_basket.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/avatars/avatar_myth_yutu.xml","avatar_myth_yutu.tex"},{"images/hud/jadehare_tab.xml","jadehare_tab.tex"}}, 
            {"myth_bamboo", 3},
            {"rope", 2},
        },
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/myth_bamboo_basket.xml", "myth_bamboo_basket.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.yutu3, {"images/bookinfo/myth_bamboo_basket_apricot.xml", "myth_bamboo_basket_apricot.tex"}},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_bamboo_basket,
        priority = 268,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.gongju,
       
    },

    --玉兔的云
    myth_flyskill_yt = {
        cookbook_tex = "myth_flyskill_yt.tex",
        cookbook_atlas = "images/bookinfo/myth_flyskill_yt.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab_fcs.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {CHARACTER_INGREDIENT.SANITY, 25},
        },
        skins = {
            {STRINGS.UI.CRAFTING.DEFAULT, {"images/bookinfo/myth_flyskill_yt.xml", "myth_flyskill_yt.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.yutu3, {"images/bookinfo/myth_flyskill_yt_apricot.xml", "myth_flyskill_yt_apricot.tex"}},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_flyskill_yt,
        priority = 185,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.feixingshu,
        perishtime = STRINGS.MYTH_BOOINFO.ITEM_TIME.yt,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.suoshu, --显示所属而不是药效
       
    },

--黑白无常
    hat_commissioner_white = {
        --无常官帽
        cookbook_tex = "hat_commissioner_white.tex",
        cookbook_atlas = "images/bookinfo/hat_commissioner_white.xml",
        skins = {
            {STRINGS.MYTH_BOOINFO.ITEM_TIME.bwc, {"images/bookinfo/hat_commissioner_white.xml", "hat_commissioner_white.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_TIME.hwc, {"images/bookinfo/hat_commissioner_black.xml", "hat_commissioner_black.tex"}},
        },
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.hat_commissioner_white},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.hat_commissioner_white,
        priority = 260,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.hat_commissioner_white,
    },

    bell_commissioner = {
        --摄魂铃
        cookbook_tex = "bell_commissioner.tex",
        cookbook_atlas = "images/bookinfo/bell_commissioner.xml",
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.zhuangbei_commissioner_w},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.bell_commissioner,
        priority = 258,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
    },

    token_commissioner = {
        --镇魂令
        cookbook_tex = "token_commissioner.tex",
        cookbook_atlas = "images/bookinfo/token_commissioner.xml",
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.zhuangbei_commissioner_b},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.token_commissioner,
        priority = 256,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
    },

    pennant_commissioner = {
        --招魂幡
        cookbook_tex = "pennant_commissioner.tex",
        cookbook_atlas = "images/bookinfo/pennant_commissioner.xml",
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.zhuangbei_commissioner_w},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.pennant_commissioner,
        priority = 259,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
    },

    whip_commissioner = {
        --勾魂索
        cookbook_tex = "whip_commissioner.tex",
        cookbook_atlas = "images/bookinfo/whip_commissioner.xml",
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.zhuangbei_commissioner_b},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.whip_commissioner,
        priority = 257,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.zhuangbei,
    },

    soul_specter = {
        --善魂
        cookbook_tex = "soul_specter.tex",
        cookbook_atlas = "images/bookinfo/soul_specter.xml",
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.soul_specter},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.soul_specter,
        priority = 252,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao,
    },

    soul_ghast = {
        --恶魂
        cookbook_tex = "soul_ghast.tex",
        cookbook_atlas = "images/bookinfo/soul_ghast.xml",
        recipes = {STRINGS.MYTH_BOOINFO.ITEM_RECIPE_DES.soul_ghast},
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.soul_ghast,
        priority = 251,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.cailiao,
    },

    myth_yama_statue1 = {
        --阎罗像
        cookbook_tex = "myth_yama_statue1.tex",
        cookbook_atlas = "images/bookinfo/myth_yama_statue1.xml",
        skins = {
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.myth_yama_statue1, {"images/bookinfo/myth_yama_statue1.xml", "myth_yama_statue1.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.myth_yama_statue2, {"images/bookinfo/myth_yama_statue2.xml", "myth_yama_statue2.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.myth_yama_statue3, {"images/bookinfo/myth_yama_statue3.xml", "myth_yama_statue3.tex"}},
            {STRINGS.MYTH_BOOINFO.ITEM_SKIN.myth_yama_statue4, {"images/bookinfo/myth_yama_statue4.xml", "myth_yama_statue4.tex"}},
        },
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/avatars/avatar_yama_commissioners.xml","avatar_yama_commissioners.tex"},{"images/hud/yama_tab.xml","yama_tab.tex"}}, 
            {"cutstone", 3},  
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_yama_statue1,
        priority = 255,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.jianzhu,
    },

    myth_cqf = {
        --出窍符
        cookbook_tex = "myth_cqf.tex",
        cookbook_atlas = "images/bookinfo/myth_cqf.xml",
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/avatars/avatar_yama_commissioners.xml","avatar_yama_commissioners.tex"},{"images/hud/yama_tab.xml","yama_tab.tex"}}, 
            {"papyrus", 1},  
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_cqf,
        priority = 253,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.gongju,
    },

    myth_higanbana_item = {
        --彼岸花
        cookbook_tex = "myth_higanbana_item.tex",
        cookbook_atlas = "images/bookinfo/myth_higanbana_item.xml",
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/avatars/avatar_yama_commissioners.xml","avatar_yama_commissioners.tex"},{"images/hud/yama_tab.xml","yama_tab.tex"}}, 
            {"petals_evil", 12},
            {"butterfly", 1},
            {"butterflywings", 1},  
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_higanbana_item,
        priority = 254,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.gongju,
        perishtime = "5"..STRINGS.MYTH_BOOINFO.ITEM_TIME.naijiuzhi,
    },

    myth_bahy = {
        --彼岸还阳
        cookbook_tex = "myth_bahy.tex",
        cookbook_atlas = "images/bookinfo/myth_bahy.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/avatars/avatar_yama_commissioners.xml","avatar_yama_commissioners.tex"},{"images/hud/yama_tab.xml","yama_tab.tex"}}, 
            {CHARACTER_INGREDIENT.SANITY, 5},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_bahy,
        priority = 181,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.jineng,
        perishtime = STRINGS.MYTH_BOOINFO.ITEM_TIME.hb,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.suoshu, --显示所属而不是药效
       
    },

    --黑白无常的云
    myth_flyskill_ya = {
        cookbook_tex = "myth_flyskill_ya.tex",
        cookbook_atlas = "images/bookinfo/myth_flyskill_ya.xml",
        --配方
        recipes = {
            {{"images/myth_bookinfo.xml", "tech_myth.tex"},{"images/myth_bookinfo.xml","myth_tab_fcs.tex"},{"images/hud/myth_tab.xml","myth_tab.tex"}}, 
            {CHARACTER_INGREDIENT.SANITY, 25},
        },
        --描述
        desc = STRINGS.MYTH_BOOINFO.ITEM_DES.myth_flyskill_ya,
        priority = 182,
        --类型
        foodtype = STRINGS.MYTH_BOOINFO.ITEM_TYPE.feixingshu,
        perishtime = STRINGS.MYTH_BOOINFO.ITEM_TIME.hb,
        xiaoguo = STRINGS.MYTH_BOOINFO.ITEM_XIAOGUO.suoshu, --显示所属而不是药效
       
    },



}

for k, v in pairs(GLOBAL.MYTH_DaojuRefining) do
    if v.skins ~= nil then
        for _, v1 in ipairs(v.skins) do
            table.insert(Assets, Asset("ATLAS", v1[2][1]))
        end
    end
    table.insert(Assets, Asset("ATLAS", v.cookbook_atlas))
end
for k, v in pairs(player_shenhua) do
    if v.skins ~= nil then
        for _, v1 in ipairs(v.skins) do
            table.insert(Assets, Asset("ATLAS", v1[2][1]))
        end
    end
    table.insert(Assets, Asset("ATLAS", v.cookbook_atlas))
end





AddSimPostInit(
    function()
        if TUNING.MYTH_CHARACTER_MOD_OPEN then
            for k, v in pairs(player_lianzhi) do
                GLOBAL.MYTH_PillRefining[k] = v
            end
            for k, v in pairs(player_shenhua) do
                GLOBAL.MYTH_DaojuRefining[k] = v
            end
        end
    end
)

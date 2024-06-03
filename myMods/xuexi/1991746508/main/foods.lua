AddPrefabFiles("myth_foods")

local L = MK_MOD_LANGUAGE_SETTING
local mythfooddes

if L == "CHINESE" then --英文！！！
    mythfooddes = {
        peach_wine = {
            --蟠桃素酒
            oneat_desc = "降温",
            cook_need = "蟠桃、冰",
            cook_cant = "熟蟠桃"
        },
        peach_banquet = {
            --蟠桃大会
            cook_need = "蟠桃、浆果、蝴蝶翅膀",
            cook_cant = "熟蟠桃、熟浆果、多汁浆果、熟多汁浆果"
        },
        honey_pie = {
            --蜂蜜素饼
            cook_need = "素食、蜂蜜",
            cook_cant = "肉、大蒜类、洋葱类、辣椒类"
        },
        vegetarian_food = {
            --素斋
            cook_need = "素食",
            cook_cant = "肉、大蒜类、洋葱类、辣椒类"
        },
        gourd_soup = {
            --葫芦汤
            cook_need = "葫芦",
            cook_cant = "肉"
        },
        gourd_omelet = {
            --葫芦鸡蛋饼
            cook_need = "葫芦、鸡蛋",
            cook_cant = "肉"
        },
        myth_food_zpd = {
            --猪皮冻
            oneat_desc = "1分钟锁血",
            cook_need = "猪皮、粘液类、鼻涕",
            cook_cant = "可以下咽的东西"
        },
        myth_food_nx = {
            --奶昔
            oneat_desc = "降温",
            cook_need = "香蕉、牛奶、冰",
            cook_cant = "烤香蕉"
        },
        myth_food_fhy = {
            --覆海
            oneat_desc = "1天避水诀",
            cook_need = "龙虾、石果、莲花",
            cook_cant = "肉"
        },
        myth_food_hymz = {
            --花月
            oneat_desc = "启蒙值归零",
            cook_need = "月桂花、香蕉、石果、蔬菜",
            cook_cant = "肉"
        },
        myth_food_lxq = {
            --龙虾球
            cook_need = "龙虾、蜂蜜",
            cook_cant = "肉"
        },
        myth_food_bbf = {
            --八宝饭
            cook_need = "蔬菜、水果、坚果",
            cook_cant = "肉、不可食用的东西"
        },
        myth_food_bz = {
            --大肉包子
            oneat_desc = "缓和50%饱食度消耗1分钟，年味儿度",
            cook_need = "玉米、肉",
            cook_cant = "辣椒"
        },
        myth_food_hlbz = {
            --胡萝卜汁
            oneat_desc = "降温，年味儿度",
            cook_need = "胡萝卜、冰块",
            cook_cant = "肉"
        },
        myth_food_lwhz = {
            --腊味合蒸
            oneat_desc = "年味儿度",
            cook_need = "肉干、蜂蜜、南瓜",
            cook_cant = "熟南瓜"
        },
        myth_food_hsy = {
            --麻辣红烧鱼
            cook_need = "鱼、大蒜、辣椒",
            cook_cant = "不可食用"
        },
        myth_food_sj = {
            --水饺
            oneat_desc = "缓慢恢复理智，年味儿度",
            cook_need = "肉、玉米、蔬菜、大蒜",
            cook_cant = "不可食用"
        },
        myth_food_xjdmg = {
            --小鸡炖蘑菇
            oneat_desc = "升温，年味儿度",
            cook_need = "鸡腿、蘑菇、冰块",
            cook_cant = "炸鸡腿"
        },
        myth_food_cj = {
            --折月春卷儿
            oneat_desc = "年味儿度",
            cook_need = "南瓜、蔬菜、月花、树枝",
            cook_cant = "肉"
        },
        myth_food_tsj = {
            --屠苏酒
            oneat_desc = "升温，年味儿度",
            cook_need = "蔬菜、水果、火荨麻、冰",
            cook_cant = "肉"
        },
        myth_food_tr = {
            --糖人
            oneat_desc = "缓慢恢复理智，年味儿度",
            cook_need = "蜂蜜、树枝",
            cook_cant = "肉"
        },
        myth_food_lzg = {
            --冰糖莲子羹
            cook_need = "蜂蜜、莲子、冰",
            cook_cant = "肉"
        },
        myth_food_zyoh = {
            --折月藕盒
            cook_need = "莲藕、月花、树枝、蔬菜",
            cook_cant = "肉"
        },
        myth_food_pgt = {
            --莲藕排骨汤
            cook_need = "莲藕、肉",
            cook_cant = "树枝"
        },
        myth_food_hbj = {
            --荷包鸡
            cook_need = "莲叶、鸡腿、浆果",
            cook_cant = "不可食用"
        },
        myth_food_zscr = {
            --竹笋炒肉
            cook_need = "肉、竹笋、蔬菜",
            cook_cant = "不可食用"
        },
        myth_food_ztf = {
            --竹筒饭
            cook_need = "莲子、竹子、蔬菜",
            cook_cant = "不可食用"
        },
    }
else
    mythfooddes = {
        peach_wine = {
            --蟠桃素酒
            oneat_desc = "Decreases temperature by 40 degrees in 15 seconds.",
            cook_need = "peach",
            cook_cant = "roasted peach"
        },
        peach_banquet = {
            --蟠桃大会
            cook_cant = "roasted peach, roasted berries, juicy berries sorts"
        },
        honey_pie = {
            --蜂蜜素饼
            cook_need = "honey",
            cook_cant = "meat, pepper sorts, onion sorts, garlic sorts"
        },
        vegetarian_food = {
            --素斋
            cook_cant = "meat, pepper sorts, onion sorts, garlic sorts"
        },
        gourd_soup = {
            --葫芦汤
            cook_need = "gourd",
            cook_cant = "meat"
        },
        gourd_omelet = {
            --葫芦鸡蛋饼
            cook_need = "gourd、egg",
            cook_cant = "meat"
        },
        myth_food_zpd = {
            --猪皮冻
            oneat_desc = "Locks minimal health to 1 for 2 minutes, after which health turns to 1 whatsoever.",
            cook_cant = "anything"
        },
        myth_food_nx = {
            --奶昔
            oneat_desc = "Decreases temperature by 40 degrees in 15 seconds.",
            cook_cant = "meat"
        },
        myth_food_fhy = {
            --覆海
            oneat_desc = "Dissipates moisture for 1 day.",
            cook_need = "Wobster",
            cook_cant = "meat"
        },
        myth_food_hymz = {
            --花月
            oneat_desc = "Cleans up Enlightenment.",
            cook_cant = "meat"
        },
        myth_food_lxq = {
            --龙虾球
            cook_need = "wobster",
            cook_cant = "meat"
        },
        myth_food_bbf = {
            --八宝饭
            cook_need = "veggie, fruit, acorn_cooked",
            cook_cant = "meat"
        },
        myth_food_bz = {
            --大肉包子
            oneat_desc = "Halves hunger drain for 1 minutes, with Festive Taste.",
            cook_need = "corn, meat",
            cook_cant = "pepper"
        },
        myth_food_hlbz = {
            --胡萝卜汁
            oneat_desc = "Lowers body temperature, with Festive Taste.",
            cook_need = "carrot, ice",
            cook_cant = "meat"
        },
        myth_food_lwhz = {
            --腊味合蒸
            oneat_desc = "With Festive Taste.",
            cook_need = "jerky, honey, pumpkin",
            cook_cant = "hot pumpkin"
        },
        myth_food_hsy = {
            --麻辣红烧鱼
            cook_need = "fish, garlic, pepper",
            cook_cant = "inedible"
        },
        myth_food_sj = {
            --水饺
            oneat_desc = "Has Soothing Tea's effect, with Festive Taste",
            cook_need = "meat, corn, veggie, garlic",
            cook_cant = "inedible"
        },
        myth_food_xjdmg = {
            --小鸡炖蘑菇
            oneat_desc = "Warms up body, with Festive Taste",
            cook_need = "drumstick, mushroom, ice",
            cook_cant = "fried drumstick"
        },
        myth_food_cj = {
            --折月春卷儿
            oneat_desc = "With Festive Taste",
            cook_need = "pumpkin, veggie, lune tree blossom, twigs",
            cook_cant = "meat"
        },
        myth_food_tsj = {
            --屠苏酒
            oneat_desc = "Warms up body temperature, with Festive Taste",
            cook_need = "veggie, fruit, firenettles, ice",
            cook_cant = "meat"
        },
        myth_food_tr = {
            --糖人
            oneat_desc = "With Festive Taste.",
            cook_need = "honey, honey, twigs, twigs",
            cook_cant = "meat"
        },
        myth_food_lzg = {
            --冰糖莲子羹
            cook_need = "honey, lotus seeds, ice",
            cook_cant = "meat"
        },
        myth_food_zyoh = {
            --折月藕盒
            cook_need = "lotus root, lune tree blossom, twigs, veggie",
            cook_cant = "meat"
        },
        myth_food_pgt = {
            --莲藕排骨汤
            cook_need = "lotus root, meat",
            cook_cant = "twigs"
        },
        myth_food_hbj = {
            --荷包鸡
            cook_need = "lotus pad, drumstick, berries",
            cook_cant = "fried drumstick, roasted berries"
        },
        myth_food_zscr = {
            --竹笋炒肉
            cook_need = "bamboo shoots, meat, veggie",
            cook_cant = "inedible"
        },
        myth_food_ztf = {
            --竹筒饭
            cook_need = "bamboo, lotus seeds, veggie",
            cook_cant = "meat"
        },
    }
end

--菜单
local foods = {
    peach_wine = {
        test = function(cooker, names, tags)
            return names.peach and names.peach >= 3 and tags.frozen
        end,
        priority = 50,
        weight = 1,
        foodtype = FOODTYPE.GOODIES,
        health = 3,
        hunger = 12.5,
        perishtime = TUNING.ICEHAT_PERISHTIME,
        sanity = 60,
        cooktime = 3,
        temperature = TUNING.COLD_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.FOOD_TEMP_BRIEF,
        unlock = {"peach", "peach", "peach", "ice"}
    },
    peach_banquet = {
        test = function(cooker, names, tags)
            return names.peach and names.peach == 2 and names.butterflywings and names.berries
        end,
        priority = 50,
        weight = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = 50,
        hunger = 37.5,
        perishtime = TUNING.UMBRELLA_PERISHTIME,
        sanity = 10,
        cooktime = 0.5,
        unlock = {"peach", "peach", "butterflywings", "berries"}
    },
    honey_pie = {
        test = function(cooker, names, tags)
            return tags.veggie and tags.veggie >= 1.5 and tags.sweetener and tags.sweetener >= 2 and not tags.meat and not names.royal_jelly
        end,
        priority = 50,
        weight = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = 20,
        hunger = 37.5,
        perishtime = TUNING.AUTOSAVE_INTERVAL * 25,
        sanity = 5,
        cooktime = 0.75,
        unlock = {"corn", "corn", "honey", "honey"}
    },
    vegetarian_food = {
        test = function(cooker, names, tags)
            return tags.veggie and tags.veggie >= 3.5 and not tags.meat and not tags.fruit and not tags.monster and
                not tags.sweetener and
                not names.royal_jelly and
                not names.onion and
                not names.onion_cooked and
                not names.garlic and
                not names.garlic_cooked and
                not names.pepper and
                not names.pepper_cooked and
                not names.goatmilk and
                not names.butter and
                not names.mandrake
        end,
        priority = 50,
        weight = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = 0,
        hunger = 75,
        perishtime = TUNING.AUTOSAVE_INTERVAL * 10,
        sanity = 0,
        cooktime = 1,
        unlock = {"corn", "corn", "corn", "corn"}
    },
    gourd_soup = {
        test = function(cooker, names, tags)
            return tags.gourd and tags.gourd >= 2 and not tags.meat
        end,
        priority = 55,
        weight = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = 20,
        hunger = 37.5,
        perishtime = TUNING.AUTOSAVE_INTERVAL * 15,
        sanity = 15,
        cooktime = 0.6,
        unlock = {"gourd", "gourd", "berries", "berries"}
    },
    gourd_omelet = {
        test = function(cooker, names, tags)
            return tags.gourd and tags.gourd >= 2 and tags.egg and tags.egg >= 2 and not tags.meat
        end,
        priority = 60,
        weight = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = 40,
        hunger = 75,
        perishtime = TUNING.AUTOSAVE_INTERVAL * 20,
        sanity = 10,
        cooktime = 0.6,
        unlock = {"gourd", "gourd", "bird_egg", "bird_egg"}
    },
    --猪皮冻
    myth_food_zpd = {
        test = function(cooker, names, tags)
            return names.phlegm and names.slurtleslime and names.glommerfuel and names.pigskin
        end,
        priority = 60,
        weight = 1,
        foodtype = FOODTYPE.GOODIES,
        health = 0,
        hunger = 0,
        sanity = -100,
        cooktime = 3,
        nostack = true,
        oneatenfn = function(inst, eater)
            if
                eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                    not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                    not eater:HasTag("playerghost")
             then
                if eater.components.debuffable:HasDebuff("myth_zpd_buff") then
                    eater.components.health.minhealth = 0
                    local current = eater.components.health.currenthealth
                    eater.components.health:DoDelta(-(current + 1), nil, "myth_food_zpd", nil, inst, true)
                else
                    eater.components.debuffable:AddDebuff("myth_zpd_buff", "myth_zpd_buff")
                end
            end
        end,
        unlock = {"phlegm", "slurtleslime", "glommerfuel", "pigskin"}
    },
    --奶昔
    myth_food_nx = {
        test = function(cooker, names, tags)
            return tags.frozen and tags.dairy and names.cave_banana and not tags.meat and not tags.veggie and
                not tags.inedible and
                not tags.egg
        end,
        priority = 60,
        weight = 1,
        foodtype = FOODTYPE.GOODIES,
        health = 20,
        hunger = 12.5,
        perishtime = TUNING.PERISH_SUPERFAST,
        temperature = TUNING.COLD_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.FOOD_TEMP_LONG,
        sanity = 60,
        cooktime = 0.5,
        unlock = {"ice", "ice", "cave_banana", "goatmilk"}
    },
    --覆海宴
    myth_food_fhy = {
        test = function(cooker, names, tags)
            return names.wobster_sheller_land and names.rock_avocado_fruit_ripe and names.myth_lotus_flower and
                tags.meat == 1.0
        end,
        priority = 60,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = 40,
        hunger = 75,
        perishtime = TUNING.PERISH_FASTISH,
        cooktime = 2,
        sanity = 33,
        unlock = {"wobster_sheller_land", "rock_avocado_fruit_ripe", "myth_lotus_flower", "corn"},
        oneatenfn = function(inst, eater)
            if
                eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                    not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                    not eater:HasTag("playerghost")
             then
                eater.components.debuffable:AddDebuff("myth_food_fhy_buff", "myth_food_fhy_buff")
            end
        end
    },
    --[[花月满盏
    myth_food_hymz =
    {
        test = function(cooker, names, tags) 
            return  names.moon_tree_blossom and names.cave_banana and names.rock_avocado_fruit_ripe and tags.veggie and tags.veggie >= 2 and not tags.meat end,
        priority = 60,
        weight = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = 20,
        hunger = 37.5,
        perishtime = TUNING.AUTOSAVE_INTERVAL* 20,
        sanity = 33,
        cooktime = 0.8,
		unlock = {"moon_tree_blossom","cave_banana","rock_avocado_fruit_ripe","corn"},
        oneatenfn = function(inst, eater)
            if eater.components.sanity ~= nil and eater.components.sanity:IsLunacyMode() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                eater.components.sanity:SetPercent(0)
            end
       	end,
    },]]
    --龙虾球
    myth_food_lxq = {
        test = function(cooker, names, tags)
            return names.wobster_sheller_land and tags.sweetener and tags.sweetener >= 1 and names.myth_banana_leaf and
                tags.meat == 1.0
        end,
        priority = 60,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = 60,
        hunger = 37.5,
        perishtime = TUNING.AUTOSAVE_INTERVAL * 15,
        sanity = 33,
        cooktime = 1,
        unlock = {"wobster_sheller_land", "honey", "myth_banana_leaf", "corn"}
    },
    --水饺
    myth_food_sj = {
        test = function(cooker, names, tags)
            return tags.meat and names.corn and names.garlic and tags.veggie and tags.veggie >= 2.5
        end,
        priority = 50,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = 40,
        hunger = 37.5,
        perishtime = TUNING.PERISH_PRESERVED,
        sanity = 5,
        tags = {"myth_nianweidu_food"},
        cooktime = 0.5,
        unlock = {"meat", "corn", "garlic", "carrot"},
        oneatenfn = function(inst, eater)
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() then
                eater.components.debuffable:AddDebuff("sweettea_buff", "sweettea_buff")
            end
        end
    },
    --大肉包子
    myth_food_bz = {
        test = function(cooker, names, tags)
            return names.corn and tags.meat and tags.meat >= 1.5 and not names.garlic and not tags.inedible and
                (not tags.monster or tags.monster < 2)
        end,
        priority = 50,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = 20,
        hunger = 112.5,
        perishtime = TUNING.PERISH_PRESERVED,
        sanity = 5,
        tags = {"myth_nianweidu_food"},
        cooktime = 0.5,
        unlock = {"meat", "smallmeat", "corn", "carrot"},
        oneatenfn = function(inst, eater)
            if
                eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                    not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                    not eater:HasTag("playerghost")
             then
                eater.components.debuffable:AddDebuff("myth_food_bz_buff", "myth_food_bz_buff")
            end
        end
    },
    --小鸡炖蘑菇
    myth_food_xjdmg = {
        test = function(cooker, names, tags)
            return names.drumstick and names.drumstick == 2 and tags.mogu and tags.frozen
        end,
        priority = 50,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = 20,
        hunger = 75,
        perishtime = TUNING.PERISH_SLOW,
        sanity = 5,
        tags = {"myth_nianweidu_food"},
        cooktime = 1,
        temperature = TUNING.HOT_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION,
        unlock = {"drumstick", "drumstick", "red_cap", "ice"}
    },
    --麻辣红烧鱼
    myth_food_hsy = {
        test = function(cooker, names, tags)
            return names.garlic and names.pepper and tags.fish and tags.fish >= 1 and not tags.inedible
        end,
        priority = 50,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = 20,
        hunger = 62.5,
        perishtime = TUNING.PERISH_SLOW,
        sanity = 5,
        tags = {"myth_nianweidu_food"},
        cooktime = 1,
        temperature = TUNING.HOT_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION,
        unlock = {"fish", "fish", "garlic", "pepper"}
    },
    --八宝饭  
    myth_food_bbf = {
        test = function(cooker, names, tags)
            return tags.veggie and tags.veggie >= 2 and tags.fruit and tags.fruit >= 1 and (names.acorn_cooked or names.lotus_seeds) and
                not names.onion and
                not names.onion_cooked and
                not names.garlic and
                not names.garlic_cooked and
                not names.pepper and
                not names.pepper_cooked
        end,
        priority = 50,
        weight = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = 3,
        hunger = 112.5,
        perishtime = TUNING.PERISH_SUPERSLOW,
        sanity = 5,
        tags = {"myth_nianweidu_food"},
        cooktime = 1,
        temperature = TUNING.HOT_FOOD_BONUS_TEMP, --升温热
        temperatureduration = TUNING.FOOD_TEMP_LONG, --升温效果
        unlock = {"carrot", "carrot", "pomegranate", "acorn_cooked"}
    },
    --折月春卷
    myth_food_cj = {
        test = function(cooker, names, tags)
            return (names.pumpkin or names.pumpkin_cooked) and names.moon_tree_blossom and names.twigs and tags.veggie and
                tags.veggie >= 2 and
                not tags.meat
        end,
        priority = 50,
        weight = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = 3,
        hunger = 37.5,
        perishtime = TUNING.PERISH_PRESERVED,
        sanity = 15,
        tags = {"myth_nianweidu_food"},
        cooktime = 1,
        stacksize = 3,
        unlock = {"pumpkin", "carrot", "moon_tree_blossom", "twigs"}
    },
    --胡萝卜汁
    myth_food_hlbz = {
        test = function(cooker, names, tags)
            return names.carrot and names.carrot == 2 and tags.frozen and tags.frozen >= 2 and not tags.meat
        end,
        priority = 50,
        weight = 1,
        foodtype = FOODTYPE.GOODIES,
        health = 3,
        hunger = 12.5,
        perishtime = TUNING.PERISH_SUPERFAST,
        sanity = 33,
        cooktime = 0.5,
        temperature = TUNING.COLD_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION,
        unlock = {"carrot", "carrot", "ice", "ice"}
    },
    --腊味合蒸
    myth_food_lwhz = {
        test = function(cooker, names, tags)
            return names.meat_dried and names.monstermeat_dried and names.honey and names.pumpkin
        end,
        priority = 50,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = 40,
        hunger = 112.5,
        perishtime = TUNING.PERISH_SUPERSLOW, --40天
        sanity = 15,
        tags = {"myth_nianweidu_food"},
        cooktime = 3,
        unlock = {"meat_dried", "monstermeat_dried", "honey", "pumpkin"}
    },
    --屠苏酒
    myth_food_tsj = {
        test = function(cooker, names, tags)
            return tags.veggie and tags.veggie >= 1 and tags.fruit and tags.fruit >= 1 and names.firenettles and
                tags.frozen and
                not tags.meat
        end,
        priority = 50,
        weight = 1,
        foodtype = FOODTYPE.GOODIES,
        health = -3,
        hunger = -10,
        sanity = 15,
        tags = {"myth_nianweidu_food"},
        cooktime = 2,
        temperature = TUNING.HOT_FOOD_BONUS_TEMP, --升温热
        temperatureduration = TUNING.FOOD_TEMP_LONG, --升温效果
        unlock = {"corn", "pomegranate", "firenettles", "ice"},
        oneatenfn = function(inst, eater)
            if
                eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                    not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                    not eater:HasTag("playerghost")
             then
                eater.components.debuffable:AddDebuff("myth_food_tsj_buff", "myth_food_tsj_buff")
            end
        end
    },
    --糖人
    myth_food_tr = {
        test = function(cooker, names, tags)
            return names.honey and names.honey == 2 and names.twigs and names.twigs == 2
        end,
        priority = 50,
        weight = 1,
        foodtype = FOODTYPE.GOODIES,
        health = 0,
        hunger = 0,
        sanity = 2,
        cooktime = 1,
        notfood = true,
        nostack = true,
        tags = {"myth_food_tr"},
        unlock = {"honey", "honey", "twigs", "twigs"}
    },

    --莲子羹
    myth_food_lzg = {
        test = function(cooker, names, tags)
            return names.ice  and names.honey and names.lotus_seeds and names.lotus_seeds == 2 
        end,
        priority = 50,
        weight = 1,
        foodtype = FOODTYPE.GOODIES,
        health = 8,
        hunger = 12.5,
        perishtime = TUNING.PERISH_FAST, --6天
        sanity = 15,
        cooktime = 1,
        unlock = {"ice", "honey", "lotus_seeds", "lotus_seeds"}
    },

    --折月藕盒
    myth_food_zyoh = {
        test = function(cooker, names, tags)
            return tags.veggie and tags.veggie >= 2  and names.twigs and (names.lotus_root or names.lotus_root_cooked) and names.moon_tree_blossom
                and not tags.meat
        end,
        priority = 50,
        weight = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = 20,
        hunger = 25,
        perishtime = TUNING.PERISH_PRESERVED, --20天
        sanity = 15,
        stacksize = 3,
        cooktime = 1,
        unlock = {"corn", "lotus_root", "twigs", "moon_tree_blossom"}
    },

    --莲藕排骨汤
    myth_food_pgt = {
        test = function(cooker, names, tags)
            return tags.meat and tags.meat >= 2  and  (names.lotus_root or names.lotus_root_cooked) and  (not tags.monster or tags.monster < 1.1)
                and not names.twigs
        end,
        priority = 50,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = 40,
        hunger = 75,
        perishtime = TUNING.PERISH_MED, --10天
        sanity = 5,
        cooktime = 1,
        unlock = {"meat", "meat", "lotus_root", "lotus_root"}
    },

    --荷包鸡
    myth_food_hbj = {
        test = function(cooker, names, tags)
            return names.myth_lotusleaf  and  names.drumstick and names.drumstick == 2 and (names.berries or names.berries_cooked or names.berries_juicy or names.berries_juicy_cooked)
        end,
        priority = 50,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = 40,
        hunger = 75,
        perishtime = TUNING.PERISH_MED, --10天
        sanity = 33,
        cooktime = 6,
        unlock = {"myth_lotusleaf", "drumstick", "drumstick", "berries"}
    },

    --竹笋炒肉
    myth_food_zscr = {
        test = function(cooker, names, tags)
            return (names.myth_bamboo_shoots or  names.myth_bamboo_shoots_cooked) and tags.meat and tags.meat >= 1.5 and tags.veggie and tags.veggie >= 1.5 and (not tags.monster or tags.monster <= 1)
        end,
        priority = 50,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = 30,
        hunger = 75,
        perishtime = TUNING.PERISH_MED, --10天
        sanity = 15,
        cooktime = 1,
        unlock = {"myth_bamboo_shoots", "meat", "meat", "carrot"}
    },
    --竹筒饭
    myth_food_ztf = {
        test = function(cooker, names, tags)
            return names.lotus_seeds and names.myth_bamboo and tags.veggie and tags.veggie >= 2 and not tags.meat
        end,
        priority = 50,
        weight = 1,
        foodtype = FOODTYPE.VEGGIE,
        health = 20,
        hunger = 75,
        perishtime = TUNING.PERISH_SLOW, --15天
        sanity = 5,
        cooktime = 1,
        unlock = {"lotus_seeds", "myth_bamboo", "carrot", "carrot"}
    },
}

local mythfoodui = require "widgets/mythfoodui"
for k, v in pairs(foods) do
    v.name = k
    v.weight = v.weight or 1
    v.priority = v.priority or 0
    v.cookbook_category = "cookpot"
    v.oneat_desc = mythfooddes[k].oneat_desc or nil
    v.cook_need = mythfooddes[k].cook_need or nil
    v.cook_cant = mythfooddes[k].cook_cant or nil

    v.custom_cookbook_details_fn = function(data, self, top, left)
        local root = mythfoodui(data, self, top, left)
        return root
    end
end

AddSimPostInit(
    function()
        if TheCookbook then
            for k, v in pairs(foods) do
                if not TheCookbook:IsUnlocked(k) then
                    TheCookbook:AddRecipe(k, v.unlock)
                end
            end
        end
    end
)

--调味料效果
local spicedfoods = {}
local function oneaten_garlic(inst, eater)
    if
        eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
            not (eater.components.health ~= nil and eater.components.health:IsDead()) and
            not eater:HasTag("playerghost")
     then
        eater.components.debuffable:AddDebuff("buff_playerabsorption", "buff_playerabsorption")
    end
end

local function oneaten_sugar(inst, eater)
    if
        eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
            not (eater.components.health ~= nil and eater.components.health:IsDead()) and
            not eater:HasTag("playerghost")
     then
        eater.components.debuffable:AddDebuff("buff_workeffectiveness", "buff_workeffectiveness")
    end
end

local function oneaten_chili(inst, eater)
    if
        eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
            not (eater.components.health ~= nil and eater.components.health:IsDead()) and
            not eater:HasTag("playerghost")
     then
        eater.components.debuffable:AddDebuff("buff_attack", "buff_attack")
    end
end

local SPICES = {
    SPICE_GARLIC = {oneatenfn = oneaten_garlic, prefabs = {"buff_playerabsorption"}},
    SPICE_SUGAR = {oneatenfn = oneaten_sugar, prefabs = {"buff_workeffectiveness"}},
    SPICE_CHILI = {oneatenfn = oneaten_chili, prefabs = {"buff_attack"}},
    SPICE_SALT = {}
}

local function MKGenerateSpicedFoods(foods, spicedfoods)
    for foodname, fooddata in pairs(foods) do
        for spicenameupper, spicedata in pairs(SPICES) do
            local newdata = shallowcopy(fooddata)
            local spicename = string.lower(spicenameupper)
            if foodname == "wetgoop" then
                newdata.test = function(cooker, names, tags)
                    return names[spicename]
                end
                newdata.priority = -10
            else
                newdata.test = function(cooker, names, tags)
                    return names[foodname] and names[spicename]
                end
                newdata.priority = 100
            end
            newdata.cooktime = .12
            newdata.stacksize = nil
            newdata.spice = spicenameupper
            newdata.basename = foodname
            newdata.name = foodname .. "_" .. spicename
            spicedfoods[newdata.name] = newdata

            if spicename == "spice_chili" then
                if newdata.temperature == nil then
                    --Add permanent "heat" to regular food
                    newdata.temperature = TUNING.HOT_FOOD_BONUS_TEMP
                    newdata.temperatureduration = TUNING.FOOD_TEMP_LONG
                    newdata.nochill = true
                elseif newdata.temperature > 0 then
                    --Upgarde "hot" food to permanent heat
                    newdata.temperatureduration = math.max(newdata.temperatureduration, TUNING.FOOD_TEMP_LONG)
                    newdata.nochill = true
                end
            end

            if spicedata.prefabs ~= nil then
                newdata.prefabs =
                    newdata.prefabs ~= nil and ArrayUnion(newdata.prefabs, spicedata.prefabs) or spicedata.prefabs
            end

            if spicedata.oneatenfn ~= nil then
                if newdata.oneatenfn ~= nil then
                    local oneatenfn_old = newdata.oneatenfn
                    newdata.oneatenfn = function(inst, eater)
                        spicedata.oneatenfn(inst, eater)
                        oneatenfn_old(inst, eater)
                    end
                else
                    newdata.oneatenfn = spicedata.oneatenfn
                end
            end
        end
    end
end

MKGenerateSpicedFoods(foods, spicedfoods)

--for prefab files
GLOBAL.MYTH_PREPARED_FOODS = foods
GLOBAL.MYTH_SPICED_FOODS = spicedfoods

--普通食物
for k, recipe in pairs(foods) do
    AddCookerRecipe("cookpot", recipe)
    AddCookerRecipe("portablecookpot", recipe)
    recipe.cookbook_tex = "cookbook_" .. k .. ".tex"
    recipe.cookbook_atlas = "images/cookbook/cookbook_" .. k .. ".xml"
    RegisterInventoryItemAtlas("images/inventoryimages/"..k..".xml", k..".tex")
end

--香料食物
for k, recipe in pairs(spicedfoods) do
    AddCookerRecipe("portablespicer", recipe)
end

--食材
AddIngredientValues({"peach"}, {fruit = 1}, true)
AddIngredientValues({"bigpeach"}, {fruit = 2}, true)
AddIngredientValues({"peach_cooked"}, {fruit = 1})
AddIngredientValues({"gourd"}, {veggie = 1, gourd = 1}, true)
AddIngredientValues({"gourd_cooked"}, {veggie = 1, gourd = 1})

--莲花改成myth前缀
AddIngredientValues({"myth_lotus_flower"}, {inedible = 1})
AddIngredientValues({"lotus_root"}, {veggie = 1})
AddIngredientValues({"lotus_root_cooked"}, {veggie = 1})
AddIngredientValues({"myth_lotusleaf"}, {inedible = 1})

AddIngredientValues({"moon_tree_blossom"}, {veggie = 0.5})
AddIngredientValues({"pigskin"}, {inedible = 1})
AddIngredientValues({"glommerfuel"}, {inedible = 1})
AddIngredientValues({"slurtleslime"}, {inedible = 1})
AddIngredientValues({"phlegm"}, {inedible = 1})
AddIngredientValues({"myth_banana_leaf"}, {inedible = 1})
AddIngredientValues({"firenettles"}, {inedible = 1})
AddIngredientValues({"lotus_seeds"}, {inedible = 1})
AddIngredientValues({"lotus_seeds_cooked"}, {inedible = 1})

AddIngredientValues({"myth_bamboo"}, {inedible = 1})
AddIngredientValues({"myth_bamboo_shoots"}, {veggie = 1})
AddIngredientValues({"myth_bamboo_shoots_cooked"}, {veggie = 1})

local cooking = require("cooking")
local mushrooms = {
    "red_cap",
    "green_cap",
    "blue_cap",
    "moon_cap",
    "red_cap_cooked",
    "green_cap_cooked",
    "blue_cap_cooked",
    "moon_cap_cooked"
}

for _, v in ipairs(mushrooms) do
    if cooking.ingredients[v] ~= nil then
        if not cooking.ingredients[v].tags then
            cooking.ingredients[v].tags = {}
        end
        cooking.ingredients[v].tags["mogu"] = 1
    else
        AddIngredientValues({v}, {mogu = 1})
    end
end

--[[  
    1    PERISH_ONE_DAY = 1*total_day_time*perish_warp,
    2    PERISH_TWO_DAY = 2*total_day_time*perish_warp,
    3    PERISH_SUPERFAST = 3*total_day_time*perish_warp,
    6    PERISH_FAST = 6*total_day_time*perish_warp,
    8    PERISH_FASTISH = 8*total_day_time*perish_warp,
    10   PERISH_MED = 10*total_day_time*perish_warp,
    15   PERISH_SLOW = 15*total_day_time*perish_warp,
    20   PERISH_PRESERVED = 20*total_day_time*perish_warp,
    40   PERISH_SUPERSLOW = 40*total_day_time*perish_warp,
]]
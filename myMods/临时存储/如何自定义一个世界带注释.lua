AddTaskSet("desertonly", {
    name = "Desert",
    location = "forest",
    tasks = {--一张表，囊括所有固定要用于生成世界的task
        "Desert Graveyard",                   
    },
    valid_start_tasks = {--一张表，生成世界时，会随机从中选择一个作为生成世界的第一个task，可能会影响到世界的生成结果
        "Desert Graveyard",
    },

set_pieces = { -- 奇遇表。其中的元素格式为["奇遇名"]={count=奇遇数量,tasks=可用该奇遇的所有task的表。这些奇遇在哪个task上生成，是随机选择的
    
    },
})

AddTask("Desert Graveyard", {			
          room_choices={["tiledemo_room"] = 1,--组成这个task的room表，可以为每个room设定数量，还可以设定随机的数量（写成函数形式）
		               
		               },
 			background_room="Blank",--用于填充的room。在生成世界时，如果room_choices中的room太少，就会随机生成一些填充room。如果不希望生成这些填充room,此项可以填"Blank"
			colour={r=0,g=0,b=0,a=0}-- 用途不明，估计是用于Debug的		
			}) 	

AddRoom("tiledemo_room", {
			colour={r=0,g=0,b=0,a=0},
			value=GROUND.GRASS,--房间的地面
			contents =  {}
			
})	
--自定义开始位置与胸部
AddStartLocation("DefaultStart", {
    name = "Desert",
    location = "forest",
	start_setpeice = "DefaultStart",
	start_node = "tiledemo_room",
})

-- 自定义世界预置

AddLevel(LEVELTYPE.SURVIVAL, {
    id = "DESERTONLY",-- 系统用于识别level的依据
    name = "Desert-A",--level的名字，会在主持房间时，在世界选项设置里看到
    desc = "Desert-Only Challenge!",--level的描述，和名字一样会在世界选项中看到，写在名字的下方
    location = "forest",-- 位置，forest为地上，cave为地下。location是一个类，它的数据表里有override表，内含所有必须填写的override数据。这些数据可以被level的override表中的同名属性覆盖
    version = 2,--版本，目前固定为2，一般不要改动
    overrides = { -- 覆盖表，里面有很多重要的信息
        task_set = "desertonly",--指定要使用的taskset
        start_location = "DefaultStart",-- 指定要使用的start_location
        roads = "never",--设定道路生成数量还有一些额外的属性也是在这张表里的，但这些属性是为世界设置服务的，可以在房间设置中进行设置。
        ordered_story_setpieces = {--用于传送的镶嵌物
            "Sculptures_1",
            "Maxwell5",
        },
        numrandom_set_pieces = 4,--全图随机奇遇的数量
        random_set_pieces = {--设置随机选择的部件
        
        },
    },
})


local Amount = 0.2                      ----------------地图上生成的东西

local function BGMarshPreInit(room)                  ----沼泽
	if not room.contents.distributeprefabs then
		room.contents.distributeprefabs = {}
	end
	room.contents.distributeprefabs.desertpalm = .01
	room.contents.distributeprefabs.desertpalm_normal = .01
	room.contents.distributeprefabs.desertpalm_tall = .01
	room.contents.distributeprefabs.desertpalm_short = .01
	room.contents.distributepercent = Amount
end
AddRoomPreInit("BGMarsh", BGMarshPreInit)
local function BGForestPreInit(room)                 ---- 树木
	if not room.contents.distributeprefabs then
		room.contents.distributeprefabs = {}
	end
	room.contents.distributeprefabs.desertpalm = .01
	room.contents.distributeprefabs.desertpalm_normal = .01
	room.contents.distributeprefabs.desertpalm_tall = .01
	room.contents.distributeprefabs.desertpalm_short = .01
	room.contents.distributepercent = Amount

end
AddRoomPreInit("BGForest", BGForestPreInit) 
local function BGGrassPreInit(room)                        ----绿草地
	if not room.contents.distributeprefabs then
		room.contents.distributeprefabs = {}
	end
	room.contents.distributeprefabs.desertpalm = .01
	room.contents.distributeprefabs.desertpalm_normal = .01
	room.contents.distributeprefabs.desertpalm_tall = .01
	room.contents.distributeprefabs.desertpalm_short = .01
	room.contents.distributepercent = Amount

end
AddRoomPreInit("BGGrass", BGGrassPreInit)           --- 草地
local function BGRockyPreInit(room)
	if not room.contents.distributeprefabs then
		room.contents.distributeprefabs = {}
	end
	room.contents.distributeprefabs.desertpalm = .01
	room.contents.distributeprefabs.desertpalm_normal = .01
	room.contents.distributeprefabs.desertpalm_tall = .01
	room.contents.distributeprefabs.desertpalm_short = .01
	room.contents.distributepercent = Amount

end
AddRoomPreInit("BGRocky", BGRockyPreInit)             ----石头大陆
local function BGSavannaPreInit(room)
	if not room.contents.distributeprefabs then
		room.contents.distributeprefabs = {}
	end
	room.contents.distributeprefabs.desertpalm = .01
	room.contents.distributeprefabs.desertpalm_normal = .01
	room.contents.distributeprefabs.desertpalm_tall = .01
	room.contents.distributeprefabs.desertpalm_short = .01
	room.contents.distributepercent = Amount

end
AddRoomPreInit("BGSavanna", BGSavannaPreInit)
local function BGDirtPreInit(room)                       ----黄草地
	if not room.contents.distributeprefabs then
		room.contents.distributeprefabs = {}
	end
	room.contents.distributeprefabs.desertpalm = .01
	room.contents.distributeprefabs.desertpalm_normal = .01
	room.contents.distributeprefabs.desertpalm_tall = .01
	room.contents.distributeprefabs.desertpalm_short = .01
	room.contents.distributepercent = Amount

end
AddRoomPreInit("BGDirt", BGDirtPreInit)



local g       = GLOBAL
local AddTask = GLOBAL.AddTask
local AddRoom = GLOBAL.AddRoom
local LOCKS   = GLOBAL.LOCKS
local KEYS    = GLOBAL.KEYS
local GROUND  = GLOBAL.GROUND

AddTask("lh_MinotaurArea", {
    locks=LOCKS.NONE,
	keys_given={KEYS.TIER1},
    room_choices =
    {
        ["LabyrinthGuarden"] = 1,
    },
    room_bg = GROUND.TILES,
    background_room="BGGrass",
    colour={r=0,g=1,b=0,a=1},
})

local function Add_Cave_OnGround()	
	AddTaskSetPreInit("default", function(tasksetdata)
		if type(tasksetdata)=="table" and type(tasksetdata.tasks)=="table" then
			local tab=
			{
				--
				--"MudWorld",
				--"MudCave",
				--"MudLights",
				--"MudPit",
				--"ToadStoolTask1",
				--"ToadStoolTask2",
				--"ToadStoolTask3",
				"lh_MinotaurArea",
				--"BigBatCave",
				--"RockyLand",
				"RedForest",
				"GreenForest",
				"BlueForest",
				--"SpillagmiteCaverns",
				--"LichenLand",
				--"Residential",
				--"Military",
				--"Sacred",
				--"SacredAltar",
				
				--"SwampySinkhole",
				--"CaveSwamp",
				--"UndergroundForest",
				--"PleasantSinkhole",
				--"FungalNoiseForest",
				--"FungalNoiseMeadow",
				--"BatCloister",
				"RabbitTown",
				"RabbitCity",
				--"SpiderLand",
				"RabbitSpiderWar",
				"AtriumMaze",
			}
			for k,v in pairs(tab) do
				if v then
					table.insert(tasksetdata.tasks, v)
				end
			end
		end
	end)
end

Add_Cave_OnGround()





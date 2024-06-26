return {
	["version"] = "1.1",
	["luaversion"] = "5.1",
	["orientation"] = "orthogonal",
	["width"] = 31,
	["height"] = 31,
	["tilewidth"] = 64,
	["tileheight"] = 64,
	["properties"] = {},
	["tilesets"] = {
		{
		["name"] = "tiles",
		["firstgid"] = 1,
		["tilewidth"] = 64,
		["tileheight"] = 64,
		["spacing"] = 0,
		["margin"] = 0,
		["image"] = "../../../../tools/tiled/dont_starve/tiles.png",
		["imagewidth"] = 512,
		["imageheight"] = 384,
		["properties"] = {},
		["tiles"] = {}
		}
	},
	["layers"] = {
		{
		["type"] = "tilelayer",
		["name"] = "BG_TILES",
		["x"] = 0,
		["y"] = 0,
		["width"] = 31,
		["height"] = 31,
		["visible"] = true,
		["opacity"] = 1,
		["properties"] = {},
		["encoding"] = "lua",
		["data"] = {
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 
			0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,32,32,32,32,1,1,1,1,1,1,1,1,0, 
			0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,32,32,32,32,32,32,32,32,32,32,1,1,1,1,1,0, 
			0,1,1,1,1,1,1,1,1,1,1,32,32,32,32,32,32,32,32,32,32,32,32,32,32,1,1,1,1,1,0, 
			0,1,1,1,1,1,1,1,1,1,1,32,32,32,32,32,32,32,32,32,32,32,32,32,32,1,1,1,1,1,0, 
			0,1,1,1,1,1,1,1,1,1,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,1,1,1,1,0, 
			0,1,1,1,1,1,1,1,1,1,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,1,1,1,1,0, 
			0,1,1,1,1,1,1,1,1,1,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,1,1,0, 
			0,1,1,1,1,1,1,1,1,1,1,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,1,1,0, 
			0,1,1,1,1,1,1,1,1,1,1,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,1,1,0, 
			0,1,1,1,1,1,1,1,1,1,1,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,1,1,0, 
			0,1,1,1,1,1,1,1,1,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,1,1,1,1,0, 
			0,1,1,1,1,32,32,1,1,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,1,1,1,1,0, 
			0,1,1,1,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,1,1,1,1,0, 
			0,1,1,1,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,1,1,1,1,0, 
			0,1,1,1,32,32,32,32,32,32,32,32,32,32,32,32,1,1,32,32,32,32,32,32,32,1,1,1,1,1,0, 
			0,1,32,32,32,7,7,7,32,32,32,32,32,32,32,1,1,1,32,32,32,32,32,32,1,1,1,1,1,1,0, 
			0,32,32,32,7,7,6,6,32,32,32,32,32,1,1,1,1,1,1,1,32,32,32,1,1,1,1,1,1,1,0, 
			0,32,32,7,7,6,6,6,6,7,32,32,32,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0, 
			0,1,32,7,7,6,6,6,6,7,32,32,32,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0, 
			0,1,32,7,7,7,6,6,7,7,32,32,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0, 
			0,1,32,32,7,7,7,7,7,32,32,32,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0, 
			0,1,32,32,32,7,7,7,32,32,32,32,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0, 
			0,1,32,32,32,32,32,32,32,32,32,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0, 
			0,1,1,32,32,32,32,32,1,32,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0, 
			0,1,1,1,32,32,32,32,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0, 
			0,1,1,1,1,32,32,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0, 
			0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0, 
			0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0, 
			0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0, 
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 
		}
	},
	{
		["type"] = "objectgroup",
		["name"] = "FG_OBJECTS",
		["visible"] = true,
		["opacity"] = 1,
		["properties"] = {},
		["objects"] = {
			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 130.00,			
				["y"] = 1103.28,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 148.75,			
				["y"] = 1222.62,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 155.55,			
				["y"] = 1363.73,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "evergreen_sparse",			
				["shape"] = "rectangle",
				["x"] = 183.81,			
				["y"] = 1166.29,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 178.10,			
				["y"] = 1472.18,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "evergreen",			
				["shape"] = "rectangle",
				["x"] = 208.51,			
				["y"] = 1067.76,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "evergreen_sparse",			
				["shape"] = "rectangle",
				["x"] = 213.26,			
				["y"] = 1379.04,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 219.47,			
				["y"] = 1264.91,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "bullkelp_plant",			
				["shape"] = "rectangle",
				["x"] = 228.51,			
				["y"] = 615.52,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 232.88,			
				["y"] = 1135.36,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 233.63,			
				["y"] = 1220.56,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 250.22,			
				["y"] = 1265.01,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 242.64,			
				["y"] = 1548.56,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 254.38,			
				["y"] = 1310.50,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 259.22,			
				["y"] = 988.08,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 263.17,			
				["y"] = 1192.62,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 257.55,			
				["y"] = 1448.11,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 260.85,			
				["y"] = 1360.11,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "flower",			
				["shape"] = "rectangle",
				["x"] = 266.00,			
				["y"] = 1235.31,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 283.01,			
				["y"] = 1101.25,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 291.22,			
				["y"] = 1129.84,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 291.92,			
				["y"] = 1335.57,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 297.42,			
				["y"] = 1092.53,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 297.68,			
				["y"] = 1060.42,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 302.30,			
				["y"] = 842.77,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 315.58,			
				["y"] = 1054.91,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 313.81,			
				["y"] = 1406.62,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 323.84,			
				["y"] = 1374.22,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "evergreen_sparse",			
				["shape"] = "rectangle",
				["x"] = 325.30,			
				["y"] = 1485.39,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 336.85,			
				["y"] = 926.29,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 345.55,			
				["y"] = 1101.28,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 350.22,			
				["y"] = 1046.50,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 343.06,			
				["y"] = 1584.74,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 352.13,			
				["y"] = 1438.74,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "flower",			
				["shape"] = "rectangle",
				["x"] = 369.10,			
				["y"] = 1374.56,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "bullkelp_plant",			
				["shape"] = "rectangle",
				["x"] = 363.68,			
				["y"] = 281.90,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 382.05,			
				["y"] = 1021.76,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 382.38,			
				["y"] = 1513.55,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 378.43,			
				["y"] = 1662.66,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 394.64,			
				["y"] = 851.57,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 393.50,			
				["y"] = 1422.11,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 412.98,			
				["y"] = 1029.42,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 437.14,			
				["y"] = 1056.50,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 437.22,			
				["y"] = 944.08,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fangcunhill",			
				["shape"] = "rectangle",
				["x"] = 448.00,			
				["y"] = 1216.00,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 454.85,			
				["y"] = 1016.42,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "evergreen",			
				["shape"] = "rectangle",
				["x"] = 443.84,			
				["y"] = 1614.03,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 469.39,			
				["y"] = 1467.84,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 467.14,			
				["y"] = 1542.94,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 487.42,			
				["y"] = 1035.94,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 488.51,			
				["y"] = 878.26,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 486.10,			
				["y"] = 1373.18,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "bullkelp_plant",			
				["shape"] = "rectangle",
				["x"] = 482.88,			
				["y"] = 294.86,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 511.92,			
				["y"] = 1386.21,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 519.89,			
				["y"] = 961.57,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "berrybush2",			
				["shape"] = "rectangle",
				["x"] = 521.58,			
				["y"] = 852.00,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 528.75,			
				["y"] = 1016.11,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 531.26,			
				["y"] = 1353.36,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 539.81,			
				["y"] = 1321.10,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 539.14,			
				["y"] = 1395.15,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 544.51,			
				["y"] = 1001.90,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 548.64,			
				["y"] = 934.46,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 549.09,			
				["y"] = 870.83,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 555.79,			
				["y"] = 1303.01,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 558.67,			
				["y"] = 1330.74,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 563.89,			
				["y"] = 974.32,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "driftwood_log",			
				["shape"] = "rectangle",
				["x"] = 536.80,			
				["y"] = 1902.40,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "evergreen_sparse",			
				["shape"] = "rectangle",
				["x"] = 577.01,			
				["y"] = 1491.87,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "flower",			
				["shape"] = "rectangle",
				["x"] = 587.79,			
				["y"] = 938.80,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 590.85,			
				["y"] = 1157.31,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "evergreen_sparse",			
				["shape"] = "rectangle",
				["x"] = 589.68,			
				["y"] = 1370.56,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 593.38,			
				["y"] = 1191.57,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "flower",			
				["shape"] = "rectangle",
				["x"] = 601.76,			
				["y"] = 838.59,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 607.68,			
				["y"] = 1221.57,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 609.68,			
				["y"] = 894.35,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 607.79,			
				["y"] = 728.21,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 616.22,			
				["y"] = 761.39,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 616.43,			
				["y"] = 1443.97,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 625.89,			
				["y"] = 1175.57,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 627.47,			
				["y"] = 1105.15,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 629.84,			
				["y"] = 853.63,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 645.17,			
				["y"] = 1303.76,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock_flintless_low",			
				["shape"] = "rectangle",
				["x"] = 657.06,			
				["y"] = 1093.97,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "berrybush2",			
				["shape"] = "rectangle",
				["x"] = 662.72,			
				["y"] = 746.11,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 672.22,			
				["y"] = 1080.80,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "evergreen_sparse",			
				["shape"] = "rectangle",
				["x"] = 669.60,			
				["y"] = 1454.22,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 676.72,			
				["y"] = 1123.18,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "evergreen_sparse",			
				["shape"] = "rectangle",
				["x"] = 676.30,			
				["y"] = 1255.28,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 682.64,			
				["y"] = 817.31,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 689.97,			
				["y"] = 707.87,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "twigs",			
				["shape"] = "rectangle",
				["x"] = 698.85,			
				["y"] = 1081.94,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "flower",			
				["shape"] = "rectangle",
				["x"] = 699.92,			
				["y"] = 1055.28,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 709.30,			
				["y"] = 750.18,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 715.14,			
				["y"] = 1230.38,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 705.31,			
				["y"] = 366.35,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 717.34,			
				["y"] = 1375.73,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 721.06,			
				["y"] = 539.63,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 731.26,			
				["y"] = 991.18,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachsapling_myth",			
				["shape"] = "rectangle",
				["x"] = 737.26,			
				["y"] = 1042.50,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 738.46,			
				["y"] = 1144.91,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachsapling_myth",			
				["shape"] = "rectangle",
				["x"] = 740.85,			
				["y"] = 766.29,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 742.38,			
				["y"] = 641.94,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "flower",			
				["shape"] = "rectangle",
				["x"] = 752.14,			
				["y"] = 1101.81,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 751.34,			
				["y"] = 611.97,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 758.59,			
				["y"] = 414.46,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 764.51,			
				["y"] = 493.49,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock_flintless_low",			
				["shape"] = "rectangle",
				["x"] = 783.22,			
				["y"] = 992.91,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 781.22,			
				["y"] = 717.18,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 770.72,			
				["y"] = 270.94,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 793.22,			
				["y"] = 1157.73,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 779.38,			
				["y"] = 249.46,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 795.30,			
				["y"] = 490.26,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 803.84,			
				["y"] = 976.50,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "flower",			
				["shape"] = "rectangle",
				["x"] = 806.38,			
				["y"] = 1056.46,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachsapling_myth",			
				["shape"] = "rectangle",
				["x"] = 809.22,			
				["y"] = 919.70,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 816.93,			
				["y"] = 611.90,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachsapling_myth",			
				["shape"] = "rectangle",
				["x"] = 820.30,			
				["y"] = 661.01,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock2",			
				["shape"] = "rectangle",
				["x"] = 815.81,			
				["y"] = 233.70,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 829.52,			
				["y"] = 565.90,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 826.88,			
				["y"] = 355.57,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 835.47,			
				["y"] = 540.32,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 835.30,			
				["y"] = 495.84,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 828.67,			
				["y"] = 290.11,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 853.89,			
				["y"] = 924.02,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 862.51,			
				["y"] = 879.39,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 850.88,			
				["y"] = 261.46,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 870.96,			
				["y"] = 984.70,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 871.73,			
				["y"] = 500.94,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 893.26,			
				["y"] = 957.36,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachsapling_myth",			
				["shape"] = "rectangle",
				["x"] = 896.46,			
				["y"] = 827.22,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 892.54,			
				["y"] = 595.52,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 899.01,			
				["y"] = 896.86,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "flower",			
				["shape"] = "rectangle",
				["x"] = 901.97,			
				["y"] = 421.97,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 906.30,			
				["y"] = 304.08,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 923.22,			
				["y"] = 793.84,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 918.13,			
				["y"] = 463.31,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 911.97,			
				["y"] = 262.86,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 939.68,			
				["y"] = 770.74,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 942.93,			
				["y"] = 581.70,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachsapling_myth",			
				["shape"] = "rectangle",
				["x"] = 942.64,			
				["y"] = 542.08,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 950.46,			
				["y"] = 846.77,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "berrybush2",			
				["shape"] = "rectangle",
				["x"] = 954.05,			
				["y"] = 891.18,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 936.10,			
				["y"] = 209.76,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 953.47,			
				["y"] = 554.50,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachsapling_myth",			
				["shape"] = "rectangle",
				["x"] = 960.96,			
				["y"] = 784.59,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 972.85,			
				["y"] = 1027.01,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 983.81,			
				["y"] = 959.46,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 975.38,			
				["y"] = 429.46,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 985.50,			
				["y"] = 761.22,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 991.68,			
				["y"] = 884.46,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "flower",			
				["shape"] = "rectangle",
				["x"] = 999.50,			
				["y"] = 917.81,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "flower",			
				["shape"] = "rectangle",
				["x"] = 993.73,			
				["y"] = 559.46,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 999.17,			
				["y"] = 533.63,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1010.14,			
				["y"] = 729.04,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 1013.50,			
				["y"] = 781.87,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 1007.63,			
				["y"] = 350.22,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "berrybush",			
				["shape"] = "rectangle",
				["x"] = 1023.30,			
				["y"] = 885.81,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1035.47,			
				["y"] = 781.60,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "flower",			
				["shape"] = "rectangle",
				["x"] = 1037.26,			
				["y"] = 934.08,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 1040.80,			
				["y"] = 966.98,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 1045.84,			
				["y"] = 856.98,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 1049.58,			
				["y"] = 893.55,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 1048.67,			
				["y"] = 739.84,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1040.10,			
				["y"] = 399.81,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachsapling_myth",			
				["shape"] = "rectangle",
				["x"] = 1046.59,			
				["y"] = 516.80,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 1041.55,			
				["y"] = 255.18,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1039.31,			
				["y"] = 194.56,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 1058.05,			
				["y"] = 702.91,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1050.30,			
				["y"] = 279.73,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "flower",			
				["shape"] = "rectangle",
				["x"] = 1067.50,			
				["y"] = 530.56,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachsapling_myth",			
				["shape"] = "rectangle",
				["x"] = 1072.38,			
				["y"] = 729.66,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "flower",			
				["shape"] = "rectangle",
				["x"] = 1068.93,			
				["y"] = 179.70,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 1092.88,			
				["y"] = 757.81,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "myth_farm_spawn",			
				["shape"] = "rectangle",
				["x"] = 1095.68,			
				["y"] = 933.01,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "berrybush2",			
				["shape"] = "rectangle",
				["x"] = 1093.92,			
				["y"] = 316.14,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1102.22,			
				["y"] = 541.49,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 1113.94,			
				["y"] = 854.70,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1112.80,			
				["y"] = 697.10,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 1124.30,			
				["y"] = 959.12,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "twigs",			
				["shape"] = "rectangle",
				["x"] = 1126.56,			
				["y"] = 971.22,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 1126.67,			
				["y"] = 838.98,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1117.14,			
				["y"] = 413.07,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock_flintless_med",			
				["shape"] = "rectangle",
				["x"] = 1115.89,			
				["y"] = 202.18,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1134.43,			
				["y"] = 776.86,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 1122.96,			
				["y"] = 255.04,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1143.06,			
				["y"] = 468.50,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 1131.71,			
				["y"] = 163.87,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1154.75,			
				["y"] = 965.28,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 1159.58,			
				["y"] = 837.76,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 1164.51,			
				["y"] = 885.15,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachsapling_myth",			
				["shape"] = "rectangle",
				["x"] = 1163.73,			
				["y"] = 751.84,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 1166.64,			
				["y"] = 713.46,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "berrybush",			
				["shape"] = "rectangle",
				["x"] = 1169.79,			
				["y"] = 949.46,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachsapling_myth",			
				["shape"] = "rectangle",
				["x"] = 1166.30,			
				["y"] = 514.91,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 1153.84,			
				["y"] = 104.56,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1179.79,			
				["y"] = 1041.57,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1166.34,			
				["y"] = 302.08,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 1185.26,			
				["y"] = 850.11,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 1176.26,			
				["y"] = 359.97,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 1189.97,			
				["y"] = 902.29,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "bullkelp_plant",			
				["shape"] = "rectangle",
				["x"] = 1162.72,			
				["y"] = 1983.79,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "flower",			
				["shape"] = "rectangle",
				["x"] = 1177.71,			
				["y"] = 206.26,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1204.46,			
				["y"] = 724.46,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "berrybush2",			
				["shape"] = "rectangle",
				["x"] = 1200.13,			
				["y"] = 518.74,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 1197.97,			
				["y"] = 253.07,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 1208.14,			
				["y"] = 443.31,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1228.26,			
				["y"] = 872.80,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 1207.17,			
				["y"] = 115.76,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 1222.10,			
				["y"] = 367.63,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 1213.92,			
				["y"] = 176.42,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1231.30,			
				["y"] = 561.87,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "flower",			
				["shape"] = "rectangle",
				["x"] = 1233.50,			
				["y"] = 521.97,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachsapling_myth",			
				["shape"] = "rectangle",
				["x"] = 1241.06,			
				["y"] = 774.94,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1247.89,			
				["y"] = 1007.07,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 1252.30,			
				["y"] = 720.02,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 1246.13,			
				["y"] = 224.56,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 1265.84,			
				["y"] = 809.07,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachsapling_myth",			
				["shape"] = "rectangle",
				["x"] = 1266.93,			
				["y"] = 499.73,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 1274.93,			
				["y"] = 889.49,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1265.10,			
				["y"] = 412.86,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "berrybush2",			
				["shape"] = "rectangle",
				["x"] = 1264.59,			
				["y"] = 304.86,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "flower",			
				["shape"] = "rectangle",
				["x"] = 1267.89,			
				["y"] = 167.66,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 1293.39,			
				["y"] = 729.39,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1280.85,			
				["y"] = 212.35,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock_flintless_med",			
				["shape"] = "rectangle",
				["x"] = 1297.26,			
				["y"] = 558.46,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 1305.09,			
				["y"] = 1056.46,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 1312.43,			
				["y"] = 992.91,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "flower",			
				["shape"] = "rectangle",
				["x"] = 1290.72,			
				["y"] = 128.62,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1318.88,			
				["y"] = 725.25,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 1328.05,			
				["y"] = 857.73,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1322.59,			
				["y"] = 540.74,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1322.34,			
				["y"] = 454.70,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "berrybush",			
				["shape"] = "rectangle",
				["x"] = 1320.46,			
				["y"] = 356.91,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1334.54,			
				["y"] = 807.63,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1323.34,			
				["y"] = 269.31,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 1343.73,			
				["y"] = 1069.76,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1352.18,			
				["y"] = 915.15,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 1351.22,			
				["y"] = 750.14,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 1349.76,			
				["y"] = 585.63,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "berrybush",			
				["shape"] = "rectangle",
				["x"] = 1362.64,			
				["y"] = 1032.98,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 1364.85,			
				["y"] = 955.39,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 1357.89,			
				["y"] = 382.98,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "flower",			
				["shape"] = "rectangle",
				["x"] = 1364.88,			
				["y"] = 552.94,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 1353.06,			
				["y"] = 159.36,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "flower",			
				["shape"] = "rectangle",
				["x"] = 1377.79,			
				["y"] = 654.46,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 1364.67,			
				["y"] = 228.42,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1384.30,			
				["y"] = 698.77,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 1388.72,			
				["y"] = 904.94,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1393.10,			
				["y"] = 612.26,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1384.10,			
				["y"] = 201.90,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 1398.75,			
				["y"] = 543.31,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 1381.84,			
				["y"] = 122.38,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1396.93,			
				["y"] = 383.01,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1409.81,			
				["y"] = 1050.59,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1417.89,			
				["y"] = 760.08,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 1421.63,			
				["y"] = 835.90,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1426.00,			
				["y"] = 940.00,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "rock1",			
				["shape"] = "rectangle",
				["x"] = 1407.84,			
				["y"] = 153.07,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "flower",			
				["shape"] = "rectangle",
				["x"] = 1433.52,			
				["y"] = 639.46,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1435.22,			
				["y"] = 282.53,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 1450.30,			
				["y"] = 668.94,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1446.72,			
				["y"] = 498.08,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 1454.59,			
				["y"] = 420.11,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1476.80,			
				["y"] = 826.66,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 1481.06,			
				["y"] = 723.76,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 1484.96,			
				["y"] = 880.29,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 1493.79,			
				["y"] = 987.73,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1482.02,			
				["y"] = 172.11,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 1489.01,			
				["y"] = 291.94,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "sapling",			
				["shape"] = "rectangle",
				["x"] = 1500.43,			
				["y"] = 570.62,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1504.96,			
				["y"] = 675.57,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1497.89,			
				["y"] = 318.46,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 1511.31,			
				["y"] = 769.28,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1510.30,			
				["y"] = 433.22,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1534.30,			
				["y"] = 949.76,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1530.38,			
				["y"] = 628.62,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 1538.72,			
				["y"] = 874.59,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "berrybush",			
				["shape"] = "rectangle",
				["x"] = 1543.26,			
				["y"] = 829.01,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "berrybush",			
				["shape"] = "rectangle",
				["x"] = 1549.84,			
				["y"] = 529.94,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "fireflies",			
				["shape"] = "rectangle",
				["x"] = 1564.67,			
				["y"] = 401.22,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1584.22,			
				["y"] = 755.81,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "berrybush",			
				["shape"] = "rectangle",
				["x"] = 1576.00,			
				["y"] = 355.10,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1574.54,			
				["y"] = 224.53,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1590.80,			
				["y"] = 548.66,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1608.02,			
				["y"] = 910.80,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "grass",			
				["shape"] = "rectangle",
				["x"] = 1615.47,			
				["y"] = 701.63,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1616.10,			
				["y"] = 653.31,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1611.73,			
				["y"] = 434.53,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "berrybush",			
				["shape"] = "rectangle",
				["x"] = 1648.13,			
				["y"] = 560.22,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "bullkelp_plant",			
				["shape"] = "rectangle",
				["x"] = 1643.06,			
				["y"] = 1620.80,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1723.26,			
				["y"] = 575.63,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

			{
				["name"] = "",
				["type"] = "peachtree_myth",			
				["shape"] = "rectangle",
				["x"] = 1720.88,			
				["y"] = 483.42,			
				["width"] = 0,
				["height"] = 0,
				["visible"] = true,
				["properties"] = {}
			},

		}
    },			

	}
}
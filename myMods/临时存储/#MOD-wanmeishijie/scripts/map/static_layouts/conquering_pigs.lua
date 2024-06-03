return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.11.0",
  orientation = "orthogonal",
  width = 4,
  height = 4,
  tilewidth = 64,
  tileheight = 64,
  nextobjectid = 23,
  properties = {},
  tilesets = {
    {
      name = "ground",
      firstgid = 1,
      filename = "../../../../Set Piece Tiles/ground.tsx",
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      image = "../../../../Set Piece Tiles/tiles.png",
      imagewidth = 512,
      imageheight = 384,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tiles = 
      {
        {
          id = 6,
          properties = {
            ["id"] = "GRASS"
          },
          width = 64,
          height = 64
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "BG_TILES",
      x = 0,
      y = 0,
      width = 4,
      height = 4,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        6, 6, 6, 6,
        6, 6, 6, 6,
        6, 6, 6, 6,
        6, 6, 6, 6
      }
    },
    {
      type = "objectgroup",
      name = "FG_OBJECTS",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "treasurechest",
          shape = "rectangle",
          x = 129,
          y = 66,
          width = 28,
          height = 25,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "conquering_pigs"
          }
        },
        {
          id = 2,
          name = "",
          type = "tent",
          shape = "rectangle",
          x = 62,
          y = 37,
          width = 62,
          height = 54,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "firepit",
          shape = "rectangle",
          x = 113,
          y = 110,
          width = 30,
          height = 34,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "sapling",
          shape = "rectangle",
          x = 39,
          y = 27,
          width = 5,
          height = 7,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "sapling",
          shape = "rectangle",
          x = 39,
          y = 40,
          width = 5,
          height = 7,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "",
          type = "sapling",
          shape = "rectangle",
          x = 26,
          y = 27,
          width = 5,
          height = 7,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          type = "sapling",
          shape = "rectangle",
          x = 26,
          y = 40,
          width = 5,
          height = 7,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "",
          type = "pigtorch",
          shape = "rectangle",
          x = 0,
          y = -1,
          width = 18,
          height = 17,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "",
          type = "pigtorch",
          shape = "rectangle",
          x = 197,
          y = 105,
          width = 18,
          height = 17,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "",
          type = "pigtorch",
          shape = "rectangle",
          x = 132,
          y = 232,
          width = 18,
          height = 17,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "",
          type = "pigtorch",
          shape = "rectangle",
          x = 23,
          y = 169,
          width = 18,
          height = 17,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "",
          type = "fast_farmplot",
          shape = "rectangle",
          x = 240,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "",
          type = "fast_farmplot",
          shape = "rectangle",
          x = 240,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 197,
          y = 18,
          width = 1,
          height = 1,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 210,
          y = 18,
          width = 1,
          height = 1,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 223,
          y = 18,
          width = 1,
          height = 1,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 17,
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 197,
          y = 31,
          width = 1,
          height = 1,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 18,
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 197,
          y = 44,
          width = 1,
          height = 1,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 19,
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 210,
          y = 31,
          width = 1,
          height = 1,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 20,
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 223,
          y = 44,
          width = 1,
          height = 1,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 21,
          name = "",
          type = "skeleton",
          shape = "rectangle",
          x = 4,
          y = 243,
          width = 10,
          height = 9,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 22,
          name = "",
          type = "skeleton",
          shape = "rectangle",
          x = 133,
          y = 4,
          width = 6,
          height = 4,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}

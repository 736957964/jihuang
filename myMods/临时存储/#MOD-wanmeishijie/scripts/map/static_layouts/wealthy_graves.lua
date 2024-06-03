return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.11.0",
  orientation = "orthogonal",
  width = 2,
  height = 2,
  tilewidth = 64,
  tileheight = 64,
  nextobjectid = 43,
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
          id = 7,
          properties = {
            ["id"] = "FOREST"
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
      width = 2,
      height = 2,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        7, 7,
        7, 7
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
          type = "wall_wood",
          shape = "rectangle",
          x = 0,
          y = 0,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1",
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 2,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 16,
          y = 0,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 3,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 32,
          y = 0,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 4,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 48,
          y = 0,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 5,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 64,
          y = 0,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 6,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 80,
          y = 0,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 7,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 96,
          y = 0,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 8,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 112,
          y = 0,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 9,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 128,
          y = 0,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1",
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 10,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 0,
          y = 16,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 11,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 0,
          y = 32,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 12,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 0,
          y = 48,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 13,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 0,
          y = 64,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 14,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 0,
          y = 80,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 15,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 0,
          y = 96,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 16,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 0,
          y = 112,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 17,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 0,
          y = 128,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1",
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 18,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 16,
          y = 128,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 19,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 32,
          y = 128,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 20,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 48,
          y = 128,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 21,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 64,
          y = 128,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 22,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 80,
          y = 128,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 23,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 96,
          y = 128,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 24,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 112,
          y = 128,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 25,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 128,
          y = 128,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1",
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 26,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 128,
          y = 16,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 27,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 128,
          y = 32,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 28,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 128,
          y = 48,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 29,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 128,
          y = 64,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 30,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 128,
          y = 80,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 31,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 128,
          y = 96,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 32,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 128,
          y = 112,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "wealthy_graves"
          }
        },
        {
          id = 33,
          name = "",
          type = "purplegem",
          shape = "rectangle",
          x = 69,
          y = 20,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 34,
          name = "",
          type = "redgem",
          shape = "rectangle",
          x = 55,
          y = 71,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 35,
          name = "",
          type = "mound",
          shape = "rectangle",
          x = 20,
          y = 25,
          width = 18,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 36,
          name = "",
          type = "goldnugget",
          shape = "rectangle",
          x = 25,
          y = 106,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 37,
          name = "",
          type = "mound",
          shape = "rectangle",
          x = 72,
          y = 46,
          width = 19,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 38,
          name = "",
          type = "gravestone",
          shape = "rectangle",
          x = 16,
          y = 76,
          width = 19,
          height = 18,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 39,
          name = "",
          type = "gravestone",
          shape = "rectangle",
          x = 97,
          y = 97,
          width = 21,
          height = 19,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 40,
          name = "",
          type = "goldnugget",
          shape = "rectangle",
          x = 107,
          y = 60,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 41,
          name = "",
          type = "goldnugget",
          shape = "rectangle",
          x = 69,
          y = 104,
          width = 9,
          height = 9,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 42,
          name = "",
          type = "skeleton",
          shape = "rectangle",
          x = 107,
          y = 20,
          width = 5,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}

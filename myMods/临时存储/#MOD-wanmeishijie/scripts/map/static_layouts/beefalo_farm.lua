return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.11.0",
  orientation = "orthogonal",
  width = 10,
  height = 10,
  tilewidth = 64,
  tileheight = 64,
  nextobjectid = 358,
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
          id = 5,
          properties = {
            ["id"] = "SAVANNA"
          },
          image = "../../../Set Piece Tiles/SAVANNA.png",
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
      width = 10,
      height = 10,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5
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
          id = 3,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 140,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1"
          }
        },
        {
          id = 4,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 156,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 5,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 172,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 6,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 188,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 7,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 204,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 8,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 220,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 9,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 236,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 10,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 252,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 11,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 268,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 12,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 284,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 13,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 300,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 14,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 316,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 15,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 332,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 16,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 348,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 17,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 364,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 18,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 380,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 19,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 396,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 20,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 412,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 21,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 428,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 22,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 444,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 23,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 460,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 24,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 476,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 27,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 140,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1"
          }
        },
        {
          id = 28,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 156,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 29,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 172,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 30,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 188,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 31,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 204,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 32,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 220,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 33,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 236,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 34,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 252,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 35,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 268,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 36,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 284,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 37,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 300,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 38,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 316,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 39,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 332,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 40,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 348,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 41,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 364,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 42,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 380,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 43,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 396,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 44,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 412,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 45,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 428,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 46,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 444,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 47,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 460,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 48,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 476,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 49,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 492,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1"
          }
        },
        {
          id = 51,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 492,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1"
          }
        },
        {
          id = 52,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 476,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 53,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 460,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 54,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 444,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 55,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 428,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 56,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 412,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 57,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 396,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 58,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 380,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 59,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 364,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 60,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 348,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 61,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 332,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1"
          }
        },
        {
          id = 62,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 316,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".1"
          }
        },
        {
          id = 63,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 300,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1"
          }
        },
        {
          id = 64,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 284,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 65,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 268,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 66,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 252,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 67,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 236,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 68,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 220,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 69,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 204,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 70,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 188,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 71,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 172,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 72,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 156,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 73,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 140,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1"
          }
        },
        {
          id = 75,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 492,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1"
          }
        },
        {
          id = 76,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 476,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 77,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 460,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 78,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 444,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 79,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 428,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 80,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 412,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 81,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 396,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 82,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 380,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 83,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 364,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 84,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 348,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 85,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 332,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 86,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 316,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 87,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 300,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 88,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 284,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 89,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 268,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 90,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 252,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 91,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 236,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 92,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 220,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 93,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 204,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 94,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 188,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 95,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 172,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 96,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 156,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".50"
          }
        },
        {
          id = 97,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 140,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1"
          }
        },
        {
          id = 117,
          name = "",
          type = "beefalo",
          shape = "rectangle",
          x = 425,
          y = 170,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 118,
          name = "",
          type = "beefalo",
          shape = "rectangle",
          x = 215,
          y = 194,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 119,
          name = "",
          type = "beefalo",
          shape = "rectangle",
          x = 195,
          y = 288,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 120,
          name = "",
          type = "beefalo",
          shape = "rectangle",
          x = 290,
          y = 296,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 121,
          name = "",
          type = "beefalo",
          shape = "rectangle",
          x = 299,
          y = 206,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 122,
          name = "",
          type = "beefalo",
          shape = "rectangle",
          x = 423,
          y = 304,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 123,
          name = "",
          type = "beefalo",
          shape = "rectangle",
          x = 346,
          y = 368,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 124,
          name = "",
          type = "beefalo",
          shape = "rectangle",
          x = 249,
          y = 369,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 125,
          name = "",
          type = "beefalo",
          shape = "rectangle",
          x = 186,
          y = 423,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 126,
          name = "",
          type = "beefalo",
          shape = "rectangle",
          x = 178,
          y = 362,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 127,
          name = "",
          type = "beefalo",
          shape = "rectangle",
          x = 477,
          y = 413,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 128,
          name = "",
          type = "beefalo",
          shape = "rectangle",
          x = 450,
          y = 354,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 129,
          name = "",
          type = "beefalo",
          shape = "rectangle",
          x = 421,
          y = 405,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 130,
          name = "",
          type = "beefalo",
          shape = "rectangle",
          x = 382,
          y = 242,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 131,
          name = "",
          type = "beefalo",
          shape = "rectangle",
          x = 364,
          y = 167,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 132,
          name = "",
          type = "beefalo",
          shape = "rectangle",
          x = 467,
          y = 245,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 133,
          name = "",
          type = "beefalo",
          shape = "rectangle",
          x = 255,
          y = 253,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 134,
          name = "",
          type = "beefalo",
          shape = "rectangle",
          x = 179,
          y = 188,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 135,
          name = "",
          type = "beefalo",
          shape = "rectangle",
          x = 256,
          y = 163,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 136,
          name = "",
          type = "beefalo",
          shape = "rectangle",
          x = 365,
          y = 319,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 137,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 194,
          y = 166,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 138,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 328,
          y = 171,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 139,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 273,
          y = 231,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 140,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 195,
          y = 248,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 141,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 256,
          y = 306,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 142,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 198,
          y = 353,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 143,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 340,
          y = 384,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 144,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 391,
          y = 327,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 145,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 418,
          y = 372,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 146,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 397,
          y = 317,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 147,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 320,
          y = 288,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 148,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 235,
          y = 380,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 149,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 369,
          y = 240,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 150,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 474,
          y = 272,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 151,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 503,
          y = 312,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 152,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 417,
          y = 238,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 153,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 403,
          y = 188,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 154,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 343,
          y = 253,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 155,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 333,
          y = 202,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 156,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 428,
          y = 202,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 157,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 438,
          y = 328,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 158,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 405,
          y = 402,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 159,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 311,
          y = 355,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 160,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 244,
          y = 407,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 161,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 174,
          y = 402,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 162,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 175,
          y = 460,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 163,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 181,
          y = 229,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 164,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 171,
          y = 323,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 165,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 241,
          y = 304,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 166,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 251,
          y = 181,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 167,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 156,
          y = 155,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 168,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 478,
          y = 461,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 169,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 398,
          y = 358,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 170,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 313,
          y = 413,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 171,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 262,
          y = 347,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 172,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 364,
          y = 272,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 173,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 303,
          y = 239,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 174,
          name = "",
          type = "poop",
          shape = "rectangle",
          x = 239,
          y = 228,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 175,
          name = "",
          type = "firepit",
          shape = "rectangle",
          x = 348,
          y = 540,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 178,
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 461,
          y = 173,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 179,
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 209,
          y = 417,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 180,
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 225,
          y = 319,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 181,
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 341,
          y = 394,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 182,
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 306,
          y = 248,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 183,
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 223,
          y = 267,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 184,
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 251,
          y = 200,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 185,
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 462,
          y = 428,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 186,
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 362,
          y = 352,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 187,
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 170,
          y = 273,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 190,
          name = "",
          type = "tent",
          shape = "rectangle",
          x = 284,
          y = 540,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 353,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 492,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1"
          }
        },
        {
          id = 354,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1"
          }
        },
        {
          id = 355,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 508,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1"
          }
        },
        {
          id = 356,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 124,
          y = 508,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1"
          }
        },
        {
          id = 357,
          name = "",
          type = "wall_hay",
          shape = "rectangle",
          x = 140,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1"
          }
        }
      }
    }
  }
}

return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.11.0",
  orientation = "orthogonal",
  width = 16,
  height = 16,
  tilewidth = 16,
  tileheight = 16,
  nextobjectid = 51,
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
      width = 16,
      height = 16,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        5, 0, 0, 0, 5, 0, 0, 0, 5, 0, 0, 0, 5, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        5, 0, 0, 0, 5, 0, 0, 0, 5, 0, 0, 0, 5, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        5, 0, 0, 0, 5, 0, 0, 0, 5, 0, 0, 0, 5, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        5, 0, 0, 0, 5, 0, 0, 0, 5, 0, 0, 0, 5, 0, 0, 0
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
          id = 2,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 20,
          y = 20,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1"
          }
        },
        {
          id = 3,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 60,
          y = 20,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1"
          }
        },
        {
          id = 5,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 80,
          y = 20,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 6,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 100,
          y = 20,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 7,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 120,
          y = 20,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 8,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 140,
          y = 20,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 9,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 160,
          y = 20,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 10,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 180,
          y = 20,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 11,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 200,
          y = 20,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 12,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 220,
          y = 20,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 15,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 240,
          y = 20,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1"
          }
        },
        {
          id = 16,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 240,
          y = 40,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 17,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 240,
          y = 60,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 18,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 240,
          y = 80,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 19,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 240,
          y = 100,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 21,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 240,
          y = 120,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 22,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 240,
          y = 140,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 23,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 240,
          y = 160,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 24,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 240,
          y = 180,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 25,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 240,
          y = 200,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 26,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 240,
          y = 220,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 27,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 240,
          y = 240,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1"
          }
        },
        {
          id = 28,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 220,
          y = 240,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 29,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 200,
          y = 240,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 30,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 180,
          y = 240,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 31,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 160,
          y = 240,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 32,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 140,
          y = 240,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 33,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 120,
          y = 240,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 34,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 100,
          y = 240,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 35,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 80,
          y = 240,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 36,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 60,
          y = 240,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 37,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 40,
          y = 240,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 38,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 20,
          y = 240,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = "1"
          }
        },
        {
          id = 39,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 20,
          y = 220,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 40,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 20,
          y = 200,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 41,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 20,
          y = 180,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 42,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 20,
          y = 160,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 43,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 20,
          y = 140,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 44,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 20,
          y = 120,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 45,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 20,
          y = 100,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 46,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 20,
          y = 80,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 47,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 20,
          y = 60,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 48,
          name = "",
          type = "wall_wood",
          shape = "rectangle",
          x = 20,
          y = 40,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["data.health.percent"] = ".5"
          }
        },
        {
          id = 49,
          name = "",
          type = "wall_stone",
          shape = "rectangle",
          x = 126,
          y = 126,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "koalefant_farm"
          }
        }
      }
    }
  }
}

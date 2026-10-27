return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 1,
  height = 1,
  tilewidth = 64,
  tileheight = 64,
  properties = {},
  tilesets = {
    {
      name = "Don't Starve Together Tileset",
      firstgid = 1,
      filename = "../../../../Don't Starve Together Tileset/Don't Starve Together Tileset.tsx",
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      image = "",
      imagewidth = 0,
      imageheight = 0,
      properties = {},
      tiles = {
        {
          id = 0,
          properties = {
            ["id"] = "BRICK"
          }
        },
        {
          id = 1,
          properties = {
            ["id"] = "BRICK_GLOW"
          }
        },
        {
          id = 2,
          properties = {
            ["id"] = "CARPET"
          }
        },
        {
          id = 3,
          properties = {
            ["id"] = "CAVE"
          }
        },
        {
          id = 4,
          properties = {
            ["id"] = "CHECKER"
          }
        },
        {
          id = 5,
          properties = {
            ["id"] = "DECIDUOUS"
          }
        },
        {
          id = 6,
          properties = {
            ["id"] = "DESERT_DIRT"
          }
        },
        {
          id = 7,
          properties = {
            ["id"] = "DIRT"
          }
        },
        {
          id = 8,
          properties = {
            ["id"] = "FOREST"
          }
        },
        {
          id = 9,
          properties = {
            ["id"] = "FUNGUS"
          }
        },
        {
          id = 10,
          properties = {
            ["id"] = "FUNGUSGREEN"
          }
        },
        {
          id = 11,
          properties = {
            ["id"] = "FUNGUSRED"
          }
        },
        {
          id = 12,
          properties = {
            ["id"] = "GRASS"
          }
        },
        {
          id = 13,
          properties = {
            ["id"] = "IMPASSIBLE"
          }
        },
        {
          id = 14,
          properties = {
            ["id"] = "MARSH"
          }
        },
        {
          id = 15,
          properties = {
            ["id"] = "MUD"
          }
        },
        {
          id = 16,
          properties = {
            ["id"] = "ROAD"
          }
        },
        {
          id = 17,
          properties = {
            ["id"] = "ROCKY"
          }
        },
        {
          id = 18,
          properties = {
            ["id"] = "SAVANNA"
          }
        },
        {
          id = 19,
          properties = {
            ["id"] = "SCALE"
          }
        },
        {
          id = 20,
          properties = {
            ["id"] = "SINKHOLE"
          }
        },
        {
          id = 21,
          properties = {
            ["id"] = "TILES"
          }
        },
        {
          id = 22,
          properties = {
            ["id"] = "TILES_GLOW"
          }
        },
        {
          id = 23,
          properties = {
            ["id"] = "TRIM"
          }
        },
        {
          id = 24,
          properties = {
            ["id"] = "TRIM_GLOW"
          }
        },
        {
          id = 25,
          properties = {
            ["id"] = "UNDERROCK"
          }
        },
        {
          id = 26,
          properties = {
            ["id"] = "WEB"
          }
        },
        {
          id = 27,
          properties = {
            ["id"] = "WOODFLOOR"
          }
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
      width = 1,
      height = 1,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        9
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
          name = "",
          type = "critterlab",
          shape = "rectangle",
          x = 32,
          y = 32,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}

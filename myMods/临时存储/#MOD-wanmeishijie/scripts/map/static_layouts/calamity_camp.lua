return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.11.0",
  orientation = "orthogonal",
  width = 5,
  height = 5,
  tilewidth = 64,
  tileheight = 64,
  nextobjectid = 9,
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
      width = 5,
      height = 5,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        6, 6, 6, 6, 6,
        6, 6, 6, 6, 6,
        6, 6, 6, 6, 6,
        6, 6, 6, 6, 6,
        6, 6, 6, 6, 6
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
          name = "treasurechest",
          type = "treasurechest",
          shape = "rectangle",
          x = 102,
          y = 103,
          width = 19,
          height = 19,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "calamity_camp"
          }
        },
        {
          id = 2,
          name = "cookpot",
          type = "cookpot",
          shape = "rectangle",
          x = 197,
          y = 103,
          width = 19,
          height = 19,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "tent",
          type = "tent",
          shape = "rectangle",
          x = 196,
          y = 195,
          width = 19,
          height = 19,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "firehound",
          type = "firehound",
          shape = "rectangle",
          x = 129,
          y = 69,
          width = 61,
          height = 54,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "firehound",
          type = "firehound",
          shape = "rectangle",
          x = 100,
          y = 197,
          width = 61,
          height = 54,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "firehound",
          type = "firehound",
          shape = "rectangle",
          x = 229,
          y = 45,
          width = 61,
          height = 54,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "firehound",
          type = "firehound",
          shape = "rectangle",
          x = 233,
          y = 142,
          width = 61,
          height = 54,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "firepit",
          type = "firepit",
          shape = "rectangle",
          x = 153,
          y = 151,
          width = 19,
          height = 19,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "staff_hounds"
          }
        }
      }
    }
  }
}

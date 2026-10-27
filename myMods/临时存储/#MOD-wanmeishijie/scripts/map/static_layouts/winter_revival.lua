return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.11.0",
  orientation = "orthogonal",
  width = 8,
  height = 8,
  tilewidth = 16,
  tileheight = 16,
  nextobjectid = 8,
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
          id = 9,
          properties = {
            ["id"] = "WOODFLOOR"
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
      width = 8,
      height = 8,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        9, 0, 0, 0, 9, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        9, 0, 0, 0, 9, 0, 0, 0
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
          type = "resurrectionstone",
          shape = "rectangle",
          x = 62,
          y = 60.5,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          type = "firepit",
          shape = "rectangle",
          x = 3,
          y = 2,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "treasurechest",
          shape = "rectangle",
          x = 3,
          y = 32,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "winter_revival"
          }
        },
        {
          id = 4,
          name = "",
          type = "pighead",
          shape = "rectangle",
          x = 124,
          y = 60,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "pighead",
          shape = "rectangle",
          x = 60,
          y = 124,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "",
          type = "pighead",
          shape = "rectangle",
          x = 60,
          y = 0,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          type = "pighead",
          shape = "rectangle",
          x = 0,
          y = 60,
          width = 6,
          height = 6,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}

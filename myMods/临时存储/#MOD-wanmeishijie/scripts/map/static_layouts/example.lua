--[[  Copyright © 2015 Ysovuka/Kzisor  ]]

return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.11.0",
  orientation = "orthogonal",
  width = 24,
  height = 24,
  tilewidth = 16,
  tileheight = 16,
  nextobjectid = 21,
  properties = {},
  tilesets = {
    {
      name = "Tiles",
      firstgid = 1,
      filename = "../../../exported/tiles.tsx",
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      image = "../../../exported/tiles.png",
      imagewidth = 512,
      imageheight = 384,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {
        {
          name = "impassible",
          tile = -1,
          properties = {}
        },
        {
          name = "cobblestone",
          tile = -1,
          properties = {}
        },
        {
          name = "rock",
          tile = -1,
          properties = {}
        },
        {
          name = "dirt",
          tile = -1,
          properties = {}
        },
        {
          name = "savannah",
          tile = -1,
          properties = {}
        },
        {
          name = "grassy",
          tile = -1,
          properties = {}
        },
        {
          name = "forest",
          tile = -1,
          properties = {}
        },
        {
          name = "marsh",
          tile = -1,
          properties = {}
        },
        {
          name = "wooden flooring",
          tile = -1,
          properties = {}
        },
        {
          name = "carpet",
          tile = -1,
          properties = {}
        },
        {
          name = "checkerboard",
          tile = -1,
          properties = {}
        }
      },
      tiles = {
        {
          id = 0,
          terrain = { 0, 0, 0, 0 },
          properties =
          {
            ["id"] = "IMPASSIBLE",
          }
        },
        {
          id = 1,
          terrain = { 1, 1, 1, 1 }
        },
        {
          id = 2,
          terrain = { 2, 2, 2, 2 }
        },
        {
          id = 3,
          terrain = { 3, 3, 3, 3 }
        },
        {
          id = 4,
          terrain = { 4, 4, 4, 4 }
        },
        {
          id = 5,
          terrain = { 5, 5, 5, 5 }
        },
        {
          id = 6,
          terrain = { 6, 6, 6, 6 }
        },
        {
          id = 7,
          terrain = { 7, 7, 7, 7 }
        },
        {
          id = 8,
          terrain = { 8, 8, 8, 8 },
          properties =
          {
            ["id"] = "MARSH",
          }
        },
        {
          id = 9,
          terrain = { 9, 9, 9, 9 }
        },
        {
          id = 10,
          terrain = { 10, 10, 10, 10 }
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
      width = 24,
      height = 24,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1, 0, 0, 0, 8, 0, 0, 0, 8, 0, 0, 0, 8, 0, 0, 0, 8, 0, 0, 0, 1, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1, 0, 0, 0, 8, 0, 0, 0, 8, 0, 0, 0, 8, 0, 0, 0, 8, 0, 0, 0, 1, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1, 0, 0, 0, 8, 0, 0, 0, 8, 0, 0, 0, 8, 0, 0, 0, 8, 0, 0, 0, 1, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1, 0, 0, 0, 8, 0, 0, 0, 8, 0, 0, 0, 8, 0, 0, 0, 8, 0, 0, 0, 1, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1, 0, 0, 0, 1, 0, 0, 0, 8, 0, 0, 0, 8, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0
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
          name = "example_chest",
          type = "treasurechest",
          shape = "rectangle",
          x = 188,
          y = 188,
          width = 7.33333,
          height = 7.66667,
          rotation = 0,
          visible = true,
          properties = {
            ["scenario"] = "example"
          }
        },
        {
          id = 5,
          name = "example_reed",
          type = "reeds",
          shape = "rectangle",
          x = 113.667,
          y = 113,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "example_reed",
          type = "reeds",
          shape = "rectangle",
          x = 301.167,
          y = 157.167,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "example_reed",
          type = "reeds",
          shape = "rectangle",
          x = 103.5,
          y = 297.167,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "example_reed",
          type = "reeds",
          shape = "rectangle",
          x = 164.5,
          y = 217.833,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "example_reed",
          type = "reeds",
          shape = "rectangle",
          x = 227.167,
          y = 290.5,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "example_reed",
          type = "reeds",
          shape = "rectangle",
          x = 235.833,
          y = 167.5,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "example_reed",
          type = "reeds",
          shape = "rectangle",
          x = 195.833,
          y = 107.5,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "example_tentacle",
          type = "tentacle",
          shape = "rectangle",
          x = 84.3333,
          y = 181,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "example_tentacle",
          type = "tentacle",
          shape = "rectangle",
          x = 284.833,
          y = 238.167,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "example_tentacle",
          type = "tentacle",
          shape = "rectangle",
          x = 250.5,
          y = 110.167,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "example_tentacle",
          type = "tentacle",
          shape = "rectangle",
          x = 150.833,
          y = 108.167,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 17,
          name = "example_tentacle",
          type = "tentacle",
          shape = "rectangle",
          x = 163.5,
          y = 264.5,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 18,
          name = "example_tentacle",
          type = "tentacle",
          shape = "rectangle",
          x = 190.167,
          y = 349.167,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 19,
          name = "example_tentacle",
          type = "tentacle",
          shape = "rectangle",
          x = 149.167,
          y = 366.167,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 20,
          name = "example_tentacle",
          type = "tentacle",
          shape = "rectangle",
          x = 233.833,
          y = 370.167,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}

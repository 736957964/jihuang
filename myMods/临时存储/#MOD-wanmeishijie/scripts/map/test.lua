return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.14.2",
  orientation = "orthogonal",
  renderorder = "left-down",
  width = 10,
  height = 10,
  tilewidth = 64,
  tileheight = 64,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "Ground",
      firstgid = 1,
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 4,
      tiles = {
        {
          id = 0,
          image = "../../../Set Piece Tiles/IMPASSIBLE.png",
          width = 64,
          height = 64
        },
        {
          id = 1,
          image = "../../../Set Piece Tiles/ROAD.png",
          width = 64,
          height = 64
        },
        {
          id = 2,
          image = "../../../Set Piece Tiles/ROCKY.png",
          width = 64,
          height = 64
        },
        {
          id = 3,
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
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 10,
      height = 10,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      data = "eJxjYWBgYBnFgwYDAD0/AZE="
    }
  }
}

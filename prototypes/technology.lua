data:extend({
  {
    type = "technology",
    name = "flan-technology",
    icon = "__FLAN__/graphics/technology/flan-technology.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "flantenna"
      }
    },
    prerequisites = {"circuit-network"},
    unit =
    {
      count = 50,
      ingredients =
      {
        {"science-pack-1", 2},
        {"science-pack-2", 1},
      },
      time = 10
    },
    order = "a-d-e",
  }
})
-- Adapted from https://mods.factorio.com/mod/underwater-pipes

local hit_effects = require "__base__.prototypes.entity.hit-effects"
local sounds = require "__base__.prototypes.entity.sounds"

local transparent = {a=0.2, r=0.2,g=0.2,b=0.2}
local depth = 0.321


local function hide_background(sprites)
  for name, sprite in pairs(sprites) do
      if string.find(name, "_background$") then
          sprites[name] = {
              filename = "__core__/graphics/empty.png",
              priority = "low",
              height = 1,
              width = 1,
          }
      end
  end
  return sprites
end
local function underwater_hint(sprites, tint, depth)
  for _, sprite in pairs(sprites) do
      if sprite.layers then
          underwater_hint(sprite.layers, tint, depth)
      else
          sprite.tint = tint
          if sprite.hr_version then
              sprite.hr_version.tint = tint
          end
          sprite.shift = sprite.shift or {0,0}
          sprite.shift[2] = sprite.shift[2] + depth
      end
  end
  return hide_background(sprites)
end

local pipe = table.deepcopy(data.raw.pipe.pipe)
pipe.name = "ff-underwater-pipe"
pipe.minable = {mining_time = 0.1, result = "ff-underwater-pipe"}
pipe.collision_mask = {"ground-tile"}
pipe.icons = {
  {icon="__base__/graphics/terrain/water/water-o.png", icon_size=32},
  {icon=pipe.icon, icon_size=pipe.icon_size, tint=transparent},
}
pipe.icon = nil
pipe.icon_size = nil
pipe.pictures = underwater_hint(pipe.pictures, transparent, depth)

data:extend{
  pipe,
  {
    type = "item",
    name = "ff-underwater-pipe",
    icons = {
      {icon="__base__/graphics/terrain/water/water-o.png", icon_size=32},
      {icon="__base__/graphics/icons/pipe.png", icon_size=64, tint=transparent},
    },
    subgroup = "energy-pipe-distribution",
    order = "a[pipe]-a[pipe]-a",
    place_result = "ff-underwater-pipe",
    stack_size = 100
  },
  {
    type = "recipe",
    name = "ff-underwater-pipe",
    energy_required = 0.5,
    ingredients = {
        {"pipe", 2},
        {"steel-plate", 5},
        {"concrete", 20},
    },
    result = "ff-underwater-pipe",
    enabled = false,
  },
}

table.insert(data.raw["technology"]["tank_ship"].effects, 2,
  {
    type = "unlock-recipe",
    recipe = "ff-underwater-pipe"
  }
)
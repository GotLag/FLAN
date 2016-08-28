empty_sprite =
{
  filename = "__core__/graphics/empty.png",
  priority = "extra-high",
  width = 1,
  height = 1
}

antenna = util.table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
antenna.name = "flantenna"
antenna.icon = "__FLAN__/graphics/icons/flantenna.png"
antenna.minable.result = "flantenna"
antenna.collision_box = {{-0.15, -0.15}, {0.15, 0.15}}
antenna.drawing_box = {{-0.6, -3.2}, {0.6, 0.6}}
antenna.item_slot_count = ANTENNA_SIGNAL_SLOTS
antenna.sprites = 
{
  north =
  {
    filename = "__FLAN__/graphics/entity/flantenna/flantenna.png",
    width = 140,
    height = 140,
    frame_count = 1,
    shift = {1.125, -1.125},
  }
}
antenna.sprites.east = antenna.sprites.north
antenna.sprites.south = antenna.sprites.north
antenna.sprites.west = antenna.sprites.north
antenna_activity_sprite =
{
  filename = "__base__/graphics/entity/combinator/activity-leds/combinator-led-arithmetic-west.png",
  width = 13,
  height = 11,
  frame_count = 1
}
antenna.activity_led_sprites =
{
  north = antenna_activity_sprite,
  east = antenna_activity_sprite,
  south = antenna_activity_sprite,
  west = antenna_activity_sprite
}
-- antenna.activity_led_light = nil
antenna.activity_led_light_offsets =
{
  {0, 0},
  {0, 0},
  {0, 0},
  {0, 0}
}
antenna_wire_points =
{
  shadow =
  {
    red = {0.8125, 0.1875},
    green = {0.8125, 0.1875},
  },
  wire =
  {
    red = {0.25, 0.-0.125},
    green = {0.25, 0.03125},
  }
}
antenna.circuit_wire_connection_points =
{
  antenna_wire_points,
  antenna_wire_points,
  antenna_wire_points,
  antenna_wire_points
}
antenna_psu = util.table.deepcopy(data.raw["electric-energy-interface"]["electric-energy-interface"])
antenna_psu.name = "flantenna-power-supply"
antenna_psu.icon = "__FLAN__/graphics/icons/flantenna.png"
antenna_psu.flags = {"not-deconstructable"}
antenna_psu.minable = nil
antenna_psu.max_health = antenna.max_health
antenna_psu.corpse = nil
antenna_psu.collision_mask = {"ghost-layer"}
antenna_psu.collision_box = antenna.collision_box
antenna_psu.selection_box = {{-0.25, -0.25}, {0.25, 0.25}}
antenna_psu.energy_source =
{
  type = "electric",
  buffer_capacity = "889J",
  usage_priority = "secondary-input",
  input_flow_limit = "100kW",
  -- output_flow_limit = "1000kW"
}
antenna_psu.energy_production = "0kW"
antenna_psu.energy_usage = "50kW"
antenna_psu.picture = empty_sprite
antenna_psu.vehicle_impact_sound = nil
antenna_psu.working_sound = nil
antenna_psu.order = "z"

data:extend({
  antenna,
  antenna_psu
})
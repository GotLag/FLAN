FLAN_TOGGLE_PADDING = 0
FLAN_PANEL_PADDING = 2

data:extend({
  {
    type="sprite",
    name="flan-icon",
    filename = "__FLAN__/graphics/gui/flan-icon.png",
    priority = "extra-high-no-scale",
    width = 32,
    height = 32,
  },
  {
    type="sprite",
    name="flan-icon-small",
    filename = "__FLAN__/graphics/gui/flan.png",
    priority = "extra-high-no-scale",
    width = 22,
    height = 22,
  },
  {
    type="sprite",
    name="flan-red-x",
    filename = "__FLAN__/graphics/gui/red-x.png",
    priority = "extra-high-no-scale",
    width = 22,
    height = 22,
  }
})

data.raw["gui-style"].default["flan-frame"] =
{
  type = "frame_style",
  parent = "frame_style",
  top_padding  = FLAN_PANEL_PADDING,
  right_padding = FLAN_PANEL_PADDING,
  bottom_padding = FLAN_PANEL_PADDING,
  left_padding = FLAN_PANEL_PADDING,
  graphical_set =
  {
    type = "composition",
    filename = "__FLAN__/graphics/gui/gui.png",
    priority = "extra-high-no-scale",
    corner_size = {0, 0},
    position = {0, 0}
  }
}
data.raw["gui-style"].default["flan-frame-toggle"] =
{
  type = "frame_style",
  parent = "flan-frame",
  top_padding  = FLAN_TOGGLE_PADDING,
  right_padding = FLAN_TOGGLE_PADDING,
  bottom_padding = FLAN_TOGGLE_PADDING,
  left_padding = FLAN_TOGGLE_PADDING,
}

data.raw["gui-style"].default["flan-button"] =
{
	type = "button_style",
	parent = "button_style",
  top_padding = 0,
  right_padding = 0,
  bottom_padding = 0,
  left_padding = 0,
  width = 34,
  height = 34,
  default_graphical_set =
  {
    type = "none"
  },
  hovered_graphical_set =
  {
    type = "none"
  },
  clicked_graphical_set =
  {
    type = "none"
  }
}
data.raw["gui-style"].default["flan-button-toggle"] =
{
  type = "button_style",
	parent = "flan-button",
  default_graphical_set =
  {
    type = "none"
  },
  hovered_graphical_set =
  {
    type = "composition",
    filename = "__FLAN__/graphics/gui/gui.png",
    priority = "extra-high-no-scale",
    corner_size = {0, 0},
    position = {1, 0}
  },
  clicked_graphical_set =
  {
    type = "composition",
    filename = "__FLAN__/graphics/gui/gui.png",
    priority = "extra-high-no-scale",
    corner_size = {0, 0},
    position = {2, 0}
  }
}
data.raw["gui-style"].default["flan-signal-icon"] =
{
	type = "button_style",
	parent = "flan-button",
  width = 24,
  height = 24
}

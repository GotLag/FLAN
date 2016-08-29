MOD_NAME = "FLAN"
CURRENT_VERSION = "1.0.3"
FACTORIO_VERSION = "0.14"
REBUILD_REQUIRED_VERSION = "1.0.1"
ENTITY_NAME = "flantenna"
TECHNOLOGY_NAME = "flan-technology"
POWER_ENTITY_NAME = "flantenna-power-supply"
UPDATES_PER_TICK = 4

function debug_print(output)
  for _,player in pairs(game.players) do
    player.print(output)
  end
end

function init_global()
  global = global or {}
  global.network = {}
  global.signals = {item = {}, fluid = {}, virtual = {}}
  global.offsets = {}
end

function update_global(changes)
  if changes.mod_changes[MOD_NAME] then
    if (not changes.mod_changes[MOD_NAME].old_version) or
      is_newer_than(REBUILD_REQUIRED_VERSION, changes.mod_changes[MOD_NAME].old_version) then
      init_global()
      for _,surface in pairs(game.surfaces) do
        for _,psu in pairs(surface.find_entities_filtered{name=POWER_ENTITY_NAME}) do
          psu.destroy()
        end
        for _,antenna in pairs(surface.find_entities_filtered{name=ENTITY_NAME}) do
          add_antenna(antenna)
        end
      end
      for _,player in pairs(game.players) do
        if player.gui.top["flan-toggle"] then
          player.gui.top["flan-toggle"].destroy()
        end
        if player.gui.left["flan-panel"] then
          player.gui.left["flan-panel"].destroy()
        end
      end
    end
  end
end

function is_newer_than(new_version_string, old_version_string)
  local new_version = 0
  for n in string.gmatch(new_version_string, '([^.]+)') do
    new_version = new_version * 100
    new_version = new_version + tonumber(n)
  end
  local old_version = 0
  for n in string.gmatch(old_version_string, '([^.]+)') do
    old_version = old_version * 100
    old_version = old_version + tonumber(n)
  end
  return new_version > old_version
end

script.on_init(init_global)
script.on_configuration_changed(update_global)

function add_antenna(antenna)
  table.insert(global.network,
  {
    id = antenna.unit_number,
    entity = antenna,
    control = antenna.get_or_create_control_behavior(),
    psu = antenna.surface.create_entity
    {
      name = POWER_ENTITY_NAME,
      position = antenna.position,
      force = antenna.force    
    },
    signals = {item = {}, fluid = {}, virtual = {}}
  })
  -- debug_print("Added "..#global.network..": "..antenna.unit_number)
  update_offsets()
end

script.on_event(defines.events.on_built_entity, function(event)
  if event.created_entity.name == ENTITY_NAME then
    add_antenna(event.created_entity)
  end
end)
script.on_event(defines.events.on_robot_built_entity, function(event)
  if event.created_entity.name == ENTITY_NAME then
    add_antenna(event.created_entity)
  end
end)

function remove_antenna(dead_antenna)
  for i,antenna in pairs(global.network) do
    if antenna.id == dead_antenna.unit_number then
      -- debug_print("Removed "..i..": "..antenna.id)
      subtract_signals(i)
      antenna.psu.destroy()
      table.remove(global.network, i)
      update_offsets()
    end
  end
end

script.on_event(defines.events.on_preplayer_mined_item, function(event)
  if event.entity.name == ENTITY_NAME then
    remove_antenna(event.entity)
  end
end)
script.on_event(defines.events.on_robot_pre_mined, function(event)
  if event.entity.name == ENTITY_NAME then
    remove_antenna(event.entity)
  end
end)
script.on_event(defines.events.on_entity_died, function(event)
  if event.entity.name == ENTITY_NAME then
    remove_antenna(event.entity)
  end
end)

function update_offsets()
  global.offsets = {}
  local offset_count = math.min(UPDATES_PER_TICK, #global.network)
  for i = 1, offset_count  do
    global.offsets[i] = math.floor(#global.network / offset_count) * i
  end
end

function subtract_signals(index)
  local antenna = global.network[index]
  for type,signals in pairs(antenna.signals) do
    for name,count in pairs(signals) do
      global.signals[type][name] =
        (global.signals[type][name] or 0) - count
      antenna.signals[type][name] = nil
    end
  end
end

function zero_output(index)
  local control = global.network[index].control
  local old_parameters = control.parameters.parameters
  local new_parameters = {parameters={}}
  for _,parameter in pairs(old_parameters) do
    if parameter.signal.name then
      parameter.count = 0
      table.insert(new_parameters.parameters, parameter)
    end
  end
  control.parameters = new_parameters
end

function update_antenna(index)
  subtract_signals(index)
  local antenna = global.network[index]
  local control = antenna.control
  if antenna.psu.energy > 0 then
    if not antenna.red or not antenna.red.valid then
      antenna.red =
       control.get_circuit_network(defines.wire_type.red)
    end
    local red_circuit = antenna.red
    if not antenna.green or not antenna.green.valid then
      antenna.green =
        control.get_circuit_network(defines.wire_type.green)
    end
    local green_circuit = antenna.green
    local old_parameters = control.parameters.parameters
    local new_parameters = {parameters={}}
    for _,parameter in pairs(old_parameters) do
      if parameter.signal.name then
        local red_signal, green_signal = 0, 0
        if red_circuit then
          red_signal = (red_circuit.get_signal(parameter.signal) or 0) - parameter.count
        end
        if green_circuit then
          green_signal = (green_circuit.get_signal(parameter.signal) or 0) - parameter.count
        end
        -- output global count
        parameter.count =
          (global.signals[parameter.signal.type][parameter.signal.name] or 0)
        -- add inbound to global count
        global.signals[parameter.signal.type][parameter.signal.name] =
          parameter.count + red_signal + green_signal
        -- store inbound for next update
        antenna.signals[parameter.signal.type][parameter.signal.name] =
          red_signal + green_signal
        table.insert(new_parameters.parameters, parameter)
      end
    end
    control.parameters = new_parameters
    control.enabled = true
  else
    if control.enabled then
      zero_output(index)
      antenna.control.enabled = false
    end
  end
end

script.on_event(defines.events.on_tick, function(event)
  if #global.network > 0 then
    for _,offset in pairs(global.offsets) do
      update_antenna(((event.tick + offset) % #global.network) + 1)
    end
  end
end)
extends Node3D

@export var power_grid: PowerGrid

func _ready():
	if not power_grid:
		power_grid = PowerGrid.new()
	
	_register_components()
	power_grid.update_grid_state()
	_update_all_component_hud_info() # Initial update

func _register_components():
	# Iterate through all direct children of this Ship node
	for child in get_children():
		if child.has_method("get_component"):
			var component_resource = child.get_component()
			if component_resource:
				# Add to the grid
				power_grid.components.append(component_resource)
				# Connect to the new signal
				child.state_changed.connect(_on_component_state_changed)
				# Also connect to the built-in 'failed' signal
				component_resource.component_failed.connect(_on_component_state_changed)

func _on_component_state_changed():
	# A component was repaired or failed, so update the grid
	power_grid.update_grid_state()
	_update_all_component_hud_info()

func _update_all_component_hud_info():
	# This function ensures that when one component changes state,
	# the HUD for all other components is also updated if needed.
	# This fixes the bug where the JunctionBox HUD didn't update.
	print("Power Grid updated. All components are now powered: ", power_grid.is_grid_powered())

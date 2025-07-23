extends Node3D

@export var power_grid: PowerGrid
# We will add HeatGrid and DataGrid here later

func _ready():
	# Create a new PowerGrid resource if one isn't assigned
	if not power_grid:
		power_grid = PowerGrid.new()
	
	# Find all components in the scene and register them with the grid
	_register_components()
	# Perform an initial update
	power_grid.update_grid_state()

func _register_components():
	for child in get_children():
		if child.has_method("get_component"):
			var component_resource = child.get_component()
			if component_resource:
				power_grid.components.append(component_resource)
				# Connect to the component's failed signal
				component_resource.component_failed.connect(_on_component_state_changed)

func _on_component_state_changed():
	# When any component's state changes, update the whole grid
	power_grid.update_grid_state()

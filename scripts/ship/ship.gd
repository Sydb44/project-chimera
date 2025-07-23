extends Node3D

@export var power_grid: Resource
@export var flight_controller: FlightController

func _ready():
	if not power_grid:
		var power_grid_script = load("res://scripts/systems/power_grid.gd")
		power_grid = power_grid_script.new()
	
	if not flight_controller:
		flight_controller = FlightController.new()
		add_child(flight_controller)
	
	_register_components()
	_register_flight_projectors()
	power_grid.update_grid_state()
	_update_all_component_hud_info()# Initial update

func _physics_process(delta):
	# First, process all components so their states (like power generation) are up-to-date.
	if power_grid:
		for component in power_grid.components:
			if component.has_method("_physics_process"):
				component._physics_process(delta)

		# Now, with updated states, calculate the grid's overall power status.
		power_grid.update_grid_state()

func _register_components():
	# Iterate through all direct children of this Ship node
	for child in get_children():
		if child.has_method("get_component"):
			var component_resource = child.get_component()
			if component_resource:
				power_grid.components.append(component_resource)
				# Connect to the custom signal for repairs
				child.state_changed.connect(_on_component_state_changed)
				# Also connect to the built-in signal for failures
				component_resource.component_failed.connect(_on_component_state_changed)

func _on_component_state_changed():
	# A component was repaired or failed, so update the grid
	print("A component's state changed. Updating power grid.")
	power_grid.update_grid_state()
	_update_all_component_hud_info()

func _update_all_component_hud_info():
	# This function ensures that when one component changes state,
	# the HUD for all other components is also updated if needed.
	# This fixes the bug where the JunctionBox HUD didn't update.
	print("Power Grid updated. All components are now powered: ", power_grid.is_grid_powered())

func _register_flight_projectors():
	for child in get_children():
		if child.has_method("get_component"):
			var component = child.get_component()
			if component is PhaseFieldProjector:
				flight_controller.register_projector(component)

func toggle_flight_mode():
	if flight_controller:
		flight_controller.flight_mode_enabled = !flight_controller.flight_mode_enabled
		print("Flight mode: ", "ON" if flight_controller.flight_mode_enabled else "OFF")

func is_flight_mode_enabled() -> bool:
	return flight_controller and flight_controller.flight_mode_enabled

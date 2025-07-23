extends StaticBody3D

@export var ship_component: Resource

# This function allows the player controller to safely get the component
func get_component():
	return ship_component

func interact():
	if ship_component and ship_component.condition == 0.0:
		print("Repairing component: ", name)
		ship_component.condition = 1.0
		# Tell the ship the grid needs updating.
		# We assume the parent is the ship for this test.
		get_parent()._on_component_state_changed()

extends StaticBody3D

@export var ship_component: Resource

# This function allows the player controller to safely get the component
func get_component():
	return ship_component

func interact():
	if ship_component and ship_component.condition == 0.0:
		print("Repairing component: ", name)
		ship_component.condition = 1.0
		# For now, manually set power. We will connect this to a power grid later.
		ship_component.is_powered = true

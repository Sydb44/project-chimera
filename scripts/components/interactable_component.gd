extends StaticBody3D

# Emitted when this component is repaired or its state changes
signal state_changed

@export var ship_component: ShipComponent

# This function allows the player controller to safely get the component
func get_component():
	return ship_component

func interact():
	if ship_component and ship_component.condition == 0.0:
		print("Repairing component: ", name)
		ship_component.condition = 1.0
		# Emit the signal to notify the ship that a change happened
		state_changed.emit()

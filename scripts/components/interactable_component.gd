extends StaticBody3D

# Emitted when this component is repaired or its state changes
signal state_changed

@export var ship_component: Resource

func get_component():
	return ship_component

func interact():
	print("Player interacted with '", name, "'.")
	state_changed.emit()

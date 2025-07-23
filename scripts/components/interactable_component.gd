extends StaticBody3D
signal state_changed
@export var ship_component: ShipComponent

func get_component():
	return ship_component

func interact():
	print("Player interacted with '", name, "'.")
	# Future repair logic will go here.

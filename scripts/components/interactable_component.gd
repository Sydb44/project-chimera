extends StaticBody3D

const ShipComponentScript = preload("res://scripts/components/ship_component.gd")
@export var ship_component: ShipComponentScript

func interact():
	print("Player interacted with: ", name)
	# We will add repair logic back here later

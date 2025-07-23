extends StaticBody3D

@export var ship_component: ShipComponent

func interact():
	print("Player interacted with: ", name)
	# We will add repair logic back here later

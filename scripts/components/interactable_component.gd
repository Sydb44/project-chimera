extends StaticBody3D

const ShipComponentScript = preload("res://scripts/components/ship_component.gd")
@export var ship_component: ShipComponentScript

func interact():
	# This is now a simple, non-visual repair
	if ship_component and ship_component.condition == 0.0:
		print("Repairing component: ", name)
		ship_component.condition = 1.0
		ship_component.is_powered = true
		# We will add logic to update the main power grid later

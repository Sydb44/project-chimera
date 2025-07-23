extends StaticBody3D

const ShipComponentScript = preload("res://scripts/components/ship_component.gd")
@export var component: ShipComponentScript

func _ready():
	# Create a new ShipComponent resource if none is assigned
	if not component:
		component = ShipComponentScript.new()
	# This makes sure the component knows its in-world name
	component.component_name = self.name

func interact():
	print("Player interacted with: ", self.name)
	# Future logic for interaction will go here.
	# For now, we just need to confirm the interaction works.

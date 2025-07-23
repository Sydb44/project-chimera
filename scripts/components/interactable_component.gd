extends StaticBody3D

@onready var component: ShipComponent = $ShipComponent

func _ready():
	# This makes sure the component knows its in-world name
	if component:
		component.component_name = self.name

func interact():
	print("Player interacted with: ", self.name)
	# Future logic for interaction will go here.
	# For now, we just need to confirm the interaction works.

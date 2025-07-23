extends Node3D

var ship_component

func _ready():
	if not ship_component:
		ship_component = preload("res://scripts/components/ship_component.gd").new()
		ship_component.component_name = "Junction Box"
		ship_component.power_draw = 20.0
		ship_component.condition = 1.0
		ship_component.is_powered = true

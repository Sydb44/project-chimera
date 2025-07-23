class_name ShipComponent
extends Resource

signal component_failed

@export var component_name: String
@export var condition: float = 1.0
@export var is_powered: bool = false

func degrade(amount: float) -> void:
	condition -= amount
	condition = clampf(condition, 0.0, 1.0)
	
	if condition == 0.0:
		component_failed.emit()

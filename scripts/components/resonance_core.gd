class_name ResonanceCore
extends ShipComponent

@export var max_power_output: float = 500.0
@export var plasma_consumption_rate: float = 0.5
@export var plasma_tank: Resource

func _init():
	component_name = "ResonanceCore"
	condition = 1.0
	power_draw = 0.0
	is_powered = false

func _physics_process(delta):
	if not is_instance_valid(plasma_tank): return

	if plasma_tank.quantity > 0:
		plasma_tank.quantity -= plasma_consumption_rate * delta
		power_draw = max_power_output * condition
	else:
		power_draw = 0
		if condition > 0:
			condition = 0.0
			component_failed.emit()

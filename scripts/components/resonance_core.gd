class_name ResonanceCore
extends ShipComponent

@export var max_power_output: float = 500.0
@export var plasma_consumption_rate: float = 0.5
@export var plasma_tank: ChargedPlasma

func _physics_process(delta: float) -> void:
	if plasma_tank and plasma_tank.quantity > 0:
		plasma_tank.quantity -= plasma_consumption_rate * delta
		plasma_tank.quantity = maxf(plasma_tank.quantity, 0.0)
	
	power_draw = max_power_output * condition
	
	if plasma_tank and plasma_tank.quantity <= 0.0:
		condition = 0.0
		component_failed.emit()

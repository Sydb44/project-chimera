class_name ResonanceCore
extends Resource

signal component_failed

@export var component_name: String
@export var condition: float = 1.0
@export var power_draw: float = 0.0
@export var is_powered: bool = false
@export var max_power_output: float = 500.0
@export var plasma_consumption_rate: float = 0.5
@export var plasma_tank: Resource

func degrade(amount: float) -> void:
	condition -= amount
	condition = clampf(condition, 0.0, 1.0)
	
	if condition == 0.0:
		component_failed.emit()

func process_physics(delta: float) -> void:
	if plasma_tank and plasma_tank.quantity > 0:
		plasma_tank.quantity -= plasma_consumption_rate * delta
		plasma_tank.quantity = maxf(plasma_tank.quantity, 0.0)
	
	power_draw = max_power_output * condition
	
	if plasma_tank and plasma_tank.quantity <= 0.0:
		condition = 0.0
		component_failed.emit()

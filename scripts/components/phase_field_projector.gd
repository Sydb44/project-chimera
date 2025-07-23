class_name PhaseFieldProjector
extends ShipComponent

@export var thrust_output: float = 100.0
@export var efficiency_curve: Curve
@export var power_requirement: float = 50.0

func _init():
	component_name = "Phase-Field Projector"
	power_draw = power_requirement
	condition = 1.0

func get_thrust_multiplier() -> float:
	if not is_powered:
		return 0.0
	
	var efficiency = 1.0
	if efficiency_curve:
		efficiency = efficiency_curve.sample(condition)
	
	return thrust_output * condition * efficiency

func _physics_process(delta: float) -> void:
	if condition <= 0.0:
		is_powered = false

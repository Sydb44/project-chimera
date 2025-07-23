class_name FlightController
extends Node3D

@export var player_controller: CharacterBody3D
@export var phase_field_projectors: Array = []
@export var flight_mode_enabled: bool = false

var flight_velocity: Vector3 = Vector3.ZERO
var input_thrust: Vector3 = Vector3.ZERO

func _ready():
	if not player_controller:
		player_controller = get_node("../Player") as CharacterBody3D

func _physics_process(delta: float):
	if flight_mode_enabled:
		_handle_flight_input()
		_apply_flight_physics(delta)

func _handle_flight_input():
	input_thrust = Vector3.ZERO
	
	if Input.is_action_pressed("forward"):
		input_thrust.z -= 1.0
	if Input.is_action_pressed("backward"):
		input_thrust.z += 1.0
	if Input.is_action_pressed("left"):
		input_thrust.x -= 1.0
	if Input.is_action_pressed("right"):
		input_thrust.x += 1.0
	
	if Input.is_action_pressed("thrust_up"):
		input_thrust.y += 1.0
	if Input.is_action_pressed("thrust_down"):
		input_thrust.y -= 1.0

func _apply_flight_physics(delta: float):
	if not player_controller or phase_field_projectors.is_empty():
		return
	
	var total_thrust_multiplier = _calculate_total_thrust()
	var world_thrust = player_controller.global_transform.basis * input_thrust
	
	flight_velocity += world_thrust * total_thrust_multiplier * delta
	
	flight_velocity *= 0.95
	
	player_controller.velocity = flight_velocity
	player_controller.move_and_slide()

func _calculate_total_thrust() -> float:
	var total_thrust = 0.0
	for projector in phase_field_projectors:
		if projector and projector.has_method("get_thrust_multiplier"):
			total_thrust += projector.get_thrust_multiplier()
	return total_thrust

func _calculate_rotational_power() -> float:
	return _calculate_total_thrust() * 0.1

func register_projector(projector):
	if projector and not projector in phase_field_projectors:
		phase_field_projectors.append(projector)

func unregister_projector(projector):
	phase_field_projectors.erase(projector)

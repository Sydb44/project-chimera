extends CharacterBody3D

@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.002

@onready var camera: Camera3D = $Camera3D
@onready var raycast: RayCast3D = $Camera3D/RayCast3D
@onready var hud_label: Label = get_node("/root/TestHangar/HUD/StatusLabel")

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var current_target = null
var last_hud_text = ""

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()
	
	_handle_interaction()
	_handle_debug_input()
	_update_hud()

func _handle_interaction():
	if Input.is_action_just_pressed("interact"):
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider and collider.get_parent().has_method("interact"):
				collider.get_parent().interact()

func _handle_debug_input():
	if Input.is_action_just_pressed("debug_degrade"):
		var power_conduit = get_node("../PowerConduit")
		if power_conduit and power_conduit.ship_component:
			power_conduit.ship_component.degrade(1.0)

func _get_targeted_component():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider and collider.get_parent().has_method("interact"):
			return collider.get_parent()
	return null

func _update_hud():
	var target = _get_targeted_component()
	
	if target != current_target:
		current_target = target
		if current_target and current_target.ship_component:
			var component = current_target.ship_component
			var status = "Powered" if component.is_powered else "Offline"
			var new_text = "%s | Condition: %d%% | Status: %s" % [component.component_name, component.condition * 100, status]
			if new_text != last_hud_text:
				hud_label.text = new_text
				last_hud_text = new_text
		else:
			if last_hud_text != "":
				hud_label.text = ""
				last_hud_text = ""
	
	elif current_target and current_target.ship_component:
		var component = current_target.ship_component
		var status = "Powered" if component.is_powered else "Offline"
		var new_text = "%s | Condition: %d%% | Status: %s" % [component.component_name, component.condition * 100, status]
		if new_text != last_hud_text:
			hud_label.text = new_text
			last_hud_text = new_text

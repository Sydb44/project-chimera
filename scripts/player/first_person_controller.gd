extends CharacterBody3D

@export var speed: float = 5.0
@export var mouse_sensitivity: float = 0.002
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var current_target = null

@onready var camera: Camera3D = $Camera3D
@onready var interaction_raycast: RayCast3D = $Camera3D/InteractionRaycast
@onready var hud_label: Label = get_node("/root/TestHangar/HUD/Label2")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clampf(camera.rotation.x, -PI/2, PI/2)

func _physics_process(delta):
	# Movement
	if not is_on_floor():
		velocity.y -= gravity * delta
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	move_and_slide()
	
	# Game Logic
	_handle_interaction()
	_handle_debug_input()
	_update_hud()
	
func _get_targeted_interactable():
	if interaction_raycast.is_colliding():
		var collider = interaction_raycast.get_collider()
		if is_instance_valid(collider) and collider.has_method("interact"):
			return collider
	return null

func _handle_interaction():
	if Input.is_action_just_pressed("interact"):
		var target = _get_targeted_interactable()
		if is_instance_valid(target):
			target.interact()

func _handle_debug_input():
	if Input.is_action_just_pressed("debug_degrade"):
		var conduit = get_node_or_null("../PowerConduit")
		if is_instance_valid(conduit) and conduit.ship_component:
			conduit.ship_component.degrade(1.0)

func _update_hud():
	var target = _get_targeted_interactable()
	
	# Only update the HUD if the target has changed
	if target != current_target:
		current_target = target
		if is_instance_valid(current_target) and current_target.ship_component:
			var component = current_target.ship_component
			var status = "Powered" if component.is_powered else "Offline"
			hud_label.text = "%s | Condition: %d%% | Status: %s" % [current_target.name, component.condition * 100, status]
		else:
			hud_label.text = ""

	# If we are looking at the same target, we can still update its text if needed
	# This handles the case where the component's state changes while we are looking at it
	elif is_instance_valid(current_target):
		 var component = current_target.ship_component
		 var status = "Powered" if component.is_powered else "Offline"
		 var new_text = "%s | Condition: %d%% | Status: %s" % [current_target.name, component.condition * 100, status]
		 if hud_label.text != new_text:
			 hud_label.text = new_text

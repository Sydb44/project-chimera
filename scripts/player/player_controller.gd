extends CharacterBody3D

@export var speed: float = 5.0
@export var mouse_sensitivity: float = 0.002
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera: Camera3D = $Camera3D
@onready var interaction_raycast: RayCast3D = $Camera3D/InteractionRaycast
@onready var hud_label: Label

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hud_label = get_node("/root/TestHangar/HUD/Label2")

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

	# Interaction
	if Input.is_action_just_pressed("interact") and interaction_raycast.is_colliding():
		var target = interaction_raycast.get_collider()
		if target.has_method("interact"):
			target.interact()

	# Debug
	if Input.is_action_just_pressed("debug_degrade"):
		var conduit = get_node_or_null("../PowerConduit")
		if is_instance_valid(conduit):
			conduit.get_node("ShipComponent").degrade(1.0)
	
	# HUD Update
	_update_hud()

func _update_hud():
	if interaction_raycast.is_colliding():
		var target = interaction_raycast.get_collider()
		if is_instance_valid(target) and target.has_method("get") and target.component:
			var component = target.component
			var status = "Powered" if component.is_powered else "Offline"
			hud_label.text = "%s | Condition: %d%% | Status: %s" % [component.component_name, component.condition * 100, status]
			return
	hud_label.text = ""

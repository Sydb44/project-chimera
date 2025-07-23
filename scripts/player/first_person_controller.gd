extends CharacterBody3D

@export var speed: float = 5.0
@export var mouse_sensitivity: float = 0.002
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera: Camera3D = $Camera3D
@onready var interaction_raycast: RayCast3D = $Camera3D/InteractionRaycast
@export var hud_label: Label

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

	# Input handling for interaction
	if Input.is_action_just_pressed("interact"):
		var target = _get_targeted_interactable()
		if is_instance_valid(target):
			target.interact()

	if Input.is_action_just_pressed("debug_degrade"):
		var target = _get_targeted_interactable()
		if is_instance_valid(target) and target.has_method("get_component"):
			target.get_component().degrade(1.0)

func _process(delta):
	# UI logic
	var target = _get_targeted_interactable()
	if is_instance_valid(target) and target.has_method("get_component"):
		var component = target.get_component()
		var status = "Powered" if component.is_powered else "Offline"
		var new_text = "%s | Condition: %d%% | Status: %s" % [target.name, component.condition * 100, status]
		if hud_label.text != new_text:
			hud_label.text = new_text
	else:
		if hud_label.text != "":
			hud_label.text = ""

func _get_targeted_interactable():
	# This is the new, robust logic
	if not interaction_raycast.is_colliding():
		return null

	var collider = interaction_raycast.get_collider()
	
	# Check if the collider itself has the script
	if is_instance_valid(collider) and collider.has_method("interact"):
		return collider
		
	# If not, check if its parent has the script
	var parent = collider.get_parent()
	if is_instance_valid(parent) and parent.has_method("interact"):
		return parent
		
	# If neither, we're not looking at an interactable
	return null

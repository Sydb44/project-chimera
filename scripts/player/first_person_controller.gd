extends CharacterBody3D

@export var speed: float = 5.0
@export var mouse_sensitivity: float = 0.002
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera: Camera3D = $Camera3D
@onready var interaction_raycast: RayCast3D = $Camera3D/InteractionRaycast
@onready var hud_label: Label = get_node("../HUD/Label2")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clampf(camera.rotation.x, -PI/2, PI/2)

func _physics_process(delta):
	# Movement logic
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	move_and_slide()

	# Interaction
	if Input.is_action_just_pressed("interact"):
		var target = _get_targeted_interactable()
		if is_instance_valid(target):
			target.interact()

	# Debug
	if Input.is_action_just_pressed("debug_degrade"):
		var target = _get_targeted_interactable()
		if is_instance_valid(target) and target.has_method("get_component"):
			target.get_component().degrade(1.0)

func _process(delta):
	update_hud()

func update_hud():
	# Get reference to the ship's power grid
	var ship_node = get_parent().get_node("Ship")
	if not is_instance_valid(ship_node) or not ship_node.power_grid:
		hud_label.text = "No ship data available"
		return
	
	var hud_text = ""
	for component in ship_node.power_grid.components:
		var status = "Powered" if component.is_powered else "Offline"
		var condition_percent = int(component.condition * 100)
		hud_text += "%s | Condition: %d%% | Status: %s\n" % [component.component_name, condition_percent, status]
	
	hud_label.text = hud_text.strip_edges()

func _get_targeted_interactable():
	if not interaction_raycast.is_colliding(): return null
	var collider = interaction_raycast.get_collider()
	if is_instance_valid(collider) and collider.has_method("interact"):
		return collider
	var parent = collider.get_parent()
	if is_instance_valid(parent) and parent.has_method("interact"):
		return parent
	return null

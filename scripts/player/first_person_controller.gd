extends CharacterBody3D

@export var speed: float = 5.0
@export var mouse_sensitivity: float = 0.002

# We will get the HUD label reliably in the _ready function
var hud_label: Label

@onready var camera: Camera3D = $Camera3D
@onready var raycast: RayCast3D = $Camera3D/RayCast3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Find the HUD label using its path in the scene tree. This is more reliable.
	# NOTE: This assumes the HUD scene instance is named 'HUD' in TestHangar.tscn
	hud_label = get_node("/root/TestHangar/HUD/Label")

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	# --- Player Movement ---
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()
	
	# --- Game Logic ---
	_handle_interaction()
	_handle_debug_input()
	_update_hud()

func _handle_interaction():
	if Input.is_action_just_pressed("interact"):
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			# The script is on the parent of the collision shape
			if collider and collider.get_parent().has_method("interact"):
				collider.get_parent().interact()

func _handle_debug_input():
	if Input.is_action_just_pressed("debug_degrade"):
		# This path is brittle but fine for a debug key
		var power_conduit = get_node_or_null("../PowerConduit")
		if power_conduit and "ship_component" in power_conduit:
			power_conduit.ship_component.degrade(1.0)

func _update_hud():
	# Ensure the label exists before trying to use it
	if not is_instance_valid(hud_label):
		return

	if raycast.is_colliding():
		var collider = raycast.get_collider()
		var component_node = collider.get_parent()
		
		if component_node and "ship_component" in component_node:
			var component = component_node.ship_component
			if component:
				var status_text = "Offline"
				if component.is_powered:
					status_text = "Powered"
				
				var condition_percent = int(component.condition * 100)
				hud_label.text = "%s | Condition: %s%% | Status: %s" % [component.component_name, condition_percent, status_text]
				return
	
	# If not looking at a valid component, clear the text
	hud_label.text = ""

extends CharacterBody3D

@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.002

@onready var camera: Camera3D = $Camera3D
@onready var raycast: RayCast3D = $Camera3D/RayCast3D
@onready var hud_label: Label = get_node("../ComponentHUD/StatusLabel")

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

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

func _update_hud():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		# The script is on the parent of the collision shape
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

extends Node3D

var ship_component
@onready var light: OmniLight3D = get_node("../OmniLight3D")

var makeshift_cable: Node3D = null

func _ready():
	if not ship_component:
		ship_component = preload("res://scripts/components/ship_component.gd").new()
		ship_component.component_name = "Power Conduit"
		ship_component.power_draw = -10.0
		ship_component.condition = 1.0
		ship_component.is_powered = true
	
	ship_component.component_failed.connect(_on_component_failed)
	_update_light()

func _update_light():
	if light:
		light.visible = ship_component.is_powered and ship_component.condition > 0.0

func _on_component_failed():
	ship_component.is_powered = false
	_update_light()

func interact():
	print("Interact method called on Power Conduit.")
	if ship_component.condition == 0.0:
		_perform_makeshift_repair()

func _perform_makeshift_repair():
	var junction_box = get_node("../JunctionBox")
	if junction_box:
		_create_visual_cable(junction_box)
		ship_component.is_powered = true
		_update_light()

func _create_visual_cable(target: Node3D):
	if makeshift_cable:
		makeshift_cable.queue_free()
	
	makeshift_cable = CSGCylinder3D.new()
	makeshift_cable.radius = 0.05
	makeshift_cable.height = global_position.distance_to(target.global_position)
	
	var material = StandardMaterial3D.new()
	material.emission_enabled = true
	material.emission = Color.YELLOW
	material.emission_energy = 2.0
	makeshift_cable.material_override = material
	
	get_parent().add_child(makeshift_cable)
	makeshift_cable.global_position = global_position.lerp(target.global_position, 0.5)
	makeshift_cable.look_at(target.global_position, Vector3.UP)
	makeshift_cable.rotate_x(PI/2)

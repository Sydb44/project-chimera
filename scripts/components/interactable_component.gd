extends StaticBody3D

const ShipComponentScript = preload("res://scripts/components/ship_component.gd")
@export var ship_component: ShipComponentScript

# Add this variable at the top of the script
var makeshift_cable: Node3D = null

# Replace the existing interact() function with this one
func interact():
	print("Player interacted with: ", name)
	if ship_component and ship_component.condition == 0.0:
		_perform_makeshift_repair()

# Add the following two new functions to the script
func _perform_makeshift_repair():
	# For now, we'll hardcode the target as the JunctionBox
	var junction_box = get_node_or_null("../JunctionBox")
	if is_instance_valid(junction_box):
		_create_visual_cable(junction_box)
		ship_component.is_powered = true
		# We need a way to update the light. For now, this is a placeholder.
		print("Makeshift repair complete. Component is now powered.")

func _create_visual_cable(target: Node3D):
	if is_instance_valid(makeshift_cable):
		makeshift_cable.queue_free()
	
	makeshift_cable = CSGCylinder3D.new()
	makeshift_cable.radius = 0.05
	makeshift_cable.height = global_position.distance_to(target.global_position)
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.ORANGE
	material.emission_enabled = true
	material.emission = Color.YELLOW
	material.emission_energy = 2.0
	makeshift_cable.material = material
	
	# Add the cable to the main scene, not this node
	get_parent().add_child(makeshift_cable)
	makeshift_cable.global_position = global_position.lerp(target.global_position, 0.5)
	makeshift_cable.look_at(target.global_position)
	makeshift_cable.rotate_x(deg_to_rad(90))

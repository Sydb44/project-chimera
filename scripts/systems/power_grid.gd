extends Node
class_name PowerGrid

var components: Array[ShipComponent] = []

func _ready():
	pass

func update_grid_state():
	var total_supply: float = 0.0
	var total_demand: float = 0.0
	
	for component in components:
		if component.power_draw > 0:
			total_supply += component.power_draw
		else:
			total_demand += abs(component.power_draw)
	
	var power_available: bool = total_supply >= total_demand
	
	for component in components:
		component.is_powered = power_available

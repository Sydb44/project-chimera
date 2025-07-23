class_name PowerGrid
extends Resource

@export var components: Array = []

func update_grid_state():
	var total_supply: float = 0.0
	var total_demand: float = 0.0
	
	for component in components:
		# Only factor in components that are not broken
		if component.condition > 0.0:
			if component.power_draw > 0:
				total_supply += component.power_draw
			else:
				total_demand += abs(component.power_draw)

	var power_available: bool = total_supply >= total_demand
	
	for component in components:
		# Only power components that are not broken
		if component.condition > 0.0:
			component.is_powered = power_available
		else:
			component.is_powered = false

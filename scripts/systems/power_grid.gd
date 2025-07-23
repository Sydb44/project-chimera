class_name PowerGrid
extends Resource

@export var components: Array = []

func update_grid_state():
	var total_supply: float = 0.0
	var total_demand: float = 0.0
	
	# First pass: calculate total available power from working components
	for component in components:
		if component.condition > 0.0 and component.power_draw > 0:
			total_supply += component.power_draw
	
	# Second pass: calculate total demand from working components
	for component in components:
		if component.condition > 0.0 and component.power_draw < 0:
			total_demand += abs(component.power_draw)

	var power_is_sufficient: bool = total_supply >= total_demand
	
	# Final pass: update the power status of every component
	for component in components:
		if component.condition > 0.0 and power_is_sufficient:
			component.is_powered = true
		else:
			component.is_powered = false

func is_grid_powered() -> bool:
	if components.is_empty():
		return false
	# Assumes all components share the same power state
	return components[0].is_powered

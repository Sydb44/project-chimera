class_name PowerGrid
extends Resource

@export var components: Array = []

func update_grid_state():
	var total_supply: float = 0.0
	var total_demand: float = 0.0
	
	# First pass: calculate total available power from working components
	for component in components:
		if component and "condition" in component and "power_draw" in component and component.condition > 0.0 and component.power_draw > 0:
			total_supply += component.power_draw
	
	# Apply random power fluctuation of ±5% to make the grid feel more alive
	if total_supply > 0.0:
		var fluctuation_range = total_supply * 0.05
		var fluctuation = randf_range(-fluctuation_range, fluctuation_range)
		total_supply += fluctuation
		total_supply = max(0.0, total_supply)  # Ensure supply doesn't go negative
	
	# Second pass: calculate total demand from working components
	for component in components:
		if component and "condition" in component and "power_draw" in component and component.condition > 0.0 and component.power_draw < 0:
			total_demand += abs(component.power_draw)

	var power_is_sufficient: bool = total_supply >= total_demand
	
	# Final pass: update the power status of every component
	for component in components:
		if component and "condition" in component and "is_powered" in component:
			if component.condition > 0.0 and power_is_sufficient:
				component.is_powered = true
			else:
				component.is_powered = false

func is_grid_powered() -> bool:
	if components.is_empty():
		return false
	# Assumes all components share the same power state
	return components[0].is_powered

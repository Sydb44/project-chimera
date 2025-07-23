class_name FlightControl
extends ShipComponent

func _init():
	component_name = "Flight Control Console"
	power_draw = 25.0
	condition = 1.0

func interact():
	if not is_powered or condition <= 0.0:
		print("Flight controls are offline!")
		return
	
	var ship = get_node("../../")
	if ship and ship.has_method("toggle_flight_mode"):
		ship.toggle_flight_mode()
		var flight_status = "ENGAGED" if ship.is_flight_mode_enabled() else "DISENGAGED"
		print("Flight mode: ", flight_status)
	else:
		print("Unable to access flight systems!")

func get_status_text() -> String:
	if not is_powered:
		return "OFFLINE"
	elif condition <= 0.5:
		return "DAMAGED"
	else:
		return "OPERATIONAL"

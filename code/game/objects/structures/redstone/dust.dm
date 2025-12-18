/obj/structure/redstone/dust
	name = "redstone dust"
	desc = "Magical dust that can transmit power signals."
	icon_state = "dust"
	redstone_role = REDSTONE_ROLE_CONDUCTOR

/obj/structure/redstone/dust/calculate_received_power(incoming_power, obj/structure/redstone/source)
	// Dust loses 1 power per block from other dust
	if(istype(source, /obj/structure/redstone/dust))
		return max(0, incoming_power - 1)
	// Full power from non-dust sources
	return incoming_power

/obj/structure/redstone/dust/on_power_changed()
	maptext = "[power_level]"

/obj/structure/redstone/dust/update_overlays()
	. = ..()
	if(power_level > 0)
		var/brightness = 0.3 + (power_level / 15.0) * 0.7
		color = rgb(255 * brightness, 0, 0)
	else
		color = "#8B4513"

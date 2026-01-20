
/datum/say_channel
	var/name = "Say"
	var/color = "#aebfd4"
	var/quiet = FALSE

/datum/say_channel/proc/can_show(client/C)
	return TRUE

/datum/say_channel/proc/send(client/C, message)
	return FALSE

/datum/say_channel/proc/get_border_color()
	// Darken the base color slightly
	return color

/datum/say_channel/proc/get_hover_border()
	// Lighten for hover
	return color

/datum/say_channel/proc/get_hover_color()
	return color

/datum/say_channel/proc/get_shine_gradient()
	return "radial-gradient(circle, [color], [color], [color])"

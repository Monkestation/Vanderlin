/datum/say_channel/say
	name = "Say"
	color = "#aebfd4"
	quiet = FALSE

/datum/say_channel/say/can_show(client/C)
	return TRUE

/datum/say_channel/say/send(client/C, message)
	C.mob.say_verb(message)
	return TRUE

/datum/say_channel/say/get_border_color()
	return "#9daec3"

/datum/say_channel/say/get_hover_border()
	return "#bfcee3"

/datum/say_channel/say/get_hover_color()
	return "#b9c8dd"

/datum/say_channel/say/get_shine_gradient()
	return "radial-gradient(circle, #b9c8dd, #8899ae, #c9d8ed, #8899ae, #b9c8dd)"

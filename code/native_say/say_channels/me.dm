/datum/say_channel/me
	name = "Me"
	color = "#849fd9"
	quiet = FALSE

/datum/say_channel/me/can_show(client/C)
	return TRUE

/datum/say_channel/me/send(client/C, message)
	C.mob.me_verb(message)
	return TRUE

/datum/say_channel/me/get_border_color()
	return "#748fca"

/datum/say_channel/me/get_hover_border()
	return "#94afe8"

/datum/say_channel/me/get_hover_color()
	return "#8ca9e2"

/datum/say_channel/me/get_shine_gradient()
	return "radial-gradient(circle, #8ca9e2, #6c7fb9, #9cb9eb, #6c7fb9, #8ca9e2)"

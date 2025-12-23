/datum/say_channel/ooc
	name = "OOC"
	color = "#cc0"
	quiet = TRUE

/datum/say_channel/ooc/send(client/C, message)
	C.ooc(message)
	return TRUE

/datum/say_channel/ooc/get_border_color()
	return "#b3b300"

/datum/say_channel/ooc/get_hover_border()
	return "#e5e500"

/datum/say_channel/ooc/get_hover_color()
	return "#d6d600"

/datum/say_channel/ooc/get_shine_gradient()
	return "radial-gradient(circle, #d6d600, #999900, #f0f000, #999900, #d6d600)"

/datum/say_channel/looc
	name = "LOOC"
	color = "#fafa3b"
	quiet = TRUE

/datum/say_channel/looc/send(client/C, message)
	C.looc(message)
	return TRUE

/datum/say_channel/looc/get_border_color()
	return "#e1e12b"

/datum/say_channel/looc/get_hover_border()
	return "#ffff4b"

/datum/say_channel/looc/get_hover_color()
	return "#ffff45"

/datum/say_channel/looc/get_shine_gradient()
	return "radial-gradient(circle, #ffff45, #d1d11b, #ffff5b, #d1d11b, #ffff45)"

/datum/say_channel/admin
	name = "Admin"
	color = "#f5c6f5"
	quiet = TRUE

/datum/say_channel/admin/can_show(client/C)
	return C.holder && check_rights_for(C, R_ADMIN)

/datum/say_channel/admin/send(client/C, message)
	C.cmd_admin_say(message)
	return TRUE

/datum/say_channel/admin/get_border_color()
	return "#ecb3ec"

/datum/say_channel/admin/get_hover_border()
	return "#ffd9ff"

/datum/say_channel/admin/get_hover_color()
	return "#ffd0ff"

/datum/say_channel/admin/get_shine_gradient()
	return "radial-gradient(circle, #ffd0ff, #dba3db, #ffe9ff, #dba3db, #ffd0ff)"

/datum/keybinding/client/ooc
	hotkey_keys = list("O")
	name = "ooc"
	full_name = "Open OOC"
	description = "Opens OOC"
	category = CATEGORY_CLIENT

/datum/keybinding/client/ooc/down(client/user)
	. = ..()
	user.open_ooc()
	return TRUE

/datum/keybinding/client/say
	hotkey_keys = list("T")
	name = "say"
	full_name = "Open Say"
	description = "Opens Say channel"
	category = CATEGORY_CLIENT

/datum/keybinding/client/me
	hotkey_keys = list("M")
	name = "me"
	full_name = "Open Me"
	description = "Opens Me channel"
	category = CATEGORY_CLIENT

/datum/keybinding/client/me/down(client/user)
	. = ..()
	user.open_me()
	return TRUE

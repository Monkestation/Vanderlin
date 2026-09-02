/mob/dead/observer/Login()
	..()

	if(client && client.prefs)
		ghost_accs = client.prefs.read_preference(/datum/preference/choiced/ghost_accs)
		ghost_others = client.prefs.read_preference(/datum/preference/choiced/ghost_others)
	var/preferred_form = null

	if(IsAdminGhost(src))
		has_unlimited_silicon_privilege = 1

	if(client.prefs.unlock_content)
		preferred_form = client.prefs.read_preference(/datum/preference/choiced/ghost_form)
		ghost_orbit = client.prefs.read_preference(/datum/preference/choiced/ghost_orbit)

	if(client.holder)
		icon_state = client.prefs.admin_ghost_icon

	var/turf/T = get_turf(src)
	if (isturf(T))
		update_z(T.z)

	if(preferred_form)
		icon_state = preferred_form

	updateghostimages()

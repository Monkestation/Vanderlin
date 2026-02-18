/atom/movable/screen/ghost/orbit
	name = "Orbit"
	icon_state = "orbit"

/atom/movable/screen/ghost/orbit/Click()
	var/mob/dead/observer/G = usr
	G.follow()
//skull
/atom/movable/screen/ghost/orbit/rogue
	name = "AFTER LIFE"
	icon = 'icons/mob/afterlife.dmi'
	icon_state = "skull"
	screen_loc = "WEST-4,SOUTH+6"
	no_over_text = FALSE

/atom/movable/screen/ghost/orbit/rogue/Click(location, control, params)
	var/mob/dead/observer/ghost = usr
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK)) // screen objects don't do the normal Click() stuff so we'll cheat
		if(ghost.client?.holder)
			ghost.follow()
	else
		if(ghost.isinhell)
			return
		if(ghost.client)
			if(ghost.client.holder)
				if(istype(ghost, /mob/dead/observer/rogue/arcaneeye))
					return
				if(istype(ghost, /mob/dead/observer/profane)) // Souls trapped by a dagger can return to lobby if they want
					if(alert("Return to the lobby?", "", "Yes", "No") == "Yes")
						ghost.returntolobby()
				ghost.descend_to_underworld()
				return

		if(has_world_trait(/datum/world_trait/skeleton_siege) || has_world_trait(/datum/world_trait/rousman_siege) || has_world_trait(/datum/world_trait/goblin_siege))
			ghost.returntolobby()
			return

		ghost.descend_to_underworld()

/datum/hud/ghost/New(mob/owner)
	..()
	var/atom/movable/screen/using

	if(!GLOB.admin_datums[owner.ckey]) // If you are adminned, you will not get the dead hud obstruction.
		using =  new /atom/movable/screen/backhudl/ghost(null, src)
		static_inventory += using

	scannies = new /atom/movable/screen/scannies(null, src)
	static_inventory += scannies
	if(owner.client?.prefs?.crt == TRUE)
		scannies.alpha = 70

	using = new /atom/movable/screen/ghost/orbit/rogue(null, src)
	static_inventory += using

/datum/hud/ghost/show_hud(version = 0, mob/viewmob)
	// don't show this HUD if observing; show the HUD of the observee
	var/mob/dead/observer/O = mymob
	if (istype(O) && O.observetarget)
		plane_masters_update()
		return FALSE

	. = ..()
	if(!.)
		return
	var/mob/screenmob = viewmob || mymob
	if(!screenmob.client.prefs.ghost_hud)
		screenmob.client.screen -= static_inventory
	else
		screenmob.client.screen += static_inventory

/datum/hud/eye/New(mob/owner)
	..()
	var/atom/movable/screen/using

	using =  new /atom/movable/screen/backhudl/ghost(null, src)
	static_inventory += using

	scannies = new /atom/movable/screen/scannies(null, src)
	static_inventory += scannies
	if(owner.client?.prefs?.crt == TRUE)
		scannies.alpha = 70

/datum/hud/eye/show_hud(version = 0, mob/viewmob)
	// don't show this HUD if observing; show the HUD of the observee
	var/mob/dead/observer/O = mymob
	if (istype(O) && O.observetarget)
		plane_masters_update()
		return FALSE

	. = ..()
	if(!.)
		return
	var/mob/screenmob = viewmob || mymob
	if(!screenmob.client.prefs.ghost_hud)
		screenmob.client.screen -= static_inventory
	else
		screenmob.client.screen += static_inventory

/datum/hud/obs/New(mob/owner)
	..()
	var/atom/movable/screen/using

	using =  new /atom/movable/screen/backhudl/obs(null, src)
	static_inventory += using

	scannies = new /atom/movable/screen/scannies(null, src)
	static_inventory += scannies
	if(owner.client?.prefs?.crt == TRUE)
		scannies.alpha = 70

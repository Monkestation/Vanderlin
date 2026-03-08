/atom/movable/screen/ghost
	icon = 'icons/mob/screen_ghost.dmi'
	no_over_text = FALSE

/atom/movable/screen/ghost/orbit
	name = "Orbit"
	screen_loc = "SOUTH:6,CENTER-2:24"
	icon_state = "orbit"

/atom/movable/screen/ghost/orbit/Click()
	var/mob/dead/observer/G = usr
	G.follow()

/atom/movable/screen/ghost/reenter_corpse
	name = "Re-enter Corpse"
	screen_loc = "SOUTH:6,CENTER-1:24"
	icon_state = "reenter_corpse"

/atom/movable/screen/ghost/reenter_corpse/Click()
	var/mob/dead/observer/G = usr
	G.reenter_corpse()

/atom/movable/screen/ghost/teleport
	name = "Teleport"
	screen_loc = "SOUTH:6,CENTER:24"
	icon_state = "teleport"

/atom/movable/screen/ghost/teleport/Click()
	var/mob/dead/observer/G = usr
	G.dead_tele()

/atom/movable/screen/ghost/ghost_up
	name = "Ghost Up"
	screen_loc = "SOUTH:6,CENTER+1:24"
	icon_state = "up"

/atom/movable/screen/ghost/ghost_up/Click()
	var/mob/dead/observer/G = usr
	G.ghost_up()

/atom/movable/screen/ghost/ghost_down
	name = "Ghost Down"
	screen_loc = "SOUTH:6,CENTER+2:24"
	icon_state = "down"

/atom/movable/screen/ghost/ghost_down/Click()
	var/mob/dead/observer/G = usr
	G.ghost_down()

/atom/movable/screen/ghost/after_life
	name = "AFTERLIFE"
	icon = 'icons/mob/afterlife.dmi'
	icon_state = "skull"
	screen_loc = "WEST-4,SOUTH+6"

/atom/movable/screen/ghost/after_life/Click(location, control, params)
	var/mob/dead/observer/ghost = usr
	if(!istype(ghost))
		return

	if(istype(ghost, /mob/dead/observer/rogue/arcaneeye))
		return

	if(ghost.isinhell)
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

	using = new /atom/movable/screen/ghost/orbit(null, src)
	static_inventory += using

	using = new /atom/movable/screen/ghost/teleport(null, src)
	static_inventory += using

	using = new /atom/movable/screen/ghost/reenter_corpse(null, src)
	static_inventory += using

	using = new /atom/movable/screen/ghost/ghost_up(null, src)
	static_inventory += using

	using = new /atom/movable/screen/ghost/ghost_down(null, src)
	static_inventory += using

	using = new /atom/movable/screen/ghost/after_life(null, src)
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

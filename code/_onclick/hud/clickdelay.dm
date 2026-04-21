/atom/movable/screen/action_bar

/atom/movable/screen/action_bar/Destroy()
	STOP_PROCESSING(SShuds, src)
	return ..()

/atom/movable/screen/action_bar/proc/mark_dirty()
	var/mob/living/L = hud?.mymob
	if(L?.client && update_to_mob(L))
		START_PROCESSING(SShuds, src)

/atom/movable/screen/action_bar/process()
	var/mob/living/L = hud?.mymob
	if(!L?.client || !update_to_mob(L))
		return PROCESS_KILL

/atom/movable/screen/action_bar/proc/update_to_mob(mob/living/L)
	return FALSE

/datum/hud/var/atom/movable/screen/action_bar/clickdelay/left/cdleft
/datum/hud/var/atom/movable/screen/action_bar/clickdelay/right/cdright
/datum/hud/var/atom/movable/screen/action_bar/clickdelay/cdmid

/atom/movable/screen/action_bar/clickdelay
	name = "click delay"
	icon = 'icons/mob/roguehud.dmi'
	icon_state = ""
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = 22.1
	plane = HUD_PLANE
	alpha = 230

/atom/movable/screen/action_bar/clickdelay/update_to_mob(mob/living/L)
	if(world.time >= L.next_move)
		icon_state = ""
		return FALSE
	icon_state = "resiswait"
	return TRUE

/atom/movable/screen/action_bar/clickdelay/left/update_to_mob(mob/living/L)
	if(world.time >= L.next_lmove)
		icon_state = ""
		return FALSE
	icon_state = "resiswait"
	return TRUE

/atom/movable/screen/action_bar/clickdelay/right/update_to_mob(mob/living/L)
	if(world.time >= L.next_rmove)
		icon_state = ""
		return FALSE
	icon_state = "resiswait"
	return TRUE

/datum/hud/var/atom/movable/screen/action_bar/resistdelay/resistdelay

/atom/movable/screen/action_bar/resistdelay
	name = "resist delay"
	icon = 'icons/mob/roguehud.dmi'
	icon_state = ""

/atom/movable/screen/action_bar/resistdelay/update_to_mob(mob/living/L)
	if(world.time >= L.last_special)
		icon_state = ""
		return FALSE
	icon_state = "resiswait"
	return TRUE


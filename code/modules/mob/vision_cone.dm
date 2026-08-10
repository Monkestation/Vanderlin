/client
	var/list/hidden_atoms = list()
	var/list/hidden_mobs = list()
	var/list/hidden_images = list()

/mob
	var/fovangle

//viewers() but with a signal, for blacklisting otherwise capable of viewing atoms
/proc/fov_viewers(depth = world.view, atom/center)
	if(!center)
		return
	. = viewers(depth, center)
	for(var/mob/viewer as anything in .)
		SEND_SIGNAL(viewer, COMSIG_MOB_FOV_VIEWER, center, depth, .)

//view() but with a signal, to allow blacklisting some of the otherwise visible atoms.
/proc/fov_view(dist = world.view, atom/center)
	. = view(dist, center)
	SEND_SIGNAL(center, COMSIG_MOB_FOV_VIEW, center, dist, .)

/proc/cone(atom/center = usr, list/list = oview(center))
	SEND_SIGNAL(center, COMSIG_MOB_FOV_VIEW, center, world.view, list)
	return list

/mob/dead/BehindAtom(mob/center = usr, dir = NORTH)
	return

/atom/proc/BehindAtom(atom/center = usr, dir = NORTH)
	switch(dir)
		if(NORTH)
			if(y > center.y)
				return 1
		if(SOUTH)
			if(y < center.y)
				return 1
		if(EAST)
			if(x > center.x)
				return 1
		if(WEST)
			if(x < center.x)
				return 1

/proc/behind(atom/center = usr, dirs, list/list = oview(center))
	for(var/atom/A in list)
		var/fou
		for(var/D in dirs)
			if(A.BehindAtom(center, D))
				fou = TRUE
				break
		if(!fou)
			list -= A
	return list

/mob/proc/update_cone()
	return

/client/proc/update_cone()
	if(mob)
		mob.update_cone()

/mob/living/update_cone()
	var/datum/component/field_of_vision/fov = GetComponent(/datum/component/field_of_vision)
	if(!fov || !client)
		return
	fov.generate_fov_holder(src, fov.shadow_angle, fov.angle, register = FALSE, delete_holder = FALSE)

/mob/proc/can_see_cone(mob/L)
	if(!isliving(src) || !isliving(L))
		return
	if(!client)
		return TRUE
	var/list/result = list(src)
	SEND_SIGNAL(src, COMSIG_MOB_FOV_VIEWER, L, 0, result)
	return (src in result)

/mob/proc/update_cone_show()
	if(!client)
		return
	if(client.perspective != MOB_PERSPECTIVE)
		return hide_cone()
	if(client.eye != src)
		return hide_cone()
	if(client.pixel_x || client.pixel_y)
		return hide_cone()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.resting || H.body_position == LYING_DOWN)
			return hide_cone()
	return show_cone()

/mob/proc/show_cone()
	if(!client)
		return
	SEND_SIGNAL(src, COMSIG_FOV_SHOW)

/mob/proc/hide_cone()
	if(!client)
		return
	SEND_SIGNAL(src, COMSIG_FOV_HIDE)

/mob/proc/update_fov_angles()
	return

/atom/movable/screen/fullscreen/impaired/left
	icon_state = "impairedoverlay_left"

/atom/movable/screen/fullscreen/impaired/right
	icon_state = "impairedoverlay_right"

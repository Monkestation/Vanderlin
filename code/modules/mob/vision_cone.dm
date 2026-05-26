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
	fovangle = initial(fovangle)
	if(ishuman(src) && fovangle)
		var/mob/living/carbon/human/H = src
		var/obj/item/organ/eyes/LE = LAZYACCESS(H.eye_organs, 1)
		var/obj/item/organ/eyes/RE = LAZYACCESS(H.eye_organs, 2)
		var/left_damage = (LE ? LE.get_eye_damage_level() : 3)
		var/right_damage = (RE ? RE.get_eye_damage_level() : 3)
		if(left_damage >= 3)
			fovangle |= FOV_LEFT
		if(right_damage >= 3)
			fovangle |= FOV_RIGHT
		if(H.head?.block2add)
			fovangle |= H.head.block2add
		if(H.wear_mask?.block2add)
			fovangle |= H.wear_mask.block2add
		if(GET_MOB_ATTRIBUTE_VALUE(H, STAT_PERCEPTION) < 5)
			fovangle |= FOV_LEFT
			fovangle |= FOV_RIGHT
		else
			if(HAS_TRAIT(src, TRAIT_CYCLOPS_LEFT))
				fovangle |= FOV_RIGHT
			if(HAS_TRAIT(src, TRAIT_CYCLOPS_RIGHT))
				fovangle |= FOV_LEFT

	var/datum/component/field_of_vision/fov = GetComponent(/datum/component/field_of_vision)
	if(!fov)
		return

	if(!(fovangle & FOV_DEFAULT))
		fov.fov_holder?.alpha = 0
		return

	var/new_shadow_angle
	var/new_angle

	if(fovangle & FOV_RIGHT)
		if(fovangle & FOV_LEFT)
			new_shadow_angle = FOV_270_DEGREES
			new_angle = 0
		else if(fovangle & FOV_BEHIND)
			new_shadow_angle = FOV_180PLUS45_DEGREES
			new_angle = -45
		else
			new_shadow_angle = FOV_180PLUS45_DEGREES
			new_angle = 45
	else if(fovangle & FOV_LEFT)
		if(fovangle & FOV_BEHIND)
			new_shadow_angle = FOV_180MINUS45_DEGREES
			new_angle = 45
		else
			new_shadow_angle = FOV_180MINUS45_DEGREES
			new_angle = -45
	else if(fovangle & FOV_BEHIND)
		new_shadow_angle = FOV_180_DEGREES
		new_angle = 0
	else
		new_shadow_angle = FOV_90_DEGREES
		new_angle = 0

	fov.generate_fov_holder(src, new_shadow_angle, new_angle, register = FALSE, delete_holder = TRUE)

/atom/movable/screen/fullscreen/impaired/left
	icon_state = "impairedoverlay_left"

/atom/movable/screen/fullscreen/impaired/right
	icon_state = "impairedoverlay_right"

/mob/living/carbon/proc/update_eyes()
	if(!client)
		return
	var/obj/item/organ/eyes/LE = LAZYACCESS(eye_organs, 1)
	var/obj/item/organ/eyes/RE = LAZYACCESS(eye_organs, 2)
	var/left_damage = (LE ? LE.get_eye_damage_level() : 3)
	var/right_damage = (RE ? RE.get_eye_damage_level() : 3)
	if((left_damage >= 3) && (right_damage >= 3))
		become_blind(EYE_DAMAGE)
		return TRUE
	else
		cure_blind(EYE_DAMAGE)
	var/datum/component/field_of_vision/fov = GetComponent(/datum/component/field_of_vision)
	if(!fov)
		if(left_damage in 1 to 2)
			overlay_fullscreen("left_eye_damage", /atom/movable/screen/fullscreen/impaired/left, left_damage)
		else
			clear_fullscreen("left_eye_damage")
		if(right_damage in 1 to 2)
			overlay_fullscreen("right_eye_damage", /atom/movable/screen/fullscreen/impaired/right, right_damage)
		else
			clear_fullscreen("right_eye_damage")
	update_fov_angles()
	return TRUE

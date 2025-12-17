
/datum/atom_hud/alternate_appearance/basic/group
	var/list/seers
	add_ghost_version = TRUE

/datum/atom_hud/alternate_appearance/basic/group/New(key, image/I, mob_or_mobs)
	..(key, I, FALSE)
	var/list/mobs = islist(mob_or_mobs) ? mob_or_mobs : list(mob_or_mobs)
	seers = mobs
	for(var/mob/M in seers)
		add_hud_to(M)

/datum/atom_hud/alternate_appearance/basic/group/mobShouldSee(mob/M)
	if(M in seers)
		return TRUE
	return FALSE

/datum/component/vis_radius
	// This is an invisible object that will follow bounded object
	var/obj/effect/overlay/radius_obj
	var/image/radius_img

/datum/component/vis_radius/Initialize(radius, icon_state = "radius", color = COLOR_RED)
	RegisterSignal(parent, COMSIG_SHOW_RADIUS, PROC_REF(show_radius))
	RegisterSignal(parent, COMSIG_HIDE_RADIUS, PROC_REF(hide_radius))

	setup_radius(radius, icon_state, color)

/datum/component/vis_radius/Destroy()
	hide_radius()
	QDEL_NULL(radius_img)
	QDEL_NULL(radius_obj)
	return ..()

/datum/component/vis_radius/proc/setup_radius(radius, icon_state, color)
	var/atom/movable/AM = parent
	radius_obj = new(get_turf(AM))
	radius_obj.appearance_flags &= ~TILE_BOUND
	radius_obj.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	radius_obj.AddComponent(/datum/component/bounded, AM, 0, 0, null, null, FALSE, FALSE)

	radius_img = image('icons/hud/screen1.dmi', radius_obj, icon_state)
	radius_img.plane = ABOVE_LIGHTING_PLANE
	radius_img.appearance_flags &= ~TILE_BOUND
	radius_img.alpha = 49
	radius_img.color = color
	radius_img.mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	var/matrix/M = matrix()
	if(radius == 1)
		M.Scale(3)
	else
		M.Scale(3 + ((radius - 1) * 2))
	radius_img.transform = M

/datum/component/vis_radius/proc/show_radius(datum/sourse, mob_or_mobs)
	radius_obj.add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/group, "visible_radius", radius_img, mob_or_mobs)

/datum/component/vis_radius/proc/hide_radius()
	radius_obj?.remove_alt_appearance("visible_radius")

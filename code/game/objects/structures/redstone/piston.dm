
/obj/structure/redstone/piston
	name = "redstone piston"
	desc = "A mechanical device that can push blocks when powered."
	icon_state = "piston"
	redstone_role = REDSTONE_ROLE_OUTPUT
	var/extended = FALSE
	var/can_pull = FALSE
	var/obj/structure/piston_head/head
	var/extending = FALSE
	can_connect_wires = TRUE

/obj/structure/redstone/piston/Initialize()
	. = ..()
	create_piston_head()

/obj/structure/redstone/piston/Destroy()
	if(head)
		qdel(head)
	return ..()

/obj/structure/redstone/piston/get_input_directions()
	var/list/dirs = GLOB.cardinals.Copy()
	dirs -= dir // Don't receive from front
	return dirs

/obj/structure/redstone/piston/can_connect_to(obj/structure/redstone/other, direction)
	return (dir != direction)

/obj/structure/redstone/piston/on_power_changed()
	var/should_extend = (power_level > 0)
	if(should_extend != extended && !extending)
		if(should_extend)
			extend_piston()
		else
			retract_piston()

/obj/structure/redstone/piston/proc/create_piston_head()
	head = new /obj/structure/piston_head(get_turf(src))
	head.parent_piston = src
	head.set_direction(dir)
	head.layer = layer - 0.1

/obj/structure/redstone/piston/proc/extend_piston()
	if(extended || extending)
		return
	extending = TRUE
	var/turf/target_turf = get_step(src, dir)
	if(!can_extend_to(target_turf))
		extending = FALSE
		return
	push_objects(target_turf)
	extended = TRUE
	if(head)
		head.forceMove(target_turf)

	update_appearance(UPDATE_ICON_STATE)

	addtimer(VARSET_CALLBACK(src, extending, FALSE), 0.5 SECONDS)

/obj/structure/redstone/piston/proc/retract_piston()
	if(!extended || extending)
		return
	extending = TRUE
	if(can_pull && head)
		pull_objects()
	extended = FALSE
	if(head)
		head.forceMove(get_turf(src))

	update_appearance(UPDATE_ICON_STATE)

	addtimer(VARSET_CALLBACK(src, extending, FALSE), 0.5 SECONDS)

/obj/structure/redstone/piston/proc/can_extend_to(turf/target_turf)
	if(!target_turf)
		return FALSE
	for(var/obj/structure/S in target_turf)
		if(S.density && S.anchored)
			return FALSE
	return TRUE

/obj/structure/redstone/piston/proc/push_objects(turf/target_turf)
	var/turf/push_target = get_step(target_turf, dir)
	if(!push_target)
		return
	for(var/obj/O in target_turf)
		if(O.density && !O.anchored)
			O.forceMove(push_target)
	for(var/mob/M in target_turf)
		M.forceMove(push_target)
		to_chat(M, "<span class='warning'>You are pushed by the piston!</span>")

/obj/structure/redstone/piston/proc/pull_objects()
	if(!head)
		return
	var/turf/pull_source = get_step(head, dir)
	var/turf/pull_target = head.loc
	if(!pull_source)
		return
	for(var/obj/O in pull_source)
		if(O.density && !O.anchored)
			O.forceMove(pull_target)
	for(var/mob/M in pull_source)
		M.forceMove(pull_target)
		to_chat(M, "<span class='warning'>You are pulled by the sticky piston!</span>")

/obj/structure/redstone/piston/update_icon_state()
	. = ..()
	var/base_state = can_pull ? "sticky_piston" : "piston"
	if(extended)
		base_state += "_extended"
	icon_state = base_state

/obj/structure/redstone/piston/AltClick(mob/user, list/modifiers)
	if(!Adjacent(user) || extended)
		return
	dir = turn(dir, 90)
	if(head)
		head.set_direction(dir)
	update_appearance(UPDATE_ICON_STATE)
	to_chat(user, "<span class='notice'>You rotate the [name].</span>")

/obj/structure/redstone/piston/sticky
	name = "sticky redstone piston"
	icon_state = "sticky_piston"
	can_pull = TRUE

/obj/structure/piston_head
	name = "piston head"
	icon = 'icons/obj/redstone.dmi'
	icon_state = "piston_head"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER - 0.01
	var/obj/structure/redstone/piston/parent_piston

/obj/structure/piston_head/proc/set_direction(new_dir)
	dir = new_dir

/obj/structure/piston_head/Destroy()
	if(parent_piston)
		parent_piston.head = null
	return ..()

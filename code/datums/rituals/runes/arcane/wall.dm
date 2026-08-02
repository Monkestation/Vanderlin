/obj/effect/decal/cleanable/ritual_rune/arcyne/wall
	name = "wall accession matrix"
	desc = "Arcane symbols litter the ground — is that a wall of some sort?"
	icon_state = "wall"
	tier = 2
	invocation = "Fren'aleth ar'quor!"
	ritual_number = TRUE
	can_be_scribed = TRUE
	color = "#184075"
	var/list/barriers = list()

/obj/effect/decal/cleanable/ritual_rune/arcyne/wall/Destroy()
	QDEL_LIST_CONTENTS(barriers)
	barriers = null
	return ..()

/obj/effect/decal/cleanable/ritual_rune/arcyne/wall/attack_hand(mob/living/user)
	if(active)
		QDEL_LIST_CONTENTS(barriers)
		to_chat(user, span_warning("You deactivate the [src]!"))
		playsound(usr, 'sound/magic/teleport_diss.ogg', 75, TRUE)
		active = FALSE
		return
	. = ..()

/obj/effect/decal/cleanable/ritual_rune/arcyne/wall/get_ritual_list_for_rune()
	return tier >= 3 ? GLOB.t4wallrunerituallist : GLOB.t2wallrunerituallist

/obj/effect/decal/cleanable/ritual_rune/arcyne/wall/invoke(list/invokers, datum/runerituals/runeritual)
	if(!..())
		return
	var/mob/living/user = usr
	var/list/turf/targets = wall_get_target_turfs(user, pickritual.tier >= 2)
	for(var/turf/T in targets)
		if(locate(/obj/structure/forcefield/casted) in T)
			continue
		barriers += new /obj/structure/forcefield/casted(T, user)
	active = TRUE
	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)
	finish_invoke(invokers)

/obj/effect/decal/cleanable/ritual_rune/arcyne/wall/proc/wall_get_target_turfs(mob/living/user, double_row = FALSE)
	var/user_dir = user.dir
	var/turf/front = get_step(get_step(src, user_dir), user_dir)
	var/list/turfs = list(
		front,
		get_step(front, turn(user_dir, 90)),
		get_step(front, turn(user_dir, -90)),
		get_step(get_step(front, turn(user_dir, 90)), turn(user_dir, 90)),
		get_step(get_step(front, turn(user_dir, -90)), turn(user_dir, -90))
	)
	if(!double_row)
		return turfs
	var/turf/back = get_step(front, user_dir)
	turfs += list(
		back,
		get_step(back, turn(user_dir, 90)),
		get_step(back, turn(user_dir, -90)),
		get_step(get_step(back, turn(user_dir, 90)), turn(user_dir, 90)),
		get_step(get_step(back, turn(user_dir, -90)), turn(user_dir, -90))
	)
	return turfs

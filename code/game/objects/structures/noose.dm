

/obj/structure/noose
	name = "noose"
	desc = "Abandon all hope."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	SET_BASE_PIXEL(0, 10)
	icon_state = "noose"
	layer = 4.26
	max_integrity = 10
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER

	can_buckle = TRUE
	buckle_lying = 0
	buckle_prevents_pull = TRUE
	buckleverb = "tie"
	breakoutextra = 4 MINUTES
	buckle_delay = 5 SECONDS

	var/buckle_x_offset = 0
	var/buckle_y_offset = 10

/obj/structure/noose/atom_deconstruct(disassembled)
	new /obj/item/rope(loc)

/obj/structure/noose/Destroy()
	STOP_PROCESSING(SSobj, src)
	unbuckle_all_mobs(TRUE)
	return ..()

/obj/structure/noose/attackby(obj/item/W, mob/user, list/modifiers)
	if(!W.get_sharpness())
		return ..()

	if(do_after(user, 1 SECONDS, src))
		playsound(src, 'sound/foley/dropsound/cloth_drop.ogg', 50, TRUE)
		user.visible_message(span_notice("[user] cuts down the noose."), span_notice("I cut down the noose."), span_hear("I hear something snap."))
		deconstruct(TRUE)
		return TRUE

/obj/structure/noose/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	. = ..()
	playsound(src, 'sound/foley/dropsound/cloth_drop.ogg', 50, TRUE)
	visible_message(span_danger("The noose is shot down by [P]!"))
	deconstruct()

/obj/structure/noose/is_buckle_possible(mob/living/target, force, check_loc)
	. = ..()
	if(!.)
		return
	if(!target.get_bodypart(BODY_ZONE_PRECISE_NECK))
		return FALSE

/obj/structure/noose/post_buckle_mob(mob/living/buckled_mob)
	. = ..()
	START_PROCESSING(SSobj, src)
	buckled_mob.add_offsets(type, x_add = buckle_x_offset, y_add = buckle_y_offset)
	playsound(buckled_mob, 'sound/foley/noosed.ogg', 50, 1, -1)
	RegisterSignal(buckled_mob, COMSIG_CARBON_ATTEMPT_BREATHE, PROC_REF(breathe_attempt))
	RegisterSignal(buckled_mob, COMSIG_MOB_STATCHANGE, PROC_REF(upon_stat_change))

/obj/structure/noose/post_unbuckle_mob(mob/living/unbuckled_mob)
	unbuckled_mob.remove_offsets(type)
	UnregisterSignal(unbuckled_mob, list(COMSIG_CARBON_ATTEMPT_BREATHE, COMSIG_MOB_STATCHANGE))
	if(!has_buckled_mobs())
		STOP_PROCESSING(SSobj, src)

/obj/structure/noose/proc/breathe_attempt(mob/living/source)
	SIGNAL_HANDLER
	return BREATHE_SKIP_BREATH

/obj/structure/noose/proc/upon_stat_change(mob/living/source, new_stat, old_stat)
	SIGNAL_HANDLER
	if(old_stat != DEAD && new_stat == DEAD)
		var/obj/item/bodypart/head = source.get_bodypart(BODY_ZONE_PRECISE_NECK)
		head?.add_wound(/datum/wound/fracture/neck)

/obj/structure/noose/process(delta_time)
	if(!has_buckled_mobs())
		return PROCESS_KILL
	if(locate(/obj/structure/chair) in get_turf(src)) // So you can kick down the chair and make them hang, and stuff.
		return
	for(var/mob/living/buckled_mob as anything in buckled_mobs)
		var/obj/item/bodypart/head = buckled_mob.get_bodypart(BODY_ZONE_PRECISE_NECK)
		if(!head)
			unbuckle_mob(buckled_mob, TRUE)
			continue
		if(head.skeletonized)
			head.dismember()
			unbuckle_mob(buckled_mob, TRUE)
			continue

		if(buckled_mob.stat == DEAD || HAS_TRAIT(buckled_mob, TRAIT_NOBREATH))
			continue

		buckled_mob.adjustOxyLoss(3 * delta_time) // so nooses kill you faster

		if(buckled_mob.stat < UNCONSCIOUS && prob(25))
			buckled_mob.visible_message(pick(list(\
										span_danger("[buckled_mob]'s legs flail for anything to stand on."),\
										span_danger("[buckled_mob]'s hands are desperately clutching the noose."),\
										span_danger("[buckled_mob]'s limbs sway back and forth with diminishing strength."))))
			playsound(buckled_mob, 'sound/foley/noose_idle.ogg', 30, 1, -3)

/obj/structure/noose/unbuckle_mob(mob/living/buckled_mob, force, can_fall)
	. = ..()
	if(!force)
		return
	buckled_mob.visible_message(span_danger("[buckled_mob] falls over and hits the ground!"), \
								span_userdanger("You fall over and hit the ground!"))
	buckled_mob.adjustBruteLoss(10, damage_type = BCLASS_BLUNT)
	buckled_mob.Knockdown(6 SECONDS)

/obj/structure/noose/gallows
	name = "gallows"
	desc = "Read through six lines written by the most honest man in the world, and one will find enough in them to hang him."
	icon_state = "gallows"
	SET_BASE_PIXEL(0, 0)
	max_integrity = 100
	buckle_x_offset = 6
	buckle_y_offset = 16

/obj/structure/noose/gallows/atom_deconstruct(disassembled)
	. = ..()
	new /obj/machinery/light/fueled/lanternpost/unfixed(loc)

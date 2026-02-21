GLOBAL_LIST_EMPTY(mana_fountains)

/obj/structure/fluff/walldeco/mageguild
	name = "Mage's Guild"
	icon_state = "mageguild"

/obj/effect/turf_decal/magedecal
	icon = 'icons/effects/96x96.dmi'
	icon_state = "imbuement2"

/obj/structure/door/arcyne
	name = "arcyne door"
	icon_state = "arcyne"
	blade_dulling = DULLING_BASH
	resistance_flags = FIRE_PROOF
	lock = /datum/lock
	can_add_lock = FALSE
	max_integrity = 2000

	repair_thresholds = null
	broken_repair = null
	repair_skill = null
	metalizer_result = null

/obj/structure/door/arcyne/bolt
	has_bolt = TRUE

/obj/structure/door/arcyne/bolt/caster
	var/mob/caster

/obj/structure/door/arcyne/bolt/caster/Initialize(mapload, mob/summoner)
	. = ..()
	caster = summoner

/obj/structure/door/arcyne/bolt/caster/attack_hand_secondary(mob/user, list/modifiers)
	if(user != caster)
		to_chat(user, span_warning("A magical force prevents me from interacting with [src]!"))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	return ..()

/atom/movable
	var/list/mana_beams

/atom/movable/proc/draw_mana_beams(atom/movable/find_type, max_distance = 3)
	for(var/atom/movable/movable in range(max_distance, src))
		if(movable == src)
			continue
		if(movable in mana_beams)
			continue
		if(!istype(movable, find_type))
			continue

		var/datum/beam/mana = Beam(
			movable,
			icon_state = "drain_life",
			max_distance = max_distance,
			time = INFINITY,
			beam_layer = LOWER_LEYLINE_LAYER,
			beam_plane = LEYLINE_PLANE,
			invisibility = INVISIBILITY_LEYLINES,
		)

		RegisterSignal(mana, COMSIG_PARENT_QDELETING, PROC_REF(beam_ended), movable)

		LAZYADD(mana_beams, movable)

/atom/movable/proc/beam_ended(atom/movable/target)
	if(!length(mana_beams))
		return
	if(target in mana_beams)
		mana_beams -= target

/atom/movable/proc/draw_mana_beams_from_list(list/found_types, max_distance = 3)
	for(var/atom/movable/movable in found_types)
		if(movable == src)
			continue
		if(movable in mana_beams)
			continue

		var/datum/beam/mana = Beam(
			movable,
			icon_state = "drain_life",
			max_distance = max_distance,
			time = INFINITY,
			beam_layer = LOWER_LEYLINE_LAYER,
			beam_plane = LEYLINE_PLANE,
			invisibility = INVISIBILITY_LEYLINES,
		)

		RegisterSignal(mana, COMSIG_PARENT_QDELETING, PROC_REF(beam_ended), movable)

		LAZYADD(mana_beams, movable)

/obj/structure/well/fountain/mana
	name = "mana fountain"
	desc = ""
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "manafountain"
	layer = BELOW_MOB_LAYER
	SET_BASE_PIXEL(-16, 0)
	layer = -0.1
	has_initial_mana_pool = TRUE

/obj/structure/well/fountain/mana/Initialize()
	. = ..()
	GLOB.mana_fountains |= src

/obj/structure/well/fountain/mana/Destroy()
	GLOB.mana_fountains -= src
	return ..()

/obj/structure/well/fountain/mana/get_initial_mana_pool_type()
	return /datum/mana_pool/mana_fountain

/obj/structure/well/fountain/mana/onbite(mob/living/user)
	if(mana_pool.amount < 50)
		to_chat(user, span_warning("[src] is dry."))
		return TRUE
	. = ..()

/obj/structure/well/fountain/mana/drink_from(mob/living/user)
	mana_pool.adjust_mana(-50)
	var/datum/reagents/reagents = new()
	reagents.add_reagent(/datum/reagent/medicine/manapot/weak, 2)
	reagents.trans_to(user, reagents.total_volume, transfered_by = user, method = INGEST)
	playsound(user,pick('sound/items/drink_gen (1).ogg','sound/items/drink_gen (2).ogg','sound/items/drink_gen (3).ogg'), 100, TRUE)


/obj/structure/well/fountain/mana/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/reagent_containers/glass))
		var/obj/item/reagent_containers/glass/W = I
		if(W.reagents.holder_full())
			to_chat(user, span_warning("[W] is full."))
			return
		var/mana_amount = min(round(mana_pool.amount / 25, 1), 40)
		if(!mana_amount)
			to_chat(user, span_warning("[src] is dry."))
			return
		if(do_after(user, 60, target = src))
			mana_pool.adjust_mana(-mana_amount * 25)
			var/list/waterl = list(/datum/reagent/medicine/manapot/weak = mana_amount)
			W.reagents.add_reagent_list(waterl)
			to_chat(user, "<span class='notice'>I fill [W] from [src].</span>")
			playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 80, FALSE)
			return
	if(istype(I, /obj/item/grabbing))
		if(mana_pool.amount < 500)
			to_chat(user, "There is not enough liquid mana to perform a baptism.")
			return
		var/atom/movable/grabbed = I:grabbed
		if(!grabbed.mana_pool)
			return
		user.visible_message(span_notice("[user] starts to submerge [grabbed]."), span_notice("You start to submerge [grabbed]."))
		if(!do_after(user, 10 SECONDS, src))
			return
		grabbed.mana_pool.set_intrinsic_recharge(MANA_ALL_LEYLINES)
		SEND_SIGNAL(grabbed, COMSIG_BAPTISM_RECEIVED, user)
		playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 80, FALSE)
		return

	return ..()

/obj/machinery/light/fueled/forge/arcane
	icon = 'icons/roguetown/misc/forge.dmi'
	name = "infernal forge"
	desc = "This forge uses cycling magma from an internal core to heat things."
	icon_state = "infernal0"
	base_state = "infernal"

/obj/machinery/light/fueled/forge/arcane/process()
	if(isopenturf(loc))
		var/turf/open/O = loc
		if(IS_WET_OPEN_TURF(O))
			extinguish()
	if(on)
		if(initial(fueluse) > 0)
			if(fueluse > 0)
				fueluse = max(fueluse - 10, 0)
			if(fueluse == 0)//It's literally powered by arcane lava. It's not gonna run out of fuel.
				fueluse = 4000
		update_appearance(UPDATE_ICON_STATE)

/obj/structure/leyline
	name = "inactive leyline"
	desc = "A curious arrangement of stones."
	icon = 'icons/effects/effects.dmi'
	icon_state = "inactiveleyline"
	var/active = FALSE
	var/mob/living/guardian = null
	anchored = TRUE
	density = FALSE
	var/time_between_uses = 12000
	var/last_process = 0

/obj/structure/leyline/Initialize()
	.=..()
	last_process = world.time

/obj/structure/leyline/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(last_process + time_between_uses > world.time)
		to_chat(user, span_notice("The leyline appears to be drained of energy."))
		return
	if(!isarcyne(user))
		if(!active)
			to_chat(user, span_notice("I wave a hand through the circle of rocks. Nothing happens."))
			return
		else
			if(prob(60) && (!guardian))
				if(do_after(user, 60))
					to_chat(user, span_notice("I reach out towards the active leyline, peering within- and something peers back!"))
					sleep(2 SECONDS)
					guardian = new /mob/living/simple_animal/hostile/retaliate/leylinelycan(src.loc, src)
					src.visible_message(span_danger("[src] emerges from the leyline rupture!"))
			else
				if(do_after(user, 60))
					to_chat(user, span_notice("I reach out towards the active leyline, and it shatters! A large, usable piece of it drops at your feet."))
					new /obj/item/natural/leyline(user.loc)
					active = FALSE
					icon_state = "inactiveleyline"
					name = "inactive leyline"
					desc = "A curious arrangement of stones."
					last_process = world.time

	else
		if(!active)
			to_chat(user, span_notice("I wave a hand through the circle of rocks, and pulse my arcyne magic through it. The leyline activates!"))
			icon_state = "leylinerupture"
			name = "active leyline"
			desc = "An active tear into the leyline. It gives off plenty of energy."
			active = TRUE
		else
			if(guardian)
				if(do_after(user, 60))
					to_chat(user, span_danger("The leyline is abuzz with energy in a feedback from \the [guardian]! It lashes out at me!"))
					user.electrocute_act(10)

			if(prob(60) && (!guardian))
				if(do_after(user, 60))
					to_chat(user, span_notice("I reach out towards the active leyline, peering within- and something peers back!"))
					sleep(2 SECONDS)
					guardian = new /mob/living/simple_animal/hostile/retaliate/leylinelycan(src.loc, src)
					src.visible_message(span_danger("\The [guardian] emerges from the leyline rupture!"))

			else
				if(do_after(user, 60))
					to_chat(user, span_notice("I reach out towards the active leyline, and it shatters! A large, usable piece of it drops at my feet."))
					new /obj/item/natural/leyline(user.loc)
					active = FALSE
					icon_state = "inactiveleyline"
					name = "inactive leyline"
					desc = "A curious arrangement of stones."
					last_process = world.time

/obj/structure/voidstoneobelisk
	name = "Voidstone Obelisk"
	desc = "A smooth unnatural Obelisk, looking at it provides the sense of unease."
	icon = 'icons/mob/summonable/32x32.dmi'
	icon_state = "dormantobelisk"
	anchored = TRUE
	density = TRUE

/obj/structure/voidstoneobelisk/attacked_by(obj/item/I, mob/living/user)
	user.changeNext_move(CLICK_CD_MELEE)
	var/newforce = get_complex_damage(I, user, blade_dulling)
	if(!newforce)
		return 0
	if(newforce < damage_deflection)
		return 0
	if(user.used_intent.no_attack)
		return 0
	log_combat(user, src, "attacked", I)
	var/verbu = "hits"
	verbu = pick(user.used_intent.attack_verb)
	if(newforce > 1)
		if(user.adjust_stamina(5))
			user.visible_message(span_danger("[user] [verbu] [src] with [I]!"))
	user.visible_message(span_danger("[src] comes to life, archaic stone shifting into position!"))
	sleep(2)
	new /mob/living/simple_animal/hostile/retaliate/voidstoneobelisk(src.loc)
	qdel(src)

/obj/structure/voidstoneobelisk/attack_hand(mob/living/carbon/human/user)
	to_chat(user, span_notice("You reach out to touch the aberrant obelisk..."))
	if(do_after(user, 3 SECONDS, target = src))
		user.visible_message(span_danger("[src] comes to life, archaic stone shifting into position!"))
		sleep(2)
		new /mob/living/simple_animal/hostile/retaliate/voidstoneobelisk(src.loc)
		qdel(src)

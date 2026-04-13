
/obj/structure/closet/dirthole
	name = "hole"
	icon_state = "hole1"
	icon = 'icons/turf/floors.dmi'
	mob_storage_capacity = 3
	allow_dense = TRUE
	opened = TRUE
	density = FALSE
	anchored = TRUE
	can_buckle = FALSE
	resistance_flags = INDESTRUCTIBLE
	buckle_lying = 90
	layer = 2.8
	lock = null
	can_add_lock = FALSE
	alternative_icon_handling = TRUE
	/// How big the hole is, at 3 you can bury a body, at 4 theres something buried.
	var/stage = 1
	/// Chance for attempt to increase `stage` fails, while still spawning dirt. Increments each fail and is skipped once it reaches 3
	var/faildirt = 0

	/// Present headstone. If this is empty, there isnt one.
	var/obj/item/gravedecor/headstone
	/// Present gravefence. If this is empty, there isnt one.
	var/obj/item/gravedecor/gravefence
	/// From 0-10. You shouldn't be able to get more than 10 quality. This is affected by the headstone, gravefence, location of burial, and if you used a winding sheet / coffin.
	var/gravequality = 0
	/// For debug/administrative purposes. Set this if you want it to apply next time we call update_quality.
	var/bonusquality
	/// Has the "burial rites" miracle been used on this grave. TRUE or FALSE.
	var/is_consecrated


/obj/structure/closet/dirthole/Initialize()
	var/turf/open/floor/dirt/T = loc
	if(!istype(T))
		return INITIALIZE_HINT_QDEL
	if(T.muddy)
		if(!(locate(/obj/item/natural/worms) in T))
			if(prob(40))
				if(prob(10))
					new /obj/item/natural/worms/grub_silk(T)
				else
					new /obj/item/natural/worms/leech(T)
			else
				new /obj/item/natural/worms(T)
		if(!(locate(/obj/item/natural/clay) in T))
			if(prob(25))
				new /obj/item/natural/clay(T)
	else
		if(!(locate(/obj/item/natural/stone) in T))
			if(prob(23))
				new /obj/item/natural/stone(T)
	return ..()

// TODO: When we implement more systems, such as passive devotion, we ensure it is removed before we delete
/obj/structure/closet/dirthole/Destroy()
	. = ..()

/obj/structure/closet/dirthole/examine(mob/user)
	. = ..()
	if(is_consecrated)
		switch(gravequality)
			if(0 to 2)
				user.add_stress(/datum/stress_event/saw_grave_1)
				user.remove_stress(/datum/stress_event/saw_grave_2)
				user.remove_stress(/datum/stress_event/saw_grave_3)
				user.remove_stress(/datum/stress_event/saw_grave_4)
				user.remove_stress(/datum/stress_event/saw_grave_5)
			if(3 to 4)
				user.add_stress(/datum/stress_event/saw_grave_2)
				user.remove_stress(/datum/stress_event/saw_grave_1)
				user.remove_stress(/datum/stress_event/saw_grave_3)
				user.remove_stress(/datum/stress_event/saw_grave_4)
				user.remove_stress(/datum/stress_event/saw_grave_5)
			if(5 to 6)
				user.add_stress(/datum/stress_event/saw_grave_3)
				user.remove_stress(/datum/stress_event/saw_grave_1)
				user.remove_stress(/datum/stress_event/saw_grave_2)
				user.remove_stress(/datum/stress_event/saw_grave_4)
				user.remove_stress(/datum/stress_event/saw_grave_5)
			if(7 to 8)
				user.add_stress(/datum/stress_event/saw_grave_4)
				user.remove_stress(/datum/stress_event/saw_grave_1)
				user.remove_stress(/datum/stress_event/saw_grave_2)
				user.remove_stress(/datum/stress_event/saw_grave_3)
				user.remove_stress(/datum/stress_event/saw_grave_5)
			if(9 to INFINITY)
				user.add_stress(/datum/stress_event/saw_grave_5)
				user.remove_stress(/datum/stress_event/saw_grave_1)
				user.remove_stress(/datum/stress_event/saw_grave_2)
				user.remove_stress(/datum/stress_event/saw_grave_3)
				user.remove_stress(/datum/stress_event/saw_grave_4)

/obj/structure/closet/dirthole/grave
	stage = 3
	faildirt = 3
	icon_state = "grave"

/obj/structure/closet/dirthole/closed
	stage = 4
	faildirt = 3
	climb_offset = 10
	icon_state = "gravecovered"
	opened = FALSE

/obj/structure/closet/dirthole/closed/loot/Initialize()
	. = ..()
	lootroll = rand(1,4)

/obj/structure/closet/dirthole/closed/loot
	var/looted = FALSE
	var/lootroll = 0

/obj/structure/closet/dirthole/closed/loot/open()
	if(!looted)
		looted = TRUE
		switch(lootroll)
			if(1)
				new /mob/living/carbon/human/species/skeleton/npc(get_turf(src))
				new /obj/structure/closet/crate/chest/lootbox(get_turf(src))
			if(2)
				new /obj/structure/closet/crate/chest/lootbox(get_turf(src))
	..()

/obj/structure/closet/dirthole/closed/loot/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_SOUL_EXAMINE))
		if(lootroll == 1)
			. += "<span class='warning'>Better let this one sleep.</span>"

/// Alt clicking allows you to remove grave decorations if the grave has not been consecrated yet
/obj/structure/closet/dirthole/AltClick(mob/user, list/modifiers)
	if(!Adjacent(user) || stage != 4)
		return FALSE

	if(is_consecrated)
		to_chat(user, span_warning("I cannot modify a grave that has been already consecrated..."))
		return FALSE

	var/list/GraveDecorations = list()
	if(headstone)
		GraveDecorations += headstone
	if(gravefence)
		GraveDecorations += gravefence

	// List formed, handle if empty, only one, or both
	var/obj/item/gravedecor/item_to_remove
	if(!GraveDecorations)
		return FALSE
	else if(length(GraveDecorations) != 1)
		item_to_remove = tgui_input_list(user, "Which decoration do you want to remove?", "Grave Decor Removal", GraveDecorations)
	else
		item_to_remove = GraveDecorations[1] // only one item

	if(!item_to_remove)
		return FALSE

	// Time to actually remove the item
	user.visible_message("[user] starts to remove \the [item_to_remove] from \the [src]", "You attempt to remove \the [item_to_remove] from \the [src]")
	if(!do_after(user, 5 SECONDS, src, progress = TRUE))
		to_chat(user, span_warning("You fail to remove \the [item_to_remove]!"))
		return FALSE
	else
		user.visible_message("[user] removes \the [item_to_remove] from \the [src]", "You remove \the [item_to_remove] from \the [src]")

		// Remove either headstone or gravestone
		if(istype(item_to_remove, /obj/item/gravedecor/headstone))
			user.put_in_active_hand(new item_to_remove.type())
			headstone = null
		else if(istype(item_to_remove, /obj/item/gravedecor/gravefence))
			user.put_in_active_hand(new item_to_remove.type())
			gravefence = null

		update_quality()
		update_overlays()
		return TRUE

/obj/structure/closet/dirthole/insertion_allowed(atom/movable/AM)
	if(istype(AM, /obj/structure/closet/crate/chest) || istype(AM, /obj/structure/closet/burial_shroud) || istype(AM, /obj/structure/closet/crate/coffin))
		for(var/mob/living/M in contents)
			return FALSE
		for(var/obj/structure/closet/C in contents)
			return FALSE
		return TRUE
	. = ..()

/obj/structure/closet/dirthole/toggle(mob/living/user)
	return

/obj/structure/closet/dirthole/proc/attemptwatermake(mob/living/user, obj/item/reagent_containers/bucket)
	if(user.used_intent.type == /datum/intent/splash)
		if(bucket.reagents)
			var/datum/reagent/master_reagent = bucket.reagents.get_master_reagent()
			var/reagent_volume = master_reagent.volume
			if(do_after(user, 10 SECONDS, src))
				if(bucket.reagents.remove_reagent(master_reagent.type, clamp(master_reagent.volume, 1, 100)))
					var/turf/structure_turf = get_turf(src)
					var/turf/open/water/W = structure_turf.PlaceOnTop(/turf/open/water/river/creatable)
					if(!W) // how did this happen
						return
					W.water_reagent = master_reagent.type
					W.water_volume = clamp(reagent_volume, 1, 100)
					W.handle_water()
					playsound(W, 'sound/foley/waterenter.ogg', 100, FALSE)
					QDEL_NULL(src)

/obj/structure/closet/dirthole/attackby(obj/item/attacking_item, mob/user, list/modifiers)
	if(istype(attacking_item, /obj/item/grown/log/tree/stick))
		if(headstone)
			to_chat(user, "<span class='warning'>This grave already has a headstone.</span>")
			return
		if(stage != 4)
			to_chat(user, "<span class='warning'>I can't tie a grave marker on an open grave.</span>")

		if(!do_after(user, 10 SECONDS, src))
			return

		// TODO this needs refactored so it spawns a subtype of `gravedecor/headstone` that tracks this stick but deletes it (restored if headstone removed)
		var/mutable_appearance/headstone_overlay = mutable_appearance('icons/turf/floors.dmi', "gravemarker1", 2.91)
		add_overlay(headstone_overlay)
		headstone = attacking_item.type
		if(pacify_coffin(src, user))
			user.visible_message(span_rose("[user] consecrates [src]."), span_rose("I consecrate [src]."))
			if(!is_consecrated)
				SEND_SIGNAL(user, COMSIG_GRAVE_CONSECRATED, src)
				record_round_statistic(STATS_GRAVES_CONSECRATED)

		update_quality()
		//update_appearance(UPDATE_ICON)
		qdel(attacking_item)
		return

	if(istype(attacking_item, /obj/item/gravedecor/headstone))
		if(headstone)
			to_chat(user, "<span class='warning'>This grave already has a headstone.</span>")
			return
		if(stage != 4)
			to_chat(user, "<span class='warning'>I can't put a headstone on an open grave.</span>")
			return

		if(!do_after(user, 5 SECONDS, src))
			return

		headstone = attacking_item
		if(pacify_coffin(src, user))
			user.visible_message(span_rose("[user] consecrates [src]."), span_rose("I consecrate [src]."))
			if(!is_consecrated)
				SEND_SIGNAL(user, COMSIG_GRAVE_CONSECRATED, src)
				record_round_statistic(STATS_GRAVES_CONSECRATED)

		qdel(attacking_item)
		update_quality()
		update_appearance(UPDATE_ICON)
		return

	if(istype(attacking_item, /obj/item/gravedecor/gravefence))
		if(gravefence)
			to_chat(user, "<span class='warning'>This grave already has a fence.</span>")
			return
		if(stage != 4)
			to_chat(user, "<span class='warning'>I can't put a gravefence on an open grave.</span>")
			return

		if(!do_after(user, 5 SECONDS, src))
			return
		gravefence = attacking_item

		qdel(attacking_item)
		update_quality()
		update_appearance(UPDATE_ICON)
		return

	if(!istype(attacking_item, /obj/item/weapon/shovel))
		if(istype(attacking_item, /obj/item/reagent_containers/glass/bucket))
			attemptwatermake(user, attacking_item)
			return
		return ..()
	var/obj/item/weapon/shovel/attacking_shovel = attacking_item
	if(user.used_intent.type != /datum/intent/shovelscoop)
		return

	if(attacking_shovel.heldclod)
		playsound(src,'sound/items/empty_shovel.ogg', 100, TRUE)
		if(stage == 3) //close grave
			if(!do_after(user, 5 SECONDS * attacking_shovel.time_multiplier, src)) //can't have nice things can we
				return
			stage = 4
			climb_offset = 10
			close()
			var/founds
			for(var/obj/structure/closet/crate/coffin/coffin in contents)
				gravequality += 2
				if(coffin.consecrated)
					gravequality += 1
			for(var/obj/structure/closet/burial_shroud/shroud in contents)
				gravequality += 1
			for(var/atom/A in contents)
				founds = TRUE
				break
			if(!founds)
				stage = 2
				climb_offset = 0
				open()
			stage_update()
		else if(stage < 4)
			stage--
			climb_offset = 0
			stage_update()
			if(stage == 0)
				qdel(src)
		QDEL_NULL(attacking_shovel.heldclod)
		attacking_shovel.update_appearance(UPDATE_ICON_STATE)
		return
	else
		if(stage == 3)
			var/turf/our_turf = get_turf(src)
			var/turf/under_turf = GET_TURF_BELOW(our_turf)
			if(under_turf && our_turf && isopenturf(under_turf))
				playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)
				user.visible_message("[user] starts digging out the bottom of [src]", "I start digging out the bottom of [src].")
				if(!do_after(user, 10 SECONDS * attacking_shovel.time_multiplier, src))
					return TRUE
				attacking_shovel.heldclod = new(attacking_shovel)
				attacking_shovel.update_appearance(UPDATE_ICON_STATE)
				playsound(our_turf,'sound/items/dig_shovel.ogg', 100, TRUE)
				our_turf.ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
				qdel(src)
				return
			to_chat(user, "<span class='warning'>I think that's deep enough.</span>")
			return
		playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)
		var/used_str = 10
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			if(C.domhand)
				used_str = C.get_str_arms(C.used_hand)
			C.adjust_stamina(max(60 - (used_str * 5), 1))
		if(stage < 3)
			if(faildirt < 2)
				if(prob(used_str * 5))
					stage++
				else
					faildirt++
			else
				stage++
		if(stage == 4)
			if(!do_after(user, 5 SECONDS * attacking_shovel.time_multiplier, src)) // WE CANT HAVE NICE THINGS CAN WE
				return
			stage = 3
			climb_offset = 0
			cut_overlays()
			open()
			if(headstone)
				new headstone.type(get_turf(src))
				headstone = null
			if(gravefence)
				new gravefence.type(get_turf(src))
				gravefence = null
			if(is_consecrated)	// Curses you if you don't have the graverobber trait, otherwise records you as a criminal and gives a special message.
				if(ishuman(user))
					var/mob/living/carbon/human/L = user
					var/robbery_location = get_area_name(get_turf(src))
					if(HAS_TRAIT(L, TRAIT_GRAVEROBBER))
						var/robbing = TRUE
						var/message = "I perform the secret rite of concealment, the Undermaiden won't know of my transgression here."
						switch(L.patron?.type)
							if(/datum/patron/divine/necra)
								robbing = FALSE
								message = "I perform the secret rite of exhumation, and so the Undermaiden overlooks my transgression."
							if(/datum/patron/divine/pestra) //Special notices if you're of a particular faith.
								message = "I perform the secret rite of concealment, Pestra shields me from divine gaze as I exhume this corpse for study."
							if(/datum/patron/inhumen/matthios)
								message = "I perform the secret rite of liberation, the Undermaiden is none the wiser as the occupant of this grave is freed."
							if(/datum/patron/inhumen/zizo)
								message = "I perform the secret rite of defilement, the Undermaiden can do nothing but watch as I undo the rites on this grave."
						to_chat(user, span_info(message))
						if(robbing)
							record_featured_stat(FEATURED_STATS_CRIMINALS, user) //You aren't a Necran, even though you didn't get any consequences you're still a criminal.
							record_round_statistic(STATS_GRAVES_ROBBED)
							SEND_SIGNAL(user, COMSIG_GRAVE_ROBBED, user)
					else
						if(gravequality >= 2 && gravequality < 5)
							to_chat(user, span_warning("Necra shuns my blasphemous deeds!"))
							L.apply_status_effect(/datum/status_effect/debuff/cursed)
						else if(gravequality >= 5)
							to_chat(user, span_warning("Necra shuns my blasphemous deeds! Worse, whispers flutter in every direction, someone has been warned of my actions!"))
							L.apply_status_effect(/datum/status_effect/debuff/cursed)
							for (var/mob/living/player in GLOB.player_list)
								if (player.stat == DEAD || isbrain(player))
									continue
								// When the alarm is tripped, the priest, templars, and necran clergy (gravekeepers + acolytes whose patron is Necra) get alerted.
								if (is_priest_job(player.mind.assigned_role) || (is_monk_job(player.mind.assigned_role) && player.patron?.type == /datum/patron/divine/necra) || istype(player.mind.assigned_role, /datum/job/templar) || istype(player.mind.assigned_role, /datum/job/gmtemplar) || istype(player.mind.assigned_role, /datum/job/undertaker))
									to_chat(player, span_crit("Veiled whispers hiss of great blasphemy, a highly blessed grave is being robbed in [robbery_location], this cannot go unpunished!"))
						record_featured_stat(FEATURED_STATS_CRIMINALS, user)
						record_round_statistic(STATS_GRAVES_ROBBED)
						SEND_SIGNAL(user, COMSIG_GRAVE_ROBBED, user)

		stage_update()
		attacking_shovel.heldclod = new /obj/item/natural/clod/dirt(attacking_shovel)
		attacking_shovel.update_appearance(UPDATE_ICON_STATE)
		update_quality()
		is_consecrated = null // Unconsecrate.

/obj/structure/closet/dirthole/MouseDrop_T(atom/movable/O, mob/living/user)
	var/turf/T = get_turf(src)
	if(istype(O, /obj/structure/closet/crate/coffin))
		O.forceMove(T)
	if(!istype(O) || O.anchored || istype(O, /atom/movable/screen))
		return
	if(!istype(user) || user.incapacitated() || user.body_position == LYING_DOWN)
		return
	if(!Adjacent(user) || !user.Adjacent(O))
		return
	if(user == O) //try to climb onto it
		return ..()
	if(!opened)
		return
	if(!isturf(O.loc))
		return

	var/actuallyismob = 0
	if(isliving(O))
		actuallyismob = 1
	else if(!isitem(O))
		return
	add_fingerprint(user)
	user.visible_message("<span class='warning'>[user] [actuallyismob ? "tries to ":""]stuff [O] into [src].</span>", \
						"<span class='warning'>I [actuallyismob ? "try to ":""]stuff [O] into [src].</span>", \
						"<span class='hear'>I hear clanging.</span>")
	if(actuallyismob)
		if(do_after(user, 4 SECONDS, O))
			user.visible_message("<span class='notice'>[user] stuffs [O] into [src].</span>", \
								"<span class='notice'>I stuff [O] into [src].</span>", \
								"<span class='hear'>I hear a loud bang.</span>")
			O.forceMove(T)
			user_buckle_mob(O, user)
	else
		O.forceMove(T)
	return 1

/obj/structure/closet/dirthole/take_contents()
	var/atom/L = drop_location()
	..()
	for(var/obj/structure/closet/crate/coffin/C in L)
		if(C != src && insert(C) == -1)
			break


/obj/structure/closet/dirthole/close(mob/living/user)
	if(!opened || !can_close(user))
		return FALSE
	take_contents()
	for(var/mob/A in contents)
		if((A.stat) && (istype(A, /mob/living/carbon/human)))
			var/mob/living/carbon/human/B = A
			B.buried = TRUE
	opened = FALSE
	return TRUE

/obj/structure/closet/dirthole/dump_contents()
	for(var/mob/A in contents)
		if((!A.stat) && (istype(A, /mob/living/carbon/human)))
			var/mob/living/carbon/human/B = A
			B.buried = FALSE
	..()

/obj/structure/closet/dirthole/open(mob/living/user)
	if(opened)
		return
	if(stage == 4)
		stage = 3
		climb_offset = 0
	opened = TRUE
	dump_contents()
	stage_update()
	return 1

/obj/structure/closet/dirthole/proc/stage_update()
	switch(stage)
		if(1, 2, 4)
			can_buckle = FALSE
		if(3)
			can_buckle = TRUE
	update_appearance(UPDATE_ICON | UPDATE_NAME)

/// Proc to update `quality`, should be called when `headstone` or `gravefence` is modified, and other cases where the condition of the grave has changed
/obj/structure/closet/dirthole/proc/update_quality()
    var/corpse_patron
    gravequality = 0
    if(stage != 4) // If not a complete grave, no quality
        return
    if(bonusquality)
        gravequality += bonusquality

    for(var/mob/living/corpse in contents)
        corpse_patron = corpse.patron
    if(headstone)
        var/obj/item/gravedecor/headstone/Head = headstone
        var/heldquality = Head.decorationquality
        for(var/datum/patron/GravePatron in Head.patron)
            if(GravePatron == corpse_patron)
                heldquality += 3
        gravequality += heldquality
    if(gravefence)
        var/obj/item/gravedecor/gravefence/Fence = gravefence
        var/heldquality = Fence.decorationquality
        for(var/datum/patron/GravePatron in Fence.patron)
            if(GravePatron == corpse_patron)
                heldquality += 3
        gravequality += heldquality
    for(var/obj/structure/closet/crate/coffin/coffin in contents)
        gravequality += 2
        if(coffin.consecrated)
            gravequality += 1
    for(var/obj/structure/closet/burial_shroud/shroud in contents)
        gravequality += 1

    return max(gravequality, 10)

/obj/structure/closet/dirthole/update_icon_state()
	. = ..()
	switch(stage)
		if(1)
			icon_state = "hole1"
		if(2)
			icon_state = "hole2"
		if(3)
			icon_state = "grave"
		if(4)
			icon_state = "gravecovered"

/obj/structure/closet/dirthole/update_overlays()
	cut_overlays()
	. = ..()
	if(stage < 3)
		return
	else if(stage == 3)
		. += mutable_appearance(icon, "grave_above", ABOVE_MOB_LAYER)

	// handle gravedecor overlays
	if(headstone)
		. += mutable_appearance('icons/turf/floors.dmi', headstone.icon_state, 2.91)
	if(gravefence)
		. += mutable_appearance('icons/turf/floors.dmi', gravefence.icon_state, 2.9)

	// handle consecrate overlay
	//if(is_consecrated >= CONSECRATED)
		//. += mutable_appearance(icon, "graveconsecrated")

/obj/structure/closet/dirthole/update_name(updates)
	. = ..()
	switch(stage)
		if(1, 2)
			name = "hole"
		if(3)
			name = "pit"
		if(4)
			name = "grave"

/obj/structure/closet/dirthole/post_buckle_mob(mob/living/M)
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/closet/dirthole/post_unbuckle_mob()
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/closet/dirthole/relaymove(mob/user)
	if(user.stat || !isturf(loc) || !isliving(user))
		return
	if(!user.mind?.has_antag_datum(/datum/antagonist/zombie))
		if(message_cooldown <= world.time)
			message_cooldown = world.time + 50
			to_chat(user, "<span class='warning'>I'm trapped!</span>")
		return
	container_resist(user)



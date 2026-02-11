GLOBAL_LIST_EMPTY(last_words)

/mob/living/gib(no_brain, no_organs, no_bodyparts)
	var/prev_lying = lying_angle
	if(stat != DEAD)
		death(TRUE)

	playsound(src, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)

	if(!prev_lying)
		gib_animation()

	spill_embedded_objects()

	spill_organs(no_brain, no_organs, no_bodyparts)

	if(!no_bodyparts)
		spread_bodyparts(no_brain, no_organs)

	spawn_gibs(no_bodyparts)
	qdel(src)

/mob/living/proc/gib_animation()
	return

/mob/living/proc/spawn_gibs()
	new /obj/effect/gibspawner/generic(drop_location(), src)

/mob/living/proc/spill_embedded_objects()
	for(var/obj/item/embedded_item as anything in simple_embedded_objects)
		simple_remove_embedded_object(embedded_item)

/mob/living/proc/spill_organs()
	return

/mob/living/proc/spread_bodyparts()
	return

/mob/living/dust(just_ash, drop_items, force)
	death(TRUE)

	spill_embedded_objects()

	if(drop_items)
		unequip_everything()

	if(buckled)
		buckled.unbuckle_mob(src, force = TRUE)

	dust_animation()
	spawn_dust(just_ash)
	QDEL_IN(src,5) // since this is sometimes called in the middle of movement, allow half a second for movement to finish, ghosting to happen and animation to play. Looks much nicer and doesn't cause multiple runtimes.

/mob/living/proc/dust_animation()
	return

/mob/living/proc/spawn_dust(just_ash = FALSE)
	for(var/i in 1 to 3)
		new /obj/item/fertilizer/ash(loc)


/mob/living/death(gibbed)
	var/was_dead_before = stat == DEAD
	set_stat(DEAD)
	unset_machine()
	timeofdeath = world.time
	tod = station_time_timestamp()

	var/obj/structure/soul/soul = new(get_turf(src))
	soul.init_mana(WEAKREF(src))

	for(var/obj/item/I in contents)
		I.on_mob_death(src, gibbed)
	GLOB.alive_mob_list -= src
	if(!gibbed && !was_dead_before)
		GLOB.dead_mob_list += src

	if(prob(0.1))
		src.playsound_local(src, 'sound/misc/dark_die.ogg', 250)
	else
		src.playsound_local(src, 'sound/misc/deth.ogg', 100)

	set_disgust(0)
	SetSleeping(0)
	reset_perspective(null)
	reload_fullscreen()
	update_mob_action_buttons()
	update_damage_hud()
	update_health_hud()
	stop_pulling()

	to_chat(src, span_green("A bleak afterlife awaits... but the Gods may let you walk again in another shape! Spirit, you must descend in a Journey to the Underworld and wait there for judgment..."))

	. = ..()

	SEND_SIGNAL(src, COMSIG_LIVING_DEATH, gibbed)
	if(client)
		client.move_delay = initial(client.move_delay)
		var/atom/movable/screen/gameover/hog/H = new()
		H.plane = SPLASHSCREEN_PLANE
		client.screen += H
		H.Fade()
		MOBTIMER_SET(src, MT_LASTDIED)
		addtimer(CALLBACK(H, TYPE_PROC_REF(/atom/movable/screen/gameover, Fade), TRUE), 100)
		remove_client_colour(/datum/client_colour/monochrome/death)
		add_client_colour(/datum/client_colour/monochrome/death)
		if(last_words)
			GLOB.last_words |= last_words

	if(lastattacker_weakref)
		var/mob/attacker = lastattacker_weakref.resolve()
		SEND_SIGNAL(attacker, COMSIG_LIVING_COMBAT_KILL, src)

	for(var/datum/soullink/S as anything in ownedSoullinks)
		S.ownerDies(gibbed)
	for(var/datum/soullink/S as anything in sharedSoullinks)
		S.sharerDies(gibbed)

//	for(var/datum/death_tracker/D in target.death_trackers)

	if(!gibbed && !QDELETED(src) && rot_type)
		LoadComponent(rot_type)

	set_typing_indicator(FALSE)

	if (client)
		if (!gibbed)
			var/locale = prepare_deathsight_message()
			for (var/mob/living/player in GLOB.player_list)
				if (player.stat == DEAD || isbrain(player))
					continue
				if (HAS_TRAIT(player, TRAIT_DEATHSIGHT))
					if (HAS_TRAIT(player, TRAIT_CABAL) || istype(player.patron, /datum/patron/inhumen/zizo))
						to_chat(player, span_warning("I feel the faint passage of disjointed life essence as it flees [locale]."))
					else
						to_chat(player, span_warning("Veiled whispers herald the Undermaiden's gaze in my mind's eye as it turns towards [locale] for but a brief, singular moment."))

	return TRUE


/mob/living/proc/prepare_deathsight_message()
	var/area_of_death = lowertext(get_area_name(src))
	var/locale = "a locale wreathed in enigmatic fog"
	switch (area_of_death) // we're deliberately obtuse with this.
		if ("mountains", "mt decapitation", "malum's anvil forest", "malum's anvil under lower caves", "malum's anvil cave building", "malum's anvil lower dungeon", "malum's anvil surface building", "malum's anvil hidden grove", "malum's anvil peak")
			locale = "a twisted tangle of dense rocks and rivers of lava"
		if ("wilderness", "azure basin")
			locale = "somewhere in the wilds"
		if ("the bog", "bog", "dense bog", "latejoin cave")
			locale = "a wretched, fetid bog"
		if ("coast", "coastforest", "river")
			locale = "somewhere betwixt Abyssor's realm and Dendor's bounty"
		if ("indoors", "shop", "physician", "outdoors", "roofs", "manor", "wizard's tower", "garrison","village garrison", "dungeon cell", "baths", "tavern", "basement")
			locale = "the city of [SSmapping.config.map_name] and all its bustling souls"
		if ("sewers")
			locale = "somwhere under the city of [SSmapping.config.map_name] and all its bustling souls"
		if ("church")
			locale = "a hallowed place, sworn to the Ten" // special bit for the church since it's sacred ground

	return locale


/obj/item/signal_horn
	name = "signal horn"
	desc = "Used to sound the alarm."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "signal_horn"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK
	w_class = WEIGHT_CLASS_NORMAL
	grid_height = 32
	grid_width = 64
	COOLDOWN_DECLARE(sound_horn)

/obj/item/signal_horn/attack_self(mob/living/user, list/modifiers)
	. = ..()
	attempt_sound_horn(user)

/obj/item/signal_horn/proc/attempt_sound_horn(mob/living/user)
	if(!COOLDOWN_FINISHED(src, sound_horn))
		to_chat(user, span_warning("[src] is not ready to be used yet!"))
		return
	user.visible_message(span_warning("[user] is about to sound [src]!"))
	if(do_after(user, 1.5 SECONDS))
		sound_horn(user)
		COOLDOWN_START(src, sound_horn, 1 MINUTES)

/obj/item/signal_horn/proc/sound_horn(mob/living/user)
	user.visible_message(span_warning("[user] sounds the alarm!"))
	// New sound made by fem_tanyl
	playsound(src, 'sound/items/signalhorn.ogg', 100, TRUE)
	var/turf/origin_turf = get_turf(src)

	for(var/mob/living/player in GLOB.player_list)
		if(player.stat == DEAD)
			continue
		if(isbrain(player))
			continue
		if(player == user)
			continue

		var/distance = get_dist(player, origin_turf)
		if(distance <= 7)
			player.apply_status_effect(/datum/status_effect/signal_horn, null, user)
			continue
		var/dirtext = " to the "
		var/direction = get_dir(player, origin_turf)
		switch(direction)
			if(NORTH)
				dirtext += "north"
			if(SOUTH)
				dirtext += "south"
			if(EAST)
				dirtext += "east"
			if(WEST)
				dirtext += "west"
			if(NORTHWEST)
				dirtext += "northwest"
			if(NORTHEAST)
				dirtext += "northeast"
			if(SOUTHWEST)
				dirtext += "southwest"
			if(SOUTHEAST)
				dirtext += "southeast"
			else //Where ARE you.
				dirtext = ", although I cannot make out a direction"
		var/disttext
		switch(distance)
			if(0 to 20)
				disttext = " very close"
			if(20 to 40)
				disttext = " close"
			if(40 to 80)
				disttext = ""
			if(80 to 160)
				disttext = " far"
			else
				disttext = " very far"

		//sound played for other players, by fem_tanyl !!!1!!
		player.playsound_local(get_turf(player), 'sound/items/signalhorn.ogg', 35, FALSE, pressure_affected = FALSE)
		to_chat(player, span_warning("I hear the horn alarm somewhere[disttext][dirtext]!"))

#define WARDEN_AMBUSH_MIN 2
#define WARDEN_AMBUSH_MAX 9

/obj/item/signal_horn/ambush
	name = "ambush horn"
	desc = "Used to trigger ambushes from unsavory folks in the wilds."

/obj/item/signal_horn/ambush/examine()
	. = ..()
	. += span_notice("Using the horn will make you stand still and induce several ambushes to happen at once, enabling you to clear out an area. It cannot be used in rapid succession.")
	. += span_notice("Using it will leave you exhausted for a moment. Bring friends!")

/obj/item/signal_horn/ambush/attempt_sound_horn(mob/living/user)
	var/area/AR = get_area(user)
	var/datum/threat_region/TR = SSregionthreat.get_region(AR.threat_region)
	if(!TR || !TR.latent_ambush || TR.fixed_ambush)
		to_chat(user, span_warning("There's no point in sounding the horn here."))
		return
	if(user.get_will_block_ambush())
		to_chat(user, span_warning("This place is too well-lit for enemies to come."))
		return
	if(!user.get_possible_ambush_spawn(min_dist = WARDEN_AMBUSH_MIN, max_dist = WARDEN_AMBUSH_MAX))
		to_chat(user, span_warning("This place is too lightly vegetated for enemies to hide."))
		return
	if(TR && TR.last_induced_ambush_time && (world.time < TR.last_induced_ambush_time + 5 MINUTES))
		to_chat(user, span_warning("Foes have been cleared out here recently, perhaps you should wait a moment before sounding the horn again."))
		return
	user.visible_message(span_userdanger("[user] is about to sound [src]!"))
	user.apply_status_effect(/datum/status_effect/debuff/clickcd, 5 SECONDS) // We don't want them to spam the message.
	if(do_after(user, 30 SECONDS)) // Enough time for any antag to kick or interrupt third party, me think
		TR.last_induced_ambush_time = world.time
		user.Immobilize(30) // A very crude solution to kill any solo gamer
		sound_horn(user)

/obj/item/signal_horn/ambush/sound_horn(mob/living/user)
	. = ..()
	var/random_ambushes = 4 + rand(0,2) // 4 - 6 ambushes
	for(var/i = 0, i < random_ambushes, i++)
		user.consider_ambush(TRUE, TRUE, min_dist = WARDEN_AMBUSH_MIN, max_dist = WARDEN_AMBUSH_MAX)

#undef WARDEN_AMBUSH_MIN
#undef WARDEN_AMBUSH_MAX

/datum/status_effect/signal_horn
	id = "signal horn indicator"
	duration = 2 SECONDS
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = null
	tick_interval = 1
	var/atom/movable/screen/signal_horn/signal_horn_object
	var/atom/target

/datum/status_effect/signal_horn/on_creation(mob/living/new_owner, duration_override, sound_source)
	. = ..()
	if(.)
		target = sound_source
		RegisterSignal(target, COMSIG_QDELETING, PROC_REF(qdel), src)
		tick()

/datum/status_effect/signal_horn/on_apply()
	if(owner.client)
		signal_horn_object = new /atom/movable/screen/signal_horn(src)
		owner.client.screen += signal_horn_object
	tick()
	return ..()

/datum/status_effect/signal_horn/Destroy()
	target = null
	if(owner)
		if(owner.client)
			owner.client.screen -= signal_horn_object
	return ..()

/datum/status_effect/signal_horn/tick()
	var/target_angle = get_angle(owner, target)
	var/matrix/rotation = matrix()
	rotation.Turn(target_angle)
	signal_horn_object.transform = rotation

/atom/movable/screen/signal_horn
	icon = 'icons/effects/indicators.dmi'
	icon_state = "signal_horn_indicator"
	screen_loc = "CENTER:-16,CENTER:-16"
	alpha = 100

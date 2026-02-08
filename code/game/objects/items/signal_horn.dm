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
		RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(qdel), src)
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

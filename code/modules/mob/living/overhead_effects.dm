//By DREAMKEEP, Vide Noir https://github.com/EaglePhntm.
//GRAPHICS & SOUNDS INCLUDED:
//DARKEST DUNGEON (STRESS, RELIEF, AFFLICTION)
/**
 * Show an appearance over the head of this mob.
 *
 * Arguments
 * * icon - icon file to use.
 * * icon_state - icon_state to use.
 * * duration - how long to show the icon for.
 * * layer - layer to use.
 * * public - If True all clients can see the icon.
 * * sound - If set, play this when we show the icon.
 * * can_see_cb - Callback to test if someone can see and hear even if not public.
 */
/mob/living/proc/show_overhead_indicator(icon, icon_state, duration, layer = ABOVE_ALL_MOB_LAYER, plane = FLOAT_PLANE, y_offset = 12, public = FALSE, sound = null, datum/callback/can_see_cb = null)
	if(!icon_exists_or_scream(icon, icon_state))
		return

	var/mutable_appearance/appearance = mutable_appearance(icon, icon_state, layer, plane, appearance_flags = RESET_COLOR)
	appearance.pixel_y = y_offset

	if(public && sound)
		playsound(src, sound, 15, FALSE, extrarange = -1, ignore_walls = FALSE)
	else if(sound)
		playsound_local(src, sound, 15, FALSE)

	if(client)
		flick_overlay(appearance, client, duration)

	for(var/mob/viewer as anything in viewers(src))
		var/client/client = viewer.client
		if(!client)
			continue
		if(public)
			flick_overlay(appearance, client, duration)
		else if(can_see_cb)
			var/can_see = can_see_cb.Invoke(src, viewer)
			if(can_see)
				playsound_local(viewer, sound, 15, FALSE)
				flick_overlay(appearance, client, duration)

/mob/living/carbon/human/show_overhead_indicator(icon, icon_state, duration = 3 SECONDS, layer = ABOVE_ALL_MOB_LAYER, y_offset = 12, public = FALSE, sound = null, datum/callback/can_see_cb = null)
	if(!icon_exists_or_scream(icon, icon_state))
		return

	var/list/offsets

	var/datum/species/species =	dna?.species
	if(species)
		var/use_female_sprites = MALE_SPRITES
		if(species.sexes)
			if(gender == FEMALE && !species.swap_female_clothes || gender == MALE && species.swap_male_clothes)
				use_female_sprites = FEMALE_SPRITES

		if(use_female_sprites)
			offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_f
		else
			offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_m

	var/mutable_appearance/appearance = mutable_appearance(icon, icon_state, layer, appearance_flags = RESET_COLOR)
	appearance.pixel_y = y_offset

	if(length(offsets) && LAZYACCESS(offsets, OFFSET_HEAD))
		appearance.pixel_y += offsets[OFFSET_HEAD][1]
		appearance.pixel_y+= offsets[OFFSET_HEAD][2]

	if(public && sound)
		playsound(src, sound, 15, FALSE, extrarange = -1, ignore_walls = FALSE)
	else if(sound)
		playsound_local(src, sound, 15, FALSE)

	if(client)
		flick_overlay(appearance, client, duration)

	for(var/mob/viewer as anything in viewers(src))
		var/client/client = viewer.client
		if(!client)
			continue
		if(public)
			flick_overlay(appearance, client, duration)
		else if(can_see_cb)
			var/can_see = can_see_cb.Invoke(src, viewer)
			if(can_see)
				viewer.playsound_local(src, sound, 15, FALSE)
				flick_overlay(appearance, client, duration)

// Everything about this makes me sad

/mob/living/carbon/proc/play_stress_indicator()
	if(!COOLDOWN_FINISHED(src, stress_indicator))
		return
	show_overhead_indicator('icons/mob/overhead_effects.dmi', "stress", 2 SECONDS, sound = 'sound/ddstress.ogg', can_see_cb = CALLBACK(src, PROC_REF(is_empath)))
	COOLDOWN_START(src, stress_indicator, 8 SECONDS)

/mob/living/carbon/proc/play_relief_indicator()
	if(!COOLDOWN_FINISHED(src, stress_indicator))
		return
	show_overhead_indicator('icons/mob/overhead_effects.dmi', "relief", 2 SECONDS, sound = 'sound/ddrelief.ogg', can_see_cb = CALLBACK(src, PROC_REF(is_empath)))
	COOLDOWN_START(src, stress_indicator, 8 SECONDS)

/mob/living/carbon/proc/play_mental_break_indicator()
	if(!COOLDOWN_FINISHED(src, stress_indicator))
		return
	show_overhead_indicator('icons/mob/overhead_effects.dmi', "mentalbreak", 3 SECONDS, sound = 'sound/stressaffliction.ogg', can_see_cb = CALLBACK(src, PROC_REF(is_empath)))
	COOLDOWN_START(src, stress_indicator, 8 SECONDS)

/mob/living/carbon/proc/is_empath()
	return HAS_TRAIT(src, TRAIT_EMPATH)

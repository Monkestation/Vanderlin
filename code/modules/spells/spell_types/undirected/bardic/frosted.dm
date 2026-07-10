#define FROST_OVERLAY_COLOR rgb(136, 191, 255)
#define FROST_BURST_DAMAGE 50
#define FROST_BURST_IMMUNITY_DURATION (15 SECONDS)
#define FROST_BURST_IMMUNITY_KEY "frost_burst_immunity"

/// Apply one frost stack to the target. Escalates frosted1 -> frosted2 -> frosted3 -> burst (50 burn, clears frost).
/proc/apply_frost_stack(mob/living/target, stacks = 1)
	if(!isliving(target))
		return
	var/final_tier = 0
	for(var/i in 1 to stacks)
		if(target.has_status_effect(/datum/status_effect/debuff/frosted3))
			// Fourth stack - burst for burn damage and clear all frost
			if(target.mob_timers[FROST_BURST_IMMUNITY_KEY] && world.time < target.mob_timers[FROST_BURST_IMMUNITY_KEY])
				target.apply_status_effect(/datum/status_effect/debuff/frosted3)
				var/remaining = round((target.mob_timers[FROST_BURST_IMMUNITY_KEY] - world.time) / 10)
				target.balloon_alert_to_viewers("<font color='#4cadee'>frost adapted ([remaining]s)</font>")
				final_tier = max(final_tier, 3)
				break
			// Burst
			remove_all_frost_stacks(target)
			target.apply_damage(FROST_BURST_DAMAGE, BURN)
			target.mob_timers[FROST_BURST_IMMUNITY_KEY] = world.time + FROST_BURST_IMMUNITY_DURATION
			target.visible_message(span_danger("The frost on [target] detonates in a flash of ice!"), span_userdanger("The frost bites deep - my body burns with cold!"))
			target.balloon_alert_to_viewers("<font color='#4cadee'>shattered!</font>")
			//playsound(get_turf(target), 'sound/spellbooks/crystal.ogg', 80, TRUE)
			final_tier = 0
			break
		if(target.has_status_effect(/datum/status_effect/debuff/frosted2))
			target.remove_status_effect(/datum/status_effect/debuff/frosted2)
			target.apply_status_effect(/datum/status_effect/debuff/frosted3)
			final_tier = 3
			continue
		if(target.has_status_effect(/datum/status_effect/debuff/frosted1))
			target.remove_status_effect(/datum/status_effect/debuff/frosted1)
			target.apply_status_effect(/datum/status_effect/debuff/frosted2)
			final_tier = 2
			continue
		target.apply_status_effect(/datum/status_effect/debuff/frosted1)
		final_tier = max(final_tier, 1)
	// Single alert for the final tier reached (burst handles its own alert)
	switch(final_tier)
		if(1)
			target.balloon_alert_to_viewers("<font color='#4cadee'>frosted I (-1 spd)!</font>")
		if(2)
			target.balloon_alert_to_viewers("<font color='#4cadee'>frosted II (-2 spd, 1.1x slow)!</font>")
		if(3)
			target.balloon_alert_to_viewers("<font color='#4cadee'>frosted III (-2 spd, 1.2x slow)!</font>")

/// Decrement one frost stack from the target. Used by fire spells.
/// Returns TRUE if a stack was removed.
/proc/remove_frost_stack(mob/living/target)
	if(!isliving(target))
		return FALSE
	if(target.has_status_effect(/datum/status_effect/debuff/frosted3))
		target.remove_status_effect(/datum/status_effect/debuff/frosted3)
		target.apply_status_effect(/datum/status_effect/debuff/frosted2)
		return TRUE
	if(target.has_status_effect(/datum/status_effect/debuff/frosted2))
		target.remove_status_effect(/datum/status_effect/debuff/frosted2)
		target.apply_status_effect(/datum/status_effect/debuff/frosted1)
		return TRUE
	if(target.has_status_effect(/datum/status_effect/debuff/frosted1))
		target.remove_status_effect(/datum/status_effect/debuff/frosted1)
		return TRUE
	return FALSE

/// Check if the target has any frost stacks.
/proc/has_frost_stacks(mob/living/target)
	if(!isliving(target))
		return FALSE
	return target.has_status_effect(/datum/status_effect/debuff/frosted1) || \
		target.has_status_effect(/datum/status_effect/debuff/frosted2) || \
		target.has_status_effect(/datum/status_effect/debuff/frosted3)

/// Returns the current frost stack count (0-3).
/proc/get_frost_stacks(mob/living/target)
	if(!isliving(target))
		return 0
	if(target.has_status_effect(/datum/status_effect/debuff/frosted3))
		return 3
	if(target.has_status_effect(/datum/status_effect/debuff/frosted2))
		return 2
	if(target.has_status_effect(/datum/status_effect/debuff/frosted1))
		return 1
	return 0

/// Remove all frost stacks. Used by fire damage and frost burst to cleanse frost.
/proc/remove_all_frost_stacks(mob/living/target)
	if(!isliving(target))
		return
	target.remove_status_effect(/datum/status_effect/debuff/frosted3)
	target.remove_status_effect(/datum/status_effect/debuff/frosted2)
	target.remove_status_effect(/datum/status_effect/debuff/frosted1)

/datum/status_effect/debuff/frosted1
	id = "frosted1"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/frosted1
	duration = 15 SECONDS
	effectedstats = list(STATKEY_SPD = -1)

/atom/movable/screen/alert/status_effect/debuff/frosted1
	name = "Frosted"
	desc = "A chill seeps into my bones."
	icon_state = "debuff"

/datum/status_effect/debuff/frosted1/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.add_atom_colour(FROST_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)

/datum/status_effect/debuff/frosted1/on_remove()
	var/mob/living/target = owner
	target.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, FROST_OVERLAY_COLOR)
	. = ..()

/datum/status_effect/debuff/frosted2
	id = "frosted2"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/frosted2
	duration = 15 SECONDS
	effectedstats = list(STATKEY_SPD = -2)

/atom/movable/screen/alert/status_effect/debuff/frosted2
	name = "Frosted II"
	desc = "The cold bites deep. My movements are sluggish."
	icon_state = "debuff"

/datum/status_effect/debuff/frosted2/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.add_atom_colour(FROST_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)

/datum/status_effect/debuff/frosted2/on_remove()
	var/mob/living/target = owner
	target.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, FROST_OVERLAY_COLOR)
	. = ..()

/datum/status_effect/debuff/frosted2/nextmove_modifier()
	return 1.1

/datum/status_effect/debuff/frosted3
	id = "frosted3"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/frosted3
	duration = 15 SECONDS
	effectedstats = list(STATKEY_SPD = -2)

/atom/movable/screen/alert/status_effect/debuff/frosted3
	name = "Frosted III"
	desc = "Frozen to the bone. I can barely move."
	icon_state = "debuff"

/datum/status_effect/debuff/frosted3/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.add_atom_colour(FROST_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)

/datum/status_effect/debuff/frosted3/on_remove()
	var/mob/living/target = owner
	target.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, FROST_OVERLAY_COLOR)
	. = ..()

/datum/status_effect/debuff/frosted3/nextmove_modifier()
	return 1.2

/obj/effect/temp_visual/trapice
	icon = 'icons/effects/effects.dmi'
	icon_state = "frost"
	light_outer_range = 2
	light_color = "#4cadee"
	duration = 11

/obj/effect/temp_visual/snap_freeze
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	name = "rippeling arcyne ice"
	desc = "Get out of the way!"
	randomdir = FALSE
	duration = 1 SECONDS

#undef FROST_OVERLAY_COLOR
#undef FROST_BURST_DAMAGE
#undef FROST_BURST_IMMUNITY_DURATION
#undef FROST_BURST_IMMUNITY_KEY

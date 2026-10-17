#define SILENCE_RANGE 3
/datum/action/cooldown/spell/silence_dome
	name = "Silence"
	desc = "Generate a zone of silence preventing all sound."
	button_icon_state = "readomen"
	sound = 'sound/magic/cosmic_expansion.ogg'
	self_cast_possible = FALSE
	spell_flags = SPELL_RITUOS
	required_form = FORM_ARCANE
	required_technique = TECHNIQUE_ALTERATION
	required_level = 4

	invocation = "Be Silent!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 2 SECONDS
	cooldown_time = 3 MINUTES
	spell_cost = 35
	var/duration = 2 MINUTES
	var/obj/effect/silence_dome/dome
	var/datum/proximity_monitor/advanced/silence_field/zone
	var/validation_timer
	var/deactivation_timer

/datum/action/cooldown/spell/silence_dome/cast(mob/living/cast_on)
	. = ..()
	if(dome || zone)
		deactivate_silence(TRUE)

	dome = new(get_turf(cast_on))
	zone = new(get_turf(cast_on), SILENCE_RANGE, FALSE, src)
	// Apply silence to all mobs currently in range
	apply_initial_silence()
	// Start validation timer to check positions periodically - this is really redundant but its useful incases of forceMove
	validation_timer = addtimer(CALLBACK(src, PROC_REF(validate_silence_field)), 1 SECONDS, TIMER_LOOP | TIMER_STOPPABLE)
	deactivation_timer = addtimer(CALLBACK(src, PROC_REF(deactivate_silence)), duration, TIMER_STOPPABLE)

/datum/action/cooldown/spell/silence_dome/proc/deactivate_silence(early = FALSE)
	if(zone)
		QDEL_NULL(zone)
	if(dome)
		QDEL_NULL(dome)
	if(validation_timer)
		deltimer(validation_timer)
		validation_timer = null
	if(early)
		deltimer(deactivation_timer)
		deactivation_timer = null

/datum/action/cooldown/spell/silence_dome/proc/apply_initial_silence()
	if(!owner || !zone || !dome)
		return

	// Find all mobs within range and apply silence
	for(var/mob/living/carbon/human/target in range(SILENCE_RANGE, dome))
		if(should_affect_target(target))
			zone.add_affected_mob(target)

/datum/action/cooldown/spell/silence_dome/proc/validate_silence_field()
	if(!owner || !zone || !dome)
		return

	var/list/current_affected = zone.affected_mobs.Copy()

	// Check each affected mob to see if they're still in range
	for(var/mob/living/carbon/human/target in current_affected)
		if(!target || target.z != dome.z || get_dist(dome, target) > SILENCE_RANGE)
			zone.remove_affected_mob(target)

	// Check for new mobs that entered range
	for(var/mob/living/carbon/human/target in range(SILENCE_RANGE, dome))
		if(should_affect_target(target) && !(target in zone.affected_mobs))
			zone.add_affected_mob(target)

/datum/action/cooldown/spell/silence_dome/proc/should_affect_target(mob/living/carbon/human/target)
	return TRUE

/datum/action/cooldown/spell/silence_dome/proc/apply_silence(mob/living/carbon/human/target)
	if(!should_affect_target(target))
		return
	ADD_TRAIT(target, TRAIT_SILENT_FOOTSTEPS, "silence_dome")
	ADD_TRAIT(target, TRAIT_DEAF, "silence_dome")
	target.apply_status_effect(/datum/status_effect/debuff/silenced/permanent)

/datum/action/cooldown/spell/silence_dome/proc/remove_silence(mob/living/carbon/human/target)
	if(HAS_TRAIT_FROM(target, TRAIT_DEAF, "silence_dome"))
		REMOVE_TRAIT(target, TRAIT_DEAF, "silence_dome")
	if(HAS_TRAIT_FROM(target, TRAIT_SILENT_FOOTSTEPS, "silence_dome"))
		REMOVE_TRAIT(target, TRAIT_SILENT_FOOTSTEPS, "silence_dome")
	target.remove_status_effect(/datum/status_effect/debuff/silenced/permanent)

// Proximity monitor for the silence field
/datum/proximity_monitor/advanced/silence_field
	var/datum/action/cooldown/spell/silence_dome/parent_spell
	var/list/affected_mobs = list()

/datum/proximity_monitor/advanced/silence_field/New(atom/center, range, ignore_if_not_on_turf, datum/action/cooldown/spell/silence_dome/spell)
	parent_spell = spell
	. = ..()

/datum/proximity_monitor/advanced/silence_field/setup_field_turf(turf/target)
	. = ..()
	// Check for any mobs already on this turf
	for(var/mob/living/carbon/human/H in target)
		if(parent_spell.should_affect_target(H))
			add_affected_mob(H)

/datum/proximity_monitor/advanced/silence_field/field_edge_crossed(atom/movable/movable, turf/location, direction)
	. = ..()
	if(istype(movable, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = movable
		if(parent_spell.should_affect_target(H))
			add_affected_mob(H)

/datum/proximity_monitor/advanced/silence_field/field_edge_uncrossed(atom/movable/movable, turf/location, direction)
	. = ..()
	if(istype(movable, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = movable
		remove_affected_mob(H)

/datum/proximity_monitor/advanced/silence_field/proc/add_affected_mob(mob/living/carbon/human/target)
	if(target in affected_mobs)
		return
	affected_mobs |= target
	parent_spell.apply_silence(target)

/datum/proximity_monitor/advanced/silence_field/proc/remove_affected_mob(mob/living/carbon/human/target)
	if(!(target in affected_mobs))
		return
	affected_mobs -= target
	parent_spell.remove_silence(target)

/datum/proximity_monitor/advanced/silence_field/Destroy()
	// Clean up all affected mobs when the field is destroyed
	for(var/mob/living/carbon/human/H in affected_mobs)
		parent_spell.remove_silence(H)
	affected_mobs.Cut()
	parent_spell = null
	return ..()

/obj/effect/silence_dome
	name = "dome of silence"
	icon = 'icons/effects/vampire/224x224.dmi'
	icon_state = "stun_warning"
	color = "#d171dd"
	light_power = 2
	light_outer_range = 5
	light_color = COLOR_PALE_PURPLE_GRAY
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pixel_x = -95
	pixel_y = -95

/obj/effect/silence_dome/ex_act()
	return

#undef SILENCE_RANGE

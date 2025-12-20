//TODO! Implement this into the message and sound system

/datum/action/cooldown/spell/essence/silence
	name = "Silence"
	desc = "Creates a zone of magical silence that muffles all sounds."
	button_icon_state = "silence"
	cast_range = 2
	point_cost = 4
	attunements = list(/datum/attunement/fire)

/datum/action/cooldown/spell/essence/silence/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] creates a zone of absolute silence."))

	new /obj/effect/temp_visual/silence_zone(target_turf)

/obj/effect/temp_visual/silence_zone
	name = "silence zone"
	desc = "An area of magical silence."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-grey"
	alpha = 150
	duration = 30 SECONDS

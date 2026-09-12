/datum/action/cooldown/spell/augment_buff/precognition
	name = "Precognition"
	desc = "Peer a few moments into the future for yourself or an ally, readying them before the moment arrives. Cuts 15 seconds from the remaining cooldown of the target's Defend and Special."
	button_icon_state = "readomen"

	required_form = FORM_ARCANE

	invocation = "Praescientia!"
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 75 SECONDS
	other_cast_cooldown_reduction = 0 // Does not benefit from ally-cast cooldown reduction

/datum/action/cooldown/spell/augment_buff/precognition/cast(atom/cast_on)
	. = ..()
	if(!isliving(cast_on))
		to_chat(owner, span_warning("That is not a valid target!"))
		return FALSE
	var/mob/living/target = cast_on

	var/hastened = FALSE
	hastened |= target.reduce_status_effect_duration(/datum/status_effect/debuff/clashcd)
	hastened |= target.reduce_status_effect_duration(/datum/status_effect/debuff/specialcd)

	var/obj/effect/temp_visual/origin_haste/V = new
	target.vis_contents += V

	if(hastened)
		target.balloon_alert_to_viewers("<font color='#66ffcc'>cooldowns -15s!</font>")
		to_chat(target, span_notice("I glimpse the moments ahead, and ready myself for the next move."))
	else
		to_chat(target, span_notice("I glimpse the moments ahead, but there is nothing left to hasten."))
	return TRUE

/obj/effect/temp_visual/origin_haste
	icon = 'icons/effects/effects.dmi'
	icon_state = "chronofield"
	duration = 10
	layer = ABOVE_MOB_LAYER
	alpha = 200
	color = "#66ffcc"

/obj/effect/temp_visual/origin_haste/Initialize(mapload)
	. = ..()
	transform = matrix()*3
	animate(src, transform = matrix()*0.1, alpha = 0, time = duration, easing = EASE_IN)
	return INITIALIZE_HINT_NORMAL

/obj/effect/temp_visual/origin_haste/Destroy()
	if(ismob(loc))
		var/mob/M = loc
		M.vis_contents -= src
	return ..()

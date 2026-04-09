/datum/action/cooldown/spell/eyebite
	name = "Eyebite"
	desc = "Blind and damage the eyes of a target."
	button_icon_state = "raiseskele"
	sound = 'sound/items/beartrap.ogg'

	attunements = list(
		/datum/attunement/dark = 0.4,
	)

	charge_time = 2 SECONDS
	charge_drain = 1
	cooldown_time = 15 SECONDS
	spell_cost = 30

/datum/action/cooldown/spell/eyebite/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return isliving(cast_on)

/datum/action/cooldown/spell/eyebite/cast(mob/living/cast_on)
	. = ..()
	cast_on.visible_message(
		span_info("A loud crunching sound has come from [cast_on]!"),
		span_userdanger("I feel arcyne teeth biting into my eyes!"),
		span_hear("I hear a loud crunch"),
	)
	cast_on.adjustBruteLoss(30)
	cast_on.adjust_temp_blindness(4 SECONDS)
	cast_on.set_eye_blur_if_lower(20 SECONDS)

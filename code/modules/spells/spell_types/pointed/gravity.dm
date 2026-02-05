/datum/action/cooldown/spell/gravity
	name = "Gravity"
	desc = "Weighten space around someone, crushing them."
	button_icon_state = "gravity"
	sound = 'sound/magic/gravity.ogg'
	self_cast_possible = FALSE
	spell_flags = SPELL_RITUOS
	point_cost = 2
	attunements = list(
		/datum/attunement/dark = 0.6,
	)

	//https://www.youtube.com/watch?v=MfK3Ygb7Jzk
	invocation = "Fall."
	invocation_type = INVOCATION_SHOUT

	charge_time = 2 SECONDS
	cooldown_time = 25 SECONDS
	spell_cost = 35

/datum/action/cooldown/spell/gravity/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return isliving(cast_on)

/datum/action/cooldown/spell/gravity/cast(mob/living/cast_on)
	. = ..()
	new /obj/effect/temp_visual/gravity(get_turf(cast_on))
	if(cast_on.STASTR >= 13)
		cast_on.OffBalance(3 SECONDS)
		cast_on.adjustBruteLoss(15)
		to_chat(cast_on, span_userdanger("You're magically weighed down, but your strength resists!"))
	else
		cast_on.Knockdown(3 SECONDS)
		cast_on.Immobilize(3 SECONDS)
		cast_on.adjustBruteLoss(30)
		to_chat(cast_on, span_userdanger("You're magically weighed down and hit the ground!"))

/obj/effect/temp_visual/gravity
	name = "gravity magic"
	icon = 'icons/effects/effects.dmi'
	icon_state = "hierophant_squares"
	randomdir = FALSE
	duration = 3 SECONDS
	light_power = 1
	light_outer_range = 2
	light_color = COLOR_PALE_PURPLE_GRAY

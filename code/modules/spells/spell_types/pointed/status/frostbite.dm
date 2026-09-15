/datum/action/cooldown/spell/status/frostbite
	name = "Frostbite"
	desc = "Freeze your enemy with an icy blast that does low damage, but reduces the target's Speed for a considerable length of time."
	button_icon_state = "frostbite"
	self_cast_possible = FALSE

	sound = 'sound/magic/whiteflame.ogg'

	required_form = FORM_ICE
	required_technique = TECHNIQUE_ALTERATION

	invocation = "Bite of Frost!!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 3 SECONDS
	charge_drain = 1
	cooldown_time = 25 SECONDS
	spell_cost = 50
	spell_flags = SPELL_RITUOS
	status_effect = /datum/status_effect/debuff/frostbite

/datum/action/cooldown/spell/status/frostbite/cast(mob/living/cast_on)
	. = ..()
	extra_args = list(spell_magnitude_modifier)
	if(iscarbon(cast_on))
		var/mob/living/carbon/C = cast_on
		C.adjustFireLoss(15 * spell_magnitude_modifier)

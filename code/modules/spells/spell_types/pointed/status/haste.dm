/datum/action/cooldown/spell/status/haste
	name = "Haste"
	desc = "Cause a target to be magically hastened."
	button_icon_state = "haste"
	sound = 'sound/magic/haste.ogg'

	required_form = FORM_EARTH

	charge_time = 2 SECONDS
	charge_slowdown = 0.3
	cooldown_time = 3 MINUTES
	spell_cost = 40
	spell_flags = SPELL_RITUOS
	status_effect = /datum/status_effect/buff/haste
	duration_scaling = TRUE
	duration_modification = 30 SECONDS

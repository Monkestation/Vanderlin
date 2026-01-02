/datum/action/cooldown/spell/undirected/touch/darkvision
	name = "Darkvision"
	desc = "Enhance the night vision of a target you touch for half a dae."
	button_icon_state = "darkvision"
	can_cast_on_self = TRUE

	point_cost = 2
	attunements = list(
		/datum/attunement/light = 0.6,
	)
	spell_flags = SPELL_RITUOS
	cooldown_time = 6 MINUTES

	hand_path = /obj/item/melee/touch_attack/darkvision
	draw_message = "I prepare to grant Darkvision."
	drop_message = "I release my arcyne focus."
	charges = 3

/datum/action/cooldown/spell/undirected/touch/darkvision/adjust_hand_charges()
	charges += FLOOR(attuned_strength * 1.5, 1)

/datum/action/cooldown/spell/undirected/touch/darkvision/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return isliving(cast_on)

/datum/action/cooldown/spell/undirected/touch/darkvision/cast_on_hand_hit(obj/item/melee/touch_attack/hand, mob/living/victim, mob/living/carbon/caster, list/modifiers)
	. = ..()
	if(!do_after(caster, 5 SECONDS, victim))
		return FALSE

	var/duration_increase = attuned_strength * 2 MINUTES

	if(victim != caster)
		caster.visible_message("[caster] draws a glyph in the air and touches [victim] with an arcyne focus.")
	else
		caster.visible_message("[caster] draws a glyph in the air and touches themselves with an arcyne focus.")

	victim.apply_status_effect(/datum/status_effect/buff/darkvision, 10 MINUTES + duration_increase)
	return TRUE

/obj/item/melee/touch_attack/darkvision
	name = "\improper arcyne focus"
	desc = "Touch a creature to grant them Darkvision for half a dae."
	color = "#3FBAFD"

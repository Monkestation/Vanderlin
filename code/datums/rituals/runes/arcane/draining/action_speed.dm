/datum/actionspeed_modifier/mana_siphon_haste
	variable = TRUE
	multiplicative_slowdown = -0.3

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/haste
	name = "arcyne haste sigil"
	desc = "A jagged, lightning-etched sigil that floods those bound to it with frenetic arcane energy..."
	color = "#F5D76E"
	invocation = "Kael'veth un'shar!"
	buff = /datum/status_effect/mana_siphon_buff/haste

/datum/status_effect/mana_siphon_buff/haste
	id = "mana_siphon_haste_buff"
	alert_type = /atom/movable/screen/alert/status_effect/mana_siphon_buff/haste

/datum/status_effect/mana_siphon_buff/haste/on_creation(mob/living/afflicted)
	. = ..()
	afflicted.add_or_update_variable_actionspeed_modifier(/datum/actionspeed_modifier/mana_siphon_haste, multiplicative_slowdown = -0.2)
	to_chat(afflicted, span_hierophant_warning("Arcane energy crackles through your limbs, your actions quicken."))

/datum/status_effect/mana_siphon_buff/haste/on_remove()
	. = ..()
	owner.remove_actionspeed_modifier(/datum/actionspeed_modifier/mana_siphon_haste)
	to_chat(owner, span_cultsmall("The frenetic energy leaves you."))

/atom/movable/screen/alert/status_effect/mana_siphon_buff/haste
	name = "Arcyne Haste"
	desc = "You are bound to a haste sigil. While near it, arcane energy quickens your every action."

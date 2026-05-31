/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/experience
	name = "arcyne knowledge sigil"
	desc = "A smooth sigil, it stimulates the mind of those it affects.."
	color = "#63500c"
	invocation = "Near'las nal'see!"
	buff = /datum/status_effect/mana_siphon_buff/experience
	mana_cost = 1

/datum/status_effect/mana_siphon_buff/experience
	id = "mana_siphon_exp_buff"
	alert_type = /atom/movable/screen/alert/status_effect/mana_siphon_buff/experience
	max_range = 8

/datum/status_effect/mana_siphon_buff/experience/on_creation(mob/living/afflicted)
	. = ..()
	ADD_TRAIT(owner, TRAIT_ARCANE_KNOWLEDGE, "[type]")
	to_chat(afflicted, span_hierophant_warning("Arcane energy crackles through your brain, you feel smarter."))

/datum/status_effect/mana_siphon_buff/experience/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_ARCANE_KNOWLEDGE, "[type]")
	to_chat(owner, span_cultsmall("The frenetic energy leaves you."))

/atom/movable/screen/alert/status_effect/mana_siphon_buff/experience
	name = "Arcyne Improvement"
	desc = "You are bound to a knowledge rune, everything feels easier to you."

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/flight
	name = "arcyne flight sigil"
	desc = "A smooth curved sigil, allowing free flight in the area.."
	color = "#63500c"
	invocation = "Kael'veth nal'see!"
	buff = /datum/status_effect/mana_siphon_buff/flight
	mana_cost = 1.2

/datum/status_effect/mana_siphon_buff/flight
	id = "mana_siphon_flight_buff"
	alert_type = /atom/movable/screen/alert/status_effect/mana_siphon_buff/haste
	max_range = 4

/datum/status_effect/mana_siphon_buff/flight/on_creation(mob/living/afflicted)
	. = ..()
	passtable_on(afflicted, "[type]")
	ADD_TRAIT(owner, TRAIT_MOVE_FLYING, "[type]")
	to_chat(afflicted, span_hierophant_warning("Arcane energy crackles through your limbs, you feel weightless."))

/datum/status_effect/mana_siphon_buff/flight/on_remove()
	. = ..()
	passtable_off(owner, "[type]")
	REMOVE_TRAIT(owner, TRAIT_MOVE_FLYING, "[type]")
	to_chat(owner, span_cultsmall("The frenetic energy leaves you."))

/atom/movable/screen/alert/status_effect/mana_siphon_buff/flight
	name = "Arcyne Flight"
	desc = "You are bound to a flight sigil. While near it, arcane energy allows free movement upwards."
